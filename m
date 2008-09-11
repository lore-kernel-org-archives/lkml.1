Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYIKSmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYIKSmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYIKSly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:41:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33202 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbYIKSly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:41:54 -0400
Message-ID: <48C96449.4080704@redhat.com>
Date: Thu, 11 Sep 2008 13:32:41 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
CC: akpm@linux-foundation.org, sct@redhat.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz, jbacik@redhat.com,
       cmm@us.ibm.com, tytso@mit.edu, adilger@clusterfs.com, snitzer@gmail.com,
       tglx@linutronix.de, yumiko.sugita.yf@hitachi.com,
       satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH 1/4] jbd: abort when failed to log metadata buffers
References: <488876D3.80004@hitachi.com> <48887776.4080504@hitachi.com> <48C95867.5080707@redhat.com>
In-Reply-To: <48C95867.5080707@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Hidehiro Kawai wrote:
>> If we failed to write metadata buffers to the journal space and
>> succeeded to write the commit record, stale data can be written
>> back to the filesystem as metadata in the recovery phase.
>>
>> To avoid this, when we failed to write out metadata buffers,
>> abort the journal before writing the commit record.
>>
>> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
>> Acked-by: Jan Kara <jack@suse.cz>
>> ---
>>  fs/jbd/commit.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> Index: linux-2.6.26-rc8-mm1/fs/jbd/commit.c
>> ===================================================================
>> --- linux-2.6.26-rc8-mm1.orig/fs/jbd/commit.c
>> +++ linux-2.6.26-rc8-mm1/fs/jbd/commit.c
>> @@ -762,6 +762,9 @@ wait_for_iobuf:
>>  		/* AKPM: bforget here */
>>  	}
>>  
>> +	if (err)
>> +		journal_abort(journal, err);
>> +
>>  	jbd_debug(3, "JBD: commit phase 6\n");
>>  
>>  	if (journal_write_commit_record(journal, commit_transaction))
> 
> A little late for me to chime in, but why is this a journal_abort() when
> journal aborts before and after this call __journal_abort_hard()?
> 
> I'm just not sure what's different about this one condition that we wish
> to update the error and the superblock here?


I take that back, was looking at an old tree, and Josef pointed out
commit 7a266e75cf5a1efd20d084408a1b7f1a185496dd to me that changes this,
and now it makes much more sense.  :)

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7a266e75cf5a1efd20d084408a1b7f1a185496dd

Thanks,
-Eric
