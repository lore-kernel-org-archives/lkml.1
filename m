Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZI0UW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZI0UW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 16:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbZI0UW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 16:22:57 -0400
Received: from [195.41.46.235] ([195.41.46.235]:49904 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZI0UW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 16:22:57 -0400
Date: Sun, 27 Sep 2009 22:22:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Solving section mismatches
Message-ID: <20090927202251.GA10523@merkur.ravnborg.org>
References: <20090927164115.GB20093@n2100.arm.linux.org.uk> <20090927182707.GA10405@merkur.ravnborg.org> <20090927183904.GD20093@n2100.arm.linux.org.uk> <20090927184645.GA10454@merkur.ravnborg.org> <20090927190953.GE20093@n2100.arm.linux.org.uk> <20090927194747.GA10490@merkur.ravnborg.org> <20090927201507.GF20093@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927201507.GF20093@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 09:15:07PM +0100, Russell King - ARM Linux wrote:
> On Sun, Sep 27, 2009 at 09:47:47PM +0200, Sam Ravnborg wrote:
> > Please try this:
> > diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> > index e0d3277..835188b 100644
> > --- a/arch/arm/kernel/smp.c
> > +++ b/arch/arm/kernel/smp.c
> > @@ -214,7 +214,7 @@ void __cpuexit __cpu_die(unsigned int cpu)
> >   * of the other hotplug-cpu capable cores, so presumably coming
> >   * out of idle fixes this.
> >   */
> > -void __cpuexit cpu_die(void)
> > +void __ref cpu_die(void)
> >  {
> >         unsigned int cpu = smp_processor_id();
> 
> That works - so can I get your ack for this entire patch please:
> 
> From: Russell King <rmk+kernel@arm.linux.org.uk>
> Subject: [PATCH] ARM: Fix __cpuexit section mismatch warnings
> 
> Fix:
> 
> WARNING: vmlinux.o(.text+0x247c): Section mismatch in reference from the function cpu_idle() to the function .cpuexit.text:cpu_die()
> The function cpu_idle() references a function in an exit section.
> Often the function cpu_die() has valid usage outside the exit section
> and the fix is to remove the __cpuexit annotation of cpu_die.
> 
> WARNING: vmlinux.o(.cpuexit.text+0x3c): Section mismatch in reference from the function cpu_die() to the function .cpuinit.text:secondary_start_kernel()
> The function __cpuexit cpu_die() references
> a function __cpuinit secondary_start_kernel().
> This is often seen when error handling in the exit function
> uses functionality in the init path.
> The fix is often to remove the __cpuinit annotation of
> secondary_start_kernel() so it may be used outside an init section.
> 
> Sam says:
> > The annotation of cpu_die() is wrong.
> > To be annotated __cpuexit the function shall:
> > - be used in exit context and only in exit context with HOTPLUG_CPU=n
> > - be used outside exit context with HOTPLUG_CPU=y
> 
> So, this also means __cpu_disable(), __cpu_die() and twd_timer_stop() are
> also wrong.  However, removing __cpuexit from cpu_die() creates:
> 
> WARNING: vmlinux.o(.text+0x6834): Section mismatch in reference from the function cpu_die() to the function .cpuinit.text:secondary_start_kernel()
> The function cpu_die() references
> the function __cpuinit secondary_start_kernel().
> This is often because cpu_die lacks a __cpuinit
> annotation or the annotation of secondary_start_kernel is wrong.
> 
> so fix this using __ref.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Patch looks good!
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
