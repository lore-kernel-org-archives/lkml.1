Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502Ab0ANT0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab0ANT0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 14:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447Ab0ANT03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 14:26:29 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:33537 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab0ANT02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:26:28 -0500
Message-ID: <4B4F6FDB.20204@us.ibm.com>
Date: Thu, 14 Jan 2010 11:26:19 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: richard parkins <p1rpp@yahoo.co.uk>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Problems with futex
References: <244239.49075.qm@web27606.mail.ukl.yahoo.com>
In-Reply-To: <244239.49075.qm@web27606.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Richard,

Thomas, Ingo - should we push commit
f8d1e548931cfa5ea9a082e020c2a47d27e5d793 to stable? (I didn't see 
stable@kernel.org in the -tip commit for this patch).

richard parkins wrote:
 > Please CC rparkins@undo-software.com with any responses
 >
 > 1. Various problems with futex
 > 2. Test attached shows errors:
 > FUTEX_WAKE_OP arg4 not decoded correctly in 32-bit (looks like fixed
 > in linux-2.6.32.3)

Right, fixed in commit f54f098612d7f86463b5fb4763d03533d634de73. This 
has already been sent to stable@kernel.org.

 > FUTEX_LOCK_PI(_PRIVATE) with non-NULL timeout returns ETIMEDOUT
 > immediately without waiting (may be fixed in linux-2.6.32.3)
 > FUTEX_WAIT_BITSET(_PRIVATE) with non-NULL timeout returns ETIMEDOUT
 > immediately without waiting (patch suggested below)

Both of the above are due to the testcase using a relative timeout which 
is only appropriate for the FUTEX_WAIT opcode. The newer opcodes use an 
absolute timeout. This was done for syscall restart optimizations, but 
FUTEX_WAIT could not be changed as it was already "out in the wild".

Additionally, FUTEX_WAIT_BITSET and FUTEX_WAIT_REQUEUE_PI can also take 
FUTEX_CLOCK_REALTIME as a flag to the futex op which identifies the 
passed in timeout to be generated from CLOCK_REALTIME instead of 
CLOCK_MONOTONIC.

 > Definitions of FUTEX_WAIT_BITSET_PRIVATE and 
FUTEX_WAKE_BITSET_PRIVATE were bad in header file (fixed in linux-2.6.32.3)

Right, fixed in commit f8d1e548931cfa5ea9a082e020c2a47d27e5d793.

 > Definition of FUTEX_OP unsafe if actual arguments are expressions 
(safe one suggested below)
 > The definition of FUTEX_OP in linux/futex.h doesn't protect against 
the actual arguments being expressions. Here is a safer one
 > #define FUTEX_OP(op, oparg, cmp, cmparg) \
 >   ((((op) & 0xf) << 28) | (((cmp) & 0xf) << 24)		\
 >    | (((oparg) & 0xfff) << 12) | ((cmparg) & 0xfff))


That seems reasonable, please consider submitting a patch.

Thanks,

Darren Hart


 > 3. futex
 > 4. Linux version 2.6.27.39-0.2-default (geeko@buildhost) (gcc version 
4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP 2009-11-23 
12:57:38 +0100
 > 5. not applicable
 > 6. test attached
 > 7.1
 > Linux rparkins64 2.6.27.39-0.2-default #1 SMP 2009-11-23 12:57:38 
+0100 x86_64 x86_64 x86_64 GNU/Linux
 >
 > Gnu C                  4.3
 > Gnu make               3.81
 > binutils               11.1
 > 2.19
 > util-linux             ver_linux: line 23: fdformat: command not found
 > mount                  support
 > module-init-tools      found
 > Linux C Library        2.9
 > Dynamic linker (ldd)   2.9
 > Procps                 3.2.7
 > Kbd                    1.14.1
 > oprofile               0.9.4
 > Sh-utils               6.12
 > udev                   128
 > Modules Loaded         ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit 
af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT 
nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state 
iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns 
nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter ip6_tables 
x_tables ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave 
acpi_cpufreq dm_crypt fuse loop dm_mod arc4 ecb snd_hda_intel 
crypto_blkcipher iwl3945 snd_pcm usbhid pcmcia video snd_timer rfkill 
iTCO_wdt hid mac80211 iTCO_vendor_support snd_page_alloc tg3 
yenta_socket nvidia snd_hwdep ohci1394 i2c_i801 battery snd output 
rtc_cmos libphy led_class button ac rsrc_nonstatic pcspkr joydev 
ff_memless ieee1394 intel_agp wmi sr_mod irda rtc_core pcmcia_core 
dcdbas cdrom soundcore rtc_lib i2c_core cfg80211 crc_ccitt sg sd_mod 
crc_t10dif ehci_hcd uhci_hcd usbcore edd ext3 mbcache jbd fan 
ide_pci_generic ide_core ata_generic
 >  ata_piix libata scsi_mod dock thermal processor thermal_sys hwmon
 > 7.2
 > processor       : 0
 > vendor_id       : GenuineIntel
 > cpu family      : 6
 > model           : 15
 > model name      : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
 > stepping        : 6
 > cpu MHz         : 1000.000
 > cache size      : 4096 KB
 > physical id     : 0
 > siblings        : 2
 > core id         : 0
 > cpu cores       : 2
 > apicid          : 0
 > initial apicid  : 0
 > fpu             : yes
 > fpu_exception   : yes
 > cpuid level     : 10
 > wp              : yes
 > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr 
pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni 
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
 > bogomips        : 3989.97
 > clflush size    : 64
 > cache_alignment : 64
 > address sizes   : 36 bits physical, 48 bits virtual
 > power management:
 >
 > processor       : 1
 > vendor_id       : GenuineIntel
 > cpu family      : 6
 > model           : 15
 > model name      : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
 > stepping        : 6
 > cpu MHz         : 1000.000
 > cache size      : 4096 KB
 > physical id     : 0
 > siblings        : 2
 > core id         : 1
 > cpu cores       : 2
 > apicid          : 1
 > initial apicid  : 1
 > fpu             : yes
 > fpu_exception   : yes
 > cpuid level     : 10
 > wp              : yes
 > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr 
pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni 
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
 > bogomips        : 3990.05
 > clflush size    : 64
 > cache_alignment : 64
 > address sizes   : 36 bits physical, 48 bits virtual
 > power management:
 > 7.3
 > ip6t_LOG 7180 7 - Live 0xffffffffa0dbe000
 > xt_tcpudp 3608 4 - Live 0xffffffffa0dbc000
 > xt_pkttype 2152 3 - Live 0xffffffffa0dba000
 > ipt_LOG 6812 8 - Live 0xffffffffa0db7000
 > xt_limit 3180 15 - Live 0xffffffffa0db5000
 > af_packet 20232 4 - Live 0xffffffffa0daf000
 > snd_pcm_oss 48624 0 - Live 0xffffffffa0da2000
 > snd_mixer_oss 16808 1 snd_pcm_oss, Live 0xffffffffa0d9c000
 > snd_seq 61504 0 - Live 0xffffffffa0d8b000
 > snd_seq_device 8604 1 snd_seq, Live 0xffffffffa0d87000
 > ip6t_REJECT 6024 3 - Live 0xffffffffa0d84000
 > nf_conntrack_ipv6 24712 5 - Live 0xffffffffa0d7c000
 > ip6table_raw 2456 1 - Live 0xffffffffa0d7a000
 > xt_NOTRACK 2152 4 - Live 0xffffffffa0d78000
 > ipt_REJECT 3480 3 - Live 0xffffffffa0d76000
 > xt_state 2568 10 - Live 0xffffffffa0d74000
 > iptable_raw 2760 1 - Live 0xffffffffa0d72000
 > iptable_filter 3400 1 - Live 0xffffffffa0d70000
 > ip6table_mangle 3128 0 - Live 0xffffffffa0d6e000
 > nf_conntrack_netbios_ns 2840 0 - Live 0xffffffffa0219000
 > nf_conntrack_ipv4 12808 5 - Live 0xffffffffa0d69000
 > nf_conntrack 80352 5 
nf_conntrack_ipv6,xt_NOTRACK,xt_state,nf_conntrack_netbios_ns,nf_conntrack_ipv4, 
Live 0xffffffffa0d54000
 > ip_tables 19464 2 iptable_raw,iptable_filter, Live 0xffffffffa0d4e000
 > ip6table_filter 3240 1 - Live 0xffffffffa01d3000
 > ip6_tables 21048 4 
ip6t_LOG,ip6table_raw,ip6table_mangle,ip6table_filter, Live 
0xffffffffa0d47000
 > x_tables 23376 11 
ip6t_LOG,xt_tcpudp,xt_pkttype,ipt_LOG,xt_limit,ip6t_REJECT,xt_NOTRACK,ipt_REJECT,xt_state,ip_tables,ip6_tables, 
Live 0xffffffffa0d40000
 > ipv6 292472 23 ip6t_REJECT,nf_conntrack_ipv6,ip6table_mangle, Live 
0xffffffffa0cf7000
 > cpufreq_conservative 8384 0 - Live 0xffffffffa0cf3000
 > cpufreq_userspace 4204 0 - Live 0xffffffffa0cf0000
 > cpufreq_powersave 2248 0 - Live 0xffffffffa015f000
 > acpi_cpufreq 8216 0 - Live 0xffffffffa0cec000
 > dm_crypt 14352 0 - Live 0xffffffffa0ce7000
 > fuse 57872 3 - Live 0xffffffffa0cd7000
 > loop 16660 0 - Live 0xffffffffa0cd1000
 > dm_mod 74064 1 dm_crypt, Live 0xffffffffa0cbd000
 > arc4 2216 2 - Live 0xffffffffa01ec000
 > ecb 3464 2 - Live 0xffffffffa01df000
 > snd_hda_intel 562228 2 - Live 0xffffffffa0c32000
 > crypto_blkcipher 19372 2 dm_crypt,ecb, Live 0xffffffffa0c2c000
 > iwl3945 97892 0 - Live 0xffffffffa0c13000
 > snd_pcm 92064 2 snd_pcm_oss,snd_hda_intel, Live 0xffffffffa0bfb000
 > usbhid 52544 0 - Live 0xffffffffa0bed000
 > pcmcia 38288 0 - Live 0xffffffffa0be2000
 > video 24316 6 - Live 0xffffffffa0bdb000
 > snd_timer 24968 2 snd_seq,snd_pcm, Live 0xffffffffa0bd3000
 > rfkill 10948 2 iwl3945, Live 0xffffffffa0bcf000
 > iTCO_wdt 12416 0 - Live 0xffffffffa0bca000
 > hid 41136 1 usbhid, Live 0xffffffffa0bbe000
 > mac80211 241360 1 iwl3945, Live 0xffffffffa0b82000
 > iTCO_vendor_support 4268 1 iTCO_wdt, Live 0xffffffffa0216000
 > snd_page_alloc 9800 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0212000
 > tg3 125084 0 - Live 0xffffffffa0b62000
 > yenta_socket 26404 1 - Live 0xffffffffa0b5a000
 > nvidia 9616824 32 - Live 0xffffffffa022d000 (PX)
 > snd_hwdep 9104 1 snd_hda_intel, Live 0xffffffffa0229000
 > ohci1394 31364 0 - Live 0xffffffffa0220000
 > i2c_i801 12756 0 - Live 0xffffffffa021b000
 > battery 13856 0 - Live 0xffffffffa01b4000
 > snd 73576 12 
snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_timer,snd_hwdep, 
Live 0xffffffffa01ff000
 > output 3672 1 video, Live 0xffffffffa01fd000
 > rtc_cmos 13000 0 - Live 0xffffffffa01f8000
 > libphy 23080 1 tg3, Live 0xffffffffa01f1000
 > led_class 5008 1 iwl3945, Live 0xffffffffa01ee000
 > button 8328 0 - Live 0xffffffffa01e8000
 > ac 5776 0 - Live 0xffffffffa01e5000
 > rsrc_nonstatic 10920 1 yenta_socket, Live 0xffffffffa01e1000
 > pcspkr 3064 0 - Live 0xffffffffa01dd000
 > joydev 11376 0 - Live 0xffffffffa01d9000
 > ff_memless 8752 1 usbhid, Live 0xffffffffa01d5000
 > ieee1394 98464 1 ohci1394, Live 0xffffffffa01b9000
 > intel_agp 30400 0 - Live 0xffffffffa01ab000
 > wmi 8160 0 - Live 0xffffffffa01a8000
 > sr_mod 15860 0 - Live 0xffffffffa01a3000
 > irda 132756 0 - Live 0xffffffffa0181000
 > rtc_core 21396 1 rtc_cmos, Live 0xffffffffa017a000
 > pcmcia_core 39140 3 pcmcia,yenta_socket,rsrc_nonstatic, Live 
0xffffffffa016f000
 > dcdbas 10984 0 - Live 0xffffffffa016b000 (X)
 > cdrom 36200 1 sr_mod, Live 0xffffffffa0161000
 > soundcore 8368 1 snd, Live 0xffffffffa015b000
 > rtc_lib 3560 1 rtc_core, Live 0xffffffffa0131000
 > i2c_core 35296 2 nvidia,i2c_i801, Live 0xffffffffa0151000
 > cfg80211 28168 2 iwl3945,mac80211, Live 0xffffffffa0149000
 > crc_ccitt 2392 1 irda, Live 0xffffffffa0120000
 > sg 35376 0 - Live 0xffffffffa013f000
 > sd_mod 35240 6 - Live 0xffffffffa0135000
 > crc_t10dif 2152 1 sd_mod, Live 0xffffffffa0133000
 > ehci_hcd 54676 0 - Live 0xffffffffa0122000
 > uhci_hcd 26840 0 - Live 0xffffffffa0118000
 > usbcore 195808 4 usbhid,ehci_hcd,uhci_hcd, Live 0xffffffffa00e7000
 > edd 10272 0 - Live 0xffffffffa00e3000
 > ext3 140824 3 - Live 0xffffffffa00bf000
 > mbcache 9484 1 ext3, Live 0xffffffffa00bb000
 > jbd 61752 1 ext3, Live 0xffffffffa00aa000
 > fan 6016 0 - Live 0xffffffffa00a7000
 > ide_pci_generic 4652 0 - Live 0xffffffffa00a4000
 > ide_core 115068 1 ide_pci_generic, Live 0xffffffffa0086000
 > ata_generic 6044 0 - Live 0xffffffffa0083000
 > ata_piix 21980 5 - Live 0xffffffffa007c000
 > libata 183856 2 ata_generic,ata_piix, Live 0xffffffffa004e000
 > scsi_mod 178968 4 sr_mod,sg,sd_mod,libata, Live 0xffffffffa0021000
 > dock 14212 1 libata, Live 0xffffffffa001c000
 > thermal 24408 0 - Live 0xffffffffa0015000
 > processor 49472 4 acpi_cpufreq,thermal, Live 0xffffffffa0007000
 > thermal_sys 14336 4 video,fan,thermal,processor, Live 0xffffffffa0002000
 > hwmon 3720 1 thermal_sys, Live 0xffffffffa0000000
 > 7.4
 > 0000-001f : dma1
 > 0020-0021 : pic1
 > 0040-0043 : timer0
 > 0050-0053 : timer1
 > 0060-0060 : keyboard
 > 0064-0064 : keyboard
 > 0070-0071 : rtc0
 > 0080-008f : dma page reg
 > 00a0-00a1 : pic2
 > 00c0-00df : dma2
 > 00f0-00ff : fpu
 > 0170-0177 : 0000:00:1f.2
 >   0170-0177 : ata_piix
 > 01f0-01f7 : 0000:00:1f.2
 >   01f0-01f7 : ata_piix
 > 02f8-02ff : serial
 > 0376-0376 : 0000:00:1f.2
 >   0376-0376 : ata_piix
 > 03c0-03df : vga+
 > 03f6-03f6 : 0000:00:1f.2
 >   03f6-03f6 : ata_piix
 > 03f8-03ff : serial
 > 04d0-04d1 : pnp 00:02
 > 0809-0809 : pnp 00:03
 > 0910-091f : pnp 00:08
 > 0920-092f : pnp 00:08
 > 0930-097f : pnp 00:08
 > 0c80-0caf : pnp 00:08
 > 0cb0-0cbb : pnp 00:0e
 > 0cbc-0cbf : pnp 00:08
 > 0cf8-0cff : PCI conf1
 > 1000-107f : 0000:00:1f.0
 >   1000-1003 : ACPI PM1a_EVT_BLK
 >   1004-1005 : ACPI PM1a_CNT_BLK
 >   1008-100b : ACPI PM_TMR
 >   1010-1015 : ACPI CPU throttle
 >   1020-1020 : ACPI PM2_CNT_BLK
 >   1028-102f : ACPI GPE0_BLK
 >   1060-107f : iTCO_wdt
 > 1080-10bf : 0000:00:1f.0
 >   1080-10bf : pnp 00:03
 > 10c0-10df : 0000:00:1f.3
 >   10c0-10df : pnp 00:03
 >     10c0-10df : i801_smbus
 > 2000-2fff : PCI Bus 0000:03
 >   2000-20ff : PCI CardBus 0000:04
 >   2400-24ff : PCI CardBus 0000:04
 > bf20-bf3f : 0000:00:1d.3
 >   bf20-bf3f : uhci_hcd
 > bf40-bf5f : 0000:00:1d.2
 >   bf40-bf5f : uhci_hcd
 > bf60-bf7f : 0000:00:1d.1
 >   bf60-bf7f : uhci_hcd
 > bf80-bf9f : 0000:00:1d.0
 >   bf80-bf9f : uhci_hcd
 > bfa0-bfaf : 0000:00:1f.2
 >   bfa0-bfaf : ata_piix
 > e000-efff : PCI Bus 0000:0d
 > f400-f4fe : pnp 00:03
 > 00000000-0009efff : System RAM
 > 0009f000-0009ffff : reserved
 > 000c0000-000cffff : pnp 00:00
 > 000e0000-000fffff : pnp 00:00
 > 00100000-7fe813ff : System RAM
 >   00200000-004a420f : Kernel code
 >   004a4210-007bd18f : Kernel data
 >   00a36000-00bcc8b7 : Kernel bss
 > 7fe81400-7fffffff : reserved
 > 88000000-8bffffff : PCI Bus 0000:03
 >   88000000-8bffffff : PCI CardBus 0000:04
 > 8c000000-8fffffff : PCI CardBus 0000:04
 > d0000000-dfffffff : PCI Bus 0000:01
 >   d0000000-dfffffff : 0000:01:00.0
 > e0000000-e01fffff : PCI Bus 0000:0d
 > ecb00000-ecbfffff : PCI Bus 0000:03
 >   ecb00000-ecb00fff : 0000:03:01.0
 >     ecb00000-ecb00fff : yenta_socket
 >   ecbfe800-ecbfefff : 0000:03:01.4
 >   ecbff000-ecbfffff : 0000:03:01.4
 >     ecbff000-ecbff7ff : ohci1394
 > ecc00000-ecdfffff : PCI Bus 0000:0d
 > ece00000-ecefffff : PCI Bus 0000:09
 >   ecef0000-ecefffff : 0000:09:00.0
 >     ecef0000-ecefffff : tg3
 > ecf00000-ecffffff : PCI Bus 0000:0c
 >   ecfff000-ecffffff : 0000:0c:00.0
 >     ecfff000-ecffffff : iwl3945
 > ed000000-efefffff : PCI Bus 0000:01
 >   ed000000-edffffff : 0000:01:00.0
 >     ed000000-edffffff : nvidia
 >   ee000000-eeffffff : 0000:01:00.0
 >   ef000000-ef01ffff : 0000:01:00.0
 > efffc000-efffffff : 0000:00:1b.0
 >   efffc000-efffffff : ICH HD audio
 > f0000000-f4006fff : reserved
 >   f0000000-f3ffffff : PCI MMCONFIG 0
 > f4008000-f400bfff : reserved
 > fec00000-fec0ffff : reserved
 >   fec00000-fec00fff : IOAPIC 0
 > fed00000-fed003ff : HPET 0
 >   fed00000-fed003ff : pnp 00:0b
 > fed20000-fed9ffff : reserved
 > fee00000-fee0ffff : reserved
 >   fee00000-fee00fff : Local APIC
 > ffa80000-ffa803ff : 0000:00:1d.7
 >   ffa80000-ffa803ff : ehci_hcd
 > ffb00000-ffffffff : reserved
 > 7.5
 > 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 
943/940GML and 945GT Express Memory Controller Hub (rev 03)
 >         Subsystem: Dell Device 01cc
 >         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
 >         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
 >         Latency: 0
 >         Capabilities: [e0] Vendor Specific Information <?>
 >         Kernel modules: intel-agp
 >
 > 00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML 
and 945GT Express PCI Express Root Port (rev 03) (prog-if 00 [Normal 
decode])
 >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0, Cache Line Size: 64 bytes
 >         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
 >         I/O behind bridge: 0000f000-00000fff
 >         Memory behind bridge: ed000000-efefffff
 >         Prefetchable memory behind bridge: 
00000000d0000000-00000000dfffffff
 >         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
 >         BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
 >                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 >         Capabilities: [88] Subsystem: Dell Device 01cc
 >         Capabilities: [80] Power Management version 2
 >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
 >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 >         Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Count=1/1 Enable+
 >                 Address: fee0300c  Data: 4169
 >         Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
 >                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency 
L0s <64ns, L1 <1us
 >                         ExtTag- RBE- FLReset-
 >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 >                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 >                         MaxPayload 128 bytes, MaxReadReq 128 bytes
 >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
 >                 LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s 
L1, Latency L0 <256ns, L1 <4us
 >                         ClockPM- Suprise- LLActRep- BwNot-
 >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
 >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 >                 LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- 
SlotClk+ DLActive- BWMgmt- ABWMgmt-
 >                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surpise-
 >                         Slot #  1, PowerLimit 75.000000; Interlock- 
NoCompl-
 >                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- 
CmdCplt- HPIrq- LinkChg-
 >                         Control: AttnInd Off, PwrInd On, Power- 
Interlock-
 >                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
 >                         Changed: MRL- PresDet+ LinkState-
 >                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
 >                 RootCap: CRSVisible-
 >                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 >         Capabilities: [100] Virtual Channel <?>
 >         Capabilities: [140] Root Complex Link <?>
 >         Kernel driver in use: pcieport-driver
 >         Kernel modules: shpchp
 >
 > 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
Definition Audio Controller (rev 01)
 >         Subsystem: Dell Device 01cc
 >         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0, Cache Line Size: 64 bytes
 >         Interrupt: pin A routed to IRQ 21
 >         Region 0: Memory at efffc000 (64-bit, non-prefetchable) 
[size=16K]
 >         Capabilities: [50] Power Management version 2
 >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
 >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 >         Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Count=1/1 Enable-
 >                 Address: 0000000000000000  Data: 0000
 >         Capabilities: [70] Express (v1) Root Complex Integrated 
Endpoint, MSI 00
 >                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency 
L0s <64ns, L1 <1us
 >                         ExtTag- RBE- FLReset-
 >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 >                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
 >                         MaxPayload 128 bytes, MaxReadReq 128 bytes
 >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
 >                 LnkCap: Port #0, Speed unknown, Width x0, ASPM 
unknown, Latency L0 <64ns, L1 <1us
 >                         ClockPM- Suprise- LLActRep- BwNot-
 >                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
 >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 >                 LnkSta: Speed unknown, Width x0, TrErr- Train- 
SlotClk- DLActive- BWMgmt- ABWMgmt-
 >         Capabilities: [100] Virtual Channel <?>
 >         Capabilities: [130] Root Complex Link <?>
 >         Kernel driver in use: HDA Intel
 >         Kernel modules: snd-hda-intel
 >
 > 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI 
Express Port 1 (rev 01) (prog-if 00 [Normal decode])
 >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0, Cache Line Size: 64 bytes
 >         Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
 >         I/O behind bridge: 0000f000-00000fff
 >         Memory behind bridge: fff00000-000fffff
 >         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
 >         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
 >         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
 >                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 >         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
 >                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency 
L0s unlimited, L1 unlimited
 >                         ExtTag- RBE- FLReset-
 >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 >                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 >                         MaxPayload 128 bytes, MaxReadReq 128 bytes
 >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
 >                 LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s 
L1, Latency L0 <1us, L1 <4us
 >                         ClockPM- Suprise- LLActRep+ BwNot-
 >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- 
Retrain- CommClk-
 >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 >                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- 
SlotClk+ DLActive- BWMgmt- ABWMgmt-
 >                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surpise+
 >                         Slot #  2, PowerLimit 6.500000; Interlock- 
NoCompl-
 >                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ 
CmdCplt- HPIrq- LinkChg-
 >                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
 >                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
 >                         Changed: MRL- PresDet- LinkState-
 >                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
 >                 RootCap: CRSVisible-
 >                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 >         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Count=1/1 Enable+
 >                 Address: fee0300c  Data: 4171
 >         Capabilities: [90] Subsystem: Dell Device 01cc
 >         Capabilities: [a0] Power Management version 2
 >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
 >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 >         Capabilities: [100] Virtual Channel <?>
 >         Capabilities: [180] Root Complex Link <?>
 >         Kernel driver in use: pcieport-driver
 >         Kernel modules: shpchp
 >
 > 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI 
Express Port 2 (rev 01) (prog-if 00 [Normal decode])
 >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0, Cache Line Size: 64 bytes
 >         Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
 >         I/O behind bridge: 0000f000-00000fff
 >         Memory behind bridge: ecf00000-ecffffff
 >         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
 >         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
 >         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
 >                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 >         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
 >                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency 
L0s unlimited, L1 unlimited
 >                         ExtTag- RBE- FLReset-
 >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 >                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 >                         MaxPayload 128 bytes, MaxReadReq 128 bytes
 >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
 >                 LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s 
L1, Latency L0 <256ns, L1 <4us
 >                         ClockPM- Suprise- LLActRep+ BwNot-
 >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
 >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 >                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- 
SlotClk+ DLActive+ BWMgmt- ABWMgmt-
 >                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surpise+
 >                         Slot #  3, PowerLimit 6.500000; Interlock- 
NoCompl-
 >                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ 
CmdCplt- HPIrq- LinkChg-
 >                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
 >                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
 >                         Changed: MRL- PresDet- LinkState-
 >                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
 >                 RootCap: CRSVisible-
 >                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 >         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Count=1/1 Enable+
 >                 Address: fee0300c  Data: 4179
 >         Capabilities: [90] Subsystem: Dell Device 01cc
 >         Capabilities: [a0] Power Management version 2
 >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
 >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 >         Capabilities: [100] Virtual Channel <?>
 >         Capabilities: [180] Root Complex Link <?>
 >         Kernel driver in use: pcieport-driver
 >         Kernel modules: shpchp
 >
 > 00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI 
Express Port 3 (rev 01) (prog-if 00 [Normal decode])
 >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0, Cache Line Size: 64 bytes
 >         Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
 >         I/O behind bridge: 0000f000-00000fff
 >         Memory behind bridge: ece00000-ecefffff
 >         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
 >         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
 >         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
 >                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 >         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
 >                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency 
L0s unlimited, L1 unlimited
 >                         ExtTag- RBE- FLReset-
 >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 >                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 >                         MaxPayload 128 bytes, MaxReadReq 128 bytes
 >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
 >                 LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s 
L1, Latency L0 <256ns, L1 <4us
 >                         ClockPM- Suprise- LLActRep+ BwNot-
 >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
 >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 >                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- 
SlotClk+ DLActive+ BWMgmt- ABWMgmt-
 >                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surpise+
 >                         Slot #  4, PowerLimit 6.500000; Interlock- 
NoCompl-
 >                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ 
CmdCplt- HPIrq- LinkChg-
 >                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
 >                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
 >                         Changed: MRL- PresDet- LinkState-
 >                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
 >                 RootCap: CRSVisible-
 >                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 >         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Count=1/1 Enable+
 >                 Address: fee0300c  Data: 4189
 >         Capabilities: [90] Subsystem: Dell Device 01cc
 >         Capabilities: [a0] Power Management version 2
 >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
 >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 >         Capabilities: [100] Virtual Channel <?>
 >         Capabilities: [180] Root Complex Link <?>
 >         Kernel driver in use: pcieport-driver
 >         Kernel modules: shpchp
 >
 > 00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI 
Express Port 4 (rev 01) (prog-if 00 [Normal decode])
 >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0, Cache Line Size: 64 bytes
 >         Bus: primary=00, secondary=0d, subordinate=0e, sec-latency=0
 >         I/O behind bridge: 0000e000-0000efff
 >         Memory behind bridge: ecc00000-ecdfffff
 >         Prefetchable memory behind bridge: 
00000000e0000000-00000000e01fffff
 >         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
 >         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
 >                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 >         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
 >                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency 
L0s unlimited, L1 unlimited
 >                         ExtTag- RBE- FLReset-
 >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 >                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 >                         MaxPayload 128 bytes, MaxReadReq 128 bytes
 >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
 >                 LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s 
L1, Latency L0 <1us, L1 <4us
 >                         ClockPM- Suprise- LLActRep+ BwNot-
 >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- 
Retrain- CommClk-
 >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 >                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- 
SlotClk+ DLActive- BWMgmt- ABWMgmt-
 >                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surpise+
 >                         Slot #  5, PowerLimit 6.500000; Interlock- 
NoCompl-
 >                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ 
CmdCplt- HPIrq- LinkChg-
 >                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
 >                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
 >                         Changed: MRL- PresDet- LinkState-
 >                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
 >                 RootCap: CRSVisible-
 >                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 >         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Count=1/1 Enable+
 >                 Address: fee0300c  Data: 4191
 >         Capabilities: [90] Subsystem: Dell Device 01cc
 >         Capabilities: [a0] Power Management version 2
 >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
 >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 >         Capabilities: [100] Virtual Channel <?>
 >         Capabilities: [180] Root Complex Link <?>
 >         Kernel driver in use: pcieport-driver
 >         Kernel modules: shpchp
 >
 > 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB 
UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
 >         Subsystem: Dell Device 01cc
 >         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
 >         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0
 >         Interrupt: pin A routed to IRQ 20
 >         Region 4: I/O ports at bf80 [size=32]
 >         Kernel driver in use: uhci_hcd
 >         Kernel modules: uhci-hcd
 >
 > 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB 
UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
 >         Subsystem: Dell Device 01cc
 >         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
 >         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0
 >         Interrupt: pin B routed to IRQ 21
 >         Region 4: I/O ports at bf60 [size=32]
 >         Kernel driver in use: uhci_hcd
 >         Kernel modules: uhci-hcd
 >
 > 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB 
UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
 >         Subsystem: Dell Device 01cc
 >         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
 >         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0
 >         Interrupt: pin C routed to IRQ 22
 >         Region 4: I/O ports at bf40 [size=32]
 >         Kernel driver in use: uhci_hcd
 >         Kernel modules: uhci-hcd
 >
 > 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB 
UHCI Controller #4 (rev 01) (prog-if 00 [UHCI])
 >         Subsystem: Dell Device 01cc
 >         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
 >         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0
 >         Interrupt: pin D routed to IRQ 23
 >         Region 4: I/O ports at bf20 [size=32]
 >         Kernel driver in use: uhci_hcd
 >         Kernel modules: uhci-hcd
 >
 > 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 
EHCI Controller (rev 01) (prog-if 20 [EHCI])
 >         Subsystem: Dell Device 01cc
 >         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
 >         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0
 >         Interrupt: pin A routed to IRQ 20
 >         Region 0: Memory at ffa80000 (32-bit, non-prefetchable) [size=1K]
 >         Capabilities: [50] Power Management version 2
 >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
 >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 >         Capabilities: [58] Debug port: BAR=1 offset=00a0
 >         Kernel driver in use: ehci_hcd
 >         Kernel modules: ehci-hcd
 >
 > 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 
e1) (prog-if 01 [Subtractive decode])
 >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0
 >         Bus: primary=00, secondary=03, subordinate=07, sec-latency=32
 >         I/O behind bridge: 00002000-00002fff
 >         Memory behind bridge: ecb00000-ecbfffff
 >         Prefetchable memory behind bridge: 
0000000088000000-000000008bffffff
 >         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
 >         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
 >                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 >         Capabilities: [50] Subsystem: Dell Device 01cc
 >
 > 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface 
Bridge (rev 01)
 >         Subsystem: Dell Device 01cc
 >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0
 >         Capabilities: [e0] Vendor Specific Information <?>
 >         Kernel modules: iTCO_wdt, intel-rng
 >
 > 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) 
SATA IDE Controller (rev 01) (prog-if 80 [Master])
 >         Subsystem: Dell Device 01cc
 >         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
 >         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0
 >         Interrupt: pin B routed to IRQ 17
 >         Region 0: I/O ports at 01f0 [size=8]
 >         Region 1: I/O ports at 03f4 [size=1]
 >         Region 2: I/O ports at 0170 [size=8]
 >         Region 3: I/O ports at 0374 [size=1]
 >         Region 4: I/O ports at bfa0 [size=16]
 >         Capabilities: [70] Power Management version 2
 >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
 >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 >         Kernel driver in use: ata_piix
 >         Kernel modules: ide-pci-generic, ata_generic, pata_acpi, ata_piix
 >
 > 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus 
Controller (rev 01)
 >         Subsystem: Dell Device 01cc
 >         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
 >         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Interrupt: pin B routed to IRQ 17
 >         Region 4: I/O ports at 10c0 [size=32]
 >         Kernel driver in use: i801_smbus
 >         Kernel modules: i2c-i801
 >
 > 01:00.0 VGA compatible controller: nVidia Corporation G72M [Quadro 
NVS 110M/GeForce Go 7300] (rev a1) (prog-if 00 [VGA controller])
 >         Subsystem: Dell Device 01cc
 >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0
 >         Interrupt: pin A routed to IRQ 16
 >         Region 0: Memory at ed000000 (32-bit, non-prefetchable) 
[size=16M]
 >         Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
 >         Region 3: Memory at ee000000 (64-bit, non-prefetchable) 
[size=16M]
 >         [virtual] Expansion ROM at ef000000 [disabled] [size=128K]
 >         Capabilities: [60] Power Management version 2
 >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
 >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 >         Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ 
Count=1/1 Enable-
 >                 Address: 0000000000000000  Data: 0000
 >         Capabilities: [78] Express (v1) Endpoint, MSI 00
 >                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency 
L0s <256ns, L1 <4us
 >                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
 >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 >                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
 >                         MaxPayload 128 bytes, MaxReadReq 512 bytes
 >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
 >                 LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s 
L1, Latency L0 <256ns, L1 <4us
 >                         ClockPM- Suprise- LLActRep- BwNot-
 >                 LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- 
Retrain- CommClk+
 >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 >                 LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- 
SlotClk+ DLActive- BWMgmt- ABWMgmt-
 >         Capabilities: [100] Virtual Channel <?>
 >         Capabilities: [128] Power Budgeting <?>
 >         Kernel driver in use: nvidia
 >         Kernel modules: nvidia, nvidiafb
 >
 > 03:01.0 CardBus bridge: O2 Micro, Inc. Cardbus bridge (rev 21)
 >         Subsystem: Dell Device 01cc
 >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR- FastB2B- DisINTx-
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 168
 >         Interrupt: pin A routed to IRQ 19
 >         Region 0: Memory at ecb00000 (32-bit, non-prefetchable) [size=4K]
 >         Bus: primary=03, secondary=04, subordinate=07, sec-latency=176
 >         Memory window 0: 88000000-8bfff000 (prefetchable)
 >         Memory window 1: 8c000000-8ffff000
 >         I/O window 0: 00002000-000020ff
 >         I/O window 1: 00002400-000024ff
 >         BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ 
PostWrite+
 >         16-bit legacy interface ports at 0001
 >         Kernel driver in use: yenta_cardbus
 >         Kernel modules: yenta_socket
 >
 > 03:01.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) 
(rev 02) (prog-if 10 [OHCI])
 >         Subsystem: Dell Device 01cc
 >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
 >         Latency: 64, Cache Line Size: 64 bytes
 >         Interrupt: pin A routed to IRQ 19
 >         Region 0: Memory at ecbff000 (32-bit, non-prefetchable) [size=4K]
 >         Region 1: Memory at ecbfe800 (32-bit, non-prefetchable) [size=2K]
 >         Capabilities: [60] Power Management version 2
 >                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
 >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME+
 >         Kernel driver in use: ohci1394
 >         Kernel modules: ohci1394
 >
 > 09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752 
Gigabit Ethernet PCI Express (rev 02)
 >         Subsystem: Dell Device 01cc
 >         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0, Cache Line Size: 64 bytes
 >         Interrupt: pin A routed to IRQ 4345
 >         Region 0: Memory at ecef0000 (64-bit, non-prefetchable) 
[size=64K]
 >         Expansion ROM at <ignored> [disabled]
 >         Capabilities: [48] Power Management version 2
 >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
 >                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
 >         Capabilities: [50] Vital Product Data <?>
 >         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ 
Count=1/8 Enable+
 >                 Address: 00000000fee0300c  Data: 41c1
 >         Capabilities: [d0] Express (v1) Endpoint, MSI 00
 >                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency 
L0s <4us, L1 unlimited
 >                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
 >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 >                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 >                         MaxPayload 128 bytes, MaxReadReq 4096 bytes
 >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
 >                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s 
L1, Latency L0 <2us, L1 <64us
 >                         ClockPM- Suprise- LLActRep- BwNot-
 >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
 >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 >                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- 
SlotClk+ DLActive- BWMgmt- ABWMgmt-
 >         Capabilities: [100] Advanced Error Reporting
 >                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
 >                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
 >                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
 >                 CESta:  RxErr- BadTLP- BadDLLP+ Rollover- Timeout- 
NonFatalErr-
 >                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
 >                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap+ ChkEn-
 >         Capabilities: [13c] Virtual Channel <?>
 >         Kernel driver in use: tg3
 >         Kernel modules: tg3
 >
 > 0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG 
[Golan] Network Connection (rev 02)
 >         Subsystem: Intel Corporation Device 1021
 >         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
 >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 >         Latency: 0, Cache Line Size: 64 bytes
 >         Interrupt: pin A routed to IRQ 4346
 >         Region 0: Memory at ecfff000 (32-bit, non-prefetchable) [size=4K]
 >         Capabilities: [c8] Power Management version 2
 >                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
 >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 >         Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ 
Count=1/1 Enable+
 >                 Address: 00000000fee0100c  Data: 41b9
 >         Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
 >                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency 
L0s <512ns, L1 unlimited
 >                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
 >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 >                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
 >                         MaxPayload 128 bytes, MaxReadReq 128 bytes
 >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
 >                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s 
L1, Latency L0 <128ns, L1 <64us
 >                         ClockPM+ Suprise- LLActRep- BwNot-
 >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
 >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 >                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- 
SlotClk+ DLActive- BWMgmt- ABWMgmt-
 >         Capabilities: [100] Advanced Error Reporting
 >                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
 >                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
 >                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
 >                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
 >                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
 >                 AERCap: First Error Pointer: 00, GenCap- CGenEn- 
ChkCap- ChkEn-
 >         Capabilities: [140] Device Serial Number 07-0e-7b-ff-ff-d2-19-00
 >         Kernel driver in use: iwl3945
 >         Kernel modules: iwl3945
 > 7.6
 > Attached devices:
 > Host: scsi0 Channel: 00 Id: 00 Lun: 00
 >   Vendor: ATA      Model: Hitachi HTS54161 Rev: SBDO
 >   Type:   Direct-Access                    ANSI  SCSI revision: 05
 > Host: scsi1 Channel: 00 Id: 00 Lun: 00
 >   Vendor: TSSTcorp Model: DVD+-RW TS-L632D Rev: DE03
 >   Type:   CD-ROM                           ANSI  SCSI revision: 05
 >
 > Here is the output from the attached test compiled with -m32 and run 
under 64-bit Linux 2.6.27.39.
 >
 > Could not find undodb private space
 > FUTEX_WAKE_PRIVATE with bad address succeeds
 > FUTEX_WAKE with zero val woke a process
 > FUTEX_WAKE with negative val woke a process
 > FUTEX_REQUEUE returns 1 when waking no processes but requeueing one
 > KERNELBUG? FUTEX_WAKE_OP arg4 not decoded correctly in 32-bit
 > KERNELBUG? FUTEX_LOCK_PI with timer returns ETIMEDOUT immediately
 > KERNELBUG? FUTEX_LOCK_PI_PRIVATE with timer returns ETIMEDOUT immediately
 > KERNELBUG? FUTEX_WAIT_BITSET with timer returns ETIMEDOUT immediately
 > KERNELBUG? FUTEX_WAIT_BITSET_PRIVATE with timer returns ETIMEDOUT 
immediately
 > Test succeeded
 >
 > If compiled in 64-bit mode the output is the same but without the 
line about FUTEX_WAKE_OP.
 >
 > Here is the output again with my comments.
 >>>> Could not find undodb private space
 > Nothing to do with the kernel: it prints this if it isn't running 
under our debugger.
 >
 >>>> FUTEX_WAKE_PRIVATE with bad address succeeds
 > It isn't clear that this is a bug. FUTEX_WAKE always returns -EFAULT 
with a bad uaddr, because it looks for the vma and doesn't find one. 
FUTEX_WAIT_PRIVATE only does access_ok(), which is a weak test on x86 
architecture. On 32-bit FUTEX_WAKE_PRIVATE always returns 0 because it 
doesn't find a waiter: on 64-bit it returns -EFAULT if uaddr is negative 
and otherwise 0. I can see the case for not doing a proper accessibility 
check since the kernel doesn't actually dereference uaddr for 
FUTEX_WAKE, but the existing behaviour is a bit inconsistent.
 >
 >>>> FUTEX_WAKE with zero val woke a process
 >>>> FUTEX_WAKE with negative val woke a process
 >>>> FUTEX_REQUEUE returns 1 when waking no processes but requeueing one
 > These messages are because the kernel doesn't do what the man page 
says it does. Maybe the man page is wrong.... The treatment of counts of 
processes to be woken or requeued is a bit inconsistent. Sometimes you 
wake a process before checking the count (so a zero or negative count is 
treated as 1) and sometimes you check the count first. Maybe there's 
some method in your madness, but if so the man page is wrong.
 >
 >>>> KERNELBUG? FUTEX_WAKE_OP arg4 not decoded correctly in 32-bit
 > Should already have been fixed by this diff in futex_compat.c from 
2.6.27.39 to 2.6.32.3
 > 191c195,196
 > <       if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
 > ---
 >>       if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
 >>           cmd == FUTEX_CMP_REQUEUE_PI || cmd == FUTEX_WAKE_OP)
 >
 >>>> KERNELBUG? FUTEX_LOCK_PI with timer returns ETIMEDOUT immediately
 >>>> KERNELBUG? FUTEX_LOCK_PI_PRIVATE with timer returns ETIMEDOUT 
immediately
 > The problem was in rtmutex.c. The code has changed, so it may be 
fixed now.
 >
 >>>> KERNELBUG? FUTEX_WAIT_BITSET with timer returns ETIMEDOUT immediately
 >>>> KERNELBUG? FUTEX_WAIT_BITSET_PRIVATE with timer returns ETIMEDOUT 
immediately
 > This doesn't seem to be fixed yet. I think it should be fixed by this 
diff to futex.c in version linux-2.6.32.3.
 > 2611c2611
 > <               if (cmd == FUTEX_WAIT)
 > ---
 >>               if ((cmd == FUTEX_WAIT) || (cmd == FUTEX_WAIT_BITSET))
 > The same change is needed for futex_compat.c.
 > 191c191
 > <               if (cmd == FUTEX_WAIT)
 > ---
 >>               if ((cmd == FUTEX_WAIT) || (cmd == FUTEX_WAIT_BITSET))
 >
 >>>> Test succeeded
 > It didn't find any problems that it didn't expect.
 >
 > Definitions of FUTEX_WAIT_BITSET_PRIVATE and 
FUTEX_WAKE_BITSET_PRIVATE were bad in linux/futex.h, but have been fixed 
in linux-2.6.32.3.
 >
 > The definition of FUTEX_OP in linux/futex.h doesn't protect against 
the actual arguments being expressions. Here is a safer one
 > #define FUTEX_OP(op, oparg, cmp, cmparg) \
 >   ((((op) & 0xf) << 28) | (((cmp) & 0xf) << 24)		\
 >    | (((oparg) & 0xfff) << 12) | ((cmparg) & 0xfff))
 >
 > Richard P. Parkins, M. A.
 > rparkins@undo-software.com
 >
 >
 >
 >
 >
 >


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
