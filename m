Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZI0Squ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZI0Squ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 14:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZI0Squ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 14:46:50 -0400
Received: from [195.41.46.235] ([195.41.46.235]:52311 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbZI0Sqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 14:46:48 -0400
Date: Sun, 27 Sep 2009 20:46:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Solving section mismatches
Message-ID: <20090927184645.GA10454@merkur.ravnborg.org>
References: <20090927164115.GB20093@n2100.arm.linux.org.uk> <20090927182707.GA10405@merkur.ravnborg.org> <20090927183904.GD20093@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927183904.GD20093@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 07:39:04PM +0100, Russell King - ARM Linux wrote:
> On Sun, Sep 27, 2009 at 08:27:07PM +0200, Sam Ravnborg wrote:
> > On Sun, Sep 27, 2009 at 05:41:16PM +0100, Russell King - ARM Linux wrote:
> > > Sam,
> > > 
> > > Any idea how to solve this:
> > > 
> > > WARNING: arch/arm/kernel/built-in.o(.text+0x1ebc): Section mismatch in reference from the function cpu_idle() to the function .cpuexit.text:cpu_die()
> > > The function cpu_idle() references a function in an exit section.
> > > Often the function cpu_die() has valid usage outside the exit section
> > > and the fix is to remove the __cpuexit annotation of cpu_die.
> > > 
> > > WARNING: arch/arm/kernel/built-in.o(.cpuexit.text+0x3c): Section mismatch in reference from the function cpu_die() to the function .cpuinit.text:secondary_start_kernel()
> > > The function __cpuexit cpu_die() references
> > > a function __cpuinit secondary_start_kernel().
> > > This is often seen when error handling in the exit function
> > > uses functionality in the init path.
> > > The fix is often to remove the __cpuinit annotation of
> > > secondary_start_kernel() so it may be used outside an init section.
> > > 
> > > Logically, the annotations are correct - in the first case, cpu_die()
> > > will only ever be called if hotplug CPU is enabled, since you can't
> > > offline a CPU without hotplug CPU enabled.  In that case, the __cpuexit.*
> > > sections are not discarded.
> > 
> > The annotation of cpu_die() is wrong.
> > To be annotated __cpuexit the function shall:
> > - be used in exit context and only in exit context with HOTPLUG_CPU=n
> > - be used outside exit context with HOTPLUG_CPU=y
> > 
> > cpu_die() fails on the first condition because it is only used
> > if HOTPLUG_CPU=y.
> > The annotation is wrongly used as a replacement for an ifdef.
> > As cpu_die() is already inside ifdef CONFIG_HOTPLUG_CPU is should
> > be enough to just remove the annotation.
> > 
> > Like this (copy'n'paste so it does not apply)
> > 
> > diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> > index e0d3277..de4ef1c 100644
> > --- a/arch/arm/kernel/smp.c
> > +++ b/arch/arm/kernel/smp.c
> > @@ -214,7 +214,7 @@ void __cpuexit __cpu_die(unsigned int cpu)
> >   * of the other hotplug-cpu capable cores, so presumably coming
> >   * out of idle fixes this.
> >   */
> > -void __cpuexit cpu_die(void)
> > +void cpu_die(void)
> >  {
> >         unsigned int cpu = smp_processor_id();
> 
> This is wrong.  cpu_die() does not need to exist if hotplug CPU is
> disabled.  In that case, it should be discarded and this is precisely
> what __cpuexit does.  The annotation is, therefore, correct.

>From arch/arm/kernel/smp.c

#ifdef CONFIG_HOTPLUG_CPU

...
void __cpuexit cpu_die(void)
{
        unsigned int cpu = smp_processor_id();

        local_irq_disable();
        idle_task_exit();

        /*
         * actual CPU shutdown procedure is at least platform (if not
         * CPU) specific
         */
        platform_cpu_die(cpu);

        /*
         * Do not return to the idle loop - jump back to the secondary
         * cpu initialisation.  There's some initialisation which needs
         * to be repeated to undo the effects of taking the CPU offline.
         */
        __asm__("mov    sp, %0\n"
        "       b       secondary_start_kernel"
                :
                : "r" (task_stack_page(current) + THREAD_SIZE - 8));
}
#endif /* CONFIG_HOTPLUG_CPU */


Please look at the above and realise that cpu_die() is only ever defined
in case that HOTPLUG_CPU is defined. So there is nothing to discard if
HOTPLUG_CPU equals to n.

And just to repeat myself....
The only correct use of __cpu* annotation is for function/data that is
used with or without HOTPLUG_CPU equals to y.
Which is NOT the case for cpu_die().

The __cpu* annotation is not a replacement for ifdeffed out code that is
not relevant for the non-HOTPLUG_CPU case.

	Sam
