Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZI0UPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZI0UPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 16:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZI0UPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 16:15:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59048 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZI0UPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 16:15:19 -0400
Date: Sun, 27 Sep 2009 21:15:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Solving section mismatches
Message-ID: <20090927201507.GF20093@n2100.arm.linux.org.uk>
References: <20090927164115.GB20093@n2100.arm.linux.org.uk> <20090927182707.GA10405@merkur.ravnborg.org> <20090927183904.GD20093@n2100.arm.linux.org.uk> <20090927184645.GA10454@merkur.ravnborg.org> <20090927190953.GE20093@n2100.arm.linux.org.uk> <20090927194747.GA10490@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927194747.GA10490@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 09:47:47PM +0200, Sam Ravnborg wrote:
> Please try this:
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index e0d3277..835188b 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -214,7 +214,7 @@ void __cpuexit __cpu_die(unsigned int cpu)
>   * of the other hotplug-cpu capable cores, so presumably coming
>   * out of idle fixes this.
>   */
> -void __cpuexit cpu_die(void)
> +void __ref cpu_die(void)
>  {
>         unsigned int cpu = smp_processor_id();

That works - so can I get your ack for this entire patch please:

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] ARM: Fix __cpuexit section mismatch warnings

Fix:

WARNING: vmlinux.o(.text+0x247c): Section mismatch in reference from the function cpu_idle() to the function .cpuexit.text:cpu_die()
The function cpu_idle() references a function in an exit section.
Often the function cpu_die() has valid usage outside the exit section
and the fix is to remove the __cpuexit annotation of cpu_die.

WARNING: vmlinux.o(.cpuexit.text+0x3c): Section mismatch in reference from the function cpu_die() to the function .cpuinit.text:secondary_start_kernel()
The function __cpuexit cpu_die() references
a function __cpuinit secondary_start_kernel().
This is often seen when error handling in the exit function
uses functionality in the init path.
The fix is often to remove the __cpuinit annotation of
secondary_start_kernel() so it may be used outside an init section.

Sam says:
> The annotation of cpu_die() is wrong.
> To be annotated __cpuexit the function shall:
> - be used in exit context and only in exit context with HOTPLUG_CPU=n
> - be used outside exit context with HOTPLUG_CPU=y

So, this also means __cpu_disable(), __cpu_die() and twd_timer_stop() are
also wrong.  However, removing __cpuexit from cpu_die() creates:

WARNING: vmlinux.o(.text+0x6834): Section mismatch in reference from the function cpu_die() to the function .cpuinit.text:secondary_start_kernel()
The function cpu_die() references
the function __cpuinit secondary_start_kernel().
This is often because cpu_die lacks a __cpuinit
annotation or the annotation of secondary_start_kernel is wrong.

so fix this using __ref.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/kernel/smp.c     |    6 +++---
 arch/arm/kernel/smp_twd.c |    4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 9d015ee..57162af 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -154,7 +154,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 /*
  * __cpu_disable runs on the processor to be shutdown.
  */
-int __cpuexit __cpu_disable(void)
+int __cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
 	struct task_struct *p;
@@ -201,7 +201,7 @@ int __cpuexit __cpu_disable(void)
  * called on the thread which is asking for a CPU to be shutdown -
  * waits until shutdown has completed, or it is timed out.
  */
-void __cpuexit __cpu_die(unsigned int cpu)
+void __cpu_die(unsigned int cpu)
 {
 	if (!platform_cpu_kill(cpu))
 		printk("CPU%u: unable to kill\n", cpu);
@@ -215,7 +215,7 @@ void __cpuexit __cpu_die(unsigned int cpu)
  * of the other hotplug-cpu capable cores, so presumably coming
  * out of idle fixes this.
  */
-void __cpuexit cpu_die(void)
+void __ref cpu_die(void)
 {
 	unsigned int cpu = smp_processor_id();
 
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index d8c88c6..a73a34d 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -166,10 +166,12 @@ void __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	clockevents_register_device(clk);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
 /*
  * take a local timer down
  */
-void __cpuexit twd_timer_stop(void)
+void twd_timer_stop(void)
 {
 	__raw_writel(0, twd_base + TWD_TIMER_CONTROL);
 }
+#endif
