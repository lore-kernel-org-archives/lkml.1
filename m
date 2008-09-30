Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYI3O1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYI3O1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYI3O1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:27:12 -0400
Received: from 184-111-204-62-static.cable.fcom.ch ([62.204.111.184]:53533
	"EHLO blinkeye.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYI3O1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:27:06 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2008 10:27:04 EDT
Message-ID: <2a91f0404ed398ad8ce242e6da3f7b1e.squirrel@blinkeye.ch>
Date: Tue, 30 Sep 2008 16:19:08 +0200 (CEST)
Subject: PROBLEM: processes claim CPU indefinitely on Intel(R) Core(TM)2 
     Quad
From: "Reto Glauser" <linux@blinkeye.ch>
To: "Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20080930161908_64929"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20080930161908_64929
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

[1.] One line summary of the problem
Processes claim CPU indefinitely on Intel(R) Core(TM)2 Quad CPU Q6600

[2.] Full description of the problem/report
Processes hang indefinitely (but might recover after 10min. or so) while executing
forked tasks like sed, touch, mv, uic (Qt), grep etc. The processes claim a CPU,
which may be for 2min. or 30min. and continue later on. This happens very often and
changing the preemption model does not make a difference (be it Preemptible Kernel
or Voluntary Kernel preemption). I cannot reproduce this bug with a Core(TM)2 Duo
with similar hardware and the same distribution (Gentoo x86_64).

Here's the command `touch' hanging:

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
16692 foobar  20   0  7816  408  312 R  100  0.0   6:03.72 touch

stracing above process showed that `touch' hang for 12 minutes and then simply
continued:

# strace -p 16692
Process 16692 attached - interrupt to quit
brk(0)                                  = 0x60d000
brk(0x62e000)                           = 0x62e000
close(0)                                = 0
open("./file66.txt", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK, 0666) = 0 utimensat(0,
NULL, NULL, 0)             = 0
close(0)                                = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
Process 16692 detached

Here's the output of /proc/16692/stat during above hang-time:

# while true; do cat /proc/16692/stat ; sleep 5; done
16692 (touch) R 22679 22677 7314 34821 22677 4194304 180 0 0 0 17803 2 0 0 20 0 1 0
15147700 8003584 102 18446744073709551615 4194304 4242292 140736481217664
18446744073709551615 140401332315429 0 0 0 0 0 0 0 17 3 0 0 0 0 0
16692 (touch) R 22679 22677 7314 34821 22677 4194304 180 0 0 0 18303 2 0 0 20 0 1 0
15147700 8003584 102 18446744073709551615 4194304 4242292 140736481217664
18446744073709551615 140401332315429 0 0 0 0 0 0 0 17 3 0 0 0 0 0
16692 (touch) R 22679 22677 7314 34821 22677 4194304 180 0 0 0 18803 2 0 0 20 0 1 0
15147700 8003584 102 18446744073709551615 4194304 4242292 140736481217664
18446744073709551615 140401332315429 0 0 0 0 0 0 0 17 3 0 0 0 0 0
16692 (touch) R 22679 22677 7314 34821 22677 4194304 180 0 0 0 19303 2 0 0 20 0 1 0
15147700 8003584 102 18446744073709551615 4194304 4242292 140736481217664
18446744073709551615 140401332315432 0 0 0 0 0 0 0 17 3 0 0 0 0 0
...

Another example is `sed' hanging for at least 16 minutes during distribution update:

PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7760 root      39  19  7768  360  256 R  100  0.0  16:57.61 sed

[3.] Keywords
scheduler, Intel(R) Core(TM)2 Quad CPU Q6600

[4.] Kernel information
[4.1.] Kernel version (from /proc/version)
Linux version 2.6.25-gentoo-r7 (root@quadux) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1))
#22 SMP PREEMPT Tue Sep 30 08:22:20 CEST 2008

[4.2.] Kernel .config file
see attachment

[5.] Most recent kernel version which did not have the bug
unkown. tried 2.6.24 through 2.6.26-r1

[7.] A small shell script or example program which triggers the problem
for i in `seq 0 9999`; do
	touch file.txt
	echo 1 > file.txt
done

[8.] Environment
[8.1.] Software
# /usr/src/linux/scripts/ver_linux

Linux quadux 2.6.25-gentoo-r7 #17 SMP Mon Sep 22 14:46:30 CEST 2008 x86_64 Intel(R)
Core(TM)2 Quad CPU Q6600 @ 2.40GHz GenuineIntel GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.18
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.40.9
reiserfsprogs          3.6.19
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.10
udev                   124
Modules Loaded         coretemp it87 hwmon_vid fglrx i2c_i801

[8.2.] Processor information:
# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2400.000
cache size      : 4096 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc
pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm bogomips
    : 4802.65
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2400.000
cache size      : 4096 KB
physical id     : 0
siblings        : 3
core id         : 2
cpu cores       : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc
arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr
lahf_lm
bogomips        : 4799.90
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2400.000
cache size      : 0 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc
pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm bogomips
    : 4799.88
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2400.000
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc
arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr
lahf_lm
bogomips        : 4799.87
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:



[8.3.] Module information:
# cat /proc/modules
coretemp 7808 0 - Live 0xffffffff881dc000
it87 26712 0 - Live 0xffffffff881d4000
hwmon_vid 3968 1 it87, Live 0xffffffff881d2000
fglrx 1885248 44 - Live 0xffffffff88004000 (P)
i2c_i801 10780 0 - Live 0xffffffff88000000

[8.4.] Loaded driver and hardware information
# cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0290-029f : pnp 00:01
  0290-0294 : pnp 00:01
  0295-0296 : it87
    0295-0296 : it87
03c0-03df : vesafb
03f2-03f5 : floppy
03f7-03f7 : floppy DIR
03f8-03ff : serial
0400-047f : 0000:00:1f.0
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0420-042f : ACPI GPE0_BLK
0480-04bf : 0000:00:1f.0
04d0-04d1 : pnp 00:01
0500-051f : 0000:00:1f.3
  0500-051f : i801_smbus
0800-087f : pnp 00:01
0880-088f : pnp 00:01
0cf8-0cff : PCI conf1
8000-8fff : PCI Bus #02
9000-9fff : PCI Bus #01
  9000-90ff : 0000:01:00.0
a000-afff : PCI Bus #03
  a000-a007 : 0000:03:00.1
  a100-a103 : 0000:03:00.1
  a200-a207 : 0000:03:00.1
  a300-a303 : 0000:03:00.1
  a400-a40f : 0000:03:00.1
    a400-a407 : ide0
    a408-a40f : ide1
b000-bfff : PCI Bus #04
  b000-b0ff : 0000:04:00.0
    b000-b0ff : r8169
c000-cfff : PCI Bus #05
  c000-c07f : 0000:05:02.0
    c000-c07f : typhoon
d000-d01f : 0000:00:1a.0
  d000-d01f : uhci_hcd
d100-d11f : 0000:00:1a.1
  d100-d11f : uhci_hcd
d200-d21f : 0000:00:1d.0
  d200-d21f : uhci_hcd
d300-d31f : 0000:00:1d.1
  d300-d31f : uhci_hcd
d400-d41f : 0000:00:1d.2
  d400-d41f : uhci_hcd
d500-d51f : 0000:00:1a.2
  d500-d51f : uhci_hcd
d600-d607 : 0000:00:1f.2
  d600-d607 : ata_piix
d700-d703 : 0000:00:1f.2
  d700-d703 : ata_piix
d800-d807 : 0000:00:1f.2
  d800-d807 : ata_piix
d900-d903 : 0000:00:1f.2
  d900-d903 : ata_piix
da00-da0f : 0000:00:1f.2
  da00-da0f : ata_piix
db00-db0f : 0000:00:1f.2
  db00-db0f : ata_piix
dd00-dd07 : 0000:00:1f.5
  dd00-dd07 : ata_piix
de00-de03 : 0000:00:1f.5
  de00-de03 : ata_piix
df00-df07 : 0000:00:1f.5
  df00-df07 : ata_piix
e000-e003 : 0000:00:1f.5
  e000-e003 : ata_piix
e100-e10f : 0000:00:1f.5
  e100-e10f : ata_piix
e200-e20f : 0000:00:1f.5
  e200-e20f : ata_piix

# cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000d3000-000d3fff : pnp 00:0c
000e0000-000effff : pnp 00:0c
000f0000-000fffff : reserved
00100000-dfedffff : System RAM
  00200000-006f7225 : Kernel code
  006f7226-00921407 : Kernel data
  009a5000-00a21ea7 : Kernel bss
dfee0000-dfee2fff : ACPI Non-volatile Storage
dfee3000-dfeeffff : ACPI Tables
dfef0000-dfefffff : reserved
e0000000-efffffff : PCI Bus #01
  e0000000-efffffff : 0000:01:00.0
    e0000000-e0ffffff : vesafb
f0000000-f3ffffff : PCI MMCONFIG 0
  f0000000-f3ffffff : reserved
f4000000-f5ffffff : PCI Bus #01
  f4000000-f401ffff : 0000:01:00.0
  f5000000-f500ffff : 0000:01:00.0
  f5010000-f501ffff : 0000:01:00.1
f6000000-f7ffffff : PCI Bus #04
  f7000000-f7000fff : 0000:04:00.0
    f7000000-f7000fff : r8169
f8000000-f80fffff : PCI Bus #03
  f8000000-f8001fff : 0000:03:00.0
    f8000000-f8001fff : ahci
f8100000-f81fffff : PCI Bus #05
  f8100000-f813ffff : 0000:05:02.0
    f8100000-f813ffff : typhoon
f8200000-f8203fff : 0000:00:1b.0
  f8200000-f8203fff : ICH HD audio
f8204000-f82043ff : 0000:00:1d.7
  f8204000-f82043ff : ehci_hcd
f8205000-f82053ff : 0000:00:1a.7
  f8205000-f82053ff : ehci_hcd
f8206000-f82060ff : 0000:00:1f.3
f8300000-f83fffff : PCI Bus #04
  f8300000-f831ffff : 0000:04:00.0
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : pnp 00:0c
fed00000-fed003ff : HPET 0
fed10000-fed1dfff : pnp 00:0c
fed20000-fed8ffff : pnp 00:0c
fee00000-fee00fff : Local APIC
ffb00000-ffb7ffff : pnp 00:0c
fff00000-ffffffff : pnp 00:0c
100000000-19fffffff : System RAM

[8.5.] PCI information
# lspci -vv
00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
        Subsystem: Giga-byte Technology Device 5000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information <?>

00:01.0 PCI bridge: Intel Corporation PCI Express Root Port (rev 02) (prog-if 00
[Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0 I/O behind
bridge: 00009000-00009fff
        Memory behind bridge: f4000000-f5ffffff
        Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort-
<SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [88] Subsystem: Giga-byte Technology Device 5000 Capabilities:
[80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable+
                Address: fee0f00c  Data: 4159
        Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1
<1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- MaxPayload 128
bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s, Latency L0
<256ns, L1 <64us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
                        Slot # 20, PowerLimit 75.000000; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
LinkChg-
                        Control: AttnInd Off, PwrInd On, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [140] Root Complex Link <?>
        Kernel driver in use: pcieport-driver

00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 02) (prog-if
00 [UHCI])
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at d000 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 02) (prog-if
00 [UHCI])
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at d100 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation USB UHCI Controller #6 (rev 02) (prog-if
00 [UHCI])
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at d500 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 02) (prog-if
20 [EHCI])
        Subsystem: Giga-byte Technology Device 5006
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at f8205000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation HD Audio Controller (rev 02)
        Subsystem: Giga-byte Technology Device a002
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at f8200000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1
<1us
                        ExtTag- RBE- FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ MaxPayload 128
bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [130] Root Complex Link <?>
        Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation PCI Express Port 1 (rev 02) (prog-if 00
[Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0 I/O behind
bridge: 00008000-00008fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1
<1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- MaxPayload 128
bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <1us, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
                        Slot # 10, PowerLimit 10.000000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable-
                Address: fee0f00c  Data: 4161
        Capabilities: [90] Subsystem: Giga-byte Technology Device 5001 Capabilities:
[a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver

00:1c.3 PCI bridge: Intel Corporation PCI Express Port 4 (rev 02) (prog-if 00
[Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0 I/O behind
bridge: 0000a000-0000afff
        Memory behind bridge: f8000000-f80fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1
<1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- MaxPayload 128
bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0
<256ns, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
                        Slot # 13, PowerLimit 10.000000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable-
                Address: fee0f00c  Data: 4169
        Capabilities: [90] Subsystem: Giga-byte Technology Device 5001 Capabilities:
[a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver

00:1c.4 PCI bridge: Intel Corporation PCI Express Port 5 (rev 02) (prog-if 00
[Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0 I/O behind
bridge: 0000b000-0000bfff
        Memory behind bridge: f6000000-f7ffffff
        Prefetchable memory behind bridge: 00000000f8300000-00000000f83fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort-
<SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1
<1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- MaxPayload 128
bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #5, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0
<256ns, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
                        Slot # 14, PowerLimit 10.000000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable-
                Address: fee0f00c  Data: 4171
        Capabilities: [90] Subsystem: Giga-byte Technology Device 5001 Capabilities:
[a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver

00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 02) (prog-if
00 [UHCI])
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at d200 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 02) (prog-if
00 [UHCI])
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at d300 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 02) (prog-if
00 [UHCI])
        Subsystem: Giga-byte Technology Device 5004
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at d400 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 02) (prog-if
20 [EHCI])
        Subsystem: Giga-byte Technology Device 5006
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at f8204000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 01
[Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=32 I/O behind
bridge: 0000c000-0000cfff
        Memory behind bridge: f8100000-f81fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Subsystem: Giga-byte Technology Device 5000

00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
        Subsystem: Giga-byte Technology Device 5001
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information <?>

00:1f.2 IDE interface: Intel Corporation 4 port SATA IDE Controller (rev 02)
(prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: Giga-byte Technology Device b002
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at d600 [size=8]
        Region 1: I/O ports at d700 [size=4]
        Region 2: I/O ports at d800 [size=8]
        Region 3: I/O ports at d900 [size=4]
        Region 4: I/O ports at da00 [size=16]
        Region 5: I/O ports at db00 [size=16]
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [b0] PCIe advanced features <?>
        Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
        Subsystem: Giga-byte Technology Device 5001
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at f8206000 (64-bit, non-prefetchable) [size=256] Region 4:
I/O ports at 0500 [size=32]
        Kernel driver in use: i801_smbus
        Kernel modules: i2c-i801

00:1f.5 IDE interface: Intel Corporation 2 port SATA IDE Controller (rev 02)
(prog-if 85 [Master SecO PriO])
        Subsystem: Giga-byte Technology Device b002
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at dd00 [size=8]
        Region 1: I/O ports at de00 [size=4]
        Region 2: I/O ports at df00 [size=8]
        Region 3: I/O ports at e000 [size=4]
        Region 4: I/O ports at e100 [size=16]
        Region 5: I/O ports at e200 [size=16]
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [b0] PCIe advanced features <?>
        Kernel driver in use: ata_piix

01:00.0 VGA compatible controller: ATI Technologies Inc RV515GL [FireGL V3350]
(prog-if 00 [VGA controller])
        Subsystem: ATI Technologies Inc Device 1b02
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at e0000000 (64-bit, prefetchable) [size=256M] Region 2:
Memory at f5000000 (64-bit, non-prefetchable) [size=64K] Region 4: I/O ports at 9000
[size=256]
        [virtual] Expansion ROM at f4000000 [disabled] [size=128K] Capabilities:
[50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1
unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ MaxPayload 128
bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
                Address: 0000000000000000  Data: 0000
        Kernel driver in use: fglrx_pci
        Kernel modules: fglrx

01:00.1 Display controller: ATI Technologies Inc RV515GL [FireGL V3350] (Secondary)
        Subsystem: ATI Technologies Inc Device 1b03
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Region 0: Memory at f5010000 (64-bit, non-prefetchable) [size=64K]
Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1
unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- MaxPayload 128
bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-

03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI
Controller (rev 02) (prog-if 01 [AHCI 1.0])
        Subsystem: Giga-byte Technology Device b000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 19
        Region 5: Memory at f8000000 (32-bit, non-prefetchable) [size=8K]
Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1
<1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- MaxPayload 128
bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0
unlimited, L1 unlimited
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
        Kernel driver in use: ahci

03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI
Controller (rev 02) (prog-if 85 [Master SecO PriO])
        Subsystem: Giga-byte Technology Device b000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin B routed to IRQ 16
        Region 0: I/O ports at a000 [size=8]
        Region 1: I/O ports at a100 [size=4]
        Region 2: I/O ports at a200 [size=8]
        Region 3: I/O ports at a300 [size=4]
        Region 4: I/O ports at a400 [size=16]
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: JMicron IDE

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
Express Gigabit Ethernet controller (rev 01)
        Subsystem: Giga-byte Technology Device e000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 507
        Region 0: I/O ports at b000 [size=256]
        Region 2: Memory at f7000000 (64-bit, non-prefetchable) [size=4K] [virtual]
Expansion ROM at f8300000 [disabled] [size=128K] Capabilities: [40] Power Management
version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data <?>
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1
Enable+
                Address: 00000000fee0f00c  Data: 4181
        Capabilities: [60] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <128ns, L1
unlimited
                        ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ MaxPayload 128
bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0
unlimited, L1 unlimited
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
        Capabilities: [84] Vendor Specific Information <?>
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [12c] Virtual Channel <?>
        Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-00-00
Capabilities: [154] Power Budgeting <?>
        Kernel driver in use: r8169

05:02.0 Ethernet controller: 3Com Corporation 3CR990-TX-95 [Typhoon 56-bit] (rev 02)
        Subsystem: 3Com Corporation 3CR990-TX-95 [Typhoon 56-bit]
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at c000 [size=128]
        Region 1: Memory at f8100000 (32-bit, non-prefetchable) [size=256K]
Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D3 PME-Enable+ DSel=0 DScale=0 PME-
        Kernel driver in use: typhoon

[8.6.] SCSI information
# cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3250410AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: BD-RE  GGW-H20L  Rev: YL02
  Type:   CD-ROM                           ANSI  SCSI revision: 05



------=_20080930161908_64929
Content-Type: application/octet-stream; name=".config"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=".config"

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMgTGlu
dXgga2VybmVsIHZlcnNpb246IDIuNi4yNS1nZW50b28tcjcKIyBUdWUgU2VwIDMwIDA4OjIxOjMw
IDIwMDgKIwpDT05GSUdfNjRCSVQ9eQojIENPTkZJR19YODZfMzIgaXMgbm90IHNldApDT05GSUdf
WDg2XzY0PXkKQ09ORklHX1g4Nj15CkNPTkZJR19BUkNIX0RFRkNPTkZJRz0iYXJjaC94ODYvY29u
Zmlncy94ODZfNjRfZGVmY29uZmlnIgojIENPTkZJR19HRU5FUklDX0xPQ0tCUkVBSyBpcyBub3Qg
c2V0CkNPTkZJR19HRU5FUklDX1RJTUU9eQpDT05GSUdfR0VORVJJQ19DTU9TX1VQREFURT15CkNP
TkZJR19DTE9DS1NPVVJDRV9XQVRDSERPRz15CkNPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRTPXkK
Q09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfQlJPQURDQVNUPXkKQ09ORklHX0xPQ0tERVBfU1VQ
UE9SVD15CkNPTkZJR19TVEFDS1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfSEFWRV9MQVRFTkNZVE9Q
X1NVUFBPUlQ9eQpDT05GSUdfU0VNQVBIT1JFX1NMRUVQRVJTPXkKQ09ORklHX0ZBU1RfQ01QWENI
R19MT0NBTD15CkNPTkZJR19NTVU9eQpDT05GSUdfWk9ORV9ETUE9eQpDT05GSUdfR0VORVJJQ19J
U0FfRE1BPXkKQ09ORklHX0dFTkVSSUNfSU9NQVA9eQpDT05GSUdfR0VORVJJQ19CVUc9eQpDT05G
SUdfR0VORVJJQ19IV0VJR0hUPXkKIyBDT05GSUdfR0VORVJJQ19HUElPIGlzIG5vdCBzZXQKQ09O
RklHX0FSQ0hfTUFZX0hBVkVfUENfRkRDPXkKQ09ORklHX0RNST15CkNPTkZJR19SV1NFTV9HRU5F
UklDX1NQSU5MT0NLPXkKIyBDT05GSUdfUldTRU1fWENIR0FERF9BTEdPUklUSE0gaXMgbm90IHNl
dAojIENPTkZJR19BUkNIX0hBU19JTE9HMl9VMzIgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0hB
U19JTE9HMl9VNjQgaXMgbm90IHNldApDT05GSUdfQVJDSF9IQVNfQ1BVX0lETEVfV0FJVD15CkNP
TkZJR19HRU5FUklDX0NBTElCUkFURV9ERUxBWT15CkNPTkZJR19HRU5FUklDX1RJTUVfVlNZU0NB
TEw9eQpDT05GSUdfQVJDSF9IQVNfQ1BVX1JFTEFYPXkKQ09ORklHX0hBVkVfU0VUVVBfUEVSX0NQ
VV9BUkVBPXkKQ09ORklHX0FSQ0hfSElCRVJOQVRJT05fUE9TU0lCTEU9eQpDT05GSUdfQVJDSF9T
VVNQRU5EX1BPU1NJQkxFPXkKQ09ORklHX1pPTkVfRE1BMzI9eQpDT05GSUdfQVJDSF9QT1BVTEFU
RVNfTk9ERV9NQVA9eQpDT05GSUdfQVVESVRfQVJDSD15CkNPTkZJR19BUkNIX1NVUFBPUlRTX0FP
VVQ9eQpDT05GSUdfR0VORVJJQ19IQVJESVJRUz15CkNPTkZJR19HRU5FUklDX0lSUV9QUk9CRT15
CkNPTkZJR19HRU5FUklDX1BFTkRJTkdfSVJRPXkKQ09ORklHX1g4Nl9TTVA9eQpDT05GSUdfWDg2
XzY0X1NNUD15CkNPTkZJR19YODZfSFQ9eQpDT05GSUdfWDg2X1RSQU1QT0xJTkU9eQojIENPTkZJ
R19LVElNRV9TQ0FMQVIgaXMgbm90IHNldApDT05GSUdfREVGQ09ORklHX0xJU1Q9Ii9saWIvbW9k
dWxlcy8kVU5BTUVfUkVMRUFTRS8uY29uZmlnIgoKIwojIEdlbmVyYWwgc2V0dXAKIwpDT05GSUdf
RVhQRVJJTUVOVEFMPXkKQ09ORklHX0xPQ0tfS0VSTkVMPXkKQ09ORklHX0lOSVRfRU5WX0FSR19M
SU1JVD0zMgpDT05GSUdfTE9DQUxWRVJTSU9OPSIiCkNPTkZJR19MT0NBTFZFUlNJT05fQVVUTz15
CkNPTkZJR19TV0FQPXkKQ09ORklHX1NZU1ZJUEM9eQpDT05GSUdfU1lTVklQQ19TWVNDVEw9eQpD
T05GSUdfUE9TSVhfTVFVRVVFPXkKQ09ORklHX0JTRF9QUk9DRVNTX0FDQ1Q9eQpDT05GSUdfQlNE
X1BST0NFU1NfQUNDVF9WMz15CiMgQ09ORklHX1RBU0tTVEFUUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0FVRElUIGlzIG5vdCBzZXQKQ09ORklHX0lLQ09ORklHPXkKQ09ORklHX0lLQ09ORklHX1BST0M9
eQpDT05GSUdfTE9HX0JVRl9TSElGVD0xNwojIENPTkZJR19DR1JPVVBTIGlzIG5vdCBzZXQKIyBD
T05GSUdfR1JPVVBfU0NIRUQgaXMgbm90IHNldApDT05GSUdfU1lTRlNfREVQUkVDQVRFRD15CkNP
TkZJR19TWVNGU19ERVBSRUNBVEVEX1YyPXkKQ09ORklHX1JFTEFZPXkKQ09ORklHX05BTUVTUEFD
RVM9eQpDT05GSUdfVVRTX05TPXkKQ09ORklHX0lQQ19OUz15CiMgQ09ORklHX1VTRVJfTlMgaXMg
bm90IHNldAojIENPTkZJR19QSURfTlMgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9JTklUUkQ9
eQpDT05GSUdfSU5JVFJBTUZTX1NPVVJDRT0iIgojIENPTkZJR19DQ19PUFRJTUlaRV9GT1JfU0la
RSBpcyBub3Qgc2V0CkNPTkZJR19TWVNDVEw9eQojIENPTkZJR19FTUJFRERFRCBpcyBub3Qgc2V0
CkNPTkZJR19VSUQxNj15CkNPTkZJR19TWVNDVExfU1lTQ0FMTD15CkNPTkZJR19LQUxMU1lNUz15
CiMgQ09ORklHX0tBTExTWU1TX0VYVFJBX1BBU1MgaXMgbm90IHNldApDT05GSUdfSE9UUExVRz15
CkNPTkZJR19QUklOVEs9eQpDT05GSUdfQlVHPXkKQ09ORklHX0VMRl9DT1JFPXkKQ09ORklHX0NP
TVBBVF9CUks9eQpDT05GSUdfQkFTRV9GVUxMPXkKQ09ORklHX0ZVVEVYPXkKQ09ORklHX0FOT05f
SU5PREVTPXkKQ09ORklHX0VQT0xMPXkKQ09ORklHX1NJR05BTEZEPXkKQ09ORklHX1RJTUVSRkQ9
eQpDT05GSUdfRVZFTlRGRD15CkNPTkZJR19TSE1FTT15CkNPTkZJR19WTV9FVkVOVF9DT1VOVEVS
Uz15CkNPTkZJR19TTEFCPXkKIyBDT05GSUdfU0xVQiBpcyBub3Qgc2V0CiMgQ09ORklHX1NMT0Ig
aXMgbm90IHNldAojIENPTkZJR19QUk9GSUxJTkcgaXMgbm90IHNldAojIENPTkZJR19NQVJLRVJT
IGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfT1BST0ZJTEU9eQojIENPTkZJR19LUFJPQkVTIGlzIG5v
dCBzZXQKQ09ORklHX0hBVkVfS1BST0JFUz15CkNPTkZJR19IQVZFX0tSRVRQUk9CRVM9eQpDT05G
SUdfUFJPQ19QQUdFX01PTklUT1I9eQpDT05GSUdfU0xBQklORk89eQpDT05GSUdfUlRfTVVURVhF
Uz15CiMgQ09ORklHX1RJTllfU0hNRU0gaXMgbm90IHNldApDT05GSUdfQkFTRV9TTUFMTD0wCkNP
TkZJR19NT0RVTEVTPXkKQ09ORklHX01PRFVMRV9VTkxPQUQ9eQpDT05GSUdfTU9EVUxFX0ZPUkNF
X1VOTE9BRD15CiMgQ09ORklHX01PRFZFUlNJT05TIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9EVUxF
X1NSQ1ZFUlNJT05fQUxMIGlzIG5vdCBzZXQKQ09ORklHX0tNT0Q9eQpDT05GSUdfU1RPUF9NQUNI
SU5FPXkKQ09ORklHX0JMT0NLPXkKIyBDT05GSUdfQkxLX0RFVl9JT19UUkFDRSBpcyBub3Qgc2V0
CiMgQ09ORklHX0JMS19ERVZfQlNHIGlzIG5vdCBzZXQKQ09ORklHX0JMT0NLX0NPTVBBVD15Cgoj
CiMgSU8gU2NoZWR1bGVycwojCkNPTkZJR19JT1NDSEVEX05PT1A9eQpDT05GSUdfSU9TQ0hFRF9B
Uz15CkNPTkZJR19JT1NDSEVEX0RFQURMSU5FPXkKQ09ORklHX0lPU0NIRURfQ0ZRPXkKQ09ORklH
X0RFRkFVTFRfQVM9eQojIENPTkZJR19ERUZBVUxUX0RFQURMSU5FIGlzIG5vdCBzZXQKIyBDT05G
SUdfREVGQVVMVF9DRlEgaXMgbm90IHNldAojIENPTkZJR19ERUZBVUxUX05PT1AgaXMgbm90IHNl
dApDT05GSUdfREVGQVVMVF9JT1NDSEVEPSJhbnRpY2lwYXRvcnkiCkNPTkZJR19DTEFTU0lDX1JD
VT15CgojCiMgUHJvY2Vzc29yIHR5cGUgYW5kIGZlYXR1cmVzCiMKIyBDT05GSUdfVElDS19PTkVT
SE9UIGlzIG5vdCBzZXQKIyBDT05GSUdfTk9fSFogaXMgbm90IHNldAojIENPTkZJR19ISUdIX1JF
U19USU1FUlMgaXMgbm90IHNldApDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UU19CVUlMRD15CkNP
TkZJR19TTVA9eQpDT05GSUdfWDg2X1BDPXkKIyBDT05GSUdfWDg2X0VMQU4gaXMgbm90IHNldAoj
IENPTkZJR19YODZfVk9ZQUdFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9OVU1BUSBpcyBub3Qg
c2V0CiMgQ09ORklHX1g4Nl9TVU1NSVQgaXMgbm90IHNldAojIENPTkZJR19YODZfQklHU01QIGlz
IG5vdCBzZXQKIyBDT05GSUdfWDg2X1ZJU1dTIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X0dFTkVS
SUNBUkNIIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X0VTNzAwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X1g4Nl9SREMzMjFYIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1ZTTVAgaXMgbm90IHNldAojIENP
TkZJR19QQVJBVklSVF9HVUVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX00zODYgaXMgbm90IHNldAoj
IENPTkZJR19NNDg2IGlzIG5vdCBzZXQKIyBDT05GSUdfTTU4NiBpcyBub3Qgc2V0CiMgQ09ORklH
X001ODZUU0MgaXMgbm90IHNldAojIENPTkZJR19NNTg2TU1YIGlzIG5vdCBzZXQKIyBDT05GSUdf
TTY4NiBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVNSUkgaXMgbm90IHNldAojIENPTkZJR19N
UEVOVElVTUlJSSBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVNTSBpcyBub3Qgc2V0CiMgQ09O
RklHX01QRU5USVVNNCBpcyBub3Qgc2V0CiMgQ09ORklHX01LNiBpcyBub3Qgc2V0CiMgQ09ORklH
X01LNyBpcyBub3Qgc2V0CiMgQ09ORklHX01LOCBpcyBub3Qgc2V0CiMgQ09ORklHX01DUlVTT0Ug
aXMgbm90IHNldAojIENPTkZJR19NRUZGSUNFT04gaXMgbm90IHNldAojIENPTkZJR19NV0lOQ0hJ
UEM2IGlzIG5vdCBzZXQKIyBDT05GSUdfTVdJTkNISVAyIGlzIG5vdCBzZXQKIyBDT05GSUdfTVdJ
TkNISVAzRCBpcyBub3Qgc2V0CiMgQ09ORklHX01HRU9ERUdYMSBpcyBub3Qgc2V0CiMgQ09ORklH
X01HRU9ERV9MWCBpcyBub3Qgc2V0CiMgQ09ORklHX01DWVJJWElJSSBpcyBub3Qgc2V0CiMgQ09O
RklHX01WSUFDM18yIGlzIG5vdCBzZXQKIyBDT05GSUdfTVZJQUM3IGlzIG5vdCBzZXQKIyBDT05G
SUdfTVBTQyBpcyBub3Qgc2V0CkNPTkZJR19NQ09SRTI9eQojIENPTkZJR19HRU5FUklDX0NQVSBp
cyBub3Qgc2V0CkNPTkZJR19YODZfTDFfQ0FDSEVfQllURVM9NjQKQ09ORklHX1g4Nl9JTlRFUk5P
REVfQ0FDSEVfQllURVM9NjQKQ09ORklHX1g4Nl9DTVBYQ0hHPXkKQ09ORklHX1g4Nl9MMV9DQUNI
RV9TSElGVD02CkNPTkZJR19YODZfR09PRF9BUElDPXkKQ09ORklHX1g4Nl9JTlRFTF9VU0VSQ09Q
WT15CkNPTkZJR19YODZfVVNFX1BQUk9fQ0hFQ0tTVU09eQpDT05GSUdfWDg2X1A2X05PUD15CkNP
TkZJR19YODZfVFNDPXkKQ09ORklHX1g4Nl9NSU5JTVVNX0NQVV9GQU1JTFk9NjQKQ09ORklHX1g4
Nl9ERUJVR0NUTE1TUj15CkNPTkZJR19IUEVUX1RJTUVSPXkKQ09ORklHX0hQRVRfRU1VTEFURV9S
VEM9eQpDT05GSUdfR0FSVF9JT01NVT15CiMgQ09ORklHX0NBTEdBUllfSU9NTVUgaXMgbm90IHNl
dApDT05GSUdfSU9NTVVfSEVMUEVSPXkKQ09ORklHX1NXSU9UTEI9eQpDT05GSUdfTlJfQ1BVUz04
CiMgQ09ORklHX1NDSEVEX1NNVCBpcyBub3Qgc2V0CkNPTkZJR19TQ0hFRF9NQz15CiMgQ09ORklH
X1BSRUVNUFRfTk9ORSBpcyBub3Qgc2V0CiMgQ09ORklHX1BSRUVNUFRfVk9MVU5UQVJZIGlzIG5v
dCBzZXQKQ09ORklHX1BSRUVNUFQ9eQojIENPTkZJR19QUkVFTVBUX1JDVSBpcyBub3Qgc2V0CkNP
TkZJR19YODZfTE9DQUxfQVBJQz15CkNPTkZJR19YODZfSU9fQVBJQz15CkNPTkZJR19YODZfTUNF
PXkKQ09ORklHX1g4Nl9NQ0VfSU5URUw9eQojIENPTkZJR19YODZfTUNFX0FNRCBpcyBub3Qgc2V0
CiMgQ09ORklHX0k4SyBpcyBub3Qgc2V0CiMgQ09ORklHX01JQ1JPQ09ERSBpcyBub3Qgc2V0CkNP
TkZJR19YODZfTVNSPXkKQ09ORklHX1g4Nl9DUFVJRD15CiMgQ09ORklHX05VTUEgaXMgbm90IHNl
dApDT05GSUdfQVJDSF9TUEFSU0VNRU1fREVGQVVMVD15CkNPTkZJR19BUkNIX1NQQVJTRU1FTV9F
TkFCTEU9eQpDT05GSUdfQVJDSF9TRUxFQ1RfTUVNT1JZX01PREVMPXkKQ09ORklHX1NFTEVDVF9N
RU1PUllfTU9ERUw9eQojIENPTkZJR19GTEFUTUVNX01BTlVBTCBpcyBub3Qgc2V0CiMgQ09ORklH
X0RJU0NPTlRJR01FTV9NQU5VQUwgaXMgbm90IHNldApDT05GSUdfU1BBUlNFTUVNX01BTlVBTD15
CkNPTkZJR19TUEFSU0VNRU09eQpDT05GSUdfSEFWRV9NRU1PUllfUFJFU0VOVD15CiMgQ09ORklH
X1NQQVJTRU1FTV9TVEFUSUMgaXMgbm90IHNldApDT05GSUdfU1BBUlNFTUVNX0VYVFJFTUU9eQpD
T05GSUdfU1BBUlNFTUVNX1ZNRU1NQVBfRU5BQkxFPXkKQ09ORklHX1NQQVJTRU1FTV9WTUVNTUFQ
PXkKCiMKIyBNZW1vcnkgaG90cGx1ZyBpcyBjdXJyZW50bHkgaW5jb21wYXRpYmxlIHdpdGggU29m
dHdhcmUgU3VzcGVuZAojCkNPTkZJR19TUExJVF9QVExPQ0tfQ1BVUz00CkNPTkZJR19SRVNPVVJD
RVNfNjRCSVQ9eQpDT05GSUdfWk9ORV9ETUFfRkxBRz0xCkNPTkZJR19CT1VOQ0U9eQpDT05GSUdf
VklSVF9UT19CVVM9eQpDT05GSUdfTVRSUj15CiMgQ09ORklHX0VGSSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFQ0NPTVAgaXMgbm90IHNldAojIENPTkZJR19IWl8xMDAgaXMgbm90IHNldAojIENPTkZJ
R19IWl8yNTAgaXMgbm90IHNldAojIENPTkZJR19IWl8zMDAgaXMgbm90IHNldApDT05GSUdfSFpf
MTAwMD15CkNPTkZJR19IWj0xMDAwCiMgQ09ORklHX1NDSEVEX0hSVElDSyBpcyBub3Qgc2V0CkNP
TkZJR19LRVhFQz15CiMgQ09ORklHX0NSQVNIX0RVTVAgaXMgbm90IHNldApDT05GSUdfUEhZU0lD
QUxfU1RBUlQ9MHgyMDAwMDAKIyBDT05GSUdfUkVMT0NBVEFCTEUgaXMgbm90IHNldApDT05GSUdf
UEhZU0lDQUxfQUxJR049MHgyMDAwMDAKQ09ORklHX0hPVFBMVUdfQ1BVPXkKIyBDT05GSUdfQ09N
UEFUX1ZEU08gaXMgbm90IHNldApDT05GSUdfQVJDSF9FTkFCTEVfTUVNT1JZX0hPVFBMVUc9eQoK
IwojIFBvd2VyIG1hbmFnZW1lbnQgb3B0aW9ucwojCkNPTkZJR19BUkNIX0hJQkVSTkFUSU9OX0hF
QURFUj15CkNPTkZJR19QTT15CiMgQ09ORklHX1BNX0xFR0FDWSBpcyBub3Qgc2V0CiMgQ09ORklH
X1BNX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1BNX1NMRUVQX1NNUD15CkNPTkZJR19QTV9TTEVF
UD15CkNPTkZJR19TVVNQRU5EPXkKQ09ORklHX1NVU1BFTkRfRlJFRVpFUj15CkNPTkZJR19ISUJF
Uk5BVElPTj15CkNPTkZJR19QTV9TVERfUEFSVElUSU9OPSIvZGV2L3NkYTEiCkNPTkZJR19BQ1BJ
PXkKQ09ORklHX0FDUElfU0xFRVA9eQpDT05GSUdfQUNQSV9QUk9DRlM9eQpDT05GSUdfQUNQSV9Q
Uk9DRlNfUE9XRVI9eQpDT05GSUdfQUNQSV9TWVNGU19QT1dFUj15CkNPTkZJR19BQ1BJX1BST0Nf
RVZFTlQ9eQojIENPTkZJR19BQ1BJX0FDIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9CQVRURVJZ
IGlzIG5vdCBzZXQKQ09ORklHX0FDUElfQlVUVE9OPXkKQ09ORklHX0FDUElfRkFOPXkKQ09ORklH
X0FDUElfRE9DSz15CiMgQ09ORklHX0FDUElfQkFZIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfUFJP
Q0VTU09SPXkKQ09ORklHX0FDUElfSE9UUExVR19DUFU9eQpDT05GSUdfQUNQSV9USEVSTUFMPXkK
IyBDT05GSUdfQUNQSV9XTUkgaXMgbm90IHNldAojIENPTkZJR19BQ1BJX0FTVVMgaXMgbm90IHNl
dAojIENPTkZJR19BQ1BJX1RPU0hJQkEgaXMgbm90IHNldAojIENPTkZJR19BQ1BJX0NVU1RPTV9E
U0RUIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfQkxBQ0tMSVNUX1lFQVI9MAojIENPTkZJR19BQ1BJ
X0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfRUM9eQpDT05GSUdfQUNQSV9QT1dFUj15CkNP
TkZJR19BQ1BJX1NZU1RFTT15CkNPTkZJR19YODZfUE1fVElNRVI9eQpDT05GSUdfQUNQSV9DT05U
QUlORVI9eQojIENPTkZJR19BQ1BJX1NCUyBpcyBub3Qgc2V0CgojCiMgQ1BVIEZyZXF1ZW5jeSBz
Y2FsaW5nCiMKQ09ORklHX0NQVV9GUkVRPXkKQ09ORklHX0NQVV9GUkVRX1RBQkxFPXkKIyBDT05G
SUdfQ1BVX0ZSRVFfREVCVUcgaXMgbm90IHNldApDT05GSUdfQ1BVX0ZSRVFfU1RBVD15CkNPTkZJ
R19DUFVfRlJFUV9TVEFUX0RFVEFJTFM9eQpDT05GSUdfQ1BVX0ZSRVFfREVGQVVMVF9HT1ZfUEVS
Rk9STUFOQ0U9eQojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9VU0VSU1BBQ0UgaXMgbm90
IHNldAojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9PTkRFTUFORCBpcyBub3Qgc2V0CiMg
Q09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX0NPTlNFUlZBVElWRSBpcyBub3Qgc2V0CkNPTkZJ
R19DUFVfRlJFUV9HT1ZfUEVSRk9STUFOQ0U9eQpDT05GSUdfQ1BVX0ZSRVFfR09WX1BPV0VSU0FW
RT15CkNPTkZJR19DUFVfRlJFUV9HT1ZfVVNFUlNQQUNFPXkKQ09ORklHX0NQVV9GUkVRX0dPVl9P
TkRFTUFORD15CkNPTkZJR19DUFVfRlJFUV9HT1ZfQ09OU0VSVkFUSVZFPXkKCiMKIyBDUFVGcmVx
IHByb2Nlc3NvciBkcml2ZXJzCiMKQ09ORklHX1g4Nl9BQ1BJX0NQVUZSRVE9eQojIENPTkZJR19Y
ODZfUE9XRVJOT1dfSzggaXMgbm90IHNldAojIENPTkZJR19YODZfU1BFRURTVEVQX0NFTlRSSU5P
IGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1A0X0NMT0NLTU9EIGlzIG5vdCBzZXQKCiMKIyBzaGFy
ZWQgb3B0aW9ucwojCkNPTkZJR19YODZfQUNQSV9DUFVGUkVRX1BST0NfSU5URj15CiMgQ09ORklH
X1g4Nl9TUEVFRFNURVBfTElCIGlzIG5vdCBzZXQKQ09ORklHX0NQVV9JRExFPXkKQ09ORklHX0NQ
VV9JRExFX0dPVl9MQURERVI9eQoKIwojIEJ1cyBvcHRpb25zIChQQ0kgZXRjLikKIwpDT05GSUdf
UENJPXkKQ09ORklHX1BDSV9ESVJFQ1Q9eQpDT05GSUdfUENJX01NQ09ORklHPXkKQ09ORklHX1BD
SV9ET01BSU5TPXkKIyBDT05GSUdfRE1BUiBpcyBub3Qgc2V0CkNPTkZJR19QQ0lFUE9SVEJVUz15
CkNPTkZJR19IT1RQTFVHX1BDSV9QQ0lFPXkKQ09ORklHX1BDSUVBRVI9eQpDT05GSUdfQVJDSF9T
VVBQT1JUU19NU0k9eQpDT05GSUdfUENJX01TST15CkNPTkZJR19QQ0lfTEVHQUNZPXkKQ09ORklH
X0hUX0lSUT15CkNPTkZJR19JU0FfRE1BX0FQST15CkNPTkZJR19LOF9OQj15CiMgQ09ORklHX1BD
Q0FSRCBpcyBub3Qgc2V0CkNPTkZJR19IT1RQTFVHX1BDST15CiMgQ09ORklHX0hPVFBMVUdfUENJ
X0ZBS0UgaXMgbm90IHNldApDT05GSUdfSE9UUExVR19QQ0lfQUNQST15CiMgQ09ORklHX0hPVFBM
VUdfUENJX0FDUElfSUJNIGlzIG5vdCBzZXQKIyBDT05GSUdfSE9UUExVR19QQ0lfQ1BDSSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hPVFBMVUdfUENJX1NIUEMgaXMgbm90IHNldAoKIwojIEV4ZWN1dGFi
bGUgZmlsZSBmb3JtYXRzIC8gRW11bGF0aW9ucwojCkNPTkZJR19CSU5GTVRfRUxGPXkKQ09ORklH
X0NPTVBBVF9CSU5GTVRfRUxGPXkKQ09ORklHX0JJTkZNVF9NSVNDPXkKQ09ORklHX0lBMzJfRU1V
TEFUSU9OPXkKQ09ORklHX0lBMzJfQU9VVD15CkNPTkZJR19DT01QQVQ9eQpDT05GSUdfQ09NUEFU
X0ZPUl9VNjRfQUxJR05NRU5UPXkKQ09ORklHX1NZU1ZJUENfQ09NUEFUPXkKCiMKIyBOZXR3b3Jr
aW5nCiMKQ09ORklHX05FVD15CgojCiMgTmV0d29ya2luZyBvcHRpb25zCiMKQ09ORklHX1BBQ0tF
VD15CiMgQ09ORklHX1BBQ0tFVF9NTUFQIGlzIG5vdCBzZXQKQ09ORklHX1VOSVg9eQpDT05GSUdf
WEZSTT15CiMgQ09ORklHX1hGUk1fVVNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1hGUk1fU1VCX1BP
TElDWSBpcyBub3Qgc2V0CiMgQ09ORklHX1hGUk1fTUlHUkFURSBpcyBub3Qgc2V0CiMgQ09ORklH
X1hGUk1fU1RBVElTVElDUyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9LRVkgaXMgbm90IHNldApD
T05GSUdfSU5FVD15CkNPTkZJR19JUF9NVUxUSUNBU1Q9eQpDT05GSUdfSVBfQURWQU5DRURfUk9V
VEVSPXkKQ09ORklHX0FTS19JUF9GSUJfSEFTSD15CiMgQ09ORklHX0lQX0ZJQl9UUklFIGlzIG5v
dCBzZXQKQ09ORklHX0lQX0ZJQl9IQVNIPXkKQ09ORklHX0lQX01VTFRJUExFX1RBQkxFUz15CkNP
TkZJR19JUF9ST1VURV9NVUxUSVBBVEg9eQpDT05GSUdfSVBfUk9VVEVfVkVSQk9TRT15CkNPTkZJ
R19JUF9QTlA9eQpDT05GSUdfSVBfUE5QX0RIQ1A9eQpDT05GSUdfSVBfUE5QX0JPT1RQPXkKQ09O
RklHX0lQX1BOUF9SQVJQPXkKQ09ORklHX05FVF9JUElQPXkKQ09ORklHX05FVF9JUEdSRT15CkNP
TkZJR19ORVRfSVBHUkVfQlJPQURDQVNUPXkKQ09ORklHX0lQX01ST1VURT15CiMgQ09ORklHX0lQ
X1BJTVNNX1YxIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfUElNU01fVjIgaXMgbm90IHNldApDT05G
SUdfQVJQRD15CkNPTkZJR19TWU5fQ09PS0lFUz15CkNPTkZJR19JTkVUX0FIPXkKQ09ORklHX0lO
RVRfRVNQPXkKQ09ORklHX0lORVRfSVBDT01QPXkKQ09ORklHX0lORVRfWEZSTV9UVU5ORUw9eQpD
T05GSUdfSU5FVF9UVU5ORUw9eQpDT05GSUdfSU5FVF9YRlJNX01PREVfVFJBTlNQT1JUPXkKQ09O
RklHX0lORVRfWEZSTV9NT0RFX1RVTk5FTD15CkNPTkZJR19JTkVUX1hGUk1fTU9ERV9CRUVUPXkK
Q09ORklHX0lORVRfTFJPPXkKQ09ORklHX0lORVRfRElBRz15CkNPTkZJR19JTkVUX1RDUF9ESUFH
PXkKQ09ORklHX1RDUF9DT05HX0FEVkFOQ0VEPXkKQ09ORklHX1RDUF9DT05HX0JJQz15CkNPTkZJ
R19UQ1BfQ09OR19DVUJJQz15CkNPTkZJR19UQ1BfQ09OR19XRVNUV09PRD15CkNPTkZJR19UQ1Bf
Q09OR19IVENQPXkKQ09ORklHX1RDUF9DT05HX0hTVENQPXkKQ09ORklHX1RDUF9DT05HX0hZQkxB
PXkKQ09ORklHX1RDUF9DT05HX1ZFR0FTPXkKQ09ORklHX1RDUF9DT05HX1NDQUxBQkxFPXkKQ09O
RklHX1RDUF9DT05HX0xQPXkKQ09ORklHX1RDUF9DT05HX1ZFTk89eQpDT05GSUdfVENQX0NPTkdf
WUVBSD15CkNPTkZJR19UQ1BfQ09OR19JTExJTk9JUz15CiMgQ09ORklHX0RFRkFVTFRfQklDIGlz
IG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfQ1VCSUM9eQojIENPTkZJR19ERUZBVUxUX0hUQ1AgaXMg
bm90IHNldAojIENPTkZJR19ERUZBVUxUX1ZFR0FTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVGQVVM
VF9XRVNUV09PRCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFRkFVTFRfUkVOTyBpcyBub3Qgc2V0CkNP
TkZJR19ERUZBVUxUX1RDUF9DT05HPSJjdWJpYyIKIyBDT05GSUdfVENQX01ENVNJRyBpcyBub3Qg
c2V0CkNPTkZJR19JUF9WUz15CiMgQ09ORklHX0lQX1ZTX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklH
X0lQX1ZTX1RBQl9CSVRTPTEyCgojCiMgSVBWUyB0cmFuc3BvcnQgcHJvdG9jb2wgbG9hZCBiYWxh
bmNpbmcgc3VwcG9ydAojCkNPTkZJR19JUF9WU19QUk9UT19UQ1A9eQpDT05GSUdfSVBfVlNfUFJP
VE9fVURQPXkKQ09ORklHX0lQX1ZTX1BST1RPX0VTUD15CkNPTkZJR19JUF9WU19QUk9UT19BSD15
CgojCiMgSVBWUyBzY2hlZHVsZXIKIwpDT05GSUdfSVBfVlNfUlI9eQpDT05GSUdfSVBfVlNfV1JS
PXkKQ09ORklHX0lQX1ZTX0xDPXkKQ09ORklHX0lQX1ZTX1dMQz15CkNPTkZJR19JUF9WU19MQkxD
PXkKQ09ORklHX0lQX1ZTX0xCTENSPXkKQ09ORklHX0lQX1ZTX0RIPXkKQ09ORklHX0lQX1ZTX1NI
PXkKQ09ORklHX0lQX1ZTX1NFRD15CkNPTkZJR19JUF9WU19OUT15CgojCiMgSVBWUyBhcHBsaWNh
dGlvbiBoZWxwZXIKIwpDT05GSUdfSVBfVlNfRlRQPXkKQ09ORklHX0lQVjY9eQojIENPTkZJR19J
UFY2X1BSSVZBQ1kgaXMgbm90IHNldAojIENPTkZJR19JUFY2X1JPVVRFUl9QUkVGIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSVBWNl9PUFRJTUlTVElDX0RBRCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVQ2
X0FIIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVDZfRVNQIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5F
VDZfSVBDT01QIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9NSVA2IGlzIG5vdCBzZXQKIyBDT05G
SUdfSU5FVDZfWEZSTV9UVU5ORUwgaXMgbm90IHNldAojIENPTkZJR19JTkVUNl9UVU5ORUwgaXMg
bm90IHNldAojIENPTkZJR19JTkVUNl9YRlJNX01PREVfVFJBTlNQT1JUIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5FVDZfWEZSTV9NT0RFX1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVQ2X1hG
Uk1fTU9ERV9CRUVUIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVDZfWEZSTV9NT0RFX1JPVVRFT1BU
SU1JWkFUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9TSVQgaXMgbm90IHNldAojIENPTkZJ
R19JUFY2X1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lQVjZfTVVMVElQTEVfVEFCTEVTIGlz
IG5vdCBzZXQKQ09ORklHX05FVFdPUktfU0VDTUFSSz15CkNPTkZJR19ORVRGSUxURVI9eQojIENP
TkZJR19ORVRGSUxURVJfREVCVUcgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX0FEVkFOQ0VE
PXkKCiMKIyBDb3JlIE5ldGZpbHRlciBDb25maWd1cmF0aW9uCiMKQ09ORklHX05FVEZJTFRFUl9O
RVRMSU5LPXkKQ09ORklHX05FVEZJTFRFUl9ORVRMSU5LX1FVRVVFPXkKQ09ORklHX05FVEZJTFRF
Ul9ORVRMSU5LX0xPRz15CkNPTkZJR19ORl9DT05OVFJBQ0s9eQpDT05GSUdfTkZfQ1RfQUNDVD15
CkNPTkZJR19ORl9DT05OVFJBQ0tfTUFSSz15CkNPTkZJR19ORl9DT05OVFJBQ0tfU0VDTUFSSz15
CiMgQ09ORklHX05GX0NPTk5UUkFDS19FVkVOVFMgaXMgbm90IHNldApDT05GSUdfTkZfQ1RfUFJP
VE9fR1JFPXkKIyBDT05GSUdfTkZfQ1RfUFJPVE9fU0NUUCBpcyBub3Qgc2V0CkNPTkZJR19ORl9D
VF9QUk9UT19VRFBMSVRFPXkKQ09ORklHX05GX0NPTk5UUkFDS19BTUFOREE9eQpDT05GSUdfTkZf
Q09OTlRSQUNLX0ZUUD15CkNPTkZJR19ORl9DT05OVFJBQ0tfSDMyMz15CkNPTkZJR19ORl9DT05O
VFJBQ0tfSVJDPXkKQ09ORklHX05GX0NPTk5UUkFDS19ORVRCSU9TX05TPXkKQ09ORklHX05GX0NP
Tk5UUkFDS19QUFRQPXkKIyBDT05GSUdfTkZfQ09OTlRSQUNLX1NBTkUgaXMgbm90IHNldApDT05G
SUdfTkZfQ09OTlRSQUNLX1NJUD15CkNPTkZJR19ORl9DT05OVFJBQ0tfVEZUUD15CiMgQ09ORklH
X05GX0NUX05FVExJTksgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX1hUQUJMRVM9eQpDT05G
SUdfTkVURklMVEVSX1hUX1RBUkdFVF9DTEFTU0lGWT15CkNPTkZJR19ORVRGSUxURVJfWFRfVEFS
R0VUX0NPTk5NQVJLPXkKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfRFNDUD15CkNPTkZJR19O
RVRGSUxURVJfWFRfVEFSR0VUX01BUks9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9ORlFV
RVVFPXkKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfTkZMT0c9eQpDT05GSUdfTkVURklMVEVS
X1hUX1RBUkdFVF9OT1RSQUNLPXkKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfUkFURUVTVD15
CkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX1RSQUNFPXkKQ09ORklHX05FVEZJTFRFUl9YVF9U
QVJHRVRfU0VDTUFSSz15CkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0NPTk5TRUNNQVJLPXkK
Q09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfVENQTVNTPXkKIyBDT05GSUdfTkVURklMVEVSX1hU
X1RBUkdFVF9UQ1BPUFRTVFJJUCBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hf
Q09NTUVOVD15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfQ09OTkJZVEVTPXkKQ09ORklHX05F
VEZJTFRFUl9YVF9NQVRDSF9DT05OTElNSVQ9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NP
Tk5NQVJLPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9DT05OVFJBQ0s9eQpDT05GSUdfTkVU
RklMVEVSX1hUX01BVENIX0RDQ1A9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0RTQ1A9eQpD
T05GSUdfTkVURklMVEVSX1hUX01BVENIX0VTUD15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hf
SEVMUEVSPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9JUFJBTkdFPXkKQ09ORklHX05FVEZJ
TFRFUl9YVF9NQVRDSF9MRU5HVEg9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0xJTUlUPXkK
Q09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9NQUM9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENI
X01BUks9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX09XTkVSPXkKQ09ORklHX05FVEZJTFRF
Ul9YVF9NQVRDSF9QT0xJQ1k9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX01VTFRJUE9SVD15
CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUEtUVFlQRT15CkNPTkZJR19ORVRGSUxURVJfWFRf
TUFUQ0hfUVVPVEE9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1JBVEVFU1Q9eQpDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX1JFQUxNPXkKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1ND
VFAgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1NUQVRFPXkKQ09ORklHX05F
VEZJTFRFUl9YVF9NQVRDSF9TVEFUSVNUSUM9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1NU
UklORz15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfVENQTVNTPXkKQ09ORklHX05FVEZJTFRF
Ul9YVF9NQVRDSF9USU1FPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9VMzI9eQpDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX0hBU0hMSU1JVD15CgojCiMgSVA6IE5ldGZpbHRlciBDb25maWd1
cmF0aW9uCiMKQ09ORklHX05GX0NPTk5UUkFDS19JUFY0PXkKQ09ORklHX05GX0NPTk5UUkFDS19Q
Uk9DX0NPTVBBVD15CiMgQ09ORklHX0lQX05GX1FVRVVFIGlzIG5vdCBzZXQKQ09ORklHX0lQX05G
X0lQVEFCTEVTPXkKQ09ORklHX0lQX05GX01BVENIX1JFQ0VOVD15CkNPTkZJR19JUF9ORl9NQVRD
SF9FQ049eQpDT05GSUdfSVBfTkZfTUFUQ0hfQUg9eQpDT05GSUdfSVBfTkZfTUFUQ0hfVFRMPXkK
Q09ORklHX0lQX05GX01BVENIX0FERFJUWVBFPXkKQ09ORklHX0lQX05GX0ZJTFRFUj15CkNPTkZJ
R19JUF9ORl9UQVJHRVRfUkVKRUNUPXkKQ09ORklHX0lQX05GX1RBUkdFVF9MT0c9eQpDT05GSUdf
SVBfTkZfVEFSR0VUX1VMT0c9eQpDT05GSUdfTkZfTkFUPXkKQ09ORklHX05GX05BVF9ORUVERUQ9
eQpDT05GSUdfSVBfTkZfVEFSR0VUX01BU1FVRVJBREU9eQpDT05GSUdfSVBfTkZfVEFSR0VUX1JF
RElSRUNUPXkKQ09ORklHX0lQX05GX1RBUkdFVF9ORVRNQVA9eQpDT05GSUdfTkZfTkFUX1NOTVBf
QkFTSUM9eQpDT05GSUdfTkZfTkFUX1BST1RPX0dSRT15CkNPTkZJR19ORl9OQVRfRlRQPXkKQ09O
RklHX05GX05BVF9JUkM9eQpDT05GSUdfTkZfTkFUX1RGVFA9eQpDT05GSUdfTkZfTkFUX0FNQU5E
QT15CkNPTkZJR19ORl9OQVRfUFBUUD15CkNPTkZJR19ORl9OQVRfSDMyMz15CkNPTkZJR19ORl9O
QVRfU0lQPXkKQ09ORklHX0lQX05GX01BTkdMRT15CkNPTkZJR19JUF9ORl9UQVJHRVRfRUNOPXkK
Q09ORklHX0lQX05GX1RBUkdFVF9UVEw9eQpDT05GSUdfSVBfTkZfVEFSR0VUX0NMVVNURVJJUD15
CkNPTkZJR19JUF9ORl9SQVc9eQpDT05GSUdfSVBfTkZfQVJQVEFCTEVTPXkKQ09ORklHX0lQX05G
X0FSUEZJTFRFUj15CkNPTkZJR19JUF9ORl9BUlBfTUFOR0xFPXkKCiMKIyBJUHY2OiBOZXRmaWx0
ZXIgQ29uZmlndXJhdGlvbgojCiMgQ09ORklHX05GX0NPTk5UUkFDS19JUFY2IGlzIG5vdCBzZXQK
IyBDT05GSUdfSVA2X05GX1FVRVVFIGlzIG5vdCBzZXQKIyBDT05GSUdfSVA2X05GX0lQVEFCTEVT
IGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfRENDUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX1NDVFAg
aXMgbm90IHNldAojIENPTkZJR19USVBDIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQlJJREdFIGlzIG5vdCBzZXQKIyBDT05GSUdfVkxBTl84MDIxUSBpcyBub3Qg
c2V0CiMgQ09ORklHX0RFQ05FVCBpcyBub3Qgc2V0CiMgQ09ORklHX0xMQzIgaXMgbm90IHNldAoj
IENPTkZJR19JUFggaXMgbm90IHNldAojIENPTkZJR19BVEFMSyBpcyBub3Qgc2V0CiMgQ09ORklH
X1gyNSBpcyBub3Qgc2V0CiMgQ09ORklHX0xBUEIgaXMgbm90IHNldAojIENPTkZJR19FQ09ORVQg
aXMgbm90IHNldAojIENPTkZJR19XQU5fUk9VVEVSIGlzIG5vdCBzZXQKQ09ORklHX05FVF9TQ0hF
RD15CgojCiMgUXVldWVpbmcvU2NoZWR1bGluZwojCkNPTkZJR19ORVRfU0NIX0NCUT15CkNPTkZJ
R19ORVRfU0NIX0hUQj15CkNPTkZJR19ORVRfU0NIX0hGU0M9eQpDT05GSUdfTkVUX1NDSF9QUklP
PXkKQ09ORklHX05FVF9TQ0hfUlI9eQpDT05GSUdfTkVUX1NDSF9SRUQ9eQpDT05GSUdfTkVUX1ND
SF9TRlE9eQpDT05GSUdfTkVUX1NDSF9URVFMPXkKQ09ORklHX05FVF9TQ0hfVEJGPXkKQ09ORklH
X05FVF9TQ0hfR1JFRD15CkNPTkZJR19ORVRfU0NIX0RTTUFSSz15CkNPTkZJR19ORVRfU0NIX05F
VEVNPXkKIyBDT05GSUdfTkVUX1NDSF9JTkdSRVNTIGlzIG5vdCBzZXQKCiMKIyBDbGFzc2lmaWNh
dGlvbgojCkNPTkZJR19ORVRfQ0xTPXkKQ09ORklHX05FVF9DTFNfQkFTSUM9eQpDT05GSUdfTkVU
X0NMU19UQ0lOREVYPXkKQ09ORklHX05FVF9DTFNfUk9VVEU0PXkKQ09ORklHX05FVF9DTFNfUk9V
VEU9eQpDT05GSUdfTkVUX0NMU19GVz15CkNPTkZJR19ORVRfQ0xTX1UzMj15CkNPTkZJR19DTFNf
VTMyX1BFUkY9eQpDT05GSUdfQ0xTX1UzMl9NQVJLPXkKQ09ORklHX05FVF9DTFNfUlNWUD15CkNP
TkZJR19ORVRfQ0xTX1JTVlA2PXkKQ09ORklHX05FVF9DTFNfRkxPVz15CkNPTkZJR19ORVRfRU1B
VENIPXkKQ09ORklHX05FVF9FTUFUQ0hfU1RBQ0s9MzIKQ09ORklHX05FVF9FTUFUQ0hfQ01QPXkK
Q09ORklHX05FVF9FTUFUQ0hfTkJZVEU9eQpDT05GSUdfTkVUX0VNQVRDSF9VMzI9eQpDT05GSUdf
TkVUX0VNQVRDSF9NRVRBPXkKQ09ORklHX05FVF9FTUFUQ0hfVEVYVD15CkNPTkZJR19ORVRfQ0xT
X0FDVD15CkNPTkZJR19ORVRfQUNUX1BPTElDRT15CkNPTkZJR19ORVRfQUNUX0dBQ1Q9eQpDT05G
SUdfR0FDVF9QUk9CPXkKQ09ORklHX05FVF9BQ1RfTUlSUkVEPXkKQ09ORklHX05FVF9BQ1RfSVBU
PXkKQ09ORklHX05FVF9BQ1RfTkFUPXkKQ09ORklHX05FVF9BQ1RfUEVESVQ9eQojIENPTkZJR19O
RVRfQUNUX1NJTVAgaXMgbm90IHNldApDT05GSUdfTkVUX0NMU19JTkQ9eQpDT05GSUdfTkVUX1ND
SF9GSUZPPXkKCiMKIyBOZXR3b3JrIHRlc3RpbmcKIwojIENPTkZJR19ORVRfUEtUR0VOIGlzIG5v
dCBzZXQKIyBDT05GSUdfSEFNUkFESU8gaXMgbm90IHNldAojIENPTkZJR19DQU4gaXMgbm90IHNl
dAojIENPTkZJR19JUkRBIGlzIG5vdCBzZXQKIyBDT05GSUdfQlQgaXMgbm90IHNldAojIENPTkZJ
R19BRl9SWFJQQyBpcyBub3Qgc2V0CkNPTkZJR19GSUJfUlVMRVM9eQoKIwojIFdpcmVsZXNzCiMK
IyBDT05GSUdfQ0ZHODAyMTEgaXMgbm90IHNldAojIENPTkZJR19XSVJFTEVTU19FWFQgaXMgbm90
IHNldAojIENPTkZJR19NQUM4MDIxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0lFRUU4MDIxMSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JGS0lMTCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF85UCBpcyBub3Qg
c2V0CgojCiMgRGV2aWNlIERyaXZlcnMKIwoKIwojIEdlbmVyaWMgRHJpdmVyIE9wdGlvbnMKIwpD
T05GSUdfVUVWRU5UX0hFTFBFUl9QQVRIPSIvc2Jpbi9ob3RwbHVnIgpDT05GSUdfU1RBTkRBTE9O
RT15CkNPTkZJR19QUkVWRU5UX0ZJUk1XQVJFX0JVSUxEPXkKQ09ORklHX0ZXX0xPQURFUj15CiMg
Q09ORklHX1NZU19IWVBFUlZJU09SIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09OTkVDVE9SIGlzIG5v
dCBzZXQKIyBDT05GSUdfTVREIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFSUE9SVCBpcyBub3Qgc2V0
CkNPTkZJR19QTlA9eQojIENPTkZJR19QTlBfREVCVUcgaXMgbm90IHNldAoKIwojIFByb3RvY29s
cwojCkNPTkZJR19QTlBBQ1BJPXkKQ09ORklHX0JMS19ERVY9eQpDT05GSUdfQkxLX0RFVl9GRD15
CiMgQ09ORklHX0JMS19DUFFfREEgaXMgbm90IHNldAojIENPTkZJR19CTEtfQ1BRX0NJU1NfREEg
aXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0RBQzk2MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JM
S19ERVZfVU1FTSBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfQ09XX0NPTU1PTiBpcyBub3Qg
c2V0CkNPTkZJR19CTEtfREVWX0xPT1A9eQpDT05GSUdfQkxLX0RFVl9DUllQVE9MT09QPXkKIyBD
T05GSUdfQkxLX0RFVl9OQkQgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1NYOCBpcyBub3Qg
c2V0CiMgQ09ORklHX0JMS19ERVZfVUIgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9SQU09eQpD
T05GSUdfQkxLX0RFVl9SQU1fQ09VTlQ9MTYKQ09ORklHX0JMS19ERVZfUkFNX1NJWkU9NDA5Ngoj
IENPTkZJR19CTEtfREVWX1hJUCBpcyBub3Qgc2V0CiMgQ09ORklHX0NEUk9NX1BLVENEVkQgaXMg
bm90IHNldAojIENPTkZJR19BVEFfT1ZFUl9FVEggaXMgbm90IHNldApDT05GSUdfTUlTQ19ERVZJ
Q0VTPXkKIyBDT05GSUdfSUJNX0FTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1BIQU5UT00gaXMgbm90
IHNldAojIENPTkZJR19FRVBST01fOTNDWDYgaXMgbm90IHNldAojIENPTkZJR19TR0lfSU9DNCBp
cyBub3Qgc2V0CiMgQ09ORklHX1RJRk1fQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NPTllfTEFQ
VE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfVEhJTktQQURfQUNQSSBpcyBub3Qgc2V0CiMgQ09ORklH
X0lOVEVMX01FTkxPVyBpcyBub3Qgc2V0CiMgQ09ORklHX0VOQ0xPU1VSRV9TRVJWSUNFUyBpcyBu
b3Qgc2V0CkNPTkZJR19IQVZFX0lERT15CkNPTkZJR19JREU9eQpDT05GSUdfQkxLX0RFVl9JREU9
eQoKIwojIFBsZWFzZSBzZWUgRG9jdW1lbnRhdGlvbi9pZGUvaWRlLnR4dCBmb3IgaGVscC9pbmZv
IG9uIElERSBkcml2ZXMKIwojIENPTkZJR19CTEtfREVWX0lERV9TQVRBIGlzIG5vdCBzZXQKIyBD
T05GSUdfQkxLX0RFVl9IRF9JREUgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0lERURJU0sg
aXMgbm90IHNldAojIENPTkZJR19JREVESVNLX01VTFRJX01PREUgaXMgbm90IHNldAojIENPTkZJ
R19CTEtfREVWX0lERUNEIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9JREVUQVBFIGlzIG5v
dCBzZXQKIyBDT05GSUdfQkxLX0RFVl9JREVGTE9QUFkgaXMgbm90IHNldAojIENPTkZJR19CTEtf
REVWX0lERVNDU0kgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0lERUFDUEkgaXMgbm90IHNl
dAojIENPTkZJR19JREVfVEFTS19JT0NUTCBpcyBub3Qgc2V0CkNPTkZJR19JREVfUFJPQ19GUz15
CgojCiMgSURFIGNoaXBzZXQgc3VwcG9ydC9idWdmaXhlcwojCiMgQ09ORklHX0lERV9HRU5FUklD
IGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9QTEFURk9STSBpcyBub3Qgc2V0CiMgQ09ORklH
X0JMS19ERVZfQ01ENjQwIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9JREVQTlAgaXMgbm90
IHNldApDT05GSUdfQkxLX0RFVl9JREVETUFfU0ZGPXkKCiMKIyBQQ0kgSURFIGNoaXBzZXRzIHN1
cHBvcnQKIwpDT05GSUdfQkxLX0RFVl9JREVQQ0k9eQpDT05GSUdfSURFUENJX1BDSUJVU19PUkRF
Uj15CiMgQ09ORklHX0JMS19ERVZfR0VORVJJQyBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZf
T1BUSTYyMSBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfUloxMDAwIGlzIG5vdCBzZXQKQ09O
RklHX0JMS19ERVZfSURFRE1BX1BDST15CiMgQ09ORklHX0JMS19ERVZfQUVDNjJYWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0JMS19ERVZfQUxJMTVYMyBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZf
QU1ENzRYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfQVRJSVhQIGlzIG5vdCBzZXQKIyBD
T05GSUdfQkxLX0RFVl9DTUQ2NFggaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1RSSUZMRVgg
aXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0NZODJDNjkzIGlzIG5vdCBzZXQKIyBDT05GSUdf
QkxLX0RFVl9DUzU1MjAgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0NTNTUzMCBpcyBub3Qg
c2V0CiMgQ09ORklHX0JMS19ERVZfSFBUMzRYIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9I
UFQzNjYgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9KTUlDUk9OPXkKIyBDT05GSUdfQkxLX0RF
Vl9TQzEyMDAgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9QSUlYPXkKIyBDT05GSUdfQkxLX0RF
Vl9JVDgyMTMgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0lUODIxWCBpcyBub3Qgc2V0CiMg
Q09ORklHX0JMS19ERVZfTlM4NzQxNSBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfUERDMjAy
WFhfT0xEIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9QREMyMDJYWF9ORVcgaXMgbm90IHNl
dAojIENPTkZJR19CTEtfREVWX1NWV0tTIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9TSUlN
QUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9TSVM1NTEzIGlzIG5vdCBzZXQKIyBDT05G
SUdfQkxLX0RFVl9TTEM5MEU2NiBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfVFJNMjkwIGlz
IG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9WSUE4MkNYWFggaXMgbm90IHNldAojIENPTkZJR19C
TEtfREVWX1RDODZDMDAxIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfSURFRE1BPXkKQ09ORklH
X0lERV9BUkNIX09CU09MRVRFX0lOSVQ9eQojIENPTkZJR19CTEtfREVWX0hEIGlzIG5vdCBzZXQK
CiMKIyBTQ1NJIGRldmljZSBzdXBwb3J0CiMKIyBDT05GSUdfUkFJRF9BVFRSUyBpcyBub3Qgc2V0
CkNPTkZJR19TQ1NJPXkKQ09ORklHX1NDU0lfRE1BPXkKIyBDT05GSUdfU0NTSV9UR1QgaXMgbm90
IHNldAojIENPTkZJR19TQ1NJX05FVExJTksgaXMgbm90IHNldApDT05GSUdfU0NTSV9QUk9DX0ZT
PXkKCiMKIyBTQ1NJIHN1cHBvcnQgdHlwZSAoZGlzaywgdGFwZSwgQ0QtUk9NKQojCkNPTkZJR19C
TEtfREVWX1NEPXkKIyBDT05GSUdfQ0hSX0RFVl9TVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NIUl9E
RVZfT1NTVCBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX1NSPXkKIyBDT05GSUdfQkxLX0RFVl9T
Ul9WRU5ET1IgaXMgbm90IHNldApDT05GSUdfQ0hSX0RFVl9TRz15CiMgQ09ORklHX0NIUl9ERVZf
U0NIIGlzIG5vdCBzZXQKCiMKIyBTb21lIFNDU0kgZGV2aWNlcyAoZS5nLiBDRCBqdWtlYm94KSBz
dXBwb3J0IG11bHRpcGxlIExVTnMKIwojIENPTkZJR19TQ1NJX01VTFRJX0xVTiBpcyBub3Qgc2V0
CiMgQ09ORklHX1NDU0lfQ09OU1RBTlRTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9MT0dHSU5H
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9TQ0FOX0FTWU5DIGlzIG5vdCBzZXQKQ09ORklHX1ND
U0lfV0FJVF9TQ0FOPW0KCiMKIyBTQ1NJIFRyYW5zcG9ydHMKIwojIENPTkZJR19TQ1NJX1NQSV9B
VFRSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfRkNfQVRUUlMgaXMgbm90IHNldAojIENPTkZJ
R19TQ1NJX0lTQ1NJX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9TQVNfTElCU0FTIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0NTSV9TUlBfQVRUUlMgaXMgbm90IHNldApDT05GSUdfU0NTSV9M
T1dMRVZFTD15CiMgQ09ORklHX0lTQ1NJX1RDUCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZf
M1dfWFhYWF9SQUlEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV8zV185WFhYIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0NTSV9BQ0FSRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfQUFDUkFJRCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NDU0lfQUlDN1hYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfQUlD
N1hYWF9PTEQgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FJQzc5WFggaXMgbm90IHNldAojIENP
TkZJR19TQ1NJX0FJQzk0WFggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FEVkFOU1lTIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0NTSV9BUkNNU1IgaXMgbm90IHNldAojIENPTkZJR19NRUdBUkFJRF9O
RVdHRU4gaXMgbm90IHNldAojIENPTkZJR19NRUdBUkFJRF9MRUdBQ1kgaXMgbm90IHNldAojIENP
TkZJR19NRUdBUkFJRF9TQVMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0hQVElPUCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NDU0lfQlVTTE9HSUMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0RNWDMx
OTFEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9FQVRBIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NT
SV9GVVRVUkVfRE9NQUlOIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9HRFRIIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0NTSV9JUFMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0lOSVRJTyBpcyBub3Qg
c2V0CiMgQ09ORklHX1NDU0lfSU5JQTEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfTVZTQVMg
aXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NURVggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NZ
TTUzQzhYWF8yIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9JUFIgaXMgbm90IHNldAojIENPTkZJ
R19TQ1NJX1FMT0dJQ18xMjgwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9RTEFfRkMgaXMgbm90
IHNldAojIENPTkZJR19TQ1NJX1FMQV9JU0NTSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfTFBG
QyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfREMzOTV4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0NT
SV9EQzM5MFQgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0NTSV9TUlAgaXMgbm90IHNldApDT05GSUdfQVRBPXkKIyBDT05GSUdfQVRBX05PTlNUQU5E
QVJEIGlzIG5vdCBzZXQKQ09ORklHX0FUQV9BQ1BJPXkKQ09ORklHX1NBVEFfQUhDST15CiMgQ09O
RklHX1NBVEFfU1ZXIGlzIG5vdCBzZXQKQ09ORklHX0FUQV9QSUlYPXkKIyBDT05GSUdfU0FUQV9N
ViBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfTlYgaXMgbm90IHNldAojIENPTkZJR19QRENfQURN
QSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfUVNUT1IgaXMgbm90IHNldAojIENPTkZJR19TQVRB
X1BST01JU0UgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1NYNCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NBVEFfU0lMIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9TSUwyNCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NBVEFfU0lTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9VTEkgaXMgbm90IHNldAojIENP
TkZJR19TQVRBX1ZJQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfVklURVNTRSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NBVEFfSU5JQzE2MlggaXMgbm90IHNldAojIENPTkZJR19QQVRBX0FDUEkgaXMg
bm90IHNldAojIENPTkZJR19QQVRBX0FMSSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQU1EIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9BUlRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQVRJ
SVhQIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9DTUQ2NDBfUENJIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFUQV9DTUQ2NFggaXMgbm90IHNldAojIENPTkZJR19QQVRBX0NTNTUyMCBpcyBub3Qgc2V0
CiMgQ09ORklHX1BBVEFfQ1M1NTMwIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9DWVBSRVNTIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9FRkFSIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBX0dFTkVS
SUMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0hQVDM2NiBpcyBub3Qgc2V0CiMgQ09ORklHX1BB
VEFfSFBUMzdYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9IUFQzWDJOIGlzIG5vdCBzZXQKIyBD
T05GSUdfUEFUQV9IUFQzWDMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0lUODIxWCBpcyBub3Qg
c2V0CiMgQ09ORklHX1BBVEFfSVQ4MjEzIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9KTUlDUk9O
IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9UUklGTEVYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFU
QV9NQVJWRUxMIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9NUElJWCBpcyBub3Qgc2V0CiMgQ09O
RklHX1BBVEFfT0xEUElJWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTkVUQ0VMTCBpcyBub3Qg
c2V0CiMgQ09ORklHX1BBVEFfTklOSkEzMiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTlM4NzQx
MCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTlM4NzQxNSBpcyBub3Qgc2V0CiMgQ09ORklHX1BB
VEFfT1BUSSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfT1BUSURNQSBpcyBub3Qgc2V0CiMgQ09O
RklHX1BBVEFfUERDX09MRCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfUkFESVNZUyBpcyBub3Qg
c2V0CiMgQ09ORklHX1BBVEFfUloxMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9TQzEyMDAg
aXMgbm90IHNldAojIENPTkZJR19QQVRBX1NFUlZFUldPUktTIGlzIG5vdCBzZXQKIyBDT05GSUdf
UEFUQV9QREMyMDI3WCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfU0lMNjgwIGlzIG5vdCBzZXQK
IyBDT05GSUdfUEFUQV9TSVMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1ZJQSBpcyBub3Qgc2V0
CiMgQ09ORklHX1BBVEFfV0lOQk9ORCBpcyBub3Qgc2V0CkNPTkZJR19NRD15CkNPTkZJR19CTEtf
REVWX01EPXkKIyBDT05GSUdfTURfTElORUFSIGlzIG5vdCBzZXQKQ09ORklHX01EX1JBSUQwPXkK
Q09ORklHX01EX1JBSUQxPXkKIyBDT05GSUdfTURfUkFJRDEwIGlzIG5vdCBzZXQKQ09ORklHX01E
X1JBSUQ0NTY9eQpDT05GSUdfTURfUkFJRDVfUkVTSEFQRT15CiMgQ09ORklHX01EX01VTFRJUEFU
SCBpcyBub3Qgc2V0CiMgQ09ORklHX01EX0ZBVUxUWSBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVW
X0RNPXkKIyBDT05GSUdfRE1fREVCVUcgaXMgbm90IHNldApDT05GSUdfRE1fQ1JZUFQ9eQojIENP
TkZJR19ETV9TTkFQU0hPVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX01JUlJPUiBpcyBub3Qgc2V0
CiMgQ09ORklHX0RNX1pFUk8gaXMgbm90IHNldAojIENPTkZJR19ETV9NVUxUSVBBVEggaXMgbm90
IHNldAojIENPTkZJR19ETV9ERUxBWSBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX1VFVkVOVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfRE1fQkJSIGlzIG5vdCBzZXQKIyBDT05GSUdfRlVTSU9O
IGlzIG5vdCBzZXQKCiMKIyBJRUVFIDEzOTQgKEZpcmVXaXJlKSBzdXBwb3J0CiMKIyBDT05GSUdf
RklSRVdJUkUgaXMgbm90IHNldApDT05GSUdfSUVFRTEzOTQ9eQoKIwojIFN1YnN5c3RlbSBPcHRp
b25zCiMKIyBDT05GSUdfSUVFRTEzOTRfVkVSQk9TRURFQlVHIGlzIG5vdCBzZXQKCiMKIyBDb250
cm9sbGVycwojCiMgQ09ORklHX0lFRUUxMzk0X1BDSUxZTlggaXMgbm90IHNldApDT05GSUdfSUVF
RTEzOTRfT0hDSTEzOTQ9eQoKIwojIFByb3RvY29scwojCiMgQ09ORklHX0lFRUUxMzk0X1ZJREVP
MTM5NCBpcyBub3Qgc2V0CkNPTkZJR19JRUVFMTM5NF9TQlAyPXkKIyBDT05GSUdfSUVFRTEzOTRf
U0JQMl9QSFlTX0RNQSBpcyBub3Qgc2V0CiMgQ09ORklHX0lFRUUxMzk0X0VUSDEzOTRfUk9NX0VO
VFJZIGlzIG5vdCBzZXQKIyBDT05GSUdfSUVFRTEzOTRfRVRIMTM5NCBpcyBub3Qgc2V0CiMgQ09O
RklHX0lFRUUxMzk0X0RWMTM5NCBpcyBub3Qgc2V0CkNPTkZJR19JRUVFMTM5NF9SQVdJTz15CkNP
TkZJR19JMk89eQojIENPTkZJR19JMk9fTENUX05PVElGWV9PTl9DSEFOR0VTIGlzIG5vdCBzZXQK
IyBDT05GSUdfSTJPX0VYVF9BREFQVEVDIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJPX0NPTkZJRyBp
cyBub3Qgc2V0CiMgQ09ORklHX0kyT19CVVMgaXMgbm90IHNldAojIENPTkZJR19JMk9fQkxPQ0sg
aXMgbm90IHNldAojIENPTkZJR19JMk9fU0NTSSBpcyBub3Qgc2V0CkNPTkZJR19JMk9fUFJPQz15
CiMgQ09ORklHX01BQ0lOVE9TSF9EUklWRVJTIGlzIG5vdCBzZXQKQ09ORklHX05FVERFVklDRVM9
eQojIENPTkZJR19ORVRERVZJQ0VTX01VTFRJUVVFVUUgaXMgbm90IHNldAojIENPTkZJR19JRkIg
aXMgbm90IHNldAojIENPTkZJR19EVU1NWSBpcyBub3Qgc2V0CiMgQ09ORklHX0JPTkRJTkcgaXMg
bm90IHNldAojIENPTkZJR19NQUNWTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfRVFVQUxJWkVSIGlz
IG5vdCBzZXQKIyBDT05GSUdfVFVOIGlzIG5vdCBzZXQKIyBDT05GSUdfVkVUSCBpcyBub3Qgc2V0
CiMgQ09ORklHX05FVF9TQjEwMDAgaXMgbm90IHNldAojIENPTkZJR19BUkNORVQgaXMgbm90IHNl
dAojIENPTkZJR19QSFlMSUIgaXMgbm90IHNldApDT05GSUdfTkVUX0VUSEVSTkVUPXkKIyBDT05G
SUdfTUlJIGlzIG5vdCBzZXQKIyBDT05GSUdfSEFQUFlNRUFMIGlzIG5vdCBzZXQKIyBDT05GSUdf
U1VOR0VNIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FTU0lOSSBpcyBub3Qgc2V0CkNPTkZJR19ORVRf
VkVORE9SXzNDT009eQojIENPTkZJR19WT1JURVggaXMgbm90IHNldApDT05GSUdfVFlQSE9PTj15
CiMgQ09ORklHX05FVF9UVUxJUCBpcyBub3Qgc2V0CiMgQ09ORklHX0hQMTAwIGlzIG5vdCBzZXQK
IyBDT05GSUdfSUJNX05FV19FTUFDX1pNSUkgaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VN
QUNfUkdNSUkgaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfVEFIIGlzIG5vdCBzZXQK
IyBDT05GSUdfSUJNX05FV19FTUFDX0VNQUM0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1BDSSBp
cyBub3Qgc2V0CiMgQ09ORklHX0I0NCBpcyBub3Qgc2V0CkNPTkZJR19ORVRERVZfMTAwMD15CiMg
Q09ORklHX0FDRU5JQyBpcyBub3Qgc2V0CiMgQ09ORklHX0RMMksgaXMgbm90IHNldApDT05GSUdf
RTEwMDA9eQojIENPTkZJR19FMTAwMF9OQVBJIGlzIG5vdCBzZXQKIyBDT05GSUdfRTEwMDBfRElT
QUJMRV9QQUNLRVRfU1BMSVQgaXMgbm90IHNldApDT05GSUdfRTEwMDBFPXkKQ09ORklHX0UxMDAw
RV9FTkFCTEVEPXkKIyBDT05GSUdfSVAxMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfSUdCIGlzIG5v
dCBzZXQKIyBDT05GSUdfTlM4MzgyMCBpcyBub3Qgc2V0CiMgQ09ORklHX0hBTUFDSEkgaXMgbm90
IHNldAojIENPTkZJR19ZRUxMT1dGSU4gaXMgbm90IHNldApDT05GSUdfUjgxNjk9eQojIENPTkZJ
R19SODE2OV9OQVBJIGlzIG5vdCBzZXQKIyBDT05GSUdfU0lTMTkwIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0tHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NLWTIgaXMgbm90IHNldAojIENPTkZJR19TSzk4
TElOIGlzIG5vdCBzZXQKIyBDT05GSUdfVklBX1ZFTE9DSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdf
VElHT04zIGlzIG5vdCBzZXQKIyBDT05GSUdfQk5YMiBpcyBub3Qgc2V0CiMgQ09ORklHX1FMQTNY
WFggaXMgbm90IHNldAojIENPTkZJR19BVEwxIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUREVWXzEw
MDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVFIgaXMgbm90IHNldAoKIwojIFdpcmVsZXNzIExBTgoj
CiMgQ09ORklHX1dMQU5fUFJFODAyMTEgaXMgbm90IHNldAojIENPTkZJR19XTEFOXzgwMjExIGlz
IG5vdCBzZXQKCiMKIyBVU0IgTmV0d29yayBBZGFwdGVycwojCiMgQ09ORklHX1VTQl9DQVRDIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX0tBV0VUSCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9QRUdB
U1VTIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1JUTDgxNTAgaXMgbm90IHNldAojIENPTkZJR19V
U0JfVVNCTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfV0FOIGlzIG5vdCBzZXQKIyBDT05GSUdfRkRE
SSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJUFBJIGlzIG5vdCBzZXQKIyBDT05GSUdfUFBQIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0xJUCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9GQyBpcyBub3Qgc2V0
CiMgQ09ORklHX05FVENPTlNPTEUgaXMgbm90IHNldAojIENPTkZJR19ORVRQT0xMIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkVUX1BPTExfQ09OVFJPTExFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lTRE4g
aXMgbm90IHNldAojIENPTkZJR19QSE9ORSBpcyBub3Qgc2V0CgojCiMgSW5wdXQgZGV2aWNlIHN1
cHBvcnQKIwpDT05GSUdfSU5QVVQ9eQojIENPTkZJR19JTlBVVF9GRl9NRU1MRVNTIGlzIG5vdCBz
ZXQKQ09ORklHX0lOUFVUX1BPTExERVY9eQoKIwojIFVzZXJsYW5kIGludGVyZmFjZXMKIwpDT05G
SUdfSU5QVVRfTU9VU0VERVY9eQpDT05GSUdfSU5QVVRfTU9VU0VERVZfUFNBVVg9eQpDT05GSUdf
SU5QVVRfTU9VU0VERVZfU0NSRUVOX1g9MTAyNApDT05GSUdfSU5QVVRfTU9VU0VERVZfU0NSRUVO
X1k9NzY4CiMgQ09ORklHX0lOUFVUX0pPWURFViBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9FVkRF
Vj15CiMgQ09ORklHX0lOUFVUX0VWQlVHIGlzIG5vdCBzZXQKCiMKIyBJbnB1dCBEZXZpY2UgRHJp
dmVycwojCkNPTkZJR19JTlBVVF9LRVlCT0FSRD15CkNPTkZJR19LRVlCT0FSRF9BVEtCRD15CiMg
Q09ORklHX0tFWUJPQVJEX1NVTktCRCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0xLS0JE
IGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfWFRLQkQgaXMgbm90IHNldAojIENPTkZJR19L
RVlCT0FSRF9ORVdUT04gaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9TVE9XQVdBWSBpcyBu
b3Qgc2V0CkNPTkZJR19JTlBVVF9NT1VTRT15CkNPTkZJR19NT1VTRV9QUzI9eQpDT05GSUdfTU9V
U0VfUFMyX0FMUFM9eQpDT05GSUdfTU9VU0VfUFMyX0xPR0lQUzJQUD15CkNPTkZJR19NT1VTRV9Q
UzJfU1lOQVBUSUNTPXkKQ09ORklHX01PVVNFX1BTMl9MSUZFQk9PSz15CkNPTkZJR19NT1VTRV9Q
UzJfVFJBQ0tQT0lOVD15CiMgQ09ORklHX01PVVNFX1BTMl9UT1VDSEtJVCBpcyBub3Qgc2V0CiMg
Q09ORklHX01PVVNFX1NFUklBTCBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX0FQUExFVE9VQ0gg
aXMgbm90IHNldAojIENPTkZJR19NT1VTRV9WU1hYWEFBIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5Q
VVRfSk9ZU1RJQ0sgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9UQUJMRVQgaXMgbm90IHNldAoj
IENPTkZJR19JTlBVVF9UT1VDSFNDUkVFTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX01JU0Mg
aXMgbm90IHNldAoKIwojIEhhcmR3YXJlIEkvTyBwb3J0cwojCkNPTkZJR19TRVJJTz15CkNPTkZJ
R19TRVJJT19JODA0Mj15CkNPTkZJR19TRVJJT19TRVJQT1JUPXkKIyBDT05GSUdfU0VSSU9fQ1Q4
MkM3MTAgaXMgbm90IHNldAojIENPTkZJR19TRVJJT19QQ0lQUzIgaXMgbm90IHNldApDT05GSUdf
U0VSSU9fTElCUFMyPXkKIyBDT05GSUdfU0VSSU9fUkFXIGlzIG5vdCBzZXQKIyBDT05GSUdfR0FN
RVBPUlQgaXMgbm90IHNldAoKIwojIENoYXJhY3RlciBkZXZpY2VzCiMKQ09ORklHX1ZUPXkKQ09O
RklHX1ZUX0NPTlNPTEU9eQpDT05GSUdfSFdfQ09OU09MRT15CiMgQ09ORklHX1ZUX0hXX0NPTlNP
TEVfQklORElORyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9OT05TVEFOREFSRCBpcyBub3Qg
c2V0CiMgQ09ORklHX05PWk9NSSBpcyBub3Qgc2V0CgojCiMgU2VyaWFsIGRyaXZlcnMKIwpDT05G
SUdfU0VSSUFMXzgyNTA9eQpDT05GSUdfU0VSSUFMXzgyNTBfQ09OU09MRT15CkNPTkZJR19GSVhf
RUFSTFlDT05fTUVNPXkKQ09ORklHX1NFUklBTF84MjUwX1BDST15CkNPTkZJR19TRVJJQUxfODI1
MF9QTlA9eQpDT05GSUdfU0VSSUFMXzgyNTBfTlJfVUFSVFM9NApDT05GSUdfU0VSSUFMXzgyNTBf
UlVOVElNRV9VQVJUUz00CiMgQ09ORklHX1NFUklBTF84MjUwX0VYVEVOREVEIGlzIG5vdCBzZXQK
CiMKIyBOb24tODI1MCBzZXJpYWwgcG9ydCBzdXBwb3J0CiMKQ09ORklHX1NFUklBTF9DT1JFPXkK
Q09ORklHX1NFUklBTF9DT1JFX0NPTlNPTEU9eQojIENPTkZJR19TRVJJQUxfSlNNIGlzIG5vdCBz
ZXQKQ09ORklHX1VOSVg5OF9QVFlTPXkKQ09ORklHX0xFR0FDWV9QVFlTPXkKQ09ORklHX0xFR0FD
WV9QVFlfQ09VTlQ9MjU2CiMgQ09ORklHX0lQTUlfSEFORExFUiBpcyBub3Qgc2V0CkNPTkZJR19I
V19SQU5ET009eQpDT05GSUdfSFdfUkFORE9NX0lOVEVMPXkKIyBDT05GSUdfSFdfUkFORE9NX0FN
RCBpcyBub3Qgc2V0CkNPTkZJR19OVlJBTT15CkNPTkZJR19SVEM9eQojIENPTkZJR19SMzk2NCBp
cyBub3Qgc2V0CiMgQ09ORklHX0FQUExJQ09NIGlzIG5vdCBzZXQKIyBDT05GSUdfTVdBVkUgaXMg
bm90IHNldAojIENPTkZJR19QQzg3MzZ4X0dQSU8gaXMgbm90IHNldAojIENPTkZJR19SQVdfRFJJ
VkVSIGlzIG5vdCBzZXQKQ09ORklHX0hQRVQ9eQojIENPTkZJR19IUEVUX1JUQ19JUlEgaXMgbm90
IHNldApDT05GSUdfSFBFVF9NTUFQPXkKQ09ORklHX0hBTkdDSEVDS19USU1FUj15CiMgQ09ORklH
X1RDR19UUE0gaXMgbm90IHNldAojIENPTkZJR19URUxDTE9DSyBpcyBub3Qgc2V0CkNPTkZJR19E
RVZQT1JUPXkKQ09ORklHX0kyQz15CkNPTkZJR19JMkNfQk9BUkRJTkZPPXkKQ09ORklHX0kyQ19D
SEFSREVWPW0KCiMKIyBJMkMgQWxnb3JpdGhtcwojCkNPTkZJR19JMkNfQUxHT0JJVD15CkNPTkZJ
R19JMkNfQUxHT1BDRj1tCkNPTkZJR19JMkNfQUxHT1BDQT1tCgojCiMgSTJDIEhhcmR3YXJlIEJ1
cyBzdXBwb3J0CiMKQ09ORklHX0kyQ19BTEkxNTM1PW0KQ09ORklHX0kyQ19BTEkxNTYzPW0KQ09O
RklHX0kyQ19BTEkxNVgzPW0KQ09ORklHX0kyQ19BTUQ3NTY9bQpDT05GSUdfSTJDX0FNRDc1Nl9T
NDg4Mj1tCkNPTkZJR19JMkNfQU1EODExMT1tCkNPTkZJR19JMkNfSTgwMT1tCkNPTkZJR19JMkNf
STgxMD1tCkNPTkZJR19JMkNfUElJWDQ9bQpDT05GSUdfSTJDX05GT1JDRTI9bQpDT05GSUdfSTJD
X09DT1JFUz1tCkNPTkZJR19JMkNfUEFSUE9SVF9MSUdIVD1tCkNPTkZJR19JMkNfUFJPU0FWQUdF
PW0KQ09ORklHX0kyQ19TQVZBR0U0PW0KQ09ORklHX0kyQ19TSU1URUM9bQpDT05GSUdfSTJDX1NJ
UzU1OTU9bQpDT05GSUdfSTJDX1NJUzYzMD1tCkNPTkZJR19JMkNfU0lTOTZYPW0KQ09ORklHX0ky
Q19UQU9TX0VWTT1tCkNPTkZJR19JMkNfU1RVQj1tCkNPTkZJR19JMkNfVElOWV9VU0I9bQpDT05G
SUdfSTJDX1ZJQT1tCkNPTkZJR19JMkNfVklBUFJPPW0KQ09ORklHX0kyQ19WT09ET08zPW0KCiMK
IyBNaXNjZWxsYW5lb3VzIEkyQyBDaGlwIHN1cHBvcnQKIwpDT05GSUdfRFMxNjgyPW0KQ09ORklH
X1NFTlNPUlNfRUVQUk9NPW0KQ09ORklHX1NFTlNPUlNfUENGODU3ND1tCkNPTkZJR19QQ0Y4NTc1
PW0KQ09ORklHX1NFTlNPUlNfUENGODU5MT1tCkNPTkZJR19UUFM2NTAxMD1tCkNPTkZJR19TRU5T
T1JTX01BWDY4NzU9bQpDT05GSUdfU0VOU09SU19UU0wyNTUwPW0KIyBDT05GSUdfSTJDX0RFQlVH
X0NPUkUgaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQUxHTyBpcyBub3Qgc2V0CiMgQ09O
RklHX0kyQ19ERUJVR19CVVMgaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQ0hJUCBpcyBu
b3Qgc2V0CgojCiMgU1BJIHN1cHBvcnQKIwojIENPTkZJR19TUEkgaXMgbm90IHNldAojIENPTkZJ
R19TUElfTUFTVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfVzEgaXMgbm90IHNldApDT05GSUdfUE9X
RVJfU1VQUExZPXkKIyBDT05GSUdfUE9XRVJfU1VQUExZX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05G
SUdfUERBX1BPV0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9EUzI3NjAgaXMgbm90IHNl
dApDT05GSUdfSFdNT049eQpDT05GSUdfSFdNT05fVklEPW0KQ09ORklHX1NFTlNPUlNfQUJJVFVH
VVJVPW0KQ09ORklHX1NFTlNPUlNfQUJJVFVHVVJVMz1tCkNPTkZJR19TRU5TT1JTX0FENzQxOD1t
CkNPTkZJR19TRU5TT1JTX0FETTEwMjE9bQpDT05GSUdfU0VOU09SU19BRE0xMDI1PW0KQ09ORklH
X1NFTlNPUlNfQURNMTAyNj1tCkNPTkZJR19TRU5TT1JTX0FETTEwMjk9bQpDT05GSUdfU0VOU09S
U19BRE0xMDMxPW0KQ09ORklHX1NFTlNPUlNfQURNOTI0MD1tCkNPTkZJR19TRU5TT1JTX0FEVDc0
NzA9bQpDT05GSUdfU0VOU09SU19BRFQ3NDczPW0KQ09ORklHX1NFTlNPUlNfSzhURU1QPW0KQ09O
RklHX1NFTlNPUlNfQVNCMTAwPW0KQ09ORklHX1NFTlNPUlNfQVRYUDE9bQpDT05GSUdfU0VOU09S
U19EUzE2MjE9bQpDT05GSUdfU0VOU09SU19JNUtfQU1CPW0KQ09ORklHX1NFTlNPUlNfRjcxODA1
Rj1tCkNPTkZJR19TRU5TT1JTX0Y3MTg4MkZHPW0KQ09ORklHX1NFTlNPUlNfRjc1Mzc1Uz1tCkNP
TkZJR19TRU5TT1JTX0ZTQ0hFUj1tCkNPTkZJR19TRU5TT1JTX0ZTQ1BPUz1tCkNPTkZJR19TRU5T
T1JTX0ZTQ0hNRD1tCkNPTkZJR19TRU5TT1JTX0dMNTE4U009bQpDT05GSUdfU0VOU09SU19HTDUy
MFNNPW0KQ09ORklHX1NFTlNPUlNfQ09SRVRFTVA9bQpDT05GSUdfU0VOU09SU19JVDg3PW0KQ09O
RklHX1NFTlNPUlNfTE02Mz1tCkNPTkZJR19TRU5TT1JTX0xNNzU9bQpDT05GSUdfU0VOU09SU19M
TTc3PW0KQ09ORklHX1NFTlNPUlNfTE03OD1tCkNPTkZJR19TRU5TT1JTX0xNODA9bQpDT05GSUdf
U0VOU09SU19MTTgzPW0KQ09ORklHX1NFTlNPUlNfTE04NT1tCkNPTkZJR19TRU5TT1JTX0xNODc9
bQpDT05GSUdfU0VOU09SU19MTTkwPW0KQ09ORklHX1NFTlNPUlNfTE05Mj1tCkNPTkZJR19TRU5T
T1JTX0xNOTM9bQpDT05GSUdfU0VOU09SU19NQVgxNjE5PW0KQ09ORklHX1NFTlNPUlNfTUFYNjY1
MD1tCkNPTkZJR19TRU5TT1JTX1BDODczNjA9bQpDT05GSUdfU0VOU09SU19QQzg3NDI3PW0KQ09O
RklHX1NFTlNPUlNfU0lTNTU5NT1tCkNPTkZJR19TRU5TT1JTX0RNRTE3Mzc9bQpDT05GSUdfU0VO
U09SU19TTVNDNDdNMT1tCkNPTkZJR19TRU5TT1JTX1NNU0M0N00xOTI9bQpDT05GSUdfU0VOU09S
U19TTVNDNDdCMzk3PW0KQ09ORklHX1NFTlNPUlNfQURTNzgyOD1tCkNPTkZJR19TRU5TT1JTX1RI
TUM1MD1tCkNPTkZJR19TRU5TT1JTX1ZJQTY4NkE9bQpDT05GSUdfU0VOU09SU19WVDEyMTE9bQpD
T05GSUdfU0VOU09SU19WVDgyMzE9bQpDT05GSUdfU0VOU09SU19XODM3ODFEPW0KQ09ORklHX1NF
TlNPUlNfVzgzNzkxRD1tCkNPTkZJR19TRU5TT1JTX1c4Mzc5MkQ9bQpDT05GSUdfU0VOU09SU19X
ODM3OTM9bQpDT05GSUdfU0VOU09SU19XODNMNzg1VFM9bQpDT05GSUdfU0VOU09SU19XODNMNzg2
Tkc9bQpDT05GSUdfU0VOU09SU19XODM2MjdIRj1tCkNPTkZJR19TRU5TT1JTX1c4MzYyN0VIRj1t
CiMgQ09ORklHX1NFTlNPUlNfSERBUFMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FQUExF
U01DIGlzIG5vdCBzZXQKIyBDT05GSUdfSFdNT05fREVCVUdfQ0hJUCBpcyBub3Qgc2V0CkNPTkZJ
R19USEVSTUFMPXkKIyBDT05GSUdfV0FUQ0hET0cgaXMgbm90IHNldAoKIwojIFNvbmljcyBTaWxp
Y29uIEJhY2twbGFuZQojCkNPTkZJR19TU0JfUE9TU0lCTEU9eQojIENPTkZJR19TU0IgaXMgbm90
IHNldAoKIwojIE11bHRpZnVuY3Rpb24gZGV2aWNlIGRyaXZlcnMKIwojIENPTkZJR19NRkRfU001
MDEgaXMgbm90IHNldAoKIwojIE11bHRpbWVkaWEgZGV2aWNlcwojCiMgQ09ORklHX1ZJREVPX0RF
ViBpcyBub3Qgc2V0CiMgQ09ORklHX0RWQl9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfREFCIGlz
IG5vdCBzZXQKCiMKIyBHcmFwaGljcyBzdXBwb3J0CiMKQ09ORklHX0FHUD15CkNPTkZJR19BR1Bf
QU1ENjQ9eQojIENPTkZJR19BR1BfSU5URUwgaXMgbm90IHNldAojIENPTkZJR19BR1BfU0lTIGlz
IG5vdCBzZXQKIyBDT05GSUdfQUdQX1ZJQSBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTSBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZHQVNUQVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fT1VUUFVUX0NP
TlRST0wgaXMgbm90IHNldApDT05GSUdfRkI9eQojIENPTkZJR19GSVJNV0FSRV9FRElEIGlzIG5v
dCBzZXQKIyBDT05GSUdfRkJfRERDIGlzIG5vdCBzZXQKQ09ORklHX0ZCX0NGQl9GSUxMUkVDVD15
CkNPTkZJR19GQl9DRkJfQ09QWUFSRUE9eQpDT05GSUdfRkJfQ0ZCX0lNQUdFQkxJVD15CiMgQ09O
RklHX0ZCX0NGQl9SRVZfUElYRUxTX0lOX0JZVEUgaXMgbm90IHNldAojIENPTkZJR19GQl9TWVNf
RklMTFJFQ1QgaXMgbm90IHNldAojIENPTkZJR19GQl9TWVNfQ09QWUFSRUEgaXMgbm90IHNldAoj
IENPTkZJR19GQl9TWVNfSU1BR0VCTElUIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0ZPUFMg
aXMgbm90IHNldApDT05GSUdfRkJfREVGRVJSRURfSU89eQojIENPTkZJR19GQl9TVkdBTElCIGlz
IG5vdCBzZXQKIyBDT05GSUdfRkJfTUFDTU9ERVMgaXMgbm90IHNldAojIENPTkZJR19GQl9CQUNL
TElHSFQgaXMgbm90IHNldAojIENPTkZJR19GQl9NT0RFX0hFTFBFUlMgaXMgbm90IHNldAojIENP
TkZJR19GQl9USUxFQkxJVFRJTkcgaXMgbm90IHNldAoKIwojIEZyYW1lIGJ1ZmZlciBoYXJkd2Fy
ZSBkcml2ZXJzCiMKIyBDT05GSUdfRkJfQ0lSUlVTIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUE0y
IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQ1lCRVIyMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJf
QVJDIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQVNJTElBTlQgaXMgbm90IHNldAojIENPTkZJR19G
Ql9JTVNUVCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1ZHQTE2IGlzIG5vdCBzZXQKQ09ORklHX0ZC
X1ZFU0E9eQojIENPTkZJR19GQl9FRkkgaXMgbm90IHNldAojIENPTkZJR19GQl9IRUNVQkEgaXMg
bm90IHNldAojIENPTkZJR19GQl9IR0EgaXMgbm90IHNldAojIENPTkZJR19GQl9TMUQxM1hYWCBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZCX05WSURJQSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1JJVkEg
aXMgbm90IHNldAojIENPTkZJR19GQl9MRTgwNTc4IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfSU5U
RUwgaXMgbm90IHNldAojIENPTkZJR19GQl9NQVRST1ggaXMgbm90IHNldAojIENPTkZJR19GQl9S
QURFT04gaXMgbm90IHNldAojIENPTkZJR19GQl9BVFkxMjggaXMgbm90IHNldAojIENPTkZJR19G
Ql9BVFkgaXMgbm90IHNldAojIENPTkZJR19GQl9TMyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1NB
VkFHRSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1NJUyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX05F
T01BR0lDIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfS1lSTyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZC
XzNERlggaXMgbm90IHNldAojIENPTkZJR19GQl9WT09ET08xIGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfVlQ4NjIzIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVFJJREVOVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZCX0FSSyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1BNMyBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX0dFT0RFIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVklSVFVBTCBpcyBub3Qgc2V0CiMgQ09O
RklHX0JBQ0tMSUdIVF9MQ0RfU1VQUE9SVCBpcyBub3Qgc2V0CgojCiMgRGlzcGxheSBkZXZpY2Ug
c3VwcG9ydAojCkNPTkZJR19ESVNQTEFZX1NVUFBPUlQ9eQoKIwojIERpc3BsYXkgaGFyZHdhcmUg
ZHJpdmVycwojCgojCiMgQ29uc29sZSBkaXNwbGF5IGRyaXZlciBzdXBwb3J0CiMKQ09ORklHX1ZH
QV9DT05TT0xFPXkKQ09ORklHX1ZHQUNPTl9TT0ZUX1NDUk9MTEJBQ0s9eQpDT05GSUdfVkdBQ09O
X1NPRlRfU0NST0xMQkFDS19TSVpFPTQwOTYKQ09ORklHX1ZJREVPX1NFTEVDVD15CkNPTkZJR19E
VU1NWV9DT05TT0xFPXkKQ09ORklHX0ZSQU1FQlVGRkVSX0NPTlNPTEU9eQojIENPTkZJR19GUkFN
RUJVRkZFUl9DT05TT0xFX0RFVEVDVF9QUklNQVJZIGlzIG5vdCBzZXQKIyBDT05GSUdfRlJBTUVC
VUZGRVJfQ09OU09MRV9ST1RBVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0NPTl9ERUNPUiBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZPTlRTIGlzIG5vdCBzZXQKQ09ORklHX0ZPTlRfOHg4PXkKQ09O
RklHX0ZPTlRfOHgxNj15CkNPTkZJR19MT0dPPXkKIyBDT05GSUdfTE9HT19MSU5VWF9NT05PIGlz
IG5vdCBzZXQKIyBDT05GSUdfTE9HT19MSU5VWF9WR0ExNiBpcyBub3Qgc2V0CkNPTkZJR19MT0dP
X0xJTlVYX0NMVVQyMjQ9eQoKIwojIFNvdW5kCiMKQ09ORklHX1NPVU5EPXkKCiMKIyBBZHZhbmNl
ZCBMaW51eCBTb3VuZCBBcmNoaXRlY3R1cmUKIwpDT05GSUdfU05EPXkKQ09ORklHX1NORF9USU1F
Uj15CkNPTkZJR19TTkRfUENNPXkKIyBDT05GSUdfU05EX1NFUVVFTkNFUiBpcyBub3Qgc2V0CkNP
TkZJR19TTkRfT1NTRU1VTD15CkNPTkZJR19TTkRfTUlYRVJfT1NTPXkKQ09ORklHX1NORF9QQ01f
T1NTPXkKQ09ORklHX1NORF9QQ01fT1NTX1BMVUdJTlM9eQpDT05GSUdfU05EX1JUQ1RJTUVSPXkK
IyBDT05GSUdfU05EX0RZTkFNSUNfTUlOT1JTIGlzIG5vdCBzZXQKQ09ORklHX1NORF9TVVBQT1JU
X09MRF9BUEk9eQpDT05GSUdfU05EX1ZFUkJPU0VfUFJPQ0ZTPXkKIyBDT05GSUdfU05EX1ZFUkJP
U0VfUFJJTlRLIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0RFQlVHIGlzIG5vdCBzZXQKCiMKIyBH
ZW5lcmljIGRldmljZXMKIwpDT05GSUdfU05EX0FDOTdfQ09ERUM9eQojIENPTkZJR19TTkRfRFVN
TVkgaXMgbm90IHNldAojIENPTkZJR19TTkRfTVRQQVYgaXMgbm90IHNldAojIENPTkZJR19TTkRf
U0VSSUFMX1UxNjU1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9NUFU0MDEgaXMgbm90IHNldAoK
IwojIFBDSSBkZXZpY2VzCiMKIyBDT05GSUdfU05EX0FEMTg4OSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9BTFMzMDAgaXMgbm90IHNldAojIENPTkZJR19TTkRfQUxTNDAwMCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9BTEk1NDUxIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FUSUlYUCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9BVElJWFBfTU9ERU0gaXMgbm90IHNldAojIENPTkZJR19TTkRfQVU4
ODEwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FVODgyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9BVTg4MzAgaXMgbm90IHNldAojIENPTkZJR19TTkRfQVpUMzMyOCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9CVDg3WCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9DQTAxMDYgaXMgbm90IHNldAoj
IENPTkZJR19TTkRfQ01JUENJIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX09YWUdFTiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9DUzQyODEgaXMgbm90IHNldAojIENPTkZJR19TTkRfQ1M0NlhYIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX0NTNTUzMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9EQVJM
QTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0dJTkEyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9MQVlMQTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0RBUkxBMjQgaXMgbm90IHNldAojIENP
TkZJR19TTkRfR0lOQTI0IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0xBWUxBMjQgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfTU9OQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9NSUEgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfRUNITzNHIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0lORElHTyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NORF9JTkRJR09JTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9JTkRJ
R09ESiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9FTVUxMEsxIGlzIG5vdCBzZXQKIyBDT05GSUdf
U05EX0VNVTEwSzFYIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0VOUzEzNzAgaXMgbm90IHNldAoj
IENPTkZJR19TTkRfRU5TMTM3MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9FUzE5MzggaXMgbm90
IHNldAojIENPTkZJR19TTkRfRVMxOTY4IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0ZNODAxIGlz
IG5vdCBzZXQKQ09ORklHX1NORF9IREFfSU5URUw9eQojIENPTkZJR19TTkRfSERBX0hXREVQIGlz
IG5vdCBzZXQKQ09ORklHX1NORF9IREFfQ09ERUNfUkVBTFRFSz15CkNPTkZJR19TTkRfSERBX0NP
REVDX0FOQUxPRz15CkNPTkZJR19TTkRfSERBX0NPREVDX1NJR01BVEVMPXkKQ09ORklHX1NORF9I
REFfQ09ERUNfVklBPXkKQ09ORklHX1NORF9IREFfQ09ERUNfQVRJSERNST15CkNPTkZJR19TTkRf
SERBX0NPREVDX0NPTkVYQU5UPXkKQ09ORklHX1NORF9IREFfQ09ERUNfQ01FRElBPXkKQ09ORklH
X1NORF9IREFfQ09ERUNfU0kzMDU0PXkKQ09ORklHX1NORF9IREFfR0VORVJJQz15CiMgQ09ORklH
X1NORF9IREFfUE9XRVJfU0FWRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9IRFNQIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0hEU1BNIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hJRklFUiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NORF9JQ0UxNzEyIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0lDRTE3
MjQgaXMgbm90IHNldApDT05GSUdfU05EX0lOVEVMOFgwPXkKIyBDT05GSUdfU05EX0lOVEVMOFgw
TSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9LT1JHMTIxMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9NQUVTVFJPMyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9NSVhBUlQgaXMgbm90IHNldAojIENP
TkZJR19TTkRfTk0yNTYgaXMgbm90IHNldAojIENPTkZJR19TTkRfUENYSFIgaXMgbm90IHNldAoj
IENPTkZJR19TTkRfUklQVElERSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9STUUzMiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9STUU5NiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9STUU5NjUyIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX1NPTklDVklCRVMgaXMgbm90IHNldAojIENPTkZJR19TTkRf
VFJJREVOVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9WSUE4MlhYIGlzIG5vdCBzZXQKIyBDT05G
SUdfU05EX1ZJQTgyWFhfTU9ERU0gaXMgbm90IHNldAojIENPTkZJR19TTkRfVklSVFVPU08gaXMg
bm90IHNldAojIENPTkZJR19TTkRfVlgyMjIgaXMgbm90IHNldAojIENPTkZJR19TTkRfWU1GUENJ
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FDOTdfUE9XRVJfU0FWRSBpcyBub3Qgc2V0CgojCiMg
VVNCIGRldmljZXMKIwojIENPTkZJR19TTkRfVVNCX0FVRElPIGlzIG5vdCBzZXQKIyBDT05GSUdf
U05EX1VTQl9VU1gyWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9VU0JfQ0FJQVEgaXMgbm90IHNl
dAoKIwojIFN5c3RlbSBvbiBDaGlwIGF1ZGlvIHN1cHBvcnQKIwojIENPTkZJR19TTkRfU09DIGlz
IG5vdCBzZXQKCiMKIyBTb0MgQXVkaW8gc3VwcG9ydCBmb3IgU3VwZXJICiMKCiMKIyBBTFNBIFNv
QyBhdWRpbyBmb3IgRnJlZXNjYWxlIFNPQ3MKIwoKIwojIE9wZW4gU291bmQgU3lzdGVtCiMKIyBD
T05GSUdfU09VTkRfUFJJTUUgaXMgbm90IHNldApDT05GSUdfQUM5N19CVVM9eQpDT05GSUdfSElE
X1NVUFBPUlQ9eQpDT05GSUdfSElEPXkKIyBDT05GSUdfSElEX0RFQlVHIGlzIG5vdCBzZXQKIyBD
T05GSUdfSElEUkFXIGlzIG5vdCBzZXQKCiMKIyBVU0IgSW5wdXQgRGV2aWNlcwojCkNPTkZJR19V
U0JfSElEPXkKQ09ORklHX1VTQl9ISURJTlBVVF9QT1dFUkJPT0s9eQojIENPTkZJR19ISURfRkYg
aXMgbm90IHNldApDT05GSUdfVVNCX0hJRERFVj15CkNPTkZJR19VU0JfU1VQUE9SVD15CkNPTkZJ
R19VU0JfQVJDSF9IQVNfSENEPXkKQ09ORklHX1VTQl9BUkNIX0hBU19PSENJPXkKQ09ORklHX1VT
Ql9BUkNIX0hBU19FSENJPXkKQ09ORklHX1VTQj15CiMgQ09ORklHX1VTQl9ERUJVRyBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9BTk5PVU5DRV9ORVdfREVWSUNFUyBpcyBub3Qgc2V0CgojCiMgTWlz
Y2VsbGFuZW91cyBVU0Igb3B0aW9ucwojCkNPTkZJR19VU0JfREVWSUNFRlM9eQojIENPTkZJR19V
U0JfREVWSUNFX0NMQVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0RZTkFNSUNfTUlOT1JTIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX1NVU1BFTkQgaXMgbm90IHNldAojIENPTkZJR19VU0JfUEVS
U0lTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9PVEcgaXMgbm90IHNldAoKIwojIFVTQiBIb3N0
IENvbnRyb2xsZXIgRHJpdmVycwojCkNPTkZJR19VU0JfRUhDSV9IQ0Q9eQojIENPTkZJR19VU0Jf
RUhDSV9ST09UX0hVQl9UVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9FSENJX1RUX05FV1NDSEVE
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDExNlhfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX09IQ0lfSENEIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9VSENJX0hDRD15CiMgQ09ORklHX1VT
Ql9TTDgxMV9IQ0QgaXMgbm90IHNldAojIENPTkZJR19VU0JfUjhBNjY1OTdfSENEIGlzIG5vdCBz
ZXQKCiMKIyBVU0IgRGV2aWNlIENsYXNzIGRyaXZlcnMKIwojIENPTkZJR19VU0JfQUNNIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX1BSSU5URVIgaXMgbm90IHNldAoKIwojIE5PVEU6IFVTQl9TVE9S
QUdFIGVuYWJsZXMgU0NTSSwgYW5kICdTQ1NJIGRpc2sgc3VwcG9ydCcKIwoKIwojIG1heSBhbHNv
IGJlIG5lZWRlZDsgc2VlIFVTQl9TVE9SQUdFIEhlbHAgZm9yIG1vcmUgaW5mb3JtYXRpb24KIwpD
T05GSUdfVVNCX1NUT1JBR0U9eQojIENPTkZJR19VU0JfU1RPUkFHRV9ERUJVRyBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9TVE9SQUdFX0RBVEFGQUIgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RP
UkFHRV9GUkVFQ09NIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfSVNEMjAwIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfRFBDTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9T
VE9SQUdFX1VTQkFUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfU0REUjA5IGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfU0REUjU1IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X1NUT1JBR0VfSlVNUFNIT1QgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9BTEFVREEg
aXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9LQVJNQSBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9MSUJVU1VBTCBpcyBub3Qgc2V0CgojCiMgVVNCIEltYWdpbmcgZGV2aWNlcwojCiMgQ09O
RklHX1VTQl9NREM4MDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfTUlDUk9URUsgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfTU9OIGlzIG5vdCBzZXQKCiMKIyBVU0IgcG9ydCBkcml2ZXJzCiMKIyBD
T05GSUdfVVNCX1NFUklBTCBpcyBub3Qgc2V0CgojCiMgVVNCIE1pc2NlbGxhbmVvdXMgZHJpdmVy
cwojCiMgQ09ORklHX1VTQl9FTUk2MiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9FTUkyNiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9BRFVUVVggaXMgbm90IHNldAojIENPTkZJR19VU0JfQVVFUlNX
QUxEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1JJTzUwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9MRUdPVE9XRVIgaXMgbm90IHNldAojIENPTkZJR19VU0JfTENEIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX0JFUlJZX0NIQVJHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRUQgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfQ1lQUkVTU19DWTdDNjMgaXMgbm90IHNldAojIENPTkZJR19VU0JfQ1lU
SEVSTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9QSElER0VUIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0lETU9VU0UgaXMgbm90IHNldAojIENPTkZJR19VU0JfRlRESV9FTEFOIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX0FQUExFRElTUExBWSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TSVNVU0JW
R0EgaXMgbm90IHNldAojIENPTkZJR19VU0JfTEQgaXMgbm90IHNldAojIENPTkZJR19VU0JfVFJB
TkNFVklCUkFUT1IgaXMgbm90IHNldAojIENPTkZJR19VU0JfSU9XQVJSSU9SIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19VU0JfR0FER0VUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTU1DIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVNU1RJQ0sgaXMgbm90IHNldApD
T05GSUdfTkVXX0xFRFM9eQpDT05GSUdfTEVEU19DTEFTUz15CgojCiMgTEVEIGRyaXZlcnMKIwoj
IENPTkZJR19MRURTX0NMRVZPX01BSUwgaXMgbm90IHNldAoKIwojIExFRCBUcmlnZ2VycwojCiMg
Q09ORklHX0xFRFNfVFJJR0dFUlMgaXMgbm90IHNldAojIENPTkZJR19JTkZJTklCQU5EIGlzIG5v
dCBzZXQKIyBDT05GSUdfRURBQyBpcyBub3Qgc2V0CkNPTkZJR19SVENfTElCPXkKQ09ORklHX1JU
Q19DTEFTUz15CgojCiMgQ29uZmxpY3RpbmcgUlRDIG9wdGlvbiBoYXMgYmVlbiBzZWxlY3RlZCwg
Y2hlY2sgR0VOX1JUQyBhbmQgUlRDCiMKQ09ORklHX1JUQ19IQ1RPU1lTPXkKQ09ORklHX1JUQ19I
Q1RPU1lTX0RFVklDRT0icnRjMCIKIyBDT05GSUdfUlRDX0RFQlVHIGlzIG5vdCBzZXQKCiMKIyBS
VEMgaW50ZXJmYWNlcwojCkNPTkZJR19SVENfSU5URl9TWVNGUz15CkNPTkZJR19SVENfSU5URl9Q
Uk9DPXkKQ09ORklHX1JUQ19JTlRGX0RFVj15CiMgQ09ORklHX1JUQ19JTlRGX0RFVl9VSUVfRU1V
TCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfVEVTVCBpcyBub3Qgc2V0CgojCiMgSTJDIFJU
QyBkcml2ZXJzCiMKIyBDT05GSUdfUlRDX0RSVl9EUzEzMDcgaXMgbm90IHNldAojIENPTkZJR19S
VENfRFJWX0RTMTM3NCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxNjcyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUlRDX0RSVl9NQVg2OTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9S
UzVDMzcyIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9JU0wxMjA4IGlzIG5vdCBzZXQKIyBD
T05GSUdfUlRDX0RSVl9YMTIwNSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUENGODU2MyBp
cyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUENGODU4MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JU
Q19EUlZfTTQxVDgwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9TMzUzOTBBIGlzIG5vdCBz
ZXQKCiMKIyBTUEkgUlRDIGRyaXZlcnMKIwoKIwojIFBsYXRmb3JtIFJUQyBkcml2ZXJzCiMKIyBD
T05GSUdfUlRDX0RSVl9DTU9TIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE1MTEgaXMg
bm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTU1MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19E
UlZfRFMxNzQyIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9TVEsxN1RBOCBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfTTQ4VDg2IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NNDhU
NTkgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1YzMDIwIGlzIG5vdCBzZXQKCiMKIyBvbi1D
UFUgUlRDIGRyaXZlcnMKIwpDT05GSUdfRE1BREVWSUNFUz15CgojCiMgRE1BIERldmljZXMKIwoj
IENPTkZJR19JTlRFTF9JT0FURE1BIGlzIG5vdCBzZXQKCiMKIyBVc2Vyc3BhY2UgSS9PCiMKIyBD
T05GSUdfVUlPIGlzIG5vdCBzZXQKCiMKIyBGaXJtd2FyZSBEcml2ZXJzCiMKIyBDT05GSUdfRURE
IGlzIG5vdCBzZXQKIyBDT05GSUdfREVMTF9SQlUgaXMgbm90IHNldAojIENPTkZJR19EQ0RCQVMg
aXMgbm90IHNldApDT05GSUdfRE1JSUQ9eQoKIwojIEZpbGUgc3lzdGVtcwojCkNPTkZJR19FWFQy
X0ZTPXkKQ09ORklHX0VYVDJfRlNfWEFUVFI9eQpDT05GSUdfRVhUMl9GU19QT1NJWF9BQ0w9eQoj
IENPTkZJR19FWFQyX0ZTX1NFQ1VSSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfRVhUMl9GU19YSVAg
aXMgbm90IHNldApDT05GSUdfRVhUM19GUz15CkNPTkZJR19FWFQzX0ZTX1hBVFRSPXkKQ09ORklH
X0VYVDNfRlNfUE9TSVhfQUNMPXkKIyBDT05GSUdfRVhUM19GU19TRUNVUklUWSBpcyBub3Qgc2V0
CiMgQ09ORklHX0VYVDRERVZfRlMgaXMgbm90IHNldApDT05GSUdfSkJEPXkKQ09ORklHX0ZTX01C
Q0FDSEU9eQpDT05GSUdfUkVJU0VSRlNfRlM9eQojIENPTkZJR19SRUlTRVJGU19DSEVDSyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JFSVNFUkZTX1BST0NfSU5GTyBpcyBub3Qgc2V0CkNPTkZJR19SRUlT
RVJGU19GU19YQVRUUj15CkNPTkZJR19SRUlTRVJGU19GU19QT1NJWF9BQ0w9eQpDT05GSUdfUkVJ
U0VSRlNfRlNfU0VDVVJJVFk9eQojIENPTkZJR19KRlNfRlMgaXMgbm90IHNldApDT05GSUdfRlNf
UE9TSVhfQUNMPXkKIyBDT05GSUdfWEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfR0ZTMl9GUyBp
cyBub3Qgc2V0CiMgQ09ORklHX09DRlMyX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0ROT1RJRlk9eQpD
T05GSUdfSU5PVElGWT15CkNPTkZJR19JTk9USUZZX1VTRVI9eQojIENPTkZJR19RVU9UQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FVVE9GU19GUyBpcyBub3Qgc2V0CkNPTkZJR19BVVRPRlM0X0ZTPXkK
IyBDT05GSUdfRlVTRV9GUyBpcyBub3Qgc2V0CgojCiMgQ0QtUk9NL0RWRCBGaWxlc3lzdGVtcwoj
CkNPTkZJR19JU085NjYwX0ZTPXkKQ09ORklHX0pPTElFVD15CkNPTkZJR19aSVNPRlM9eQpDT05G
SUdfVURGX0ZTPXkKQ09ORklHX1VERl9OTFM9eQoKIwojIERPUy9GQVQvTlQgRmlsZXN5c3RlbXMK
IwpDT05GSUdfRkFUX0ZTPXkKQ09ORklHX01TRE9TX0ZTPXkKQ09ORklHX1ZGQVRfRlM9eQpDT05G
SUdfRkFUX0RFRkFVTFRfQ09ERVBBR0U9NDM3CkNPTkZJR19GQVRfREVGQVVMVF9JT0NIQVJTRVQ9
Imlzbzg4NTktMSIKQ09ORklHX05URlNfRlM9eQojIENPTkZJR19OVEZTX0RFQlVHIGlzIG5vdCBz
ZXQKQ09ORklHX05URlNfUlc9eQoKIwojIFBzZXVkbyBmaWxlc3lzdGVtcwojCkNPTkZJR19QUk9D
X0ZTPXkKQ09ORklHX1BST0NfS0NPUkU9eQpDT05GSUdfUFJPQ19TWVNDVEw9eQpDT05GSUdfU1lT
RlM9eQpDT05GSUdfVE1QRlM9eQojIENPTkZJR19UTVBGU19QT1NJWF9BQ0wgaXMgbm90IHNldApD
T05GSUdfSFVHRVRMQkZTPXkKQ09ORklHX0hVR0VUTEJfUEFHRT15CiMgQ09ORklHX0NPTkZJR0ZT
X0ZTIGlzIG5vdCBzZXQKCiMKIyBNaXNjZWxsYW5lb3VzIGZpbGVzeXN0ZW1zCiMKIyBDT05GSUdf
QURGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FGRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19I
RlNfRlMgaXMgbm90IHNldAojIENPTkZJR19IRlNQTFVTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdf
QkVGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0JGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0VG
U19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSQU1GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NRVUFT
SEZTIGlzIG5vdCBzZXQKIyBDT05GSUdfVlhGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX01JTklY
X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSFBGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1FOWDRG
U19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JPTUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lT
Vl9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VGU19GUyBpcyBub3Qgc2V0CkNPTkZJR19ORVRXT1JL
X0ZJTEVTWVNURU1TPXkKQ09ORklHX05GU19GUz15CkNPTkZJR19ORlNfVjM9eQpDT05GSUdfTkZT
X1YzX0FDTD15CiMgQ09ORklHX05GU19WNCBpcyBub3Qgc2V0CiMgQ09ORklHX05GU19ESVJFQ1RJ
TyBpcyBub3Qgc2V0CkNPTkZJR19ORlNEPXkKQ09ORklHX05GU0RfVjJfQUNMPXkKQ09ORklHX05G
U0RfVjM9eQpDT05GSUdfTkZTRF9WM19BQ0w9eQojIENPTkZJR19ORlNEX1Y0IGlzIG5vdCBzZXQK
Q09ORklHX05GU0RfVENQPXkKIyBDT05GSUdfUk9PVF9ORlMgaXMgbm90IHNldApDT05GSUdfTE9D
S0Q9eQpDT05GSUdfTE9DS0RfVjQ9eQpDT05GSUdfRVhQT1JURlM9eQpDT05GSUdfTkZTX0FDTF9T
VVBQT1JUPXkKQ09ORklHX05GU19DT01NT049eQpDT05GSUdfU1VOUlBDPXkKIyBDT05GSUdfU1VO
UlBDX0JJTkQzNCBpcyBub3Qgc2V0CiMgQ09ORklHX1JQQ1NFQ19HU1NfS1JCNSBpcyBub3Qgc2V0
CiMgQ09ORklHX1JQQ1NFQ19HU1NfU1BLTTMgaXMgbm90IHNldApDT05GSUdfU01CX0ZTPXkKQ09O
RklHX1NNQl9OTFNfREVGQVVMVD15CkNPTkZJR19TTUJfTkxTX1JFTU9URT0iY3A0MzciCkNPTkZJ
R19DSUZTPXkKIyBDT05GSUdfQ0lGU19TVEFUUyBpcyBub3Qgc2V0CkNPTkZJR19DSUZTX1dFQUtf
UFdfSEFTSD15CkNPTkZJR19DSUZTX1hBVFRSPXkKQ09ORklHX0NJRlNfUE9TSVg9eQojIENPTkZJ
R19DSUZTX0RFQlVHMiBpcyBub3Qgc2V0CiMgQ09ORklHX0NJRlNfRVhQRVJJTUVOVEFMIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkNQX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09EQV9GUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0FGU19GUyBpcyBub3Qgc2V0CgojCiMgUGFydGl0aW9uIFR5cGVzCiMKIyBD
T05GSUdfUEFSVElUSU9OX0FEVkFOQ0VEIGlzIG5vdCBzZXQKQ09ORklHX01TRE9TX1BBUlRJVElP
Tj15CkNPTkZJR19OTFM9eQpDT05GSUdfTkxTX0RFRkFVTFQ9Imlzbzg4NTktMSIKQ09ORklHX05M
U19DT0RFUEFHRV80Mzc9eQojIENPTkZJR19OTFNfQ09ERVBBR0VfNzM3IGlzIG5vdCBzZXQKIyBD
T05GSUdfTkxTX0NPREVQQUdFXzc3NSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84
NTAgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODUyIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkxTX0NPREVQQUdFXzg1NSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NTcg
aXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYwIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkxTX0NPREVQQUdFXzg2MSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjIgaXMg
bm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYzIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxT
X0NPREVQQUdFXzg2NCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjUgaXMgbm90
IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODY2IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NP
REVQQUdFXzg2OSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85MzYgaXMgbm90IHNl
dAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTUwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQ
QUdFXzkzMiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85NDkgaXMgbm90IHNldAoj
IENPTkZJR19OTFNfQ09ERVBBR0VfODc0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlf
OCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV8xMjUwIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkxTX0NPREVQQUdFXzEyNTEgaXMgbm90IHNldApDT05GSUdfTkxTX0FTQ0lJPXkKQ09ORklH
X05MU19JU084ODU5XzE9eQojIENPTkZJR19OTFNfSVNPODg1OV8yIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkxTX0lTTzg4NTlfMyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzQgaXMgbm90
IHNldAojIENPTkZJR19OTFNfSVNPODg1OV81IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4
NTlfNiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzcgaXMgbm90IHNldAojIENPTkZJ
R19OTFNfSVNPODg1OV85IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMTMgaXMgbm90
IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8xNCBpcyBub3Qgc2V0CkNPTkZJR19OTFNfSVNPODg1
OV8xNT15CiMgQ09ORklHX05MU19LT0k4X1IgaXMgbm90IHNldAojIENPTkZJR19OTFNfS09JOF9V
IGlzIG5vdCBzZXQKQ09ORklHX05MU19VVEY4PXkKIyBDT05GSUdfRExNIGlzIG5vdCBzZXQKCiMK
IyBLZXJuZWwgaGFja2luZwojCkNPTkZJR19UUkFDRV9JUlFGTEFHU19TVVBQT1JUPXkKQ09ORklH
X1BSSU5US19USU1FPXkKQ09ORklHX0VOQUJMRV9XQVJOX0RFUFJFQ0FURUQ9eQojIENPTkZJR19F
TkFCTEVfTVVTVF9DSEVDSyBpcyBub3Qgc2V0CkNPTkZJR19NQUdJQ19TWVNSUT15CkNPTkZJR19V
TlVTRURfU1lNQk9MUz15CiMgQ09ORklHX0RFQlVHX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSEVB
REVSU19DSEVDSyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0tFUk5FTCBpcyBub3Qgc2V0CkNP
TkZJR19ERUJVR19CVUdWRVJCT1NFPXkKIyBDT05GSUdfTEFURU5DWVRPUCBpcyBub3Qgc2V0CiMg
Q09ORklHX1BST1ZJREVfT0hDSTEzOTRfRE1BX0lOSVQgaXMgbm90IHNldAojIENPTkZJR19TQU1Q
TEVTIGlzIG5vdCBzZXQKQ09ORklHX0VBUkxZX1BSSU5USz15CkNPTkZJR19YODZfTVBQQVJTRT15
CkNPTkZJR19JT19ERUxBWV9UWVBFXzBYODA9MApDT05GSUdfSU9fREVMQVlfVFlQRV8wWEVEPTEK
Q09ORklHX0lPX0RFTEFZX1RZUEVfVURFTEFZPTIKQ09ORklHX0lPX0RFTEFZX1RZUEVfTk9ORT0z
CkNPTkZJR19JT19ERUxBWV8wWDgwPXkKIyBDT05GSUdfSU9fREVMQVlfMFhFRCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lPX0RFTEFZX1VERUxBWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lPX0RFTEFZX05P
TkUgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9JT19ERUxBWV9UWVBFPTAKCiMKIyBTZWN1cml0
eSBvcHRpb25zCiMKIyBDT05GSUdfS0VZUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFQ1VSSVRZIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VDVVJJVFlfRklMRV9DQVBBQklMSVRJRVMgaXMgbm90IHNldApD
T05GSUdfWE9SX0JMT0NLUz15CkNPTkZJR19BU1lOQ19DT1JFPXkKQ09ORklHX0FTWU5DX01FTUNQ
WT15CkNPTkZJR19BU1lOQ19YT1I9eQpDT05GSUdfQ1JZUFRPPXkKQ09ORklHX0NSWVBUT19BTEdB
UEk9eQpDT05GSUdfQ1JZUFRPX0FFQUQ9eQpDT05GSUdfQ1JZUFRPX0JMS0NJUEhFUj15CiMgQ09O
RklHX0NSWVBUT19TRVFJViBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fSEFTSD15CkNPTkZJR19D
UllQVE9fTUFOQUdFUj15CkNPTkZJR19DUllQVE9fSE1BQz15CiMgQ09ORklHX0NSWVBUT19YQ0JD
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX05VTEwgaXMgbm90IHNldAojIENPTkZJR19DUllQ
VE9fTUQ0IGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19NRDU9eQpDT05GSUdfQ1JZUFRPX1NIQTE9
eQpDT05GSUdfQ1JZUFRPX1NIQTI1Nj15CkNPTkZJR19DUllQVE9fU0hBNTEyPXkKIyBDT05GSUdf
Q1JZUFRPX1dQNTEyIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1RHUjE5MiBpcyBub3Qgc2V0
CiMgQ09ORklHX0NSWVBUT19HRjEyOE1VTCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19FQ0Ig
aXMgbm90IHNldApDT05GSUdfQ1JZUFRPX0NCQz15CiMgQ09ORklHX0NSWVBUT19QQ0JDIGlzIG5v
dCBzZXQKIyBDT05GSUdfQ1JZUFRPX0xSVyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19YVFMg
aXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQ1RSIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRP
X0dDTSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19DQ00gaXMgbm90IHNldAojIENPTkZJR19D
UllQVE9fQ1JZUFREIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19ERVM9eQojIENPTkZJR19DUllQ
VE9fRkNSWVBUIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0JMT1dGSVNIIGlzIG5vdCBzZXQK
IyBDT05GSUdfQ1JZUFRPX1RXT0ZJU0ggaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fVFdPRklT
SF9YODZfNjQgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fU0VSUEVOVCBpcyBub3Qgc2V0CkNP
TkZJR19DUllQVE9fQUVTPXkKQ09ORklHX0NSWVBUT19BRVNfWDg2XzY0PXkKIyBDT05GSUdfQ1JZ
UFRPX0NBU1Q1IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0NBU1Q2IGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX1RFQSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19BUkM0IGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ1JZUFRPX0tIQVpBRCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19BTlVC
SVMgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fU0VFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0NS
WVBUT19TQUxTQTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NBTFNBMjBfWDg2XzY0IGlz
IG5vdCBzZXQKQ09ORklHX0NSWVBUT19ERUZMQVRFPXkKIyBDT05GSUdfQ1JZUFRPX01JQ0hBRUxf
TUlDIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19DUkMzMkM9eQojIENPTkZJR19DUllQVE9fQ0FN
RUxMSUEgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fVEVTVCBpcyBub3Qgc2V0CkNPTkZJR19D
UllQVE9fQVVUSEVOQz15CiMgQ09ORklHX0NSWVBUT19MWk8gaXMgbm90IHNldApDT05GSUdfQ1JZ
UFRPX0hXPXkKIyBDT05GSUdfQ1JZUFRPX0RFVl9ISUZOXzc5NVggaXMgbm90IHNldApDT05GSUdf
SEFWRV9LVk09eQojIENPTkZJR19WSVJUVUFMSVpBVElPTiBpcyBub3Qgc2V0CgojCiMgTGlicmFy
eSByb3V0aW5lcwojCkNPTkZJR19CSVRSRVZFUlNFPXkKQ09ORklHX0NSQ19DQ0lUVD15CkNPTkZJ
R19DUkMxNj15CiMgQ09ORklHX0NSQ19JVFVfVCBpcyBub3Qgc2V0CkNPTkZJR19DUkMzMj15CiMg
Q09ORklHX0NSQzcgaXMgbm90IHNldApDT05GSUdfTElCQ1JDMzJDPXkKQ09ORklHX1pMSUJfSU5G
TEFURT15CkNPTkZJR19aTElCX0RFRkxBVEU9eQpDT05GSUdfVEVYVFNFQVJDSD15CkNPTkZJR19U
RVhUU0VBUkNIX0tNUD15CkNPTkZJR19URVhUU0VBUkNIX0JNPXkKQ09ORklHX1RFWFRTRUFSQ0hf
RlNNPXkKQ09ORklHX1BMSVNUPXkKQ09ORklHX0hBU19JT01FTT15CkNPTkZJR19IQVNfSU9QT1JU
PXkKQ09ORklHX0hBU19ETUE9eQo=
------=_20080930161908_64929--


