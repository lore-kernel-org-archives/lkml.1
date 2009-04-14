Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZDNQsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZDNQsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZDNQr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:47:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51326 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZDNQr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:47:58 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Zach Brown <zach.brown@oracle.com>,
       Andy Grover <andy.grover@oracle.com>
Subject: Re: [RFC][PATCH v3 2/6] mm, directio: fix fork vs direct-io race (read(2) side IOW gup(write) side)
References: <20090414151204.C647.A69D9226@jp.fujitsu.com>
	<20090414151652.C64D.A69D9226@jp.fujitsu.com>
	<20090414152500.C65F.A69D9226@jp.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 14 Apr 2009 12:45:41 -0400
In-Reply-To: <20090414152500.C65F.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's
	message of "Tue, 14 Apr 2009 15:25:52 +0900 (JST)")
Message-ID: <x49ab6jyyiy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

> Oops, I forgot some cc. resend it.
>
>> Subject: [PATCH] mm, directio: fix fork vs direct-io race
>> 
>> 
>> ChangeLog:
>> V2 -> V3
>>    o remove early decow logic
>> 
>> V1 -> V2
>>    o add dio+aio logic
>> 

[snip test programs]

>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Sugessted-by: Linus Torvalds <torvalds@osdl.org>
>> Cc: Hugh Dickins <hugh@veritas.com>
>> Cc: Andrew Morton <akpm@osdl.org>
>> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Zach Brown <zach.brown@oracle.com>
>> Cc: Andy Grover <andy.grover@oracle.com>
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> ---
>>  fs/direct-io.c            |   16 ++++++++++++++++
>>  include/linux/init_task.h |    1 +
>>  include/linux/mm_types.h  |    6 ++++++
>>  kernel/fork.c             |    3 +++
>>  4 files changed, 26 insertions(+)
>> 
>> Index: b/fs/direct-io.c
>> ===================================================================
>> --- a/fs/direct-io.c	2009-04-13 00:24:01.000000000 +0900
>> +++ b/fs/direct-io.c	2009-04-13 01:36:37.000000000 +0900
>> @@ -131,6 +131,9 @@ struct dio {
>>  	int is_async;			/* is IO async ? */
>>  	int io_error;			/* IO error in completion path */
>>  	ssize_t result;                 /* IO result */
>> +
>> +	/* fork exclusive stuff */
>> +	struct mm_struct *mm;
>>  };
>>  
>>  /*
>> @@ -244,6 +247,12 @@ static int dio_complete(struct dio *dio,
>>  		/* lockdep: non-owner release */
>>  		up_read_non_owner(&dio->inode->i_alloc_sem);
>>  
>> +	if (dio->rw == READ) {
>> +		BUG_ON(!dio->mm);
>> +		up_read_non_owner(&dio->mm->mm_pinned_sem);
>> +		mmdrop(dio->mm);
>> +	}
>> +
>>  	if (ret == 0)
>>  		ret = dio->page_errors;
>>  	if (ret == 0)
>> @@ -942,6 +951,7 @@ direct_io_worker(int rw, struct kiocb *i
>>  	ssize_t ret = 0;
>>  	ssize_t ret2;
>>  	size_t bytes;
>> +	struct mm_struct *mm;
>>  
>>  	dio->inode = inode;
>>  	dio->rw = rw;
>> @@ -960,6 +970,12 @@ direct_io_worker(int rw, struct kiocb *i
>>  	spin_lock_init(&dio->bio_lock);
>>  	dio->refcount = 1;
>>  
>> +	if (rw == READ) {
>> +		mm = dio->mm = current->mm;
>> +		atomic_inc(&mm->mm_count);
>> +		down_read_non_owner(&mm->mm_pinned_sem);
>> +	}
>> +

So, if you're continuously submitting async read I/O, you will starve
out the fork() call indefinitely.  I agree that you want to allow
multiple O_DIRECT I/Os to go on at once, but I'm not sure this is the
right way forward.

I have to weigh in and say I much prefer the patches posted by Nick and
Andrea.  They were much more contained and had negligible performance
impact.

Have you done any performance measurements on this patch series?

Cheers,
Jeff
