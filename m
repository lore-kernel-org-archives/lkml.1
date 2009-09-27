Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbZI0SjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbZI0SjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 14:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZI0SjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 14:39:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50970 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZI0SjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 14:39:12 -0400
Date: Sun, 27 Sep 2009 19:39:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Solving section mismatches
Message-ID: <20090927183904.GD20093@n2100.arm.linux.org.uk>
References: <20090927164115.GB20093@n2100.arm.linux.org.uk> <20090927182707.GA10405@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927182707.GA10405@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 08:27:07PM +0200, Sam Ravnborg wrote:
> On Sun, Sep 27, 2009 at 05:41:16PM +0100, Russell King - ARM Linux wrote:
> > Sam,
> > 
> > Any idea how to solve this:
> > 
> > WARNING: arch/arm/kernel/built-in.o(.text+0x1ebc): Section mismatch in reference from the function cpu_idle() to the function .cpuexit.text:cpu_die()
> > The function cpu_idle() references a function in an exit section.
> > Often the function cpu_die() has valid usage outside the exit section
> > and the fix is to remove the __cpuexit annotation of cpu_die.
> > 
> > WARNING: arch/arm/kernel/built-in.o(.cpuexit.text+0x3c): Section mismatch in reference from the function cpu_die() to the function .cpuinit.text:secondary_start_kernel()
> > The function __cpuexit cpu_die() references
> > a function __cpuinit secondary_start_kernel().
> > This is often seen when error handling in the exit function
> > uses functionality in the init path.
> > The fix is often to remove the __cpuinit annotation of
> > secondary_start_kernel() so it may be used outside an init section.
> > 
> > Logically, the annotations are correct - in the first case, cpu_die()
> > will only ever be called if hotplug CPU is enabled, since you can't
> > offline a CPU without hotplug CPU enabled.  In that case, the __cpuexit.*
> > sections are not discarded.
> 
> The annotation of cpu_die() is wrong.
> To be annotated __cpuexit the function shall:
> - be used in exit context and only in exit context with HOTPLUG_CPU=n
> - be used outside exit context with HOTPLUG_CPU=y
> 
> cpu_die() fails on the first condition because it is only used
> if HOTPLUG_CPU=y.
> The annotation is wrongly used as a replacement for an ifdef.
> As cpu_die() is already inside ifdef CONFIG_HOTPLUG_CPU is should
> be enough to just remove the annotation.
> 
> Like this (copy'n'paste so it does not apply)
> 
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index e0d3277..de4ef1c 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -214,7 +214,7 @@ void __cpuexit __cpu_die(unsigned int cpu)
>   * of the other hotplug-cpu capable cores, so presumably coming
>   * out of idle fixes this.
>   */
> -void __cpuexit cpu_die(void)
> +void cpu_die(void)
>  {
>         unsigned int cpu = smp_processor_id();

This is wrong.  cpu_die() does not need to exist if hotplug CPU is
disabled.  In that case, it should be discarded and this is precisely
what __cpuexit does.  The annotation is, therefore, correct.
