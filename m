Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbYFLUmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbYFLUmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbYFLUlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:41:50 -0400
Received: from web53707.mail.re2.yahoo.com ([206.190.37.28]:21527 "HELO
	web53707.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754620AbYFLUlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:41:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=hTkAAIKype1AtFJKpUxPloM4TV306GADkhJvOuBpKOV0mt2GcZcm+2CvqNjLehvAmBJwQ0Hvr7C1mTqfze2L5hw5BEcu7ah0+Hi40GEfUcvYrzVR90Vt+gLrsFUfbhdHqZcIF6pWpO/eL9o4x9BvihT4TWNgN6jQ083prjwFHGg=;
X-YMail-OSG: QAHt_C8VM1ksZwxmXP9ZmFZFOVVJCComvzjX6O3z06yKJ6433acuIQN2VIqlHCew3ihyQezobOuRLbjd2YeuiNB1cp8TkejdG4k8qKf0yCPIHTXocchcCpY-
Date: Thu, 12 Jun 2008 13:41:45 -0700 (PDT)
From: Benjamin Kidwell <benjkidwell@yahoo.com>
Subject: 2.6.26-rc5-mm3 reproducible BUG and build failures
To: linux-kernel@vger.kernel.org
Cc: benjkidwell@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <314477.88718.qm@web53707.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Working with 2.6.26-rc5-mm3 on a pair of test x86 boxes (a p4 and a c2d) both
running Ubuntu 8.04. I've had two issues.

1) The build process fails with certain config options. I have reproduced this
on 2 machines. 

  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
mm/built-in.o: In function `__munlock_vma_pages_range':
mlock.c:(.text+0x11567): undefined reference to `walk_page_range'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

After changing a few .config options I have been able to compile successfully.
I believe the setting that triggers the build failure is:
# CONFIG_PROC_PAGE_MONITOR is not set
With =y the make process went fine on both of my test boxes. If I'm mistaken
on this, I can provide a full diff of the building/nonbuilding configs.

2nd: I get the following BUG every startup on the P4. I think it triggers when
GDM starts, triggered by playing back a sound sample. This box is known to
have buggy sound controller, see http://lkml.org/lkml/2008/6/6/408 and
followups. I think Takashi-san's sound-unstable tree already has some code
relevant to this chip's issues, but I don't know if this BUG is related, or
not. GDM login seems to work but it goes to a white screen when trying to load
Gnome desktop. TTYs still work so I was able to save the following. 

[   33.165017] Kernel BUG at c0141256 [verbose debug info unavailable]
[   33.165017] invalid opcode: 0000 [#1] SMP 
[   33.165017] last sysfs file:
/sys/devices/pci0000:00/0000:00:14.4/0000:01:03.0/resource
[   33.165017] Modules linked in: ipv6 sbs sbshc container battery
iptable_filter ip_tables x_tables ac loop af_packet snd_hda_intel snd_pcm
serio_raw i2c_piix4 snd_timer psmouse i2c_core snd soundcore snd_page_alloc
ati_agp agpgart button evdev ext3 jbd mbcache sd_mod ide_cd_mod cdrom
pata_atiixp usbhid hid sata_sil pata_acpi 8139too ata_generic atiixp 8139cp
mii ohci_hcd ehci_hcd libata scsi_mod dock ide_pci_generic ide_core usbcore
thermal processor fan fuse
[   33.165017] 
[   33.165017] Pid: 5400, comm: aplay Not tainted (2.6.26-rc5-mm3mmtry #1)
[   33.165017] EIP: 0060:[<c0141256>] EFLAGS: 00010246 CPU: 0
[   33.165017] EIP is at unlock_page+0xe/0x23
[   33.165017] EAX: 00000000 EBX: c14add60 ECX: 00000000 EDX: c14add60
[   33.165017] ESI: 00000001 EDI: c14add60 EBP: eeed6630 ESP: eef79dec
[   33.165017]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   33.165017] Process aplay (pid: 5400, ti=eef79000 task=eec6b960
task.ti=eef79000)
[   33.165017] Stack: 00000000 c0149c37 0000000e 000040ca c0131baf 00000000
00000000 00000000 
[   33.165017]        ffffffff 0000000e 00000000 c14add60 c14add80 c14adda0
c14addc0 c14adde0 
[   33.165017]        c14ade00 c14aef00 c14aef20 c14aef40 c14aef60 c14aef80
c14aefa0 c14aefc0 
[   33.165017] Call Trace:
[   33.165017]  [<c0149c37>] truncate_inode_pages_range+0xc4/0x336
[   33.165017]  [<c0131baf>] getnstimeofday+0x37/0xdf
[   33.165018]  [<c015d5c7>] shmem_delete_inode+0x0/0xb6
[   33.165018]  [<c0149ec0>] truncate_inode_pages+0x17/0x27
[   33.165018]  [<c015d60f>] shmem_delete_inode+0x48/0xb6
[   33.165018]  [<c015d5c7>] shmem_delete_inode+0x0/0xb6
[   33.165018]  [<c0172fc1>] generic_delete_inode+0x7f/0x100
[   33.165018]  [<c01726c4>] iput+0x44/0x4a
[   33.165018]  [<c017069a>] d_kill+0x2b/0x44
[   33.165018]  [<c01717d6>] dput+0xc3/0x16f
[   33.165018]  [<c016237d>] __fput+0x117/0x16f
[   33.165018]  [<c01a373c>] shm_destroy+0x36/0x3e
[   33.165018]  [<c01a43e1>] sys_shmctl+0x60b/0x61e
[   33.165018]  [<c01764a7>] mnt_drop_write+0x1d/0xd4
[   33.165018]  [<c01a364f>] sys_shmdt+0x10f/0x139
[   33.165018]  [<c0106799>] sys_ipc+0x42/0x28e
[   33.165018]  [<c01535e6>] sys_munmap+0x30/0x35
[   33.165018]  [<c0102de1>] sysenter_past_esp+0x6a/0x91
[   33.165018]  [<c0280000>] setup_local_APIC+0x3f/0x1aa
[   33.165018]  =======================
[   33.165018] Code: 74 09 8b 52 08 85 d2 74 02 ff d2 e8 37 0d 14 00 31 c0 8d
76 00 c3 ba a0 fa 2f c0 eb de 53 89 c3 f0 0f ba 30 00 19 c0 85 c0 75 04 <0f>
0b eb fe 89 d8 e8 7f f4 ff ff 31 c9 89 da 5b e9 9e b8 fe ff 
[   33.165018] EIP: [<c0141256>] unlock_page+0xe/0x23 SS:ESP 0068:eef79dec
[   33.165018] ---[ end trace f0d41f68fa3deb86 ]---

Userland seemed OK on the TTY, but the system hung while trying to terminate
proceses after I told it reboot. Magic SysRQ worked fine to restart. The 2nd
attempt to boot produced the same failure at GDM login. For reference, here is
the full dmesg output with the BUG at the end. Let me know if any more
information or tests are useful. Feedback on how to post reports properly also
appreciated.

[    0.000000] Linux version 2.6.26-rc5-mm3mmtry (hagbard@hardy) (gcc version
4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #1 SMP Thu Jun 12 14:21:37 CDT 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000002fef0000 (usable)
[    0.000000]  BIOS-e820: 000000002fef0000 - 000000002fef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000002fef3000 - 000000002ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] last_pfn = 196336 max_arch_pfn = 1048576
[    0.000000] 766MB LOWMEM available.
[    0.000000] old RAMDISK: 2fbad000 - 2fedf38a
[    0.000000]   mapped low ram: 0 - 00800000
[    0.000000]   low ram: 0039d000 - 2fef0000
[    0.000000]   bootmap 0039d000 - 003a2fe0
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [1000-1fff] EX TRAMPOLINE
[    0.000000]   early res: 2 [6000-6fff] TRAMPOLINE
[    0.000000]   early res: 3 [100000-39ac4f] TEXT DATA BSS
[    0.000000]   early res: 4 [2fbad000-2fedf389] RAMDISK
[    0.000000]   early res: 5 [39b000-39cfff] INIT_PG_TABLE
[    0.000000]   early res: 6 [9f000-fffff] BIOS reserved
[    0.000000]   early res: 7 [39d000-3a2fff] BOOTMAP
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f49f0] 000f49f0
[    0.000000] sizeof(struct page) = 32
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   196336
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   196336
[    0.000000] On node 0 totalpages: 196239
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 190738 pages, LIFO batch:31
[    0.000000] DMI 2.5 present.
[    0.000000] ACPI: RSDP 000F8AA0, 0014 (r0 HPQOEM)
[    0.000000] ACPI: RSDT 2FEF3040, 0030 (r1 HPQOEM SLIC-BPC 42302E31 AWRD    
   0)
[    0.000000] ACPI: FACP 2FEF30C0, 0084 (r2 HPQOEM SLIC-BPC 42302E31 AWRD    
   0)
[    0.000000] ACPI: DSDT 2FEF31C0, 3C26 (r1 HPQOEM AWRDACPI     1000 MSFT 
100000E)
[    0.000000] ACPI: FACS 2FEF0000, 0040
[    0.000000] ACPI: MCFG 2FEF6F40, 003C (r1 HPQOEM SLIC-BPC 42302E31 AWRD    
   0)
[    0.000000] ACPI: APIC 2FEF6E40, 0084 (r1 HPQOEM SLIC-BPC 42302E31 AWRD    
   0)
[    0.000000] ACPI: DMI detected: Hewlett-Packard
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 30000000 (gap:
2ff00000:b0100000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 30760 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total
pages: 194705
[    0.000000] Kernel command line: root=/dev/sda7 ro
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c035b000 soft=c0359000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 3000.236 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 771820k/785344k available (1552k kernel code, 12992k
reserved, 611k data, 212k init, 0k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
[    0.004000]     vmalloc : 0xf0800000 - 0xfffb7000   ( 247 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xefef0000   ( 766 MB)
[    0.004000]       .init : 0xc0321000 - 0xc0356000   ( 212 kB)
[    0.004000]       .data : 0xc0284166 - 0xc031cfa0   ( 611 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0284166   (1552 kB)
[    0.004000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.084076] Calibrating delay using timer specific routine.. 6009.35
BogoMIPS (lpj=12018705)
[    0.084288] Mount-cache hash table entries: 512
[    0.084549] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.084722] CPU: L2 cache: 1024K
[    0.084818] CPU: Physical Processor ID: 0
[    0.084916] Intel machine check architecture supported.
[    0.085020] Intel machine check reporting enabled on CPU#0.
[    0.085122] CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.085225] CPU0: Thermal monitoring enabled
[    0.085323] using mwait in idle threads.
[    0.085427] Checking 'hlt' instruction... OK.
[    0.100466] ACPI: Core revision 20080321
[    0.116000] ENABLING IO-APIC IRQs
[    0.116000] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.116000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.116000] ...trying to set up timer (IRQ0) through the 8259A ... 
[    0.116000] ..... (found pin 2) ...works.
[    0.155971] CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
[    0.160000] CPU 1 irqstacks, hard=c035c000 soft=c035a000
[    0.160000] Booting processor 1/1 ip 6000
[    0.168010] Initializing CPU#1
[    0.168010] Calibrating delay using timer specific routine.. 6000.40
BogoMIPS (lpj=12000803)
[    0.168010] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.168010] CPU: L2 cache: 1024K
[    0.168010] CPU: Physical Processor ID: 0
[    0.168010] Intel machine check architecture supported.
[    0.168010] Intel machine check reporting enabled on CPU#1.
[    0.168010] CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.168010] CPU1: Thermal monitoring enabled
[    0.248000] CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
[    0.248000] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.252000] Brought up 2 CPUs
[    0.252000] Total of 2 processors activated (12009.75 BogoMIPS).
[    0.168010] net_namespace: 636 bytes
[    0.168010] NET: Registered protocol family 16
[    0.168010] ACPI: bus type pci registered
[    0.168010] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -
255
[    0.168010] PCI: MCFG area at e0000000 reserved in E820
[    0.168010] PCI: Using MMCONFIG for extended config space
[    0.168010] PCI: Using configuration type 1 for base access
[    0.168010] Setting up standard PCI resources
[    0.260000] ACPI: EC: Look up EC in DSDT
[    0.264000] ACPI: Interpreter enabled
[    0.264000] ACPI: (supports S0 S3 S5)
[    0.264326] ACPI: Using IOAPIC for interrupt routing
[    0.272000] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.272000] PCI: Transparent bridge - 0000:00:14.4
[    0.272000] bus 00 -> node 0
[    0.272000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.272000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.288000] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0,
disabled.
[    0.288000] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0,
disabled.
[    0.288000] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0,
disabled.
[    0.289014] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0,
disabled.
[    0.290020] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *7 10 11)
[    0.290871] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0,
disabled.
[    0.291880] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 *11)
[    0.292733] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 6 7 10 11)
[    0.296000] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.296000] pnp: PnP ACPI init
[    0.296000] ACPI: bus type pnp registered
[    0.300000] pnp 00:0a: mem resource (0xe0000000-0xefffffff) overlaps
0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.300000] pnp 00:0b: mem resource (0xffff0000-0xffffffff) overlaps
0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.300000] pnp 00:0b: mem resource (0xfec00000-0xfec00fff) overlaps
0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.300000] pnp 00:0b: mem resource (0xfee00000-0xfee00fff) overlaps
0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.300000] pnp 00:0b: mem resource (0xfff80000-0xfffeffff) overlaps
0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.300000] pnp: PnP ACPI: found 12 devices
[    0.300000] ACPI: ACPI bus type pnp unregistered
[    0.300000] PCI: Using ACPI for IRQ routing
[    0.300000] PCI: Cannot allocate resource region 3 of device 0000:00:00.0
[    0.309434] system 00:01: ioport range 0x140-0x15f has been reserved
[    0.309542] system 00:01: ioport range 0x228-0x22f has been reserved
[    0.309646] system 00:01: ioport range 0x40b-0x40b has been reserved
[    0.309748] system 00:01: ioport range 0x4d6-0x4d6 has been reserved
[    0.309851] system 00:01: ioport range 0xc00-0xc01 has been reserved
[    0.309954] system 00:01: ioport range 0xc14-0xc14 has been reserved
[    0.310057] system 00:01: ioport range 0xc50-0xc52 has been reserved
[    0.310160] system 00:01: ioport range 0xc6c-0xc6d has been reserved
[    0.310262] system 00:01: ioport range 0xc6f-0xc6f has been reserved
[    0.310365] system 00:01: ioport range 0xcd4-0xcdf has been reserved
[    0.310468] system 00:01: ioport range 0x4000-0x40fe has been reserved
[    0.310572] system 00:01: ioport range 0x4210-0x4217 has been reserved
[    0.310683] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    0.310786] system 00:06: ioport range 0x260-0x267 has been reserved
[    0.310889] system 00:06: ioport range 0x880-0x88f has been reserved
[    0.311005] system 00:0b: iomem range 0xd0000-0xd3fff has been reserved
[    0.311110] system 00:0b: iomem range 0xd5000-0xd7fff has been reserved
[    0.311213] system 00:0b: iomem range 0xf0000-0xfbfff could not be reserved
[    0.311318] system 00:0b: iomem range 0xfc000-0xfffff could not be reserved
[    0.311422] system 00:0b: iomem range 0x2ff00000-0x2fffffff has been
reserved
[    0.311527] system 00:0b: iomem range 0x2fef0000-0x2fefffff could not be
reserved
[    0.311651] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[    0.311754] system 00:0b: iomem range 0x100000-0x2feeffff could not be
reserved
[    0.342030] PCI: Bridge: 0000:00:14.4
[    0.342130]   IO window: e000-efff
[    0.342232]   MEM window: 0xfb000000-0xfcffffff
[    0.342334]   PREFETCH window: 0x00000000d8000000-0x00000000dfffffff
[    0.342462] NET: Registered protocol family 2
[    0.353006] IP route cache hash table entries: 32768 (order: 5, 131072
bytes)
[    0.355493] TCP established hash table entries: 131072 (order: 8, 1048576
bytes)
[    0.356039] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.356039] TCP: Hash tables configured (established 131072 bind 65536)
[    0.356168] TCP reno registered
[    0.360259] NET: Registered protocol family 1
[    0.360501] Unpacking initramfs... done
[    0.500349] Freeing initrd memory: 3272k freed
[    0.501709] Machine check exception polling timer started.
[    0.504054] VFS: Disk quotas dquot_6.5.1
[    0.504054] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.504054] msgmni has been set to 1514
[    0.504054] io scheduler noop registered
[    0.504054] io scheduler cfq registered (default)
[    0.861921] Switched to high resolution mode on CPU 1
[    0.861936] Switched to high resolution mode on CPU 0
[    8.544029] pci 0000:00:13.2: EHCI: BIOS handoff failed (BIOS bug?)
01010001
[    8.544157] pci 0000:01:00.0: Boot video device
[    8.584003] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ
sharing enabled
[    8.584003] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.584004] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.588005] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64
irq 1,12
[    8.588005] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.588005] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.588005] mice: PS/2 mouse device common for all mice
[    8.588005] cpuidle: using governor ladder
[    8.588005] TCP cubic registered
[    8.588005] Using IPI No-Shortcut mode
[    8.592095] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    8.592095] Freeing unused kernel memory: 212k freed
[    8.616004] input: AT Translated Set 2 keyboard as /class/input/input0
[    8.752005] fuse init (API version 7.9)
[    8.764005] processor ACPI0007:00: registered as cooling_device0
[    8.764005] ACPI: Processor [CPU0] (supports 8 throttling states)
[    8.765002] processor ACPI0007:01: registered as cooling_device1
[    8.765002] ACPI: Processor [CPU1] (supports 8 throttling states)
[    9.193003] Uniform Multi-Platform E-IDE driver
[    9.205002] No dock devices found.
[    9.228004] usbcore: registered new interface driver usbfs
[    9.228004] usbcore: registered new interface driver hub
[    9.265550] usbcore: registered new device driver usb
[    9.266666] SCSI subsystem initialized
[    9.309003] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI)
Driver
[    9.309003] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) ->
IRQ 19
[    9.309003] Int: type 0, pol 3, trig 3, bus 00, IRQ 4c, APIC ID 4, APIC INT
13
[    9.309148] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    9.309148] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus
number 1
[    9.309148] ohci_hcd 0000:00:13.0: irq 19, io mem 0xfdffe000
[    9.310868] libata version 3.00 loaded.
[    9.369339] usb usb1: configuration #1 chosen from 1 choice
[    9.369512] hub 1-0:1.0: USB hub found
[    9.369635] hub 1-0:1.0: 4 ports detected
[    9.377003] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    9.581018] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) ->
IRQ 19
[    9.581018] Int: type 0, pol 3, trig 3, bus 00, IRQ 4c, APIC ID 4, APIC INT
13
[    9.581018] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    9.581018] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus
number 2
[    9.581018] ohci_hcd 0000:00:13.1: irq 19, io mem 0xfdffd000
[    9.639778] usb usb2: configuration #1 chosen from 1 choice
[    9.639925] hub 2-0:1.0: USB hub found
[    9.640036] hub 2-0:1.0: 4 ports detected
[    9.744018] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) ->
IRQ 19
[    9.744018] Int: type 0, pol 3, trig 3, bus 00, IRQ 4c, APIC ID 4, APIC INT
13
[    9.744018] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    9.744018] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus
number 3
[    9.744018] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfdffc000
[    9.753513] usb 1-2: new low speed USB device using ohci_hcd and address 2
[    9.765050] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10
Dec 2004
[    9.765285] usb usb3: configuration #1 chosen from 1 choice
[    9.765427] hub 3-0:1.0: USB hub found
[    9.765534] hub 3-0:1.0: 8 ports detected
[    9.820059] hub 1-0:1.0: unable to enumerate USB device on port 2
[    9.976018] ATIIXP: IDE controller (0x1002:0x4376 rev 0x80) at  PCI slot
0000:00:14.1
[    9.976018] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) ->
IRQ 16
[    9.976018] Int: type 0, pol 3, trig 3, bus 00, IRQ 50, APIC ID 4, APIC INT
10
[    9.976018] ATIIXP: not 100% native mode: will probe irqs later
[    9.976018]     ide0: BM-DMA at 0xf900-0xf907
[    9.976018] ATIIXP: simplex device: DMA disabled
[    9.976018] ide1: DMA disabled
[    9.976018] Probing IDE interface ide0...
[   10.372112] usb 1-2: new low speed USB device using ohci_hcd and address 3
[   10.580210] usb 1-2: configuration #1 chosen from 1 choice
[   10.710172] hda: LITE-ON DVDRW SHM-165H6S, ATAPI CD/DVD-ROM drive
[   11.380574] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[   11.380862] hda: host side 80-wire cable detection failed, limiting max
speed to UDMA33
[   11.380988] hda: UDMA/33 mode selected
[   11.381371] Probing IDE interface ide1...
[   11.940103] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   11.953232] ide1 at 0x170-0x177,0x376 on irq 15
[   11.956018] 8139cp 0000:01:03.0: This (id 10ec:8139 rev 10) is not an
8139C+ compatible chip
[   11.956018] 8139cp 0000:01:03.0: Try the "8139too" driver instead.
[   11.966710] 8139too Fast Ethernet driver 0.9.28
[   11.966897] ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 23 (level, low) ->
IRQ 23
[   11.967105] Int: type 0, pol 3, trig 3, bus 01, IRQ 0c, APIC ID 4, APIC INT
17
[   11.968353] eth0: RealTek RTL8139 at 0xf08cc000, 00:19:db:59:ba:be, IRQ 23
[   11.968462] eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
[   11.975904] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) ->
IRQ 22
[   11.977004] Int: type 0, pol 3, trig 3, bus 00, IRQ 48, APIC ID 4, APIC INT
16
[   11.978675] sata_sil 0000:00:12.0: version 2.3
[   11.983830] scsi0 : sata_sil
[   11.985006] scsi1 : sata_sil
[   11.985006] ata1: SATA max UDMA/100 mmio m512@0xfdfff000 tf 0xfdfff080 irq
22
[   11.985006] ata2: SATA max UDMA/100 mmio m512@0xfdfff000 tf 0xfdfff0c0 irq
22
[   11.992321] input: Logitech Logitech USB Optical Mouse as
/class/input/input1
[   11.996396] input,hidraw0: USB HID v1.11 Mouse [Logitech Logitech USB
Optical Mouse] on usb-0000:00:13.0-2
[   11.996829] usbcore: registered new interface driver usbhid
[   11.996933] usbhid: v2.6:USB HID core driver
[   12.307535] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   12.315571] ata1.00: ATA-7: WDC WD1600JS-60MHB5, 10.02E04, max UDMA/100
[   12.315678] ata1.00: 312581808 sectors, multi 16: LBA48 
[   12.324018] ata1.00: configured for UDMA/100
[   12.642648] ata2: SATA link down (SStatus 0 SControl 310)
[   12.642648] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-60M 10.0
PQ: 0 ANSI: 5
[   12.656005] hda: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
[   12.656005] Uniform CD-ROM driver Revision: 3.20
[   12.658633] Driver 'sd' needs updating - please use bus_type methods
[   12.658633] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042
MB)
[   12.658641] sd 0:0:0:0: [sda] Write Protect is off
[   12.658641] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   12.658641] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   12.658641] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042
MB)
[   12.658641] sd 0:0:0:0: [sda] Write Protect is off
[   12.658641] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   12.658641] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   12.658641]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[   12.732027] sd 0:0:0:0: [sda] Attached SCSI disk
[   13.298656] kjournald starting.  Commit interval 5 seconds
[   13.300018] EXT3-fs: mounted filesystem with ordered data mode.
[   19.268854] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   19.817020] warning: `dhclient3' uses 32-bit capabilities (legacy support
in use)
[   20.004008] input: Power Button (FF) as /class/input/input2
[   20.036004] Linux agpgart interface v0.103
[   20.062295] ACPI: Power Button (FF) [PWRF]
[   20.062516] input: Power Button (CM) as /class/input/input3
[   20.112007] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0x500,
revision 0
[   20.124009] ACPI: Power Button (CM) [PWRB]
[   20.360023] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) ->
IRQ 16
[   20.360023] Int: type 0, pol 3, trig 3, bus 00, IRQ 50, APIC ID 4, APIC INT
10
[   20.900004] NET: Registered protocol family 17
[   21.084018] loop: module loaded
[   21.188754] Adding 2096472k swap on /dev/sda3.  Priority:-1 extents:1
across:2096472k
[   21.445307] EXT3 FS on sda7, internal journal
[   21.896018] ip_tables: (C) 2000-2006 Netfilter Core Team
[   23.320002] NET: Registered protocol family 10
[   23.322075] lo: Disabled Privacy Extensions
[   32.572010] hda-intel: Invalid position buffer, using LPIB read method
instead.
[    0.000000] Linux version 2.6.26-rc5-mm3mmtry (hagbard@hardy) (gcc version
4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #1 SMP Thu Jun 12 14:21:37 CDT 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000002fef0000 (usable)
[    0.000000]  BIOS-e820: 000000002fef0000 - 000000002fef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000002fef3000 - 000000002ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] last_pfn = 196336 max_arch_pfn = 1048576
[    0.000000] 766MB LOWMEM available.
[    0.000000] old RAMDISK: 2fbad000 - 2fedf38a
[    0.000000]   mapped low ram: 0 - 00800000
[    0.000000]   low ram: 0039d000 - 2fef0000
[    0.000000]   bootmap 0039d000 - 003a2fe0
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [1000-1fff] EX TRAMPOLINE
[    0.000000]   early res: 2 [6000-6fff] TRAMPOLINE
[    0.000000]   early res: 3 [100000-39ac4f] TEXT DATA BSS
[    0.000000]   early res: 4 [2fbad000-2fedf389] RAMDISK
[    0.000000]   early res: 5 [39b000-39cfff] INIT_PG_TABLE
[    0.000000]   early res: 6 [9f000-fffff] BIOS reserved
[    0.000000]   early res: 7 [39d000-3a2fff] BOOTMAP
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f49f0] 000f49f0
[    0.000000] sizeof(struct page) = 32
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   196336
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   196336
[    0.000000] On node 0 totalpages: 196239
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 190738 pages, LIFO batch:31
[    0.000000] DMI 2.5 present.
[    0.000000] ACPI: RSDP 000F8AA0, 0014 (r0 HPQOEM)
[    0.000000] ACPI: RSDT 2FEF3040, 0030 (r1 HPQOEM SLIC-BPC 42302E31 AWRD    
   0)
[    0.000000] ACPI: FACP 2FEF30C0, 0084 (r2 HPQOEM SLIC-BPC 42302E31 AWRD    
   0)
[    0.000000] ACPI: DSDT 2FEF31C0, 3C26 (r1 HPQOEM AWRDACPI     1000 MSFT 
100000E)
[    0.000000] ACPI: FACS 2FEF0000, 0040
[    0.000000] ACPI: MCFG 2FEF6F40, 003C (r1 HPQOEM SLIC-BPC 42302E31 AWRD    
   0)
[    0.000000] ACPI: APIC 2FEF6E40, 0084 (r1 HPQOEM SLIC-BPC 42302E31 AWRD    
   0)
[    0.000000] ACPI: DMI detected: Hewlett-Packard
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 30000000 (gap:
2ff00000:b0100000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 30760 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total
pages: 194705
[    0.000000] Kernel command line: root=/dev/sda7 ro
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c035b000 soft=c0359000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 3000.355 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 771820k/785344k available (1552k kernel code, 12992k
reserved, 611k data, 212k init, 0k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
[    0.004000]     vmalloc : 0xf0800000 - 0xfffb7000   ( 247 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xefef0000   ( 766 MB)
[    0.004000]       .init : 0xc0321000 - 0xc0356000   ( 212 kB)
[    0.004000]       .data : 0xc0284166 - 0xc031cfa0   ( 611 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0284166   (1552 kB)
[    0.004000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.084077] Calibrating delay using timer specific routine.. 6009.33
BogoMIPS (lpj=12018666)
[    0.084290] Mount-cache hash table entries: 512
[    0.084550] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.084723] CPU: L2 cache: 1024K
[    0.084819] CPU: Physical Processor ID: 0
[    0.084918] Intel machine check architecture supported.
[    0.085022] Intel machine check reporting enabled on CPU#0.
[    0.085123] CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.085227] CPU0: Thermal monitoring enabled
[    0.085326] using mwait in idle threads.
[    0.085430] Checking 'hlt' instruction... OK.
[    0.100466] ACPI: Core revision 20080321
[    0.116000] ENABLING IO-APIC IRQs
[    0.116000] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.116000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.116000] ...trying to set up timer (IRQ0) through the 8259A ... 
[    0.116000] ..... (found pin 2) ...works.
[    0.157298] CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
[    0.160000] CPU 1 irqstacks, hard=c035c000 soft=c035a000
[    0.160000] Booting processor 1/1 ip 6000
[    0.168010] Initializing CPU#1
[    0.168010] Calibrating delay using timer specific routine.. 6000.36
BogoMIPS (lpj=12000731)
[    0.168010] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.168010] CPU: L2 cache: 1024K
[    0.168010] CPU: Physical Processor ID: 0
[    0.168010] Intel machine check architecture supported.
[    0.168010] Intel machine check reporting enabled on CPU#1.
[    0.168010] CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.168010] CPU1: Thermal monitoring enabled
[    0.248000] CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
[    0.248000] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.252000] Brought up 2 CPUs
[    0.252000] Total of 2 processors activated (12009.69 BogoMIPS).
[    0.168010] net_namespace: 636 bytes
[    0.168010] NET: Registered protocol family 16
[    0.168010] ACPI: bus type pci registered
[    0.168010] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -
255
[    0.168010] PCI: MCFG area at e0000000 reserved in E820
[    0.168010] PCI: Using MMCONFIG for extended config space
[    0.168010] PCI: Using configuration type 1 for base access
[    0.168010] Setting up standard PCI resources
[    0.260000] ACPI: EC: Look up EC in DSDT
[    0.264000] ACPI: Interpreter enabled
[    0.264000] ACPI: (supports S0 S3 S5)
[    0.264325] ACPI: Using IOAPIC for interrupt routing
[    0.272000] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.272000] PCI: Transparent bridge - 0000:00:14.4
[    0.272000] bus 00 -> node 0
[    0.272000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.272000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.288000] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0,
disabled.
[    0.288000] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0,
disabled.
[    0.288000] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0,
disabled.
[    0.289012] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0,
disabled.
[    0.290020] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *7 10 11)
[    0.290868] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0,
disabled.
[    0.291873] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 *11)
[    0.292726] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 6 7 10 11)
[    0.296000] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.296000] pnp: PnP ACPI init
[    0.296000] ACPI: bus type pnp registered
[    0.300000] pnp 00:0a: mem resource (0xe0000000-0xefffffff) overlaps
0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.300000] pnp 00:0b: mem resource (0xffff0000-0xffffffff) overlaps
0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.300000] pnp 00:0b: mem resource (0xfec00000-0xfec00fff) overlaps
0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.300000] pnp 00:0b: mem resource (0xfee00000-0xfee00fff) overlaps
0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.300000] pnp 00:0b: mem resource (0xfff80000-0xfffeffff) overlaps
0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.300000] pnp: PnP ACPI: found 12 devices
[    0.300000] ACPI: ACPI bus type pnp unregistered
[    0.300000] PCI: Using ACPI for IRQ routing
[    0.300000] PCI: Cannot allocate resource region 3 of device 0000:00:00.0
[    0.309432] system 00:01: ioport range 0x140-0x15f has been reserved
[    0.309539] system 00:01: ioport range 0x228-0x22f has been reserved
[    0.309643] system 00:01: ioport range 0x40b-0x40b has been reserved
[    0.309745] system 00:01: ioport range 0x4d6-0x4d6 has been reserved
[    0.309848] system 00:01: ioport range 0xc00-0xc01 has been reserved
[    0.309950] system 00:01: ioport range 0xc14-0xc14 has been reserved
[    0.310053] system 00:01: ioport range 0xc50-0xc52 has been reserved
[    0.310156] system 00:01: ioport range 0xc6c-0xc6d has been reserved
[    0.310259] system 00:01: ioport range 0xc6f-0xc6f has been reserved
[    0.310361] system 00:01: ioport range 0xcd4-0xcdf has been reserved
[    0.310464] system 00:01: ioport range 0x4000-0x40fe has been reserved
[    0.310568] system 00:01: ioport range 0x4210-0x4217 has been reserved
[    0.310679] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    0.310785] system 00:06: ioport range 0x260-0x267 has been reserved
[    0.310888] system 00:06: ioport range 0x880-0x88f has been reserved
[    0.311002] system 00:0b: iomem range 0xd0000-0xd3fff has been reserved
[    0.311107] system 00:0b: iomem range 0xd5000-0xd7fff has been reserved
[    0.311211] system 00:0b: iomem range 0xf0000-0xfbfff could not be reserved
[    0.311315] system 00:0b: iomem range 0xfc000-0xfffff could not be reserved
[    0.311420] system 00:0b: iomem range 0x2ff00000-0x2fffffff has been
reserved
[    0.311524] system 00:0b: iomem range 0x2fef0000-0x2fefffff could not be
reserved
[    0.311649] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[    0.311753] system 00:0b: iomem range 0x100000-0x2feeffff could not be
reserved
[    0.343998] PCI: Bridge: 0000:00:14.4
[    0.343998]   IO window: e000-efff
[    0.343998]   MEM window: 0xfb000000-0xfcffffff
[    0.343998]   PREFETCH window: 0x00000000d8000000-0x00000000dfffffff
[    0.343998] NET: Registered protocol family 2
[    0.358429] IP route cache hash table entries: 32768 (order: 5, 131072
bytes)
[    0.360053] TCP established hash table entries: 131072 (order: 8, 1048576
bytes)
[    0.360053] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.360773] TCP: Hash tables configured (established 131072 bind 65536)
[    0.360880] TCP reno registered
[    0.364856] NET: Registered protocol family 1
[    0.365096] Unpacking initramfs... done
[    0.504890] Freeing initrd memory: 3272k freed
[    0.505717] Machine check exception polling timer started.
[    0.508062] VFS: Disk quotas dquot_6.5.1
[    0.508062] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.508062] msgmni has been set to 1514
[    0.508062] io scheduler noop registered
[    0.508062] io scheduler cfq registered (default)
[    0.861916] Switched to high resolution mode on CPU 1
[    0.861932] Switched to high resolution mode on CPU 0
[    8.560029] pci 0000:00:13.2: EHCI: BIOS handoff failed (BIOS bug?)
01010001
[    8.560156] pci 0000:01:00.0: Boot video device
[    8.600005] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ
sharing enabled
[    8.600005] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.600145] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.604025] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64
irq 1,12
[    8.604025] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.604025] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.604025] mice: PS/2 mouse device common for all mice
[    8.608025] cpuidle: using governor ladder
[    8.608025] TCP cubic registered
[    8.608025] Using IPI No-Shortcut mode
[    8.608025] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    8.608025] Freeing unused kernel memory: 212k freed
[    8.632005] input: AT Translated Set 2 keyboard as /class/input/input0
[    8.768006] fuse init (API version 7.9)
[    8.780006] processor ACPI0007:00: registered as cooling_device0
[    8.780006] ACPI: Processor [CPU0] (supports 8 throttling states)
[    8.781004] processor ACPI0007:01: registered as cooling_device1
[    8.781004] ACPI: Processor [CPU1] (supports 8 throttling states)
[    9.311434] usbcore: registered new interface driver usbfs
[    9.311649] usbcore: registered new interface driver hub
[    9.317004] usbcore: registered new device driver usb
[    9.320005] Uniform Multi-Platform E-IDE driver
[    9.330149] No dock devices found.
[    9.344004] SCSI subsystem initialized
[    9.399199] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) ->
IRQ 19
[    9.399408] Int: type 0, pol 3, trig 3, bus 00, IRQ 4c, APIC ID 4, APIC INT
13
[    9.399555] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    9.399724] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus
number 1
[    9.399932] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfdffc000
[    9.413106] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10
Dec 2004
[    9.413525] usb usb1: configuration #1 chosen from 1 choice
[    9.413690] hub 1-0:1.0: USB hub found
[    9.413812] hub 1-0:1.0: 8 ports detected
[    9.417005] libata version 3.00 loaded.
[    9.417005] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI)
Driver
[    9.425004] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    9.625018] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) ->
IRQ 19
[    9.625018] Int: type 0, pol 3, trig 3, bus 00, IRQ 4c, APIC ID 4, APIC INT
13
[    9.625018] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    9.625018] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus
number 2
[    9.625018] ohci_hcd 0000:00:13.0: irq 19, io mem 0xfdffe000
[    9.684134] usb usb2: configuration #1 chosen from 1 choice
[    9.684278] hub 2-0:1.0: USB hub found
[    9.684391] hub 2-0:1.0: 4 ports detected
[    9.893018] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) ->
IRQ 19
[    9.893018] Int: type 0, pol 3, trig 3, bus 00, IRQ 4c, APIC ID 4, APIC INT
13
[    9.893018] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    9.893018] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus
number 3
[    9.893018] ohci_hcd 0000:00:13.1: irq 19, io mem 0xfdffd000
[    9.949224] usb usb3: configuration #1 chosen from 1 choice
[    9.949367] hub 3-0:1.0: USB hub found
[    9.949478] hub 3-0:1.0: 4 ports detected
[   10.056717] ATIIXP: IDE controller (0x1002:0x4376 rev 0x80) at  PCI slot
0000:00:14.1
[   10.056884] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) ->
IRQ 16
[   10.057018] Int: type 0, pol 3, trig 3, bus 00, IRQ 50, APIC ID 4, APIC INT
10
[   10.057018] ATIIXP: not 100% native mode: will probe irqs later
[   10.057018]     ide0: BM-DMA at 0xf900-0xf907
[   10.057018] ATIIXP: simplex device: DMA disabled
[   10.057018] ide1: DMA disabled
[   10.057018] Probing IDE interface ide0...
[   10.193880] usb 2-2: new low speed USB device using ohci_hcd and address 2
[   10.400245] usb 2-2: configuration #1 chosen from 1 choice
[   10.795646] hda: LITE-ON DVDRW SHM-165H6S, ATAPI CD/DVD-ROM drive
[   11.466075] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[   11.466364] hda: host side 80-wire cable detection failed, limiting max
speed to UDMA33
[   11.466492] hda: UDMA/33 mode selected
[   11.466877] Probing IDE interface ide1...
[   12.030291] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   12.042483] ide1 at 0x170-0x177,0x376 on irq 15
[   12.045018] 8139cp 0000:01:03.0: This (id 10ec:8139 rev 10) is not an
8139C+ compatible chip
[   12.045018] 8139cp 0000:01:03.0: Try the "8139too" driver instead.
[   12.049006] 8139too Fast Ethernet driver 0.9.28
[   12.049006] ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 23 (level, low) ->
IRQ 23
[   12.049006] Int: type 0, pol 3, trig 3, bus 01, IRQ 0c, APIC ID 4, APIC INT
17
[   12.049006] eth0: RealTek RTL8139 at 0xf08a8000, 00:19:db:59:ba:be, IRQ 23
[   12.049006] eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
[   12.064814] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) ->
IRQ 22
[   12.065003] Int: type 0, pol 3, trig 3, bus 00, IRQ 48, APIC ID 4, APIC INT
16
[   12.069003] sata_sil 0000:00:12.0: version 2.3
[   12.069003] scsi0 : sata_sil
[   12.069003] scsi1 : sata_sil
[   12.069003] ata1: SATA max UDMA/100 mmio m512@0xfdfff000 tf 0xfdfff080 irq
22
[   12.069003] ata2: SATA max UDMA/100 mmio m512@0xfdfff000 tf 0xfdfff0c0 irq
22
[   12.076007] input: Logitech Logitech USB Optical Mouse as
/class/input/input1
[   12.081027] input,hidraw0: USB HID v1.11 Mouse [Logitech Logitech USB
Optical Mouse] on usb-0000:00:13.0-2
[   12.081027] usbcore: registered new interface driver usbhid
[   12.081027] usbhid: v2.6:USB HID core driver
[   12.388069] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   12.397018] ata1.00: ATA-7: WDC WD1600JS-60MHB5, 10.02E04, max UDMA/100
[   12.397018] ata1.00: 312581808 sectors, multi 16: LBA48 
[   12.405018] ata1.00: configured for UDMA/100
[   12.727799] ata2: SATA link down (SStatus 0 SControl 310)
[   12.728018] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-60M 10.0
PQ: 0 ANSI: 5
[   12.740394] hda: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
[   12.740926] Uniform CD-ROM driver Revision: 3.20
[   12.745007] Driver 'sd' needs updating - please use bus_type methods
[   12.745007] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042
MB)
[   12.745007] sd 0:0:0:0: [sda] Write Protect is off
[   12.745007] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   12.745007] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   12.745008] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042
MB)
[   12.745008] sd 0:0:0:0: [sda] Write Protect is off
[   12.745008] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   12.745008] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   12.745008]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[   12.815852] sd 0:0:0:0: [sda] Attached SCSI disk
[   13.301018] kjournald starting.  Commit interval 5 seconds
[   13.301018] EXT3-fs: mounted filesystem with ordered data mode.
[   19.333007] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   19.692997] warning: `dhclient3' uses 32-bit capabilities (legacy support
in use)
[   20.039910] input: Power Button (FF) as /class/input/input2
[   20.060272] Linux agpgart interface v0.103
[   20.085753] ACPI: Power Button (FF) [PWRF]
[   20.088996] input: Power Button (CM) as /class/input/input3
[   20.149397] ACPI: Power Button (CM) [PWRB]
[   20.377009] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0x500,
revision 0
[   20.413013] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) ->
IRQ 16
[   20.413013] Int: type 0, pol 3, trig 3, bus 00, IRQ 50, APIC ID 4, APIC INT
10
[   21.053002] NET: Registered protocol family 17
[   21.161009] loop: module loaded
[   21.273705] Adding 2096472k swap on /dev/sda3.  Priority:-1 extents:1
across:2096472k
[   21.530304] EXT3 FS on sda7, internal journal
[   21.981009] ip_tables: (C) 2000-2006 Netfilter Core Team
[   23.356992] NET: Registered protocol family 10
[   23.356993] lo: Disabled Privacy Extensions
[   32.717001] hda-intel: Invalid position buffer, using LPIB read method
instead.
[   33.165017] ------------[ cut here ]------------
[   33.165017] Kernel BUG at c0141256 [verbose debug info unavailable]
[   33.165017] invalid opcode: 0000 [#1] SMP 
[   33.165017] last sysfs file:
/sys/devices/pci0000:00/0000:00:14.4/0000:01:03.0/resource
[   33.165017] Modules linked in: ipv6 sbs sbshc container battery
iptable_filter ip_tables x_tables ac loop af_packet snd_hda_intel snd_pcm
serio_raw i2c_piix4 snd_timer psmouse i2c_core snd soundcore snd_page_alloc
ati_agp agpgart button evdev ext3 jbd mbcache sd_mod ide_cd_mod cdrom
pata_atiixp usbhid hid sata_sil pata_acpi 8139too ata_generic atiixp 8139cp
mii ohci_hcd ehci_hcd libata scsi_mod dock ide_pci_generic ide_core usbcore
thermal processor fan fuse
[   33.165017] 
[   33.165017] Pid: 5400, comm: aplay Not tainted (2.6.26-rc5-mm3mmtry #1)
[   33.165017] EIP: 0060:[<c0141256>] EFLAGS: 00010246 CPU: 0
[   33.165017] EIP is at unlock_page+0xe/0x23
[   33.165017] EAX: 00000000 EBX: c14add60 ECX: 00000000 EDX: c14add60
[   33.165017] ESI: 00000001 EDI: c14add60 EBP: eeed6630 ESP: eef79dec
[   33.165017]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   33.165017] Process aplay (pid: 5400, ti=eef79000 task=eec6b960
task.ti=eef79000)
[   33.165017] Stack: 00000000 c0149c37 0000000e 000040ca c0131baf 00000000
00000000 00000000 
[   33.165017]        ffffffff 0000000e 00000000 c14add60 c14add80 c14adda0
c14addc0 c14adde0 
[   33.165017]        c14ade00 c14aef00 c14aef20 c14aef40 c14aef60 c14aef80
c14aefa0 c14aefc0 
[   33.165017] Call Trace:
[   33.165017]  [<c0149c37>] truncate_inode_pages_range+0xc4/0x336
[   33.165017]  [<c0131baf>] getnstimeofday+0x37/0xdf
[   33.165018]  [<c015d5c7>] shmem_delete_inode+0x0/0xb6
[   33.165018]  [<c0149ec0>] truncate_inode_pages+0x17/0x27
[   33.165018]  [<c015d60f>] shmem_delete_inode+0x48/0xb6
[   33.165018]  [<c015d5c7>] shmem_delete_inode+0x0/0xb6
[   33.165018]  [<c0172fc1>] generic_delete_inode+0x7f/0x100
[   33.165018]  [<c01726c4>] iput+0x44/0x4a
[   33.165018]  [<c017069a>] d_kill+0x2b/0x44
[   33.165018]  [<c01717d6>] dput+0xc3/0x16f
[   33.165018]  [<c016237d>] __fput+0x117/0x16f
[   33.165018]  [<c01a373c>] shm_destroy+0x36/0x3e
[   33.165018]  [<c01a43e1>] sys_shmctl+0x60b/0x61e
[   33.165018]  [<c01764a7>] mnt_drop_write+0x1d/0xd4
[   33.165018]  [<c01a364f>] sys_shmdt+0x10f/0x139
[   33.165018]  [<c0106799>] sys_ipc+0x42/0x28e
[   33.165018]  [<c01535e6>] sys_munmap+0x30/0x35
[   33.165018]  [<c0102de1>] sysenter_past_esp+0x6a/0x91
[   33.165018]  [<c0280000>] setup_local_APIC+0x3f/0x1aa
[   33.165018]  =======================
[   33.165018] Code: 74 09 8b 52 08 85 d2 74 02 ff d2 e8 37 0d 14 00 31 c0 8d
76 00 c3 ba a0 fa 2f c0 eb de 53 89 c3 f0 0f ba 30 00 19 c0 85 c0 75 04 <0f>
0b eb fe 89 d8 e8 7f f4 ff ff 31 c9 89 da 5b e9 9e b8 fe ff 
[   33.165018] EIP: [<c0141256>] unlock_page+0xe/0x23 SS:ESP 0068:eef79dec
[   33.165018] ---[ end trace f0d41f68fa3deb86 ]---
[   33.953013] eth0: no IPv6 routers present



      
