Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZLVCX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZLVCX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 21:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZLVCX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 21:23:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZLVCX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 21:23:56 -0500
Date: Mon, 21 Dec 2009 21:23:55 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Asus eeepc 1008HA suspend issue and mac80211 suspend corner case
Message-ID: <20091222022355.GA32508@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing ath9k on an Asus eeepc 1008HA on a 2.6.32.2 kernel
and ran into a suspend corner case issue which we do not handle
yet. From what I've debugged so far it appears to me ath9k is
doing everything it should to suspend. mac80211 drivers don't
really do much on suspend except listen to mac80211. In the
suspend case the mac80211 first stops TX, flushes out all packets,
tears down aggregation, removes peers (if STA this would be your
AP), removes all interfaces and finally call the mac80211 driver
stop() callback for the driver. The driver is expected to have
completed the stop() successfully, it shall not fail. It should
be noted we never disassociate from the AP, this is left to
userspace to figure out if it wants to do this prior to suspend.
Network manger does this, for example. If you run the supplicant
manually though and if your AP does not kick you off you could
end up suspending and resumeing and still have a valid auth/assoc
to the AP.

Upon resume mac80211 first calls the mac80211 start() driver callback,
then re-add the interfaces, then the peers (your AP), etc. The corner
case I just ran into was that the mac80211 driver start() callback
*can* fail if your bus is screwy. You would likely see other sorts
of errors when this sort of thing happens but I'm not and when we
try to start() on ath9k we fail as the harware is completely
unresponsive. What ends up happening then currently is the driver
will enable interrupts and obviously though since we cannot even
reset the hardware these interrupts will have gone unhandled and
the interrupt gets disabled by the kernel. I reproduced this on
vanilla 2.6.32.2 but I only did get full ath9k debug logs when
testing against 2.6.31 with 2.6.32.2 wireless bits. That log can
be found here:

http://bombadil.infradead.org/~mcgrof/logs/2.6.31-with-2.6.32-wireless/irq-disabled.txt

This can be fixed by something like the following:

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e6c08da..63d42fa 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1031,7 +1031,14 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 
 	/* restart hardware */
 	if (local->open_count) {
+		/*
+		 * Upon resume hardware can sometimes be goofy due to
+		 * various platform issues, so restarting the device may
+		 * at times not work immediately. Propagate the error.
+		 */
 		res = drv_start(local);
+		if (res)
+			return res;
 
 		ieee80211_led_radio(local, true);
 	}

But this isn't enough. And since we cannot exactly talk to hardware
we can't try to send a deassoc as harware would be unresponsive. I
also don't see us handling such cases before either on cfg80211 or
mac80211, so curious what we should do. Doing the above is not enough
since userspace will still believe it will be associated if it left
the device in an associated state. If you end up killing userspace
and restarting you'll end up with crawling into cfg80211/mac80211
warnings due to the unexpected state we left things in. This is
currently busted on 2.6.32.2 and I don't see an obvious fix, hoping
others might.

As for the specific Asus eeepc 1008HA issue what I'm seeing is ath9k
talking to harware fine prior to suspend, disabling harware and then
upon resume it becomes unusable, failing at the first harware reset.
lspci tells me the following when the device is functional, both during
initial boot, and during successfull pm-suspend cycles:

01:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
	Subsystem: Device 1a3b:1089
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fbef0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 12-14-24-ff-ff-17-15-00
	Capabilities: [170] Power Budgeting <?>
	Kernel driver in use: ath9k
	Kernel modules: ath9k

I do notice a difference when resume goes bust and the ath9k device becomes unhappy. This
is what I see:

--- lspci-ok.txt	2009-12-21 17:22:24.000000000 -0800
+++ lspci-busted.txt	2009-12-21 17:22:50.000000000 -0800
@@ -16,7 +16,7 @@
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 512 bytes
-		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
+		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
 			ClockPM- Suprise- LLActRep- BwNot-
 		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+

The line in question is the PCI device status. The CorrErr indicates
"Correctable Error Detected" and the UnsuppReq indicates "Unsupported
Request Detected". Its not entirely clear to me what exact unsupported
request must have been sent. I've considered getting help to look at this
with a PCI analyzer but first I wanted to check and see if others are seeing
this with the 1008HA or similar platform familes and if there are pointers
some can give.

I'll consider sucking in patches to 2.6.32.2 if there is something on Linus'
tree on 2.6.33-rc1 but so far I can't even boot 2.6.33-rc1 on this thing so
it will have to be very selective.

The only other thing that might be relevant, not sure is the APCI error
messages I see during the first successfull resume:

[  139.873054] ath9k: Starting driver with initial channel: 2462 MHz
[  139.887477] ath9k: Attach a VIF of type: 2
[  139.887511] ath9k: Set channel: 2462 MHz
[  139.887516] ath9k: tx chmask: 1, rx chmask: 1
[  139.887624] ath9k: (2462 MHz) -> (2462 MHz), chanwidth: 0
[  139.896694] ath9k: Set HW RX filter: 0x607
[  139.896701] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  139.896707] ath9k: BSS Changed PREAMBLE 1
[  139.896711] ath9k: BSS Changed CTS PROT 0
[  139.896715] ath9k: BSS Changed ASSOC 1
[  139.896718] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  139.899489] PM: Finishing wakeup.
[  139.899494] Restarting tasks ... done.
[  139.934227] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
[  139.934270] activated addBA response timer on tid 0
[  139.936192] Rx A-MPDU request on tid 0 result 0
[  139.954281] switched off addBA timer for tid 0 
[  139.954289] Aggregation is on for tid 0 
[  140.571086] ACPI: EC: missing confirmations, switch off interrupt mode.
[  141.076065] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] 20090521 evregion-424
[  141.076106] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.SBRG.EC0_.BST3] (Node f7013ea0), AE_TIME
[  141.076205] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.CBST] (Node f70160a8), AE_TIME
[  141.076249] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.BAT0._BST] (Node f7014fd8), AE_TIME
[  141.076303] ACPI Exception: AE_TIME, Evaluating _BST 20090521 battery-385

I'll note though that I've even seen the ACPI error messages even
after a first busted resume. In that case the device already is
unresponsive before these ACPI messages.

  Luis
