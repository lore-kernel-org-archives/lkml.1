Return-Path: <linux-kernel-owner+w=401wt.eu-S1761360AbZDQOhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360AbZDQOhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbZDQOhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:37:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48202 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753145AbZDQOhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:37:16 -0400
Date: Fri, 17 Apr 2009 10:37:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, <maneesh@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 00/11] Hardware Breakpoint interfaces
In-Reply-To: <20090417031221.GA4837@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0904171000470.6220-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009, K.Prasad wrote:

> > > +void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > > +{
> > > +	int i, j;
> > > +
> > > +	mutex_lock(&hw_breakpoint_mutex);
> > > +
> > > +	/* Find the 'bp' in our list of breakpoints for kernel */
> > > +	for (i = hbp_kernel_pos; i < HB_NUM; i++)
> > > +		if (bp == hbp_kernel[i])
> > > +			break;
> > > +
> > > +	/* Check if we did not find a match for 'bp'. If so return early */
> > > +	if (i == HB_NUM) {
> > > +		mutex_unlock(&hw_breakpoint_mutex);
> > > +		return;
> > > +	}
> > > +
> > > +	/*
> > > +	 * We'll shift the breakpoints one-level above to compact if
> > > +	 * unregistration creates a hole
> > > +	 */
> > > +	for (j = i; j > hbp_kernel_pos; j--)
> > > +		hbp_kernel[j] = hbp_kernel[j-1];
> > > +
> > > +	hbp_kernel[hbp_kernel_pos] = 0;
> > 
> > s/0/NULL/
> > 
> 
> Ok.
> 
> > > +	on_each_cpu(arch_update_kernel_hw_breakpoints, NULL, 0);
> > > +	hbp_kernel_pos++;
> > 
> > Don't you want to increment hbp_kernel_pos _before_ calling
> > on_each_cpu()?  Otherwise you're telling the other CPUs to install an
> > empty breakpoint.
> > 
> 
> Incrementing hbp_kernel_pos after arch_update_kernel_hw_breakpoints()
> during unregister_kernel_ is of the following significance:
> 
> - The 'pos' numbered debug register is reset to 0 through the code 
>   "set_debugreg(hbp_kernel[i]->info.address, i)" where 'i' ranges from
>   hbp_kernel_pos to HB_NUM. This is necessary during unregister operation.

It _isn't_ necessary.  The contents of that debug register don't matter 
at all if it isn't enabled.  (And there's nothing special about 0; if 
the breakpoint were enabled then you would get a breakpoint interrupt 
whenever something tried to access address 0.)

Besides, the "set_debugreg" line of code in
arch_update_kernel_hw_breakpoints doesn't get executed when
hbp_kernel[i] is NULL.  So this whole point is moot; the debug register
wouldn't be affected anyway.

> - The following statements would reset the bits corresponding to
>   unregistered breakpoint only then.
> 	kdr7 &= ~kdr7_masks[hbp_kernel_pos];
> 	dr7 &= ~kdr7_masks[hbp_kernel_pos];

But if hbp_kernel_pos is wrong (i.e., if it hasn't been incremented)
then these statements will set kdr7 and dr7 incorrectly.

> - Helps keep the arch_update_kernel_hw_breakpoints() code generic enough
>   to be invoked during register and unregister operations.

This is another moot point.  Your code is _wrong_ -- how generic it is
doesn't matter.


> > > +/* Unmasked kernel DR7 value */
> > > +static unsigned long kdr7;
> > > +static const unsigned long	kdr7_masks[HB_NUM] = {
> > > +	0xffff00ff,	/* Same for 3, 2, 1, 0 */
> > > +	0xfff000fc,	/* Same for 3, 2, 1 */
> > > +	0xff0000f0,	/* Same for 3, 2 */
> > > +	0xf00f00c0	/* LEN3, R/W3, G3, L3 */
> > > +};
> > 
> > It looks like you took out the first line of assignments.  Isn't
> > kdr7_masks supposed to contain HB_NUM + 1 elements?  Not to mention
> > that reordering the lines has mixed up the comments.
> > 
> 
> The kdr7_masks array is slightly different from your implementation
> earlier.
> 
> The element zero in the array is 0xffff00ff, which has all bits
> corresponding to DRs 0, 1, 2 and 3 'set', and hence the comment.

The comment is "Same for 3, 2, 1, 0".  But that is an incomplete 
thought -- same as _what_?  The answer is: Same as "LEN3, R/W3, G3, 
L3".  But you have messed up the logical order of the comments by 
reversing the lines.

Look at this:

	/* LEN3, R/W3, G3, L3 */
	/* Same for 3, 2 */
	/* Same for 3, 2, 1 */
	/* Same for 3, 2, 1, 0 */

That makes sense.  For instance, it's clear that the second line means 
LEN3, LEN2, R/W3, R/W2, G3, G2, L3, L2.  Now look at yours:

	/* Same for 3, 2, 1, 0 */
	/* Same for 3, 2, 1 */
	/* Same for 3, 2 */
	/* LEN3, R/W3, G3, L3 */

That doesn't make sense.  It's a general fact of human language: If you 
reverse the order of a bunch of sentences, you will mess up the 
meaning.


> > > +void arch_update_kernel_hw_breakpoints(void *unused)
> > > +{
> > > +	struct hw_breakpoint *bp;
> > > +	unsigned long dr7;
> > > +	int i;
> > > +
> > > +	/* Check if there is nothing to update */
> > > +	if (hbp_kernel_pos == HB_NUM)
> > > +		return;
> > 
> > This is wrong; you have to set DR7 to 0 first.  Might as well leave
> > out this test and just go through the whole routine.  The "for" loop
> > will be skipped entirely if hbp_kernel_pos == HB_NUM, so you don't
> > save much by returning early.
> > 
> > Ah, now I see this is why you removed a line from kdr7_masks.
> > 
> 
> This check is added to help the load_debug_registers() call during
> boot-time which is when hbp_kernel_pos = HB_NUM. If we don't return
> early, then assignments such as  these "kdr7 &= ~kdr7_masks[hbp_kernel_pos];"
> will cause array-out-of-bounds. Otherwise we have to circumvent it by
> adding a dummy HB_NUM element in kdr7_masks[] array. I would prefer
> retaining the "if (hbp_kernel_pos == HB_NUM)" check instead.

It's up to you.  But consider this:

     1. You have replaced a single array element (4 bytes of data)
	with a conditional test and jump (probably around 7 bytes
	of code, not to mention that the conditional jump will slow
	down the CPU even when it isn't taken).

     2. If hbp_kernel_pos is equal to HB_NUM then the early return 
	causes you to skip the line setting kdr7.  It will end up 
	having an incorrect value.


> > > +int __kprobes hw_breakpoint_handler(struct die_args *args)
> > > +{
> > > +	int i, rc = NOTIFY_STOP;
> > > +	struct hw_breakpoint *bp;
> > > +	/* The DR6 value is stored in args->err */
> > > +	unsigned long dr7, dr6 = args->err;
> > > +
> > > +	/*
> > > +	 * We are here because BT, BS or BD bit is set and no trap bits are set
> > > +	 * in dr6 register. Do an early return
> > > +	 */
> > 
> > I don't like such comments.  It says that BT, BS, or BD is set, but
> > they don't necessarily have to be.  You should say:
> > 
> > 	/* Do an early return if no trap bits are set in DR6 */
> > 
> 
> Since we enter hw_breakpoint_handler() code only if DIE_DEBUG (and not
> say DIE_INT3), one or more of these bits would be 'set' when we are in
> hw_breakpoint_handler() - BS, BT, BD or Trap bits, and hence the comment.

But the comment is _wrong_.  We might be here because one of the trap 
bits is set and BT, BS, and BD are clear, whereas the comment says that 
can't be the case.

Just read the comment again.  It says: "We are here because ... no trap 
bits are set".


> > >  dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
> > >  {
> > >  	struct task_struct *tsk = current;
> > > -	unsigned long condition;
> > > +	unsigned long dr6;
> > >  	int si_code;
> > >  
> > > -	get_debugreg(condition, 6);
> > > +	get_debugreg(dr6, 6);
> > > +	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
> > >  
> > >  	/* Catch kmemcheck conditions first of all! */
> > > -	if (condition & DR_STEP && kmemcheck_trap(regs))
> > > +	if ((dr6 & DR_STEP && kmemcheck_trap(regs)) &&
> > > +		!(dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))
> > >  		return;
> > 
> > Should this test go before the "set_debugreg(0, 6)" statement?
> > 
> 
> Either way, it doesn't affect the function "kmemcheck_trap()". I don't
> find it reading directly from DR6 anywhere.

Sure, it doesn't affect kmemcheck_trap().  But it might affect
something else.  What if some other code later on looks at the contents
of DR6?

Incidentally, the parenthese in that test are wrong.  It should be:

	if ((dr6 & DR_STEP) && kmemcheck_trap(regs) &&
			!(dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))

> On a related node, a patch that modifies dr6 to be passed by reference
> to the notifier calls will be included in the next iteration.
> 
> Let me know, upon receiving the patch, if you still think that such a
> change i.e. resetting bits in dr6 after handling of the corresponding 
> breakpoint needs to be done.

At the moment, the only other bits which could be set are BT and BD.  
Presumably we don't care about BD.  Do you care if BT gets wiped out 
before anybody has a chance to see it?

Alan Stern

