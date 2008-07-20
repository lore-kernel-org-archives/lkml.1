Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYGTM6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYGTM6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 08:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYGTM54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 08:57:56 -0400
Received: from www17.your-server.de ([213.133.104.17]:58128 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbYGTM5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 08:57:52 -0400
Subject: [OOPS] sata_nv: nv_swncq_qc_prep (next-20080718)
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 20 Jul 2008 14:57:45 +0200
Message-Id: <1216558665.3118.5.camel@dhcppc2>
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
[    0.000000] Detected 2600.002 MHz processor.
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
[    0.001999] Calibrating delay loop (skipped), value calculated using timer frequency.. <6>5200.00 BogoMIPS (lpj=2600002)
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
[    0.005447] ACPI: Core revision 20080609
[    0.011631] ENABLING IO-APIC IRQs
[    0.011843] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.021996] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.021996] Booting processor 1/1 ip 6000
[    0.031995] Initializing CPU#1
[    0.092652] Calibrating delay using timer specific routine.. <6>5199.68 BogoMIPS (lpj=2599842)
[    0.092658] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.092660] CPU: L2 Cache: 512K (64 bytes/line)
[    0.092661] CPU 1(2) -> Core 1
[    0.092663] Intel machine check architecture supported.
[    0.092664] Intel machine check reporting enabled on CPU#1.
[    0.092840] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.092826] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.092985] Brought up 2 CPUs
[    0.092985] Total of 2 processors activated (10399.68 BogoMIPS).
[    0.093308] net_namespace: 732 bytes
[    0.093543] NET: Registered protocol family 16
[    0.093751] No dock devices found.
[    0.093882] ACPI: bus type pci registered
[    0.094017] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.094068] PCI: Not using MMCONFIG.
[    0.094676] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=7
[    0.094726] PCI: Using configuration type 1 for base access
[    0.105006] ACPI: Interpreter enabled
[    0.105055] ACPI: (supports S0 S1 S3 S4 S5)
[    0.105208] ACPI: Using IOAPIC for interrupt routing
[    0.105298] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.110054] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.110103] PCI: Using MMCONFIG for extended config space
[    0.118131] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.118379] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.118430] pci 0000:00:01.1: PME# disabled
[    0.118508] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.118557] pci 0000:00:02.0: PME# disabled
[    0.118631] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.118680] pci 0000:00:02.1: PME# disabled
[    0.118866] pci 0000:00:06.1: PME# supported from D3hot D3cold
[    0.118916] pci 0000:00:06.1: PME# disabled
[    0.119007] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119057] pci 0000:00:08.0: PME# disabled
[    0.119141] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119191] pci 0000:00:09.0: PME# disabled
[    0.119256] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119305] pci 0000:00:0a.0: PME# disabled
[    0.119370] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119419] pci 0000:00:0b.0: PME# disabled
[    0.119483] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119532] pci 0000:00:0c.0: PME# disabled
[    0.119595] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119644] pci 0000:00:0d.0: PME# disabled
[    0.119708] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119757] pci 0000:00:0e.0: PME# disabled
[    0.119820] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119869] pci 0000:00:0f.0: PME# disabled
[    0.119988] pci 0000:00:06.0: transparent bridge
[    0.130108] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
[    0.131188] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
[    0.131554] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.131918] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.132304] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[    0.132691] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.133058] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *10
[    0.133420] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disabled.
[    0.133800] ACPI: PCI Interrupt Link [LUB0] (IRQs 21 22 23) *7
[    0.134143] ACPI: PCI Interrupt Link [LMAD] (IRQs 20) *5
[    0.134444] ACPI: PCI Interrupt Link [LUB2] (IRQs 21 22 23) *10
[    0.134783] ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *11
[    0.135086] ACPI: PCI Interrupt Link [LAZA] (IRQs 21 22 23) *10
[    0.135425] ACPI: PCI Interrupt Link [LSMB] (IRQs 21 22 23) *11
[    0.135764] ACPI: PCI Interrupt Link [LPMU] (IRQs 21 22 23) *5
[    0.136105] ACPI: PCI Interrupt Link [LSA0] (IRQs 21 22 23) *11
[    0.136444] ACPI: PCI Interrupt Link [LSA1] (IRQs 21 22 23) *5
[    0.136816] ACPI: PCI Interrupt Link [LATA] (IRQs 21 22 23) *0, disabled.
[    0.137175] ACPI: PCI Interrupt Link [LSA2] (IRQs 21 22 23) *10
[    0.137486] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.137562] pnp: PnP ACPI init
[    0.137617] ACPI: bus type pnp registered
[    0.141831] pnp: PnP ACPI: found 14 devices
[    0.141879] ACPI: ACPI bus type pnp unregistered
[    0.142360] usbcore: registered new interface driver usbfs
[    0.142441] usbcore: registered new interface driver hub
[    0.142538] usbcore: registered new device driver usb
[    0.142719] PCI: Using ACPI for IRQ routing
[    0.142986] NetLabel: Initializing
[    0.143034] NetLabel:  domain hash size = 128
[    0.143081] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.143137] NetLabel:  unlabeled traffic allowed by default
[    0.143190] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.143315] hpet0: 3 32-bit timers, 25000000 Hz
[    0.144648] tracer: 772 pages allocated for 65536 entries of 48 bytes
[    0.144683]    actual entries 65620
[    0.147366] ACPI: RTC can wake from S4
[    0.148866] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.148915] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.148964] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.149013] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.149062] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.149118] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.149167] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.149215] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.149264] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.149313] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.149362] system 00:05: iomem range 0xfea80000-0xfeabffff has been reserved
[    0.149411] system 00:05: iomem range 0xfee01000-0xfeefffff could not be reserved
[    0.149489] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.149565] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.149644] system 00:0a: ioport range 0xa00-0xa0f has been reserved
[    0.149692] system 00:0a: ioport range 0xa10-0xa1f has been reserved
[    0.149743] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.149794] system 00:0c: iomem range 0xd0000000-0xdfffffff could not be reserved
[    0.149878] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.149926] system 00:0d: iomem range 0xc0000-0xcffff could not be reserved
[    0.149975] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.150024] system 00:0d: iomem range 0x100000-0xbfffffff could not be reserved
[    0.150102] system 00:0d: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.180806] pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
[    0.180860] pci 0000:00:06.0:   IO window: disabled
[    0.180909] pci 0000:00:06.0:   MEM window: disabled
[    0.180957] pci 0000:00:06.0:   PREFETCH window: disabled
[    0.181006] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
[    0.181054] pci 0000:00:0a.0:   IO window: disabled
[    0.181107] pci 0000:00:0a.0:   MEM window: disabled
[    0.181155] pci 0000:00:0a.0:   PREFETCH window: disabled
[    0.181204] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
[    0.181252] pci 0000:00:0b.0:   IO window: disabled
[    0.181300] pci 0000:00:0b.0:   MEM window: disabled
[    0.181348] pci 0000:00:0b.0:   PREFETCH window: disabled
[    0.181397] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
[    0.181445] pci 0000:00:0c.0:   IO window: disabled
[    0.181493] pci 0000:00:0c.0:   MEM window: disabled
[    0.181541] pci 0000:00:0c.0:   PREFETCH window: disabled
[    0.181590] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:05
[    0.181638] pci 0000:00:0d.0:   IO window: disabled
[    0.181686] pci 0000:00:0d.0:   MEM window: disabled
[    0.181734] pci 0000:00:0d.0:   PREFETCH window: disabled
[    0.181783] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:06
[    0.181831] pci 0000:00:0e.0:   IO window: disabled
[    0.181885] pci 0000:00:0e.0:   MEM window: disabled
[    0.181933] pci 0000:00:0e.0:   PREFETCH window: disabled
[    0.181982] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:07
[    0.182030] pci 0000:00:0f.0:   IO window: 0xe000-0xefff
[    0.182079] pci 0000:00:0f.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.182133] pci 0000:00:0f.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
[    0.182245] NET: Registered protocol family 2
[    0.185894] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.186169] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.186872] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.187244] TCP: Hash tables configured (established 131072 bind 65536)
[    0.187298] TCP reno registered
[    0.188914] NET: Registered protocol family 1
[    0.189060] checking if image is initramfs... it is
[    0.361469] Freeing initrd memory: 3012k freed
[    0.362474] Machine check exception polling timer started.
[    0.362917] audit: initializing netlink socket (disabled)
[    0.362980] type=2000 audit(1216564826.361:1): initialized
[    0.367219] highmem bounce pool size: 64 pages
[    0.367253] Total HugeTLB memory allocated, 0
[    0.369250] VFS: Disk quotas dquot_6.5.1
[    0.369378] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.369564] msgmni has been set to 1668
[    0.369865] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.369941] io scheduler noop registered
[    0.369988] io scheduler anticipatory registered
[    0.370042] io scheduler deadline registered
[    0.370096] io scheduler cfq registered (default)
[    0.370167] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.411250] pci 0000:00:05.0: Enabling HT MSI Mapping
[    0.411308] pci 0000:00:05.1: Enabling HT MSI Mapping
[    0.411365] pci 0000:00:05.2: Enabling HT MSI Mapping
[    0.411421] pci 0000:00:06.0: Enabling HT MSI Mapping
[    0.411479] pci 0000:00:06.1: Enabling HT MSI Mapping
[    0.412208] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.412267] pci 0000:00:09.0: Enabling HT MSI Mapping
[    0.412324] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.412382] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.412433] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.412433] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.412433] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.412433] pci 0000:00:0f.0: Enabling HT MSI Mapping
[    0.412433] pcieport-driver 0000:00:0a.0: found MSI capability
[    0.412433] pcieport-driver 0000:00:0b.0: found MSI capability
[    0.412433] pcieport-driver 0000:00:0c.0: found MSI capability
[    0.412433] pcieport-driver 0000:00:0d.0: found MSI capability
[    0.412433] pcieport-driver 0000:00:0e.0: found MSI capability
[    0.412433] pcieport-driver 0000:00:0f.0: found MSI capability
[    0.412433] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.412433] processor ACPI0007:00: registered as cooling_device0
[    0.412433] processor ACPI0007:01: registered as cooling_device1
[    0.412433] isapnp: Scanning for PnP cards...
[    0.753421] isapnp: No Plug & Play device found
[    0.756510] Non-volatile memory driver v1.2
[    0.756558] Linux agpgart interface v0.103
[    0.757054] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    0.759052] brd: module loaded
[    0.759113] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[    0.759445] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
[    0.759501] forcedeth 0000:00:08.0: PCI INT A -> Link[LMAC] -> GSI 20 (level, low) -> IRQ 20
[    1.274420] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x1c1 @ 0, addr 00:16:17:45:c9:df
[    1.274496] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[    1.274813] ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 20
[    1.274862] forcedeth 0000:00:09.0: PCI INT A -> Link[LMAD] -> GSI 20 (level, low) -> IRQ 20
[    1.788396] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x1c1 @ 1, addr 00:16:17:45:c9:de
[    1.788471] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[    1.788594] netconsole: local port 6665
[    1.788644] netconsole: local IP 192.168.3.1
[    1.788691] netconsole: interface eth0
[    1.788738] netconsole: remote port 6666
[    1.788785] netconsole: remote IP 192.168.3.2
[    1.788833] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[    1.788882] netconsole: device eth0 not up yet, forcing it
[    1.789370] eth0: no link during initialization.
[    3.849723] eth0: link up.
[    3.850262] console [netcon0] enabled
[    3.868431] netconsole: network logging started
[    3.869281] input: Macintosh mouse button emulation as /class/input/input0
[    3.869596] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    3.872184] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.872244] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.873280] mice: PS/2 mouse device common for all mice
[    3.916804] cpuidle: using governor ladder
[    3.916855] cpuidle: using governor menu
[    3.917033] usbcore: registered new interface driver hiddev
[    3.917123] usbcore: registered new interface driver usbhid
[    3.917176] usbhid: v2.6:USB HID core driver
[    3.917658] TCP cubic registered
[    3.917706] Initializing XFRM netlink socket
[    3.917764] NET: Registered protocol family 17
[    3.917837] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ processors (2 cpu cores) (version 2.20.00)
[    3.917735] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[    3.917798] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[    3.917848] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[    3.917900] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[    3.917952] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[    3.918004] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[    3.918128] Using IPI No-Shortcut mode
[    3.918357] registered taskstats version 1
[    3.918703] Freeing unused kernel memory: 268k freed
[    3.918778] Write protecting the kernel text: 2308k
[    3.918841] Write protecting the kernel read-only data: 956k
[    4.183591] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
[    4.183657] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23 (level, low) -> IRQ 23
[    4.183746] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    4.183860] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    4.183956] ehci_hcd 0000:00:02.1: debug port 1
[    4.184024] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfeafac00
[    4.189235] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    4.189365] usb usb1: configuration #1 chosen from 1 choice
[    4.189436] hub 1-0:1.0: USB hub found
[    4.189491] hub 1-0:1.0: 10 ports detected
[    4.393802] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
[    4.393869] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22 (level, low) -> IRQ 22
[    4.393957] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    4.394066] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    4.394163] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfeafb000
[    4.446280] usb usb2: configuration #1 chosen from 1 choice
[    4.446350] hub 2-0:1.0: USB hub found
[    4.446406] hub 2-0:1.0: 10 ports detected
[    4.493232] usb 1-4: new high speed USB device using ehci_hcd and address 2
[    4.569395] USB Universal Host Controller Interface driver v3.0
[    4.610757] usb 1-4: configuration #1 chosen from 1 choice
[    4.706236] device-mapper: uevent: version 1.0.3
[    4.706376] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    4.712243] usb 1-6: new high speed USB device using ehci_hcd and address 3
[    4.827505] usb 1-6: configuration #1 chosen from 1 choice
[    4.827721] hub 1-6:1.0: USB hub found
[    4.827825] hub 1-6:1.0: 4 ports detected
[    4.908745] padlock: VIA PadLock not detected.
[    4.917205] padlock: VIA PadLock Hash Engine not detected.
[    4.976185] SCSI subsystem initialized
[    5.038137] Driver 'sd' needs updating - please use bus_type methods
[    5.093207] usb 1-6.1: new low speed USB device using ehci_hcd and address 4
[    5.153331] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 21
[    5.153397] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 21 (level, low) -> IRQ 21
[    5.153473] sata_nv 0000:00:05.0: Using SWNCQ mode
[    5.153846] scsi0 : sata_nv
[    5.153968] scsi1 : sata_nv
[    5.154119] ata1: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 irq 21
[    5.154172] ata2: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 irq 21
[    5.194490] usb 1-6.1: configuration #1 chosen from 1 choice
[    5.202324] input: Microsoft Microsoft IntelliMouse® Optical as /class/input/input1
[    5.206242] input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Optical] on usb-0000:00:02.1-6.1
[    5.270203] usb 1-6.2: new low speed USB device using ehci_hcd and address 5
[    5.357847] usb 1-6.2: configuration #1 chosen from 1 choice
[    5.362782] input: DELL DELL USB Keyboard as /class/input/input2
[    5.366242] input,hidraw1: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:02.1-6.2
[    5.376489] input: DELL DELL USB Keyboard as /class/input/input3
[    5.381239] input,hidraw2: USB HID v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:02.1-6.2
[    5.624230] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.627308] ata1.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.18, max UDMA/66
[    5.633308] ata1.00: configured for UDMA/66
[    5.948510] ata2: SATA link down (SStatus 0 SControl 300)
[    5.955084] scsi 0:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-215  1.18 PQ: 0 ANSI: 0
[    5.955521] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 23
[    5.955573] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 23 (level, low) -> IRQ 23
[    5.955656] sata_nv 0000:00:05.1: Using SWNCQ mode
[    5.956039] scsi2 : sata_nv
[    5.956144] scsi3 : sata_nv
[    5.956303] ata3: SATA max UDMA/133 cmd 0xc880 ctl 0xc800 bmdma 0xc080 irq 23
[    5.956353] ata4: SATA max UDMA/133 cmd 0xc480 ctl 0xc400 bmdma 0xc088 irq 23
[    6.412218] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.415465] ata3.00: ATA-7: Hitachi HDT725032VLA360, V54OA7EA, max UDMA/133
[    6.415515] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    6.421460] ata3.00: configured for UDMA/133
[    6.738120] ata4: SATA link down (SStatus 0 SControl 300)
[    6.737367] scsi scan: INQUIRY result too short (5), using 36
[    6.737418] scsi 2:0:0:0: Direct-Access                                    PQ: 0 ANSI: 0
[    6.737574] sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[    6.737641] sd 2:0:0:0: [sda] Write Protect is off
[    6.737721] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.737861] sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[    6.737920] sd 2:0:0:0: [sda] Write Protect is off
[    6.738002] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.738079]  sda:<1>BUG: unable to handle kernel paging request at 20696863
[    6.738224] IP: [<f88b4a1e>] :sata_nv:nv_swncq_qc_prep+0x81/0xca
[    6.738253] *pdpt = 0000000036f8c001 *pde = 0000000000000000 
[    6.738253] Oops: 0002 [#1] SMP 
[    6.738253] last sysfs file: /sys/class/firmware/timeout
[    6.738253] Modules linked in: sata_nv(+) ata_generic libata sd_mod scsi_mod sha256_generic aes_i586 dm_crypt dm_snapshot dm_zero dm_mirror dm_log dm_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
[    6.738253] 
[    6.738253] Pid: 518, comm: modprobe Not tainted (2.6.26-next-20080718 #18)
[    6.738253] EIP: 0060:[<f88b4a1e>] EFLAGS: 00010046 CPU: 1
[    6.738253] EIP is at nv_swncq_qc_prep+0x81/0xca [sata_nv]
[    6.738253] EAX: 36fa9000 EBX: 00000000 ECX: 20696863 EDX: 00001000
[    6.738253] ESI: 20696863 EDI: f6fe8078 EBP: f6dca774 ESP: f6dca754
[    6.738253]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    6.738253] Process modprobe (pid: 518, ti=f6dca000 task=f6d331c0 task.ti=f6dca000)
[    6.738253] Stack: 36fa9000 00000000 00000000 f6f9a9c0 20696863 c0642f38 f6fe8078 f6fe9404 
[    6.738253]        f6dca78c f88f4860 f6fe8000 f6fe8078 00000000 f6fe9554 f6dca7a8 f88f9001 
[    6.738253]        f88d3580 f6fe8000 f6fe9554 f6f99700 f88d3580 f6dca7c8 f88fabe5 f88f8d07 
[    6.738253] Call Trace:
[    6.738254]  [<f88f4860>] ? ata_qc_issue+0x22f/0x26c [libata]
[    6.738254]  [<f88f9001>] ? ata_scsi_translate+0xd1/0xff [libata]
[    6.738254]  [<f88d3580>] ? scsi_done+0x0/0x19 [scsi_mod]
[    6.738254]  [<f88d3580>] ? scsi_done+0x0/0x19 [scsi_mod]
[    6.738254]  [<f88fabe5>] ? ata_scsi_queuecmd+0x163/0x1ae [libata]
[    6.738254]  [<f88f8d07>] ? ata_scsi_rw_xlat+0x0/0x201 [libata]
[    6.738254]  [<f88d3810>] ? scsi_dispatch_cmd+0x18d/0x20a [scsi_mod]
[    6.738254]  [<f88d8066>] ? scsi_request_fn+0x2ce/0x390 [scsi_mod]
[    6.738254]  [<c04ef15a>] ? __generic_unplug_device+0x1d/0x20
[    6.738254]  [<c04ef3bd>] ? generic_unplug_device+0x21/0x2d
[    6.738254]  [<c04edf4c>] ? blk_unplug+0x51/0x58
[    6.738254]  [<c04edf5e>] ? blk_backing_dev_unplug+0xb/0xd
[    6.738254]  [<c049eb60>] ? block_sync_page+0x32/0x34
[    6.738254]  [<c046163f>] ? sync_page+0x31/0x3a
[    6.738254]  [<c063be56>] ? __wait_on_bit_lock+0x34/0x5e
[    6.738254]  [<c046160e>] ? sync_page+0x0/0x3a
[    6.738254]  [<c04615f9>] ? __lock_page+0x78/0x81
[    6.738254]  [<c0436ff2>] ? wake_bit_function+0x0/0x43
[    6.738254]  [<c0461bb2>] ? read_cache_page_async+0xba/0x10b
[    6.738254]  [<c04a4397>] ? blkdev_readpage+0x0/0x11
[    6.738254]  [<c0461c0f>] ? read_cache_page+0xc/0x3f
[    6.738254]  [<c04ba719>] ? read_dev_sector+0x34/0x6a
[    6.738254]  [<c04bc342>] ? efi_partition+0x0/0x676
[    6.738254]  [<c04bc12d>] ? read_lba+0x69/0xc6
[    6.738254]  [<c04bc342>] ? efi_partition+0x0/0x676
[    6.738254]  [<c04bc3e5>] ? efi_partition+0xa3/0x676
[    6.738254]  [<c04ff771>] ? snprintf+0x15/0x17
[    6.738254]  [<c04bc342>] ? efi_partition+0x0/0x676
[    6.738254]  [<c04bacdb>] ? rescan_partitions+0x10c/0x232
[    6.738254]  [<c056e486>] ? get_device+0x13/0x18
[    6.738254]  [<c04a40fe>] ? do_open+0x1d4/0x25c
[    6.738254]  [<c04a4248>] ? __blkdev_get+0x71/0x7c
[    6.738254]  [<c04a4260>] ? blkdev_get+0xd/0xf
[    6.738254]  [<c04ba827>] ? register_disk+0xd8/0x129
[    6.738254]  [<c04f3ad8>] ? add_disk+0x37/0x93
[    6.738254]  [<c04f2b2c>] ? exact_match+0x0/0xb
[    6.738254]  [<c04f3705>] ? exact_lock+0x0/0x11
[    6.738254]  [<f88754b9>] ? sd_probe+0x2b1/0x363 [sd_mod]
[    6.738254]  [<c0570591>] ? driver_probe_device+0xa0/0x136
[    6.738254]  [<c0570688>] ? __device_attach+0x8/0xa
[    6.738254]  [<c056fd8d>] ? bus_for_each_drv+0x3d/0x67
[    6.738254]  [<c05706f9>] ? device_attach+0x50/0x67
[    6.738254]  [<c0570680>] ? __device_attach+0x0/0xa
[    6.738254]  [<c056fbe0>] ? bus_attach_device+0x21/0x48
[    6.738254]  [<c056ee1c>] ? device_add+0x3b0/0x4e3
[    6.738254]  [<f88dbf56>] ? scsi_sysfs_add_sdev+0xb3/0x1ed [scsi_mod]
[    6.738254]  [<f88da4f8>] ? scsi_probe_and_add_lun+0x865/0x941 [scsi_mod]
[    6.738254]  [<f88d998d>] ? scsi_alloc_target+0x1e1/0x212 [scsi_mod]
[    6.738254]  [<f88db1ce>] ? __scsi_add_device+0x83/0xa9 [scsi_mod]
[    6.738254]  [<f88fa130>] ? ata_scsi_scan_host+0x8a/0x212 [libata]
[    6.738254]  [<f88f7df9>] ? ata_host_register+0x1ed/0x1fd [libata]
[    6.738254]  [<f88f7e9c>] ? ata_host_activate+0x93/0xb3 [libata]
[    6.738254]  [<f88b36ba>] ? nv_init_one+0x2d6/0x2e0 [sata_nv]
[    6.738254]  [<c050a000>] ? pci_match_device+0xb/0x93
[    6.738254]  [<c050a5d0>] ? pci_device_probe+0x39/0x59
[    6.738254]  [<c0570591>] ? driver_probe_device+0xa0/0x136
[    6.738254]  [<c0570661>] ? __driver_attach+0x3a/0x59
[    6.738254]  [<c056ffc9>] ? bus_for_each_dev+0x3b/0x63
[    6.738254]  [<c0570436>] ? driver_attach+0x14/0x16
[    6.738254]  [<c0570627>] ? __driver_attach+0x0/0x59
[    6.738254]  [<c056f9fe>] ? <7>eth0: too many iterations (6) in nv_nic_irq.
[    6.738254] bus_add_driver+0x9d/0x1ba
[    6.738254]  [<c05707eb>] ? driver_register+0x81/0xe1
[    6.738254]  [<c0474dda>] ? __vunmap+0x93/0x9b
[    6.738254]  [<c050a78f>] ? __pci_register_driver+0x3f/0x6c
[    6.738254]  [<f88ba017>] ? nv_init+0x17/0x19 [sata_nv]
[    6.738254]  [<c04455ed>] ? sys_init_module+0x15c9/0x17c9
[    6.738254]  [<f88f3a3f>] ? ata_port_start+0x0/0x2f [libata]
[    6.738254]  [<c04038b1>] ? sysenter_past_esp+0x6a/0x91
[    6.738254]  =======================
[    6.738254] Code: e0 8b 4d e4 8b 58 08 8d 0c ce eb 30 0f b7 45 <7>eth0: too many iterations (6) in nv_nic_irq.
[    6.738254] e0 ba 00 00 01 00 8d 0c 18 29 c2 8b 45 e0 81 f9 00 00 01 00 8b 4d f0 0f 46 d3 29 d3 <89> 01 0f b7 c2 89 41 04 ff 45 e4 83 c1 08 <7>eth0: too many iterations (6) in nv_nic_irq.
[    6.738254] 01 55 e0 85 db 89 4d 
[    6.738254] EIP: [<f88b4a1e>] nv_swncq_qc_prep+0x81/0xca [sata_nv] SS:ESP 0068:f6dca754
[    6.738254] ---[ end trace 2c049bf9d74a57ac ]---
[    6.747872] eth0: too many iterations (6) in nv_nic_irq.
[    6.758916] eth0: too many iterations (6) in nv_nic_irq.
[    6.758990] eth0: too many iterations (6) in nv_nic_irq.
[    6.769880] eth0: too many iterations (6) in nv_nic_irq.

