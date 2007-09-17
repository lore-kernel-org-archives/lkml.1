Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbXIQRTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbXIQRTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbXIQRT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:19:26 -0400
Received: from mail.ccur.com ([66.10.65.12]:12315 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbXIQRTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:19:24 -0400
Message-ID: <46EEB715.7060509@ccur.com>
Date: Mon, 17 Sep 2007 13:19:17 -0400
From: John Blackwood <john.blackwood@ccur.com>
Reply-To: john.blackwood@ccur.com
Organization: Concurrent Computer Corporation
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH] [WORKAROUND] CONFIG_PREEMPT_RT and ib_umad_close()
 issue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2007 17:20:00.0756 (UTC) FILETIME=[FA6CFB40:01C7F94E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Subject: Re: [ofa-general] [PATCH] [WORKAROUND] CONFIG_PREEMPT_RT and 
ib_umad_close() issue
 > From: Roland Dreier <rdreier@cisco.com>
 > Date: Mon, 17 Sep 2007 08:56:01 -0700
 > To: John Blackwood <john.blackwood@ccur.com>
 > CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
general@lists.openfabrics.org, Sven-Thorsten Dietrich <sdietrich@novell.com>
 >
 >  > When using OFED-1.2.5 based infiniband kernel modules on 2.6.22 based
 >  > kernels with the Ingo Molnar CONFIG_PREEMPT_RT applied, then commands
 >  > such as ibnetdiscvoer, smpquery, sminfo, etc. will hang.  The problem
 >  > is with the downgrade_write() rw semaphore usage in the
 >  > ib_umad_close() routine.
 >
 > Can you give a few more details on how PREEMPT_RT changes locking
 > rules (or just exposes existing bugs maybe?) so that the
 > downgrade_write() causes the issue?  I would like to fix this cleanly
 > but I don't really understand what the problem is.
 >
 >  - R.


Hi Roland,

Thanks for your interest in this matter.

I'm not one of the preempt rt experts, so others may want to speak up ...
(thanks Daniel...)

But basically, with CONFIG_PREEMPT_RT enabled, the lock points, such as
aqcuiring a spinlock, potentially become places where the current task
may be context switched out / preempted.

Therefore, when a call is made to lock a spinlock for example, the
caller should not currently have irqs disabled, or preemption disabled,
since a context switch may occur.


I believe that in the case of rw_semaphores, the comments
in include/linux/rt_lock.h with the rt preempt patch applied say:

/*
  * RW-semaphores are a spinlock plus a reader-depth count.
  *
  * Note that the semantics are different from the usual
  * Linux rw-sems, in PREEMPT_RT mode we do not allow
  * multiple readers to hold the lock at once, we only allow
  * a read-lock owner to read-lock recursively. This is
  * better for latency, makes the implementation inherently
  * fair and makes it simpler as well:
  */


So I believe that a read lock on a rw_semaphore is just as
exclusive as the old write lock, except that the read locks
may nest.

And with the preempt patch enabled, the downgrade_write() becomes:

void fastcall rt_downgrade_write(struct rw_semaphore *rwsem)
{
         BUG();
}
EXPORT_SYMBOL(rt_downgrade_write);




So I think code such as:

ib_umad_close()
{
	...
	down_write(&file->port->mutex);
	...  do exclusive stuff
	downgrade_write(&file->port->mutex);
	...  do potentially recursive stuff
	up_read(&file->port->mutex);
	...
}

Could probably become (only when CONFIG_PREEMPT_RT is enabled):

ib_umad_close()
{
	...
	down_read(&file->port->mutex);
	...  do exclusive stuff
	...  do potentially recursive stuff
	up_read(&file->port->mutex);
	...
}

since the down_read will not allow other readers at the same time,
but will allow nesting.


I'm not aware of any tools that find these issues, other than
just running through the code.

I do know that Ingo's preempt rt patch can be found at
http://www.kernel.org/pub/linux/kernel/projects/rt
and applied to an infiniband kernel.

If you enabled CONFIG_PREEMPT_RT, and maybe also enable
parameters such as
CONFIG_DEBUG_PREEMPT, CONFIG_DEBUG_SPINLOCK, etc. you should
see the issue with something like a ibnetdiscover invocation.


Thanks.
