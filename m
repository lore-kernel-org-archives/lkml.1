Return-Path: <linux-kernel-owner+w=401wt.eu-S933196AbYEUDAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbYEUDAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760104AbYEUDAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:00:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40354 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760049AbYEUDAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:00:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <47E87F2A.2040303@bk.jp.nec.com> <20080325135645.GA96@tv-sign.ru>
	<48337F5C.2040601@bk.jp.nec.com>
Date: Tue, 20 May 2008 19:53:29 -0700
In-Reply-To: <48337F5C.2040601@bk.jp.nec.com> (Atsushi Tsuji's message of
	"Wed, 21 May 2008 10:48:12 +0900")
Message-ID: <m1d4ng74gm.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0044]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kill_something_info: don't take tasklist_lock for pid==-1 case
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Tsuji <a-tsuji@bk.jp.nec.com> writes:

> Sorry for late reply and thank you for your comment. I understood the
> mechanism that kill(-1, SIGKILL) can miss the tasks forked by init
> (and the thread group of the current process, because we don't also
> send the signal to them). If kill(-1, SIGKILL) finish before the
> forking init process does list_add_tail_rcu(p->tasks) in
> copy_process(), the process forked by init appears on the ->tasks list
> after that.  Is that right?

No because of this from fork.c:copy_process()
       /*
         * Process group and session signals need to be delivered to just the
         * parent before the fork or both the parent and the child after the
         * fork. Restart if a signal comes in before we add the new process to
         * it's process group.
         * A fatal signal pending means that current will exit, so the new
         * thread can't slip out of an OOM kill (or normal SIGKILL).
         */
        recalc_sigpending();
        if (signal_pending(current)) {
                spin_unlock(&current->sighand->siglock);
                write_unlock_irq(&tasklist_lock);
                retval = -ERESTARTNOINTR;
                goto bad_fork_free_pid;
        }

We closed that whole a while ago, and in doing so reviewed the semantics
and verify that the behavior is required.
>
> Now, I noticed the important problem. I found the tasklist lock in
> kill_something_info() can cause stall when some processes execute
> kill(-1,SIGCONT) concurrently. It can happen even if a system has
> only 4 CPUs (and even if a user is not privileged (not root)).  This is
> because the writer cannot take the tasklist lock when a lot of readers
> exist and keep holding it.
>
> This allows a local DoS. So we have to avoid that stall. The
> conversion from the tasklist lock to rcu_read_lock() can solve this
> problem. I think my patch doesn't make the new problem because the
> problem that kill can miss the tasks have originally occurred without
> my one. If there is no problem, could you ack it?

There are problems.  It would be nice to avoid the local DOS.  How is
a good question, given the atomic definition of signal delivery.

Eric
