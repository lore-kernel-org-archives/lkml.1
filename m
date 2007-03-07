Return-Path: <linux-kernel-owner+w=401wt.eu-S2992759AbXCGWsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992759AbXCGWsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992743AbXCGWs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:48:26 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:51405 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992727AbXCGWsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:48:23 -0500
In-Reply-To: <20070307141422.25ba2730.akpm@linux-foundation.org>
References: <45EC27E5.20006@linux.intel.com> <20070307141422.25ba2730.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A5667440-009D-4ACB-9EA9-7462341DD704@zabbo.net>
Cc: Leonid Ananiev <leonid.i.ananiev@intel.com>,
       Leonid Ananiev <leonid.i.ananiev@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Chris Mason <chris.mason@oracle.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH 1/3] aio: fix oops because of extra IO control block freeing.
Date: Wed, 7 Mar 2007 14:48:19 -0800
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 7, 2007, at 2:14 PM, Andrew Morton wrote:

> On Mon, 05 Mar 2007 17:23:33 +0300
> Leonid Ananiev <leonid.i.ananiev@linux.intel.com> wrote:
>
>>  From Leonid Ananiev
>>
>> The patch fixes oops because of extra IO control block freeing.
>> IO is retried if page could not be invalidated.

This patch is incorrect and shouldn't be merged.

>>
>> Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>
>>
>> The patch fixes oops "Kernel BUG at fs/aio.c:509" archived at
>> http://lkml.org/lkml/2007/2/8/337
>> The number of IO control block (iocb)users < 0.
>> If page could not be invalidated by invalidate_inode_pages2_range()
>> than EIO is returned. It happens if journal_try_to_free_buffers()  
>> fails
>> to drop_buffers().
>> This EIO is not differing from real IO competition with EIO and
>> aio_complete() is called.

(I'm going to read this as "This EIO is misinterpreted as real IO  
completion with -EIO and aio_complete() is called.")

>> Later aio_complete() is called from dio_bio_end_aio() and frees iocb
>> once more.

This analysis is correct.  Nothing can clobber -EIOCBQUEUED as it is  
returned up from fs/direct-io.c to fs/aio.c.  This -EIO from  
invalidation is one of the two places that currently break this rule.

The fix I had hoped for, invalidating down in fs/direct-io.c before  
returning -EIOCBQUEUED, doesn't work because it ends up getting the  
ordering between the journal lock and the page lock backwards.   
Sigh.  (note to self: help lockdep warn us about that ordering)

>> After patch generic_file_direct_IO() sets PgBusy flag in iocb
>> if page could not be invalidated. iocb is retried after IO  
>> competition.
>> The process is waked up if IO is SYNC else iocb is kicked.
>> The lines ___if (ret != -EIOCBRETRY)___ is deleted because
>> nothing set to EIOCBRETRY.

True, but this is gratuitously cruel to external users of - 
EIOCBRETRY.  Silently breaking them doesn't sound like a great plan.   
If we really decide to remove EIOCBRETRY support we'd get rid of all  
the retry infrastructure and remove the EIOCBRETRY errno so their  
builds failed.  That's a separate issue that shouldn't be confused  
with this EIOCBQUEUED clobbering.  Just removing some pieces of the  
infrastructure willy-nilly isn't acceptable.

>
> Please copy linux-aio@kvack.org on AIO patches.
>
>> Next patches 2/3 and 3/3 do cleanup only.
>
> I cannot find those patches.

Me either.  I was waiting for them to arrive before responding.

>> diff -upr linux-2.6.20/mm/filemap.c linux-2.6.20-aio2/mm/filemap.c
>> --- linux-2.6.20/mm/filemap.c	2007-02-04 21:44:54.000000000 +0300
>> +++ linux-2.6.20-aio2/mm/filemap.c	2007-03-04 21:46:10.000000000  
>> +0300
>> @@ -2413,10 +2413,9 @@ generic_file_direct_IO(int rw, struct ki
>>   		if (rw == WRITE && mapping->nrpages) {
>>   			pgoff_t end = (offset + write_len - 1)
>>   						>> PAGE_CACHE_SHIFT;
>> -			int err = invalidate_inode_pages2_range(mapping,
>> -					offset >> PAGE_CACHE_SHIFT, end);
>> -			if (err)
>> -				retval = err;
>> +			if (invalidate_inode_pages2_range(mapping,
>> +					offset >> PAGE_CACHE_SHIFT, end))
>> +				kiocbSetPgBusy(iocb);

There are two problems behind this bug:

- ext3_releasepage() returns failure if it races with kjournald  
holding a reference while it waits for a transaction to commit.

- generic_file_direct_IO() causes an oops if it clobbers -EIOCBQUEUED  
with the return code from invalidate_inode_pages2_range()..- 
 >releasepage().

This fix makes the incorrect assertion that *any* failure from  
invalidate_inode_pages2_range(), which might not have anything to do  
with this race you're currently seeing, is transitory and should  
trigger a retry.  That's wrong, it should be returning the error.

Now, getting ext3_releasepage() to not fail if this race hits to  
begin with is another story.  Chris has some ideas about reworking  
the page laundering helper to make that more reliable.

- z
