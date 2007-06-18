Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbXFRO5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbXFRO5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762800AbXFRO5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:57:11 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:55302 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762504AbXFRO5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:57:10 -0400
Date: Mon, 18 Jun 2007 10:57:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [patch 4/8] Immediate Value - i386 Optimization; kprobes
Message-ID: <20070618145702.GA5254@Krystal>
References: <20070615202310.178466032@polymtl.ca> <20070615202926.152087904@polymtl.ca> <46730C5A.7080401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46730C5A.7080401@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:19:35 up 20 days, 22:58,  3 users,  load average: 0.73, 0.55, 0.56
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Chuck Ebbert (cebbert@redhat.com) wrote:
> > +		return NOTIFY_STOP;
> > +	}
> > +	return NOTIFY_DONE;
> > +}
> > +
> > +static struct notifier_block immediate_notify = {
> > +	.notifier_call = immediate_notifier,
> > +	.priority = 0x7fffffff,	/* we need to be notified first */
> > +};
> > +
> > +/*
> > + * The address is not aligned. We can only change 1 byte of the value
> > + * atomically.
> > + * Must be called with immediate_mutex held.
> > + */
> > +int immediate_optimized_set_enable(void *address, char enable)
> > +{
> > +	char saved_byte;
> > +	int ret;
> > +	char *dest = address;
> > +
> > +	if (!(enable ^ dest[1])) /* Must be a state change 0<->1 to execute */
> > +		return 0;
> > +
> > +#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_DEBUG_PAGEALLOC)
> > +	/* Make sure this page is writable */
> > +	change_page_attr(virt_to_page(address), 1, PAGE_KERNEL_EXEC);
> > +	global_flush_tlb();
> > +#endif
> 
> Can't we have a macro or inline to do this, and the setting back
> to read-only? kprobes also has the same ugly #if blocks...
> 
> Hmm, what happens if you race with kprobes setting a probe on
> the same page? Couldn't it unexpectedly become read-only?
> 

Hi Chuck,

I am looking more closely at kprobes; a few comments while we are here:

1 - Why is kprobe_count an atomic_t variable instead of a simple
integer? It is always protected by the kprobe_mutex anyway. All this
synchronization seems redundant.

2 - I wonder where is the equivalent of my snippet in kprobes code:
> > +#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_DEBUG_PAGEALLOC)
> > + /* Make sure this page is writable */
> > + change_page_attr(virt_to_page(address), 1, PAGE_KERNEL_EXEC);
> > + global_flush_tlb();
> > +#endif

I fancy it's done by the kprobe_page_fault handler, but I do not see
clearly how writing the breakpoint from arch_arm_kprobe() in
non-writeable memory is done.

In any case, I would like not to use that kind of approach; I prefer to
set the memory page to RWX before doing the memory write so I do not
depend on the page fault handler (remember that I instrument the page
fault handler itself...).

Maybe we could use a shared "text_mutex" between kprobes and
immediate values to insure mutual exclusion for .text modification.
However, we would still have the following coherency issue when an
immediate value and a kprobe share the same address:

1- enable immediate value
2- put a kprobe at the immediate value load instruction address
3- disable immediate value
4- remove kprobe

The kprobe removal would put back the load immediate instruction and
would not touch the loaded value (which is ok). However, the instruction
copy kept by kprobes would not be in sync with the immediate value
state:

Scenario 1: kprobes int3 handler first:

1- enable immediate value
2- put a kprobe at the immediate value load instruction address

-> int3 triggered
kprobe handler runs. Single-steps the "enabled" state.

3- disable immediate value

-> int3 triggered
kprobe handler runs. Single-steps the "enabled" state. This state is
wrong.

4- remove kprobe


Scenario 2: immediate value int3 handler first:

1- enable immediate value
2- put a kprobe at the immediate value load instruction address

-> int3 triggered
kprobe handler runs. Single-steps the "enabled" state.

3- disable immediate value
  -> int3 triggered (while we disable)
  While we disable, the immediate value int3 handler is executed first. It
  would cause the kprobe handler not to be called, and no "missing"
  counter would be incremented.

kprobe handler runs. Single-steps the "enabled" state. This state is
wrong.

4- remove kprobe


Since I don't want to depend on kprobes to put the breakpoint, because
of its reentrancy limitations (see all the __probes functions), It would
be good to figure out a mutual exclusion mechanism between immediate
values and kprobes. Maybe we could forbid kprobes to insert probes on
addresses present in the immediate values tables ? Or better: if we
detect this scenario, we could put the kprobe breakpoint at the
instruction following the "movl".

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
