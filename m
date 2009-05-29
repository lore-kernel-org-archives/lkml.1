Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbZE2DEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbZE2DEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 23:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZE2DEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 23:04:43 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39188 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZE2DEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 23:04:42 -0400
Date: Fri, 29 May 2009 12:59:29 +1000
From: David Gibson <dwg@au1.ibm.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 02/12] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090529025929.GD7831@yookeroo.seuss>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	"K.Prasad" <prasad@linux.vnet.ibm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Herrenschmidt <benh@au1.ibm.com>,
	maneesh@linux.vnet.ibm.com, Roland McGrath <roland@redhat.com>,
	Masami Hiramatsu <mhiramat@redhat.com>
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com> <20090511115240.GC25673@in.ibm.com> <20090528061517.GA3091@yookeroo.seuss> <20090528115546.GA6107@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528115546.GA6107@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 05:25:46PM +0530, K.Prasad wrote:
> On Thu, May 28, 2009 at 04:15:18PM +1000, David Gibson wrote:
> > On Mon, May 11, 2009 at 05:22:40PM +0530, K.Prasad wrote:
[snip]
> > > +/*
> > > + * Per-processor copy of hbp_kernel[]. Used only when hbp_kernel is being
> > > + * modified but we need the older copy to handle any hbp exceptions. It will
> > > + * sync with hbp_kernel[] value after updation is done through IPIs.
> > > + */
> > > +DEFINE_PER_CPU(struct hw_breakpoint*, this_hbp_kernel[HB_NUM]);
> > 
> > Ok.. this seems to assume that all breakpoints are equal as far as
> > allocation goes - i.e. that the total number of breakpoints is the
> > only allocation limit.  That's apparently true for x86, but on
> > embedded powerpc (4xx), for example, we can have up to 2 data
> > breakpoints and up to 4 instruction breakpoints independent of each
> > other.
> 
> True. But I hope that you see that the infrastructure is extensible.
> While the generic infrastructure has served the purposes of x86 and
> PPC64 well, one may want to 'grow' it when implementing breakpoints for
> 4xx processors. Say, make hbp_kernel[] a 2-D array, one for each
> HBP_TYPE (say DAC and IAC) and hbp_kernel_pos into an array (of size
> HBP_TYPE).

Hrm, I guess.  I suppose since there's no userspace exposed interface
to this new infrastructure (other than the backwards compatible ptrace
one), then this is indeed a deficiency which could be fixed up later.

[snip]
> > > +void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
> > > +{
> > > +	/* Set the debug register */
> > > +	arch_install_thread_hw_breakpoint(tsk);
> > 
> > Um.. and the point of this wrapper which does nothing extra around the
> > arch-specific function would be...?
> > 
> > > +}
> > > +
> > > +/*
> > > + * Install the debug register values for just the kernel, no thread.
> > > + */
> > > +void switch_to_none_hw_breakpoint(void)
> > > +{
> > > +	arch_uninstall_thread_hw_breakpoint();
> > 
> > And again.
> > 
> 
> These functions have hence been removed. You can find the latest
> patchset here: http://lkml.org/lkml/2009/5/21/143.

Oh, sorry.  I thought I'd grabbed the latest patchset, but apparently
not.

[snip]
> > > +/*
> > > + * Load the debug registers during startup of a CPU.
> > > + */
> > > +void load_debug_registers(void)
> > 
> > This name does not suggest a boot and/or cpu hotplug only function.
> 
> I think the name aptly describes what the function achieves
> (irrespective of where it is employed). Let us know if you have better
> suggestions.

Hrm, not really.  To me, "load_debug_registers" suggests the operation
that happens in during context switch as we load the new threads debug
setup into the hardware registers.  AFAICT that's only part of what
this function does, and it's *not* typically called during context
switch.

How about "init_debug_registers()"?

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
