Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZKKNCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZKKNCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 08:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZKKNCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 08:02:22 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37478 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbZKKNCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 08:02:21 -0500
Date: Wed, 11 Nov 2009 18:32:07 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Message-ID: <20091111130207.GA5676@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <1257694141-5670-6-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257694141-5670-6-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 04:28:59PM +0100, Frederic Weisbecker wrote:

There were a few comments that I posted against version 6 of your
patchset (which happened to cross your version 7 posting...) regarding
the breakpoint interfaces, reservation of register for unpinned events
and such...

By the way, I'm looking at refs/heads/perfevents/hw-breakpoint branch in
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
and hope that's correct/latest?

Some more comments about the ptrace implementation here...


static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
				      unsigned long addr)
{
	struct perf_event *bp;
	struct thread_struct *t = &tsk->thread;

	if (!t->ptrace_bps[nr]) {
		/*
		 * Put stub len and type to register (reserve) an inactive but
		 * correct bp
		 */
		bp = register_user_hw_breakpoint(addr, HW_BREAKPOINT_LEN_1,
						 HW_BREAKPOINT_W,
						 ptrace_triggered, tsk,
						 false);
..
...
}

Given that a register_user_hw_breakpoint() is done at the time of a
write to DR0-DR3, it would needlessly hold onto the debug register until
the corresponding DR7 bit is allocated while using up one 'pinned' debug
slot. It would be prudent to postpone the breakpoint registration till
DR7 is changed to activate it.

static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
{
..
...
		/*
		 * We shoud have at least an inactive breakpoint at this
		 * slot. It means the user is writing dr7 without having
		 * written the address register first
		 */
		if (!bp) {
			rc = -EINVAL;
			break;
		}

I was just about confused...thinking that the above condition would
become true during second_pass, but alas it turns out that you restore 
"thread->ptrace_bps[i] = bp" again later.

		rc = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
		if (rc)
			break;

		/*
		 * This is a temporary thing as bp is unregistered/registered
		 * to simulate modification
		 */
		bp = modify_user_hw_breakpoint(bp, bp->attr.bp_addr, gen_len,
					       gen_type, bp->callback,
					       tsk, true);

modify_user_hw_breakpoint() is called twice (once per pass) and in its
current implementation, it would leave open a window for register
grabbing on two occasions. Another reason to change its implementation
soon...

		thread->ptrace_bps[i] = NULL;

Why not remove this line from here...

		if (!bp) { /* incorrect bp, or we have a bug in bp API */
			rc = -EINVAL;
			break;
		}
		if (IS_ERR(bp)) {
			rc = PTR_ERR(bp);
			bp = NULL;
			break;
		}
		thread->ptrace_bps[i] = bp;

...and put it here inside a condition "if (second_pass)"?

	}
	/*
	 * Make a second pass to free the remaining unused breakpoints
	 * or to restore the original breakpoints if an error occurred.
	 */
	if (!second_pass) {
		second_pass = 1;
		if (rc < 0) {
			orig_ret = rc;
			data = old_dr7;
		}
		goto restore;
	}
	return ((orig_ret < 0) ? orig_ret : rc);
}

Thanks,
K.Prasad

