Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab0CHWgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:36:46 -0500
Received: from mailbackup.inode.at ([213.229.60.24]:35691 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab0CHWgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:36:43 -0500
From: David Steiner <david@sicnarf.com>
To: linux-kernel@vger.kernel.org
Subject: Bug report: scheduling while atomic: md0_raid5 - 2.6.33-rt4
Date: Mon, 8 Mar 2010 23:33:49 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rt4; KDE/4.3.4; x86_64; ; )
Cc: Neil Brown <neilb@suse.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NtXlLE+xoYMY6HV"
Message-Id: <201003082333.49460.david@sicnarf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_NtXlLE+xoYMY6HV
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, I'm writing to report a problem that's occurring in the raid456 module. 
I'm running vanilla linux with real time patches applied 
(http://rt.wiki.kernel.org). 

Since I upgraded from 2.6.31.12-rt12 the following message comes frequently. 
Before there weren't such messages:

[193002.046563] BUG: scheduling while atomic: md0_raid5/0x00000001/809, CPU#1
[193002.046571] Modules linked in: i915 drm_kms_helper drm i2c_algo_bit video 
output ppdev lp parport xt_multiport iptable_filter ip_tables x_tables 
kvm_intel kvm fuse loop raw1394 arc4 ecb ath5k mac80211 ath cfg80211 psmouse 
usbhid rfkill hid i2c_i801 serio_raw evdev rng_core led_class i2c_core raid456 
md_mod async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx 
ide_gd_mod ata_generic ata_piix ide_pci_generic ahci libata ohci1394 piix 
uhci_hcd pdc202xx_new scsi_mod ieee1394 e1000e ehci_hcd ide_core intel_agp 
[last unloaded: scsi_wait_scan]
[193002.046664] Pid: 809, comm: md0_raid5 Not tainted 2.6.33-rt4 #1
[193002.046668] Call Trace:
[193002.046682]  [<ffffffff812fc212>] ? __schedule+0x83/0x7dd
[193002.046692]  [<ffffffff810680d3>] ? task_blocks_on_rt_mutex+0x14b/0x19f
[193002.046700]  [<ffffffff812fca5b>] ? schedule+0x10/0x22
[193002.046707]  [<ffffffff812fd582>] ? rt_spin_lock_slowlock+0x14b/0x234
[193002.046721]  [<ffffffffa01a0fcc>] ? release_stripe+0x1a/0x31 [raid456]
[193002.046730]  [<ffffffffa0156402>] ? async_xor+0x402/0x413 [async_xor]
[193002.046741]  [<ffffffffa0133991>] ? ide_do_rw_disk+0x217/0x299 [ide_gd_mod]
[193002.046751]  [<ffffffffa01a2fbd>] ? __raid_run_ops+0x961/0xb61 [raid456]
[193002.046761]  [<ffffffffa01a118d>] ? ops_complete_reconstruct+0x0/0x91 
[raid456]
[193002.046772]  [<ffffffffa01a56df>] ? handle_stripe+0x17aa/0x1815 [raid456]
[193002.046782]  [<ffffffffa01a5ae3>] ? raid5d+0x399/0x3da [raid456]
[193002.046796]  [<ffffffffa0187c50>] ? md_thread+0xf2/0x110 [md_mod]
[193002.046803]  [<ffffffff81058c12>] ? autoremove_wake_function+0x0/0x2a
[193002.046815]  [<ffffffffa0187b5e>] ? md_thread+0x0/0x110 [md_mod]
[193002.046823]  [<ffffffff81058880>] ? kthread+0x75/0x7d
[193002.046831]  [<ffffffff81036068>] ? finish_task_switch+0x49/0xc8
[193002.046839]  [<ffffffff81009824>] ? kernel_thread_helper+0x4/0x10
[193002.046847]  [<ffffffff8105880b>] ? kthread+0x0/0x7d
[193002.046853]  [<ffffffff81009820>] ? kernel_thread_helper+0x0/0x10

$ dmesg | grep BUG
[182968.276011] BUG: scheduling while atomic: md0_raid5/0x00000001/809, CPU#1
[.... 55 ommitted .....]
[193002.046563] BUG: scheduling while atomic: md0_raid5/0x00000001/809, CPU#1

$ cat /proc/version 
Linux version 2.6.33-rt4 (root@sandbox) (gcc version 4.4.3 (Debian 4.4.3-3) ) 
#1 SMP PREEMPT RT Sat Feb 27 22:35:34 CET 2010

According to Neil Brown, this problem was introduced by the real-time patches.

This is a root-on-raid5, 3 disk-IDE-attached setup. If you need any more info 
let me know.  Please CC me any replies as I'm not subscribed. 
Greetings,
David

--Boundary-00=_NtXlLE+xoYMY6HV
Content-Type: text/plain;
  charset="UTF-8";
  name="proc_cpuinfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc_cpuinfo"

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz
stepping	: 6
cpu MHz		: 1829.084
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips	: 3658.16
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz
stepping	: 6
cpu MHz		: 1829.084
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips	: 3656.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


--Boundary-00=_NtXlLE+xoYMY6HV
Content-Type: text/plain;
  charset="UTF-8";
  name="proc_iomem"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc_iomem"

00000000-0009e7ff : System RAM
0009e800-0009f7ff : RAM buffer
0009f800-0009ffff : reserved
000d0000-000d7fff : pnp 00:08
000da800-000dbfff : pnp 00:08
000e0000-000effff : pnp 00:08
000f0000-000fffff : reserved
00100000-7f7effff : System RAM
  01000000-01300904 : Kernel code
  01300905-016e991f : Kernel data
  0177f000-020effef : Kernel bss
7f7f0000-7f7f2fff : ACPI Non-volatile Storage
7f7f3000-7f7fffff : ACPI Tables
7f800000-7fffffff : RAM buffer
80000000-801fffff : PCI Bus 0000:01
80200000-803fffff : PCI Bus 0000:01
80400000-805fffff : PCI Bus 0000:02
80600000-806fffff : PCI Bus 0000:03
  80600000-80603fff : 0000:03:00.0
d0000000-dfffffff : 0000:00:02.0
e0000000-e1ffffff : PCI Bus 0000:03
  e1000000-e100ffff : 0000:03:01.0
    e1000000-e100ffff : ath5k
  e1010000-e1013fff : 0000:03:00.0
  e1014000-e1017fff : 0000:03:07.0
  e1018000-e10187ff : 0000:03:07.0
    e1018000-e10187ff : ohci1394
e2000000-e20fffff : PCI Bus 0000:02
  e2000000-e207ffff : 0000:02:00.0
    e2000000-e207ffff : e1000e
  e2080000-e209ffff : 0000:02:00.0
    e2080000-e209ffff : e1000e
e2100000-e217ffff : 0000:00:02.0
e2180000-e21bffff : 0000:00:02.0
e21c0000-e21c03ff : 0000:00:1d.7
  e21c0000-e21c03ff : ehci_hcd
e21c3000-e21c33ff : 0000:00:1f.2
  e21c3000-e21c33ff : ahci
f0000000-f3ffffff : reserved
  f0000000-f3ffffff : pnp 00:07
fec00000-ffffffff : reserved
  fec00000-fec003ff : IOAPIC 0
  fed13000-fed1dfff : pnp 00:08
  fed20000-fed8ffff : pnp 00:08
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:08
  ffb00000-ffb7ffff : pnp 00:08
  fff00000-ffffffff : pnp 00:08

--Boundary-00=_NtXlLE+xoYMY6HV
Content-Type: text/plain;
  charset="UTF-8";
  name="proc_ioports"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc_ioports"

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : piix
0290-029f : pnp 00:01
0376-0376 : 0000:00:1f.1
  0376-0376 : piix
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : piix
0400-047f : 0000:00:1f.0
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0428-042f : ACPI GPE0_BLK
0480-04bf : 0000:00:1f.0
04d0-04d1 : pnp 00:01
0500-051f : 0000:00:1f.3
  0500-051f : i801_smbus
0800-087f : pnp 00:01
0880-088f : pnp 00:01
0cf8-0cff : PCI conf1
7000-7fff : PCI Bus 0000:01
8000-8fff : PCI Bus 0000:02
  8000-801f : 0000:02:00.0
9000-afff : PCI Bus 0000:03
  9000-9007 : 0000:03:00.0
    9000-9007 : pdc202xx_new
  9400-9403 : 0000:03:00.0
    9400-9403 : pdc202xx_new
  9800-9807 : 0000:03:00.0
    9800-9807 : pdc202xx_new
  9c00-9c03 : 0000:03:00.0
    9c00-9c03 : pdc202xx_new
  a000-a00f : 0000:03:00.0
    a000-a00f : pdc202xx_new
b000-b01f : 0000:00:1d.0
  b000-b01f : uhci_hcd
b400-b41f : 0000:00:1d.1
  b400-b41f : uhci_hcd
b800-b81f : 0000:00:1d.2
  b800-b81f : uhci_hcd
bc00-bc1f : 0000:00:1d.3
  bc00-bc1f : uhci_hcd
c000-c007 : 0000:00:02.0
d400-d407 : 0000:00:1f.2
  d400-d407 : ahci
d800-d803 : 0000:00:1f.2
  d800-d803 : ahci
dc00-dc07 : 0000:00:1f.2
  dc00-dc07 : ahci
e000-e003 : 0000:00:1f.2
  e000-e003 : ahci
e400-e40f : 0000:00:1f.2
  e400-e40f : ahci
f000-f00f : 0000:00:1f.1
  f000-f00f : piix

--Boundary-00=_NtXlLE+xoYMY6HV
Content-Type: text/plain;
  charset="UTF-8";
  name="proc_modules"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc_modules"

i915 248967 2 - Live 0xffffffffa02f3000
drm_kms_helper 20195 1 i915, Live 0xffffffffa02e7000
drm 142884 3 i915,drm_kms_helper, Live 0xffffffffa02b0000
i2c_algo_bit 4241 1 i915, Live 0xffffffffa0159000
video 17973 1 i915, Live 0xffffffffa02a4000
output 1772 1 video, Live 0xffffffffa014c000
ppdev 5339 0 - Live 0xffffffffa0130000
lp 8942 0 - Live 0xffffffffa0171000
parport 26050 2 ppdev,lp, Live 0xffffffffa0295000
xt_multiport 2267 1 - Live 0xffffffffa00d1000
iptable_filter 2306 1 - Live 0xffffffffa00be000
ip_tables 13986 1 iptable_filter, Live 0xffffffffa028f000
x_tables 13121 2 xt_multiport,ip_tables, Live 0xffffffffa01fa000
kvm_intel 38301 0 - Live 0xffffffffa01d0000
kvm 228220 1 kvm_intel, Live 0xffffffffa023f000
fuse 50244 1 - Live 0xffffffffa0230000
loop 12149 0 - Live 0xffffffffa00a0000
raw1394 19196 14 - Live 0xffffffffa0077000
arc4 1306 2 - Live 0xffffffffa002a000
ecb 1857 2 - Live 0xffffffffa0021000
ath5k 133970 0 - Live 0xffffffffa0205000
mac80211 114376 1 ath5k, Live 0xffffffffa01dc000
ath 8210 1 ath5k, Live 0xffffffffa0129000
cfg80211 102679 3 ath5k,mac80211,ath, Live 0xffffffffa01b4000
psmouse 31856 0 - Live 0xffffffffa0197000
usbhid 30602 0 - Live 0xffffffffa0139000
rfkill 13058 1 cfg80211, Live 0xffffffffa0116000
hid 63699 1 usbhid, Live 0xffffffffa00f8000
i2c_i801 7606 0 - Live 0xffffffffa00a4000
serio_raw 3830 0 - Live 0xffffffffa0074000
evdev 7426 9 - Live 0xffffffffa005c000
rng_core 3158 0 - Live 0xffffffffa0038000
led_class 2433 1 ath5k, Live 0xffffffffa0027000
i2c_core 15277 5 i915,drm_kms_helper,drm,i2c_algo_bit,i2c_i801, Live 0xffffffffa0008000
raid456 43965 1 - Live 0xffffffffa01a0000
md_mod 76874 2 raid456, Live 0xffffffffa0182000
async_raid6_recov 4683 1 raid456, Live 0xffffffffa017b000
async_pq 3127 2 raid456,async_raid6_recov, Live 0xffffffffa0175000
raid6_pq 76962 2 async_raid6_recov,async_pq, Live 0xffffffffa015c000
async_xor 2185 3 raid456,async_raid6_recov,async_pq, Live 0xffffffffa0156000
xor 4364 1 async_xor, Live 0xffffffffa014f000
async_memcpy 1182 2 raid456,async_raid6_recov, Live 0xffffffffa0149000
async_tx 1670 5 raid456,async_raid6_recov,async_pq,async_xor,async_memcpy, Live 0xffffffffa0143000
ide_gd_mod 13804 6 - Live 0xffffffffa0133000
ata_generic 3063 0 - Live 0xffffffffa012d000
ata_piix 20445 0 - Live 0xffffffffa0122000
ide_pci_generic 2868 0 - Live 0xffffffffa011c000
ahci 31768 0 - Live 0xffffffffa010c000
libata 131806 3 ata_generic,ata_piix,ahci, Live 0xffffffffa00d5000
ohci1394 24041 7 - Live 0xffffffffa00c9000
piix 4680 1 - Live 0xffffffffa00c2000
uhci_hcd 18082 0 - Live 0xffffffffa00b7000
pdc202xx_new 3961 2 - Live 0xffffffffa00b1000
scsi_mod 124065 1 libata, Live 0xffffffffa007f000
ieee1394 60760 2 raw1394,ohci1394, Live 0xffffffffa0063000
e1000e 109765 0 - Live 0xffffffffa003c000
ehci_hcd 29464 0 - Live 0xffffffffa002e000
ide_core 72981 4 ide_gd_mod,ide_pci_generic,piix,pdc202xx_new, Live 0xffffffffa000d000
intel_agp 24256 1 - Live 0xffffffffa0000000

--Boundary-00=_NtXlLE+xoYMY6HV
Content-Type: text/plain;
  charset="UTF-8";
  name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci"

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
	Subsystem: Giga-byte Technology Device 5000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=09 <?>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
	Subsystem: Giga-byte Technology Device d000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e2100000 (32-bit, non-prefetchable) [size=512K]
	Region 1: I/O ports at c000 [size=8]
	Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 3: Memory at e2180000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: i915

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00007000-00007fff
	Memory behind bridge: 80000000-801fffff
	Prefetchable memory behind bridge: 0000000080200000-00000000803fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #16, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4159
	Capabilities: [90] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00008000-00008fff
	Memory behind bridge: e2000000-e20fffff
	Prefetchable memory behind bridge: 0000000080400000-00000000805fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #17, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4161
	Capabilities: [90] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at b000 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at b400 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at b800 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at bc00 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device 5006
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at e21c0000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
	I/O behind bridge: 00009000-0000afff
	Memory behind bridge: e0000000-e1ffffff
	Prefetchable memory behind bridge: 0000000080600000-00000000806fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000

00:1f.0 ISA bridge: Intel Corporation 82801GHM (ICH7-M DH) LPC Interface Bridge (rev 02)
	Subsystem: Giga-byte Technology Device 5001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Giga-byte Technology Device b001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at f000 [size=16]
	Kernel driver in use: PIIX_IDE

00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: Giga-byte Technology Device b005
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 27
	Region 0: I/O ports at d400 [size=8]
	Region 1: I/O ports at d800 [size=4]
	Region 2: I/O ports at dc00 [size=8]
	Region 3: I/O ports at e000 [size=4]
	Region 4: I/O ports at e400 [size=16]
	Region 5: Memory at e21c3000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4191
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
	Subsystem: Giga-byte Technology GA-8I945PG-RH Mainboard
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 0500 [size=32]
	Kernel driver in use: i801_smbus

02:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
	Subsystem: Giga-byte Technology Device e000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 26
	Region 0: Memory at e2080000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e2000000 (32-bit, non-prefetchable) [size=512K]
	Region 2: I/O ports at 8000 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41e1
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM unknown, Latency L0 <128ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Kernel driver in use: e1000e

03:00.0 Mass storage controller: Promise Technology, Inc. 20269 (rev 02) (prog-if 85)
	Subsystem: Promise Technology, Inc. Ultra133TX2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 4500ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at 9000 [size=8]
	Region 1: I/O ports at 9400 [size=4]
	Region 2: I/O ports at 9800 [size=8]
	Region 3: I/O ports at 9c00 [size=4]
	Region 4: I/O ports at a000 [size=16]
	Region 5: Memory at e1010000 (32-bit, non-prefetchable) [size=16K]
	[virtual] Expansion ROM at 80600000 [disabled] [size=16K]
	Capabilities: [60] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: Promise_IDE

03:01.0 Ethernet controller: Atheros Communications Inc. Atheros AR5001X+ Wireless Network Adapter (rev 01)
	Subsystem: D-Link System Inc D-Link AirPlus DWL-G520 Wireless PCI Adapter(rev.B)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at e1000000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: ath5k

03:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology GA-EP45-DS5 Motherboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at e1018000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at e1014000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ohci1394


--Boundary-00=_NtXlLE+xoYMY6HV
Content-Type: text/plain;
  charset="UTF-8";
  name="ver_linux"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ver_linux"

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux sandbox 2.6.33-rt4 #1 SMP PREEMPT RT Sat Feb 27 22:35:34 CET 2010 x86_64 GNU/Linux
 
Gnu C                  4.4.3
Gnu make               3.81
binutils               2.20
util-linux             ./scripts/ver_linux: 23: fdformat: not found
mount                  support
module-init-tools      found
Linux C Library        2.10.2
Dynamic linker (ldd)   2.10.2
Procps                 3.2.8
Kbd                    1.15.1
Sh-utils               8.4
Modules Loaded         i915 drm_kms_helper drm i2c_algo_bit video output ppdev lp parport xt_multiport iptable_filter ip_tables x_tables kvm_intel kvm fuse loop raw1394 arc4 ecb ath5k mac80211 ath cfg80211 psmouse usbhid rfkill hid i2c_i801 serio_raw evdev rng_core led_class i2c_core raid456 md_mod async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx ide_gd_mod ata_generic ata_piix ide_pci_generic ahci libata ohci1394 piix uhci_hcd pdc202xx_new scsi_mod ieee1394 e1000e ehci_hcd ide_core intel_agp

--Boundary-00=_NtXlLE+xoYMY6HV--
