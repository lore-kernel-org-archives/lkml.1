Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbXHTQ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbXHTQ4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760322AbXHTQ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:56:09 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:58656 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1759559AbXHTQ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:56:08 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2007 12:56:07 EDT
Date: Mon, 20 Aug 2007 20:55:30 +0400
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
To: RT <linux-rt-users@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kbaidarov@ru.mvista.com
Subject: [PATCH] kexec: reenable HPET before kexec
Message-ID: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.19; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I've faced problem:
I have two x86_64 kernels with HPET enabled:
kernel 1 - with PM enabled,
kernel 2 - with PM disabled.
When I execute kernel 2 from kernel 1 on pentiumd based PC, kernel 2 hangs
during boot:
root@192.168.40.10:~#
root@192.168.40.10:~# ./kexec.sh ./ko_bzImage_x86_64_nopm
+ kexec -l ././ko_bzImage_x86_64_nopm '--command-line=kdb=on kdb=early
apic=debug nmi_watchdog=0 console=ttyS0
,115200 ip=bootp root=/dev/nfs rw'
+ kexec -e
md: stopping all md devices.
sd 1:0:0:0: [sda] Synchronizing SCSI cache
ACPI: PCI interrupt for device 0000:01:00.0 disabled
Starting new kernel
Linux version 2.6.23-rc2 (root@pentiumdcge.dev.rtsoft.ru) (gcc version 4.2.0
(MontaVista 4.2.0-8.0.0.0703430 2
007-06-22)) #3 SMP PREEMPT Mon Aug 20 20:26:17 MSD 2007
Command line: kdb=on kdb=early apic=debug nmi_watchdog=0 console=ttyS0,115200
ip=bootp root=/dev/nfs rw
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001f790000 (usable)
 BIOS-e820: 000000001f790000 - 000000001f79e000 (ACPI data)
 BIOS-e820: 000000001f79e000 - 000000001f7e0000 (ACPI NVS)
 BIOS-e820: 000000001f7e0000 - 000000001f800000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
end_pfn_map = 1048576
DMI 2.3 present.
Zone PFN ranges:
  DMA             1 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        1 ->      159
    0:      256 ->   128912
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: INTEL    MPTABLE: Product ID:  MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
I/O APIC #2 at 0xFEC00000.
Setting APIC routing to flat
Processors: 2
mapped APIC to ffffffffff5fb000 (        fee00000)
mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
Allocating PCI resources starting at 20000000 (gap: 1f800000:e0380000)
PERCPU: Allocating 31696 bytes of per cpu data
Built 1 zonelists in Zone order.  Total pages: 125250
Kernel command line: kdb=on kdb=early apic=debug nmi_watchdog=0
console=ttyS0,115200 ip=bootp root=/dev/nfs rw
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 16384 bytes)
time.c: Detected 3000.006 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Checking aperture...
Memory: 500048k/515648k available (4577k kernel code, 15136k reserved, 1755k
data, 280k init)
-------------------------------- kernel hangs here --------------------------

Root case:
When kernel 1 switches to Local APIC timer It disables HPET.
When kernel 1 executes kernel 2, HPET isn't reenabled early during boot, because
PM and ACPI is disabled and kernel 2 doesn't search for HPET in ACPI tables.
HPET is disabled, so kernel enables PIT timer, but it doesn't work on pentiumd
(don't know why).
HPET is disabled, PIT isn't work - IRQ0 isn't triggered jiffies isn't
incremented so kernel hangs in calibrate_delay().

How solved:
I reenable HPET timer in machine_kexec() before switching to kernel 2.

Also on some machines I can reproduce bug with i386 kernel from kernel.org, so
I i386 kernel might be fixed too, so I'm adding lkml to cc. Thanks.

Patch against patch-2.6.23-rc2-rt2.

Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>

Index: linux-2.6.23-rc2-kexec-pm/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.23-rc2-kexec-pm.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.23-rc2-kexec-pm/arch/i386/kernel/hpet.c
@@ -443,6 +443,22 @@ static __init int hpet_late_init(void)
 }
 fs_initcall(hpet_late_init);
 
+#ifdef CONFIG_KEXEC
+/*
+ * reenable HPET timer
+ */
+int hpet_reenable(void)
+{
+	if (!is_hpet_capable())
+		return -1;
+
+	if (hpet_clockevent.mode != CLOCK_EVT_MODE_PERIODIC)
+		hpet_legacy_set_mode(CLOCK_EVT_MODE_PERIODIC, &hpet_clockevent);
+
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 /* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET
Index: linux-2.6.23-rc2-kexec-pm/arch/x86_64/kernel/machine_kexec.c
===================================================================
--- linux-2.6.23-rc2-kexec-pm.orig/arch/x86_64/kernel/machine_kexec.c
+++ linux-2.6.23-rc2-kexec-pm/arch/x86_64/kernel/machine_kexec.c
@@ -14,6 +14,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
+#include <asm/hpet.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u64 kexec_pgd[512] PAGE_ALIGNED;
@@ -183,6 +184,10 @@ NORET_TYPE void machine_kexec(struct kim
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
 
+#ifdef CONFIG_HPET_TIMER
+	hpet_reenable();
+#endif
+
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
 
Index: linux-2.6.23-rc2-kexec-pm/arch/i386/kernel/machine_kexec.c
===================================================================
--- linux-2.6.23-rc2-kexec-pm.orig/arch/i386/kernel/machine_kexec.c
+++ linux-2.6.23-rc2-kexec-pm/arch/i386/kernel/machine_kexec.c
@@ -19,6 +19,7 @@
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
 #include <asm/system.h>
+#include <asm/hpet.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u32 kexec_pgd[1024] PAGE_ALIGNED;
@@ -106,6 +107,10 @@ NORET_TYPE void machine_kexec(struct kim
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
 
+#ifdef CONFIG_HPET_TIMER
+	hpet_reenable();
+#endif
+
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
 
Index: linux-2.6.23-rc2-kexec-pm/include/asm-i386/hpet.h
===================================================================
--- linux-2.6.23-rc2-kexec-pm.orig/include/asm-i386/hpet.h
+++ linux-2.6.23-rc2-kexec-pm/include/asm-i386/hpet.h
@@ -67,6 +67,9 @@ extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
+#ifdef CONFIG_KEXEC
+extern int hpet_reenable(void);
+#endif
 extern unsigned long hpet_readl(unsigned long a);
 extern void force_hpet_resume(void);
