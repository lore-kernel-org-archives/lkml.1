Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZKQBbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZKQBbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 20:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbZKQBbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 20:31:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:51716 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbZKQBbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 20:31:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eRdLq2TLE4+qgspPvtK8XlwQtY1II1/3YJPBxD18IUbode/61JFkwvjYS7WcDV7X6y
         XX1Dd6N7sd/+DejoQzUNqc88PaSlQpoQdI4p2JqpIKUvGD/RTHpve2l685VYzd8HbMbH
         o8/MjREOVQ65IqTWeDJznj5Iv3xvORMRie5+Q=
Date: Tue, 17 Nov 2009 02:31:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 5/7 v6] hw-breakpoints: Rewrite the hw-breakpoints
	layer on top of perf events
Message-ID: <20091117013135.GE5293@nowhere>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <1257694141-5670-6-git-send-email-fweisbec@gmail.com> <20091111130207.GA5676@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111130207.GA5676@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 06:32:07PM +0530, K.Prasad wrote:
> On Sun, Nov 08, 2009 at 04:28:59PM +0100, Frederic Weisbecker wrote:
> 
> There were a few comments that I posted against version 6 of your
> patchset (which happened to cross your version 7 posting...) regarding
> the breakpoint interfaces, reservation of register for unpinned events
> and such...



Yep, sorry I replied a bit late.

 
> By the way, I'm looking at refs/heads/perfevents/hw-breakpoint branch in
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> and hope that's correct/latest?
> 
> Some more comments about the ptrace implementation here...
> 
> 
> static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
> 				      unsigned long addr)
> {
> 	struct perf_event *bp;
> 	struct thread_struct *t = &tsk->thread;
> 
> 	if (!t->ptrace_bps[nr]) {
> 		/*
> 		 * Put stub len and type to register (reserve) an inactive but
> 		 * correct bp
> 		 */
> 		bp = register_user_hw_breakpoint(addr, HW_BREAKPOINT_LEN_1,
> 						 HW_BREAKPOINT_W,
> 						 ptrace_triggered, tsk,
> 						 false);
> ..
> ...
> }
> 
> Given that a register_user_hw_breakpoint() is done at the time of a
> write to DR0-DR3, it would needlessly hold onto the debug register until
> the corresponding DR7 bit is allocated while using up one 'pinned' debug
> slot. It would be prudent to postpone the breakpoint registration till
> DR7 is changed to activate it.



We register it but don't activate it so that we reserve a slot for later.
But that may be useless actually. If we don't do that and later gdb fails
to activate it trhough dr7 because there are concurrent users,
it will just report the returned error.

So I guess I should probably drop this logic.


> static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
> {
> ..
> ...
> 		/*
> 		 * We shoud have at least an inactive breakpoint at this
> 		 * slot. It means the user is writing dr7 without having
> 		 * written the address register first
> 		 */
> 		if (!bp) {
> 			rc = -EINVAL;
> 			break;
> 		}
> 
> I was just about confused...thinking that the above condition would
> become true during second_pass, but alas it turns out that you restore 
> "thread->ptrace_bps[i] = bp" again later.


Yeah, is it a problem?


> 		rc = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
> 		if (rc)
> 			break;
> 
> 		/*
> 		 * This is a temporary thing as bp is unregistered/registered
> 		 * to simulate modification
> 		 */
> 		bp = modify_user_hw_breakpoint(bp, bp->attr.bp_addr, gen_len,
> 					       gen_type, bp->callback,
> 					       tsk, true);
> 
> modify_user_hw_breakpoint() is called twice (once per pass) and in its
> current implementation, it would leave open a window for register
> grabbing on two occasions. Another reason to change its implementation
> soon...



Yeah agreed.



> 
> 		thread->ptrace_bps[i] = NULL;
> 
> Why not remove this line from here...
> 
> 		if (!bp) { /* incorrect bp, or we have a bug in bp API */
> 			rc = -EINVAL;
> 			break;
> 		}
> 		if (IS_ERR(bp)) {
> 			rc = PTR_ERR(bp);
> 			bp = NULL;
> 			break;
> 		}
> 		thread->ptrace_bps[i] = bp;
> 
> ...and put it here inside a condition "if (second_pass)"?



Yeah the whole needs a refactoring anyway.
We should have an array of arch breakpoint structure per thread
and a pointer to a perf event. I think this will simplify the whole,
as we don't need the temporary breakpoint trick.

Or something like that. I'll have a stab at it.

Thanks.

