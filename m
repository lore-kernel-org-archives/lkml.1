Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbYAMLLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbYAMLLE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 06:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYAMLKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 06:10:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:35449 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYAMLKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 06:10:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=VpBwXbul9gnVBGxhOFp9aSyQYaUxvGVQ8W2okb/n2wJ5ua6AahJYFp7x/yD0ckpWUNmAcTx2ZK/EpkeeecskFgFFfGFRICmwcjZHl2fTVw1NSuh0VSqz9ASSnIYIdoLwc7CybpTCGd1c6zzypARa237Y4IPLF7gT1Ze+h5rivXg=
Message-ID: <76366b180801130310x57f24cc8s641d3ccb2415524c@mail.gmail.com>
Date: Sun, 13 Jan 2008 06:10:52 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: linux-kernel@vger.kernel.org
Subject: HPET timer broken using 2.6.23.13 / nanosleep() hangs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: d75f0169380b9602
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started debugging a problem I was having with my sky2 network driver
under 2.6.23.13. The investigation led me to find that the HPET timer
wasn't working at all, causing the sky2 driver to not work properly.
Simple example:

am2:/sys/devices/system/clocksource/clocksource0# cat current_clocksource
jiffies
am2:/sys/devices/system/clocksource/clocksource0# time sleep 1
real    0m1.000s
user    0m0.000s
sys     0m0.000s
am2:/sys/devices/system/clocksource/clocksource0# echo tsc > current_clocksource
am2:/sys/devices/system/clocksource/clocksource0# time sleep 1
real    0m1.005s
user    0m0.004s
sys     0m0.000s
am2:/sys/devices/system/clocksource/clocksource0# echo hpet >
current_clocksource
am2:/sys/devices/system/clocksource/clocksource0# time sleep 1
<hangs indefinetly...>

Running strace shows it blocked on nanosleep(). I'm building the
kernel with the processor type set to Athalon64. I've built it with
and without SMP and high-res timers enabled and I get the same result.
My previous 2.6.18-4 kernel works because it does not install HPET as
the default timer. The same behavior occurs in 2.6.24-rc7 git head.
I've attached the config/dmesg below.

-Andrew

Under 2.6.18-4 (Debian stock kernel):

ACPI: HPET id: 0x10b9a201 base: 0xfed00000
hpet0: at MMIO 0xfed00000 (virtual 0xf8800000), IRQs 2, 8, 0, 0
hpet0: 4 32-bit timers, 14318180 Hz
Using HPET for base-timer
hpet_resources: 0xfed00000 is busy
Time: tsc clocksource has been installed.

Under 2.6.23.13 w/ SMP:

ACPI: HPET 37FE7400, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD       98)
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Time: tsc clocksource has been installed.
Clocksource tsc unstable (delta = 500013666 ns)
Time: hpet clocksource has been installed.

Relevant top of .config from 2.6.23.13:

CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CPUSETS is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_LSF=y
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
# CONFIG_TICK_ONESHOT is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_SMP=y
CONFIG_X86_PC=y
CONFIG_MK8=y
CONFIG_X86_GENERIC=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

dmesg full output until HPET is installed:

Linux version 2.6.23.13 (root@am2) (gcc version 4.1.2 20061115
(prerelease) (Debian 4.1.1-21)) #7 SMP Sun Jan 13 05:02:40
 EST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000037fe0000 (usable)
 BIOS-e820: 0000000037fe0000 - 0000000037fe3000 (ACPI NVS)
 BIOS-e820: 0000000037fe3000 - 0000000037ff0000 (ACPI data)
 BIOS-e820: 0000000037ff0000 - 0000000038000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
895MB LOWMEM available.
found SMP MP-table at 000f3b50
Entering add_active_range(0, 0, 229344) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229344
  HighMem    229344 ->   229344
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   229344
On node 0 totalpages: 229344
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1759 pages used for memmap
  Normal zone: 223489 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
DMI 2.5 present.
ACPI: RSDP 000F7CE0, 0024 (r2 RS690 )
ACPI: RSDT 37FE3040, 0034 (r1 RS690  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 37FE30C0, 0074 (r1 RS690  AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 37FE3180, 4146 (r1 RS690  AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 37FE0000, 0040
ACPI: HPET 37FE7400, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG 37FE7480, 003C (r1 RS690  AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 37FE7340, 0068 (r1 RS690  AWRDACPI 42302E31 AWRD        0)
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:15 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 40000000 (gap: 38000000:a8000000)
Built 1 zonelists in Zone order.  Total pages: 227553
Kernel command line: vga=0x31a root=/dev/sda1 ro
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2400.121 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 904288k/917376k available (2775k kernel code, 12644k reserved,
1154k data, 228k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf7fe0000   ( 895 MB)
      .init : 0xc04df000 - 0xc0518000   ( 228 kB)
      .data : 0xc03b5d36 - 0xc04d66ac   (1154 kB)
      .text : 0xc0100000 - 0xc03b5d36   (2775 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4927.60 BogoMIPS (lpj=9855209)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 078bfbff ebd3fbff 00000000 00000000
00002001 00000000 0000001d 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: After all inits, caps: 078bfbff ebd3fbff 00000000 00000410
00002001 00000000 0000001d 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 16k freed
ACPI: Core revision 20070126
CPU0: AMD Athlon(tm) 64 Processor 3800+ stepping 02
Total of 1 processors activated (4927.60 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Brought up 1 CPUs
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  7361.000 MB/sec
xor: using function: pIII_sse (7361.000 MB/sec)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
PCI: No mmconfig possible on device 00:18
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 1 of device 0000:00:14.0
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
pnp: 00:01: ioport range 0x4100-0x411f has been reserved
pnp: 00:01: ioport range 0x228-0x22f has been reserved
pnp: 00:01: ioport range 0x40b-0x40b has been reserved
pnp: 00:01: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:01: ioport range 0xc00-0xc01 has been reserved
pnp: 00:01: ioport range 0xc14-0xc14 has been reserved
pnp: 00:01: ioport range 0xc50-0xc52 has been reserved
pnp: 00:01: ioport range 0xc6c-0xc6d has been reserved
pnp: 00:09: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:0a: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:0a: iomem range 0xfed00000-0xfed000ff could not be reserved
pnp: 00:0a: iomem range 0x37fe0000-0x37ffffff could not be reserved
pnp: 00:0a: iomem range 0xffff0000-0xffffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: fde00000-fdffffff
  PREFETCH window: d8000000-dfffffff
PCI: Bridge: 0000:00:06.0
  IO window: e000-efff
  MEM window: fdd00000-fddfffff
  PREFETCH window: fdc00000-fdcfffff
PCI: Bridge: 0000:00:14.4
  IO window: c000-cfff
  MEM window: fdb00000-fdbfffff
  PREFETCH window: fda00000-fdafffff
PCI: Setting latency timer of device 0000:00:06.0 to 64
...
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: Fan [FAN] (on)
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device
is not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device
is not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device
is not present [20070126]
ACPI: Thermal Zone [THRM] (-127 C)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
...
Clocksource tsc unstable (delta = 500013666 ns)
Time: hpet clocksource has been installed.

dmidecode:

BIOS Information
        Vendor: Phoenix Technologies, LTD
        Version: 6.00 PG
        Release Date: 04/03/2007
        Address: 0xE0000
        Runtime Size: 128 kB
        ROM Size: 512 kB
