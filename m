Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYKKI42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYKKI42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYKKI4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:56:19 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:39965 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752237AbYKKI4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:56:18 -0500
Date: Tue, 11 Nov 2008 17:56:17 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix section type conflict in arch/ia64/xen/xen_pv_ops.c
Message-ID: <20081111085617.GD10955%yamahata@valinux.co.jp>
References: <s5h1vxou7gf.wl%tiwai@suse.de> <49133E11.8050607@goop.org> <20081106214848.GA3579@uranus.ravnborg.org> <s5hk5bazonk.wl%tiwai@suse.de> <20081111081552.GA10955%yamahata@valinux.co.jp> <s5hd4h2zndh.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hd4h2zndh.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 09:18:50AM +0100, Takashi Iwai wrote:
> At Tue, 11 Nov 2008 17:15:52 +0900,
> Isaku Yamahata wrote:
> > 
> > On Tue, Nov 11, 2008 at 08:51:11AM +0100, Takashi Iwai wrote:
> > > At Thu, 6 Nov 2008 22:48:48 +0100,
> > > Sam Ravnborg wrote:
> > > > 
> > > > On Thu, Nov 06, 2008 at 10:57:21AM -0800, Jeremy Fitzhardinge wrote:
> > > > > Takashi Iwai wrote:
> > > > > >__initdata and const cannot be always a happy pair, as gcc-4.3.3 gives
> > > > > >the compile errors like:
> > > > > >
> > > > > >  arch/ia64/xen/xen_pv_ops.c:156: error: xen_init_ops causes a section 
> > > > > >  type conflict
> > > > > >  arch/ia64/xen/xen_pv_ops.c:340: error: xen_iosapic_ops causes a section 
> > > > > >  type conflict
> > > > > >
> > > > > >This patch simply removes const from data with __initdata.
> > > > > >  
> > > > > 
> > > > > Yeah, I've seen these sort of messages before, but I don't see why 
> > > > > there's an inherent problem with having const __initdata.
> > > > > 
> > > > > Sam?
> > > > 
> > > > The root problem here is that in some cases gcc will stuff this into
> > > > a section marked CONST and in other cases not.
> > > > So when we manually specify the section we better not mix const and
> > > > non-const stuff in the same section.
> > > > The problem is that it is very gcc dependent. I have with powerpc
> > > > seen that the same code was not put in CONST with a 32 bit build,
> > > > but with the 64 bit build it was.
> > > > The only cure was to remove the const and use initdata.
> > > > You can try to play with initconst - and it may work.
> > > > But you need to have pretty good build coverage to be sure.
> > > 
> > > OK, then my original patch should do right :)
> > > Do you guys see any problems with it?
> > > 
> > > Right now 2.6.28-rc kernel doesn't build, thus this is basically a
> > > regression.
> > 
> > I'm fine with the patch.
> > 
> > The above sounds x86 xen potentially has the same issue, though.
> > 
> > linux-2.6/arch/x86/xen $ grep __initdata *
> > enlighten.c:static const struct pv_info xen_info __initdata = {
> > enlighten.c:static const struct pv_init_ops xen_init_ops __initdata = {
> > enlighten.c:static const struct pv_time_ops xen_time_ops __initdata = {
> > enlighten.c:static const struct pv_cpu_ops xen_cpu_ops __initdata = {
> > enlighten.c:static const struct pv_apic_ops xen_apic_ops __initdata = {
> > enlighten.c:static const struct pv_mmu_ops xen_mmu_ops __initdata = {
> > enlighten.c:static const struct machine_ops __initdata xen_machine_ops = {
> > irq.c:static const struct pv_irq_ops xen_irq_ops __initdata = {
> > smp.c:static const struct smp_ops xen_smp_ops __initdata = {
> 
> Oh, care to create a patch?

Here is.

__initdata and const cannot be always a happy pair and
x86 xen has the potential issue.
This patch simply removes const from data with __initdata
under arch/x86/xen/.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0013a72..19f758c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1173,14 +1173,14 @@ static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
 #endif
 }
 
-static const struct pv_info xen_info __initdata = {
+static struct pv_info xen_info __initdata = {
 	.paravirt_enabled = 1,
 	.shared_kernel_pmd = 0,
 
 	.name = "Xen",
 };
 
-static const struct pv_init_ops xen_init_ops __initdata = {
+static struct pv_init_ops xen_init_ops __initdata = {
 	.patch = xen_patch,
 
 	.banner = xen_banner,
@@ -1189,7 +1189,7 @@ static const struct pv_init_ops xen_init_ops __initdata = {
 	.post_allocator_init = xen_post_allocator_init,
 };
 
-static const struct pv_time_ops xen_time_ops __initdata = {
+static struct pv_time_ops xen_time_ops __initdata = {
 	.time_init = xen_time_init,
 
 	.set_wallclock = xen_set_wallclock,
@@ -1198,7 +1198,7 @@ static const struct pv_time_ops xen_time_ops __initdata = {
 	.sched_clock = xen_sched_clock,
 };
 
-static const struct pv_cpu_ops xen_cpu_ops __initdata = {
+static struct pv_cpu_ops xen_cpu_ops __initdata = {
 	.cpuid = xen_cpuid,
 
 	.set_debugreg = xen_set_debugreg,
@@ -1260,7 +1260,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	},
 };
 
-static const struct pv_apic_ops xen_apic_ops __initdata = {
+static struct pv_apic_ops xen_apic_ops __initdata = {
 #ifdef CONFIG_X86_LOCAL_APIC
 	.setup_boot_clock = paravirt_nop,
 	.setup_secondary_clock = paravirt_nop,
@@ -1268,7 +1268,7 @@ static const struct pv_apic_ops xen_apic_ops __initdata = {
 #endif
 };
 
-static const struct pv_mmu_ops xen_mmu_ops __initdata = {
+static struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.pagetable_setup_start = xen_pagetable_setup_start,
 	.pagetable_setup_done = xen_pagetable_setup_done,
 
@@ -1381,7 +1381,7 @@ static void xen_crash_shutdown(struct pt_regs *regs)
 	xen_reboot(SHUTDOWN_crash);
 }
 
-static const struct machine_ops __initdata xen_machine_ops = {
+static struct machine_ops __initdata xen_machine_ops = {
 	.restart = xen_restart,
 	.halt = xen_machine_halt,
 	.power_off = xen_machine_halt,
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 28b85ab..ffadf3a 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -124,7 +124,7 @@ static void xen_halt(void)
 		xen_safe_halt();
 }
 
-static const struct pv_irq_ops xen_irq_ops __initdata = {
+static struct pv_irq_ops xen_irq_ops __initdata = {
 	.init_IRQ = __xen_init_IRQ,
 	.save_fl = xen_save_fl,
 	.restore_fl = xen_restore_fl,
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index d77da61..f0a1ea3 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -466,7 +466,7 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static const struct smp_ops xen_smp_ops __initdata = {
+static struct smp_ops xen_smp_ops __initdata = {
 	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = xen_smp_prepare_cpus,
 	.smp_cpus_done = xen_smp_cpus_done,


-- 
yamahata
