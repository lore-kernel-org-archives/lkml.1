Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbZKLEZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbZKLEZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 23:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZKLEZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 23:25:14 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38884 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbZKLEZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 23:25:12 -0500
Date: Thu, 12 Nov 2009 09:55:02 +0530
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
       Arjan van de Ven <arjan@linux.intel.com>, paulus@in.ibm.com
Subject: Re: [PATCH 5/7 v6] hw-breakpoints: Rewrite the hw-breakpoints
	layer on top of perf events
Message-ID: <20091112042502.GA3145@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <1257694141-5670-6-git-send-email-fweisbec@gmail.com> <20091111130207.GA5676@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111130207.GA5676@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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
> 
> By the way, I'm looking at refs/heads/perfevents/hw-breakpoint branch in
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> and hope that's correct/latest?
> 
> Some more comments about the ptrace implementation here...
> 
>

I forgot to mention another potential bug here...

static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
{
..
...
restore:
	/*
	 * Loop through all the hardware breakpoints, making the
	 * appropriate changes to each.
	 */
	for (i = 0; i < HBP_NUM; i++) {
		enabled = decode_dr7(data, i, &len, &type);
		bp = thread->ptrace_bps[i];

		if (!enabled) {
			if (bp) {
				/*
				 * Don't unregister the breakpoints right-away,
				 * unless all register_user_hw_breakpoint()
				 * requests have succeeded. This prevents
				 * any window of opportunity for debug
				 * register grabbing by other users.
				 */
				if (!second_pass)
					continue;
				thread->ptrace_bps[i] = NULL;
				unregister_hw_breakpoint(bp);
			}
			continue;
		}

So, the breakpoint is unregistered whenever bits corresponding to
DR0-DR3 are set to a disabled state in DR7.

		/*
		 * We shoud have at least an inactive breakpoint at this
		 * slot. It means the user is writing dr7 without having
		 * written the address register first
		 */
		if (!bp) {
			rc = -EINVAL;
			break;
		}
..
...
}

Now think of the following sequence of write operations through ptrace:
1. Populate address in DRn (where 0 <= n <= 3) (breakpoint registration)
2. Enable corresponding bits in DR7 (modify breakpoint to active state)
3. Disable bits in DR7 (unregister breakpoint)
4. Enable bits in DR7 (returns with failure)

The assumption that every 'enable' operation in DR7 is preceded by a
write operation on DR0-DR3 need not be always true.

Thanks,
K.Prasad

