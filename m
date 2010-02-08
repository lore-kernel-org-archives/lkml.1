Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0BHRI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 12:08:28 -0500
Received: from www.tglx.de ([62.245.132.106]:32795 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab0BHRIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:08:25 -0500
Date: Mon, 8 Feb 2010 18:07:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Update comment on find_task_by_pid_ns
In-Reply-To: <20100208132101.GA7129@redhat.com>
Message-ID: <alpine.LFD.2.00.1002081802510.2811@localhost.localdomain>
References: <20091210001308.247025548@linutronix.de> <20091210004703.029784964@linutronix.de> <20091210142036.GA8226@redhat.com> <200912110008.BEJ00511.FVOJLtSMOFHOQF@I-love.SAKURA.ne.jp> <alpine.LFD.2.00.0912102214180.3089@localhost.localdomain>
 <201002082130.JDC57339.OHOVJFQtFSLFMO@I-love.SAKURA.ne.jp> <20100208132101.GA7129@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Oleg Nesterov wrote:

> On 02/08, Tetsuo Handa wrote:
> >
> > [PATCH] Update comment on find_task_by_pid_ns
> >
> > Caller of find_task_by_vpid() and find_task_by_pid_ns() needs to call
> > rcu_read_lock() rather than read_lock(&tasklist_lock) because find_pid_ns()
> > uses RCU primitives but spinlock does not prevent RCU callback if preemptive
> > RCU ( CONFIG_TREE_PREEMPT_RCU ) is enabled.
> 
> I agree with the patch, but the changelog looks a bit confusing to me.
> Perhaps this is just me, though.
> 
> tasklist does protect the task and its pid, it can't go away. The problem
> is that find_pid_ns() itself is unsafe without rcu lock, it can race with
> copy_process()->free_pid(any_pid).
> 
> IOW, if we change copy_process()
> 
> 	--- kernel/fork.c
> 	+++ kernel/fork.c
> 	@@ -1304,8 +1304,11 @@ static struct task_struct *copy_process(
> 		return p;
> 	 
> 	 bad_fork_free_pid:
> 	-	if (pid != &init_struct_pid)
> 	+	if (pid != &init_struct_pid) {
> 	+		read_lock(&tasklist_lock);
> 			free_pid(pid);
> 	+		read_unlock(&tasklist_lock);
> 	+	}
> 	 bad_fork_cleanup_io:
> 		if (p->io_context)
> 			exit_io_context(p);
> 
> then find_task_by_pid_ns/etc could be used under tasklist safely even
> with PREEMPT_RCU.

We try to get rid of the read_lock sites of tasklist_lock, so please
let's not think about adding more :)
 
Thanks,

	tglx
