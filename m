Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZCTN4C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZCTN4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:56:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbZCTNzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:55:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33892 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbZCTNzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:55:49 -0400
Date: Fri, 20 Mar 2009 14:51:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, peterz@infradead.org, efault@gmx.de,
       rjw@sisk.pl, jdike@addtoit.com, mingo@elte.hu,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] fix uml slowness caused by ptrace preemption bug on
	host
Message-ID: <20090320135147.GA20965@redhat.com>
References: <E1LkQeU-00020Z-Be@pomaz-ex.szeredi.hu> <20090319233311.8B26BFC381@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319233311.8B26BFC381@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Roland McGrath wrote:
>
> I'm no scheduler expert and I don't know whether the exact placement in
> your change is the optimal one.

Agreed, can't we do a bit more simple patch?

	--- kernel/signal.c
	+++ kernel/signal.c
	@@ -1572,8 +1572,10 @@ static void ptrace_stop(int exit_code, i
		spin_unlock_irq(&current->sighand->siglock);
		read_lock(&tasklist_lock);
		if (may_ptrace_stop()) {
	+		preempt_disable();
			do_notify_parent_cldstop(current, CLD_TRAPPED);
			read_unlock(&tasklist_lock);
	+		preempt_enable_no_resched();
			schedule();
		} else {
			/*

Yes, the task can be preempted right after spin_unlock(->siglock), but
this is unlikely. We need the "synchronous" wakeup, and this patch helps
as well.



Actually, I don't know which ptrace requests really need to make sure
the tracee was deactivated. Perhaps they can call wait_task_inactive()
themselves? I guess this is bad idea, but most of requests definitely
do not need wait_task_inactive().

Oleg.

