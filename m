Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbZI0Tru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbZI0Tru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 15:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZI0Trt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 15:47:49 -0400
Received: from [195.41.46.236] ([195.41.46.236]:48463 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbZI0Trt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 15:47:49 -0400
Date: Sun, 27 Sep 2009 21:47:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Solving section mismatches
Message-ID: <20090927194747.GA10490@merkur.ravnborg.org>
References: <20090927164115.GB20093@n2100.arm.linux.org.uk> <20090927182707.GA10405@merkur.ravnborg.org> <20090927183904.GD20093@n2100.arm.linux.org.uk> <20090927184645.GA10454@merkur.ravnborg.org> <20090927190953.GE20093@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927190953.GE20093@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 08:09:53PM +0100, Russell King - ARM Linux wrote:
> On Sun, Sep 27, 2009 at 08:46:45PM +0200, Sam Ravnborg wrote:
> > Please look at the above and realise that cpu_die() is only ever defined
> > in case that HOTPLUG_CPU is defined. So there is nothing to discard if
> > HOTPLUG_CPU equals to n.
> > 
> > And just to repeat myself....
> > The only correct use of __cpu* annotation is for function/data that is
> > used with or without HOTPLUG_CPU equals to y.
> > Which is NOT the case for cpu_die().
> > 
> > The __cpu* annotation is not a replacement for ifdeffed out code that is
> > not relevant for the non-HOTPLUG_CPU case.
> 
> Ok.  But that still doesn't solve:
> 
> WARNING: arch/arm/kernel/built-in.o(.text+0x6274): Section mismatch in reference from the function cpu_die() to the function .cpuinit.text:secondary_start_kernel()
> The function cpu_die() references
> the function __cpuinit secondary_start_kernel().
> This is often because cpu_die lacks a __cpuinit 
> annotation or the annotation of secondary_start_kernel is wrong.
> 
> So are you saying secondary_start_kernel should not have __cpuinit?

Lets try it.
- is secondary_start_kernel used only in init context with HOTPLUG_CPU=n - yes
- is secondary_start_kernel used outside init context with HOTPLUG_CPU=y - yes

So the __cpuinit annotation is correct.

cpu_idle is calling secondary_start_kernel() but cpu_idle() does not fulfill
the criteria for any of the __cpu* annotations.

So there is only two ways to tell modpost that this is correct.
Either rename it so it fullfill one of the whitelisted names
or explicitly tell modpost that this function may reference
__*init/__*exit annotated functions/code.

The latter is much preferred.
So the right fix is to annotate it with __ref. (see include/linux/init.h)

Had I looked closely last time I would have know this already - but alas I was
to quick to reply.

Please try this:
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index e0d3277..835188b 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -214,7 +214,7 @@ void __cpuexit __cpu_die(unsigned int cpu)
  * of the other hotplug-cpu capable cores, so presumably coming
  * out of idle fixes this.
  */
-void __cpuexit cpu_die(void)
+void __ref cpu_die(void)
 {
        unsigned int cpu = smp_processor_id();
 

You can add my:

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
or
Acked-by: Sam Ravnborg <sam@ravnborg.org>
as you prefer.

Assuming this works of course.

	Sam
