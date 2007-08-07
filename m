Return-Path: <linux-kernel-owner+w=401wt.eu-S967087AbXHGVrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967087AbXHGVrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937227AbXHGVYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:24:36 -0400
Received: from smtp25.orange.fr ([193.252.22.22]:5548 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937271AbXHGVY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:24:29 -0400
X-Greylist: delayed 11812 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2007 17:24:24 EDT
X-ME-UUID: 20070807180728681.A65F91C00093@mwinf2517.orange.fr
From: paul <paul.pinault@disk91.com>
Reply-To: paul.pinault@disk91.com
To: linux-kernel@vger.kernel.org
Subject: Data corruption
Date: Tue, 7 Aug 2007 20:07:26 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708072007.27343.paul.pinault@disk91.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2-3 month I have some random data corruption on my Linux server, after 
checking disks independently (i'm using raid1on 2 sata disk, the problem is 
the same w/o raid) and memory, hardware simce to be out of cause...

Here is my problem:
=> head --bytes=300m  /dev/urandom > test
=> for i in `seq 0 9` ; do cp test test$i ; done
=> md5sum test*
I got : 
014666c728c9e3b8299579fae499864a  test
014666c728c9e3b8299579fae499864a  test0
333fd93d093ac612cd8d5f65628f734e  test1
1ab6ee68c6a7d9ff5a05f9d63f0f6df6  test2
96e96483e3175a59c9c05b6720514e1e  test3
014666c728c9e3b8299579fae499864a  test4
b24dbccc9f4831f8825ab4a55a3be4aa  test5
8493efc9c14e4b5c162ac23696fbc16a  test6
6a5f4301f66d0379049d79d0e14e2a87  test7
2c81cfa1c3a03aba134574922ee5d75c  test8
2ea15c8392bfd0123472a80125bb3abe  test9

^^^ that sounds really bad for my data :(

===================================================================
I did some tests :
* badblocks on the two disk with ro and rw tests => report no error
* memtest during 6 hours => report no error

* I reproduces the error
  - under xen client host (first time issue)
  - under xen hypervisor
  - under basic kernel with raid mirroring + ext3 and raiserfs
  - under basic kernel w/o raid but ext3 ans reiserfs

My configuration
 * Asus P5B-VM
 * 4 Gb [try with and w/o options memory remaping]
 * Intel Core 2 Duo [normal speed and underclocked(233 bus speed)]
 * Hd SATA WD 80Gb

System : opensuse 10.2
===================================================================

----------------------------------------------------------
xen-prod:/ # uname -a
Linux xen-prod 2.6.18.2-34-default #1 SMP Mon Nov 27 11:46:27 UTC 2006 x86_64 
x86_64 x86_64 GNU/Linux

----------------------------------------------------------
xen-prod:/usr/src/linux-2.6.18.8-0.5/scripts # ./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux xen-prod 2.6.18.2-34-default #1 SMP Mon Nov 27 11:46:27 UTC 2006 x86_64 
x86_64 x86_64 GNU/Linux

Gnu C                  18:
Gnu make               3.81
binutils               2.17.50.0.5
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
jfsutils               1.1.11
reiserfsprogs          3.6.19
xfsprogs               2.8.11
PPP                    2.4.4
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.4
udev                   103
Modules Loaded         xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss 
snd_seq snd_seq_device snd_hda_intel snd_hda_codec snd_pcm snd_timer snd 
soundcore snd_page_alloc nfs lockd nfs_acl sunrpc af_packet joydev st sr_mod 
cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave 
speedstep_centrino freq_table button battery ac ip6t_REJECT xt_tcpudp 
ipt_REJECT xt_state iptable_mangle iptable_nat ip_nat iptable_filter 
ip6table_mangle ip_conntrack nfnetlink ip_tables ip6table_filter ip6_tables 
x_tables ipv6 apparmor aamatch_pcre ext3 jbd mbcache loop raid1 dm_mod ide_cd 
cdrom pata_jmicron generic ohci1394 ide_core ieee1394 r8169 intel_agp 
ehci_hcd uhci_hcd i2c_i801 i2c_core usbcore parport_pc lp parport reiserfs 
edd fan sg ata_piix ahci libata thermal processor sd_mod scsi_mod


----------------------------------------------------------
xen-prod:~ # cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping        : 6
cpu MHz         : 1596.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm 
constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr lahf_lm
bogomips        : 3264.96
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping        : 6
cpu MHz         : 1862.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm 
constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr lahf_lm
bogomips        : 3262.14
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

---------------------------------------------------------------------------------------------------
xen-prod:~ # cat /proc/modules
xt_pkttype 18816 3 - Live 0xffffffff88567000
ipt_LOG 23808 9 - Live 0xffffffff88560000
xt_limit 20224 9 - Live 0xffffffff8855a000
snd_pcm_oss 71680 0 - Live 0xffffffff88547000
snd_mixer_oss 35840 1 snd_pcm_oss, Live 0xffffffff8853d000
snd_seq 82976 0 - Live 0xffffffff88527000
snd_seq_device 26516 1 snd_seq, Live 0xffffffff8851f000
snd_hda_intel 37660 0 - Live 0xffffffff88514000
snd_hda_codec 220160 1 snd_hda_intel, Live 0xffffffff884dd000
snd_pcm 115464 3 snd_pcm_oss,snd_hda_intel,snd_hda_codec, Live 
0xffffffff884bf000
snd_timer 44680 2 snd_seq,snd_pcm, Live 0xffffffff884b3000
snd 89384 8 
snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer, 
Live 0xffffffff8849c000
soundcore 28192 1 snd, Live 0xffffffff88494000
snd_page_alloc 27792 2 snd_hda_intel,snd_pcm, Live 0xffffffff8848c000
nfs 275512 1 - Live 0xffffffff88447000
lockd 96112 1 nfs, Live 0xffffffff8842e000
nfs_acl 20608 1 nfs, Live 0xffffffff88427000
sunrpc 192584 4 nfs,lockd,nfs_acl, Live 0xffffffff883f6000
af_packet 57356 2 - Live 0xffffffff883e6000
joydev 28160 0 - Live 0xffffffff883de000
st 57892 0 - Live 0xffffffff883ce000
sr_mod 34596 0 - Live 0xffffffff883c4000
cpufreq_conservative 25608 0 - Live 0xffffffff883bc000
cpufreq_ondemand 24592 2 - Live 0xffffffff883b4000
cpufreq_userspace 24064 0 - Live 0xffffffff883ad000
cpufreq_powersave 18688 0 - Live 0xffffffff883a7000
speedstep_centrino 27680 1 - Live 0xffffffff8839f000
freq_table 22912 1 speedstep_centrino, Live 0xffffffff88398000
button 24736 0 - Live 0xffffffff88390000
battery 28168 0 - Live 0xffffffff88388000
ac 22792 0 - Live 0xffffffff88381000
ip6t_REJECT 22528 3 - Live 0xffffffff8837a000
xt_tcpudp 20352 5 - Live 0xffffffff88374000
ipt_REJECT 22528 3 - Live 0xffffffff8836d000
xt_state 19200 12 - Live 0xffffffff88367000
iptable_mangle 19840 0 - Live 0xffffffff88361000
iptable_nat 24964 0 - Live 0xffffffff88359000
ip_nat 37804 1 iptable_nat, Live 0xffffffff8834e000
iptable_filter 19968 1 - Live 0xffffffff88348000
ip6table_mangle 19456 0 - Live 0xffffffff88342000
ip_conntrack 78372 3 xt_state,iptable_nat,ip_nat, Live 0xffffffff8832d000
nfnetlink 24648 2 ip_nat,ip_conntrack, Live 0xffffffff88325000
ip_tables 39400 3 iptable_mangle,iptable_nat,iptable_filter, Live 
0xffffffff8831a000
ip6table_filter 19840 1 - Live 0xffffffff88314000
ip6_tables 33352 2 ip6table_mangle,ip6table_filter, Live 0xffffffff8830a000
x_tables 37384 10 
xt_pkttype,ipt_LOG,xt_limit,ip6t_REJECT,xt_tcpudp,ipt_REJECT,xt_state,iptable_nat,ip_tables,ip6_tables, 
Live 0xffffffff882ff000
ipv6 357728 27 ip6t_REJECT, Live 0xffffffff882a6000
apparmor 74264 0 - Live 0xffffffff88292000
aamatch_pcre 31232 1 apparmor, Live 0xffffffff88289000
ext3 167696 1 - Live 0xffffffff8825f000
jbd 90872 1 ext3, Live 0xffffffff88247000
mbcache 27016 1 ext3, Live 0xffffffff8823f000
loop 34064 0 - Live 0xffffffff88235000
raid1 40704 1 - Live 0xffffffff8822a000
dm_mod 81872 0 - Live 0xffffffff88215000
ide_cd 59680 0 - Live 0xffffffff88205000
cdrom 54056 2 sr_mod,ide_cd, Live 0xffffffff881f6000
pata_jmicron 24576 0 - Live 0xffffffff881ef000
generic 23172 0 [permanent], Live 0xffffffff881e8000
ohci1394 52040 0 - Live 0xffffffff881d8000
ide_core 174720 2 ide_cd,generic, Live 0xffffffff881ac000
ieee1394 130552 1 ohci1394, Live 0xffffffff8818b000
r8169 50824 0 - Live 0xffffffff8817b000
intel_agp 44224 1 - Live 0xffffffff8816d000
ehci_hcd 51080 0 - Live 0xffffffff8815d000
uhci_hcd 42520 0 - Live 0xffffffff88151000
i2c_i801 25364 0 - Live 0xffffffff88149000
i2c_core 41472 1 i2c_i801, Live 0xffffffff8813d000
usbcore 148064 2 ehci_hcd,uhci_hcd, Live 0xffffffff88117000
parport_pc 58984 1 - Live 0xffffffff88107000
lp 30664 0 - Live 0xffffffff880fe000
parport 59660 2 parport_pc,lp, Live 0xffffffff880ee000
reiserfs 260096 1 - Live 0xffffffff880ad000
edd 27912 0 - Live 0xffffffff880a5000
fan 22408 0 - Live 0xffffffff8809e000
sg 55080 0 - Live 0xffffffff8808f000
ata_piix 34564 4 - Live 0xffffffff88083000
ahci 41604 0 - Live 0xffffffff88077000
libata 145056 3 pata_jmicron,ata_piix,ahci, Live 0xffffffff88052000
thermal 33552 0 - Live 0xffffffff88048000
processor 53992 2 speedstep_centrino,thermal, Live 0xffffffff88039000
sd_mod 39296 6 - Live 0xffffffff8802e000
scsi_mod 173744 6 st,sr_mod,sg,ahci,libata,sd_mod, Live 0xffffffff88002000

------------------------------------------------------------------------------------------------
xen-prod:~ # cat /proc/ioports
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
0170-0177 : libata
01f0-01f7 : libata
0378-037a : parport0
037b-037f : parport0
03c0-03df : vesafb
03f8-03ff : serial
0400-041f : 0000:00:1f.3
  0400-041f : i801_smbus
0800-0803 : ACPI PM1a_EVT_BLK
0804-0805 : ACPI PM1a_CNT_BLK
0808-080b : ACPI PM_TMR
0810-0815 : ACPI CPU throttle
0828-082f : ACPI GPE0_BLK
0cf8-0cff : PCI conf1
b000-bfff : PCI Bus #02
  b800-b8ff : 0000:02:00.0
    b800-b8ff : r8169
c000-cfff : PCI Bus #03
  c400-c40f : 0000:03:00.1
    c400-c407 : ide0
    c408-c40f : ide1
  c480-c483 : 0000:03:00.1
  c800-c807 : 0000:03:00.1
  c880-c883 : 0000:03:00.1
    c882-c882 : ide0
  cc00-cc07 : 0000:03:00.1
    cc00-cc07 : ide0
d400-d40f : 0000:00:1f.5
  d400-d40f : libata
d480-d48f : 0000:00:1f.5
  d480-d48f : libata
d800-d803 : 0000:00:1f.5
  d800-d803 : libata
d880-d887 : 0000:00:1f.5
  d880-d887 : libata
dc00-dc03 : 0000:00:1f.5
  dc00-dc03 : libata
e000-e007 : 0000:00:1f.5
  e000-e007 : libata
e080-e09f : 0000:00:1d.0
  e080-e09f : uhci_hcd
e400-e41f : 0000:00:1d.1
  e400-e41f : uhci_hcd
e480-e49f : 0000:00:1d.2
  e480-e49f : uhci_hcd
e800-e81f : 0000:00:1a.0
  e800-e81f : uhci_hcd
e880-e89f : 0000:00:1a.1
  e880-e89f : uhci_hcd
ec00-ec07 : 0000:00:02.0
ff90-ff9f : 0000:00:1f.2
  ff90-ff9f : libata
ffa0-ffaf : 0000:00:1f.2
  ffa0-ffaf : libata


----------------------------------------------------------------------------------
xen-prod:~ # cat /proc/iomem
00000000-0009fbff : System RAM
  00000000-00000000 : Crash kernel
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000f0000-000fffff : System ROM
00100000-af78ffff : System RAM
  00200000-003ded9a : Kernel code
  003ded9b-0051e767 : Kernel data
af790000-af79dfff : ACPI Tables
af79e000-af7dffff : ACPI Non-volatile Storage
af7e0000-af7fffff : reserved
b0000000-b00000ff : 0000:00:1f.3
bfd00000-bfdfffff : PCI Bus #01
bfe00000-bfefffff : PCI Bus #04
d0000000-dfffffff : 0000:00:02.0
  d0000000-d076ffff : vesafb
fee00000-fee00fff : reserved
ff500000-ff5fffff : PCI Bus #02
  ff5c0000-ff5dffff : 0000:02:00.0
  ff5ff000-ff5fffff : 0000:02:00.0
    ff5ff000-ff5fffff : r8169
ff600000-ff6fffff : PCI Bus #03
  ff6e0000-ff6effff : 0000:03:00.0
  ff6fe000-ff6fffff : 0000:03:00.0
    ff6fe000-ff6fffff : ahci
ff700000-ff7fffff : PCI Bus #05
  ff7f8000-ff7fbfff : 0000:05:01.0
  ff7ff800-ff7fffff : 0000:05:01.0
    ff7ff800-ff7fffff : ohci1394
ff9f4000-ff9f7fff : 0000:00:1b.0
  ff9f4000-ff9f7fff : ICH HD audio
ff9fb400-ff9fb7ff : 0000:00:1d.7
  ff9fb400-ff9fb7ff : ehci_hcd
ff9fb800-ff9fbbff : 0000:00:1a.7
  ff9fb800-ff9fbbff : ehci_hcd
ffa00000-ffafffff : 0000:00:02.0
ffb00000-ffffffff : reserved

-------------------------------------------------------------------------

xen-prod:~ # lspci -vvv
00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub (rev 
02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ea
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:01.0 PCI bridge: Intel Corporation 82P965/G965 PCI Express Root Port (rev 
02) (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000bfd00000-00000000bfdfffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [88] Subsystem: Intel Corporation Unknown device 277d
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
                Address: fee00000  Data: 40c1
        Capabilities: [a0] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s, Port 2
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-

00:02.0 VGA compatible controller: Intel Corporation 82G965 Integrated 
Graphics Controller (rev 02) (prog-if 00 [VGA])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ea
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at ffa00000 (32-bit, non-prefetchable) [size=1M]
        Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at ec00 [size=8]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #4 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 169
        Region 4: I/O ports at e800 [size=32]

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #5 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 177
        Region 4: I/O ports at e880 [size=32]

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #2 
(rev 02) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 233
        Region 0: Memory at ff9fb800 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 66
        Region 0: Memory at ff9f4000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 
(rev 02) (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000bfe00000-00000000bfefffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
                Address: fee00000  Data: 40c9
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 
81ec
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 
(rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: ff600000-ff6fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 5
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
                Address: fee00000  Data: 40d1
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 
81ec
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 
(rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: ff500000-ff5fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 6
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
                Address: fee00000  Data: 40d9
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 
81ec
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #1 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 50
        Region 4: I/O ports at e080 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #2 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 225
        Region 4: I/O ports at e400 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #3 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 233
        Region 4: I/O ports at e480 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #1 
(rev 02) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 50
        Region 0: Memory at ff9fb400 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2) (prog-if 01 
[Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: ff700000-ff7fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Unknown device 
81ec

00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC Interface 
Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.2 IDE interface: Intel Corporation 82801H (ICH8 Family) 4 port SATA IDE 
Controller (rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 225
        Region 0: I/O ports at <unassigned>
        Region 1: I/O ports at <unassigned>
        Region 2: I/O ports at <unassigned>
        Region 3: I/O ports at <unassigned>
        Region 4: I/O ports at ff90 [size=16]
        Region 5: I/O ports at ffa0 [size=16]
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 
02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 233
        Region 0: Memory at b0000000 (32-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at 0400 [size=32]

00:1f.5 IDE interface: Intel Corporation 82801H (ICH8 Family) 2 port SATA IDE 
Controller (rev 02) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 225
        Region 0: I/O ports at e000 [size=8]
        Region 1: I/O ports at dc00 [size=4]
        Region 2: I/O ports at d880 [size=8]
        Region 3: I/O ports at d800 [size=4]
        Region 4: I/O ports at d480 [size=16]
        Region 5: I/O ports at d400 [size=16]
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI 
Express Gigabit Ethernet controller (rev 01)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81aa
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 177
        Region 0: I/O ports at b800 [size=256]
        Region 2: Memory at ff5ff000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at ff5c0000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 1024 bytes, PhantFunc 0, ExtTag+
                Device: Latency L0s <1us, L1 unlimited
                Device: AtnBtn+ AtnInd+ PwrInd+
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [84] Vendor Specific Information

03:00.0 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI 
Controller (rev 02) (prog-if 01 [PriO])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81e4
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 169
        Region 5: Memory at ff6fe000 (32-bit, non-prefetchable) [size=8K]
        Expansion ROM at ff6e0000 [disabled] [size=64K]
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Express Legacy Endpoint IRQ 1
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 1
                Link: Latency L0s <1us, L1 <16us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI 
Controller (rev 02) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81e4
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 177
        Region 0: I/O ports at cc00 [size=8]
        Region 1: I/O ports at c880 [size=4]
        Region 2: I/O ports at c800 [size=8]
        Region 3: I/O ports at c480 [size=4]
        Region 4: I/O ports at c400 [size=16]
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:01.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 
Controller (PHY/Link) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (500ns min, 1000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 58
        Region 0: Memory at ff7ff800 (32-bit, non-prefetchable) [size=2K]
        Region 1: Memory at ff7f8000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+

---------------------------------------------------------------

