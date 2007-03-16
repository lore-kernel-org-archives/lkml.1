Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbXCPTX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbXCPTX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbXCPTX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:23:28 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57009 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbXCPTX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:23:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ian Kent <raven@themaw.net>
Cc: Cedric Le Goater <clg@fr.ibm.com>, sukadev@us.ibm.com,
       Andrew Morton <akpm@osdl.org>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Herbert Poetzl <herbert@13thfloor.at>,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
References: <20070313045100.GC8993@us.ibm.com>
	<Pine.LNX.4.64.0703161300520.4188@raven.themaw.net>
	<m1ird1o243.fsf@ebiederm.dsl.xmission.com>
	<1174055467.3397.17.camel@raven.themaw.net>
	<45FAAD4F.4000204@fr.ibm.com>
	<1174063618.3397.58.camel@raven.themaw.net>
Date: Fri, 16 Mar 2007 13:21:51 -0600
In-Reply-To: <1174063618.3397.58.camel@raven.themaw.net> (Ian Kent's message
	of "Sat, 17 Mar 2007 01:46:58 +0900")
Message-ID: <m1hcslm1tc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> On Fri, 2007-03-16 at 15:44 +0100, Cedric Le Goater wrote:
>> > How about you send over the autofs4 bit and I'll have a look (the autofs
>> > patch looked fine). That would save me a bit of time and if there are
>> > any changes needed I can send an updated patch for you guys to review. I
>> > don't think autofs4 uses pids differently, in principle, than autofs so
>> > it "should" be straight forward.
>> 
>> Here's the latest.
>
> That looks OK to me, assuming the "find_get_pid" and friends do what
> they suggest, but I'll give it a closer look tomorrow.
>
> A ref count is used here, what affect does that have on a thread (or
> process) that may go away (or be summarily killed) without umounting the
> mount?

Nothing.  

The primary advantage is that you are pid wrap around safe as the struct
pid will never point to another process after one of those events occurs.

struct pid is a very small structure so not freeing it when the process
it originally referred to goes away is no big deal.  Although not leaking
when you stop using it is still important.

The other big use of struct pid is that to get the user space pid value
you call pid_nr().  Depending on the pid namespace of the caller the return
value of pid_nr() can be different.  So when you store a pid or pass a pid
between processes that should be done by passing a struct pid because those
processes could be in different pid namespaces.

>> Index: 2.6.20/fs/autofs4/waitq.c
>> ===================================================================
>> --- 2.6.20.orig/fs/autofs4/waitq.c
>> +++ 2.6.20/fs/autofs4/waitq.c
>> @@ -292,8 +292,8 @@ int autofs4_wait(struct autofs_sb_info *
>>  		wq->ino = autofs4_get_ino(sbi);
>>  		wq->uid = current->uid;
>>  		wq->gid = current->gid;
>> -		wq->pid = current->pid;
>> -		wq->tgid = current->tgid;
>> +		wq->pid = pid_nr(task_pid(current));
>> +		wq->tgid = pid_nr(task_tgid(current));
>>  		wq->status = -EINTR; /* Status return if interrupted */
>>  		atomic_set(&wq->wait_ctr, 2);
>>  		mutex_unlock(&sbi->wq_mutex);

I have a concern with this bit as I my quick review said the wait queue
persists, and if so we should be cache the struct pid pointer, not the
pid_t value.  Heck the whol pid_nr(task_xxx(current)) idiom I find very
suspicious.

Eric

