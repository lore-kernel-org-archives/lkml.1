Return-Path: <linux-kernel-owner+w=401wt.eu-S966433AbYD1We7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966433AbYD1We7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934507AbYD1Wev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:34:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:59713 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbYD1Wes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=X5x84WHu55SUpdHQMY6edhtpoFl1dTlroMzvWIuPtToiat2UEMfpKLXdWzLU4CdRL969/NCQazAb435TyS/IehsK4ZTb58IksF6M4Bj1V509SKCFK53MNmw3YBSbDUBt0282sJrB6cXHUAGrnCQYhHthTNCECCS0YKwcWBsv9Ag=
Date: Tue, 29 Apr 2008 00:34:41 +0200 (CEST)
To: linux-kernel@vger.kernel.org
cc: Jesper Juhl <jesper.juhl@gmail.com>
Subject: rq->rq_lock_key vs cpu_base->lock - possible circular locking
 dependency detected
Message-ID: <alpine.LNX.1.00.0804290022370.20778@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1314647572-1209422090=:20778"
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1314647572-1209422090=:20778
Content-Type: TEXT/PLAIN; charset=US-ASCII


While my box was busy building randconfig kernels I noticed this in dmesg:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.25-03562-g3dc5063 #1
-------------------------------------------------------
X/1332 is trying to acquire lock:
 (&rq->rq_lock_key){++..}, at: [<c0120a0c>] task_rq_lock+0x3c/0x70

but task is already holding lock:
 (&cpu_base->lock){++..}, at: [<c013fb73>] lock_hrtimer_base+0x23/0x50

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&cpu_base->lock){++..}:
       [<c014bd96>] __lock_acquire+0xc26/0x1070
       [<c014c261>] lock_acquire+0x81/0xa0
       [<c0360d77>] _spin_lock_irqsave+0x47/0x80
       [<c013fb73>] lock_hrtimer_base+0x23/0x50
       [<c013fcb9>] hrtimer_start+0x19/0x150
       [<c011ee6e>] enqueue_rt_entity+0xfe/0x130
       [<c011ef1b>] enqueue_task_rt+0x3b/0x60
       [<c011bd57>] enqueue_task+0x57/0x70
       [<c011bd89>] activate_task+0x19/0x30
       [<c0120ec3>] try_to_wake_up+0x1a3/0x1d0
       [<c0120f1f>] wake_up_process+0xf/0x20
       [<c04ab15b>] migration_call+0xcb/0x140
       [<c0492c64>] migration_init+0x34/0x50
       [<c0487799>] kernel_init+0x49/0x320
       [<c0103dcb>] kernel_thread_helper+0x7/0x1c
       [<ffffffff>] 0xffffffff

-> #1 (&rt_b->rt_runtime_lock){++..}:
       [<c014bd96>] __lock_acquire+0xc26/0x1070
       [<c014c261>] lock_acquire+0x81/0xa0
       [<c0360978>] _spin_lock+0x38/0x70
       [<c011ee1f>] enqueue_rt_entity+0xaf/0x130
       [<c011ef1b>] enqueue_task_rt+0x3b/0x60
       [<c011bd57>] enqueue_task+0x57/0x70
       [<c011bd89>] activate_task+0x19/0x30
       [<c0120ec3>] try_to_wake_up+0x1a3/0x1d0
       [<c0120f1f>] wake_up_process+0xf/0x20
       [<c04ab15b>] migration_call+0xcb/0x140
       [<c0492c64>] migration_init+0x34/0x50
       [<c0487799>] kernel_init+0x49/0x320
       [<c0103dcb>] kernel_thread_helper+0x7/0x1c
       [<ffffffff>] 0xffffffff

-> #0 (&rq->rq_lock_key){++..}:
       [<c014bba9>] __lock_acquire+0xa39/0x1070
       [<c014c261>] lock_acquire+0x81/0xa0
       [<c0360978>] _spin_lock+0x38/0x70
       [<c0120a0c>] task_rq_lock+0x3c/0x70
       [<c0120d49>] try_to_wake_up+0x29/0x1d0
       [<c0120f1f>] wake_up_process+0xf/0x20
       [<c012edcc>] raise_softirq+0x9c/0xa0
       [<c013f67a>] enqueue_hrtimer+0xea/0x100
       [<c013fd6f>] hrtimer_start+0xcf/0x150
       [<c0135219>] dequeue_signal+0x159/0x160
       [<c013541d>] get_signal_to_deliver+0x5d/0x310
       [<c01026a9>] do_notify_resume+0xb9/0x7e0
       [<c0103278>] work_notifysig+0x13/0x1b
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by X/1332:
 #0:  (&sighand->siglock){++..}, at: [<c01353f6>] 
get_signal_to_deliver+0x36/0x310
 #1:  (&cpu_base->lock){++..}, at: [<c013fb73>] 
lock_hrtimer_base+0x23/0x50

stack backtrace:
Pid: 1332, comm: X Not tainted 2.6.25-03562-g3dc5063 #1
 [<c014976e>] print_circular_bug_tail+0x6e/0x80
 [<c0148df3>] ? print_circular_bug_entry+0x43/0x50
 [<c014bba9>] __lock_acquire+0xa39/0x1070
 [<c014b3c8>] ? __lock_acquire+0x258/0x1070
 [<c014b3c8>] ? __lock_acquire+0x258/0x1070
 [<c014c261>] lock_acquire+0x81/0xa0
 [<c0120a0c>] ? task_rq_lock+0x3c/0x70
 [<c0360978>] _spin_lock+0x38/0x70
 [<c0120a0c>] ? task_rq_lock+0x3c/0x70
 [<c0120a0c>] task_rq_lock+0x3c/0x70
 [<c0120d49>] try_to_wake_up+0x29/0x1d0
 [<c0120f1f>] wake_up_process+0xf/0x20
 [<c012edcc>] raise_softirq+0x9c/0xa0
 [<c013f67a>] enqueue_hrtimer+0xea/0x100
 [<c013fd6f>] hrtimer_start+0xcf/0x150
 [<c0135219>] dequeue_signal+0x159/0x160
 [<c013541d>] get_signal_to_deliver+0x5d/0x310
 [<c0361175>] ? _spin_unlock_irqrestore+0x55/0x70
 [<c01026a9>] do_notify_resume+0xb9/0x7e0
 [<c013fd7c>] ? hrtimer_start+0xdc/0x150
 [<c035e404>] ? schedule+0x394/0x870
 [<c014657c>] ? tick_program_event+0x5c/0x80
 [<c012e679>] ? irq_exit+0x49/0x90
 [<c011364a>] ? smp_apic_timer_interrupt+0x5a/0x90
 [<c0103278>] work_notifysig+0x13/0x1b
 =======================


The system seems to be doing fine still.

System details follow, config file attached :

$ scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux dragon 2.6.25-03562-g3dc5063 #1 SMP PREEMPT Wed Apr 23 22:54:05 CEST 
2008 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD 
GNU/Linux

Gnu C                  4.2.3
Gnu make               3.81
binutils               2.17.50.0.17.20070615
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.4
e2fsprogs              1.40.8
jfsutils               1.1.12
reiserfsprogs          3.6.19
xfsprogs               2.9.7
pcmciautils            014
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Linux C++ Library      6.0.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.2
Sh-utils               6.9
udev                   118
Modules Loaded         snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss 
snd_mixer_oss agpgart lp snd_emu10k1 snd_rawmidi firmware_class 
snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc 
snd_util_mem snd_hwdep sg k8temp evdev ehci_hcd via_rhine

$ uname -a
Linux dragon 2.6.25-03562-g3dc5063 #1 SMP PREEMPT Wed Apr 23 22:54:05 CEST 
2008 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD 
GNU/Linux

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 35
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping        : 2
cpu MHz         : 2200.101
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 
3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips        : 4403.98
clflush size    : 64
power management: ts fid vid ttp

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 35
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping        : 2
cpu MHz         : 2200.101
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 
3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips        : 4399.38
clflush size    : 64
power management: ts fid vid ttp

$ cat /proc/modules
snd_seq_oss 29392 0 - Live 0xf89e5000
snd_seq_midi_event 6344 1 snd_seq_oss, Live 0xf88b4000
snd_seq 47224 4 snd_seq_oss,snd_seq_midi_event, Live 0xf89d8000
snd_pcm_oss 36800 0 - Live 0xf89ce000
snd_mixer_oss 14152 1 snd_pcm_oss, Live 0xf89f6000
agpgart 27464 0 - Live 0xf8a33000
lp 9156 0 - Live 0xf88b0000
snd_emu10k1 134368 0 - Live 0xf8889000
snd_rawmidi 19136 1 snd_emu10k1, Live 0xf88b7000
firmware_class 7360 1 snd_emu10k1, Live 0xf887e000
snd_ac97_codec 94968 1 snd_emu10k1, Live 0xf8865000
ac97_bus 1728 1 snd_ac97_codec, Live 0xf8848000
snd_pcm 66028 3 snd_pcm_oss,snd_emu10k1,snd_ac97_codec, Live 0xf8853000
snd_seq_device 6676 4 snd_seq_oss,snd_seq,snd_emu10k1,snd_rawmidi, Live 
0xf8841000
snd_timer 19612 3 snd_seq,snd_emu10k1,snd_pcm, Live 0xf8883000
snd_page_alloc 7816 2 snd_emu10k1,snd_pcm, Live 0xf883e000
snd_util_mem 3592 1 snd_emu10k1, Live 0xf883c000
snd_hwdep 7180 1 snd_emu10k1, Live 0xf882b000
sg 27752 0 - Live 0xf8834000
k8temp 4296 0 - Live 0xf8845000
evdev 9312 3 - Live 0xf8830000
ehci_hcd 30740 0 - Live 0xf8822000
via_rhine 20496 0 - Live 0xf884c000

$ cat /proc/ioports
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
0170-0177 : 0000:00:12.0
01f0-01f7 : 0000:00:12.0
0290-029f : pnp 00:0a
0376-0376 : 0000:00:12.0
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:12.0
03f7-03f7 : floppy DIR
0400-040f : pnp 00:06
0480-048f : pnp 00:06
04d0-04d1 : pnp 00:06
0800-083f : 0000:00:07.1
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0818-0827 : ACPI GPE0_BLK
  0830-0830 : ACPI PM2_CNT_BLK
0cf8-0cff : PCI conf1
d000-dfff : PCI Bus 0000:04
  d000-d0ff : 0000:04:07.0
    d000-d0ff : via-rhine
  d400-d4ff : 0000:04:06.0
  d880-d89f : 0000:04:05.0
    d880-d89f : EMU10K1
  dc00-dc07 : 0000:04:05.1
e800-e8ff : 0000:00:11.0
ff00-ff0f : 0000:00:12.0

$ cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cb7ff : Video ROM
000cb800-000d0bff : Adapter ROM
000f0000-000fffff : System ROM
00100000-7ffaffff : System RAM
  00100000-00362176 : Kernel code
  00362177-004810cf : Kernel data
  00514000-00852c73 : Kernel bss
7ffb0000-7ffbffff : ACPI Tables
7ffc0000-7ffeffff : ACPI Non-volatile Storage
7fff0000-7fffffff : reserved
88000000-880fffff : PCI Bus 0000:04
  88000000-8801ffff : 0000:04:06.0
  88020000-8802ffff : 0000:04:07.0
c7e00000-cfefffff : PCI Bus 0000:03
  c8000000-cbffffff : 0000:03:00.0
  cfe80000-cfefffff : 0000:03:00.0
d8000000-dfffffff : 0000:00:04.0
e0000000-efffffff : pnp 00:07
fc700000-fc7fffff : PCI Bus 0000:01
fc800000-fc8fffff : PCI Bus 0000:02
fc900000-fe9fffff : PCI Bus 0000:03
  fd000000-fdffffff : 0000:03:00.0
  fe9f0000-fe9fffff : 0000:03:00.0
fea00000-feafffff : PCI Bus 0000:04
  feafec00-feafecff : 0000:04:07.0
    feafec00-feafecff : via-rhine
  feaff000-feafffff : 0000:04:06.0
    feaff000-feafffff : aic7xxx
febfc000-febfcfff : 0000:00:13.2
febfd000-febfdfff : 0000:00:13.1
febfe000-febfefff : 0000:00:13.0
febff800-febff8ff : 0000:00:13.3
  febff800-febff8ff : ehci_hcd
febffc00-febffcff : 0000:00:11.0
fec00000-fec00fff : pnp 00:07
fec10000-fec10fff : pnp 00:07
fee00000-fee00fff : pnp 00:07
ff7c0000-ffffffff : reserved

# lspci -vvv
00:00.0 Host bridge: ALi Corporation M1695 K8 Northbridge [PCI Express and HyperTransport]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [40] HyperTransport: Slave or Primary Interface
                Command: BaseUnitID=0 UnitCnt=3 MastHost- DefDir- DUL-
                Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
                Link Control 1: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 1: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=8bit DwFcInEn- LWO=16bit DwFcOutEn-
                Revision ID: 1.05
                Link Frequency 0: 800MHz
                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
                Link Frequency 1: 800MHz
                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 1: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
                Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                Prefetchable memory behind bridge Upper: 00-00
                Bus Number: 00
        Capabilities: [5c] HyperTransport: MSI Mapping Enable- Fixed-
                Mapping Address Base: 00000000fee00000
        Capabilities: [68] HyperTransport: UnitID Clumping
        Capabilities: [74] HyperTransport: Interrupt Discovery and Configuration
        Capabilities: [7c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
                Address: 00000000fee00000  Data: 0000

00:01.0 PCI bridge: ALi Corporation PCI Express Root Port (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fc700000-fc7fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
                Address: 00000000fee0300c  Data: 41b9
        Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag+ RBE- FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <2us, L1 <32us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Off, PwrInd Off, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [7c] HyperTransport: MSI Mapping Enable- Fixed-
                Mapping Address Base: 00000000fee00000
        Capabilities: [88] HyperTransport: Revision ID: 1.05
        Kernel driver in use: pcieport-driver

00:02.0 PCI bridge: ALi Corporation PCI Express Root Port (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fc800000-fc8fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
                Address: 00000000fee0300c  Data: 41c1
        Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag+ RBE- FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x2, ASPM L0s L1, Latency L0 <2us, L1 <32us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Off, PwrInd Off, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [7c] HyperTransport: MSI Mapping Enable- Fixed-
                Mapping Address Base: 00000000fee00000
        Capabilities: [88] HyperTransport: Revision ID: 1.05
        Kernel driver in use: pcieport-driver

00:04.0 Host bridge: ALi Corporation M1689 K8 Northbridge [Super K8 Single Chip]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at d8000000 (32-bit, prefetchable) [size=128M]
        Capabilities: [40] HyperTransport: Slave or Primary Interface
                Command: BaseUnitID=4 UnitCnt=1 MastHost- DefDir- DUL-
                Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 0: MLWI=16bit DwFcIn- MLWO=8bit DwFcOut- LWI=16bit DwFcInEn- LWO=8bit DwFcOutEn-
                Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
                Revision ID: 1.04
                Link Frequency 0: 800MHz
                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
                Link Frequency 1: 200MHz
                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                Prefetchable memory behind bridge Upper: 00-00
                Bus Number: 00
        Capabilities: [60] HyperTransport: Interrupt Discovery and Configuration
        Capabilities: [80] AGP version 3.0
                Status: RQ=28 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>

00:05.0 PCI bridge: ALi Corporation AGP8X Controller (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fc900000-fe9fffff
        Prefetchable memory behind bridge: c7e00000-cfefffff
        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:06.0 PCI bridge: ALi Corporation M5249 HTT to PCI Bridge (prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fea00000-feafffff
        Prefetchable memory behind bridge: 88000000-880fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:07.0 ISA bridge: ALi Corporation M1563 HyperTransport South Bridge (rev 70)
        Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0 (250ns min, 6000ns max)

00:07.1 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
        Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:11.0 Ethernet controller: ALi Corporation ULi 1689,1573 integrated ethernet. (rev 40)
        Subsystem: ASRock Incorporation Unknown device 5263
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (5000ns min, 10000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at e800 [size=256]
        Region 1: Memory at febffc00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:12.0 IDE interface: ALi Corporation M5229 IDE (rev c7) (prog-if 8a [Master SecP PriP])
        Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard IDE (PATA)
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 0
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at ff00 [size=16]

00:13.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-if 10 [OHCI])
        Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 32 (20000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at febfe000 (32-bit, non-prefetchable) [size=4K]

00:13.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-if 10 [OHCI])
        Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 32 (20000ns max), Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 3
        Region 0: Memory at febfd000 (32-bit, non-prefetchable) [size=4K]

00:13.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-if 10 [OHCI])
        Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 32 (20000ns max), Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 11
        Region 0: Memory at febfc000 (32-bit, non-prefetchable) [size=4K]

00:13.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01) (prog-if 20 [EHCI])
        Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 64 bytes
        Interrupt: pin D routed to IRQ 23
        Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=0090
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [80] HyperTransport: Host or Secondary Interface
                !!! Possibly incomplete decoding
                Command: WarmRst+ DblEnd-
                Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
                Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
                Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel driver in use: k8temp
        Kernel modules: k8temp

03:00.0 VGA compatible controller: nVidia Corporation NV20 [GeForce3] (rev a3) (prog-if 00 [VGA controller])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1250ns min, 250ns max)
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at c8000000 (32-bit, prefetchable) [size=64M]
        Region 2: Memory at cfe80000 (32-bit, prefetchable) [size=512K]
        Expansion ROM at fe9f0000 [disabled] [size=64K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [44] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA- ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>

04:05.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 0a)
        Subsystem: Creative Labs SBLive! 5.1 eMicro 28028
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (500ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at d880 [size=32]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: EMU10K1_Audigy
        Kernel modules: snd-emu10k1

04:05.1 Input device controller: Creative Labs SB Live! Game Port (rev 0a)
        Subsystem: Creative Labs Gameport Joystick
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Region 0: I/O ports at dc00 [size=8]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

04:06.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
        Subsystem: Adaptec 29160N Ultra160 SCSI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (10000ns min, 6250ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 21
        BIST result: 00
        Region 0: I/O ports at d400 [disabled] [size=256]
        Region 1: Memory at feaff000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at 88000000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: aic7xxx

04:07.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 42)
        Subsystem: D-Link System Inc DFE-530TX rev B
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (750ns min, 2000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: I/O ports at d000 [size=256]
        Region 1: Memory at feafec00 (32-bit, non-prefetchable) [size=256]
        Expansion ROM at 88020000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: via-rhine
        Kernel modules: via-rhine

$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: IBM      Model: DDYS-T36950N     Rev: S96H
  Type:   Direct-Access                    ANSI  SCSI revision: 03



Please let me know if there is other info I can provide that would be 
useful.


Kind regards,
  Jesper Juhl <jesper.juhl@gmail.com>
 

--8323328-1314647572-1209422090=:20778
Content-Type: APPLICATION/octet-stream; name=config.gz
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.1.00.0804290034410.20778@dragon.funnycrock.com>
Content-Description: 
Content-Disposition: attachment; filename=config.gz

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
AAA=

--8323328-1314647572-1209422090=:20778--
