Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYJ3KZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYJ3KZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYJ3KZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:25:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:26077 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbYJ3KZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EP3arNH/yWZAiT0/j/cDdXZvPaFwHC5cllukwJ3m7bOu0B/3w+BGSU9DSNo7dqzps8
         tZ7jE23zaxk/XzATMhVyuh/A4hzl/7Y13iGkEsRgdcId+FCjIw/aPStDeQCkWxjby2fo
         lAaTnIrU7Irfynp/Qk/BW2V1X4KvuTqzNBa3M=
Message-ID: <f3642e6b0810300325s636baf7ascdb9a42d4698e636@mail.gmail.com>
Date: Thu, 30 Oct 2008 11:25:27 +0100
From: "Andreas Hartmetz" <ahartmetz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RAID ate my PCIe-PCI bridge's MMIO address space (?)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I have a problem with my sound card. It is the only regular PCI device in my
system and the problem is apparently not directly the sound card's.
alsamixer works fine but any application trying to play sound will either
hang when trying to play the first sample (mplayer, aplay) or report an error
(amarok with xine backend).

mplayer, for example, hangs in an endless loop of this:

nanosleep({0, 10000000}, NULL)          = 0
ioctl(5, 0x4122, 0)                     = 0
ioctl(5, 0x4122, 0)                     = 0


Hardware:
Gigabyte GA-MA78G-DS3H mainboard, AMD 780G chipset
2 GB memory
Phenom quad-core CPU in AMD64 mode
2 SATA harddisks
1 PATA cdrom
on-board graphics
PCI sound card M-Audio Revolution 7.1 (ice1724)

Software:
Kubuntu 8.10, kernel 2.6.27
Software RAID1 (aka md-raid (?))
[the rest is probably not interesting]

When I boot a live CD of the same distro with the same kernel the soundcard
works fine (and no, it's not a matter of some process blocking the card).
The diff of loaded modules looks like this:

- snip -

diff -u modlist.live modlist.inst
--- modlist.live        2008-10-30 03:32:59.000000000 +0100
+++ modlist.inst        2008-10-30 03:48:38.000000000 +0100
@@ -1,30 +1,34 @@
 ac                     13448  0
 ac97_bus               10368  1 snd_ac97_codec
-af_packet              29568  2
-ahci                   43148  2
+ahci                   43148  4
+async_memcpy           10752  1 raid456
+async_tx               16764  3 raid456,async_xor,async_memcpy
+async_xor              12032  1 raid456
 ata_generic            14212  0
-aufs                  196968  1
 battery                21128  0
 bitblit                14592  1 fbcon
-bluetooth              70820  6 bnep,rfcomm,sco,l2cap
+bluetooth              70820  6 rfcomm,bnep,sco,l2cap
 bnep                   23168  2
 bridge                 64544  0
 button                 15904  0
 cdrom                  47784  1 sr_mod
 container              12288  0
 cpufreq_conservative    16392  0
-cpufreq_ondemand       16400  4
+cpufreq_ondemand       16400  0
 cpufreq_powersave      10368  0
 cpufreq_stats          14468  0
-cpufreq_userspace      12420  0
+cpufreq_userspace      12420  4
 crc_t10dif             10240  1 sd_mod
+crypto_blkcipher       27780  1 dm_crypt
+dm_crypt               22792  0
+dm_mod                 72944  1 dm_crypt
 dock                   18464  1 libata
 ehci_hcd               48908  0
-evdev                  20512  7
-exportfs               13568  1 aufs
+evdev                  20512  3
 ext3                  150544  1
 fan                    13576  0
 fbcon                  51200  0
+fglrx                2082944  28
 font                   17152  1 fbcon
 freq_table             13568  3
powernow_k8,cpufreq_stats,cpufreq_ondemand
 fuse                   68288  1
@@ -33,22 +37,23 @@
 i2c_piix4              17936  0
 iptable_filter         11520  0
 ip_tables              28176  1 iptable_filter
-isofs                  44072  1
+ipv6                  314312  18
 jbd                    66472  1 ext3
 joydev                 20736  0
-l2cap                  33280  6 bnep,rfcomm
-libata                200160  4
pata_atiixp,pata_acpi,ata_generic,ahci
-loop                   26380  2
+l2cap                  33280  6 rfcomm,bnep
+libata                200160  4
pata_atiixp,pata_acpi,ahci,ata_generic
+linear                 13440  0
 lp                     19588  0
 mbcache                17924  1 ext3
+md_mod                102948  7
raid10,raid456,raid1,raid0,multipath,linear
 Module                  Size  Used by
-nls_cp437              15232  1
+multipath              16512  0
 ohci_hcd               34972  0
 output                 11776  1 video
 parport                50096  3 ppdev,parport_pc,lp
 parport_pc             44200  0
 pata_acpi              13568  0
-pata_atiixp            14208  1
+pata_atiixp            14208  0
 pci_hotplug            39472  1 shpchp
 pci_slot               13704  0
 pcspkr                 11136  0
@@ -56,25 +61,28 @@
 ppdev                  16904  0
 processor              47800  2 powernow_k8,thermal
 r8169                  40196  0
+raid0                  15488  0
+raid10                 32000  0
+raid1                  32640  1
+raid456               139552  0
 rfcomm                 51104  0
 sbs                    22288  0
 sbshc                  14592  1 sbs
 sco                    20612  2
 scsi_mod              183160  4 sr_mod,sd_mod,sg,libata
-sd_mod                 45864  4
+sd_mod                 45864  6
 sg                     45408  0
 shpchp                 42140  0
-snd                    79432  19
snd_hda_intel,snd_ice1724,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_ak4xxx_adda,snd_ak4114,snd_pt2258,snd_pcm,snd_i2c,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
+snd                    79432  14
snd_ice1724,snd_ac97_codec,snd_ak4xxx_adda,snd_ak4114,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_pt2258,snd_i2c,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
 snd_ac97_codec        133080  1 snd_ice1724
 snd_ak4114             19328  1 snd_ice1724
 snd_ak4xxx_adda        17792  2 snd_ice1724,snd_ice17xx_ak4xxx
-snd_hda_intel         489264  1
 snd_i2c                14720  2 snd_ice1724,snd_pt2258
-snd_ice1724           119912  1
+snd_ice1724           119912  0
 snd_ice17xx_ak4xxx     12416  1 snd_ice1724
 snd_mixer_oss          25088  1 snd_pcm_oss
-snd_page_alloc         17680  2 snd_hda_intel,snd_pcm
-snd_pcm                99208  5
snd_hda_intel,snd_ice1724,snd_ac97_codec,snd_pcm_oss,snd_ak4114
+snd_page_alloc         17680  1 snd_pcm
+snd_pcm                99208  4
snd_ice1724,snd_ac97_codec,snd_ak4114,snd_pcm_oss
 snd_pcm_oss            52608  0
 snd_pt2258             12800  1 snd_ice1724
 snd_rawmidi            34176  2 snd_ice1724,snd_seq_midi
@@ -87,13 +95,15 @@
 snd_timer              34320  2 snd_pcm,snd_seq
 softcursor             10496  1 bitblit
 soundcore              16800  1 snd
-squashfs               48912  1
-sr_mod                 24644  1
+sr_mod                 24644  0
 stp                    11268  1 bridge
 thermal                27424  0
 tileblit               11264  1 fbcon
-usbcore               175376  4 usbhid,ehci_hcd,ohci_hcd
+tun                    20996  0
+usbcore               175376  4 usbhid,ohci_hcd,ehci_hcd
 usbhid                 39776  0
 video                  28948  0
 wmi                    15808  0
+xfs                   575376  1
+xor                    14096  2 raid456,async_xor
 x_tables               31752  1 ip_tables

- snip -

Note that fglrx or no fglrx, as well as Intel HDA driver or no HDA driver,
don't make any difference for my problem - I tested that.
Some Ubuntu bug report that I can't find again suggested that RAID may actually
cause problems due to "suboptimal" address space allocation. I found that
bug report when searching for the specific error message
"shpchp: shpc_init: cannot reserve MMIO region"
that is present when booting the installed system but not when booting the
live CD.
The md modules are loaded from initramfs, way before the PCI bridge driver, so
it seems plausible that they somehow snatch a piece of address space that they
shouldn't.
Presumably this could be due to md wanting avoid copying, hence allocating
MMIO address space.
/var/log/syslog and lspci -vv output are appended so you can see for yourself.
I can test bugfix and diagnostic patches as well.

Cheers,
Andreas

/var/log/syslog:

Oct 30 09:59:18 rechenplan syslogd 1.5.0#2ubuntu6: restart.
Oct 30 09:59:18 rechenplan kernel: Inspecting /boot/System.map-2.6.27-7-generic
Oct 30 09:59:18 rechenplan kernel: Cannot find map file.
Oct 30 09:59:18 rechenplan kernel: Loaded 59100 symbols from 107 modules.
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Initializing cgroup
subsys cpuset
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Initializing cgroup subsys cpu
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Linux version
2.6.27-7-generic (buildd@yellow) (gcc version 4.3.2 (Ubuntu
4.3.2-1ubuntu10) ) #1 SMP Fri Oct 24 06:40:41 UTC 2008 (Ubuntu
2.6.27-7.14-generic)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Command line:
root=/dev/md0 ro
Oct 30 09:59:18 rechenplan kernel: [    0.000000] KERNEL supported cpus:
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   Intel GenuineIntel
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   AMD AuthenticAMD
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   Centaur CentaurHauls
Oct 30 09:59:18 rechenplan kernel: [    0.000000] BIOS-provided
physical RAM map:
Oct 30 09:59:18 rechenplan kernel: [    0.000000]  BIOS-e820:
0000000000000000 - 000000000009f800 (usable)
Oct 30 09:59:18 rechenplan kernel: [    0.000000]  BIOS-e820:
000000000009f800 - 00000000000a0000 (reserved)
Oct 30 09:59:18 rechenplan kernel: [    0.000000]  BIOS-e820:
00000000000f0000 - 0000000000100000 (reserved)
Oct 30 09:59:18 rechenplan kernel: [    0.000000]  BIOS-e820:
0000000000100000 - 0000000077de0000 (usable)
Oct 30 09:59:18 rechenplan kernel: [    0.000000]  BIOS-e820:
0000000077de0000 - 0000000077de3000 (ACPI NVS)
Oct 30 09:59:18 rechenplan kernel: [    0.000000]  BIOS-e820:
0000000077de3000 - 0000000077df0000 (ACPI data)
Oct 30 09:59:18 rechenplan kernel: [    0.000000]  BIOS-e820:
0000000077df0000 - 0000000077e00000 (reserved)
Oct 30 09:59:18 rechenplan kernel: [    0.000000]  BIOS-e820:
00000000e0000000 - 00000000f0000000 (reserved)
Oct 30 09:59:18 rechenplan kernel: [    0.000000]  BIOS-e820:
00000000fec00000 - 0000000100000000 (reserved)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] last_pfn = 0x77de0
max_arch_pfn = 0x3ffffffff
Oct 30 09:59:18 rechenplan kernel: [    0.000000] init_memory_mapping
Oct 30 09:59:18 rechenplan kernel: [    0.000000]  0000000000 -
0077c00000 page 2M
Oct 30 09:59:18 rechenplan kernel: [    0.000000]  0077c00000 -
0077de0000 page 4k
Oct 30 09:59:18 rechenplan kernel: [    0.000000] kernel direct
mapping tables up to 77de0000 @ 8000-c000
Oct 30 09:59:18 rechenplan kernel: [    0.000000] last_map_addr:
77de0000 end: 77de0000
Oct 30 09:59:18 rechenplan kernel: [    0.000000] RAMDISK: 3771b000 - 37fef549
Oct 30 09:59:18 rechenplan kernel: [    0.000000] DMI 2.4 present.
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: RSDP 000F71C0,
0014 (r0 GBT   )
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: RSDT 77DE3000,
0038 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: FACP 77DE3040,
0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: DSDT 77DE30C0,
6550 (r1 GBT    GBTUACPI     1000 MSFT  3000000)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: FACS 77DE0000, 0040
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: SSDT 77DE9700,
0544 (r1 PTLTD  POWERNOW        1  LTP        1)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: HPET 77DE9C80,
0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: MCFG 77DE9CC0,
003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: APIC 77DE9640,
0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Scanning NUMA
topology in Northbridge 24
Oct 30 09:59:18 rechenplan kernel: [    0.000000] No NUMA configuration found
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Faking a node at
0000000000000000-0000000077de0000
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Bootmem setup node 0
0000000000000000-0000000077de0000
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   NODE_DATA
[0000000000001000 - 0000000000005fff]
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   bootmap
[000000000000a000 -  0000000000018fbf] pages f
Oct 30 09:59:18 rechenplan kernel: [    0.000000] (6 early
reservations) ==> bootmem [0000000000 - 0077de0000]
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   #0 [0000000000 -
0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   #1 [0000006000 -
0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   #2 [0000200000 -
00008b8f9c]    TEXT DATA BSS ==> [0000200000 - 00008b8f9c]
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   #3 [003771b000 -
0037fef549]          RAMDISK ==> [003771b000 - 0037fef549]
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   #4 [000009f800 -
0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   #5 [0000008000 -
000000a000]          PGTABLE ==> [0000008000 - 000000a000]
Oct 30 09:59:18 rechenplan kernel: [    0.000000] found SMP MP-table
at [ffff8800000f5840] 000f5840
Oct 30 09:59:18 rechenplan kernel: [    0.000000]
[ffffe20000000000-ffffe20001dfffff] PMD ->
[ffff880001200000-ffff880002ffffff] on node 0
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Zone PFN ranges:
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   DMA
0x00000000 -> 0x00001000
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   DMA32
0x00001000 -> 0x00100000
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   Normal
0x00100000 -> 0x00100000
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Movable zone start
PFN for each node
Oct 30 09:59:18 rechenplan kernel: [    0.000000] early_node_map[2]
active PFN ranges
Oct 30 09:59:18 rechenplan kernel: [    0.000000]     0: 0x00000000 ->
0x0000009f
Oct 30 09:59:18 rechenplan kernel: [    0.000000]     0: 0x00000100 ->
0x00077de0
Oct 30 09:59:18 rechenplan kernel: [    0.000000] On node 0 totalpages: 490879
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   DMA zone: 2112
pages, LIFO batch:0
Oct 30 09:59:18 rechenplan kernel: [    0.000000]   DMA32 zone: 479272
pages, LIFO batch:31
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x00] lapic_id[0x00] enabled)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x01] lapic_id[0x01] enabled)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x02] lapic_id[0x02] enabled)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x03] lapic_id[0x03] enabled)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x00] dfl dfl lint[0x1])
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x01] dfl dfl lint[0x1])
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x02] dfl dfl lint[0x1])
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x03] dfl dfl lint[0x1])
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: IOAPIC
(id[0x02] address[0xfec00000] gsi_base[0])
Oct 30 09:59:18 rechenplan kernel: [    0.000000] IOAPIC[0]: apic_id
2, version 0, address 0xfec00000, GSI 0-23
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 0 global_irq 2 dfl dfl)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 9 global_irq 9 low level)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: IRQ0 used by override.
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: IRQ2 used by override.
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: IRQ9 used by override.
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Setting APIC routing to flat
Oct 30 09:59:18 rechenplan kernel: [    0.000000] ACPI: HPET id:
0x10b9a201 base: 0xfed00000
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Using ACPI (MADT)
for SMP configuration information
Oct 30 09:59:18 rechenplan kernel: [    0.000000] SMP: Allowing 4
CPUs, 0 hotplug CPUs
Oct 30 09:59:18 rechenplan kernel: [    0.000000] PM: Registered
nosave memory: 000000000009f000 - 00000000000a0000
Oct 30 09:59:18 rechenplan kernel: [    0.000000] PM: Registered
nosave memory: 00000000000a0000 - 00000000000f0000
Oct 30 09:59:18 rechenplan kernel: [    0.000000] PM: Registered
nosave memory: 00000000000f0000 - 0000000000100000
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Allocating PCI
resources starting at 78000000 (gap: 77e00000:68200000)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] PERCPU: Allocating
64928 bytes of per cpu data
Oct 30 09:59:18 rechenplan kernel: [    0.000000] NR_CPUS: 64,
nr_cpu_ids: 4, nr_node_ids 1
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Built 1 zonelists in
Node order, mobility grouping on.  Total pages: 481384
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Policy zone: DMA32
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Kernel command line:
root=/dev/md0 ro
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Initializing CPU#0
Oct 30 09:59:18 rechenplan kernel: [    0.000000] PID hash table
entries: 4096 (order: 12, 32768 bytes)
Oct 30 09:59:18 rechenplan kernel: [    0.000000] TSC: PIT calibration
confirmed by PMTIMER.
Oct 30 09:59:18 rechenplan kernel: [    0.000000] TSC: using PMTIMER
calibration value
Oct 30 09:59:18 rechenplan kernel: [    0.000000] Detected 2004.258
MHz processor.
Oct 30 09:59:18 rechenplan kernel: [    0.004000] Console: colour VGA+ 80x25
Oct 30 09:59:18 rechenplan kernel: [    0.004000] console [tty0] enabled
Oct 30 09:59:18 rechenplan kernel: [    0.004000] Checking aperture...
Oct 30 09:59:18 rechenplan kernel: [    0.004000] No AGP bridge found
Oct 30 09:59:18 rechenplan kernel: [    0.004000] Node 0: aperture @
5086000000 size 32 MB
Oct 30 09:59:18 rechenplan kernel: [    0.004000] Aperture beyond 4GB. Ignoring.
Oct 30 09:59:18 rechenplan kernel: [    0.004000] Memory:
1916440k/1963904k available (3112k kernel code, 47076k reserved, 1575k
data, 536k init)
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPA: page pool
initialized 1 of 1 pages preallocated
Oct 30 09:59:18 rechenplan kernel: [    0.004000] SLUB: Genslabs=13,
HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Oct 30 09:59:18 rechenplan kernel: [    0.004000] hpet clockevent registered
Oct 30 09:59:18 rechenplan kernel: [    0.004007] Calibrating delay
loop (skipped), value calculated using timer frequency.. 4008.51
BogoMIPS (lpj=8017020)
Oct 30 09:59:18 rechenplan kernel: [    0.004092] Security Framework initialized
Oct 30 09:59:18 rechenplan kernel: [    0.004129] SELinux:  Disabled at boot.
Oct 30 09:59:18 rechenplan kernel: [    0.004172] AppArmor: AppArmor initialized
Oct 30 09:59:18 rechenplan kernel: [    0.004386] Dentry cache hash
table entries: 262144 (order: 9, 2097152 bytes)
Oct 30 09:59:18 rechenplan kernel: [    0.005237] Inode-cache hash
table entries: 131072 (order: 8, 1048576 bytes)
Oct 30 09:59:18 rechenplan kernel: [    0.005616] Mount-cache hash
table entries: 256
Oct 30 09:59:18 rechenplan kernel: [    0.005793] Initializing cgroup subsys ns
Oct 30 09:59:18 rechenplan kernel: [    0.005827] Initializing cgroup
subsys cpuacct
Oct 30 09:59:18 rechenplan kernel: [    0.005861] Initializing cgroup
subsys memory
Oct 30 09:59:18 rechenplan kernel: [    0.005905] CPU: L1 I Cache: 64K
(64 bytes/line), D cache 64K (64 bytes/line)
Oct 30 09:59:18 rechenplan kernel: [    0.005939] CPU: L2 Cache: 512K
(64 bytes/line)
Oct 30 09:59:18 rechenplan kernel: [    0.005973] CPU 0/0 -> Node 0
Oct 30 09:59:18 rechenplan kernel: [    0.006006] tseg: 0077e00000
Oct 30 09:59:18 rechenplan kernel: [    0.006008] CPU: Physical Processor ID: 0
Oct 30 09:59:18 rechenplan kernel: [    0.006040] CPU: Processor Core ID: 0
Oct 30 09:59:18 rechenplan kernel: [    0.006078] using C1E aware idle routine
Oct 30 09:59:18 rechenplan kernel: [    0.007533] ACPI: Core revision 20080609
Oct 30 09:59:18 rechenplan kernel: [    0.009676] ACPI: Checking
initramfs for custom DSDT
Oct 30 09:59:18 rechenplan kernel: [    0.356633] ..TIMER: vector=0x30
apic1=0 pin1=2 apic2=-1 pin2=-1
Oct 30 09:59:18 rechenplan kernel: [    0.397509] CPU0: AMD Phenom(tm)
9350e Quad-Core Processor stepping 03
Oct 30 09:59:18 rechenplan kernel: [    0.397600] Using local APIC
timer interrupts.
Oct 30 09:59:18 rechenplan kernel: [    0.400026] APIC timer
calibration result 12526611
Oct 30 09:59:18 rechenplan kernel: [    0.400028] Detected 12.526 MHz
APIC timer.
Oct 30 09:59:18 rechenplan kernel: [    0.400181] Booting processor 1/1 ip 6000
Oct 30 09:59:18 rechenplan kernel: [    0.004000] Initializing CPU#1
Oct 30 09:59:18 rechenplan kernel: [    0.004000] Calibrating delay
using timer specific routine.. 4008.74 BogoMIPS (lpj=8017489)
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: L1 I Cache: 64K
(64 bytes/line), D cache 64K (64 bytes/line)
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: L2 Cache: 512K
(64 bytes/line)
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU 1/1 -> Node 0
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: Physical Processor ID: 0
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: Processor Core ID: 2
Oct 30 09:59:18 rechenplan kernel: [    0.488398] CPU1: AMD Phenom(tm)
9350e Quad-Core Processor stepping 03
Oct 30 09:59:18 rechenplan kernel: [    0.488713] checking TSC
synchronization [CPU#0 -> CPU#1]: passed.
Oct 30 09:59:18 rechenplan kernel: [    0.492108] Booting processor 2/2 ip 6000
Oct 30 09:59:18 rechenplan kernel: [    0.004000] Initializing CPU#2
Oct 30 09:59:18 rechenplan kernel: [    0.004000] Calibrating delay
using timer specific routine.. 4008.62 BogoMIPS (lpj=8017247)
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: L1 I Cache: 64K
(64 bytes/line), D cache 64K (64 bytes/line)
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: L2 Cache: 512K
(64 bytes/line)
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU 2/2 -> Node 0
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: Physical Processor ID: 0
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: Processor Core ID: 1
Oct 30 09:59:18 rechenplan kernel: [    0.580406] CPU2: AMD Phenom(tm)
9350e Quad-Core Processor stepping 03
Oct 30 09:59:18 rechenplan kernel: [    0.580720] checking TSC
synchronization [CPU#0 -> CPU#2]: passed.
Oct 30 09:59:18 rechenplan kernel: [    0.584110] Booting processor 3/3 ip 6000
Oct 30 09:59:18 rechenplan kernel: [    0.004000] Initializing CPU#3
Oct 30 09:59:18 rechenplan kernel: [    0.004000] Calibrating delay
using timer specific routine.. 4008.63 BogoMIPS (lpj=8017277)
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: L1 I Cache: 64K
(64 bytes/line), D cache 64K (64 bytes/line)
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: L2 Cache: 512K
(64 bytes/line)
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU 3/3 -> Node 0
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: Physical Processor ID: 0
Oct 30 09:59:18 rechenplan kernel: [    0.004000] CPU: Processor Core ID: 3
Oct 30 09:59:18 rechenplan kernel: [    0.672418] CPU3: AMD Phenom(tm)
9350e Quad-Core Processor stepping 03
Oct 30 09:59:18 rechenplan kernel: [    0.672733] checking TSC
synchronization [CPU#0 -> CPU#3]: passed.
Oct 30 09:59:18 rechenplan kernel: [    0.676054] Brought up 4 CPUs
Oct 30 09:59:18 rechenplan kernel: [    0.676087] Total of 4
processors activated (16034.51 BogoMIPS).
Oct 30 09:59:18 rechenplan kernel: [    0.676207] CPU0 attaching sched-domain:
Oct 30 09:59:18 rechenplan kernel: [    0.676209]  domain 0: span 0-3 level CPU
Oct 30 09:59:18 rechenplan kernel: [    0.676211]   groups: 0 1 2 3
Oct 30 09:59:18 rechenplan kernel: [    0.676216]   domain 1: span 0-3
level NODE
Oct 30 09:59:18 rechenplan kernel: [    0.676218]    groups: 0-3
Oct 30 09:59:18 rechenplan kernel: [    0.676222] CPU1 attaching sched-domain:
Oct 30 09:59:18 rechenplan kernel: [    0.676224]  domain 0: span 0-3 level CPU
Oct 30 09:59:18 rechenplan kernel: [    0.676225]   groups: 1 2 3 0
Oct 30 09:59:18 rechenplan kernel: [    0.676229]   domain 1: span 0-3
level NODE
Oct 30 09:59:18 rechenplan kernel: [    0.676231]    groups: 0-3
Oct 30 09:59:18 rechenplan kernel: [    0.676234] CPU2 attaching sched-domain:
Oct 30 09:59:18 rechenplan kernel: [    0.676235]  domain 0: span 0-3 level CPU
Oct 30 09:59:18 rechenplan kernel: [    0.676237]   groups: 2 3 0 1
Oct 30 09:59:18 rechenplan kernel: [    0.676240]   domain 1: span 0-3
level NODE
Oct 30 09:59:18 rechenplan kernel: [    0.676241]    groups: 0-3
Oct 30 09:59:18 rechenplan kernel: [    0.676244] CPU3 attaching sched-domain:
Oct 30 09:59:18 rechenplan kernel: [    0.676246]  domain 0: span 0-3 level CPU
Oct 30 09:59:18 rechenplan kernel: [    0.676247]   groups: 3 0 1 2
Oct 30 09:59:18 rechenplan kernel: [    0.676250]   domain 1: span 0-3
level NODE
Oct 30 09:59:18 rechenplan kernel: [    0.676252]    groups: 0-3
Oct 30 09:59:18 rechenplan kernel: [    0.676376] net_namespace: 1552 bytes
Oct 30 09:59:18 rechenplan kernel: [    0.676376] Booting
paravirtualized kernel on bare hardware
Oct 30 09:59:18 rechenplan kernel: [    0.676376] Time:  9:58:44  Date: 10/30/08
Oct 30 09:59:18 rechenplan kernel: [    0.676425] NET: Registered
protocol family 16
Oct 30 09:59:18 rechenplan kernel: [    0.676475] node 0 link 0: io
port [c000, ffff]
Oct 30 09:59:18 rechenplan kernel: [    0.676475] TOM:
0000000080000000 aka 2048M
Oct 30 09:59:18 rechenplan kernel: [    0.676475] Fam 10h mmconf
[e0000000, e00fffff]
Oct 30 09:59:18 rechenplan kernel: [    0.676475] node 0 link 0: mmio
[a0000, bffff]
Oct 30 09:59:18 rechenplan kernel: [    0.676475] node 0 link 0: mmio
[80000000, fe02ffff] ==> [80000000, dfffffff] and [e0100000, fe02ffff]
Oct 30 09:59:18 rechenplan kernel: [    0.676475] node 0 link 0: mmio
[e0000000, efffffff] ==> [e0100000, efffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.676475] bus: [00,03] on node 0 link 0
Oct 30 09:59:18 rechenplan kernel: [    0.676475] bus: 00 index 0 io
port: [0, ffff]
Oct 30 09:59:18 rechenplan kernel: [    0.676475] bus: 00 index 1
mmio: [a0000, bffff]
Oct 30 09:59:18 rechenplan kernel: [    0.676475] bus: 00 index 2
mmio: [80000000, dfffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.676475] bus: 00 index 3
mmio: [e0100000, fcffffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.676475] ACPI: bus type pci registered
Oct 30 09:59:18 rechenplan kernel: [    0.676475] PCI: MCFG
configuration 0: base e0000000 segment 0 buses 0 - 255
Oct 30 09:59:18 rechenplan kernel: [    0.676475] PCI: MCFG area at
e0000000 reserved in E820
Oct 30 09:59:18 rechenplan kernel: [    0.690506] PCI: Using MMCONFIG
at e0000000 - efffffff
Oct 30 09:59:18 rechenplan kernel: [    0.690540] PCI: Using
configuration type 1 for base access
Oct 30 09:59:18 rechenplan kernel: [    0.692355] ACPI: EC: Look up EC in DSDT
Oct 30 09:59:18 rechenplan kernel: [    0.702136] ACPI: Interpreter enabled
Oct 30 09:59:18 rechenplan kernel: [    0.702175] ACPI: (supports S0 S3 S4 S5)
Oct 30 09:59:18 rechenplan kernel: [    0.702334] ACPI: Using IOAPIC
for interrupt routing
Oct 30 09:59:18 rechenplan kernel: [    0.708374] ACPI: PCI Root
Bridge [PCI0] (0000:00)
Oct 30 09:59:18 rechenplan kernel: [    0.708374] PCI: 0000:00:00.0
reg 1c 64bit mmio: [e0000000, ffffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.708374] pci 0000:00:0a.0:
PME# supported from D0 D3hot D3cold
Oct 30 09:59:18 rechenplan kernel: [    0.708374] pci 0000:00:0a.0:
PME# disabled
Oct 30 09:59:18 rechenplan kernel: [    0.708374] PCI: 0000:00:11.0
reg 10 io port: [ff00, ff07]
Oct 30 09:59:18 rechenplan kernel: [    0.708374] PCI: 0000:00:11.0
reg 14 io port: [fe00, fe03]
Oct 30 09:59:18 rechenplan kernel: [    0.708374] PCI: 0000:00:11.0
reg 18 io port: [fd00, fd07]
Oct 30 09:59:18 rechenplan kernel: [    0.708374] PCI: 0000:00:11.0
reg 1c io port: [fc00, fc03]
Oct 30 09:59:18 rechenplan kernel: [    0.708374] PCI: 0000:00:11.0
reg 20 io port: [fb00, fb0f]
Oct 30 09:59:18 rechenplan kernel: [    0.708374] PCI: 0000:00:11.0
reg 24 32bit mmio: [fe02f000, fe02f3ff]
Oct 30 09:59:18 rechenplan kernel: [    0.708374] PCI: 0000:00:12.0
reg 10 32bit mmio: [fe02e000, fe02efff]
Oct 30 09:59:18 rechenplan kernel: [    0.708374] PCI: 0000:00:12.1
reg 10 32bit mmio: [fe02d000, fe02dfff]
Oct 30 09:59:18 rechenplan kernel: [    0.708441] PCI: 0000:00:12.2
reg 10 32bit mmio: [fe02c000, fe02c0ff]
Oct 30 09:59:18 rechenplan kernel: [    0.708485] pci 0000:00:12.2: supports D1
Oct 30 09:59:18 rechenplan kernel: [    0.708487] pci 0000:00:12.2: supports D2
Oct 30 09:59:18 rechenplan kernel: [    0.708488] pci 0000:00:12.2:
PME# supported from D0 D1 D2 D3hot
Oct 30 09:59:18 rechenplan kernel: [    0.708524] pci 0000:00:12.2:
PME# disabled
Oct 30 09:59:18 rechenplan kernel: [    0.708578] PCI: 0000:00:13.0
reg 10 32bit mmio: [fe02b000, fe02bfff]
Oct 30 09:59:18 rechenplan kernel: [    0.708628] PCI: 0000:00:13.1
reg 10 32bit mmio: [fe02a000, fe02afff]
Oct 30 09:59:18 rechenplan kernel: [    0.708700] PCI: 0000:00:13.2
reg 10 32bit mmio: [fe029000, fe0290ff]
Oct 30 09:59:18 rechenplan kernel: [    0.708744] pci 0000:00:13.2: supports D1
Oct 30 09:59:18 rechenplan kernel: [    0.708746] pci 0000:00:13.2: supports D2
Oct 30 09:59:18 rechenplan kernel: [    0.708747] pci 0000:00:13.2:
PME# supported from D0 D1 D2 D3hot
Oct 30 09:59:18 rechenplan kernel: [    0.708783] pci 0000:00:13.2:
PME# disabled
Oct 30 09:59:18 rechenplan kernel: [    0.708915] PCI: 0000:00:14.1
reg 10 io port: [0, 7]
Oct 30 09:59:18 rechenplan kernel: [    0.708921] PCI: 0000:00:14.1
reg 14 io port: [0, 3]
Oct 30 09:59:18 rechenplan kernel: [    0.708927] PCI: 0000:00:14.1
reg 18 io port: [0, 7]
Oct 30 09:59:18 rechenplan kernel: [    0.708934] PCI: 0000:00:14.1
reg 1c io port: [0, 3]
Oct 30 09:59:18 rechenplan kernel: [    0.708940] PCI: 0000:00:14.1
reg 20 io port: [fa00, fa0f]
Oct 30 09:59:18 rechenplan kernel: [    0.709054] PCI: 0000:00:14.5
reg 10 32bit mmio: [fe028000, fe028fff]
Oct 30 09:59:18 rechenplan kernel: [    0.709185] PCI: 0000:01:05.0
reg 10 32bit mmio: [d8000000, dfffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709189] PCI: 0000:01:05.0
reg 14 io port: [ee00, eeff]
Oct 30 09:59:18 rechenplan kernel: [    0.709192] PCI: 0000:01:05.0
reg 18 32bit mmio: [fdee0000, fdeeffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709199] PCI: 0000:01:05.0
reg 24 32bit mmio: [fdd00000, fddfffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709208] pci 0000:01:05.0: supports D1
Oct 30 09:59:18 rechenplan kernel: [    0.709209] pci 0000:01:05.0: supports D2
Oct 30 09:59:18 rechenplan kernel: [    0.709223] PCI: 0000:01:05.1
reg 10 32bit mmio: [fdefc000, fdefffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709240] pci 0000:01:05.1: supports D1
Oct 30 09:59:18 rechenplan kernel: [    0.709241] pci 0000:01:05.1: supports D2
Oct 30 09:59:18 rechenplan kernel: [    0.709278] PCI: bridge
0000:00:01.0 io port: [e000, efff]
Oct 30 09:59:18 rechenplan kernel: [    0.709281] PCI: bridge
0000:00:01.0 32bit mmio: [fdd00000, fdefffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709285] PCI: bridge
0000:00:01.0 64bit mmio pref: [d8000000, dfffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709317] PCI: 0000:02:00.0
reg 10 io port: [de00, deff]
Oct 30 09:59:18 rechenplan kernel: [    0.709327] PCI: 0000:02:00.0
reg 18 32bit mmio: [fdfff000, fdffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709338] PCI: 0000:02:00.0
reg 20 32bit mmio: [fdfe0000, fdfeffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709348] PCI: 0000:02:00.0
reg 30 32bit mmio: [0, ffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709369] pci 0000:02:00.0: supports D1
Oct 30 09:59:18 rechenplan kernel: [    0.709370] pci 0000:02:00.0: supports D2
Oct 30 09:59:18 rechenplan kernel: [    0.709371] pci 0000:02:00.0:
PME# supported from D0 D1 D2 D3hot D3cold
Oct 30 09:59:18 rechenplan kernel: [    0.709407] pci 0000:02:00.0:
PME# disabled
Oct 30 09:59:18 rechenplan kernel: [    0.709478] PCI: bridge
0000:00:0a.0 io port: [d000, dfff]
Oct 30 09:59:18 rechenplan kernel: [    0.709481] PCI: bridge
0000:00:0a.0 32bit mmio: [fda00000, fdafffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709484] PCI: bridge
0000:00:0a.0 64bit mmio pref: [fdf00000, fdffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709535] PCI: 0000:03:07.0
reg 10 io port: [cf00, cf1f]
Oct 30 09:59:18 rechenplan kernel: [    0.709543] PCI: 0000:03:07.0
reg 14 io port: [ce00, ce7f]
Oct 30 09:59:18 rechenplan kernel: [    0.709592] pci 0000:03:07.0: supports D2
Oct 30 09:59:18 rechenplan kernel: [    0.709630] pci 0000:00:14.4:
transparent bridge
Oct 30 09:59:18 rechenplan kernel: [    0.709665] PCI: bridge
0000:00:14.4 io port: [c000, cfff]
Oct 30 09:59:18 rechenplan kernel: [    0.709669] PCI: bridge
0000:00:14.4 32bit mmio: [fdc00000, fdcfffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709673] PCI: bridge
0000:00:14.4 32bit mmio pref: [fdb00000, fdbfffff]
Oct 30 09:59:18 rechenplan kernel: [    0.709689] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0._PRT]
Oct 30 09:59:18 rechenplan kernel: [    0.710205] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.P2P_._PRT]
Oct 30 09:59:18 rechenplan kernel: [    0.710404] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.PCEA._PRT]
Oct 30 09:59:18 rechenplan kernel: [    0.710538] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.AGP_._PRT]
Oct 30 09:59:18 rechenplan kernel: [    0.741546] ACPI: PCI Interrupt
Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 09:59:18 rechenplan kernel: [    0.741546] ACPI: PCI Interrupt
Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 09:59:18 rechenplan kernel: [    0.741546] ACPI: PCI Interrupt
Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 09:59:18 rechenplan kernel: [    0.744400] ACPI: PCI Interrupt
Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 09:59:18 rechenplan kernel: [    0.744887] ACPI: PCI Interrupt
Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 09:59:18 rechenplan kernel: [    0.745380] ACPI: PCI Interrupt
Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 09:59:18 rechenplan kernel: [    0.746354] ACPI: PCI Interrupt
Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 09:59:18 rechenplan kernel: [    0.746845] ACPI: PCI Interrupt
Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct 30 09:59:18 rechenplan kernel: [    0.747256] Linux Plug and Play
Support v0.97 (c) Adam Belay
Oct 30 09:59:18 rechenplan kernel: [    0.747256] pnp: PnP ACPI init
Oct 30 09:59:18 rechenplan kernel: [    0.747256] ACPI: bus type pnp registered
Oct 30 09:59:18 rechenplan kernel: [    0.749043] pnp 00:09: mem
resource (0xe0000000-0xefffffff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
Oct 30 09:59:18 rechenplan kernel: [    0.749043] pnp 00:0a: mem
resource (0xffff0000-0xffffffff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
Oct 30 09:59:18 rechenplan kernel: [    0.749043] pnp 00:0a: mem
resource (0xfec00000-0xfec00fff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
Oct 30 09:59:18 rechenplan kernel: [    0.749043] pnp 00:0a: mem
resource (0xfee00000-0xfee00fff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
Oct 30 09:59:18 rechenplan kernel: [    0.749043] pnp 00:0a: mem
resource (0xfff80000-0xfffeffff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
Oct 30 09:59:18 rechenplan kernel: [    0.749043] pnp: PnP ACPI: found
11 devices
Oct 30 09:59:18 rechenplan kernel: [    0.749043] ACPI: ACPI bus type
pnp unregistered
Oct 30 09:59:18 rechenplan kernel: [    0.749043] PCI: Using ACPI for
IRQ routing
Oct 30 09:59:18 rechenplan kernel: [    0.749043] pci 0000:00:00.0:
BAR 3: can't allocate resource
Oct 30 09:59:18 rechenplan kernel: [    0.768040] NET: Registered
protocol family 8
Oct 30 09:59:18 rechenplan kernel: [    0.768073] NET: Registered
protocol family 20
Oct 30 09:59:18 rechenplan kernel: [    0.768117] NetLabel: Initializing
Oct 30 09:59:18 rechenplan kernel: [    0.768117] NetLabel:  domain
hash size = 128
Oct 30 09:59:18 rechenplan kernel: [    0.768117] NetLabel:  protocols
= UNLABELED CIPSOv4
Oct 30 09:59:18 rechenplan kernel: [    0.768141] NetLabel:  unlabeled
traffic allowed by default
Oct 30 09:59:18 rechenplan kernel: [    0.768236] hpet0: at MMIO
0xfed00000, IRQs 2, 8, 0, 0
Oct 30 09:59:18 rechenplan kernel: [    0.768310] hpet0: 4 32-bit
timers, 14318180 Hz
Oct 30 09:59:18 rechenplan kernel: [    0.772041] Switched to high
resolution mode on CPU 0
Oct 30 09:59:18 rechenplan kernel: [    0.772754] tracer: 1286 pages
allocated for 65536 entries of 80 bytes
Oct 30 09:59:18 rechenplan kernel: [    0.772788]    actual entries 65586
Oct 30 09:59:18 rechenplan kernel: [    0.772804] Switched to high
resolution mode on CPU 1
Oct 30 09:59:18 rechenplan kernel: [    0.772812] Switched to high
resolution mode on CPU 2
Oct 30 09:59:18 rechenplan kernel: [    0.772824] Switched to high
resolution mode on CPU 3
Oct 30 09:59:18 rechenplan kernel: [    0.772910] AppArmor: AppArmor
Filesystem Enabled
Oct 30 09:59:18 rechenplan kernel: [    0.772961] ACPI: RTC can wake from S4
Oct 30 09:59:18 rechenplan kernel: [    0.792020] system 00:01: ioport
range 0x4d0-0x4d1 has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792055] system 00:01: ioport
range 0x220-0x225 has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792089] system 00:01: ioport
range 0x290-0x294 has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792125] system 00:02: ioport
range 0x4100-0x411f has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792160] system 00:02: ioport
range 0x228-0x22f has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792194] system 00:02: ioport
range 0x238-0x23f has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792228] system 00:02: ioport
range 0x40b-0x40b has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792262] system 00:02: ioport
range 0x4d6-0x4d6 has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792296] system 00:02: ioport
range 0xc00-0xc01 has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792330] system 00:02: ioport
range 0xc14-0xc14 has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792364] system 00:02: ioport
range 0xc50-0xc52 has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792398] system 00:02: ioport
range 0xc6c-0xc6d has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792432] system 00:02: ioport
range 0xc6f-0xc6f has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792466] system 00:02: ioport
range 0xcd0-0xcd1 has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792500] system 00:02: ioport
range 0xcd2-0xcd3 has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792534] system 00:02: ioport
range 0xcd4-0xcdf has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792567] system 00:02: ioport
range 0x4000-0x40fe has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792601] system 00:02: ioport
range 0x4210-0x4217 has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792636] system 00:02: ioport
range 0xb00-0xb0f has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792670] system 00:02: ioport
range 0xb10-0xb1f has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792704] system 00:02: ioport
range 0xb20-0xb3f has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792751] system 00:0a: iomem
range 0xd1a00-0xd3fff has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792785] system 00:0a: iomem
range 0xf0000-0xf7fff could not be reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792820] system 00:0a: iomem
range 0xf8000-0xfbfff could not be reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792854] system 00:0a: iomem
range 0xfc000-0xfffff could not be reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792888] system 00:0a: iomem
range 0x77de0000-0x77dfffff could not be reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792925] system 00:0a: iomem
range 0x0-0x9ffff could not be reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792959] system 00:0a: iomem
range 0x100000-0x77ddffff could not be reserved
Oct 30 09:59:18 rechenplan kernel: [    0.792996] system 00:0a: iomem
range 0x77ef0000-0x7feeffff has been reserved
Oct 30 09:59:18 rechenplan kernel: [    0.798143] pci 0000:00:01.0:
PCI bridge, secondary bus 0000:01
Oct 30 09:59:18 rechenplan kernel: [    0.798178] pci 0000:00:01.0:
IO window: 0xe000-0xefff
Oct 30 09:59:18 rechenplan kernel: [    0.798213] pci 0000:00:01.0:
MEM window: 0xfdd00000-0xfdefffff
Oct 30 09:59:18 rechenplan kernel: [    0.798247] pci 0000:00:01.0:
PREFETCH window: 0x000000d8000000-0x000000dfffffff
Oct 30 09:59:18 rechenplan kernel: [    0.798287] pci 0000:00:0a.0:
PCI bridge, secondary bus 0000:02
Oct 30 09:59:18 rechenplan kernel: [    0.798321] pci 0000:00:0a.0:
IO window: 0xd000-0xdfff
Oct 30 09:59:18 rechenplan kernel: [    0.798355] pci 0000:00:0a.0:
MEM window: 0xfda00000-0xfdafffff
Oct 30 09:59:18 rechenplan kernel: [    0.798390] pci 0000:00:0a.0:
PREFETCH window: 0x000000fdf00000-0x000000fdffffff
Oct 30 09:59:18 rechenplan kernel: [    0.798428] pci 0000:00:14.4:
PCI bridge, secondary bus 0000:03
Oct 30 09:59:18 rechenplan kernel: [    0.798463] pci 0000:00:14.4:
IO window: 0xc000-0xcfff
Oct 30 09:59:18 rechenplan kernel: [    0.798500] pci 0000:00:14.4:
MEM window: 0xfdc00000-0xfdcfffff
Oct 30 09:59:18 rechenplan kernel: [    0.798536] pci 0000:00:14.4:
PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
Oct 30 09:59:18 rechenplan kernel: [    0.798591] pci 0000:00:0a.0:
PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct 30 09:59:18 rechenplan kernel: [    0.798626] pci 0000:00:0a.0:
setting latency timer to 64
Oct 30 09:59:18 rechenplan kernel: [    0.798633] bus: 00 index 0 io
port: [0, ffff]
Oct 30 09:59:18 rechenplan kernel: [    0.798666] bus: 00 index 1
mmio: [0, ffffffffffffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.798699] bus: 01 index 0 io
port: [e000, efff]
Oct 30 09:59:18 rechenplan kernel: [    0.798732] bus: 01 index 1
mmio: [fdd00000, fdefffff]
Oct 30 09:59:18 rechenplan kernel: [    0.798765] bus: 01 index 2
mmio: [d8000000, dfffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.798798] bus: 01 index 3 mmio: [0, 0]
Oct 30 09:59:18 rechenplan kernel: [    0.798831] bus: 02 index 0 io
port: [d000, dfff]
Oct 30 09:59:18 rechenplan kernel: [    0.798863] bus: 02 index 1
mmio: [fda00000, fdafffff]
Oct 30 09:59:18 rechenplan kernel: [    0.798896] bus: 02 index 2
mmio: [fdf00000, fdffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.798930] bus: 02 index 3 mmio: [0, 0]
Oct 30 09:59:18 rechenplan kernel: [    0.798962] bus: 03 index 0 io
port: [c000, cfff]
Oct 30 09:59:18 rechenplan kernel: [    0.798995] bus: 03 index 1
mmio: [fdc00000, fdcfffff]
Oct 30 09:59:18 rechenplan kernel: [    0.799028] bus: 03 index 2
mmio: [fdb00000, fdbfffff]
Oct 30 09:59:18 rechenplan kernel: [    0.799061] bus: 03 index 3 io
port: [0, ffff]
Oct 30 09:59:18 rechenplan kernel: [    0.799093] bus: 03 index 4
mmio: [0, ffffffffffffffff]
Oct 30 09:59:18 rechenplan kernel: [    0.799136] NET: Registered
protocol family 2
Oct 30 09:59:18 rechenplan kernel: [    0.840125] IP route cache hash
table entries: 65536 (order: 7, 524288 bytes)
Oct 30 09:59:18 rechenplan kernel: [    0.840941] TCP established hash
table entries: 262144 (order: 10, 4194304 bytes)
Oct 30 09:59:18 rechenplan kernel: [    0.842401] TCP bind hash table
entries: 65536 (order: 8, 1048576 bytes)
Oct 30 09:59:18 rechenplan kernel: [    0.842771] TCP: Hash tables
configured (established 262144 bind 65536)
Oct 30 09:59:18 rechenplan kernel: [    0.842806] TCP reno registered
Oct 30 09:59:18 rechenplan kernel: [    0.852108] NET: Registered
protocol family 1
Oct 30 09:59:18 rechenplan kernel: [    0.852256] checking if image is
initramfs... it is
Oct 30 09:59:18 rechenplan kernel: [    1.554403] Freeing initrd
memory: 9041k freed
Oct 30 09:59:18 rechenplan kernel: [    1.559325] audit: initializing
netlink socket (disabled)
Oct 30 09:59:18 rechenplan kernel: [    1.559371] type=2000
audit(1225360724.556:1): initialized
Oct 30 09:59:18 rechenplan kernel: [    1.564690] HugeTLB registered 2
MB page size, pre-allocated 0 pages
Oct 30 09:59:18 rechenplan kernel: [    1.567424] VFS: Disk quotas dquot_6.5.1
Oct 30 09:59:18 rechenplan kernel: [    1.567537] Dquot-cache hash
table entries: 512 (order 0, 4096 bytes)
Oct 30 09:59:18 rechenplan kernel: [    1.567672] msgmni has been set to 3760
Oct 30 09:59:18 rechenplan kernel: [    1.567832] io scheduler noop registered
Oct 30 09:59:18 rechenplan kernel: [    1.567865] io scheduler
anticipatory registered
Oct 30 09:59:18 rechenplan kernel: [    1.567898] io scheduler
deadline registered
Oct 30 09:59:18 rechenplan kernel: [    1.568063] io scheduler cfq
registered (default)
Oct 30 09:59:18 rechenplan kernel: [    1.708053] pci 0000:01:05.0:
Boot video device
Oct 30 09:59:18 rechenplan kernel: [    1.708194] pcieport-driver
0000:00:0a.0: setting latency timer to 64
Oct 30 09:59:18 rechenplan kernel: [    1.708215] pcieport-driver
0000:00:0a.0: found MSI capability
Oct 30 09:59:18 rechenplan kernel: [    1.708274] pci_express
0000:00:0a.0:pcie00: allocate port service
Oct 30 09:59:18 rechenplan kernel: [    1.744417] hpet_resources:
0xfed00000 is busy
Oct 30 09:59:18 rechenplan kernel: [    1.744487] Linux agpgart interface v0.103
Oct 30 09:59:18 rechenplan kernel: [    1.744526] Serial: 8250/16550
driver4 ports, IRQ sharing enabled
Oct 30 09:59:18 rechenplan kernel: [    1.746694] brd: module loaded
Oct 30 09:59:18 rechenplan kernel: [    1.746799] input: Macintosh
mouse button emulation as /devices/virtual/input/input0
Oct 30 09:59:18 rechenplan kernel: [    1.746949] PNP: PS/2 Controller
[PNP0303:PS2K] at 0x60,0x64 irq 1
Oct 30 09:59:18 rechenplan kernel: [    1.746983] PNP: PS/2 appears to
have AUX port disabled, if this is incorrect please boot with
i8042.nopnp
Oct 30 09:59:18 rechenplan kernel: [    1.747146] serio: i8042 KBD
port at 0x60,0x64 irq 1
Oct 30 09:59:18 rechenplan kernel: [    1.760135] mice: PS/2 mouse
device common for all mice
Oct 30 09:59:18 rechenplan kernel: [    1.760298] rtc_cmos 00:05: rtc
core: registered rtc_cmos as rtc0
Oct 30 09:59:18 rechenplan kernel: [    1.760361] rtc0: alarms up to
one month, hpet irqs
Oct 30 09:59:18 rechenplan kernel: [    1.760432] cpuidle: using governor ladder
Oct 30 09:59:18 rechenplan kernel: [    1.760466] cpuidle: using governor menu
Oct 30 09:59:18 rechenplan kernel: [    1.760876] TCP cubic registered
Oct 30 09:59:18 rechenplan kernel: [    1.761116] registered taskstats version 1
Oct 30 09:59:18 rechenplan kernel: [    1.761274]   Magic number: 12:674:981
Oct 30 09:59:18 rechenplan kernel: [    1.761314] tty ttyc8: hash matches
Oct 30 09:59:18 rechenplan kernel: [    1.761445] rtc_cmos 00:05:
setting system clock to 2008-10-30 09:58:45 UTC (1225360725)
Oct 30 09:59:18 rechenplan kernel: [    1.761482] BIOS EDD facility
v0.16 2004-Jun-25, 0 devices found
Oct 30 09:59:18 rechenplan kernel: [    1.761516] EDD information not available.
Oct 30 09:59:18 rechenplan kernel: [    1.761579] Freeing unused
kernel memory: 536k freed
Oct 30 09:59:18 rechenplan kernel: [    1.761807] Write protecting the
kernel read-only data: 4348k
Oct 30 09:59:18 rechenplan kernel: [    1.778231] input: AT Translated
Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
Oct 30 09:59:18 rechenplan kernel: [    1.854573] fuse init (API version 7.9)
Oct 30 09:59:18 rechenplan kernel: [    1.874605] processor
ACPI0007:00: registered as cooling_device0
Oct 30 09:59:18 rechenplan kernel: [    1.874704] processor
ACPI0007:01: registered as cooling_device1
Oct 30 09:59:18 rechenplan kernel: [    1.874796] processor
ACPI0007:02: registered as cooling_device2
Oct 30 09:59:18 rechenplan kernel: [    1.874889] processor
ACPI0007:03: registered as cooling_device3
Oct 30 09:59:18 rechenplan kernel: [    1.892667] md: linear
personality registered for level -1
Oct 30 09:59:18 rechenplan kernel: [    1.896718] md: multipath
personality registered for level -4
Oct 30 09:59:18 rechenplan kernel: [    1.900389] md: raid0
personality registered for level 0
Oct 30 09:59:18 rechenplan kernel: [    1.905358] md: raid1
personality registered for level 1
Oct 30 09:59:18 rechenplan kernel: [    1.908731] xor: automatically
using best checksumming function: generic_sse
Oct 30 09:59:18 rechenplan kernel: [    1.925004]    generic_sse:
8234.000 MB/sec
Oct 30 09:59:18 rechenplan kernel: [    1.925037] xor: using function:
generic_sse (8234.000 MB/sec)
Oct 30 09:59:18 rechenplan kernel: [    1.926305] async_tx: api
initialized (async)
Oct 30 09:59:18 rechenplan kernel: [    1.997011] raid6: int64x1   2098 MB/s
Oct 30 09:59:18 rechenplan kernel: [    2.065020] raid6: int64x2   2791 MB/s
Oct 30 09:59:18 rechenplan kernel: [    2.133032] raid6: int64x4   2409 MB/s
Oct 30 09:59:18 rechenplan kernel: [    2.201041] raid6: int64x8   1825 MB/s
Oct 30 09:59:18 rechenplan kernel: [    2.269012] raid6: sse2x1    2884 MB/s
Oct 30 09:59:18 rechenplan kernel: [    2.337002] raid6: sse2x2    4736 MB/s
Oct 30 09:59:18 rechenplan kernel: [    2.405005] raid6: sse2x4    5703 MB/s
Oct 30 09:59:18 rechenplan kernel: [    2.405037] raid6: using
algorithm sse2x4 (5703 MB/s)
Oct 30 09:59:18 rechenplan kernel: [    2.405072] md: raid6
personality registered for level 6
Oct 30 09:59:18 rechenplan kernel: [    2.405105] md: raid5
personality registered for level 5
Oct 30 09:59:18 rechenplan kernel: [    2.405138] md: raid4
personality registered for level 4
Oct 30 09:59:18 rechenplan kernel: [    2.425850] md: raid10
personality registered for level 10
Oct 30 09:59:18 rechenplan kernel: [    2.573052] r8169 Gigabit
Ethernet driver 2.3LK-NAPI loaded
Oct 30 09:59:18 rechenplan kernel: [    2.573108] r8169 0000:02:00.0:
PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct 30 09:59:18 rechenplan kernel: [    2.573158] r8169 0000:02:00.0:
setting latency timer to 64
Oct 30 09:59:18 rechenplan kernel: [    2.573452] eth0: RTL8168c/8111c
at 0xffffc2000032a000, 00:1f:d0:56:5e:a0, XID 3c4000c0 IRQ 2302
Oct 30 09:59:18 rechenplan kernel: [    2.589619] usbcore: registered
new interface driver usbfs
Oct 30 09:59:18 rechenplan kernel: [    2.589907] usbcore: registered
new interface driver hub
Oct 30 09:59:18 rechenplan kernel: [    2.589982] usbcore: registered
new device driver usb
Oct 30 09:59:18 rechenplan kernel: [    2.591081] No dock devices found.
Oct 30 09:59:18 rechenplan kernel: [    2.592723] ohci_hcd: 2006
August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Oct 30 09:59:18 rechenplan kernel: [    2.592761] ohci_hcd
0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 30 09:59:18 rechenplan kernel: [    2.592811] ohci_hcd
0000:00:12.0: OHCI Host Controller
Oct 30 09:59:18 rechenplan kernel: [    2.592890] ohci_hcd
0000:00:12.0: new USB bus registered, assigned bus number 1
Oct 30 09:59:18 rechenplan kernel: [    2.592958] ohci_hcd
0000:00:12.0: irq 16, io mem 0xfe02e000
Oct 30 09:59:18 rechenplan kernel: [    2.604234] SCSI subsystem initialized
Oct 30 09:59:18 rechenplan kernel: [    2.623793] libata version 3.00 loaded.
Oct 30 09:59:18 rechenplan kernel: [    2.652185] usb usb1:
configuration #1 chosen from 1 choice
Oct 30 09:59:18 rechenplan kernel: [    2.652247] hub 1-0:1.0: USB hub found
Oct 30 09:59:18 rechenplan kernel: [    2.652288] hub 1-0:1.0: 3 ports detected
Oct 30 09:59:18 rechenplan kernel: [    2.860253] ohci_hcd
0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 30 09:59:18 rechenplan kernel: [    2.860305] ohci_hcd
0000:00:12.1: OHCI Host Controller
Oct 30 09:59:18 rechenplan kernel: [    2.860364] ohci_hcd
0000:00:12.1: new USB bus registered, assigned bus number 2
Oct 30 09:59:18 rechenplan kernel: [    2.860417] ohci_hcd
0000:00:12.1: irq 16, io mem 0xfe02d000
Oct 30 09:59:18 rechenplan kernel: [    2.920193] usb usb2:
configuration #1 chosen from 1 choice
Oct 30 09:59:18 rechenplan kernel: [    2.920255] hub 2-0:1.0: USB hub found
Oct 30 09:59:18 rechenplan kernel: [    2.920296] hub 2-0:1.0: 3 ports detected
Oct 30 09:59:18 rechenplan kernel: [    3.000025] usb 1-2: new low
speed USB device using ohci_hcd and address 2
Oct 30 09:59:18 rechenplan kernel: [    3.030352] ohci_hcd
0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct 30 09:59:18 rechenplan kernel: [    3.030402] ohci_hcd
0000:00:13.0: OHCI Host Controller
Oct 30 09:59:18 rechenplan kernel: [    3.030457] ohci_hcd
0000:00:13.0: new USB bus registered, assigned bus number 3
Oct 30 09:59:18 rechenplan kernel: [    3.030523] ohci_hcd
0000:00:13.0: irq 18, io mem 0xfe02b000
Oct 30 09:59:18 rechenplan kernel: [    3.088082] usb usb3:
configuration #1 chosen from 1 choice
Oct 30 09:59:18 rechenplan kernel: [    3.088138] hub 3-0:1.0: USB hub found
Oct 30 09:59:18 rechenplan kernel: [    3.088177] hub 3-0:1.0: 3 ports detected
Oct 30 09:59:18 rechenplan kernel: [    3.173344] usb 1-2:
configuration #1 chosen from 1 choice
Oct 30 09:59:18 rechenplan kernel: [    3.188151] ahci 0000:00:11.0: version 3.0
Oct 30 09:59:18 rechenplan kernel: [    3.188169] ahci 0000:00:11.0:
PCI INT A -> GSI 22 (level, low) -> IRQ 22
Oct 30 09:59:18 rechenplan kernel: [    3.188349] ahci 0000:00:11.0:
AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
Oct 30 09:59:18 rechenplan kernel: [    3.188389] ahci 0000:00:11.0:
flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
Oct 30 09:59:18 rechenplan kernel: [    3.188834] scsi0 : ahci
Oct 30 09:59:18 rechenplan kernel: [    3.188967] scsi1 : ahci
Oct 30 09:59:18 rechenplan kernel: [    3.189056] scsi2 : ahci
Oct 30 09:59:18 rechenplan kernel: [    3.189155] scsi3 : ahci
Oct 30 09:59:18 rechenplan kernel: [    3.189249] scsi4 : ahci
Oct 30 09:59:18 rechenplan kernel: [    3.189348] scsi5 : ahci
Oct 30 09:59:18 rechenplan kernel: [    3.189499] ata1: SATA max
UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 2301
Oct 30 09:59:18 rechenplan kernel: [    3.189537] ata2: SATA max
UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 2301
Oct 30 09:59:18 rechenplan kernel: [    3.189575] ata3: SATA max
UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 2301
Oct 30 09:59:18 rechenplan kernel: [    3.189613] ata4: SATA max
UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 2301
Oct 30 09:59:18 rechenplan kernel: [    3.189651] ata5: SATA max
UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 2301
Oct 30 09:59:18 rechenplan kernel: [    3.189689] ata6: SATA max
UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 2301
Oct 30 09:59:18 rechenplan kernel: [    3.672022] ata1: softreset
failed (device not ready)
Oct 30 09:59:18 rechenplan kernel: [    3.672059] ata1: failed due to
HW bug, retry pmp=0
Oct 30 09:59:18 rechenplan kernel: [    3.836031] ata1: SATA link up
3.0 Gbps (SStatus 123 SControl 300)
Oct 30 09:59:18 rechenplan kernel: [    3.842397] ata1.00: ATA-7:
SAMSUNG HD642JJ, 1AA01112, max UDMA7
Oct 30 09:59:18 rechenplan kernel: [    3.842435] ata1.00: 1250263728
sectors, multi 0: LBA48 NCQ (depth 31/32)
Oct 30 09:59:18 rechenplan kernel: [    3.848862] ata1.00: configured
for UDMA/133
Oct 30 09:59:18 rechenplan kernel: [    4.184537] ata2: SATA link down
(SStatus 0 SControl 300)
Oct 30 09:59:18 rechenplan kernel: [    4.524032] ata3: SATA link down
(SStatus 0 SControl 300)
Oct 30 09:59:18 rechenplan kernel: [    4.860032] ata4: SATA link down
(SStatus 0 SControl 300)
Oct 30 09:59:18 rechenplan kernel: [    5.360019] ata5: softreset
failed (device not ready)
Oct 30 09:59:18 rechenplan kernel: [    5.360059] ata5: failed due to
HW bug, retry pmp=0
Oct 30 09:59:18 rechenplan kernel: [    5.524031] ata5: SATA link up
3.0 Gbps (SStatus 123 SControl 300)
Oct 30 09:59:18 rechenplan kernel: [    5.536698] ata5.00: HPA
unlocked: 1250261615 -> 1250263728, native 1250263728
Oct 30 09:59:18 rechenplan kernel: [    5.536739] ata5.00: ATA-7:
SAMSUNG HD642JJ, 1AA01112, max UDMA7
Oct 30 09:59:18 rechenplan kernel: [    5.536773] ata5.00: 1250263728
sectors, multi 0: LBA48 NCQ (depth 31/32)
Oct 30 09:59:18 rechenplan kernel: [    5.543194] ata5.00: configured
for UDMA/133
Oct 30 09:59:18 rechenplan kernel: [    5.876032] ata6: SATA link down
(SStatus 0 SControl 300)
Oct 30 09:59:18 rechenplan kernel: [    5.892616] scsi 0:0:0:0:
Direct-Access     ATA      SAMSUNG HD642JJ  1AA0 PQ: 0 ANSI: 5
Oct 30 09:59:18 rechenplan kernel: [    5.892768] scsi 4:0:0:0:
Direct-Access     ATA      SAMSUNG HD642JJ  1AA0 PQ: 0 ANSI: 5
Oct 30 09:59:18 rechenplan kernel: [    5.892886] ohci_hcd
0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct 30 09:59:18 rechenplan kernel: [    5.892930] ohci_hcd
0000:00:13.1: OHCI Host Controller
Oct 30 09:59:18 rechenplan kernel: [    5.892986] ohci_hcd
0000:00:13.1: new USB bus registered, assigned bus number 4
Oct 30 09:59:18 rechenplan kernel: [    5.893036] ohci_hcd
0000:00:13.1: irq 18, io mem 0xfe02a000
Oct 30 09:59:18 rechenplan kernel: [    5.952099] usb usb4:
configuration #1 chosen from 1 choice
Oct 30 09:59:18 rechenplan kernel: [    5.952155] hub 4-0:1.0: USB hub found
Oct 30 09:59:18 rechenplan kernel: [    5.952196] hub 4-0:1.0: 3 ports detected
Oct 30 09:59:18 rechenplan kernel: [    6.161400] ehci_hcd
0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Oct 30 09:59:18 rechenplan kernel: [    6.161447] ehci_hcd
0000:00:12.2: EHCI Host Controller
Oct 30 09:59:18 rechenplan kernel: [    6.161514] ehci_hcd
0000:00:12.2: new USB bus registered, assigned bus number 5
Oct 30 09:59:18 rechenplan kernel: [    6.161582] ehci_hcd
0000:00:12.2: debug port 1
Oct 30 09:59:18 rechenplan kernel: [    6.161636] ehci_hcd
0000:00:12.2: irq 17, io mem 0xfe02c000
Oct 30 09:59:18 rechenplan kernel: [    6.296026] usb 4-3: new low
speed USB device using ohci_hcd and address 2
Oct 30 09:59:18 rechenplan kernel: [    6.308022] ehci_hcd
0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Oct 30 09:59:18 rechenplan kernel: [    6.308163] usb usb5:
configuration #1 chosen from 1 choice
Oct 30 09:59:18 rechenplan kernel: [    6.308219] hub 5-0:1.0: USB hub found
Oct 30 09:59:18 rechenplan kernel: [    6.308256] hub 5-0:1.0: 6 ports detected
Oct 30 09:59:18 rechenplan kernel: [    6.492870] usb 4-3:
configuration #1 chosen from 1 choice
Oct 30 09:59:18 rechenplan kernel: [    6.497194] usb 1-2: USB
disconnect, address 2
Oct 30 09:59:18 rechenplan kernel: [    6.518562] ehci_hcd
0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct 30 09:59:18 rechenplan kernel: [    6.518605] ehci_hcd
0000:00:13.2: EHCI Host Controller
Oct 30 09:59:18 rechenplan kernel: [    6.518663] ehci_hcd
0000:00:13.2: new USB bus registered, assigned bus number 6
Oct 30 09:59:18 rechenplan kernel: [    6.518729] ehci_hcd
0000:00:13.2: debug port 1
Oct 30 09:59:18 rechenplan kernel: [    6.518782] ehci_hcd
0000:00:13.2: irq 19, io mem 0xfe029000
Oct 30 09:59:18 rechenplan kernel: [    6.529022] ehci_hcd
0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Oct 30 09:59:18 rechenplan kernel: [    6.529147] usb usb6:
configuration #1 chosen from 1 choice
Oct 30 09:59:18 rechenplan kernel: [    6.529207] hub 6-0:1.0: USB hub found
Oct 30 09:59:18 rechenplan kernel: [    6.529245] hub 6-0:1.0: 6 ports detected
Oct 30 09:59:18 rechenplan kernel: [    6.684049] usb 4-3: USB
disconnect, address 2
Oct 30 09:59:18 rechenplan kernel: [    6.736146] ohci_hcd
0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct 30 09:59:18 rechenplan kernel: [    6.736190] ohci_hcd
0000:00:14.5: OHCI Host Controller
Oct 30 09:59:18 rechenplan kernel: [    6.736247] ohci_hcd
0000:00:14.5: new USB bus registered, assigned bus number 7
Oct 30 09:59:18 rechenplan kernel: [    6.736297] ohci_hcd
0000:00:14.5: irq 18, io mem 0xfe028000
Oct 30 09:59:18 rechenplan kernel: [    6.796938] usb usb7:
configuration #1 chosen from 1 choice
Oct 30 09:59:18 rechenplan kernel: [    6.797747] hub 7-0:1.0: USB hub found
Oct 30 09:59:18 rechenplan kernel: [    6.797788] hub 7-0:1.0: 2 ports detected
Oct 30 09:59:18 rechenplan kernel: [    6.910877] pata_acpi
0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 30 09:59:18 rechenplan kernel: [    6.915107] scsi6 : pata_atiixp
Oct 30 09:59:18 rechenplan kernel: [    6.917366] scsi7 : pata_atiixp
Oct 30 09:59:18 rechenplan kernel: [    6.918629] ata7: PATA max
UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
Oct 30 09:59:18 rechenplan kernel: [    6.918664] ata8: PATA max
UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
Oct 30 09:59:18 rechenplan kernel: [    6.919126] scsi 0:0:0:0:
Attached scsi generic sg0 type 0
Oct 30 09:59:18 rechenplan kernel: [    6.919196] scsi 4:0:0:0:
Attached scsi generic sg1 type 0
Oct 30 09:59:18 rechenplan kernel: [    6.939979] Driver 'sd' needs
updating - please use bus_type methods
Oct 30 09:59:18 rechenplan kernel: [    6.940147] sd 0:0:0:0: [sda]
1250263728 512-byte hardware sectors (640135 MB)
Oct 30 09:59:18 rechenplan kernel: [    6.940198] sd 0:0:0:0: [sda]
Write Protect is off
Oct 30 09:59:18 rechenplan kernel: [    6.940233] sd 0:0:0:0: [sda]
Mode Sense: 00 3a 00 00
Oct 30 09:59:18 rechenplan kernel: [    6.940255] sd 0:0:0:0: [sda]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 30 09:59:18 rechenplan kernel: [    6.940348] sd 0:0:0:0: [sda]
1250263728 512-byte hardware sectors (640135 MB)
Oct 30 09:59:18 rechenplan kernel: [    6.940394] sd 0:0:0:0: [sda]
Write Protect is off
Oct 30 09:59:18 rechenplan kernel: [    6.940428] sd 0:0:0:0: [sda]
Mode Sense: 00 3a 00 00
Oct 30 09:59:18 rechenplan kernel: [    6.940448] sd 0:0:0:0: [sda]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 30 09:59:18 rechenplan kernel: [    6.940487]  sda: sda1 sda2
Oct 30 09:59:18 rechenplan kernel: [    6.944710] sd 0:0:0:0: [sda]
Attached SCSI disk
Oct 30 09:59:18 rechenplan kernel: [    6.944835] sd 4:0:0:0: [sdb]
1250263728 512-byte hardware sectors (640135 MB)
Oct 30 09:59:18 rechenplan kernel: [    6.944888] sd 4:0:0:0: [sdb]
Write Protect is off
Oct 30 09:59:18 rechenplan kernel: [    6.944923] sd 4:0:0:0: [sdb]
Mode Sense: 00 3a 00 00
Oct 30 09:59:18 rechenplan kernel: [    6.944947] sd 4:0:0:0: [sdb]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 30 09:59:18 rechenplan kernel: [    6.945035] sd 4:0:0:0: [sdb]
1250263728 512-byte hardware sectors (640135 MB)
Oct 30 09:59:18 rechenplan kernel: [    6.945083] sd 4:0:0:0: [sdb]
Write Protect is off
Oct 30 09:59:18 rechenplan kernel: [    6.945117] sd 4:0:0:0: [sdb]
Mode Sense: 00 3a 00 00
Oct 30 09:59:18 rechenplan kernel: [    6.945140] sd 4:0:0:0: [sdb]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 30 09:59:18 rechenplan kernel: [    6.945180]  sdb: sdb1 sdb2
Oct 30 09:59:18 rechenplan kernel: [    6.948684] sd 4:0:0:0: [sdb]
Attached SCSI disk
Oct 30 09:59:18 rechenplan kernel: [    7.080585] ata7.00: ATAPI:
TOSHIBA DVD-ROM SD-M1612, 1004, max UDMA/33
Oct 30 09:59:18 rechenplan kernel: [    7.096517] ata7.00: configured
for UDMA/33
Oct 30 09:59:18 rechenplan kernel: [    7.132023] usb 1-2: new low
speed USB device using ohci_hcd and address 3
Oct 30 09:59:18 rechenplan kernel: [    7.252103] isa bounce pool size: 16 pages
Oct 30 09:59:18 rechenplan kernel: [    7.257620] scsi 6:0:0:0: CD-ROM
           TOSHIBA  DVD-ROM SD-M1612 1004 PQ: 0 ANSI: 5
Oct 30 09:59:18 rechenplan kernel: [    7.257797] scsi 6:0:0:0:
Attached scsi generic sg2 type 5
Oct 30 09:59:18 rechenplan kernel: [    7.277127] Driver 'sr' needs
updating - please use bus_type methods
Oct 30 09:59:18 rechenplan kernel: [    7.284828] sr0: scsi3-mmc
drive: 48x/48x cd/rw xa/form2 cdda tray
Oct 30 09:59:18 rechenplan kernel: [    7.284868] Uniform CD-ROM
driver Revision: 3.20
Oct 30 09:59:18 rechenplan kernel: [    7.284995] sr 6:0:0:0: Attached
scsi CD-ROM sr0
Oct 30 09:59:18 rechenplan kernel: [    7.303440] usb 1-2:
configuration #1 chosen from 1 choice
Oct 30 09:59:18 rechenplan kernel: [    7.377208] md: md0 stopped.
Oct 30 09:59:18 rechenplan kernel: [    7.381827] md: bind<sdb2>
Oct 30 09:59:18 rechenplan kernel: [    7.394854] md: md0 stopped.
Oct 30 09:59:18 rechenplan kernel: [    7.394902] md: unbind<sdb2>
Oct 30 09:59:18 rechenplan kernel: [    7.416197] md: export_rdev(sdb2)
Oct 30 09:59:18 rechenplan kernel: [    7.418654] md: bind<sdb2>
Oct 30 09:59:18 rechenplan kernel: [    7.418821] md: bind<sda2>
Oct 30 09:59:18 rechenplan kernel: [    7.426029] raid1: raid set md0
active with 2 out of 2 mirrors
Oct 30 09:59:18 rechenplan kernel: [    7.568023] usb 4-3: new low
speed USB device using ohci_hcd and address 3
Oct 30 09:59:18 rechenplan kernel: [    7.749242] usb 4-3:
configuration #1 chosen from 1 choice
Oct 30 09:59:18 rechenplan kernel: [    7.753653] usbcore: registered
new interface driver hiddev
Oct 30 09:59:18 rechenplan kernel: [    7.758570] input: Logitech
USB-PS/2 Optical Mouse as
/devices/pci0000:00/0000:00:12.0/usb1/1-2/1-2:1.0/input/input2
Oct 30 09:59:18 rechenplan kernel: [    7.781627] input,hidraw0: USB
HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on
usb-0000:00:12.0-2
Oct 30 09:59:18 rechenplan kernel: [   17.796536]
/build/buildd/linux-2.6.27/drivers/hid/usbhid/hid-core.c:
usb_submit_urb(ctrl) failed
Oct 30 09:59:18 rechenplan kernel: [   17.797076] usbhid: timeout
initializing reports
Oct 30 09:59:18 rechenplan kernel: [   17.797169] input: Logitech
Logitech Attack 3 as
/devices/pci0000:00/0000:00:13.1/usb4/4-3/4-3:1.0/input/input3
Oct 30 09:59:18 rechenplan kernel: [   17.797274] input,hidraw1: USB
HID v1.10 Joystick [Logitech Logitech Attack 3] on usb-0000:00:13.1-3
Oct 30 09:59:18 rechenplan kernel: [   17.797437] usbcore: registered
new interface driver usbhid
Oct 30 09:59:18 rechenplan kernel: [   17.797472] usbhid: v2.6:USB HID
core driver
Oct 30 09:59:18 rechenplan kernel: [   17.862660] PM: Starting manual
resume from disk
Oct 30 09:59:18 rechenplan kernel: [   17.862696] PM: Resume from partition 8:17
Oct 30 09:59:18 rechenplan kernel: [   17.862698] PM: Checking
hibernation image.
Oct 30 09:59:18 rechenplan kernel: [   17.862817] PM: Resume from disk failed.
Oct 30 09:59:18 rechenplan kernel: [   17.871663] SGI XFS with ACLs,
security attributes, realtime, large block/inode numbers, no debug
enabled
Oct 30 09:59:18 rechenplan kernel: [   17.877140] SGI XFS Quota
Management subsystem
Oct 30 09:59:18 rechenplan kernel: [   17.947568] XFS mounting filesystem md0
Oct 30 09:59:18 rechenplan kernel: [   18.036737] Ending clean XFS
mount for filesystem: md0
Oct 30 09:59:18 rechenplan kernel: [   26.634365] udevd version 124 started
Oct 30 09:59:18 rechenplan kernel: [   27.055605] input: Power Button
(FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
Oct 30 09:59:18 rechenplan kernel: [   27.073535] ACPI: Power Button (FF) [PWRF]
Oct 30 09:59:18 rechenplan kernel: [   27.073666] input: Power Button
(CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
Oct 30 09:59:18 rechenplan kernel: [   27.105522] ACPI: Power Button (CM) [PWRB]
Oct 30 09:59:18 rechenplan kernel: [   27.170920] ACPI: WMI: Mapper loaded
Oct 30 09:59:18 rechenplan kernel: [   27.256025] ACPI: I/O resource
piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1
[0xb00-0xb0f]
Oct 30 09:59:18 rechenplan kernel: [   27.256068] ACPI: Device needs
an ACPI driver
Oct 30 09:59:18 rechenplan kernel: [   27.256107] piix4_smbus
0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
Oct 30 09:59:18 rechenplan kernel: [   27.288376] pci_hotplug: PCI Hot
Plug PCI Core version: 0.5
Oct 30 09:59:18 rechenplan kernel: [   27.302660] shpchp: HPC
vendor_id 1022 device_id 9602 ss_vid 0 ss_did 0
Oct 30 09:59:18 rechenplan kernel: [   27.302702] shpchp: shpc_init:
cannot reserve MMIO region
Oct 30 09:59:18 rechenplan kernel: [   27.302776] shpchp: Standard Hot
Plug PCI Controller Driver version: 0.4
Oct 30 09:59:18 rechenplan kernel: [   27.310265] input: PC Speaker as
/devices/platform/pcspkr/input/input6
Oct 30 09:59:18 rechenplan kernel: [   27.503835] fglrx: module
license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY'
taints kernel.
Oct 30 09:59:18 rechenplan kernel: [   27.524434] [fglrx] Maximum main
memory to use for locked dma buffers: 1759 MBytes.
Oct 30 09:59:18 rechenplan kernel: [   27.524538] [fglrx]   vendor:
1002 device: 9610 count: 1
Oct 30 09:59:18 rechenplan kernel: [   27.526761] [fglrx] ioport: bar
1, base 0xee00, size: 0x100
Oct 30 09:59:18 rechenplan kernel: [   27.526815] pci 0000:01:05.0:
PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct 30 09:59:18 rechenplan kernel: [   27.526852] pci 0000:01:05.0:
setting latency timer to 64
Oct 30 09:59:18 rechenplan kernel: [   27.528519] [fglrx] PAT is
enabled successfully!
Oct 30 09:59:18 rechenplan kernel: [   27.528591] [fglrx] module
loaded - fglrx 8.54.3 [Oct 10 2008] with 1 minors
Oct 30 09:59:18 rechenplan kernel: [   28.279472] ICE1724
0000:03:07.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Oct 30 09:59:18 rechenplan kernel: [   29.380356] Adding 979924k swap
on /dev/sdb1.  Priority:-1 extents:1 across:979924k
Oct 30 09:59:18 rechenplan kernel: [   30.017533] device-mapper:
uevent: version 1.0.3
Oct 30 09:59:18 rechenplan kernel: [   30.018371] device-mapper:
ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Oct 30 09:59:18 rechenplan kernel: [   30.807506] kjournald starting.
Commit interval 5 seconds
Oct 30 09:59:18 rechenplan kernel: [   30.807728] EXT3 FS on sda1,
internal journal
Oct 30 09:59:18 rechenplan kernel: [   30.807734] EXT3-fs: mounted
filesystem with ordered data mode.
Oct 30 09:59:18 rechenplan kernel: [   31.531932] type=1505
audit(1225357155.404:2): operation="profile_load"
name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=4422
Oct 30 09:59:18 rechenplan kernel: [   31.532103] type=1505
audit(1225357155.407:3): operation="profile_load"
name="/usr/sbin/cupsd" name2="default" pid=4422
Oct 30 09:59:18 rechenplan kernel: [   31.877829] ip_tables: (C)
2000-2006 Netfilter Core Team
Oct 30 09:59:18 rechenplan kernel: [   31.917731] r8169: eth0: link up
Oct 30 09:59:18 rechenplan kernel: [   31.917739] r8169: eth0: link up
Oct 30 09:59:18 rechenplan kernel: [   32.654387] NET: Registered
protocol family 10
Oct 30 09:59:18 rechenplan kernel: [   32.655034] lo: Disabled Privacy
Extensions
Oct 30 09:59:18 rechenplan kernel: [   32.974671] warning: `ntpd' uses
32-bit capabilities (legacy support in use)
Oct 30 09:59:18 rechenplan kernel: [   34.203212] powernow-k8: Found 1
AMD Phenom(tm) 9350e Quad-Core Processor processors (4 cpu cores)
(version 2.20.00)
Oct 30 09:59:18 rechenplan kernel: [   34.203745] powernow-k8:    0 :
pstate 0 (2000 MHz)
Oct 30 09:59:18 rechenplan kernel: [   34.203749] powernow-k8:    1 :
pstate 1 (1000 MHz)
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: Found user 'avahi' (UID
107) and group 'avahi' (GID 116).
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: Successfully dropped
root privileges.
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: avahi-daemon 0.6.23 starting up.
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: Successfully called chroot().
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: Successfully dropped
remaining capabilities.
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: No service file found
in /etc/avahi/services.
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: Joining mDNS multicast
group on interface eth0.IPv4 with address 192.168.1.14.
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: New relevant interface
eth0.IPv4 for mDNS.
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: Network interface
enumeration completed.
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: Registering new address
record for fe80::21f:d0ff:fe56:5ea0 on eth0.*.
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: Registering new address
record for 192.168.1.14 on eth0.IPv4.
Oct 30 09:59:18 rechenplan avahi-daemon[5278]: Registering HINFO
record with values 'X86_64'/'LINUX'.
Oct 30 09:59:19 rechenplan atieventsd[5318]: ATI External Events
Daemon started...
Oct 30 09:59:19 rechenplan atieventsd[5318]: Event daemon control
socket created
Oct 30 09:59:19 rechenplan acpid: client connected from 5318[0:0]
Oct 30 09:59:19 rechenplan atieventsd[5318]: acpid connection established
Oct 30 09:59:19 rechenplan kernel: [   35.806245] lp: driver loaded
but no devices found
Oct 30 09:59:19 rechenplan avahi-daemon[5278]: Server startup
complete. Host name is rechenplan.local. Local service cookie is
282689542.
Oct 30 09:59:19 rechenplan kernel: [   35.849742] ppdev: user-space
parallel port driver
Oct 30 09:59:21 rechenplan powernowd: PowerNow Daemon v1.00, (c)
2003-2008 John Clemens
Oct 30 09:59:21 rechenplan powernowd: Found 4 scalable units:  -- 1
'CPU' per scalable unit
Oct 30 09:59:21 rechenplan powernowd:   cpu0: 1000Mhz - 2000Mhz (6 steps)
Oct 30 09:59:21 rechenplan powernowd:   cpu1: 1000Mhz - 2000Mhz (6 steps)
Oct 30 09:59:21 rechenplan powernowd:   cpu2: 1000Mhz - 2000Mhz (6 steps)
Oct 30 09:59:21 rechenplan powernowd:   cpu3: 1000Mhz - 2000Mhz (6 steps)
Oct 30 09:59:27 rechenplan kernel: [   43.501520] eth0: no IPv6 routers present
Oct 30 09:59:28 rechenplan kernel: [   44.453547] tun: Universal
TUN/TAP device driver, 1.6
Oct 30 09:59:28 rechenplan kernel: [   44.453560] tun: (C) 1999-2004
Max Krasnyansky <maxk@qualcomm.com>
Oct 30 09:59:29 rechenplan acpid: client connected from 5891[109:119]
Oct 30 09:59:30 rechenplan bluetoothd[5939]: Bluetooth daemon
Oct 30 09:59:30 rechenplan kernel: [   46.216918] Bluetooth: Core ver 2.13
Oct 30 09:59:30 rechenplan kernel: [   46.218171] NET: Registered
protocol family 31
Oct 30 09:59:30 rechenplan kernel: [   46.218177] Bluetooth: HCI
device and connection manager initialized
Oct 30 09:59:30 rechenplan kernel: [   46.218182] Bluetooth: HCI
socket layer initialized
Oct 30 09:59:30 rechenplan bluetoothd[5939]: Starting SDP server
Oct 30 09:59:30 rechenplan kernel: [   46.236585] Bluetooth: L2CAP ver 2.11
Oct 30 09:59:30 rechenplan kernel: [   46.236598] Bluetooth: L2CAP
socket layer initialized
Oct 30 09:59:30 rechenplan kernel: [   46.285880] Bluetooth: SCO
(Voice Link) ver 0.6
Oct 30 09:59:30 rechenplan kernel: [   46.285889] Bluetooth: SCO
socket layer initialized
Oct 30 09:59:30 rechenplan bluetoothd[5939]: Starting experimental
netlink support
Oct 30 09:59:30 rechenplan bluetoothd[5939]: Failed to find Bluetooth
netlink family
Oct 30 09:59:30 rechenplan bluetoothd[5939]: Can't init plugin
/usr/lib/bluetooth/plugins/netlink.so
Oct 30 09:59:30 rechenplan kernel: [   46.312952] Bluetooth: BNEP
(Ethernet Emulation) ver 1.3
Oct 30 09:59:30 rechenplan kernel: [   46.312962] Bluetooth: BNEP
filters: protocol multicast
Oct 30 09:59:30 rechenplan kernel: [   46.366717] Bridge firewalling registered
Oct 30 09:59:30 rechenplan kernel: [   46.367092] pan0: Dropping
NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
Oct 30 09:59:30 rechenplan bluetoothd[5939]: bridge pan0 created
Oct 30 09:59:30 rechenplan kernel: [   46.609104] Bluetooth: RFCOMM
socket layer initialized
Oct 30 09:59:30 rechenplan kernel: [   46.609133] Bluetooth: RFCOMM
TTY layer initialized
Oct 30 09:59:30 rechenplan kernel: [   46.609136] Bluetooth: RFCOMM ver 1.10
Oct 30 09:59:30 rechenplan NetworkManager: <info>  starting...
Oct 30 09:59:30 rechenplan NetworkManager: <info>  eth0: driver is 'r8169'.
Oct 30 09:59:30 rechenplan NetworkManager: <info>  Found new Ethernet
device 'eth0'.
Oct 30 09:59:30 rechenplan NetworkManager: <info>  (eth0): exported as
/org/freedesktop/Hal/devices/net_00_1f_d0_56_5e_a0
Oct 30 09:59:30 rechenplan NetworkManager: <info>  Trying to start the
supplicant...
Oct 30 09:59:30 rechenplan NetworkManager: <info>  Trying to start the
system settings daemon...
Oct 30 09:59:30 rechenplan NetworkManager: <info>  (eth0): carrier now
ON (device state 1)
Oct 30 09:59:30 rechenplan nm-system-settings:    SCPlugin-Ifupdown: init!
Oct 30 09:59:30 rechenplan nm-system-settings:    SCPlugin-Ifupdown:
update_system_hostname
Oct 30 09:59:30 rechenplan nm-system-settings:    SCPluginIfupdown:
guessed connection type (eth0) = 802-3-ethernet
Oct 30 09:59:30 rechenplan nm-system-settings:    SCPlugin-Ifupdown:
update_connection_setting_from_if_block: name:eth0,
type:802-3-ethernet, autoconnect:0, id:Ifupdown (eth0), uuid:
681b428f-beaf-8932-0000-000000000000
Oct 30 09:59:30 rechenplan nm-system-settings:    SCPlugin-Ifupdown:
addresses count: 1
Oct 30 09:59:30 rechenplan nm-system-settings:    SCPlugin-Ifupdown: autoconnect
Oct 30 09:59:30 rechenplan nm-system-settings:    SCPluginIfupdown:
management mode: unmanaged
Oct 30 09:59:30 rechenplan nm-system-settings:    SCPlugin-Ifupdown:
devices added (udi:
/org/freedesktop/Hal/devices/net_00_1f_d0_56_5e_a0, iface: eth0)
Oct 30 09:59:30 rechenplan nm-system-settings:    Ifupdown: get
unmanaged devices count: 1
Oct 30 09:59:30 rechenplan nm-system-settings:    SCPlugin-Ifupdown:
(7865536) ... get_connections.
Oct 30 09:59:30 rechenplan nm-system-settings:    SCPlugin-Ifupdown:
(7865536) connections count: 1
Oct 30 09:59:30 rechenplan nm-system-settings:    Ifupdown: get
unmanaged devices count: 1
Oct 30 09:59:30 rechenplan nm-system-settings:    SCPlugin-Ifupdown: end _init.
Oct 30 09:59:30 rechenplan nm-system-settings: Loaded plugin ifupdown:
(C) 2008 Canonical Ltd.  To report bugs please use the NetworkManager
mailing list.
Oct 30 09:59:30 rechenplan nm-system-settings: Loaded plugin keyfile:
(c) 2007 - 2008 Red Hat, Inc.  To report bugs please use the
NetworkManager mailing list.
Oct 30 09:59:30 rechenplan NetworkManager: <info>  (eth0): now unmanaged
Oct 30 09:59:30 rechenplan anacron[6056]: Anacron 2.3 started on 2008-10-30
Oct 30 09:59:30 rechenplan anacron[6056]: Normal exit (0 jobs run)
Oct 30 09:59:31 rechenplan /usr/sbin/cron[6100]: (CRON) INFO (pidfile fd = 3)
Oct 30 09:59:31 rechenplan /usr/sbin/cron[6101]: (CRON) STARTUP (fork ok)
Oct 30 09:59:31 rechenplan /usr/sbin/cron[6101]: (CRON) INFO (Running
@reboot jobs)
Oct 30 09:59:31 rechenplan acpid: client connected from 6061[0:0]
Oct 30 09:59:33 rechenplan kernel: [   49.534607] [fglrx] GART Table
is not in FRAME_BUFFER range
Oct 30 09:59:33 rechenplan kernel: [   49.605431] [fglrx] Reserved FB
block: Shared offset:0, size:1000000
Oct 30 09:59:33 rechenplan kernel: [   49.605451] [fglrx] Reserved FB
block: Unshared offset:7ffc000, size:4000
Oct 30 09:59:43 rechenplan kdm_greet[6181]: Cannot open default user face
Oct 30 10:00:01 rechenplan /USR/SBIN/CRON[6206]: (horst) CMD
(/home/horst/ksvn/hg/upall)
Oct 30 10:00:01 rechenplan /USR/SBIN/CRON[6207]: (root) CMD ([ -x
/usr/sbin/update-motd ] && /usr/sbin/update-motd 2>/dev/null)
Oct 30 10:00:22 rechenplan anacron[6521]: Anacron 2.3 started on 2008-10-30
Oct 30 10:00:22 rechenplan anacron[6521]: Normal exit (0 jobs run)
Oct 30 10:00:22 rechenplan kernel: [   98.608169] CPU0 attaching NULL
sched-domain.
Oct 30 10:00:22 rechenplan kernel: [   98.608189] CPU1 attaching NULL
sched-domain.
Oct 30 10:00:22 rechenplan kernel: [   98.608193] CPU2 attaching NULL
sched-domain.
Oct 30 10:00:22 rechenplan kernel: [   98.608198] CPU3 attaching NULL
sched-domain.
Oct 30 10:00:22 rechenplan kernel: [   98.624635] CPU0 attaching sched-domain:
Oct 30 10:00:22 rechenplan kernel: [   98.624643]  domain 0: span 0-3 level CPU
Oct 30 10:00:22 rechenplan kernel: [   98.624648]   groups: 0 1 2 3
Oct 30 10:00:22 rechenplan kernel: [   98.624657]   domain 1: span 0-3
level NODE
Oct 30 10:00:22 rechenplan kernel: [   98.624661]    groups: 0-3
Oct 30 10:00:22 rechenplan kernel: [   98.624668] CPU1 attaching sched-domain:
Oct 30 10:00:22 rechenplan kernel: [   98.624671]  domain 0: span 0-3 level CPU
Oct 30 10:00:22 rechenplan kernel: [   98.624675]   groups: 1 2 3 0
Oct 30 10:00:22 rechenplan kernel: [   98.624681]   domain 1: span 0-3
level NODE
Oct 30 10:00:22 rechenplan kernel: [   98.624691]    groups: 0-3
Oct 30 10:00:22 rechenplan kernel: [   98.624701] CPU2 attaching sched-domain:
Oct 30 10:00:22 rechenplan kernel: [   98.624704]  domain 0: span 0-3 level CPU
Oct 30 10:00:22 rechenplan kernel: [   98.624707]   groups: 2 3 0 1
Oct 30 10:00:22 rechenplan kernel: [   98.624714]   domain 1: span 0-3
level NODE
Oct 30 10:00:22 rechenplan kernel: [   98.624722]    groups: 0-3
Oct 30 10:00:22 rechenplan kernel: [   98.624728] CPU3 attaching sched-domain:
Oct 30 10:00:22 rechenplan kernel: [   98.624731]  domain 0: span 0-3 level CPU
Oct 30 10:00:22 rechenplan kernel: [   98.624734]   groups: 3 0 1 2
Oct 30 10:00:22 rechenplan kernel: [   98.624740]   domain 1: span 0-3
level NODE
Oct 30 10:00:22 rechenplan kernel: [   98.624747]    groups: 0-3
Oct 30 10:00:36 rechenplan NetworkManager: <info>  Unmanaged Device
found; state CONNECTED forced. (see
http://bugs.launchpad.net/bugs/191889)
Oct 30 10:00:36 rechenplan NetworkManager: <info>  Unmanaged Device
found; state CONNECTED forced. (see
http://bugs.launchpad.net/bugs/191889)
Oct 30 10:00:39 rechenplan python: hp-systray(init)[6663]: warning: No
hp: or hpfax: devices found in any installed CUPS queue. Exiting.
Oct 30 10:01:49 rechenplan kernel: [  185.871728] type=1503
audit(1225357309.806:4): operation="inode_permission"
requested_mask="r::" denied_mask="r::" fsuid=7 name="/proc/6821/net/"
pid=6821 profile="/usr/sbin/cupsd"
Oct 30 10:01:50 rechenplan kernel: [  186.957497] type=1503
audit(1225357310.892:5): operation="inode_permission"
requested_mask="r::" denied_mask="r::" fsuid=7 name="/proc/6825/net/"
pid=6825 profile="/usr/sbin/cupsd"
Oct 30 10:01:50 rechenplan kernel: [  186.957549] type=1503
audit(1225357310.892:6): operation="socket_create" family="ax25"
sock_type="dgram" protocol=0 pid=6825 profile="/usr/sbin/cupsd"
Oct 30 10:01:50 rechenplan kernel: [  186.957560] type=1503
audit(1225357310.892:7): operation="socket_create" family="netrom"
sock_type="seqpacket" protocol=0 pid=6825 profile="/usr/sbin/cupsd"
Oct 30 10:01:50 rechenplan kernel: [  186.957571] type=1503
audit(1225357310.892:8): operation="socket_create" family="rose"
sock_type="dgram" protocol=0 pid=6825 profile="/usr/sbin/cupsd"
Oct 30 10:01:50 rechenplan kernel: [  186.957580] type=1503
audit(1225357310.892:9): operation="socket_create" family="ipx"
sock_type="dgram" protocol=0 pid=6825 profile="/usr/sbin/cupsd"
Oct 30 10:01:50 rechenplan kernel: [  186.957589] type=1503
audit(1225357310.892:10): operation="socket_create" family="appletalk"
sock_type="dgram" protocol=0 pid=6825 profile="/usr/sbin/cupsd"
Oct 30 10:01:50 rechenplan kernel: [  186.957600] type=1503
audit(1225357310.892:11): operation="socket_create" family="econet"
sock_type="dgram" protocol=0 pid=6825 profile="/usr/sbin/cupsd"
Oct 30 10:01:50 rechenplan kernel: [  186.957610] type=1503
audit(1225357310.892:12): operation="socket_create" family="ash"
sock_type="dgram" protocol=0 pid=6825 profile="/usr/sbin/cupsd"
Oct 30 10:01:50 rechenplan kernel: [  186.957619] type=1503
audit(1225357310.892:13): operation="socket_create" family="x25"
sock_type="seqpacket" protocol=0 pid=6825 profile="/usr/sbin/cupsd"
Oct 30 10:03:35 rechenplan ntpd[4670]: synchronized to 91.189.94.4, stratum 2
Oct 30 10:03:35 rechenplan ntpd[4670]: kernel time sync status change 0001
Oct 30 10:10:01 rechenplan /USR/SBIN/CRON[6842]: (root) CMD ([ -x
/usr/sbin/update-motd ] && /usr/sbin/update-motd 2>/dev/null)
Oct 30 10:17:01 rechenplan /USR/SBIN/CRON[6933]: (root) CMD (   cd /
&& run-parts --report /etc/cron.hourly)
Oct 30 10:20:01 rechenplan /USR/SBIN/CRON[6995]: (root) CMD ([ -x
/usr/sbin/update-motd ] && /usr/sbin/update-motd 2>/dev/null)
Oct 30 10:20:01 rechenplan /USR/SBIN/CRON[7008]: (horst) CMD
(/home/horst/ksvn/hg/upall)
Oct 30 10:30:02 rechenplan /USR/SBIN/CRON[7205]: (root) CMD ([ -x
/usr/sbin/update-motd ] && /usr/sbin/update-motd 2>/dev/null)
Oct 30 10:40:02 rechenplan /USR/SBIN/CRON[7398]: (horst) CMD
(/home/horst/ksvn/hg/upall)
Oct 30 10:40:02 rechenplan /USR/SBIN/CRON[7407]: (root) CMD ([ -x
/usr/sbin/update-motd ] && /usr/sbin/update-motd 2>/dev/null)
Oct 30 10:50:01 rechenplan /USR/SBIN/CRON[7627]: (root) CMD ([ -x
/usr/sbin/update-motd ] && /usr/sbin/update-motd 2>/dev/null)

lspci -vv:
00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
        Subsystem: Advanced Micro Devices [AMD] RS780 Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 32
        Region 3: Memory at <ignored> (64-bit, non-prefetchable)
        Capabilities: [c4] HyperTransport: Slave or Primary Interface
                Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir-
DUL-
                Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC-
TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
                Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+
TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut-
LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
                Revision ID: 3.00
                Link Frequency 0: [a]
                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+
500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT-
64bA- UIDRD-
                Link Frequency 1: 200MHz
                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 1: 200MHz- 300MHz- 400MHz-
500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE-
CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                Prefetchable memory behind bridge Upper: 00-00
                Bus Number: 00
        Capabilities: [54] HyperTransport: UnitID Clumping
        Capabilities: [40] HyperTransport: Retry Mode
        Capabilities: [9c] HyperTransport: #1a
        Capabilities: [f8] HyperTransport: #1c

00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI
bridge (int gfx)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 99
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fdd00000-fdefffff
        Prefetchable memory behind bridge:
00000000d8000000-00000000dfffffff
        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD]
RS780 PCI to PCI bridge (int gfx)
        Kernel modules: shpchp

00:0a.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI
bridge (PCIE port 5)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 4 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fda00000-fdafffff
        Prefetchable memory behind bridge:
00000000fdf00000-00000000fdffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag+ RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Suprise- LLActRep+ BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surpise-
                        Slot #  a, PowerLimit 25.000000; Interlock-
NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0f00c  Data: 4151
        Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD]
Device 9600
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100] Vendor Specific Information <?>
        Capabilities: [110] Virtual Channel <?>
        Kernel driver in use: pcieport-driver
        Kernel modules: shpchp

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA
Controller [AHCI mode] (prog-if 01)
        Subsystem: Giga-byte Technology Device b002
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 2301
        Region 0: I/O ports at ff00 [size=8]
        Region 1: I/O ports at fe00 [size=4]
        Region 2: I/O ports at fd00 [size=8]
        Region 3: I/O ports at fc00 [size=4]
        Region 4: I/O ports at fb00 [size=16]
        Region 5: Memory at fe02f000 (32-bit, non-prefetchable)
[size=1K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
Queue=0/2 Enable+
                Address: 00000000fee0f00c  Data: 4171
        Capabilities: [70] SATA HBA <?>
        Kernel driver in use: ahci
        Kernel modules: ahci

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0
Controller (prog-if 10)
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fe02e000 (32-bit, non-prefetchable)
[size=4K]
        Kernel driver in use: ohci_hcd
        Kernel modules: ohci-hcd

00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1
Controller (prog-if 10)
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fe02d000 (32-bit, non-prefetchable)
[size=4K]
        Kernel driver in use: ohci_hcd
        Kernel modules: ohci-hcd

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI
Controller (prog-if 20)
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 17
        Region 0: Memory at fe02c000 (32-bit, non-prefetchable)
[size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0
Controller (prog-if 10)
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fe02b000 (32-bit, non-prefetchable)
[size=4K]
        Kernel driver in use: ohci_hcd
        Kernel modules: ohci-hcd

00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1
Controller (prog-if 10)
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fe02a000 (32-bit, non-prefetchable)
[size=4K]
        Kernel driver in use: ohci_hcd
        Kernel modules: ohci-hcd

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI
Controller (prog-if 20)
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 19
        Region 0: Memory at fe029000 (32-bit, non-prefetchable)
[size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
        Subsystem: Giga-byte Technology Device 4385
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
        Kernel driver in use: piix4_smbus
        Kernel modules: i2c-piix4

00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
(prog-if 8a [Master SecP PriP])
        Subsystem: Giga-byte Technology Device 5002
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at fa00 [size=16]
        Capabilities: [70] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Kernel driver in use: pata_atiixp
        Kernel modules: ata_generic, pata_acpi, pata_atiixp

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
        Subsystem: ATI Technologies Inc Device 4383
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fdc00000-fdcfffff
        Prefetchable memory behind bridge: fdb00000-fdbfffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2
Controller (prog-if 10)
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 4 bytes
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at fe028000 (32-bit, non-prefetchable)
[size=4K]
        Kernel driver in use: ohci_hcd
        Kernel modules: ohci-hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
Athlon64, Sempron] HyperTransport Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [80] HyperTransport: Host or Secondary Interface
                Command: WarmRst+ DblEnd- DevNum=0 ChainSide-
HostHide+ Slave- <EOCErr- DUL-
                Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO-
<CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
                Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
                Revision ID: 3.00
                Link Frequency: [a]
                Link Error: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability: 200MHz+ 300MHz- 400MHz+
500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT-
64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
Athlon64, Sempron] Address Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
Athlon64, Sempron] DRAM Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
Athlon64, Sempron] Miscellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [f0] Secure device <?>

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
Athlon64, Sempron] Link Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200 Graphics
        Subsystem: Giga-byte Technology Device d000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at d8000000 (32-bit, prefetchable)
[size=128M]
        Region 1: I/O ports at ee00 [size=256]
        Region 2: Memory at fdee0000 (32-bit, non-prefetchable)
[size=64K]
        Region 5: Memory at fdd00000 (32-bit, non-prefetchable)
[size=1M]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Kernel driver in use: fglrx_pci
        Kernel modules: fglrx

01:05.1 Audio device: ATI Technologies Inc RS780 Azalia controller
        Subsystem: ATI Technologies Inc RS780 Azalia controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 4 bytes
        Interrupt: pin B routed to IRQ 5
        Region 0: Memory at fdefc000 (32-bit, non-prefetchable)
[size=16K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
        Subsystem: Giga-byte Technology Device e000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 2302
        Region 0: I/O ports at de00 [size=256]
        Region 2: Memory at fdfff000 (64-bit, prefetchable) [size=4K]
        Region 4: Memory at fdfe0000 (64-bit, prefetchable) [size=64K]
        [virtual] Expansion ROM at fdf00000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable+
                Address: 00000000fee0f00c  Data: 4159
        Capabilities: [70] Express (v1) Endpoint, MSI 01
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <8us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <64us
                        ClockPM+ Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00000800
        Capabilities: [d0] Vital Product Data <?>
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [140] Virtual Channel <?>
        Capabilities: [160] Device Serial Number 78-56-34-12-78-56-34-12
        Kernel driver in use: r8169
        Kernel modules: r8169

03:07.0 Multimedia audio controller: VIA Technologies Inc. VT1720/24
[Envy24PT/HT] PCI Multi-Channel Audio Controller (rev 01)
        Subsystem: VIA Technologies Inc. Device 3630
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 21
        Region 0: I/O ports at cf00 [size=32]
        Region 1: I/O ports at ce00 [size=128]
        Capabilities: [80] Power Management version 1
                Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: ICE1724
        Kernel modules: snd-ice1724
