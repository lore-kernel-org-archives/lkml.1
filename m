Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbYGTNAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbYGTNAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 09:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbYGTNAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 09:00:35 -0400
Received: from www17.your-server.de ([213.133.104.17]:58688 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbYGTNAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 09:00:33 -0400
Subject: [OOPS] kmem_cache_alloc (next-20080718)
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 20 Jul 2008 15:00:26 +0200
Message-Id: <1216558826.3118.9.camel@dhcppc2>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got this patch on top of next-20080718:

diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index e23399c..b566516 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -108,7 +108,13 @@ static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
 	entry->end = end;
 	entry->type = type;
 	INIT_LIST_HEAD(&entry->list);
-	kobject_init(&entry->kobj, &memmap_ktype);
+	/*
+	 * don't init the kobject here since it calls kmalloc() internally
+	 * which we are not ready to do in firmware_map_add_early() case
+	 * Instead, do that before kobject_add() in memmap_init()
+	 */
+	memset(&entry->kobj, 0, sizeof(struct kobject));
+
 
 	list_add_tail(&entry->list, &map_entries);
 
@@ -195,6 +201,7 @@ static int __init memmap_init(void)
 		return -ENOMEM;
 
 	list_for_each_entry(entry, &map_entries, list) {
+		kobject_init(&entry->kobj, &memmap_ktype);
 		entry->kobj.kset = memmap_kset;
 		kobject_add(&entry->kobj, NULL, "%d", i++);
 	}
diff --git a/fs/namei.c b/fs/namei.c
index a15c155..33dc63d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -286,7 +286,8 @@ int permission(struct inode *inode, int mask, struct nameidata *nd)
 	if (retval)
 		return retval;
 
-	return security_inode_permission(inode, mask);
+	return security_inode_permission(inode,
+					 mask & (MAY_READ|MAY_WRITE|MAY_EXEC));
 }
 
 /**
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index b91a5de..2240a9e 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -44,13 +44,6 @@ static struct ctl_table_root net_sysctl_root = {
 	.lookup = net_ctl_header_lookup,
 };
 
-static LIST_HEAD(net_sysctl_ro_tables);
-static struct list_head *net_ctl_ro_header_lookup(struct ctl_table_root *root,
-		struct nsproxy *namespaces)
-{
-	return &net_sysctl_ro_tables;
-}
-
 static int net_ctl_ro_header_perms(struct ctl_table_root *root,
 		struct nsproxy *namespaces, struct ctl_table *table)
 {
@@ -61,7 +54,6 @@ static int net_ctl_ro_header_perms(struct ctl_table_root *root,
 }
 
 static struct ctl_table_root net_sysctl_ro_root = {
-	.lookup = net_ctl_ro_header_lookup,
 	.permissions = net_ctl_ro_header_perms,
 };
 
@@ -89,6 +81,7 @@ static __init int sysctl_init(void)
 	if (ret)
 		goto out;
 	register_sysctl_root(&net_sysctl_root);
+	setup_sysctl_set(&net_sysctl_ro_root.default_set, NULL, NULL);
 	register_sysctl_root(&net_sysctl_ro_root);
 out:
 	return ret;


This leads to the following oops:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.26-next-20080718 (thomas@dhcppc2) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #18 SMP Sun Jul 20 14:32:29 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffd0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffd0000 - 00000000bffde000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffde000 - 00000000c0000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] last_pfn = 0x1c0000 max_arch_pfn = 0x1000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] RAMDISK: 37cfe000 - 37fef176
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98B0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT BFFD0000, 003C (r1 MSIISM OEMRSDT   4000807 MSFT       97)
[    0.000000] ACPI: FACP BFFD0200, 0084 (r2 MSIISM OEMFACP   4000807 MSFT       97)
[    0.000000] ACPI: DSDT BFFD0440, 5045 (r1  1ADGH 1ADGH013       13 INTL 20051117)
[    0.000000] ACPI: FACS BFFDE000, 0040
[    0.000000] ACPI: APIC BFFD0390, 0070 (r1 MSIISM OEMAPIC   4000807 MSFT       97)
[    0.000000] ACPI: MCFG BFFD0400, 003C (r1 MSIISM OEMMCFG   4000807 MSFT       97)
[    0.000000] ACPI: OEMB BFFDE040, 0061 (r1 MSIISM AMI_OEM   4000807 MSFT       97)
[    0.000000] ACPI: HPET BFFD5490, 0038 (r1 MSIISM OEMHPET0  4000807 MSFT       97)
[    0.000000] ACPI: SSDT BFFD54D0, 028A (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] 6272MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 38000000
[    0.000000]   low ram: 00000000 - 38000000
[    0.000000]   bootmap 00008000 - 0000f000
[    0.000000] (9 early reservations) ==> bootmem
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000400000 - 0000877ef8]    TEXT DATA BSS ==> [0000400000 - 0000877ef8]
[    0.000000]   #4 [0037cfe000 - 0037fef176]          RAMDISK ==> [0037cfe000 - 0037fef176]
[    0.000000]   #5 [0000878000 - 0000881000]    INIT_PG_TABLE ==> [0000878000 - 0000881000]
[    0.000000]   #6 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #7 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00038000
[    0.000000]   HighMem  0x00038000 -> 0x001c0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bffd0
[    0.000000]     0: 0x00100000 -> 0x001c0000
[    0.000000] Using APIC driver default
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
[    0.000000] PERCPU: Allocating 31028 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1558383
[    0.000000] Kernel command line: ro root=LABEL=ROOT rhgb netconsole=@192.168.3.1/,@192.168.3.2/ forcedeth.poll_interval=65534
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 2600.008 MHz processor.
[    0.001999] Console: colour VGA+ 80x25
[    0.001999] console [tty0] enabled
[    0.001999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.001999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.001999] Memory: 6223936k/7340032k available (2307k kernel code, 65996k reserved, 1153k data, 268k init, 5373760k highmem)
[    0.001999] virtual kernel memory layout:
[    0.001999]     fixmap  : 0xffe18000 - 0xfffff000   (1948 kB)
[    0.001999]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.001999]     vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
[    0.001999]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.001999]       .init : 0xc0767000 - 0xc07aa000   ( 268 kB)
[    0.001999]       .data : 0xc0640cb6 - 0xc07613f8   (1153 kB)
[    0.001999]       .text : 0xc0400000 - 0xc0640cb6   (2307 kB)
[    0.001999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.001999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.001999] Calibrating delay loop (skipped), value calculated using timer frequency.. <6>5200.01 BogoMIPS (lpj=2600008)
[    0.001999] Security Framework initialized
[    0.001999] SELinux:  Initializing.
[    0.001999] Mount-cache hash table entries: 512
[    0.001999] Initializing cgroup subsys ns
[    0.001999] Initializing cgroup subsys cpuacct
[    0.001999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001999] CPU 0(2) -> Core 0
[    0.001999] Intel machine check architecture supported.
[    0.001999] Intel machine check reporting enabled on CPU#0.
[    0.001999] using C1E aware idle routine
[    0.001999] Checking 'hlt' instruction... OK.
[    0.004951] ACPI: Core revision 20080609
[    0.011135] ENABLING IO-APIC IRQs
[    0.011347] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.021577] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.021996] Booting processor 1/1 ip 6000
[    0.031995] Initializing CPU#1
[    0.092651] Calibrating delay using timer specific routine.. <6>5199.68 BogoMIPS (lpj=2599844)
[    0.092658] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.092659] CPU: L2 Cache: 512K (64 bytes/line)
[    0.092661] CPU 1(2) -> Core 1
[    0.092663] Intel machine check architecture supported.
[    0.092664] Intel machine check reporting enabled on CPU#1.
[    0.092840] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.092806] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.092985] Brought up 2 CPUs
[    0.092985] Total of 2 processors activated (10399.70 BogoMIPS).
[    0.093313] net_namespace: 732 bytes
[    0.093553] NET: Registered protocol family 16
[    0.093776] No dock devices found.
[    0.093911] ACPI: bus type pci registered
[    0.094015] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.094064] PCI: Not using MMCONFIG.
[    0.094660] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=7
[    0.094708] PCI: Using configuration type 1 for base access
[    0.104980] ACPI: Interpreter enabled
[    0.105029] ACPI: (supports S0 S1 S3 S4 S5)
[    0.105173] ACPI: Using IOAPIC for interrupt routing
[    0.105258] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.110066] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.110114] PCI: Using MMCONFIG for extended config space
[    0.118565] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.118815] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.118867] pci 0000:00:01.1: PME# disabled
[    0.118944] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.118995] pci 0000:00:02.0: PME# disabled
[    0.119069] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119118] pci 0000:00:02.1: PME# disabled
[    0.119301] pci 0000:00:06.1: PME# supported from D3hot D3cold
[    0.119350] pci 0000:00:06.1: PME# disabled
[    0.119437] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119486] pci 0000:00:08.0: PME# disabled
[    0.119569] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119619] pci 0000:00:09.0: PME# disabled
[    0.119683] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119731] pci 0000:00:0a.0: PME# disabled
[    0.119796] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119845] pci 0000:00:0b.0: PME# disabled
[    0.119908] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119957] pci 0000:00:0c.0: PME# disabled
[    0.120021] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.120069] pci 0000:00:0d.0: PME# disabled
[    0.120132] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.120180] pci 0000:00:0e.0: PME# disabled
[    0.120242] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.120290] pci 0000:00:0f.0: PME# disabled
[    0.120405] pci 0000:00:06.0: transparent bridge
[    0.130686] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
[    0.131700] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
[    0.132154] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.132905] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.132979] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[    0.133453] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.133807] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *10
[    0.134163] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disabled.
[    0.134543] ACPI: PCI Interrupt Link [LUB0] (IRQs 21 22 23) *7
[    0.134884] ACPI: PCI Interrupt Link [LMAD] (IRQs 20) *5
[    0.135188] ACPI: PCI Interrupt Link [LUB2] (IRQs 21 22 23) *10
[    0.135526] ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *11
[    0.135825] ACPI: PCI Interrupt Link [LAZA] (IRQs 21 22 23) *10
[    0.135979] ACPI: PCI Interrupt Link [LSMB] (IRQs 21 22 23) *11
[    0.136312] ACPI: PCI Interrupt Link [LPMU] (IRQs 21 22 23) *5
[    0.136644] ACPI: PCI Interrupt Link [LSA0] (IRQs 21 22 23) *11
[    0.136978] ACPI: PCI Interrupt Link [LSA1] (IRQs 21 22 23) *5
[    0.137358] ACPI: PCI Interrupt Link [LATA] (IRQs 21 22 23) *0, disabled.
[    0.137724] ACPI: PCI Interrupt Link [LSA2] (IRQs 21 22 23) *10
[    0.138034] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.138109] pnp: PnP ACPI init
[    0.138162] ACPI: bus type pnp registered
[    0.142438] pnp: PnP ACPI: found 14 devices
[    0.142486] ACPI: ACPI bus type pnp unregistered
[    0.142723] usbcore: registered new interface driver usbfs
[    0.142810] usbcore: registered new interface driver hub
[    0.142903] usbcore: registered new device driver usb
[    0.143081] PCI: Using ACPI for IRQ routing
[    0.143984] NetLabel: Initializing
[    0.144032] NetLabel:  domain hash size = 128
[    0.144078] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.144134] NetLabel:  unlabeled traffic allowed by default
[    0.144188] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.144313] hpet0: 3 32-bit timers, 25000000 Hz
[    0.145655] tracer: 772 pages allocated for 65536 entries of 48 bytes
[    0.145689]    actual entries 65620
[    0.148403] ACPI: RTC can wake from S4
[    0.149867] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.149916] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.149968] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.150016] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.150065] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.150119] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.150167] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.150216] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.150265] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.150313] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.150363] system 00:05: iomem range 0xfea80000-0xfeabffff has been reserved
[    0.150412] system 00:05: iomem range 0xfee01000-0xfeefffff could not be reserved
[    0.150490] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.150566] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.150644] system 00:0a: ioport range 0xa00-0xa0f has been reserved
[    0.150693] system 00:0a: ioport range 0xa10-0xa1f has been reserved
[    0.150744] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.150795] system 00:0c: iomem range 0xd0000000-0xdfffffff could not be reserved
[    0.150879] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.150927] system 00:0d: iomem range 0xc0000-0xcffff could not be reserved
[    0.150976] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.151025] system 00:0d: iomem range 0x100000-0xbfffffff could not be reserved
[    0.151105] system 00:0d: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.181811] pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
[    0.181866] pci 0000:00:06.0:   IO window: disabled
[    0.181917] pci 0000:00:06.0:   MEM window: disabled
[    0.181965] pci 0000:00:06.0:   PREFETCH window: disabled
[    0.182014] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
[    0.182062] pci 0000:00:0a.0:   IO window: disabled
[    0.182114] pci 0000:00:0a.0:   MEM window: disabled
[    0.182161] pci 0000:00:0a.0:   PREFETCH window: disabled
[    0.182210] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
[    0.182258] pci 0000:00:0b.0:   IO window: disabled
[    0.182306] pci 0000:00:0b.0:   MEM window: disabled
[    0.182354] pci 0000:00:0b.0:   PREFETCH window: disabled
[    0.182402] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
[    0.182451] pci 0000:00:0c.0:   IO window: disabled
[    0.182498] pci 0000:00:0c.0:   MEM window: disabled
[    0.182546] pci 0000:00:0c.0:   PREFETCH window: disabled
[    0.182595] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:05
[    0.182642] pci 0000:00:0d.0:   IO window: disabled
[    0.182690] pci 0000:00:0d.0:   MEM window: disabled
[    0.182738] pci 0000:00:0d.0:   PREFETCH window: disabled
[    0.182787] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:06
[    0.182835] pci 0000:00:0e.0:   IO window: disabled
[    0.182889] pci 0000:00:0e.0:   MEM window: disabled
[    0.182936] pci 0000:00:0e.0:   PREFETCH window: disabled
[    0.182986] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:07
[    0.183034] pci 0000:00:0f.0:   IO window: 0xe000-0xefff
[    0.183082] pci 0000:00:0f.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.183136] pci 0000:00:0f.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
[    0.183249] NET: Registered protocol family 2
[    0.186895] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.187167] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.187874] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.188240] TCP: Hash tables configured (established 131072 bind 65536)
[    0.188289] TCP reno registered
[    0.189917] NET: Registered protocol family 1
[    0.190062] checking if image is initramfs... it is
[    0.362145] Freeing initrd memory: 3012k freed
[    0.362838] Machine check exception polling timer started.
[    0.363284] audit: initializing netlink socket (disabled)
[    0.363348] type=2000 audit(1216564922.362:1): initialized
[    0.367792] highmem bounce pool size: 64 pages
[    0.367841] Total HugeTLB memory allocated, 0
[    0.370017] VFS: Disk quotas dquot_6.5.1
[    0.370144] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.370329] msgmni has been set to 1668
[    0.370622] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.370697] io scheduler noop registered
[    0.370744] io scheduler anticipatory registered
[    0.370792] io scheduler deadline registered
[    0.370846] io scheduler cfq registered (default)
[    0.370923] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.412137] pci 0000:00:05.0: Enabling HT MSI Mapping
[    0.412195] pci 0000:00:05.1: Enabling HT MSI Mapping
[    0.412252] pci 0000:00:05.2: Enabling HT MSI Mapping
[    0.412308] pci 0000:00:06.0: Enabling HT MSI Mapping
[    0.412366] pci 0000:00:06.1: Enabling HT MSI Mapping
[    0.412425] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.412484] pci 0000:00:09.0: Enabling HT MSI Mapping
[    0.413093] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.413151] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.413208] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.413265] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.413316] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.413316] pci 0000:00:0f.0: Enabling HT MSI Mapping
[    0.413316] pcieport-driver 0000:00:0a.0: found MSI capability
[    0.413316] pcieport-driver 0000:00:0b.0: found MSI capability
[    0.413316] pcieport-driver 0000:00:0c.0: found MSI capability
[    0.413316] pcieport-driver 0000:00:0d.0: found MSI capability
[    0.413316] pcieport-driver 0000:00:0e.0: found MSI capability
[    0.413316] pcieport-driver 0000:00:0f.0: found MSI capability
[    0.413316] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.413316] processor ACPI0007:00: registered as cooling_device0
[    0.413316] processor ACPI0007:01: registered as cooling_device1
[    0.413316] isapnp: Scanning for PnP cards...
[    0.754253] isapnp: No Plug & Play device found
[    0.757081] Non-volatile memory driver v1.2
[    0.757134] Linux agpgart interface v0.103
[    0.757541] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    0.759405] brd: module loaded
[    0.759465] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[    0.759797] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
[    0.759852] forcedeth 0000:00:08.0: PCI INT A -> Link[LMAC] -> GSI 20 (level, low) -> IRQ 20
[    1.274435] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x1c1 @ 0, addr 00:16:17:45:c9:df
[    1.274511] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[    1.274826] ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 20
[    1.274875] forcedeth 0000:00:09.0: PCI INT A -> Link[LMAD] -> GSI 20 (level, low) -> IRQ 20
[    1.788414] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x1c1 @ 1, addr 00:16:17:45:c9:de
[    1.788489] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[    1.788612] netconsole: local port 6665
[    1.788660] netconsole: local IP 192.168.3.1
[    1.788707] netconsole: interface eth0
[    1.788754] netconsole: remote port 6666
[    1.788801] netconsole: remote IP 192.168.3.2
[    1.788849] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[    1.788897] netconsole: device eth0 not up yet, forcing it
[    1.789253] eth0: no link during initialization.
[    3.803675] eth0: link up.
[    3.805107] console [netcon0] enabled
[    3.821844] netconsole: network logging started
[    3.822848] input: Macintosh mouse button emulation as /class/input/input0
[    3.823175] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    3.825908] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.825960] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.826191] mice: PS/2 mouse device common for all mice
[    3.869616] cpuidle: using governor ladder
[    3.869665] cpuidle: using governor menu
[    3.869827] usbcore: registered new interface driver hiddev
[    3.869916] usbcore: registered new interface driver usbhid
[    3.869968] usbhid: v2.6:USB HID core driver
[    3.870456] TCP cubic registered
[    3.870504] Initializing XFRM netlink socket
[    3.870559] NET: Registered protocol family 17
[    3.870634] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ processors (2 cpu cores) (version 2.20.00)
[    3.872012] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[    3.872065] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[    3.872114] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[    3.872163] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[    3.872212] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[    3.872266] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[    3.872375] Using IPI No-Shortcut mode
[    3.872579] registered taskstats version 1
[    3.872923] Freeing unused kernel memory: 268k freed
[    3.872988] Write protecting the kernel text: 2308k
[    3.873062] Write protecting the kernel read-only data: 956k
[    4.133072] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
[    4.133135] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23 (level, low) -> IRQ 23
[    4.133221] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    4.133343] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    4.133437] ehci_hcd 0000:00:02.1: debug port 1
[    4.133501] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfeafac00
[    4.140005] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    4.140142] usb usb1: configuration #1 chosen from 1 choice
[    4.140210] hub 1-0:1.0: USB hub found
[    4.140267] hub 1-0:1.0: 10 ports detected
[    4.344351] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
[    4.344419] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22 (level, low) -> IRQ 22
[    4.344509] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    4.344612] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    4.344707] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfeafb000
[    4.397050] usb usb2: configuration #1 chosen from 1 choice
[    4.397121] hub 2-0:1.0: USB hub found
[    4.397176] hub 2-0:1.0: 10 ports detected
[    4.443001] usb 1-4: new high speed USB device using ehci_hcd and address 2
[    4.501647] USB Universal Host Controller Interface driver v3.0
[    4.564455] device-mapper: uevent: version 1.0.3
[    4.564599] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    4.567000] usb 1-4: configuration #1 chosen from 1 choice
[    4.635109] padlock: VIA PadLock not detected.
[    4.669006] usb 1-6: new high speed USB device using ehci_hcd and address 3
[    4.711126] padlock: VIA PadLock Hash Engine not detected.
[    4.786968] SCSI subsystem initialized
[    4.787749] usb 1-6: configuration #1 chosen from 1 choice
[    4.787970] hub 1-6:1.0: USB hub found
[    4.788067] hub 1-6:1.0: 4 ports detected
[    4.844914] Driver 'sd' needs updating - please use bus_type methods
[    4.977972] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 21
[    4.978046] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 21 (level, low) -> IRQ 21
[    4.978122] sata_nv 0000:00:05.0: Using SWNCQ mode
[    4.978493] scsi0 : sata_nv
[    4.978611] scsi1 : sata_nv
[    4.978764] ata1: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 irq 21
[    4.978813] ata2: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 irq 21
[    5.053447] usb 1-6.1: new low speed USB device using ehci_hcd and address 4
[    5.148092] usb 1-6.1: configuration #1 chosen from 1 choice
[    5.155561] input: Microsoft Microsoft IntelliMouse® Optical as /class/input/input1
[    5.160027] input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Optical] on usb-0000:00:02.1-6.1
[    5.222444] usb 1-6.2: new low speed USB device using ehci_hcd and address 5
[    5.307963] usb 1-6.2: configuration #1 chosen from 1 choice
[    5.312401] input: DELL DELL USB Keyboard as /class/input/input2
[    5.317027] input,hidraw1: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:02.1-6.2
[    5.326732] input: DELL DELL USB Keyboard as /class/input/input3
[    5.337025] input,hidraw2: USB HID v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:02.1-6.2
[    5.454004] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.457086] ata1.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.18, max UDMA/66
[    5.464085] ata1.00: configured for UDMA/66
[    5.777326] ata2: SATA link down (SStatus 0 SControl 300)
[    5.783181] scsi 0:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-215  1.18 PQ: 0 ANSI: 0
[    5.783597] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 23
[    5.783648] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 23 (level, low) -> IRQ 23
[    5.783729] sata_nv 0000:00:05.1: Using SWNCQ mode
[    5.784122] scsi2 : sata_nv
[    5.784226] scsi3 : sata_nv
[    5.784277] BUG: unable to handle kernel paging request at 32050000
[    5.784365] IP: [<c047efcf>] kmem_cache_alloc+0x30/0x7d
[    5.784437] *pdpt = 0000000036edf001 *pde = 0000000000000000 
[    5.784528] Oops: 0000 [#1] SMP 
[    5.784614] last sysfs file: /sys/class/firmware/timeout
[    5.784664] Modules linked in: sata_nv(+) ata_generic libata sd_mod scsi_mod sha256_generic aes_i586 dm_crypt dm_snapshot dm_zero dm_mirror dm_log dm_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
[    5.785170] 
[    5.785217] Pid: 518, comm: modprobe Not tainted (2.6.26-next-20080718 #18)
[    5.785267] EIP: 0060:[<c047efcf>] EFLAGS: 00010006 CPU: 1
[    5.785318] EIP is at kmem_cache_alloc+0x30/0x7d
[    5.785366] EAX: 00000000 EBX: 32050000 ECX: f88d3c60 EDX: c481b620
[    5.785415] ESI: c075e480 EDI: 00000286 EBP: f7884d14 ESP: f7884d00
[    5.785465]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    5.785514] Process modprobe (pid: 518, ti=f7884000 task=f79798e0 task.ti=f7884000)
[    5.785564] Stack: 000000d0 00000100 000000d0 000000d0 f6f21818 f7884d2c f88d3c60 f88ef748 
[    5.785818]        000000d0 f6f21800 f6f21818 f7884d40 f88d3ceb f88b7854 f6f21800 f786485c 
[    5.786071]        f7884d58 f88d43e7 f7884d58 f6f3c000 f6df3434 00000001 f7884d74 f88fa394 
[    5.786255] Call Trace:
[    5.786255]  [<f88d3c60>] ? scsi_pool_alloc_command+0x18/0x59 [scsi_mod]
[    5.786255]  [<f88d3ceb>] ? scsi_setup_command_freelist+0x4a/0x7e [scsi_mod]
[    5.786255]  [<f88d43e7>] ? scsi_add_host+0x58/0x184 [scsi_mod]
[    5.786255]  [<f88fa394>] ? ata_scsi_add_hosts+0x8e/0xde [libata]
[    5.786255]  [<f88f7c95>] ? ata_host_register+0x89/0x1fd [libata]
[    5.786255]  [<f88f7e9c>] ? ata_host_activate+0x93/0xb3 [libata]
[    5.786255]  [<f88b36ba>] ? nv_init_one+0x2d6/0x2e0 [sata_nv]
[    5.786255]  [<c050a000>] ? pci_match_device+0xb/0x93
[    5.786255]  [<c050a5d0>] ? pci_device_probe+0x39/0x59
[    5.786255]  [<c0570591>] ? driver_probe_device+0xa0/0x136
[    5.786255]  [<c0570661>] ? __driver_attach+0x3a/0x59
[    5.786255]  [<c056ffc9>] ? bus_for_each_dev+0x3b/0x63
[    5.786255]  [<c0570436>] ? driver_attach+0x14/0x16
[    5.786255]  [<c0570627>] ? __driver_attach+0x0/0x59
[    5.786255]  [<c056f9fe>] ? bus_add_driver+0x9d/0x1ba
[    5.786255]  [<c05707eb>] ? driver_register+0x81/0xe1
[    5.786255]  [<c0474dda>] ? __vunmap+0x93/0x9b
[    5.786255]  [<c050a78f>] ? __pci_register_driver+0x3f/0x6c
[    5.786255]  [<f88ba017>] ? nv_init+0x17/0x19 [sata_nv]
[    5.786255]  [<c04455ed>] ? sys_init_module+0x15c9/0x17c9
[    5.786255]  [<f88f3a3f>] ? ata_port_start+0x0/0x2f [libata]
[    5.786255]  [<c04038b1>] ? sysenter_past_esp+0x6a/0x91
[    5.786255]  =======================
[    5.786255] Code: 89 c6 53 83 ec 08 89 55 ec 8b 4d 04 9c 5f fa 64 a1 04 50 7a c0 8b 94 86 80 00 00 00 8b 42 10 89 45 f0 8b 1a 85 db 74 0a 8b 42 0c <8b> 04 83 89 02 eb 13 52 8b 55 ec 89 f0 51 83 c9 ff e8 ad f9 ff 
[    5.786255] EIP: [<c047efcf>] kmem_cache_alloc+0x30/0x7d SS:ESP 0068:f7884d00
[    5.786255] ---[ end trace e5a47564365f26e7 ]---
[    5.789799] eth0: too many iterations (6) in nv_nic_irq.
[    5.789883] eth0: too many iterations (6) in nv_nic_irq.
[    5.800828] eth0: too many iterations (6) in nv_nic_irq.
[    5.800893] eth0: too many iterations (6) in nv_nic_irq.
[    8.290413] BUG: unable to handle kernel paging request at 32050000
[    8.291205] IP: [<c047efcf>] kmem_cache_alloc+0x30/0x7d
[    8.291274] *pdpt = 0000000036df9001 *pde = 0000000000000000 
[    8.291362] Oops: 0000 [#2] SMP 
[    8.291448] last sysfs file: /sys/class/firmware/timeout
[    8.291497] Modules linked in: sata_nv(+) ata_generic libata sd_mod scsi_mod sha256_generic aes_i586 dm_crypt dm_snapshot dm_zero dm_mirror dm_log dm_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
[    8.291997] 
[    8.292044] Pid: 1, comm: init Tainted: G      D   (2.6.26-next-20080718 #18)
[    8.292094] EIP: 0060:[<c047efcf>] EFLAGS: 00010006 CPU: 1
[    8.292143] EIP is at kmem_cache_alloc+0x30/0x7d
[    8.292192] EAX: 00000000 EBX: 32050000 ECX: c0494515 EDX: c481b620
[    8.292241] ESI: c075e480 EDI: 00000296 EBP: f781eee0 ESP: f781eecc
[    8.292255]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    8.292255] Process init (pid: 1, ti=f781e000 task=f7830000 task.ti=f781e000)
[    8.292255] Stack: 000000d0 00000100 f6eb0000 f781ef50 00000000 f781ef24 c0494515 00000001 
[    8.292255]        00000001 c481e440 f7811100 000080d0 00000020 f7803280 f6eb0000 f6eb048c 
[    8.292255]        f781ef1c c04d5f5b f6eb0000 f6eb0000 00000000 00000000 f781ef60 c042567f 
[    8.292255] Call Trace:
[    8.292255]  [<c0494515>] ? dup_fd+0x23/0x2cb
[    8.292255]  [<c04d5f5b>] ? selinux_task_alloc_security+0x22/0x68
[    8.292255]  [<c042567f>] ? copy_process+0x4fb/0xf70
[    8.292255]  [<c04815da>] ? sys_faccessat+0x13f/0x149
[    8.292255]  [<c04261ac>] ? do_fork+0xb8/0x1ed
[    8.292255]  [<c04023cb>] ? sys_clone+0x1f/0x21
[    8.292255]  [<c04038b1>] ? sysenter_past_esp+0x6a/0x91
[    8.292255]  =======================
[    8.292255] Code: 89 c6 53 83 ec 08 89 55 ec 8b 4d 04 9c 5f fa 64 a1 04 50 7a c0 8b 94 86 80 00 00 00 8b 42 10 89 45 f0 8b 1a 85 db 74 0a 8b 42 0c <8b> 04 83 89 02 eb 13 52 8b 55 ec 89 f0 51 83 c9 ff e8 ad f9 ff 
[    8.292255] EIP: [<c047efcf>] kmem_cache_alloc+0x30/0x7d SS:ESP 0068:f781eecc
[    8.292255] ---[ end trace e5a47564365f26e7 ]---
[    8.292255] Kernel panic - not syncing: Attempted to kill init!
[    8.292255] Pid: 1, comm: init Tainted: G      D   2.6.26-next-20080718 #18
[    8.292255]  [<c063b0bd>] ? printk+0xf/0x12
[    8.292255]  [<c063b007>] panic+0x39/0xe0
[    8.292255]  [<c0429588>] do_exit+0x5b/0x6d1
[    8.292255]  [<c063b0bd>] ? printk+0xf/0x12
[    8.292255]  [<c063b0bd>] ? printk+0xf/0x12
[    8.292255]  [<c042688d>] ? oops_exit+0x23/0x28
[    8.292255]  [<c0404c1d>] die+0x12b/0x133
[    8.292255]  [<c063e8e3>] ? do_page_fault+0x0/0x885
[    8.292255]  [<c063f04c>] do_page_fault+0x769/0x885
[    8.292255]  [<c04d3e53>] ? avc_has_perm+0x39/0x43
[    8.292255]  [<c0491bcf>] ? __d_lookup+0x9e/0xda
[    8.292255]  [<c0465d76>] ? get_page_from_freelist+0xcd/0x396
[    8.292255]  [<c063e8e3>] ? do_page_fault+0x0/0x885
[    8.292255]  [<c063d41a>] error_code+0x72/0x78
[    8.292255]  [<c0494515>] ? dup_fd+0x23/0x2cb
[    8.292255]  [<c047efcf>] ? kmem_cache_alloc+0x30/0x7d
[    8.292255]  [<c0494515>] dup_fd+0x23/0x2cb
[    8.292255]  [<c04d5f5b>] ? selinux_task_alloc_security+0x22/0x68
[    8.292255]  [<c042567f>] copy_process+0x4fb/0xf70
[    8.292255]  [<c04815da>] ? sys_faccessat+0x13f/0x149
[    8.292255]  [<c04261ac>] do_fork+0xb8/0x1ed
[    8.292255]  [<c04023cb>] sys_clone+0x1f/0x21
[    8.292255]  [<c04038b1>] sysenter_past_esp+0x6a/0x91
[    8.292255]  =======================
[    8.292255] ------------[ cut here ]------------
[    8.292255] WARNING: at kernel/smp.c:288 smp_call_function_mask+0x2b/0x119()
[    8.292255] Modules linked in: sata_nv(+) ata_generic libata sd_mod scsi_mod sha256_generic aes_i586 dm_crypt dm_snapshot dm_zero dm_mirror dm_log dm_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
[    8.292255] Pid: 1, comm: init Tainted: G      D   2.6.26-next-20080718 #18
[    8.292255]  [<c063b0bd>] ? printk+0xf/0x12
[    8.292255]  [<c0426761>] warn_on_slowpath+0x41/0x7b
[    8.292255] eth0: too many iterations (6) in nv_nic_irq.
[    8.292255]  [<c057ae82>] ? write_msg+0xb1/0xb9
[    8.292255]  [<c057add1>] ? write_msg+0x0/0xb9
[    8.292255]  [<c0426a0f>] ? __call_console_drivers+0x56/0x63
[    8.292255]  [<c043a526>] ? up+0x2b/0x2f
[    8.292255]  [<c0426e4f>] ? release_console_sem+0x177/0x17f
[    8.292255]  [<c0411f1c>] ? touch_nmi_watchdog+0x3f/0x42
[    8.292255]  [<c0435581>] ? __kernel_text_address+0x34/0x3e
[    8.292255]  [<c04425bf>] smp_call_function_mask+0x2b/0x119
[    8.292255]  [<c0410f57>] ? stop_this_cpu+0x0/0x36
[    8.292255]  [<c040519d>] ? show_trace+0x24/0x29
[    8.292255]  [<c063afc4>] ? dump_stack+0x5b/0x65
[    8.292255]  [<c04426bf>] smp_call_function+0x12/0x14
[    8.292255]  [<c0410f4a>] native_smp_send_stop+0x1b/0x28
[    8.292255]  [<c063b01b>] panic+0x4d/0xe0
[    8.292255]  [<c0429588>] <7>eth0: too many iterations (6) in nv_nic_irq.
[    8.292255] do_exit+0x5b/0x6d1
[    8.292255]  [<c063b0bd>] ? printk+0xf/0x12
[    8.292255]  [<c063b0bd>] ? printk+0xf/0x12
[    8.292255]  [<c042688d>] ? oops_exit+0x23/0x28
[    8.292255]  [<c0404c1d>] die+0x12b/0x133
[    8.292255]  [<c063e8e3>] ? do_page_fault+0x0/0x885

