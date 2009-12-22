Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZLVTM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZLVTM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZLVTM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:12:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36800 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbZLVTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:12:56 -0500
Date: Tue, 22 Dec 2009 14:12:55 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Jonathan May <jonathan.may@atheros.com>
Subject: Re: lspci CorrErr- UnsuppReq- changes (was: Asus eeepc 1008HA
	suspend issue and mac80211 suspend corner) case
Message-ID: <20091222191255.GA30201@bombadil.infradead.org>
References: <20091222022355.GA32508@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222022355.GA32508@bombadil.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the subject to the PCI specific questions. Hoping someone
from linux-pci can help me understand the meaning of the PCI config
space changes a little better.

I notice that when my device becomes unresponsive after pm-suspend both
CorrErr+ UnsuppReq+ change to
CorrErr- UnsuppReq- .

These should be:

#define PCI_EXP_DEVSTA          10      /* Device Status */
#define  PCI_EXP_DEVSTA_CED     0x01    /* Correctable Error Detected */
#define  PCI_EXP_DEVSTA_NFED    0x02    /* Non-Fatal Error Detected */
#define  PCI_EXP_DEVSTA_FED     0x04    /* Fatal Error Detected */
#define  PCI_EXP_DEVSTA_URD     0x08    /* Unsupported Request Detected */
#define  PCI_EXP_DEVSTA_AUXPD   0x10    /* AUX Power Detected */
#define  PCI_EXP_DEVSTA_TRPND   0x20    /* Transactions Pending */

I don't see the kernel using them except for in tg3 tg3_chip_reset() to
clear the PCI_EXP_DEVSTA on PCI-express upon reset for some reason:

http://lxr.linux.no/#linux+v2.6.32/drivers/net/tg3.c#L6522

But this was added as a work around:

commit 5e7dfd0fb94abed04f59481d1ce0cc06a892048a
Author: Matt Carlson <mcarlson@broadcom.com>
Date:   Fri Nov 21 17:18:16 2008 -0800

    tg3: Prevent corruption at 10 / 100Mbps w CLKREQ
    
    This patch disables CLKREQ at 10Mbps and 100Mbps to workaround a TX BD
    corruption issue.  This problem only affects the 5784 and 5761 (and
    57780 AX) ASIC revisions.
    
    Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
    Signed-off-by: Michael Chan <mchan@broadcom.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Apart from this I don't see any other uses for PCI_EXP_DEVSTA_CED and
PCI_EXP_DEVSTA_URD on the kernel as of 2.6.32 so I will likely need
to start looking at the PCI spec to decipher this. But before I do so
I still am curious what the lspci difference in output for these two
on from + to - would mean for these two.

I leave below the relevant PCI sections of my last post.

  Luis

On Mon, Dec 21, 2009 at 09:23:55PM -0500, Luis R. Rodriguez wrote:
> As for the specific Asus eeepc 1008HA issue what I'm seeing is ath9k
> talking to harware fine prior to suspend, disabling harware and then
> upon resume it becomes unusable, failing at the first harware reset.
> lspci tells me the following when the device is functional, both during
> initial boot, and during successfull pm-suspend cycles:
> 
> 01:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
> 	Subsystem: Device 1a3b:1089
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 18
> 	Region 0: Memory at fbef0000 (64-bit, non-prefetchable) [size=64K]
> 	Capabilities: [40] Power Management version 3
> 		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
> 		Address: 00000000  Data: 0000
> 	Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
> 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
> 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
> 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
> 			ClockPM- Suprise- LLActRep- BwNot-
> 		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
> 	Capabilities: [100] Advanced Error Reporting <?>
> 	Capabilities: [140] Virtual Channel <?>
> 	Capabilities: [160] Device Serial Number 12-14-24-ff-ff-17-15-00
> 	Capabilities: [170] Power Budgeting <?>
> 	Kernel driver in use: ath9k
> 	Kernel modules: ath9k
> 
> I do notice a difference when resume goes bust and the ath9k device becomes unhappy. This
> is what I see:
> 
> --- lspci-ok.txt	2009-12-21 17:22:24.000000000 -0800
> +++ lspci-busted.txt	2009-12-21 17:22:50.000000000 -0800
> @@ -16,7 +16,7 @@
>  		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>  			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>  			MaxPayload 128 bytes, MaxReadReq 512 bytes
> -		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
> +		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>  		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>  			ClockPM- Suprise- LLActRep- BwNot-
>  		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
> 
> The line in question is the PCI device status. The CorrErr indicates
> "Correctable Error Detected" and the UnsuppReq indicates "Unsupported
> Request Detected". Its not entirely clear to me what exact unsupported
> request must have been sent. I've considered getting help to look at this
> with a PCI analyzer but first I wanted to check and see if others are seeing
> this with the 1008HA or similar platform familes and if there are pointers
> some can give.
