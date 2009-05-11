Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZEKOut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZEKOut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZEKOuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:50:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49807 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752453AbZEKOuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:50:39 -0400
Date: Mon, 11 May 2009 10:50:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, <maneesh@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 00/12] Hardware Breakpoint Interfaces
In-Reply-To: <20090511113644.GB26721@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0905111025500.2975-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, K.Prasad wrote:

> > You shouldn't call on_each_cpu() while holding a spinlock.  The same
> > thing happens in unregister_kernel_hw_breakpoint().
> > 
> 
> First, on_each_cpu() will now be changed to return only after all
> functions invoked through IPIs have returned (by changing @wait
> parameter to 1). This is required to prevent side effects of
> incrementing hbp_kernel_pos after on_each_cpu() in
> unregister_kernel_hw_breakpoint() [hbp_kernel_pos is still incremented
> after IPI and I will explain it below].

Good.  I thought this was already done; it's lucky you noticed it
wasn't.

> on_each_cpu() isn't a blocking call (despite @wait being set to 1, which
> does a busy wait through cpu_relax()) and should be safe to invoke
> inside a spin_lock() context. I would like to know if you think
> otherwise.

I guess you're right.  Why did you change the spin_lock to 
spin_lock_bh?


> > What happens if a kernel breakpoint is triggered on another CPU while
> > this loop is running?  Or what happens if the breakpoint being removed
> > is triggered on another CPU before on_each_cpu() is called below?
> > 
> > Basically, it's impossible to change the kernel breakpoints 
> > simultaneously on all CPUs.  That means you somehow have to keep both 
> > the old set and the new set around until all the CPUs are updated.
> > 
> 
> I must admit that the code did not handle the above scenario. I am
> adding a per-cpu instance of 'hbp_kernel[]' called 'this_hbp_kernel[]'.
> The breakpoint handler would use the per-cpu instance which will remain
> valid throughout the execution of the handler. The per-cpu instance will
> be updated with hbp_kernel[] values in arch_update_kernel_hw_breakpoint().
> [This necessitates hbp_kernel_pos increment to happen after the IPI call
> in unregister_kernel code].

Yes, okay.  I'm a little nervous about making this_hbp_kernel[] be
per-cpu while hbp_kernel_pos isn't.  It means the two values will
sometimes be out of sync with each other.  But it ought to be safe
since during the out-of-sync periods, hbp_kernel_pos will always point
to an empty breakpoint slot.

Still, in hw_breakpoint_handler(), perhaps the "if (i >= 
hbp_kernel_pos)" path should also check for !bp.  Just to be safe.  In 
other words, move the 

+			if (!bp)
+				continue;
+			rc = NOTIFY_DONE;

lines outside the "if" statement.


> > Another problem: kdr7 is a global variable, and here you've got every
> > CPU recomputing it whenever a kernel breakpoint is added or removed.
> > It should be computed just once, before the on_each_cpu() call.
> > 
> 
> If kdr7 needs to be updated only once, it has to be kept outside the IPI
> through the use of a wrapper routine (in arch/x86/kernel/hw_breakpoint.c
> as it is arch-specific). This would mean one more function call in
> (un)register_kernel_<> routines taking the code back to one of its previous
> designs. In a trade-off between code-brevity and efficiency, the present one
> chose the former keeping in mind some of the comments received during the
> early stages of this patch.

You don't appreciate the seriousness of this problem.  Here's the new code:

+	/* Clear all kernel-space breakpoints in kdr7 */
+	kdr7 = 0;
(A)
+	for (i = hbp_kernel_pos; i < HB_NUM; i++) {
+		per_cpu(this_hbp_kernel[i], cpu) = bp = hbp_kernel[i];
+		if (bp) {
+			kdr7 |= encode_dr7(i, bp->info.len, bp->info.type);
+			set_debugreg(hbp_kernel[i]->info.address, i);
+		}
+	}
+
+	/* No need to set DR6. Update the debug registers with kernel-space
+	 * breakpoint values from kdr7 and user-space requests from the
+	 * current process
+	 */
(B)
+	set_debugreg(kdr7 | current->thread.debugreg7, 7);

Suppose you send out the IPIs, and one of the CPUs happens to reach (A)
at the same time another CPU reaches (B).  The second CPU will load an
incorrect value into DR7.

If you prefer you can replace kdr7 above with a local variable, and 
set kdr7 to the local variable's value at the end of the function.  
Also, in the first set_debugreg() line above, you can replace 
hbp_kernel[i] with bp.


> > > +	void *temp_mem = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
> > > +	if (!temp_mem)
> > > +		temp_mem_used = -ENOMEM;
> > 
> > I don't think this is a good idea...
> > 
> 
> I agree that it turned out to be wrong. ptrace is now modified to use
> the (un)register_user_hw_breakpoint() interfaces directly and not the
> worker routines, thereby avoiding all this complexity. Please find the
> changes in the new patch.

> > And now if something went wrong, you have already freed the memory
> > holding the original breakpoint structures.  It would be better to
> > keep them around until you know they aren't going to be needed.

I still think it would be a good idea to avoid freeing any breakpoint
structures until you know for certain they aren't needed.  Otherwise
you might find that you're unable to allocate memory to re-create a
structure that was already present.

Alan Stern

