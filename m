Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZKELDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZKELDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbZKELDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:03:42 -0500
Received: from ozlabs.org ([203.10.76.45]:41641 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbZKELDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:03:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19186.45014.502448.698606@cargo.ozlabs.ibm.com>
Date: Thu, 5 Nov 2009 21:58:30 +1100
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 5/6] hw-breakpoints: Arbitrate access to pmu following registers constraints
In-Reply-To: <1257275474-5285-6-git-send-email-fweisbec@gmail.com>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
	<1257275474-5285-6-git-send-email-fweisbec@gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

> Allow or refuse to build a counter using the breakpoints pmu following
> given constraints.

As far as I can see, you assume each CPU has HBP_NUM breakpoint
registers which are all interchangeable and can all be used either for
data breakpoints or instruction breakpoints.  Is that accurate?

If so, we'll need to extend it a bit for Power since we have some CPUs
that have one data breakpoint register and one instruction breakpoint
register.  In general on powerpc the instruction and data breakpoint
facilities are separate, i.e. we have no registers that can be used
for either.

> +static void toggle_bp_slot(struct perf_event *bp, bool enable)
> +{
> +	int cpu = bp->cpu;
> +	unsigned int *nr;
> +	struct task_struct *tsk = bp->ctx->task;
> +
> +	/* Flexible */
> +	if (!bp->attr.pinned) {
> +		if (cpu >= 0) {
> +			nr = &per_cpu(nr_bp_flexible, cpu);
> +			goto toggle;
> +		}
> +
> +		for_each_online_cpu(cpu) {
> +			nr = &per_cpu(nr_bp_flexible, cpu);
> +			goto toggle;

...

> +toggle:
> +	*nr = enable ? *nr + 1 : *nr - 1;
> +}

This won't do what I think you want.  In the case where
!bp->attr.pinned and cpu == -1, it will only update the count for the
first online cpu, not all of them.

Paul.
