Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbZIRUii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbZIRUii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbZIRUid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:38:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35083 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173AbZIRUia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:38:30 -0400
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090918202245.GR23126@kernel.dk>
References: <20090917124233.GJ23126@kernel.dk>
	 <20090917194027.GS23126@kernel.dk>
	 <1253229410.2783.16.camel@heimdal.trondhjem.org>
	 <20090918064006.GU23126@kernel.dk> <20090918150248.GB23126@kernel.dk>
	 <1253290790.3183.14.camel@heimdal.trondhjem.org>
	 <20090918173608.GD23126@kernel.dk> <20090918183203.GG23126@kernel.dk>
	 <1253305003.10538.72.camel@laptop>  <20090918202245.GR23126@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Sep 2009 22:38:26 +0200
Message-Id: <1253306306.10538.80.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 22:22 +0200, Jens Axboe wrote:
> On Fri, Sep 18 2009, Peter Zijlstra wrote:
> > On Fri, 2009-09-18 at 20:32 +0200, Jens Axboe wrote:
> > > Peter, if you have
> > > the time, it would be nice if you could check whether this one works for
> > > you too.
> > 
> > Doesn't make my machine happy :/
> 
> That looks like a double register. Irk, I see what it is... Can you try
> this additional patch?

Still deeply unhappy,..

1) double bdi registation
2) lockdep splat on bdi registration
3) NULL ptr deref on netfs automount

Also note the lockdep splat which I think is caused by these patches..

  Booting 'Fedora (2.6.31-tip)'                                                                                
[    0.000000] Initializing cgroup subsys cpuset                                                
[    0.000000] Initializing cgroup subsys cpu                                                                  
[    0.000000] Linux version 2.6.31-tip (root@twins) (gcc version 4.3.1 20080510 (prerelease) (GCC) ) #15 SMP PREEMPT Fri Sep 18 22:10:02 CEST 2009UID=2678f5ee-ec1c-4be4-9fdd-ee4f1de115fa de                                
[    0.000000] Command line: ro root=UUID=2678f5ee-ec1c-4be4-9fdd-ee4f1de115fa debug ignore_loglevel sysrq_always_enabled console=ttyS0,115200 earlyprintk=serial,ttyS0,115200                                                
[    0.000000] debug: ignoring loglevel setting.                                                               
[    0.000000] bootconsole [earlyser0] enabled                                                                 
[    0.000000] KERNEL supported cpus:dc bytes]                                                                 
[    0.000000]   Intel GenuineIntel                                                                            
[    0.000000]   AMD AuthenticAMD                                                                              
[    0.000000]   Centaur CentaurHauls                                                                          
[    0.000000] BIOS-provided physical RAM map:                                                                 
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)                                        
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)                                      
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)                                      
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)                                        
[    0.000000]  BIOS-e820: 000000007fff0000 - 000000007fffe000 (ACPI data)                                     
[    0.000000]  BIOS-e820: 000000007fffe000 - 0000000080000000 (ACPI NVS)                                      
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec03000 (reserved)                                      
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)                                      
[    0.000000] DMI 2.3 present.                                                                                
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.                                 
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)                  
[    0.000000] last_pfn = 0x7fff0 max_arch_pfn = 0x400000000                                                   
[    0.000000] MTRR default type: uncachable                                                                   
[    0.000000] MTRR fixed ranges enabled:                                                                      
[    0.000000]   00000-9FFFF write-back                                                                        
[    0.000000]   A0000-EFFFF uncachable                                                                        
[    0.000000]   F0000-FFFFF write-protect                                                                     
[    0.000000] MTRR variable ranges enabled:                                                                   
[    0.000000]   0 base 0000000000 mask FF80000000 write-back                                                  
[    0.000000]   1 disabled                                                                                    
[    0.000000]   2 disabled                                                                                    
[    0.000000]   3 disabled                                                                                    
[    0.000000]   4 disabled                                                                                    
[    0.000000]   5 disabled                                                                                    
[    0.000000]   6 disabled                                                                                    
[    0.000000]   7 disabled                                                                                    
[    0.000000] initial memory mapped : 0 - 20000000                                                            
[    0.000000] init_memory_mapping: 0000000000000000-000000007fff0000                                          
[    0.000000]  0000000000 - 007fe00000 page 2M                                                                
[    0.000000]  007fe00000 - 007fff0000 page 4k                                                                
[    0.000000] kernel direct mapping tables up to 7fff0000 @ 10000-14000                                       
[    0.000000] RAMDISK: 37cac000 - 37fefadc                                                                    
[    0.000000] ACPI: RSDP 00000000000f7470 00024 (v02 ACPIAM)                                                  
[    0.000000] ACPI: XSDT 000000007fff0100 00044 (v01 A M I  OEMXSDT  09000625 MSFT 00000097)                  
[    0.000000] ACPI: FACP 000000007fff0290 000F4 (v03 A M I  OEMFACP  09000625 MSFT 00000097)                  
[    0.000000] ACPI: DSDT 000000007fff0400 03018 (v01  0AAAA 0AAAA000 00000000 INTL 02002026)                  
[    0.000000] ACPI: FACS 000000007fffe000 00040                                                               
[    0.000000] ACPI: APIC 000000007fff0390 00070 (v01 A M I  OEMAPIC  09000625 MSFT 00000097)                  
[    0.000000] ACPI: OEMB 000000007fffe040 00056 (v01 A M I  AMI_OEM  09000625 MSFT 00000097)                  
[    0.000000] ACPI: SSDT 000000007fff3420 00248 (v01 A M I  POWERNOW 00000001 AMD  00000001)                  
[    0.000000] ACPI: Local APIC address 0xfee00000                                                             
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 007fff0000]                                    
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]                   
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]                   
[    0.000000]   #2 [0001000000 - 0002219a50]    TEXT DATA BSS ==> [0001000000 - 0002219a50]                   
[    0.000000]   #3 [0037cac000 - 0037fefadc]          RAMDISK ==> [0037cac000 - 0037fefadc]                   
[    0.000000]   #4 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]                   
[    0.000000]   #5 [000221a000 - 000221a200]              BRK ==> [000221a000 - 000221a200]                   
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]                   
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780                                                  
[    0.000000]  [ffffea0000000000-ffffea00033fffff] PMD -> [ffff880002800000-ffff880005bfffff] on node 0       
[    0.000000] Zone PFN ranges:                                                                                
[    0.000000]   DMA      0x00000010 -> 0x00001000                                                             
[    0.000000]   DMA32    0x00001000 -> 0x00100000                                                             
[    0.000000]   Normal   0x00100000 -> 0x00100000                                                             
[    0.000000] Movable zone start PFN for each node                                                            
[    0.000000] early_node_map[2] active PFN ranges                                                             
[    0.000000]     0: 0x00000010 -> 0x0000009d                                                                 
[    0.000000]     0: 0x00000100 -> 0x0007fff0                                                                 
[    0.000000] On node 0 totalpages: 524157                                                                    
[    0.000000]   DMA zone: 104 pages used for memmap                                                           
[    0.000000]   DMA zone: 103 pages reserved                                                                  
[    0.000000]   DMA zone: 3774 pages, LIFO batch:0                                                            
[    0.000000]   DMA32 zone: 13208 pages used for memmap                                                       
[    0.000000]   DMA32 zone: 506968 pages, LIFO batch:31                                                       
[    0.000000] Detected use of extended apic ids on hypertransport bus                                         
[    0.000000] ACPI: PM-Timer IO Port: 0x508                                                                   
[    0.000000] ACPI: Local APIC address 0xfee00000                                                             
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)                                              
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)                                              
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])                                             
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])                                         
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-15                                  
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])                                        
[    0.000000] IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 16-31                                 
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec02000] gsi_base[32])                                        
[    0.000000] IOAPIC[2]: apic_id 4, version 17, address 0xfec02000, GSI 32-47                                 
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)                                        
[    0.000000] ACPI: IRQ0 used by override.                                                                    
[    0.000000] ACPI: IRQ2 used by override.                                                                    
[    0.000000] ACPI: IRQ9 used by override.                                                                    
[    0.000000] Using ACPI (MADT) for SMP configuration information                                             
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs                                                            
[    0.000000] nr_irqs_gsi: 48                                                                                 
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)                          
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1                                          
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff880005c00000 s1915032 r8192 d22376 u2097152                 
[    0.000000] pcpu-alloc: s1915032 r8192 d22376 u2097152 alloc=1*2097152                                      
[    0.000000] pcpu-alloc: [0] 0 [0] 1                                                                         
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 510742                     
[    0.000000] Kernel command line: ro root=UUID=2678f5ee-ec1c-4be4-9fdd-ee4f1de115fa debug ignore_loglevel sysrq_always_enabled console=ttyS0,115200 earlyprintk=serial,ttyS0,115200                                         
[    0.000000] debug: sysrq always enabled.                                                                    
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)                                           
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)                               
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)                                
[    0.000000] Initializing CPU#0                                                                              
[    0.000000] Checking aperture...                                                                            
[    0.000000] No AGP bridge found                                                                             
[    0.000000] Node 0: aperture @ 202a000000 size 32 MB                                                        
[    0.000000] Aperture beyond 4GB. Ignoring.                                                                  
[    0.000000] Memory: 2013708k/2097088k available (3499k kernel code, 460k absent, 82260k reserved, 2332k data, 2336k init)                                                                                                  
[    0.000000] Hierarchical RCU implementation.                                                                
[    0.000000] NR_IRQS:512                                                                                     
[    0.000000] Extended CMOS year: 2000                                                                        
[    0.000000] Console: colour VGA+ 80x25                                                                      
[    0.000000] console [ttyS0] enabled, bootconsole disabled                                                   
[    0.000000] console [ttyS0] enabled, bootconsole disabled                                                   
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar                        
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8                                                                  
[    0.000000] ... MAX_LOCK_DEPTH:          48                                                                 
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191                                                               
[    0.000000] ... CLASSHASH_SIZE:          4096                                                               
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384                                                              
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768                                                              
[    0.000000] ... CHAINHASH_SIZE:          16384                                                              
[    0.000000]  memory used by lock dependency info: 6367 kB                                                   
[    0.000000]  per task-struct memory footprint: 2688 bytes                                                   
[    0.000000] Fast TSC calibration using PIT                                                                  
[    0.000000] Detected 2394.411 MHz processor.                                                                
[    0.003039] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.82 BogoMIPS (lpj=2394411)                                                                                                      
[    0.005195] Security Framework initialized                                                                  
[    0.006089] Mount-cache hash table entries: 256                                                             
[    0.009437] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)                               
[    0.010004] CPU: L2 Cache: 1024K (64 bytes/line)                                                            
[    0.011003] tseg: 0000000000                                                                                
[    0.012113] CPU: Physical Processor ID: 0                                                                   
[    0.013002] CPU: Processor Core ID: 0                                                                       
[    0.014003] mce: CPU supports 5 MCE banks                                                                   
[    0.015011] using C1E aware idle routine                                                                    
[    0.016002] Performance Counters: AMD PMU driver.                                                           
[    0.018013] ... version:                 0                                                                  
[    0.019001] ... bit width:               48                                                                 
[    0.020001] ... generic counters:        4                                                                  
[    0.021001] ... value mask:              0000ffffffffffff                                                   
[    0.022001] ... max period:              00007fffffffffff                                                   
[    0.023001] ... fixed-purpose counters:  0                                                                  
[    0.024000] ... counter mask:            000000000000000f                                                   
[    0.025043] ACPI: Core revision 20090521                                                                    
[    0.034909] ftrace: converting mcount calls to 0f 1f 44 00 00                                               
[    0.035002] ftrace: allocating 14985 entries in 59 pages                                                    
[    0.038265] Setting APIC routing to flat                                                                    
[    0.040386] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1                                            
[    0.051390] CPU0: Dual-Core AMD Opteron(tm) Processor 1216 stepping 02                                      
[    0.057038] lockdep: fixing up alternatives.                                                                
[    0.058190] Booting processor 1 APIC 0x1 ip 0x6000                                                          
[    0.003999] Initializing CPU#1                                                                              
[    0.003999] Calibrating delay using timer specific routine.. 4787.02 BogoMIPS (lpj=2393513)                 
[    0.003999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)                               
[    0.003999] CPU: L2 Cache: 1024K (64 bytes/line)                                                            
[    0.003999] CPU: Physical Processor ID: 0                                                                   
[    0.003999] CPU: Processor Core ID: 1                                                                       
[    0.003999] mce: CPU supports 5 MCE banks                                                                   
[    0.130038] CPU1: Dual-Core AMD Opteron(tm) Processor 1216 stepping 02                                      
[    0.133017] Brought up 2 CPUs                                                                               
[    0.133984] Total of 2 processors activated (9575.84 BogoMIPS).                                             
[    0.136062] CPU0 attaching sched-domain:                                                                    
[    0.136984]  domain 0: span 0-1 level MC                                                                    
[    0.138982]   groups: 0 1                                                                                   
[    0.140552] CPU1 attaching sched-domain:                                                                    
[    0.140982]  domain 0: span 0-1 level MC                                                                    
[    0.142981]   groups: 1 0                                                                                   
[    0.148290] NET: Registered protocol family 16                                                              
[    0.150194] node 0 link 0: io port [1000, ffffff]                                                           
[    0.150984] TOM: 0000000080000000 aka 2048M                                                                 
[    0.151982] node 0 link 0: mmio [a0000, bffff]                                                              
[    0.153980] node 0 link 0: mmio [80000000, ff70ffff]                                                        
[    0.155980] bus: [00,ff] on node 0 link 0                                                                   
[    0.156979] bus: 00 index 0 io port: [0, ffff]                                                              
[    0.157979] bus: 00 index 1 mmio: [a0000, bffff]                                                            
[    0.158981] bus: 00 index 2 mmio: [80000000, fcffffffff]                                                    
[    0.160030] ACPI: bus type pci registered                                                                   
[    0.161055] PCI: Using configuration type 1 for base access                                                 
[    0.171178] bio: create slab <bio-0> at 0                                                                   
[    0.175600] ACPI: EC: Look up EC in DSDT                                                                    
[    0.192032] ACPI: Interpreter enabled                                                                       
[    0.192977] ACPI: (supports S0 S1 S5)                                                                       
[    0.195247] ACPI: Using IOAPIC for interrupt routing                                                        
[    0.214207] ACPI Warning: Incorrect checksum in table [OEMB] - 8D, should be 82 20090521 tbutils-246        
[    0.218083] ACPI: No dock devices found.                                                                    
[    0.219119] ACPI: PCI Root Bridge [PCI0] (0000:00)                                                          
[    0.221124] pci 0000:00:01.0: Enabling HT MSI Mapping                                                       
[    0.222142] pci 0000:00:02.1: reg 10 io port: [0x1f0-0x1f7]                                                 
[    0.222976] pci 0000:00:02.1: reg 14 io port: [0x3f4-0x3f7]                                                 
[    0.223976] pci 0000:00:02.1: reg 18 io port: [0x170-0x177]                                                 
[    0.224975] pci 0000:00:02.1: reg 1c io port: [0x374-0x377]                                                 
[    0.225977] pci 0000:00:02.1: reg 20 io port: [0xffa0-0xffaf]                                               
[    0.227123] pci 0000:00:03.0: reg 10 32bit mmio: [0xff6b4000-0xff6b4fff]                                    
[    0.227975] pci 0000:00:03.0: reg 14 io port: [0xe000-0xe0ff]                                               
[    0.229070] pci 0000:00:03.1: reg 10 32bit mmio: [0xff6b5000-0xff6b5fff]                                    
[    0.229976] pci 0000:00:03.1: reg 14 io port: [0xe400-0xe4ff]                                               
[    0.231072] pci 0000:00:03.2: reg 10 32bit mmio: [0xff6b6000-0xff6b6fff]                                    
[    0.231975] pci 0000:00:03.2: reg 14 io port: [0xe800-0xe8ff]                                               
[    0.233023] pci 0000:00:03.2: supports D1 D2                                                                
[    0.233969] pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot                                            
[    0.234971] pci 0000:00:03.2: PME# disabled                                                                 
[    0.236037] pci 0000:00:04.0: reg 10 32bit mmio: [0xff680000-0xff69ffff]                                    
[    0.236974] pci 0000:00:04.0: reg 14 32bit mmio: [0xff660000-0xff67ffff]                                    
[    0.237975] pci 0000:00:04.0: reg 18 io port: [0xdc00-0xdc3f]                                               
[    0.238992] pci 0000:00:04.0: reg 30 32bit mmio pref: [0xff640000-0xff65ffff]                               
[    0.239996] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold                                           
[    0.240969] pci 0000:00:04.0: PME# disabled                                                                 
[    0.242029] pci 0000:00:05.0: reg 10 32bit mmio: [0xff620000-0xff63ffff]                                    
[    0.242973] pci 0000:00:05.0: reg 14 32bit mmio: [0xff600000-0xff61ffff]                                    
[    0.243973] pci 0000:00:05.0: reg 18 io port: [0xd880-0xd8bf]                                               
[    0.244991] pci 0000:00:05.0: reg 30 32bit mmio pref: [0xff5e0000-0xff5fffff]                               
[    0.245996] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold                                           
[    0.246968] pci 0000:00:05.0: PME# disabled                                                                 
[    0.248013] pci 0000:00:06.0: reg 10 32bit mmio pref: [0xf8000000-0xfbffffff]                               
[    0.248972] pci 0000:00:06.0: reg 14 32bit mmio: [0xff6c0000-0xff6fffff]                                    
[    0.249973] pci 0000:00:06.0: reg 18 io port: [0xec00-0xec7f]                                               
[    0.251013] pci 0000:00:06.0: supports D1 D2                                                                
[    0.252393] pci 0000:01:0e.0: reg 10 io port: [0xc080-0xc087]                                               
[    0.252969] pci 0000:01:0e.0: reg 14 io port: [0xc000-0xc003]                                               
[    0.253970] pci 0000:01:0e.0: reg 18 io port: [0xbc00-0xbc07]                                               
[    0.254969] pci 0000:01:0e.0: reg 1c io port: [0xb880-0xb883]                                               
[    0.255969] pci 0000:01:0e.0: reg 20 io port: [0xb800-0xb80f]                                               
[    0.256969] pci 0000:01:0e.0: reg 24 32bit mmio: [0xff3fe000-0xff3fffff]                                    
[    0.257970] pci 0000:01:0e.0: reg 30 32bit mmio pref: [0xff3c0000-0xff3dffff]                               
[    0.259039] pci 0000:01:0e.1: reg 10 io port: [0xcc00-0xcc07]                                               
[    0.259968] pci 0000:01:0e.1: reg 14 io port: [0xc880-0xc883]                                               
[    0.260968] pci 0000:01:0e.1: reg 18 io port: [0xc800-0xc807]                                               
[    0.261969] pci 0000:01:0e.1: reg 1c io port: [0xc480-0xc483]                                               
[    0.262968] pci 0000:01:0e.1: reg 20 io port: [0xc400-0xc40f]                                               
[    0.264065] pci 0000:00:01.0: bridge io port: [0xb000-0xcfff]                                               
[    0.264965] pci 0000:00:01.0: bridge 32bit mmio: [0xff300000-0xff3fffff]                                    
[    0.266083] pci_bus 0000:00: on NUMA node 0                                                                 
[    0.266966] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]                                             
[    0.268232] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]                                        
[    0.269031] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P2._PRT]                                   
[    0.282144] ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 9 11 12 14 15) *0, disabled.                      
[    0.287296] ACPI: PCI Interrupt Link [LN01] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.292076] ACPI: PCI Interrupt Link [LN02] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.297293] ACPI: PCI Interrupt Link [LN03] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.302111] ACPI: PCI Interrupt Link [LN04] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.307315] ACPI: PCI Interrupt Link [LN05] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.312291] ACPI: PCI Interrupt Link [LN06] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.317312] ACPI: PCI Interrupt Link [LN07] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.322151] ACPI: PCI Interrupt Link [LN08] (IRQs 1 3 4 5 6 7 *9 11 12 14 15)                               
[    0.326437] ACPI: PCI Interrupt Link [LN09] (IRQs 1 3 4 *5 6 7 9 11 12 14 15)                               
[    0.329974] ACPI: PCI Interrupt Link [LN10] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.334340] ACPI: PCI Interrupt Link [LN11] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.339116] ACPI: PCI Interrupt Link [LN12] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.344338] ACPI: PCI Interrupt Link [LN13] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.349156] ACPI: PCI Interrupt Link [LN14] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.354340] ACPI: PCI Interrupt Link [LN15] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.360034] ACPI: PCI Interrupt Link [LN16] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.365337] ACPI: PCI Interrupt Link [LN17] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.370157] ACPI: PCI Interrupt Link [LN18] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.375340] ACPI: PCI Interrupt Link [LN19] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.380157] ACPI: PCI Interrupt Link [LN20] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.385339] ACPI: PCI Interrupt Link [LN21] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.390340] ACPI: PCI Interrupt Link [LN22] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.395340] ACPI: PCI Interrupt Link [LN23] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.400156] ACPI: PCI Interrupt Link [LN24] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.405339] ACPI: PCI Interrupt Link [LN25] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.410340] ACPI: PCI Interrupt Link [LN26] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.415340] ACPI: PCI Interrupt Link [LN27] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.420339] ACPI: PCI Interrupt Link [LN28] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.425080] ACPI: PCI Interrupt Link [LN29] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.431340] ACPI: PCI Interrupt Link [LN30] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.                  
[    0.436359] ACPI: PCI Interrupt Link [LNUS] (IRQs *10)                                                      
[    0.438179] ACPI: PCI Interrupt Link [LNSA] (IRQs *11)                                                      
[    0.441123] vgaarb: device added: PCI:0000:00:06.0,decodes=io+mem,owns=io+mem,locks=none                    
[    0.442019] vgaarb: loaded                                                                                  
[    0.444249] SCSI subsystem initialized                                                                      
[    0.446046] libata version 3.00 loaded.                                                                     
[    0.448069] usbcore: registered new interface driver usbfs                                                  
[    0.449040] usbcore: registered new interface driver hub                                                    
[    0.450102] usbcore: registered new device driver usb                                                       
[    0.451159] PCI: Using ACPI for IRQ routing                                                                 
[    0.453430] Switching to clocksource jiffies                                                                
[    0.461399] pnp: PnP ACPI init                                                                              
[    0.462054] ACPI: bus type pnp registered                                                                   
[    0.470755] pnp: PnP ACPI: found 12 devices                                                                 
[    0.471005] ACPI: ACPI bus type pnp unregistered                                                            
[    0.472026] system 00:08: ioport range 0x800-0x87f has been reserved                                        
[    0.473005] system 00:08: ioport range 0xa80-0xa8f has been reserved                                        
[    0.474015] system 00:09: ioport range 0x4d0-0x4d1 has been reserved                                        
[    0.475005] system 00:09: ioport range 0xc00-0xc01 has been reserved                                        
[    0.476006] system 00:09: ioport range 0xcd6-0xcd7 has been reserved                                        
[    0.477004] system 00:09: ioport range 0xcd4-0xcd5 has been reserved                                        
[    0.478004] system 00:09: ioport range 0xcd8-0xcdf has been reserved                                        
[    0.479005] system 00:09: ioport range 0x40b-0x40b has been reserved                                        
[    0.480007] system 00:09: ioport range 0x4d6-0x4d6 has been reserved                                        
[    0.481005] system 00:09: ioport range 0xc06-0xc07 has been reserved                                        
[    0.482005] system 00:09: ioport range 0xc14-0xc14 has been reserved                                        
[    0.483005] system 00:09: ioport range 0xc49-0xc49 has been reserved                                        
[    0.484006] system 00:09: ioport range 0xc4a-0xc4a has been reserved                                        
[    0.485004] system 00:09: ioport range 0xc50-0xc51 has been reserved                                        
[    0.486005] system 00:09: ioport range 0xc52-0xc52 has been reserved                                        
[    0.487005] system 00:09: ioport range 0xc6c-0xc6c has been reserved                                        
[    0.488006] system 00:09: ioport range 0xc6f-0xc6f has been reserved                                        
[    0.489005] system 00:09: ioport range 0x500-0x57f has been reserved                                        
[    0.490015] system 00:0a: ioport range 0x580-0x58f has been reserved                                        
[    0.491005] system 00:0a: ioport range 0x590-0x593 has been reserved                                        
[    0.492006] system 00:0a: ioport range 0x700-0x703 has been reserved                                        
[    0.493005] system 00:0a: ioport range 0xca0-0xcaf has been reserved                                        
[    0.494009] system 00:0a: iomem range 0xfec00000-0xfec00fff could not be reserved                           
[    0.495005] system 00:0a: iomem range 0xfec01000-0xfec01fff could not be reserved                           
[    0.496006] system 00:0a: iomem range 0xfec02000-0xfec02fff could not be reserved                           
[    0.497005] system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved                               
[    0.498005] system 00:0a: iomem range 0xfff00000-0xffffffff has been reserved                               
[    0.499005] system 00:0a: iomem range 0xff780000-0xffbfffff has been reserved                               
[    0.500006] system 00:0a: iomem range 0xfebfe000-0xfebfefff has been reserved                               
[    0.501015] system 00:0b: iomem range 0x0-0x9ffff could not be reserved                                     
[    0.502005] system 00:0b: iomem range 0xe0000-0xfffff could not be reserved                                 
[    0.503005] system 00:0b: iomem range 0x100000-0x7fffffff could not be reserved                             
[    0.510111] Switching to clocksource acpi_pm                                                                
[    0.514382] pci 0000:01:0d.0: PCI bridge, secondary bus 0000:02                                             
[    0.514846] Switched to high resolution mode on CPU 0                                                       
[    0.525225] Switched to high resolution mode on CPU 1                                                       
[    0.530305] pci 0000:01:0d.0:   IO window: disabled                                                         
[    0.535176] pci 0000:01:0d.0:   MEM window: disabled                                                        
[    0.540133] pci 0000:01:0d.0:   PREFETCH window: disabled                                                   
[    0.545522] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01                                             
[    0.551431] pci 0000:00:01.0:   IO window: 0xb000-0xcfff                                                    
[    0.556736] pci 0000:00:01.0:   MEM window: 0xff300000-0xff3fffff                                           
[    0.562817] pci 0000:00:01.0:   PREFETCH window: disabled                                                   
[    0.568223] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]                                                  
[    0.574346] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]                                  
[    0.581205] pci_bus 0000:01: resource 0 io:  [0xb000-0xcfff]                                                
[    0.586851] pci_bus 0000:01: resource 1 mem: [0xff300000-0xff3fffff]                                        
[    0.593361] NET: Registered protocol family 2                                                               
[    0.598033] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)                               
[    0.606329] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)                           
[    0.615998] TCP bind hash table entries: 32768 (order: 9, 2359296 bytes)                                    
[    0.626355] TCP: Hash tables configured (established 262144 bind 32768)                                     
[    0.632999] TCP reno registered                                                                             
[    0.636458] NET: Registered protocol family 1                                                               
[    0.641791] Trying to unpack rootfs image as initramfs...                                                   
[    0.751727] Freeing initrd memory: 3342k freed                                                              
[    0.762242] audit: initializing netlink socket (disabled)                                                   
[    0.768329] type=2000 audit(1253305988.768:1): initialized                                                  
[    0.776538] HugeTLB registered 2 MB page size, pre-allocated 0 pages                                        
[    0.784296] VFS: Disk quotas dquot_6.5.2                                                                    
[    0.788330] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)                                       
[    0.795445] msgmni has been set to 3940                                                                     
[    0.801315] alg: No test for stdrng (krng)                                                                  
[    0.805464] io scheduler noop registered                                                                    
[    0.809390] io scheduler anticipatory registered                                                            
[    0.813999] io scheduler deadline registered                                                                
[    0.818303] io scheduler cfq registered (default)                                                           
[    0.823063] pci 0000:00:02.0: disabled boot interrupts on device [1166:0205]                                
[    0.873051] pci 0000:00:06.0: Boot video device                                                             
[    0.878093] pci_hotplug: PCI Hot Plug PCI Core version: 0.5                                                 
[    0.884470] processor LNXCPU:00: registered as cooling_device0                                              
[    0.890466] processor LNXCPU:01: registered as cooling_device1                                              
[    0.909448] Non-volatile memory driver v1.3                                                                 
[    0.913657] Linux agpgart interface v0.103                                                                  
[    0.918067] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled                                         
�[    1.168604] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A                                           
[    1.419615] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A                                            
[    1.426827] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A                                                 
[    1.432780] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A                                                 
[    1.443728] brd: module loaded                                                                              
[    1.447341] sata_svw 0000:01:0e.0: version 2.3                                                              
[    1.451890] sata_svw 0000:01:0e.0: PCI INT A -> GSI 11 (level, low) -> IRQ 11                               
[    1.459161] scsi0 : sata_svw                                                                                
[    1.462451] scsi1 : sata_svw                                                                                
[    1.465518] scsi2 : sata_svw                                                                                
[    1.468588] scsi3 : sata_svw                                                                                
[    1.471610] ata1: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe000 irq 11                            
[    1.478999] ata2: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe100 irq 11                            
[    1.486384] ata3: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe200 irq 11                            
[    1.493766] ata4: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe300 irq 11                            
[    1.806043] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)                                          
[    1.815385] ata1.00: ATA-7: WDC WD1200JS-00NCB1, 10.02E02, max UDMA/133                                     
[    1.821988] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)                                    
[    1.831277] ata1.00: configured for UDMA/133                                                                
[    1.846885] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1200JS-00N 10.0 PQ: 0 ANSI: 5                    
[    1.855968] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)                           
[    1.863555] sd 0:0:0:0: [sda] Write Protect is off                                                          
[    1.868347] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                                                       
[    1.873448] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA         
[    1.883404]  sda: sda1 sda2 sda3                                                                            
[    1.904613] sd 0:0:0:0: [sda] Attached SCSI disk                                                            
[    2.224456] ata2: SATA link down (SStatus 4 SControl 300)                                                   
[    2.544422] ata3: SATA link down (SStatus 4 SControl 300)                                                   
[    2.864451] ata4: SATA link down (SStatus 4 SControl 300)                                                   
[    2.869983] sata_svw 0000:01:0e.1: PCI INT A -> GSI 11 (level, low) -> IRQ 11                               
[    2.877748] scsi4 : pata_serverworks                                                                        
[    2.881517] scsi5 : pata_serverworks                                                                        
[    2.885251] ata5: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14                                  
[    2.892125] ata6: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15                                  
[    3.052341] ata5.00: ATAPI: TEAC DV-516G, F4S7, max UDMA/33                                                 
[    3.061349] ata5.00: configured for UDMA/33                                                                 
[    3.066374] scsi 4:0:0:0: CD-ROM            TEAC     DV-516G          F4S7 PQ: 0 ANSI: 5                    
[    3.225333] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI                                       
[    3.231765] Copyright (c) 1999-2006 Intel Corporation.                                                      
[    3.236931] e1000 0000:00:04.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24                                  
[    3.524378] e1000: 0000:00:04.0: e1000_probe: (PCI:33MHz:32-bit) 00:e0:81:72:62:74                          
[    3.677724] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection                                  
[    3.684612] e1000 0000:00:05.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25                                  
[    3.955641] e1000: 0000:00:05.0: e1000_probe: (PCI:33MHz:32-bit) 00:e0:81:72:62:75                          
[    4.127709] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection                                  
[    4.134695] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2                                             
[    4.140609] e1000e: Copyright (c) 1999-2008 Intel Corporation.                                              
[    4.146574] console [netcon0] enabled                                                                       
[    4.150242] netconsole: network logging started                                                             
[    4.155065] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver                                      
[    4.161624] ehci_hcd 0000:00:03.2: PCI INT A -> GSI 10 (level, low) -> IRQ 10                               
[    4.168757] ehci_hcd 0000:00:03.2: EHCI Host Controller                                                     
[    4.174773] ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1                            
[    4.203052] ehci_hcd 0000:00:03.2: irq 10, io mem 0xff6b6000                                                
[    4.214044] ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00                                               
[    4.220570] usb usb1: configuration #1 chosen from 1 choice                                                 
[    4.226561] hub 1-0:1.0: USB hub found                                                                      
[    4.230348] hub 1-0:1.0: 4 ports detected                                                                   
[    4.235337] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver                                          
[    4.241540] ohci_hcd 0000:00:03.0: PCI INT A -> GSI 10 (level, low) -> IRQ 10                               
[    4.248673] ohci_hcd 0000:00:03.0: OHCI Host Controller                                                     
[    4.254073] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2                            
[    4.261483] ohci_hcd 0000:00:03.0: irq 10, io mem 0xff6b4000                                                
[    4.322315] usb usb2: configuration #1 chosen from 1 choice                                                 
[    4.328019] hub 2-0:1.0: USB hub found                                                                      
[    4.331780] hub 2-0:1.0: 2 ports detected                                                                   
[    4.336244] ohci_hcd 0000:00:03.1: PCI INT A -> GSI 10 (level, low) -> IRQ 10                               
[    4.343380] ohci_hcd 0000:00:03.1: OHCI Host Controller                                                     
[    4.348765] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3                            
[    4.356167] ohci_hcd 0000:00:03.1: irq 10, io mem 0xff6b5000                                                
[    4.416312] usb usb3: configuration #1 chosen from 1 choice                                                 
[    4.422042] hub 3-0:1.0: USB hub found                                                                      
[    4.425797] hub 3-0:1.0: 2 ports detected                                                                   
[    4.430134] uhci_hcd: USB Universal Host Controller Interface driver                                        
[    4.436961] usbcore: registered new interface driver libusual                                               
[    4.443156] PNP: No PS/2 controller found. Probing ports directly.                                          
[    4.451011] serio: i8042 KBD port at 0x60,0x64 irq 1                                                        
[    4.456130] serio: i8042 AUX port at 0x60,0x64 irq 12                                                       
[    4.461521] mice: PS/2 mouse device common for all mice                                                     
[    4.467279] cpuidle: using governor ladder                                                                  
[    4.471369] cpuidle: using governor menu                                                                    
[    4.478150] usbcore: registered new interface driver hiddev                                                 
[    4.483822] usbcore: registered new interface driver usbhid                                                 
[    4.489386] usbhid: v2.6:USB HID core driver                                                                
[    4.494573] TCP bic registered                                                                              
[    4.497626] NET: Registered protocol family 17                                                              
[    4.502131] powernow-k8: Found 1 Dual-Core AMD Opteron(tm) Processor 1216 processors (2 cpu cores) (version 2.20.00)                                                                                                       
[    4.512946] powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0xa                                                
[    4.518663] powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xc                                                 
[    4.524224] powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xe                                                 
[    4.529789] powernow-k8:    3 : fid 0xa (1800 MHz), vid 0x10                                                
[    4.535438] powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12                                                
[    4.542557] registered taskstats version 1                                                                  
[    4.547360] Freeing unused kernel memory: 2336k freed                                                       
Mounting proc filesystem                                                                                       
Mounting sysfs filesystem                                                                                      
Creating /dev                                                                                                  
Creating initial device nodes                                                                                  
[    5.010281] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4                                    
[    5.070923] kjournald starting.  Commit interval 5 seconds                                                  
[    5.071190] EXT3-fs: mounted filesystem with writeback data mode.                                           
/etc/profile.d/lang.sh: line 19: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                  
/etc/profile.d/lang.sh: line 20: warning: setlocale: LC_COLLATE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 23: warning: setlocale: LC_MESSAGES: cannot change locale (en_US.UTF-8): No such file or directory                                                                                               
/etc/profile.d/lang.sh: line 26: warning: setlocale: LC_NUMERIC: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 29: warning: setlocale: LC_TIME: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                   
                Welcome to Fedora                                                                              
                Press 'I' to enter interactive startup.                                                        
Starting udev: udevd[633]: udev: missing sysfs features; please update the kernel or disable the kernel's CONFIG_SYSFS_DEPRECATED option; udev may fail to work correctly                                                     
                                                                                                               
[   10.005023] udev: starting version 145                                                                      
[   10.005025] <3>udev: missing sysfs features; please update the kernel or disable the kernel's CONFIG_SYSFS_DEPRECATED option; udev may fail to work correctly                                                              
[   10.300091] input: Power Button as /class/input/input0                                                      
[   10.306609] ACPI: Power Button [PWRF]                                                                       
[   10.310519] input: Sleep Button as /class/input/input1                                                      
[   10.315809] ACPI: Sleep Button [SLPF]                                                                       
[   10.319691] input: Power Button as /class/input/input2                                                      
[   10.324981] ACPI: Power Button [PWRB]                                                                       
[   10.370364] Floppy drive(s): fd0 is 1.44M                                                                   
[   10.389890] FDC 0 is a post-1991 82077                                                                      
[   10.409354] input: PC Speaker as /class/input/input3                                                        
[   10.476453] sr0: scsi3-mmc drive: 4x/48x cd/rw xa/form2 cdda tray                                           
[   10.482558] Uniform CD-ROM driver Revision: 3.20                                                            
[   10.487926] sr 4:0:0:0: Attached scsi CD-ROM sr0                                                            
[   10.522255] sd 0:0:0:0: Attached scsi generic sg0 type 0                                                    
[   10.527723] sr 4:0:0:0: Attached scsi generic sg1 type 5                                                    
[   11.405317] end_request: I/O error, dev fd0, sector 0                                                       
[  OK  ]                                                                                                       
[   11.633093] kvm: Nested Virtualization enabled                                                              
Setting hostname opteron:  [  OK  ]                                                                            
/proc/misc: No entry for device-mapper found                                                                   
Is device-mapper driver missing from kernel?                                                                   
Failure to communicate with kernel device-mapper driver.                                                       
/proc/misc: No entry for device-mapper found                                                                   
Is device-mapper driver missing from kernel?                                                                   
Failure to communicate with kernel device-mapper driver.                                                       
Command failed                                                                                                 
Setting up Logical Volume Management: [  OK  ]                                                                 
Checking filesystems                                                                                           
Checking all file systems.                                                                                     
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda3                                                              
/: clean, 236232/3932656 files, 2231885/15729643 blocks                                                        
[/sbin/fsck.ext3 (1) -- /boot] fsck.ext3 -a /dev/sda1                                                          
/boot: clean, 57/26104 files, 62912/104388 blocks                                                              
[  OK  ]                                                                                                       
Remounting root filesystem in read-write mode:  [   12.253591] EXT3 FS on sda3, internal journal               
[  OK  ]                                                                                                       
Mounting local filesystems:  [   12.382053] kjournald starting.  Commit interval 5 seconds                     
[   12.382250] EXT3 FS on sda1, internal journal                                                               
[   12.382274] EXT3-fs: mounted filesystem with writeback data mode.                                           
[  OK  ]                                                                                                       
Enabling local filesystem quotas:  [  OK  ]                                                                    
Enabling /etc/fstab swaps:  [   12.997561] Adding 2096472k swap on /dev/sda2.  Priority:-1 extents:1 across:2096472k                                                                                                          
[  OK  ]                                                                                                       
/etc/profile.d/lang.sh: line 19: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                  
/etc/profile.d/lang.sh: line 20: warning: setlocale: LC_COLLATE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 23: warning: setlocale: LC_MESSAGES: cannot change locale (en_US.UTF-8): No such file or directory                                                                                               
/etc/profile.d/lang.sh: line 26: warning: setlocale: LC_NUMERIC: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 29: warning: setlocale: LC_TIME: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                   
Entering non-interactive startup                                                                               
Enabling ondemand cpu frequency scaling: [  OK  ]                                                              
[   13.649027] Clocksource tsc unstable (delta = -102241535 ns)                                                
FATAL: Module ipv6 not found.                                                                                  
Bringing up loopback interface:  [  OK  ]                                                                      
Bringing up interface eth0:                                                                                    
Determining IP information for eth0...[   14.458289] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX                                                                                                    
/etc/profile.d/lang.sh: line 19: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                  
/etc/profile.d/lang.sh: line 20: warning: setlocale: LC_COLLATE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 23: warning: setlocale: LC_MESSAGES: cannot change locale (en_US.UTF-8): No such file or directory                                                                                               
/etc/profile.d/lang.sh: line 26: warning: setlocale: LC_NUMERIC: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 29: warning: setlocale: LC_TIME: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                   
/etc/profile.d/lang.sh: line 19: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                  
/etc/profile.d/lang.sh: line 20: warning: setlocale: LC_COLLATE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 23: warning: setlocale: LC_MESSAGES: cannot change locale (en_US.UTF-8): No such file or directory                                                                                               
/etc/profile.d/lang.sh: line 26: warning: setlocale: LC_NUMERIC: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 29: warning: setlocale: LC_TIME: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                   
 done.                                                                                                         
[  OK  ]                                                                                                       
FATAL: Module ipv6 not found.                                                                                  
Starting portreserve: [  OK  ]                                                                                 
Starting system logger: [  OK  ]                                                                               
Starting irqbalance: [  OK  ]                                                                                  
Starting rpcbind: [  OK  ]                                                                                     
Mounting NFS filesystems:  [   18.663960] RPC: Registered udp transport module.                                
[   18.669025] RPC: Registered tcp transport module.                                                           
[   19.014428] ------------[ cut here ]------------                                                            
[   19.019084] WARNING: at /mnt/build/linux-2.6/fs/sysfs/dir.c:487 sysfs_add_one+0xf8/0x10f()                  
[   19.027362] Hardware name: To Be Filled By O.E.M.                                                           
[   19.032085] sysfs: cannot create duplicate filename '/class/bdi/0:0'                                        
[   19.038434] Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand kvm_amd kvm uinput sg sr_mod serio_raw pcspkr floppy cdrom button shpchp [last unloaded: scsi_wait_scan]                              
[   19.055671] Pid: 1265, comm: mount.nfs Not tainted 2.6.31-tip #15                                           
[   19.061760] Call Trace:                                                                                     
[   19.064214]  [<ffffffff81150b8e>] ? sysfs_add_one+0xf8/0x10f                                                
[   19.069877]  [<ffffffff8104d009>] warn_slowpath_common+0x7c/0xa9                                            
[   19.075882]  [<ffffffff8104d0b5>] warn_slowpath_fmt+0x69/0x6b                                               
[   19.081751]  [<ffffffff8107959b>] ? trace_hardirqs_on_caller+0x10b/0x12f                                    
[   19.088451]  [<ffffffff81150a8e>] ? sysfs_pathname+0x3c/0x44                                                
[   19.094107]  [<ffffffff81150a8e>] ? sysfs_pathname+0x3c/0x44                                                
[   19.099766]  [<ffffffff81150a8e>] ? sysfs_pathname+0x3c/0x44                                                
[   19.105423]  [<ffffffff81150b8e>] sysfs_add_one+0xf8/0x10f                                                  
[   19.110908]  [<ffffffff81151214>] create_dir+0x5d/0x98                                                      
[   19.116045]  [<ffffffff8115128c>] sysfs_create_dir+0x3d/0x54                                                
[   19.121704]  [<ffffffff8136378b>] ? _spin_unlock+0x35/0x50                                                  
[   19.127190]  [<ffffffff811bd4f5>] kobject_add_internal+0xdb/0x19b                                           
[   19.133281]  [<ffffffff811bd68d>] kobject_add_varg+0x41/0x4e                                                
[   19.138938]  [<ffffffff811bd79f>] kobject_add+0x89/0x8b                                                     
[   19.144165]  [<ffffffff8107933a>] ? mark_held_locks+0x4d/0x6b                                               
[   19.149910]  [<ffffffff81077f80>] ? lockdep_init_map+0xae/0x510                                             
[   19.155828]  [<ffffffff811bd394>] ? kobject_get+0x1a/0x22                                                   
[   19.161226]  [<ffffffff8123ba40>] ? get_device+0x19/0x1f                                                    
[   19.166537]  [<ffffffff8123c3ea>] device_add+0xe4/0x5d8                                                     
[   19.171762]  [<ffffffff811c7641>] ? __spin_lock_init+0x31/0x54                                              
[   19.177594]  [<ffffffff8123c8fc>] device_register+0x1e/0x22                                                 
[   19.183166]  [<ffffffff8123ca13>] device_create_vargs+0x113/0x140                                           
[   19.189265]  [<ffffffff810d96ae>] bdi_register+0x85/0x197                                                   
[   19.194662]  [<ffffffff8107959b>] ? trace_hardirqs_on_caller+0x10b/0x12f                                    
[   19.201361]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[   19.206758]  [<ffffffff811ca0cc>] ? __percpu_counter_init+0x9b/0xa7                                         
[   19.213020]  [<ffffffff811bf15b>] ? prop_local_init_percpu+0x43/0x48                                        
[   19.219372]  [<ffffffff810d97e8>] bdi_register_dev+0x28/0x2a                                                
[   19.225050]  [<ffffffffa0143b82>] nfs_set_super+0x41/0x9d [nfs]                                             
[   19.230968]  [<ffffffff810f8d36>] sget+0x3bc/0x490                                                          
[   19.235773]  [<ffffffffa0143b41>] ? nfs_set_super+0x0/0x9d [nfs]                                            
[   19.241790]  [<ffffffffa01434d8>] ? nfs_compare_super+0x0/0x183 [nfs]                                       
[   19.248239]  [<ffffffffa01450d2>] nfs_get_sb+0x806/0xae6 [nfs]                                              
[   19.254070]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[   19.259470]  [<ffffffff810f4b98>] ? pcpu_alloc+0x68c/0x704                                                  
[   19.264955]  [<ffffffff810f914f>] vfs_kern_mount+0x9e/0x122                                                 
[   19.270529]  [<ffffffff810f923a>] do_kern_mount+0x4c/0xec                                                   
[   19.275930]  [<ffffffff8111051b>] do_mount+0x748/0x7ae                                                      
[   19.281070]  [<ffffffff810cc051>] ? __get_free_pages+0x17/0x54                                              
[   19.286901]  [<ffffffff81110605>] sys_mount+0x84/0xbf                                                       
[   19.291954]  [<ffffffff8136317f>] ? trace_hardirqs_on_thunk+0x3a/0x3f                                       
[   19.298391]  [<ffffffff8100bc9b>] system_call_fastpath+0x16/0x1b                                            
[   19.304395] ---[ end trace 630c33e55fa37c36 ]---                                                            
[   19.309016] kobject_add_internal failed for 0:0 with -EEXIST, don't try to register things with the same name in the same directory.                                                                                       
[   19.320903] Pid: 1265, comm: mount.nfs Tainted: G        W  2.6.31-tip #15                                  
[   19.327770] Call Trace:                                                                                     
[   19.330222]  [<ffffffff811bd26e>] ? kobject_put+0x47/0x4b                                                   
[   19.335621]  [<ffffffff811bd59c>] kobject_add_internal+0x182/0x19b                                          
[   19.341798]  [<ffffffff811bd68d>] kobject_add_varg+0x41/0x4e                                                
[   19.347455]  [<ffffffff811bd79f>] kobject_add+0x89/0x8b                                                     
[   19.352679]  [<ffffffff8107933a>] ? mark_held_locks+0x4d/0x6b                                               
[   19.358422]  [<ffffffff81077f80>] ? lockdep_init_map+0xae/0x510                                             
[   19.364339]  [<ffffffff811bd394>] ? kobject_get+0x1a/0x22                                                   
[   19.369736]  [<ffffffff8123ba40>] ? get_device+0x19/0x1f                                                    
[   19.375045]  [<ffffffff8123c3ea>] device_add+0xe4/0x5d8                                                     
[   19.380270]  [<ffffffff811c7641>] ? __spin_lock_init+0x31/0x54                                              
[   19.386101]  [<ffffffff8123c8fc>] device_register+0x1e/0x22                                                 
[   19.391670]  [<ffffffff8123ca13>] device_create_vargs+0x113/0x140                                           
[   19.397760]  [<ffffffff810d96ae>] bdi_register+0x85/0x197                                                   
[   19.403159]  [<ffffffff8107959b>] ? trace_hardirqs_on_caller+0x10b/0x12f                                    
[   19.409854]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[   19.415250]  [<ffffffff811ca0cc>] ? __percpu_counter_init+0x9b/0xa7                                         
[   19.421513]  [<ffffffff811bf15b>] ? prop_local_init_percpu+0x43/0x48                                        
[   19.427861]  [<ffffffff810d97e8>] bdi_register_dev+0x28/0x2a                                                
[   19.433531]  [<ffffffffa0143b82>] nfs_set_super+0x41/0x9d [nfs]                                             
[   19.439447]  [<ffffffff810f8d36>] sget+0x3bc/0x490                                                          
[   19.444250]  [<ffffffffa0143b41>] ? nfs_set_super+0x0/0x9d [nfs]                                            
[   19.450272]  [<ffffffffa01434d8>] ? nfs_compare_super+0x0/0x183 [nfs]                                       
[   19.456722]  [<ffffffffa01450d2>] nfs_get_sb+0x806/0xae6 [nfs]                                              
[   19.462553]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[   19.467951]  [<ffffffff810f4b98>] ? pcpu_alloc+0x68c/0x704                                                  
[   19.473436]  [<ffffffff810f914f>] vfs_kern_mount+0x9e/0x122                                                 
[   19.479004]  [<ffffffff810f923a>] do_kern_mount+0x4c/0xec                                                   
[   19.484401]  [<ffffffff8111051b>] do_mount+0x748/0x7ae                                                      
[   19.489537]  [<ffffffff810cc051>] ? __get_free_pages+0x17/0x54                                              
[   19.495367]  [<ffffffff81110605>] sys_mount+0x84/0xbf                                                       
[   19.500418]  [<ffffffff8136317f>] ? trace_hardirqs_on_thunk+0x3a/0x3f                                       
[   19.506853]  [<ffffffff8100bc9b>] system_call_fastpath+0x16/0x1b                                            
mount.nfs: File exists                                                                                         
[FAILED]                                                                                                       
Mounting other filesystems:  [  OK  ]                                                                          
Starting acpi daemon: [  OK  ]                                                                                 
Starting PC/SC smart card daemon (pcscd): [  OK  ]                                                             
Retrigger failed udev events[  OK  ]                                                                           
Loading autofs4: [  OK  ]                                                                                      
Starting automount: [  OK  ]                                                                                   
Starting RPC idmapd: [  OK  ]                                                                                  
Starting hid2hci:                                                                                              
Starting sshd: [  OK  ]                                                                                        
Starting ntpd: [  OK  ]                                                                                        
/etc/profile.d/lang.sh: line 19: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                  
/etc/profile.d/lang.sh: line 20: warning: setlocale: LC_COLLATE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 23: warning: setlocale: LC_MESSAGES: cannot change locale (en_US.UTF-8): No such file or directory                                                                                               
/etc/profile.d/lang.sh: line 26: warning: setlocale: LC_NUMERIC: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 29: warning: setlocale: LC_TIME: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                   
[   22.910674] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).                                        
Starting NFS services:  [  OK  ]                                                                               
Starting NFS quotas: [  OK  ]                                                                                  
Starting NFS daemon: [   23.073455] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory  
[   23.095850] NFSD: starting 90-second grace period                                                           
[  OK  ]                                                                                                       
Starting NFS mountd: [  OK  ]                                                                                  
/etc/profile.d/lang.sh: line 19: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                  
/etc/profile.d/lang.sh: line 20: warning: setlocale: LC_COLLATE: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 23: warning: setlocale: LC_MESSAGES: cannot change locale (en_US.UTF-8): No such file or directory                                                                                               
/etc/profile.d/lang.sh: line 26: warning: setlocale: LC_NUMERIC: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                
/etc/profile.d/lang.sh: line 29: warning: setlocale: LC_TIME: cannot change locale (en_US.UTF-8): No such file or directory                                                                                                   
Starting sendmail: [  OK  ]                                                                                    
Starting sm-client: [  OK  ]                                                                                   
[  OK  ] crond: [  OK  ]                                                                                       
[  OK  ] atd: [  OK  ]                                                                                         
Starting smartd: [  OK  ]                                                                                      
                                                                                                               
Fedora release 11.90 (Rawhide)                                                                                 
Kernel 2.6.31-tip on an x86_64 (/dev/ttyS0)                                                                    
                                                                                                               
opteron login:                                                                                                 
Fedora release 11.90 (Rawhide)                                                                                 
Kernel 2.6.31-tip on an x86_64 (/dev/ttyS0)                                                                    
                                                                                                               
opteron login: [   35.174095]                                                                                  
[   35.174098] =======================================================                                         
[   35.175013] [ INFO: possible circular locking dependency detected ]                                         
[   35.175013] 2.6.31-tip #15                                                                                  
[   35.175013] -------------------------------------------------------                                         
[   35.175013] flush-8:0/559 is trying to acquire lock:                                                        
[   35.175013]  (sb_lock){+.+.+.}, at: [<ffffffff81114879>] writeback_inodes_wb+0x2a5/0x453                    
[   35.175013]                                                                                                 
[   35.175013] but task is already holding lock:                                                               
[   35.175013]  (inode_lock){+.+...}, at: [<ffffffff8111461f>] writeback_inodes_wb+0x4b/0x453                  
[   35.175013]                                                                                                 
[   35.175013] which lock already depends on the new lock.                                                     
[   35.175013]                                                                                                 
[   35.175013]                                                                                                 
[   35.175013] the existing dependency chain (in reverse order) is:                                            
[   35.175013]                                                                                                 
[   35.175013] -> #2 (inode_lock){+.+...}:                                                                     
[   35.175013]        [<ffffffff8107b5f6>] __lock_acquire+0x1430/0x176f                                        
[   35.175013]        [<ffffffff8107ba1d>] lock_acquire+0xe8/0x105                                             
[   35.175013]        [<ffffffff81363961>] _spin_lock+0x41/0x75                                                
[   35.175013]        [<ffffffff8110a72e>] ifind_fast+0x27/0x91                                                
[   35.175013]        [<ffffffff8110b88a>] iget_locked+0x3e/0x166                                              
[   35.175013]        [<ffffffff8114f257>] sysfs_get_inode+0x1f/0x20f                                          
[   35.175013]        [<ffffffff81151bf1>] sysfs_fill_super+0x56/0xc1                                          
[   35.175013]        [<ffffffff810f9340>] get_sb_single+0x66/0xad                                             
[   35.175013]        [<ffffffff81151b99>] sysfs_get_sb+0x1b/0x1d                                              
[   35.175013]        [<ffffffff810f914f>] vfs_kern_mount+0x9e/0x122                                           
[   35.175013]        [<ffffffff810f91ec>] kern_mount_data+0x19/0x1b                                           
[   35.175013]        [<ffffffff817a6640>] sysfs_init+0x5d/0xb8                                                
[   35.175013]        [<ffffffff817a56df>] mnt_init+0xa0/0x181                                                 
[   35.175013]        [<ffffffff817a52f0>] vfs_caches_init+0x10d/0x11e                                         
[   35.175013]        [<ffffffff817884ea>] start_kernel+0x342/0x389                                            
[   35.175013]        [<ffffffff81787b3a>] x86_64_start_reservations+0xaa/0xae                                 
[   35.175013]        [<ffffffff81787c1f>] x86_64_start_kernel+0xe1/0xe8                                       
[   35.175013]                                                                                                 
[   35.175013] -> #1 (sysfs_mutex){+.+.+.}:                                                                    
[   35.175013]        [<ffffffff8107b5f6>] __lock_acquire+0x1430/0x176f                                        
[   35.175013]        [<ffffffff8107ba1d>] lock_acquire+0xe8/0x105                                             
[   35.175013]        [<ffffffff81361e93>] mutex_lock_nested+0x5e/0x324                                        
[   35.175013]        [<ffffffff81150bd2>] sysfs_addrm_start+0x2d/0xaa                                         
[   35.175013]        [<ffffffff81151209>] create_dir+0x52/0x98                                                
[   35.175013]        [<ffffffff8115128c>] sysfs_create_dir+0x3d/0x54                                          
[   35.175013]        [<ffffffff811bd4f5>] kobject_add_internal+0xdb/0x19b                                     
[   35.175013]        [<ffffffff811bd68d>] kobject_add_varg+0x41/0x4e                                          
[   35.175013]        [<ffffffff811bd79f>] kobject_add+0x89/0x8b                                               
[   35.175013]        [<ffffffff8123c3ea>] device_add+0xe4/0x5d8                                               
[   35.175013]        [<ffffffff8123c8fc>] device_register+0x1e/0x22                                           
[   35.175013]        [<ffffffff8123ca13>] device_create_vargs+0x113/0x140                                     
[   35.175013]        [<ffffffff810d96ae>] bdi_register+0x85/0x197                                             
[   35.175013]        [<ffffffff810d97e8>] bdi_register_dev+0x28/0x2a                                          
[   35.175013]        [<ffffffffa0143b82>] nfs_set_super+0x41/0x9d [nfs]                                       
[   35.175013]        [<ffffffff810f8d36>] sget+0x3bc/0x490                                                    
[   35.175013]        [<ffffffffa01450d2>] nfs_get_sb+0x806/0xae6 [nfs]                                        
[   35.175013]        [<ffffffff810f914f>] vfs_kern_mount+0x9e/0x122                                           
[   35.175013]        [<ffffffff810f923a>] do_kern_mount+0x4c/0xec                                             
[   35.175013]        [<ffffffff8111051b>] do_mount+0x748/0x7ae                                                
[   35.175013]        [<ffffffff81110605>] sys_mount+0x84/0xbf                                                 
[   35.175013]        [<ffffffff8100bc9b>] system_call_fastpath+0x16/0x1b                                      
[   35.175013]                                                                                                 
[   35.175013] -> #0 (sb_lock){+.+.+.}:                                                                        
[   35.175013]        [<ffffffff8107b31b>] __lock_acquire+0x1155/0x176f                                        
[   35.175013]        [<ffffffff8107ba1d>] lock_acquire+0xe8/0x105                                             
[   35.175013]        [<ffffffff81363961>] _spin_lock+0x41/0x75                                                
[   35.175013]        [<ffffffff81114879>] writeback_inodes_wb+0x2a5/0x453                                     
[   35.175013]        [<ffffffff81114b68>] wb_writeback+0x141/0x194                                            
[   35.175013]        [<ffffffff81114e4e>] wb_do_writeback+0x1d2/0x1e8                                         
[   35.175013]        [<ffffffff81114ea3>] bdi_writeback_task+0x3f/0xae                                        
[   35.175013]        [<ffffffff810d9d1c>] bdi_start_fn+0x76/0xda                                              
[   35.175013]        [<ffffffff810678b9>] kthread+0x82/0x8a                                                   
[   35.175013]        [<ffffffff8100ce1a>] child_rip+0xa/0x20                                                  
[   35.175013]                                                                                                 
[   35.175013] other info that might help us debug this:                                                       
[   35.175013]                                                                                                 
[   35.175013] 1 lock held by flush-8:0/559:                                                                   
[   35.175013]  #0:  (inode_lock){+.+...}, at: [<ffffffff8111461f>] writeback_inodes_wb+0x4b/0x453             
[   35.175013]                                                                                                 
[   35.175013] stack backtrace:                                                                                
[   35.175013] Pid: 559, comm: flush-8:0 Tainted: G        W  2.6.31-tip #15                                   
[   35.175013] Call Trace:                                                                                     
[   35.175013]  [<ffffffff81079c78>] print_circular_bug+0xb3/0xc2                                              
[   35.175013]  [<ffffffff8107b31b>] __lock_acquire+0x1155/0x176f                                              
[   35.175013]  [<ffffffff8107ba1d>] lock_acquire+0xe8/0x105                                                   
[   35.175013]  [<ffffffff81114879>] ? writeback_inodes_wb+0x2a5/0x453                                         
[   35.175013]  [<ffffffff81363961>] _spin_lock+0x41/0x75                                                      
[   35.175013]  [<ffffffff81114879>] ? writeback_inodes_wb+0x2a5/0x453                                         
[   35.175013]  [<ffffffff81077b3d>] ? lock_release_holdtime+0xfb/0x100                                        
[   35.175013]  [<ffffffff81114879>] writeback_inodes_wb+0x2a5/0x453                                           
[   35.175013]  [<ffffffff81114b68>] wb_writeback+0x141/0x194                                                  
[   35.175013]  [<ffffffff81114e4e>] wb_do_writeback+0x1d2/0x1e8                                               
[   35.175013]  [<ffffffff81114d1e>] ? wb_do_writeback+0xa2/0x1e8                                              
[   35.175013]  [<ffffffff81114ea3>] bdi_writeback_task+0x3f/0xae                                              
[   35.175013]  [<ffffffff810d9ca6>] ? bdi_start_fn+0x0/0xda                                                   
[   35.175013]  [<ffffffff810d9d1c>] bdi_start_fn+0x76/0xda                                                    
[   35.175013]  [<ffffffff810d9ca6>] ? bdi_start_fn+0x0/0xda                                                   
[   35.175013]  [<ffffffff810678b9>] kthread+0x82/0x8a                                                         
[   35.175013]  [<ffffffff8100ce1a>] child_rip+0xa/0x20                                                        
[   35.175013]  [<ffffffff8100c780>] ? restore_args+0x0/0x30                                                   
[   35.175013]  [<ffffffff81067837>] ? kthread+0x0/0x8a                                                        
[   35.175013]  [<ffffffff8100ce10>] ? child_rip+0x0/0x20                                                      
[  144.209162] ------------[ cut here ]------------                                                            
[  144.213807] WARNING: at /mnt/build/linux-2.6/fs/sysfs/dir.c:487 sysfs_add_one+0xf8/0x10f()                  
[  144.222079] Hardware name: To Be Filled By O.E.M.                                                           
[  144.226799] sysfs: cannot create duplicate filename '/class/bdi/0:0'                                        
[  144.233161] Modules linked in: nfsd exportfs autofs4 nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand kvm_amd kvm uinput sg sr_mod serio_raw pcspkr floppy cdrom button shpchp [last unloaded: scsi_wait_scan]        
[  144.252563] Pid: 1602, comm: mount.nfs Tainted: G        W  2.6.31-tip #15                                  
[  144.259444] Call Trace:                                                                                     
[  144.261916]  [<ffffffff81150b8e>] ? sysfs_add_one+0xf8/0x10f                                                
[  144.267598]  [<ffffffff8104d009>] warn_slowpath_common+0x7c/0xa9                                            
[  144.273630]  [<ffffffff8104d0b5>] warn_slowpath_fmt+0x69/0x6b                                               
[  144.279399]  [<ffffffff81150c22>] ? sysfs_addrm_start+0x7d/0xaa                                             
[  144.285334]  [<ffffffff81150a8e>] ? sysfs_pathname+0x3c/0x44                                                
[  144.291028]  [<ffffffff81150a8e>] ? sysfs_pathname+0x3c/0x44                                                
[  144.296701]  [<ffffffff81150a8e>] ? sysfs_pathname+0x3c/0x44                                                
[  144.302382]  [<ffffffff81150b8e>] sysfs_add_one+0xf8/0x10f                                                  
[  144.307884]  [<ffffffff81151214>] create_dir+0x5d/0x98                                                      
[  144.313043]  [<ffffffff8115128c>] sysfs_create_dir+0x3d/0x54                                                
[  144.318719]  [<ffffffff8136378b>] ? _spin_unlock+0x35/0x50                                                  
[  144.324227]  [<ffffffff811bd4f5>] kobject_add_internal+0xdb/0x19b                                           
[  144.330339]  [<ffffffff811bd68d>] kobject_add_varg+0x41/0x4e                                                
[  144.336033]  [<ffffffff811bd79f>] kobject_add+0x89/0x8b                                                     
[  144.341278]  [<ffffffff81077f80>] ? lockdep_init_map+0xae/0x510                                             
[  144.347222]  [<ffffffff811bd394>] ? kobject_get+0x1a/0x22                                                   
[  144.352638]  [<ffffffff8123ba40>] ? get_device+0x19/0x1f                                                    
[  144.357972]  [<ffffffff8123c3ea>] device_add+0xe4/0x5d8                                                     
[  144.363214]  [<ffffffff811c7641>] ? __spin_lock_init+0x31/0x54                                              
[  144.369064]  [<ffffffff8123c8fc>] device_register+0x1e/0x22                                                 
[  144.374653]  [<ffffffff8123ca13>] device_create_vargs+0x113/0x140                                           
[  144.380766]  [<ffffffff810d96ae>] bdi_register+0x85/0x197                                                   
[  144.386186]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[  144.391603]  [<ffffffff811ca0cc>] ? __percpu_counter_init+0x9b/0xa7                                         
[  144.397883]  [<ffffffff811bf15b>] ? prop_local_init_percpu+0x43/0x48                                        
[  144.404251]  [<ffffffff810d97e8>] bdi_register_dev+0x28/0x2a                                                
[  144.409972]  [<ffffffffa0143b82>] nfs_set_super+0x41/0x9d [nfs]                                             
[  144.415918]  [<ffffffff810f8d36>] sget+0x3bc/0x490                                                          
[  144.420755]  [<ffffffffa0143b41>] ? nfs_set_super+0x0/0x9d [nfs]                                            
[  144.426808]  [<ffffffffa01434d8>] ? nfs_compare_super+0x0/0x183 [nfs]                                       
[  144.433292]  [<ffffffffa01450d2>] nfs_get_sb+0x806/0xae6 [nfs]                                              
[  144.439140]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[  144.444557]  [<ffffffff810f4b98>] ? pcpu_alloc+0x68c/0x704                                                  
[  144.450063]  [<ffffffff810f914f>] vfs_kern_mount+0x9e/0x122                                                 
[  144.455652]  [<ffffffff810f923a>] do_kern_mount+0x4c/0xec                                                   
[  144.461073]  [<ffffffff8111051b>] do_mount+0x748/0x7ae                                                      
[  144.466229]  [<ffffffff810cc051>] ? __get_free_pages+0x17/0x54                                              
[  144.472089]  [<ffffffff81110605>] sys_mount+0x84/0xbf                                                       
[  144.477157]  [<ffffffff8136317f>] ? trace_hardirqs_on_thunk+0x3a/0x3f                                       
[  144.483624]  [<ffffffff8100bc9b>] system_call_fastpath+0x16/0x1b                                            
[  144.489640] ---[ end trace 630c33e55fa37c37 ]---                                                            
[  144.494279] kobject_add_internal failed for 0:0 with -EEXIST, don't try to register things with the same name in the same directory.                                                                                       
[  144.506183] Pid: 1602, comm: mount.nfs Tainted: G        W  2.6.31-tip #15                                  
[  144.513069] Call Trace:                                                                                     
[  144.515538]  [<ffffffff811bd26e>] ? kobject_put+0x47/0x4b                                                   
[  144.520956]  [<ffffffff811bd59c>] kobject_add_internal+0x182/0x19b                                          
[  144.527151]  [<ffffffff811bd68d>] kobject_add_varg+0x41/0x4e                                                
[  144.532828]  [<ffffffff811bd79f>] kobject_add+0x89/0x8b                                                     
[  144.538071]  [<ffffffff81077f80>] ? lockdep_init_map+0xae/0x510                                             
[  144.544029]  [<ffffffff811bd394>] ? kobject_get+0x1a/0x22                                                   
[  144.549444]  [<ffffffff8123ba40>] ? get_device+0x19/0x1f                                                    
[  144.554774]  [<ffffffff8123c3ea>] device_add+0xe4/0x5d8                                                     
[  144.560028]  [<ffffffff811c7641>] ? __spin_lock_init+0x31/0x54                                              
[  144.565881]  [<ffffffff8123c8fc>] device_register+0x1e/0x22                                                 
[  144.571471]  [<ffffffff8123ca13>] device_create_vargs+0x113/0x140                                           
[  144.577584]  [<ffffffff810d96ae>] bdi_register+0x85/0x197                                                   
[  144.582999]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[  144.588419]  [<ffffffff811ca0cc>] ? __percpu_counter_init+0x9b/0xa7                                         
[  144.594700]  [<ffffffff811bf15b>] ? prop_local_init_percpu+0x43/0x48                                        
[  144.601067]  [<ffffffff810d97e8>] bdi_register_dev+0x28/0x2a                                                
[  144.606772]  [<ffffffffa0143b82>] nfs_set_super+0x41/0x9d [nfs]                                             
[  144.612711]  [<ffffffff810f8d36>] sget+0x3bc/0x490                                                          
[  144.617548]  [<ffffffffa0143b41>] ? nfs_set_super+0x0/0x9d [nfs]                                            
[  144.623605]  [<ffffffffa01434d8>] ? nfs_compare_super+0x0/0x183 [nfs]                                       
[  144.630090]  [<ffffffffa01450d2>] nfs_get_sb+0x806/0xae6 [nfs]                                              
[  144.635946]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[  144.641361]  [<ffffffff810f4b98>] ? pcpu_alloc+0x68c/0x704                                                  
[  144.646875]  [<ffffffff810f914f>] vfs_kern_mount+0x9e/0x122                                                 
[  144.652463]  [<ffffffff810f923a>] do_kern_mount+0x4c/0xec                                                   
[  144.657883]  [<ffffffff8111051b>] do_mount+0x748/0x7ae                                                      
[  144.663037]  [<ffffffff810cc051>] ? __get_free_pages+0x17/0x54                                              
[  144.668892]  [<ffffffff81110605>] sys_mount+0x84/0xbf                                                       
[  144.673960]  [<ffffffff8136317f>] ? trace_hardirqs_on_thunk+0x3a/0x3f                                       
[  144.680417]  [<ffffffff8100bc9b>] system_call_fastpath+0x16/0x1b                                            
[  144.740854] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008                       
[  144.741531] IP: [<ffffffff810d9572>] bdi_destroy+0x70/0x127                                                 
[  144.741531] PGD 0                                                                                           
[  144.741531] Oops: 0002 [#1] PREEMPT SMP                                                                     
[  144.741531] last sysfs file: /sys/devices/pci0000:00/0000:00:05.0/irq                                       
[  144.741531] CPU 0                                                                                           
[  144.741531] Modules linked in: nfsd exportfs autofs4 nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand kvm_amd kvm uinput sg sr_mod serio_raw pcspkr floppy cdrom button shpchp [last unloaded: scsi_wait_scan]        
[  144.741531] Pid: 1605, comm: mount.nfs Tainted: G        W  2.6.31-tip #15 To Be Filled By O.E.M.           
[  144.741531] RIP: 0010:[<ffffffff810d9572>]  [<ffffffff810d9572>] bdi_destroy+0x70/0x127                     
[  144.741531] RSP: 0018:ffff88007d4f9b38  EFLAGS: 00010213                                                    
[  144.741531] RAX: 0000000000000000 RBX: ffff88007b940848 RCX: 0000000000000000                               
[  144.741531] RDX: ffffffff815651d0 RSI: ffffffff815671b8 RDI: ffffffff810d9551                               
[  144.741531] RBP: ffff88007d4f9b48 R08: ffff880005dda080 R09: 0000000000000000                               
[  144.741531] R10: 0000000000000246 R11: ffffffff81566960 R12: ffff88007b940a58                               
[  144.741531] R13: ffff88007f185400 R14: ffff88007dcf2800 R15: ffff88007d5d4180                               
[  144.741531] FS:  00007f18438d66f0(0000) GS:ffff880005c00000(0000) knlGS:0000000000000000                    
[  144.741531] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                               
[  144.741531] CR2: 0000000000000008 CR3: 000000007ddde000 CR4: 00000000000006f0                               
[  144.741531] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                               
[  144.741531] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                               
[  144.741531] Process mount.nfs (pid: 1605, threadinfo ffff88007d4f8000, task ffff88007b99e940)               
[  144.741531] Stack:                                                                                          
[  144.741531]  ffff88007b940800 ffffffffffffff8c ffff88007d4f9b68 ffffffffa0139795                            
[  144.741531] <0> ffff88007dcf2800 00000000ffffff8c ffff88007d4f9cc8 ffffffffa013a65d                         
[  144.741531] <0> ffff88007d4f9bf8 ffffffffa00d1b15 ffff880000000000 ffff88007b99e940                         
[  144.741531] Call Trace:                                                                                     
[  144.741531]  [<ffffffffa0139795>] nfs_free_server+0xea/0x112 [nfs]                                          
[  144.741531]  [<ffffffffa013a65d>] nfs_create_server+0x5ca/0x5e1 [nfs]                                       
[  144.741531]  [<ffffffffa00d1b15>] ? rpc_shutdown_client+0xdb/0xea [sunrpc]                                  
[  144.741531]  [<ffffffffa00d1827>] ? rpc_call_sync+0x59/0x62 [sunrpc]                                        
[  144.741531]  [<ffffffffa014d8da>] ? nfs_mount+0x128/0x1ab [nfs]                                             
[  144.741531]  [<ffffffff810795cc>] ? trace_hardirqs_on+0xd/0xf                                               
[  144.741531]  [<ffffffffa0145090>] nfs_get_sb+0x7c4/0xae6 [nfs]                                              
[  144.741531]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[  144.741531]  [<ffffffff810f4b98>] ? pcpu_alloc+0x68c/0x704                                                  
[  144.741531]  [<ffffffff810f914f>] vfs_kern_mount+0x9e/0x122                                                 
[  144.741531]  [<ffffffff810f923a>] do_kern_mount+0x4c/0xec                                                   
[  144.741531]  [<ffffffff8111051b>] do_mount+0x748/0x7ae                                                      
[  144.741531]  [<ffffffff810cc051>] ? __get_free_pages+0x17/0x54                                              
[  144.741531]  [<ffffffff81110605>] sys_mount+0x84/0xbf                                                       
[  144.741531]  [<ffffffff8136317f>] ? trace_hardirqs_on_thunk+0x3a/0x3f                                       
[  144.741531]  [<ffffffff8100bc9b>] system_call_fastpath+0x16/0x1b                                            
[  144.741531] Code: c7 a0 71 56 81 e8 cf a3 28 00 48 8b 8b 10 02 00 00 4c 39 e1 74 24 48 8b 15 6c bc 48 00 48 8b 83 18 02 00 00 48 89 0d 5e bc 48 00 <48> c7 41 08 d0 51 56 81 48 89 10 48 89 42 08 48 8b 8b 20 02 00        
[  144.741531] RIP  [<ffffffff810d9572>] bdi_destroy+0x70/0x127                                                
[  144.741531]  RSP <ffff88007d4f9b38>                                                                         
[  144.741531] CR2: 0000000000000008                                                                           
[  145.042325] ---[ end trace 630c33e55fa37c38 ]---                                                            
[  145.046983] note: mount.nfs[1605] exited with preempt_count 2                                               
[  145.052757] BUG: scheduling while atomic: mount.nfs/1605/0x10000002                                         
[  145.059020] INFO: lockdep is turned off.
[  145.062943] Modules linked in: nfsd exportfs autofs4 nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand kvm_amd kvm uinput sg sr_mod serio_raw pcspkr floppy cdrom button shpchp [last unloaded: scsi_wait_scan]
[  145.082176] Pid: 1605, comm: mount.nfs Tainted: G      D W  2.6.31-tip #15
[  145.089042] Call Trace:
[  145.091501]  [<ffffffff810789d3>] ? __debug_show_held_locks+0x1b/0x24
[  145.097942]  [<ffffffff81041d6d>] __schedule_bug+0x72/0x77
[  145.103430]  [<ffffffff813604ef>] schedule+0x117/0xb5e
[  145.108571]  [<ffffffff8107ba58>] ? print_lock_contention_bug+0x1e/0x110
[  145.115275]  [<ffffffff813637a2>] ? _spin_unlock+0x4c/0x50
[  145.120764]  [<ffffffff81077a40>] ? trace_hardirqs_off+0xd/0xf
[  145.126601]  [<ffffffff81042b58>] __cond_resched+0x18/0x24
[  145.132087]  [<ffffffff81361191>] _cond_resched+0x29/0x34
[  145.137489]  [<ffffffff810dc763>] unmap_vmas+0x76b/0x960
[  145.142803]  [<ffffffff8104dd0e>] ? vprintk+0x380/0x3ac
[  145.148036]  [<ffffffff810e1052>] exit_mmap+0xd2/0x177
[  145.153179]  [<ffffffff8104a90f>] mmput+0x30/0xc5
[  145.157888]  [<ffffffff8104eb2a>] exit_mm+0x110/0x11b
[  145.162941]  [<ffffffff81050457>] do_exit+0x1c3/0x6d4
[  145.167999]  [<ffffffff81364f3f>] oops_end+0xb7/0xbf
[  145.172969]  [<ffffffff8102f3bb>] no_context+0x1f2/0x201
[  145.178286]  [<ffffffff810795cc>] ? trace_hardirqs_on+0xd/0xf
[  145.184033]  [<ffffffff8102f56f>] __bad_area_nosemaphore+0x1a5/0x1cb
[  145.190428]  [<ffffffffa00d18ee>] ? rpc_free_client+0x0/0xfb [sunrpc]
[  145.196868]  [<ffffffff8102f5a8>] bad_area_nosemaphore+0x13/0x15
[  145.202876]  [<ffffffff81366843>] do_page_fault+0x225/0x35b
[  145.208451]  [<ffffffff813642cf>] page_fault+0x1f/0x30
[  145.213592]  [<ffffffff810d9551>] ? bdi_destroy+0x4f/0x127
[  145.219080]  [<ffffffff810d9572>] ? bdi_destroy+0x70/0x127
[  145.224568]  [<ffffffff810d9551>] ? bdi_destroy+0x4f/0x127
[  145.230084]  [<ffffffffa0139795>] nfs_free_server+0xea/0x112 [nfs]
[  145.236293]  [<ffffffffa013a65d>] nfs_create_server+0x5ca/0x5e1 [nfs]
[  145.242769]  [<ffffffffa00d1b15>] ? rpc_shutdown_client+0xdb/0xea [sunrpc]
[  145.249677]  [<ffffffffa00d1827>] ? rpc_call_sync+0x59/0x62 [sunrpc]
[  145.256065]  [<ffffffffa014d8da>] ? nfs_mount+0x128/0x1ab [nfs]
[  145.261987]  [<ffffffff810795cc>] ? trace_hardirqs_on+0xd/0xf
[  145.267764]  [<ffffffffa0145090>] nfs_get_sb+0x7c4/0xae6 [nfs]
[  145.273600]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10
[  145.279001]  [<ffffffff810f4b98>] ? pcpu_alloc+0x68c/0x704
[  145.284492]  [<ffffffff810f914f>] vfs_kern_mount+0x9e/0x122
[  145.290066]  [<ffffffff810f923a>] do_kern_mount+0x4c/0xec
[  145.295469]  [<ffffffff8111051b>] do_mount+0x748/0x7ae
[  145.300614]  [<ffffffff810cc051>] ? __get_free_pages+0x17/0x54
[  145.306449]  [<ffffffff81110605>] sys_mount+0x84/0xbf
[  145.311505]  [<ffffffff8136317f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  145.317945]  [<ffffffff8100bc9b>] system_call_fastpath+0x16/0x1b


