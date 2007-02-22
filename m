Return-Path: <linux-kernel-owner+w=401wt.eu-S1751832AbXBVUPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbXBVUPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbXBVUPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:15:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbXBVUPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:15:12 -0500
Message-ID: <45DDF9C1.4090003@redhat.com>
Date: Thu, 22 Feb 2007 15:14:57 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update ctime and mtime for mmaped write
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu> <20070221202615.a0a167f4.akpm@linux-foundation.org> <E1HK8hU-0005Mq-00@dorka.pomaz.szeredi.hu> <45DDD55F.4060106@redhat.com> <E1HKIN1-0006RX-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1HKIN1-0006RX-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>>>> Why is the flag checked in __fput()?
>>>>     
>>>>         
>>> It's because of this bit in the standard:
>>>
>>>     If there is no such call and if the underlying file is modified
>>>     as a result of a write reference, then these fields shall be
>>>     marked for update at some time after the write reference.
>>>
>>> It could be done in munmap/mremap, but it seemed more difficult to
>>> track down all the places where the vma is removed.  But yes, that may
>>> be a nicer solution.
>>>       
>> It seems to me that, with this support, a file, which is mmap'd,
>> modified, but never msync'd or munmap'd, will never get its mtime
>> updated.  Or did I miss that?
>>
>> I also don't see how an mmap'd block device will get its mtime
>> updated either.
>>     
>
> __fput() will be called when there are no more references to 'file',
> then it will update the time if the flag is set.  This applies to
> regular files as well as devices.
>
>   

I suspect that you will find that, for a block device, the wrong inode
gets updated.  That's where the bd_inode_update_time() portion of my
proposed patch came from.

> But I've moved the check from __fput to remove_vma() in the next
> revision of the patch, which would give slightly nicer semantics, and
> be equally conforming.

This still does not address the situation where a file is 'permanently'
mmap'd, does it?

    Thanx...

       ps
