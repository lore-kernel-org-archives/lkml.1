Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZDUK4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZDUK4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZDUK4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:56:23 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:34068 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZDUK4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:56:22 -0400
Date: Tue, 21 Apr 2009 14:56:29 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Message-ID: <20090421105629.GB17904@jurassic.park.msu.ru>
References: <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain> <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain> <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu> <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ED0EBC.4070901@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 05:09:32PM -0700, Yinghai Lu wrote:
> also it seems logical is wrong.
> 
> we should make sure if one pci resource support 64 from pci_read_bases() instead of 
> pcibios_allocate_resources.

pci_read_bases() is already providing all necessary information.

> thinking about: if pci bridge on bus 0 (aka first peer root bus), some device under
> bridge doesn't get allocated resource from BIOS. and those bridge/device does support pref mem64
> then your patch will not getIORESORCE_MEM64 set before pcibios_pci64_verify...

Yes, that's my point - even if host bridge, p2p bridge and device are 64-bit,
there is absolutely no guarantee that after moving the BARs above 4G
the device will work correctly.

> Correct logic should be
> record all device if support 64bit pref mem (with pci_read_bases), and make sure bridge to be
>  consistent with that of device under if.

Your view is very x86 centric, please don't forget that drivers/pci
code is used by other architectures as well:
- limiting 32-bit allocations to 0xffffffff simply breaks non-x86
  architectures. Alpha doesn't even boot with your patch;
- there are lots of devices with 64-bit non-prefetchable memory BARs,
  you don't seem to care about that.

And your patch doesn't work even on x86:

00:01.0 PCI bridge: Intel Corporation 82945G/GZ/P/PL PCI Express Root Port (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 16 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: cdf00000-cfffffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [88] Subsystem: Intel Corporation Device 0000
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
                Address: fee0300c  Data: 4159
        Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <256ns, L1 <4us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
                        Slot #  0, PowerLimit 75.000000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Off, PwrInd On, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
00: 86 80 71 27 07 05 10 00 02 00 04 06 04 00 01 00
10: 00 00 00 00 00 00 00 00 00 04 04 00 e0 e0 00 00
20: f0 cd f0 cf 01 d0 f1 df 00 00 00 00 00 00 00 00
30: 00 00 00 00 88 00 00 00 00 00 00 00 0b 01 0a 00

As one can see, the prefetchable base register (0x24) is 0xd001, the
bit 0 indicates 64-bitness. Which is not true, as i82945G/GZ/P/PL
only supports 32-bit addressing (please check the datasheet).

Also, your patch can't handle transparent bridges. And it doesn't
bode well for bus sizing code.

> and that is my patch doing: pci: don't assume pref memio are 64bit -v2

Your patch is all wrong, sorry.

Ivan.
