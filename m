Return-Path: <linux-kernel-owner+w=401wt.eu-S933055AbXDFQTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbXDFQTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933057AbXDFQTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:19:46 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:45293 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055AbXDFQTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:19:42 -0400
Message-ID: <461672D8.7090100@free.fr>
Date: Fri, 06 Apr 2007 18:18:32 +0200
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, tglx@timesys.com, linux.kernel@free.fr
Subject: 2.6.20-rt8 patch tweaked for 2.6.20.5
Content-Type: multipart/mixed;
 boundary="------------020803010609090106030602"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020803010609090106030602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I've tweaked patch-2.6.20-rt8 so that it applies to 2.6.20.5

The unified diff is attached to this message.

I'd be happy to hear comments on what I've done wrong.

78 hunks had to be offset and 3 hunks had to be fuzzed.

$ grep -B1 fuzz patch.log
patching file arch/ia64/kernel/iosapic.c
Hunk #3 succeeded at 469 with fuzz 2.
--
patching file kernel/fork.c
Hunk #9 succeeded at 975 with fuzz 1.
--
patching file kernel/sched.c
Hunk #46 succeeded at 3996 with fuzz 1.

What is the fuzz value, exactly?

Regards.


--------------020803010609090106030602
Content-Type: text/plain;
 name="2.6.20-to-2.6.20.5-diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.20-to-2.6.20.5-diff"

--- patch-2.6.20-rt8	2007-02-16 10:48:03.000000000 +0100
+++ patch-2.6.20.5-rt8	2007-04-06 17:55:30.000000000 +0200
@@ -770,8 +770,8 @@
  VERSION = 2
  PATCHLEVEL = 6
  SUBLEVEL = 20
--EXTRAVERSION =
-+EXTRAVERSION = -rt8
+-EXTRAVERSION = .5
++EXTRAVERSION = .5-rt8
  NAME = Homicidal Dwarf Hamster
  
  # *DOCUMENTATION*
@@ -19927,15 +19927,6 @@
  unsigned long segment_base(u16 selector);
  
  void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes);
-@@ -558,7 +587,7 @@ static inline void load_gs(u16 sel)
- #ifndef load_ldt
- static inline void load_ldt(u16 sel)
- {
--	asm ("lldt %0" : : "g"(sel));
-+	asm ("lldt %0" : : "rm"(sel));
- }
- #endif
- 
 @@ -627,4 +656,6 @@ static inline u32 get_rdx_init_val(void)
  #define TSS_REDIRECTION_SIZE (256 / 8)
  #define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
@@ -38197,7 +38188,7 @@
  	if (q->filp)
  		send_sigio(&q->filp->f_owner, q->fd, POLL_IN);
  	/*
-@@ -561,10 +608,12 @@ static int wake_futex_pi(u32 __user *uad
+@@ -561,11 +608,12 @@ static int wake_futex_pi(u32 __user *uad
  	struct task_struct *new_owner;
  	struct futex_pi_state *pi_state = this->pi_state;
  	u32 curval, newval;
@@ -38206,11 +38197,12 @@
  	if (!pi_state)
  		return -EINVAL;
  
+-	spin_lock(&pi_state->pi_mutex.wait_lock);
 +	spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
  	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
  
  	/*
-@@ -583,27 +632,40 @@ static int wake_futex_pi(u32 __user *uad
+@@ -583,28 +632,40 @@ static int wake_futex_pi(u32 __user *uad
  	 */
  	if (!(uval & FUTEX_OWNER_DIED)) {
  		newval = FUTEX_WAITERS | new_owner->pid;
@@ -38253,6 +38245,7 @@
 -	spin_unlock_irq(&new_owner->pi_lock);
 +	spin_unlock(&new_owner->pi_lock);
  
+-	spin_unlock(&pi_state->pi_mutex.wait_lock);
 +	spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);
  	rt_mutex_unlock(&pi_state->pi_mutex);
  
@@ -54910,9 +54903,9 @@
 --- linux.orig/kernel/time/clocksource.c
 +++ linux/kernel/time/clocksource.c
 @@ -28,6 +28,7 @@
- #include <linux/sysdev.h>
  #include <linux/init.h>
  #include <linux/module.h>
+ #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 +#include <linux/tick.h>
  
  /* XXX - Would like a better way for initializing curr_clocksource */
@@ -66089,27 +66082,6 @@
  }
  
  /* When dgram socket disconnects (or changes its peer), we clear its receive
-Index: linux/net/xfrm/xfrm_user.c
-===================================================================
---- linux.orig/net/xfrm/xfrm_user.c
-+++ linux/net/xfrm/xfrm_user.c
-@@ -1273,13 +1273,12 @@ static int xfrm_get_policy(struct sk_buf
- 		xp = xfrm_policy_bysel_ctx(type, p->dir, &p->sel, tmp.security, delete);
- 		security_xfrm_policy_free(&tmp);
- 	}
--	if (delete)
--		xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
--			       AUDIT_MAC_IPSEC_DELSPD, (xp) ? 1 : 0, xp, NULL);
--
- 	if (xp == NULL)
- 		return -ENOENT;
- 
-+	xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
-+		       AUDIT_MAC_IPSEC_DELSPD, delete, xp, NULL);
-+
- 	if (!delete) {
- 		struct sk_buff *resp_skb;
- 
 Index: linux/scripts/Makefile
 ===================================================================
 --- linux.orig/scripts/Makefile


--------------020803010609090106030602
Content-Type: text/plain;
 name="patch.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch.log"

patching file Documentation/feature-removal-schedule.txt
patching file Documentation/hrtimer/timer_stats.txt
patching file Documentation/hrtimers.txt
patching file Documentation/hrtimers/highres.txt
patching file Documentation/hrtimers/hrtimers.txt
patching file Documentation/kernel-parameters.txt
patching file Documentation/stable_api_nonsense.txt
patching file Makefile
patching file arch/arm/Kconfig
patching file arch/arm/boot/compressed/head.S
patching file arch/arm/common/time-acorn.c
patching file arch/arm/kernel/dma.c
patching file arch/arm/kernel/entry-armv.S
patching file arch/arm/kernel/entry-common.S
patching file arch/arm/kernel/fiq.c
patching file arch/arm/kernel/irq.c
patching file arch/arm/kernel/process.c
patching file arch/arm/kernel/semaphore.c
patching file arch/arm/kernel/signal.c
patching file arch/arm/kernel/smp.c
patching file arch/arm/kernel/time.c
patching file arch/arm/kernel/traps.c
patching file arch/arm/mach-footbridge/netwinder-hw.c
patching file arch/arm/mach-footbridge/netwinder-leds.c
patching file arch/arm/mach-imx/time.c
patching file arch/arm/mach-integrator/core.c
patching file arch/arm/mach-integrator/pci_v3.c
patching file arch/arm/mach-integrator/platsmp.c
patching file arch/arm/mach-ixp4xx/common-pci.c
patching file arch/arm/mach-ixp4xx/common.c
patching file arch/arm/mach-netx/time.c
patching file arch/arm/mach-omap1/pm.c
patching file arch/arm/mach-omap1/time.c
patching file arch/arm/mach-omap2/pm.c
patching file arch/arm/mach-pxa/time.c
patching file arch/arm/mach-sa1100/badge4.c
patching file arch/arm/mach-shark/leds.c
patching file arch/arm/mm/consistent.c
patching file arch/arm/mm/copypage-v4mc.c
patching file arch/arm/mm/copypage-v6.c
patching file arch/arm/mm/copypage-xscale.c
patching file arch/arm/mm/fault.c
patching file arch/arm/mm/mmu.c
patching file arch/arm/oprofile/op_model_xscale.c
patching file arch/arm/plat-omap/Kconfig
patching file arch/arm/plat-omap/clock.c
patching file arch/arm/plat-omap/common.c
patching file arch/arm/plat-omap/dma.c
patching file arch/arm/plat-omap/gpio.c
patching file arch/arm/plat-omap/mux.c
patching file arch/arm/plat-omap/timer32k.c
patching file arch/avr32/kernel/time.c
patching file arch/i386/Kconfig
patching file arch/i386/Kconfig.cpu
patching file arch/i386/Kconfig.debug
patching file arch/i386/Makefile
patching file arch/i386/boot/compressed/Makefile
patching file arch/i386/boot/compressed/misc.c
patching file arch/i386/defconfig
patching file arch/i386/kernel/Makefile
patching file arch/i386/kernel/acpi/boot.c
patching file arch/i386/kernel/acpi/earlyquirk.c
patching file arch/i386/kernel/apic.c
patching file arch/i386/kernel/apm.c
patching file arch/i386/kernel/cpu/intel.c
patching file arch/i386/kernel/cpu/mcheck/p4.c
patching file arch/i386/kernel/cpu/mtrr/generic.c
patching file arch/i386/kernel/cpu/transmeta.c
patching file arch/i386/kernel/crash.c
patching file arch/i386/kernel/efi.c
patching file arch/i386/kernel/entry.S
patching file arch/i386/kernel/head.S
patching file arch/i386/kernel/hpet.c
patching file arch/i386/kernel/hyper_clock.c
patching file arch/i386/kernel/i386_ksyms.c
patching file arch/i386/kernel/i8253.c
patching file arch/i386/kernel/i8259.c
patching file arch/i386/kernel/io_apic.c
patching file arch/i386/kernel/irq.c
patching file arch/i386/kernel/kprobes.c
patching file arch/i386/kernel/mcount-wrapper.S
patching file arch/i386/kernel/microcode.c
patching file arch/i386/kernel/mpparse.c
patching file arch/i386/kernel/nmi.c
patching file arch/i386/kernel/paravirt.c
patching file arch/i386/kernel/process.c
patching file arch/i386/kernel/quirks.c
patching file arch/i386/kernel/reboot.c
patching file arch/i386/kernel/signal.c
Hunk #1 succeeded at 534 (offset 4 lines).
patching file arch/i386/kernel/smp.c
patching file arch/i386/kernel/smpboot.c
patching file arch/i386/kernel/time.c
patching file arch/i386/kernel/time_hpet.c
patching file arch/i386/kernel/traps.c
patching file arch/i386/kernel/tsc.c
patching file arch/i386/kernel/tsc_sync.c
patching file arch/i386/kernel/vm86.c
patching file arch/i386/lib/delay.c
patching file arch/i386/lib/semaphore.S
patching file arch/i386/mach-default/setup.c
patching file arch/i386/mach-es7000/es7000plat.c
patching file arch/i386/mach-visws/setup.c
patching file arch/i386/mach-visws/visws_apic.c
patching file arch/i386/mach-voyager/setup.c
patching file arch/i386/mm/fault.c
patching file arch/i386/mm/highmem.c
patching file arch/i386/mm/init.c
patching file arch/i386/mm/pgtable.c
patching file arch/i386/oprofile/Kconfig
patching file arch/i386/pci/Makefile
patching file arch/i386/pci/common.c
patching file arch/i386/pci/direct.c
patching file arch/i386/pci/pci.h
patching file arch/ia64/Kconfig
Hunk #1 succeeded at 33 (offset 1 line).
Hunk #3 succeeded at 374 (offset 1 line).
patching file arch/ia64/kernel/asm-offsets.c
patching file arch/ia64/kernel/entry.S
patching file arch/ia64/kernel/fsys.S
patching file arch/ia64/kernel/iosapic.c
Hunk #3 succeeded at 469 with fuzz 2.
patching file arch/ia64/kernel/irq_ia64.c
patching file arch/ia64/kernel/mca.c
patching file arch/ia64/kernel/perfmon.c
patching file arch/ia64/kernel/process.c
patching file arch/ia64/kernel/sal.c
patching file arch/ia64/kernel/salinfo.c
patching file arch/ia64/kernel/semaphore.c
patching file arch/ia64/kernel/signal.c
patching file arch/ia64/kernel/smp.c
patching file arch/ia64/kernel/smpboot.c
patching file arch/ia64/kernel/time.c
patching file arch/ia64/kernel/traps.c
patching file arch/ia64/kernel/unwind.c
patching file arch/ia64/kernel/unwind_i.h
patching file arch/ia64/mm/init.c
patching file arch/ia64/mm/tlb.c
patching file arch/m68k/atari/stdma.c
patching file arch/mips/Kconfig
patching file arch/mips/kernel/Makefile
patching file arch/mips/kernel/asm-offsets.c
patching file arch/mips/kernel/entry.S
patching file arch/mips/kernel/i8259.c
patching file arch/mips/kernel/module.c
patching file arch/mips/kernel/process.c
patching file arch/mips/kernel/scall32-o32.S
patching file arch/mips/kernel/scall64-64.S
patching file arch/mips/kernel/scall64-n32.S
patching file arch/mips/kernel/scall64-o32.S
patching file arch/mips/kernel/semaphore.c
patching file arch/mips/kernel/signal.c
patching file arch/mips/kernel/signal32.c
patching file arch/mips/kernel/smp.c
patching file arch/mips/kernel/time.c
patching file arch/mips/kernel/traps.c
patching file arch/mips/mm/fault.c
patching file arch/mips/mm/init.c
patching file arch/mips/sibyte/cfe/smp.c
patching file arch/mips/sibyte/sb1250/irq.c
patching file arch/mips/sibyte/sb1250/smp.c
patching file arch/mips/sibyte/swarm/setup.c
patching file arch/powerpc/Kconfig
patching file arch/powerpc/Kconfig.debug
patching file arch/powerpc/boot/Makefile
patching file arch/powerpc/kernel/Makefile
patching file arch/powerpc/kernel/entry_32.S
patching file arch/powerpc/kernel/idle.c
patching file arch/powerpc/kernel/irq.c
patching file arch/powerpc/kernel/ppc_ksyms.c
patching file arch/powerpc/kernel/semaphore.c
patching file arch/powerpc/kernel/smp.c
patching file arch/powerpc/kernel/time.c
patching file arch/powerpc/kernel/traps.c
patching file arch/powerpc/lib/locks.c
patching file arch/powerpc/mm/fault.c
patching file arch/powerpc/mm/init_32.c
patching file arch/powerpc/mm/tlb_64.c
patching file arch/powerpc/platforms/cell/interrupt.c
patching file arch/powerpc/platforms/cell/smp.c
patching file arch/powerpc/platforms/chrp/smp.c
patching file arch/powerpc/platforms/chrp/time.c
patching file arch/powerpc/platforms/iseries/irq.c
patching file arch/powerpc/platforms/iseries/setup.c
patching file arch/powerpc/platforms/powermac/feature.c
patching file arch/powerpc/platforms/powermac/nvram.c
patching file arch/powerpc/platforms/powermac/pic.c
patching file arch/powerpc/platforms/pseries/setup.c
patching file arch/powerpc/platforms/pseries/smp.c
patching file arch/powerpc/platforms/pseries/xics.c
patching file arch/powerpc/sysdev/mpic.c
patching file arch/ppc/8260_io/enet.c
patching file arch/ppc/8260_io/fcc_enet.c
patching file arch/ppc/8xx_io/commproc.c
patching file arch/ppc/8xx_io/enet.c
patching file arch/ppc/8xx_io/fec.c
patching file arch/ppc/Kconfig
patching file arch/ppc/boot/Makefile
patching file arch/ppc/kernel/dma-mapping.c
patching file arch/ppc/kernel/entry.S
patching file arch/ppc/kernel/semaphore.c
patching file arch/ppc/kernel/smp.c
patching file arch/ppc/kernel/time.c
patching file arch/ppc/kernel/traps.c
patching file arch/ppc/lib/locks.c
patching file arch/ppc/mm/fault.c
patching file arch/ppc/mm/init.c
patching file arch/ppc/platforms/apus_setup.c
patching file arch/ppc/platforms/ev64260.c
patching file arch/ppc/platforms/gemini_setup.c
patching file arch/ppc/platforms/hdpu.c
patching file arch/ppc/platforms/powerpmc250.c
patching file arch/ppc/platforms/prep_setup.c
patching file arch/ppc/platforms/prpmc750.c
patching file arch/ppc/platforms/prpmc800.c
patching file arch/ppc/platforms/sbc82xx.c
patching file arch/ppc/platforms/spruce.c
patching file arch/ppc/syslib/cpm2_common.c
patching file arch/ppc/syslib/i8259.c
patching file arch/ppc/syslib/ibm44x_common.c
patching file arch/ppc/syslib/m8260_setup.c
patching file arch/ppc/syslib/m8xx_setup.c
patching file arch/ppc/syslib/mpc52xx_setup.c
patching file arch/ppc/syslib/ocp.c
patching file arch/ppc/syslib/open_pic.c
patching file arch/ppc/syslib/open_pic2.c
patching file arch/ppc/syslib/ppc4xx_setup.c
patching file arch/ppc/syslib/ppc85xx_setup.c
patching file arch/ppc/syslib/todc_time.c
patching file arch/s390/kernel/time.c
patching file arch/x86_64/Kconfig
patching file arch/x86_64/Makefile
patching file arch/x86_64/defconfig
patching file arch/x86_64/ia32/ia32entry.S
patching file arch/x86_64/kernel/Makefile
patching file arch/x86_64/kernel/apic.c
patching file arch/x86_64/kernel/crash.c
patching file arch/x86_64/kernel/early-quirks.c
patching file arch/x86_64/kernel/early_printk.c
patching file arch/x86_64/kernel/entry.S
patching file arch/x86_64/kernel/genapic.c
patching file arch/x86_64/kernel/genapic_cluster.c
patching file arch/x86_64/kernel/head64.c
patching file arch/x86_64/kernel/hpet.c
patching file arch/x86_64/kernel/i8259.c
patching file arch/x86_64/kernel/io_apic.c
patching file arch/x86_64/kernel/irq.c
Hunk #1 succeeded at 111 (offset 1 line).
patching file arch/x86_64/kernel/mpparse.c
patching file arch/x86_64/kernel/nmi.c
patching file arch/x86_64/kernel/pmtimer.c
patching file arch/x86_64/kernel/process.c
patching file arch/x86_64/kernel/reboot.c
patching file arch/x86_64/kernel/setup64.c
patching file arch/x86_64/kernel/signal.c
patching file arch/x86_64/kernel/smp.c
patching file arch/x86_64/kernel/smpboot.c
patching file arch/x86_64/kernel/time.c
patching file arch/x86_64/kernel/traps.c
patching file arch/x86_64/kernel/tsc.c
patching file arch/x86_64/kernel/tsc_sync.c
patching file arch/x86_64/kernel/vmlinux.lds.S
patching file arch/x86_64/kernel/vsyscall.c
patching file arch/x86_64/kernel/x8664_ksyms.c
patching file arch/x86_64/lib/thunk.S
patching file arch/x86_64/mm/fault.c
patching file arch/x86_64/mm/init.c
patching file block/ll_rw_blk.c
patching file drivers/acpi/ec.c
patching file drivers/acpi/hardware/hwregs.c
patching file drivers/acpi/namespace/nsinit.c
patching file drivers/acpi/osl.c
patching file drivers/acpi/processor_idle.c
patching file drivers/acpi/resources/rscreate.c
patching file drivers/acpi/sleep/main.c
patching file drivers/acpi/tables/tbrsdt.c
patching file drivers/acpi/utilities/utmutex.c
patching file drivers/ata/libata-core.c
Hunk #1 succeeded at 5846 (offset 9 lines).
patching file drivers/ata/pata_mpiix.c
Hunk #1 succeeded at 231 (offset 2 lines).
patching file drivers/ata/pata_pcmcia.c
patching file drivers/ata/pata_pdc2027x.c
patching file drivers/ata/pata_winbond.c
patching file drivers/base/power/suspend.c
patching file drivers/base/power/sysfs.c
patching file drivers/block/floppy.c
patching file drivers/block/paride/pseudo.h
patching file drivers/char/Kconfig
patching file drivers/char/Makefile
patching file drivers/char/blocker.c
patching file drivers/char/drm/i915_irq.c
patching file drivers/char/hangcheck-timer.c
patching file drivers/char/lpptest.c
patching file drivers/char/random.c
patching file drivers/char/rtc.c
patching file drivers/char/sysrq.c
patching file drivers/char/tty_io.c
patching file drivers/char/watchdog/rm9k_wdt.c
patching file drivers/clocksource/acpi_pm.c
patching file drivers/clocksource/cyclone.c
patching file drivers/clocksource/scx200_hrt.c
patching file drivers/ide/ide-floppy.c
patching file drivers/ide/ide-io.c
patching file drivers/ide/ide-iops.c
Hunk #4 succeeded at 742 (offset 11 lines).
patching file drivers/ide/ide-lib.c
patching file drivers/ide/ide-probe.c
patching file drivers/ide/ide-taskfile.c
patching file drivers/ide/pci/alim15x3.c
patching file drivers/ide/pci/cs5530.c
patching file drivers/ide/pci/hpt366.c
patching file drivers/ieee1394/ieee1394_transactions.c
patching file drivers/infiniband/hw/amso1100/c2.c
patching file drivers/infiniband/hw/ehca/ehca_eq.c
patching file drivers/input/ff-memless.c
patching file drivers/input/gameport/gameport.c
patching file drivers/input/keyboard/atkbd.c
patching file drivers/input/mouse/psmouse-base.c
Hunk #1 succeeded at 1551 (offset 28 lines).
patching file drivers/isdn/hysdn/boardergo.c
patching file drivers/isdn/hysdn/hysdn_proclog.c
patching file drivers/isdn/isdnloop/isdnloop.c
patching file drivers/kvm/kvm.h
patching file drivers/kvm/kvm_main.c
patching file drivers/kvm/mmu.c
patching file drivers/kvm/paging_tmpl.h
patching file drivers/kvm/svm.c
patching file drivers/kvm/vmx.c
patching file drivers/kvm/vmx.h
patching file drivers/macintosh/adb.c
patching file drivers/media/dvb/dvb-core/dvb_frontend.c
patching file drivers/media/dvb/dvb-core/dvb_frontend.h
patching file drivers/misc/tifm_7xx1.c
patching file drivers/mtd/devices/Kconfig
patching file drivers/mtd/devices/block2mtd.c
patching file drivers/mtd/nand/cafe.c
patching file drivers/net/3c527.c
patching file drivers/net/3c59x.c
patching file drivers/net/7990.c
patching file drivers/net/8139too.c
patching file drivers/net/e1000/e1000_main.c
patching file drivers/net/ehea/ehea_main.c
patching file drivers/net/hamradio/6pack.c
patching file drivers/net/hamradio/mkiss.c
patching file drivers/net/ibm_emac/ibm_emac_core.c
patching file drivers/net/ibm_emac/ibm_emac_core.h
patching file drivers/net/loopback.c
patching file drivers/net/macb.c
patching file drivers/net/netconsole.c
patching file drivers/net/netxen/netxen_nic_main.c
patching file drivers/net/plip.c
patching file drivers/net/ppp_async.c
patching file drivers/net/ppp_synctty.c
patching file drivers/net/qla3xxx.c
patching file drivers/net/sungem.c
patching file drivers/net/tulip/tulip_core.c
patching file drivers/net/ucc_geth.c
patching file drivers/oprofile/oprofilefs.c
patching file drivers/pci/access.c
patching file drivers/pci/hotplug/cpci_hotplug_core.c
patching file drivers/pci/hotplug/cpqphp_ctrl.c
patching file drivers/pci/hotplug/ibmphp_hpc.c
patching file drivers/pci/hotplug/pciehp_ctrl.c
patching file drivers/pci/msi.c
patching file drivers/pci/pcie/aer/aerdrv.c
patching file drivers/pnp/pnpbios/core.c
patching file drivers/rtc/rtc-omap.c
patching file drivers/rtc/rtc-s3c.c
patching file drivers/scsi/aacraid/aacraid.h
patching file drivers/scsi/aic94xx/aic94xx_init.c
patching file drivers/scsi/arcmsr/arcmsr_hba.c
patching file drivers/scsi/ibmvscsi/ibmvstgt.c
patching file drivers/scsi/qla2xxx/qla_def.h
patching file drivers/scsi/qla4xxx/ql4_os.c
patching file drivers/serial/8250.c
patching file drivers/usb/core/devio.c
patching file drivers/usb/core/hcd.c
patching file drivers/usb/core/message.c
patching file drivers/usb/gadget/pxa2xx_udc.c
patching file drivers/usb/host/ehci-hcd.c
Hunk #1 succeeded at 512 (offset 16 lines).
Hunk #3 succeeded at 636 (offset 16 lines).
patching file drivers/usb/host/ehci-hub.c
Hunk #1 succeeded at 286 (offset 4 lines).
patching file drivers/usb/host/ohci-ep93xx.c
patching file drivers/usb/host/ohci-pnx4008.c
patching file drivers/usb/host/ohci-pnx8550.c
patching file drivers/usb/net/usbnet.c
patching file drivers/usb/storage/usb.h
patching file drivers/video/console/fbcon.c
patching file drivers/video/console/vgacon.c
patching file drivers/video/intelfb/intelfbhw.c
patching file fs/aio.c
patching file fs/block_dev.c
patching file fs/buffer.c
Hunk #2 succeeded at 397 (offset 1 line).
Hunk #4 succeeded at 422 (offset 1 line).
Hunk #6 succeeded at 469 (offset 1 line).
Hunk #8 succeeded at 2974 (offset 1 line).
patching file fs/dcache.c
patching file fs/dnotify.c
patching file fs/dquot.c
patching file fs/exec.c
patching file fs/file.c
patching file fs/file_table.c
patching file fs/isofs/namei.c
patching file fs/jbd/transaction.c
patching file fs/jffs2/erase.c
patching file fs/jffs2/jffs2_fs_i.h
patching file fs/jfs/jfs_txnmgr.c
patching file fs/lockd/svc.c
patching file fs/nfsd/nfsctl.c
patching file fs/ntfs/aops.c
patching file fs/open.c
patching file fs/pipe.c
patching file fs/proc/array.c
patching file fs/proc/generic.c
patching file fs/proc/proc_misc.c
patching file fs/proc/task_mmu.c
patching file fs/select.c
patching file fs/super.c
patching file fs/xfs/linux-2.6/mrlock.h
patching file fs/xfs/linux-2.6/sema.h
patching file fs/xfs/linux-2.6/xfs_buf.h
patching file fs/xfs/xfs_mount.h
patching file include/acpi/acglobal.h
patching file include/acpi/acpiosxf.h
patching file include/acpi/processor.h
patching file include/asm-arm/arch-pxa/timex.h
patching file include/asm-arm/atomic.h
patching file include/asm-arm/dma.h
patching file include/asm-arm/pgalloc.h
patching file include/asm-arm/semaphore.h
patching file include/asm-arm/thread_info.h
patching file include/asm-arm/timex.h
patching file include/asm-arm/tlb.h
patching file include/asm-arm/tlbflush.h
patching file include/asm-arm/unistd.h
patching file include/asm-generic/bug.h
patching file include/asm-generic/percpu.h
patching file include/asm-generic/tlb.h
patching file include/asm-generic/vmlinux.lds.h
patching file include/asm-i386/acpi.h
patching file include/asm-i386/apic.h
patching file include/asm-i386/bugs.h
patching file include/asm-i386/dma.h
patching file include/asm-i386/genapic.h
patching file include/asm-i386/highmem.h
patching file include/asm-i386/hpet.h
patching file include/asm-i386/hypercall.h
patching file include/asm-i386/i8253.h
patching file include/asm-i386/i8259.h
patching file include/asm-i386/io_apic.h
patching file include/asm-i386/irq.h
patching file include/asm-i386/kdebug.h
patching file include/asm-i386/mach-bigsmp/mach_apic.h
patching file include/asm-i386/mach-default/do_timer.h
patching file include/asm-i386/mach-default/irq_vectors.h
patching file include/asm-i386/mach-default/mach_apic.h
patching file include/asm-i386/mach-es7000/mach_apic.h
patching file include/asm-i386/mach-generic/mach_apic.h
patching file include/asm-i386/mach-numaq/mach_apic.h
patching file include/asm-i386/mach-summit/mach_apic.h
patching file include/asm-i386/mach-visws/mach_apic.h
patching file include/asm-i386/mach-voyager/do_timer.h
patching file include/asm-i386/mc146818rtc.h
patching file include/asm-i386/module.h
patching file include/asm-i386/mpspec.h
patching file include/asm-i386/msr.h
patching file include/asm-i386/pgtable.h
patching file include/asm-i386/processor.h
patching file include/asm-i386/rwsem.h
patching file include/asm-i386/semaphore.h
patching file include/asm-i386/spinlock.h
patching file include/asm-i386/spinlock_types.h
patching file include/asm-i386/thread_info.h
patching file include/asm-i386/tlbflush.h
patching file include/asm-i386/tsc.h
patching file include/asm-i386/unwind.h
patching file include/asm-i386/xor.h
patching file include/asm-ia64/irqflags.h
patching file include/asm-ia64/mmu_context.h
patching file include/asm-ia64/percpu.h
patching file include/asm-ia64/processor.h
patching file include/asm-ia64/rtc.h
patching file include/asm-ia64/rwsem.h
patching file include/asm-ia64/sal.h
patching file include/asm-ia64/semaphore.h
patching file include/asm-ia64/spinlock.h
patching file include/asm-ia64/spinlock_types.h
patching file include/asm-ia64/system.h
patching file include/asm-ia64/thread_info.h
patching file include/asm-ia64/tlb.h
patching file include/asm-mips/asmmacro.h
patching file include/asm-mips/atomic.h
patching file include/asm-mips/bitops.h
patching file include/asm-mips/hw_irq.h
patching file include/asm-mips/i8259.h
patching file include/asm-mips/io.h
patching file include/asm-mips/linkage.h
patching file include/asm-mips/m48t35.h
patching file include/asm-mips/mipsregs.h
patching file include/asm-mips/rwsem.h
patching file include/asm-mips/semaphore.h
patching file include/asm-mips/spinlock.h
patching file include/asm-mips/spinlock_types.h
patching file include/asm-mips/system.h
patching file include/asm-mips/thread_info.h
patching file include/asm-mips/time.h
patching file include/asm-mips/timeofday.h
patching file include/asm-mips/uaccess.h
patching file include/asm-powerpc/hw_irq.h
patching file include/asm-powerpc/pmac_feature.h
patching file include/asm-powerpc/rwsem.h
patching file include/asm-powerpc/semaphore.h
patching file include/asm-powerpc/spinlock.h
patching file include/asm-powerpc/spinlock_types.h
patching file include/asm-powerpc/thread_info.h
patching file include/asm-powerpc/time.h
patching file include/asm-ppc/ocp.h
patching file include/asm-ppc/time.h
patching file include/asm-x86_64/acpi.h
patching file include/asm-x86_64/apic.h
patching file include/asm-x86_64/calling.h
patching file include/asm-x86_64/futex.h
patching file include/asm-x86_64/genapic.h
patching file include/asm-x86_64/hpet.h
patching file include/asm-x86_64/hw_irq.h
patching file include/asm-x86_64/hypercall.h
patching file include/asm-x86_64/io_apic.h
patching file include/asm-x86_64/kdebug.h
patching file include/asm-x86_64/nmi.h
patching file include/asm-x86_64/percpu.h
patching file include/asm-x86_64/proto.h
patching file include/asm-x86_64/semaphore.h
patching file include/asm-x86_64/spinlock.h
patching file include/asm-x86_64/spinlock_types.h
patching file include/asm-x86_64/thread_info.h
patching file include/asm-x86_64/timex.h
patching file include/asm-x86_64/tlbflush.h
patching file include/asm-x86_64/tsc.h
patching file include/asm-x86_64/unistd.h
patching file include/asm-x86_64/unwind.h
patching file include/asm-x86_64/vsyscall.h
patching file include/linux/acpi.h
patching file include/linux/acpi_pmtmr.h
patching file include/linux/barrier.h
patching file include/linux/bit_spinlock.h
patching file include/linux/bottom_half.h
patching file include/linux/buffer_head.h
patching file include/linux/clockchips.h
patching file include/linux/clocksource.h
patching file include/linux/completion.h
patching file include/linux/console.h
patching file include/linux/cpu.h
patching file include/linux/device.h
patching file include/linux/fs.h
patching file include/linux/futex.h
patching file include/linux/genhd.h
patching file include/linux/hardirq.h
patching file include/linux/hrtimer.h
patching file include/linux/init_task.h
patching file include/linux/interrupt.h
patching file include/linux/irq.h
patching file include/linux/irqflags.h
patching file include/linux/jbd.h
patching file include/linux/jiffies.h
patching file include/linux/kernel.h
patching file include/linux/kernel_stat.h
patching file include/linux/kprobes.h
patching file include/linux/ktime.h
Hunk #1 succeeded at 265 (offset 4 lines).
patching file include/linux/kvm.h
patching file include/linux/kvm_para.h
patching file include/linux/latency_hist.h
patching file include/linux/linkage.h
patching file include/linux/lock_list.h
patching file include/linux/lockdep.h
Hunk #1 succeeded at 134 (offset 2 lines).
Hunk #3 succeeded at 262 (offset 2 lines).
patching file include/linux/mm.h
patching file include/linux/mutex.h
patching file include/linux/netdevice.h
patching file include/linux/netfilter_ipv4/ip_conntrack.h
patching file include/linux/nmi.h
patching file include/linux/oprofile.h
patching file include/linux/page-flags.h
patching file include/linux/pagemap.h
patching file include/linux/pagevec.h
patching file include/linux/paravirt.h
patching file include/linux/parport.h
patching file include/linux/percpu.h
patching file include/linux/percpu_counter.h
patching file include/linux/plist.h
patching file include/linux/posix-timers.h
patching file include/linux/prctl.h
patching file include/linux/preempt.h
patching file include/linux/proc_fs.h
patching file include/linux/profile.h
patching file include/linux/radix-tree.h
patching file include/linux/rcuclassic.h
patching file include/linux/rcupdate.h
patching file include/linux/rcupreempt.h
patching file include/linux/rcupreempt_trace.h
patching file include/linux/rt_lock.h
patching file include/linux/rtmutex.h
patching file include/linux/rwsem-spinlock.h
patching file include/linux/rwsem.h
patching file include/linux/sched.h
patching file include/linux/semaphore.h
patching file include/linux/seqlock.h
patching file include/linux/smp.h
patching file include/linux/smp_lock.h
patching file include/linux/spinlock.h
patching file include/linux/spinlock_api_smp.h
patching file include/linux/spinlock_api_up.h
patching file include/linux/spinlock_types.h
patching file include/linux/spinlock_types_up.h
patching file include/linux/spinlock_up.h
patching file include/linux/syscalls.h
patching file include/linux/tick.h
patching file include/linux/time.h
patching file include/linux/timer.h
patching file include/linux/timex.h
patching file include/linux/uaccess.h
patching file include/linux/unwind.h
patching file include/linux/vmstat.h
patching file include/linux/wait.h
patching file include/linux/workqueue.h
patching file include/net/dn_dev.h
patching file include/net/inet_hashtables.h
patching file include/net/netfilter/nf_conntrack.h
patching file include/net/netfilter/nf_conntrack_ecache.h
patching file include/net/sock.h
patching file include/scsi/libsas.h
patching file init/main.c
patching file ipc/mqueue.c
patching file ipc/msg.c
patching file ipc/sem.c
patching file kernel/Kconfig.preempt
patching file kernel/Makefile
patching file kernel/audit.c
patching file kernel/auditfilter.c
patching file kernel/exit.c
patching file kernel/fork.c
Hunk #9 succeeded at 975 with fuzz 1.
patching file kernel/futex.c
Hunk #12 succeeded at 633 (offset 1 line).
Hunk #13 succeeded at 709 (offset 1 line).
Hunk #14 succeeded at 963 (offset 1 line).
Hunk #15 succeeded at 977 (offset 1 line).
Hunk #16 succeeded at 991 (offset 1 line).
Hunk #17 succeeded at 1005 (offset 1 line).
Hunk #18 succeeded at 1067 (offset 1 line).
Hunk #19 succeeded at 1078 (offset 1 line).
Hunk #20 succeeded at 1090 (offset 1 line).
Hunk #21 succeeded at 1104 (offset 1 line).
Hunk #22 succeeded at 1117 (offset 1 line).
Hunk #23 succeeded at 1150 (offset 1 line).
Hunk #24 succeeded at 1166 (offset 1 line).
Hunk #25 succeeded at 1177 (offset 1 line).
Hunk #26 succeeded at 1200 (offset 1 line).
Hunk #27 succeeded at 1225 (offset 1 line).
Hunk #28 succeeded at 1281 (offset 1 line).
Hunk #29 succeeded at 1296 (offset 1 line).
Hunk #30 succeeded at 1375 (offset 1 line).
Hunk #31 succeeded at 1429 (offset 1 line).
Hunk #32 succeeded at 1462 (offset 1 line).
Hunk #33 succeeded at 1502 (offset 1 line).
Hunk #34 succeeded at 1582 (offset 1 line).
Hunk #35 succeeded at 1663 (offset 1 line).
Hunk #36 succeeded at 1683 (offset 1 line).
Hunk #37 succeeded at 1704 (offset 1 line).
Hunk #38 succeeded at 1726 (offset 1 line).
Hunk #39 succeeded at 1799 (offset 1 line).
Hunk #40 succeeded at 1812 (offset 1 line).
Hunk #41 succeeded at 1863 (offset 1 line).
Hunk #42 succeeded at 1878 (offset 1 line).
Hunk #43 succeeded at 1914 (offset 1 line).
Hunk #44 succeeded at 1939 (offset 1 line).
Hunk #45 succeeded at 1959 (offset 1 line).
Hunk #46 succeeded at 1991 (offset 1 line).
Hunk #47 succeeded at 2052 (offset 1 line).
Hunk #48 succeeded at 2068 (offset 1 line).
Hunk #49 succeeded at 2181 (offset 1 line).
Hunk #50 succeeded at 2279 (offset 1 line).
Hunk #51 succeeded at 2305 (offset 1 line).
Hunk #52 succeeded at 2322 (offset 1 line).
Hunk #53 succeeded at 3632 (offset 1 line).
patching file kernel/futex_compat.c
patching file kernel/hrtimer.c
Hunk #15 succeeded at 662 (offset 6 lines).
Hunk #17 succeeded at 818 (offset 6 lines).
Hunk #19 succeeded at 845 (offset 6 lines).
Hunk #21 succeeded at 898 (offset 6 lines).
Hunk #23 succeeded at 930 (offset 6 lines).
Hunk #25 succeeded at 1000 (offset 6 lines).
Hunk #27 succeeded at 1275 (offset 6 lines).
Hunk #29 succeeded at 1308 (offset 6 lines).
Hunk #31 succeeded at 1377 (offset 6 lines).
Hunk #33 succeeded at 1461 (offset 6 lines).
patching file kernel/irq/autoprobe.c
patching file kernel/irq/chip.c
patching file kernel/irq/handle.c
patching file kernel/irq/internals.h
patching file kernel/irq/manage.c
patching file kernel/irq/proc.c
patching file kernel/irq/spurious.c
patching file kernel/itimer.c
patching file kernel/kprobes.c
patching file kernel/latency_hist.c
patching file kernel/latency_trace.c
patching file kernel/lockdep.c
patching file kernel/lockdep_internals.h
patching file kernel/lockdep_proc.c
patching file kernel/module.c
patching file kernel/panic.c
patching file kernel/posix-cpu-timers.c
patching file kernel/posix-timers.c
patching file kernel/power/pm.c
patching file kernel/power/swsusp.c
patching file kernel/printk.c
patching file kernel/profile.c
patching file kernel/rcuclassic.c
patching file kernel/rcupdate.c
patching file kernel/rcupreempt.c
patching file kernel/rcupreempt_trace.c
patching file kernel/rcutorture.c
patching file kernel/rt.c
patching file kernel/rtmutex-debug.c
patching file kernel/rtmutex-debug.h
patching file kernel/rtmutex.c
patching file kernel/rtmutex_common.h
patching file kernel/rwsem.c
patching file kernel/sched.c
Hunk #46 succeeded at 3996 with fuzz 1.
patching file kernel/signal.c
patching file kernel/softirq.c
patching file kernel/softlockup.c
patching file kernel/spinlock.c
patching file kernel/stop_machine.c
patching file kernel/sys.c
patching file kernel/sys_ni.c
patching file kernel/sysctl.c
patching file kernel/time.c
patching file kernel/time/Kconfig
patching file kernel/time/Makefile
patching file kernel/time/clockevents.c
patching file kernel/time/clocksource.c
Hunk #1 succeeded at 29 (offset 1 line).
Hunk #3 succeeded at 64 (offset 1 line).
Hunk #5 succeeded at 260 (offset 1 line).
Hunk #7 succeeded at 336 (offset 1 line).
patching file kernel/time/jiffies.c
patching file kernel/time/ntp.c
patching file kernel/time/tick-broadcast.c
patching file kernel/time/tick-common.c
patching file kernel/time/tick-internal.h
patching file kernel/time/tick-oneshot.c
patching file kernel/time/tick-sched.c
patching file kernel/time/timer_list.c
patching file kernel/time/timer_stats.c
patching file kernel/timer.c
patching file kernel/tsacct.c
patching file kernel/unwind.c
patching file kernel/user.c
patching file kernel/workqueue.c
patching file lib/Kconfig.debug
patching file lib/Makefile
patching file lib/debug_locks.c
patching file lib/dec_and_lock.c
patching file lib/fault-inject.c
patching file lib/kernel_lock.c
patching file lib/lock_list.c
patching file lib/locking-selftest.c
patching file lib/plist.c
patching file lib/radix-tree.c
patching file lib/rwsem-spinlock.c
patching file lib/rwsem.c
patching file lib/semaphore-sleepers.c
patching file lib/smp_processor_id.c
patching file lib/spinlock_debug.c
patching file mm/bounce.c
patching file mm/filemap.c
patching file mm/highmem.c
patching file mm/memory.c
patching file mm/migrate.c
patching file mm/mmap.c
patching file mm/page-writeback.c
Hunk #1 succeeded at 958 (offset 9 lines).
patching file mm/page_alloc.c
patching file mm/readahead.c
patching file mm/slab.c
patching file mm/slob.c
patching file mm/swap.c
patching file mm/swap_state.c
patching file mm/vmscan.c
patching file mm/vmstat.c
patching file net/core/dev.c
patching file net/core/flow.c
patching file net/core/netpoll.c
patching file net/core/sock.c
patching file net/decnet/dn_dev.c
patching file net/ipv4/icmp.c
patching file net/ipv4/multipath_wrandom.c
patching file net/ipv4/netfilter/arp_tables.c
patching file net/ipv4/netfilter/ip_conntrack_core.c
patching file net/ipv4/netfilter/ip_conntrack_standalone.c
patching file net/ipv4/netfilter/ip_tables.c
patching file net/ipv4/route.c
patching file net/ipv4/tcp.c
patching file net/ipv4/tcp_ipv4.c
patching file net/ipv6/netfilter/ip6_tables.c
patching file net/netfilter/nf_conntrack_core.c
patching file net/netfilter/nf_conntrack_ecache.c
patching file net/sched/sch_generic.c
patching file net/sunrpc/svc.c
Hunk #1 succeeded at 456 (offset 1 line).
patching file net/unix/af_unix.c
patching file scripts/Makefile
patching file scripts/testlpp.c
patching file scripts/trace-it.c
patching file security/Kconfig
patching file security/Makefile
patching file security/realcap.c
patching file security/selinux/avc.c
patching file security/selinux/netif.c
patching file security/selinux/selinuxfs.c
patching file sound/core/control_compat.c
patching file sound/core/pcm_lib.c
patching file sound/pci/pcxhr/pcxhr.c

--------------020803010609090106030602--

