Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbZLVR7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbZLVR7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZLVR7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:59:42 -0500
Received: from mail.atheros.com ([12.36.123.2]:44745 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbZLVR7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:59:41 -0500
Date: Tue, 22 Dec 2009 09:59:39 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@atheros.com>
CC: Sujith Manoharan <Sujith.Manoharan@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner
 case
Message-ID: <20091222175939.GF4385@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
 <19248.19829.293087.367661@gargle.gargle.HOWL>
 <20091222155005.GA4385@tux>
 <20091222162055.GC4385@tux>
 <20091222165528.GE4385@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20091222165528.GE4385@tux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 08:55:28AM -0800, Luis Rodriguez wrote:
> On Tue, Dec 22, 2009 at 08:20:55AM -0800, Luis Rodriguez wrote:
> > On Tue, Dec 22, 2009 at 07:50:05AM -0800, Luis Rodriguez wrote:
> > > On Mon, Dec 21, 2009 at 08:39:17PM -0800, Sujith Manoharan wrote:
> > > > Luis Rodriguez wrote:
> > > > > That log can be found here:
> > > > >
> > > > > http://bombadil.infradead.org/~mcgrof/logs/2.6.31-with-2.6.32-wireless/irq-disabled.txt
> > > >
> > > > Thanks for the log.
> > > > It's a bug in ath9k, related to PowerSave.
> > > >
> > > > Can you test this patch ?
> > > >
> > > > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> > > > index 3f5b887..419c382 100644
> > > > --- a/drivers/net/wireless/ath/ath9k/main.c
> > > > +++ b/drivers/net/wireless/ath/ath9k/main.c
> > > > @@ -2504,6 +2504,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
> > > >                 return; /* another wiphy still in use */
> > > >         }
> > > >
> > > > +       /* Ensure HW is awake when we try to shut it down. */
> > > > +       ath9k_ps_wakeup(sc);
> > > > +
> > > >         if (ah->btcoex_hw.enabled) {
> > > >                 ath9k_hw_btcoex_disable(ah);
> > > >                 if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
> > > > @@ -2524,8 +2527,10 @@ static void ath9k_stop(struct ieee80211_hw *hw)
> > > >         /* disable HAL and put h/w to sleep */
> > > >         ath9k_hw_disable(ah);
> > > >         ath9k_hw_configpcipowersave(ah, 1, 1);
> > > > -       ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
> > > > +       ath9k_ps_restore(sc);
> > > >
> > > > +       /* Finally, put the chip in FULL SLEEP mode */
> > > > +       ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
> > > >         sc->sc_flags |= SC_OP_INVALID;
> > > >
> > > >         mutex_unlock(&sc->mutex);
> > >
> > >
> > > Thanks for the patch, doesn't cure it though. Below is the log
> > > with debug=0xa00 (CONFIG | PS), you can see some successes prior to
> > > the failure.
> >
> > Here's the new log with 0x601, with a few pm-suspend successes above.
> 
> Let me massage this a little:
> 
> Here is one success:
> 
> > [  249.543348] ath9k: NETWORK SLEEP -> AWAKE
> > [  249.549393] ath9k: AWAKE -> NETWORK SLEEP
> > [  249.577650] PM: Syncing filesystems ...
> > [  249.645775] ath9k: NETWORK SLEEP -> AWAKE
> > [  249.651822] ath9k: AWAKE -> NETWORK SLEEP
> > [  249.677281] done.
> > [  249.677291] PM: Preparing system for mem sleep
> > [  249.748159] ath9k: NETWORK SLEEP -> AWAKE
> > [  249.754256] ath9k: AWAKE -> NETWORK SLEEP
> > [  249.765132] ath9k: NETWORK SLEEP -> AWAKE
> 
> Device is awake prior to sending Tx BA.
> 
> > [  249.824923] Freezing user space processes ... (elapsed 0.00 seconds) done.
> > [  249.826762] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> > [  249.826830] PM: Entering mem sleep
> > [  249.826853] Suspending console(s) (use no_console_suspend to debug)
> > [  249.832057] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
> > [  249.832077] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
> > [  249.832110] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
> > [  249.832130] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 6
> > [  249.832141] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 6
> > [  249.832166] ath9k: Detach Interface
> > [  249.834435] ath9k: AWAKE -> FULL-SLEEP
> > [  249.834446] ath9k: Driver halt
> > [  249.858079] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> > [  249.858457] sd 0:0:0:0: [sda] Stopping disk
> > [  250.781437] ath9k 0000:01:00.0: PCI INT A disabled
> 
> > [  251.087088] Back to C!
> 
> > [  252.038696] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> > [  254.521068] ath9k: Starting driver with initial channel: 2437 MHz
> > [  254.522086] ath9k: FULL-SLEEP -> AWAKE
> > [  254.533094] ath9k: ah->misc_mode 0x4
> > [  254.535214] ath9k: Attach a VIF of type: 2
> > [  254.535248] ath9k: Set channel: 2437 MHz
> > [  254.535252] ath9k: tx chmask: 1, rx chmask: 1
> > [  254.535373] ath9k: (2437 MHz) -> (2437 MHz), chanwidth: 1
> > [  254.541929] ath9k: ah->misc_mode 0x4
> > [  254.544052] ath9k: Set HW RX filter: 0x607
> > [  254.544058] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
> > [  254.544065] ath9k: BSS Changed PREAMBLE 1
> > [  254.544068] ath9k: BSS Changed CTS PROT 0
> > [  254.544072] ath9k: BSS Changed ASSOC 1
> > [  254.544076] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
> > [  254.546454] PM: Finishing wakeup.
> > [  254.546458] Restarting tasks ... done.
> > [  254.589051] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
> > [  254.589095] activated addBA response timer on tid 0
> > [  254.615144] Rx A-MPDU request on tid 0 result 0
> > [  254.717357] switched off addBA timer for tid 0
> > [  254.717366] Aggregation is on for tid 0
> > [  254.718297] switched off addBA timer for tid 0
> 
> Then this is the failure suspend:
> 
> > [  270.574054] ath9k: NETWORK SLEEP -> AWAKE
> > [  270.582421] ath9k: AWAKE -> NETWORK SLEEP
> > [  270.676431] ath9k: NETWORK SLEEP -> AWAKE
> > [  270.682643] ath9k: AWAKE -> NETWORK SLEEP
> > [  270.778860] ath9k: NETWORK SLEEP -> AWAKE
> > [  270.989686] ath9k: AWAKE -> NETWORK SLEEP
> > [  271.049041] ath9k: NETWORK SLEEP -> AWAKE
> > [  271.304833] PM: Syncing filesystems ... done.
> > [  271.307636] PM: Preparing system for mem sleep
> > [  271.399307] ath9k: AWAKE -> NETWORK SLEEP
> 
> Below the device seems to go to sleep prior to sending the Tx BA, but I could have
> sworn this happens in another successfull suspend before.
> 
> > [  271.448580] Freezing user space processes ... (elapsed 0.00 seconds) done.
> > [  271.450215] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> > [  271.450296] PM: Entering mem sleep
> > [  271.450321] Suspending console(s) (use no_console_suspend to debug)
> > [  271.456054] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
> > [  271.456073] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
> > [  271.456112] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
> > [  271.456141] ath9k: Detach Interface
> > [  271.456161] ath9k: NETWORK SLEEP -> AWAKE
> > [  271.458525] ath9k: AWAKE -> NETWORK SLEEP
> > [  271.458533] ath9k: NETWORK SLEEP -> FULL-SLEEP
> > [  271.458544] ath9k:
> > [  271.458547] ath9k: Driver halt
> > [  271.458552] FULL-SLEEP -> AWAKE
> 
> And we leave it awake prior to suspend, hrm.
> 
> > [  271.485081] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> > [  271.485444] sd 0:0:0:0: [sda] Stopping disk
> > [  272.348209] ath9k 0000:01:00.0: PCI INT A disabled
> 
> > [  272.552139] Back to C!
> 
> > [  273.522696] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> > [  275.742070] ath9k: Starting driver with initial channel: 2437 MHz
> > [  275.891791] ath9k: timeout (100000 us) on reg 0x7000: 0xdeadbeef & 0x00000003 != 0x00000000
> > [  275.891799] ath9k: RTC stuck in MAC reset
> 
> AT this point hardware is already completely unresonsive.
> 
> > [  275.891803] ath9k: Chip reset failed
> > [  275.891807] ath9k: Unable to reset hardware; reset status -22 (freq 2437 MHz)
> > [  275.891827] ath9k: Attach a VIF of type: 2
> > [  275.891867] ath9k: Set channel: 2437 MHz
> > [  275.891873] ath9k: tx chmask: 1, rx chmask: 1
> > [  275.891880] ath9k: Unable to set channel
> > [  275.891894] ath9k: Set HW RX filter: 0x2707
> > [  275.891901] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
> > [  275.891910] ath9k: BSS Changed PREAMBLE 1
> > [  275.891915] ath9k: BSS Changed CTS PROT 0
> > [  275.891919] ath9k: BSS Changed ASSOC 1
> > [  275.891924] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
> > [  275.894481] PM: Finishing wakeup.
> > [  275.894486] Restarting tasks ... done.
> > [  276.835592] irq 18: nobody cared (try booting with the "irqpoll" option)
> > [  276.835609] Pid: 1710, comm: Xorg Not tainted 2.6.31.4-intel-menlow #14
> > [  276.835616] Call Trace:
> > [  276.835636]  [<c105ca3e>] __report_bad_irq+0x2e/0x6f
> > [  276.835646]  [<c105cb74>] note_interrupt+0xf5/0x14d
> > [  276.835656]  [<c105d0a4>] handle_fasteoi_irq+0x7d/0x9b
> > [  276.835668]  [<c10048c1>] handle_irq+0x3b/0x46
> > [  276.835677]  [<c1004103>] do_IRQ+0x41/0x95
> > [  276.835687]  [<c1003189>] common_interrupt+0x29/0x30
> > [  276.835693] handlers:
> > [  276.835698] [<f89a3d03>] (ath_isr+0x0/0x12f [ath9k])
> > [  276.835739] Disabling IRQ #18

Here's a new log with a two printks added as follows:

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 420e165..a74f9db 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2145,6 +2145,10 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		return; /* another wiphy still in use */
 	}
 
+	/* Ensure HW is awake when we try to shut it down. */
+	printk("== Wake up!\n");
+	ath9k_ps_wakeup(sc);
+
 	if (sc->sc_flags & SC_OP_BTCOEX_ENABLED) {
 		ath9k_hw_btcoex_disable(sc->sc_ah);
 		if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
@@ -2165,7 +2169,11 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(sc->sc_ah);
 	ath9k_hw_configpcipowersave(sc->sc_ah, 1, 1);
+	ath9k_ps_restore(sc);
+
+	/* Finally, put the chip in FULL SLEEP mode */
 	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
+	printk("== Sleep!\n");
 
 	sc->sc_flags |= SC_OP_INVALID;

And the log, massaged to keep only relevant sections below.

Suspend success cycle #1:

[  182.156952] ath9k: AWAKE -> NETWORK SLEEP
[  182.253322] ath9k: NETWORK SLEEP -> AWAKE
[  182.260175] ath9k: AWAKE -> NETWORK SLEEP
[  182.355720] ath9k: NETWORK SLEEP -> AWAKE
[  182.361755] ath9k: AWAKE -> NETWORK SLEEP
[  182.458145] ath9k: NETWORK SLEEP -> AWAKE
[  182.459914] PM: Syncing filesystems ... 
[  182.660736] ath9k: AWAKE -> NETWORK SLEEP
[  182.662924] ath9k: NETWORK SLEEP -> AWAKE
[  182.681816] ath9k: AWAKE -> NETWORK SLEEP
[  182.765356] ath9k: NETWORK SLEEP -> AWAKE
[  182.784954] ath9k: AWAKE -> NETWORK SLEEP
[  182.798240] done.
[  182.798250] PM: Preparing system for mem sleep
[  182.867751] ath9k: NETWORK SLEEP -> AWAKE
[  182.876104] ath9k: AWAKE -> NETWORK SLEEP

Note device in NETWORK_SLEEP and below we send Tx BA.

[  182.944721] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  182.946141] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  182.946222] PM: Entering mem sleep
[  182.946245] Suspending console(s) (use no_console_suspend to debug)
[  182.950334] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  182.950354] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[  182.950392] ath9k: 
[  182.950403] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0

We awaken only for the Tx BA for TID 6 below.

[  182.950410] NETWORK SLEEP -> AWAKE
[  182.950429] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 6
[  182.950444] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 6
[  182.950509] ath9k: Detach Interface
[  182.950527] == Wake up!
[  182.952768] ath9k: AWAKE -> FULL-SLEEP
[  182.952779] == Sleep!

[  182.952781] ath9k: Driver halt
[  182.976080] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  182.976457] sd 0:0:0:0: [sda] Stopping disk
[  183.908332] ath9k 0000:01:00.0: PCI INT A disabled
[  183.932618] ACPI handle has no context!
[  183.932632] atl1c 0000:02:00.0: PME# disabled
[  183.932643] atl1c 0000:02:00.0: PCI INT A disabled
[  183.932653] ACPI handle has no context!
[  183.976158] ata6: port disabled. ignoring.
[  183.976246] ata_piix 0000:00:1f.1: PCI INT A disabled
[  183.976264] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  183.976276] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  183.976287] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  183.976298] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  183.976309] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  183.994731] i915 0000:00:02.0: PCI INT A disabled
[  184.005417] ehci_hcd 0000:00:1d.7: PME# disabled
[  184.016463] ACPI: Preparing to enter system sleep state S3
[  184.104766] Disabling non-boot CPUs ...
[  184.107102] CPU 1 is now offline
[  184.107108] SMP alternatives: switching to UP code
[  184.111140] CPU1 is down
[  184.111163] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106

[  184.111163] Back to C!


[  185.060698] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  187.457073] ath9k: Starting driver with initial channel: 2437 MHz
[  187.458091] ath9k: FULL-SLEEP -> AWAKE
[  187.469043] ath9k: ah->misc_mode 0x4
[  187.471159] ath9k: Attach a VIF of type: 2
[  187.471191] ath9k: Set channel: 2437 MHz
[  187.471196] ath9k: tx chmask: 1, rx chmask: 1
[  187.471317] ath9k: (2437 MHz) -> (2437 MHz), chanwidth: 1
[  187.477858] ath9k: ah->misc_mode 0x4
[  187.479976] ath9k: Set HW RX filter: 0x607
[  187.479982] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  187.479989] ath9k: BSS Changed PREAMBLE 1
[  187.479992] ath9k: BSS Changed CTS PROT 0
[  187.479996] ath9k: BSS Changed ASSOC 1
[  187.480000] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  187.482457] PM: Finishing wakeup.
[  187.482462] Restarting tasks ... done.
[  187.530036] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
[  187.530077] activated addBA response timer on tid 0
[  187.537252] Rx A-MPDU request on tid 0 result 0
[  187.541097] switched off addBA timer for tid 0 
[  187.541104] Aggregation is on for tid 0 
[  187.749356] ath9k: AWAKE -> NETWORK SLEEP
[  187.775809] ath9k: NETWORK SLEEP -> AWAKE

etc

second pm-suspend success:

[  192.212022] ath9k: NETWORK SLEEP -> AWAKE
[  192.218060] ath9k: AWAKE -> NETWORK SLEEP
[  192.231965] PM: Syncing filesystems ... 
[  192.314416] ath9k: NETWORK SLEEP -> AWAKE
[  192.327533] ath9k: AWAKE -> NETWORK SLEEP
[  192.416841] ath9k: NETWORK SLEEP -> AWAKE
[  192.427949] ath9k: AWAKE -> NETWORK SLEEP
[  192.455560] done.
[  192.455569] PM: Preparing system for mem sleep
[  192.519226] ath9k: NETWORK SLEEP -> AWAKE
[  192.525257] ath9k: AWAKE -> NETWORK SLEEP
[  192.530138] ath9k: NETWORK SLEEP -> AWAKE

Device AWAKE prior to sending the Tx BA on both TIDs below.

[  192.602902] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  192.604579] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  192.604654] PM: Entering mem sleep
[  192.604675] Suspending console(s) (use no_console_suspend to debug)
[  192.610334] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  192.610355] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[  192.610387] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  192.610414] ath9k: Detach Interface
[  192.610427] == Wake up!
[  192.612705] ath9k: AWAKE -> FULL-SLEEP
[  192.612716] == Sleep!

Device now asleep..

[  192.612719] ath9k: Driver halt
[  192.635080] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  192.635448] sd 0:0:0:0: [sda] Stopping disk
[  193.485094] ath9k 0000:01:00.0: PCI INT A disabled
[  193.509614] ACPI handle has no context!

Suspeneded.

[  193.685151] Back to C!

[  193.765036] ACPI: Waking up from system sleep state S3
[  194.623693] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  196.841100] ath9k: FULL-SLEEP -> AWAKE
[  196.852089] ath9k: ah->misc_mode 0x4
[  196.854196] ath9k: Attach a VIF of type: 2
[  196.854229] ath9k: Set channel: 2437 MHz
[  196.854233] ath9k: tx chmask: 1, rx chmask: 1
[  196.854355] ath9k: (2437 MHz) -> (2437 MHz), chanwidth: 1
[  196.860891] ath9k: ah->misc_mode 0x4
[  196.863000] ath9k: Set HW RX filter: 0x607
[  196.863021] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  196.863027] ath9k: BSS Changed PREAMBLE 1
[  196.863031] ath9k: BSS Changed CTS PROT 0
[  196.863035] ath9k: BSS Changed ASSOC 1
[  196.863038] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  196.865482] PM: Finishing wakeup.
[  196.865487] Restarting tasks ... done.
[  196.889882] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
[  196.889916] activated addBA response timer on tid 0
[  196.895041] Rx A-MPDU request on tid 0 result 0
[  196.897663] switched off addBA timer for tid 0 
[  196.897671] Aggregation is on for tid 0 
[  197.006590] ath9k: AWAKE -> NETWORK SLEEP
[  197.892811] ath9k: NETWORK SLEEP -> AWAKE

Shake and bake.

And then immediatey another quick suspend (#4) right after:

[  198.098735] ath9k: AWAKE -> NETWORK SLEEP
[  198.894095] ath9k: NETWORK SLEEP -> AWAKE
[  199.021250] ath9k: AWAKE -> NETWORK SLEEP
[  199.895581] ath9k: NETWORK SLEEP -> AWAKE
[  200.028475] ath9k: AWAKE -> NETWORK SLEEP
[  200.902321] ath9k: NETWORK SLEEP -> AWAKE
[  201.027363] ath9k: AWAKE -> NETWORK SLEEP
[  201.605981] ath9k: NETWORK SLEEP -> AWAKE
[  201.731412] ath9k: AWAKE -> NETWORK SLEEP
[  201.903590] ath9k: NETWORK SLEEP -> AWAKE
[  201.948356] PM: Syncing filesystems ... 
[  202.030148] ath9k: AWAKE -> NETWORK SLEEP
[  202.161849] done.
[  202.161859] PM: Preparing system for mem sleep
[  202.305059] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  202.306442] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  202.306525] PM: Entering mem sleep
[  202.306547] Suspending console(s) (use no_console_suspend to debug)

Device in NETWORK_SLEEP state prior to sendign the Tx BA for TID 0,
nothing was sent for Tid 6 as no BA session was established after
resume, it was a quick resume --> suspend cycle.

[  202.311334] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  202.311354] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[  202.311393] ath9k: 
[  202.311402] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  202.311411] NETWORK SLEEP -> AWAKE
[  202.311506] ath9k: Detach Interface
[  202.311525] == Wake up!
[  202.313823] ath9k: AWAKE -> FULL-SLEEP
[  202.313834] == Sleep!
[  202.313836] ath9k: Driver halt
[  203.281163] ath9k 0000:01:00.0: PCI INT A disabled
[  203.305614] ACPI handle has no context!


[  203.483156] Back to C!

Waking up from suspend #4 now.


[  203.561036] ACPI: Waking up from system sleep state S3
[  204.430697] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  206.660077] ath9k: Starting driver with initial channel: 2437 MHz
[  206.661096] ath9k: FULL-SLEEP -> AWAKE
[  206.672056] ath9k: ah->misc_mode 0x4
[  206.674176] ath9k: Attach a VIF of type: 2
[  206.674209] ath9k: Set channel: 2437 MHz
[  206.674214] ath9k: tx chmask: 1, rx chmask: 1
[  206.674335] ath9k: (2437 MHz) -> (2437 MHz), chanwidth: 1
[  206.680870] ath9k: ah->misc_mode 0x4
[  206.682973] ath9k: Set HW RX filter: 0x607
[  206.682980] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  206.682986] ath9k: BSS Changed PREAMBLE 1
[  206.682990] ath9k: BSS Changed CTS PROT 0
[  206.682994] ath9k: BSS Changed ASSOC 1
[  206.682997] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  206.685445] PM: Finishing wakeup.
[  206.685449] Restarting tasks ... done.
[  206.721949] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
[  206.721994] activated addBA response timer on tid 0
[  206.726181] Rx A-MPDU request on tid 0 result 0
[  206.728552] switched off addBA timer for tid 0 
[  206.728560] Aggregation is on for tid 0 
[  206.832028] ath9k: AWAKE -> NETWORK SLEEP
[  207.716419] ath9k: NETWORK SLEEP -> AWAKE
[  207.848507] ath9k: AWAKE -> NETWORK SLEEP

etc..

Here's another sucessfull suspend (#5):

[  210.821393] ath9k: NETWORK SLEEP -> AWAKE
[  210.821468] ath9k: AWAKE -> NETWORK SLEEP
[  210.831262] ath9k: NETWORK SLEEP -> AWAKE
[  210.936498] ath9k: AWAKE -> NETWORK SLEEP
[  211.463078] PM: Syncing filesystems ... done.
[  211.670449] PM: Preparing system for mem sleep
[  211.723388] ath9k: NETWORK SLEEP -> AWAKE

Device awake prior to sending Tx BA stop request on TID 0:

[  211.818907] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  211.820532] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  211.820611] PM: Entering mem sleep
[  211.820633] Suspending console(s) (use no_console_suspend to debug)
[  211.826059] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  211.826078] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[  211.826113] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  211.826141] ath9k: Detach Interface
[  211.826155] == Wake up!
[  211.828465] ath9k: AWAKE -> FULL-SLEEP
[  211.828476] == Sleep!
[  211.828478] ath9k: Driver halt
[  212.702026] ath9k 0000:01:00.0: PCI INT A disabled
[  212.726613] ACPI handle has no context!
[  212.807467] ACPI: Preparing to enter system sleep state S3

[  212.906162] Back to C!

[  213.863686] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  216.080072] ath9k: Starting driver with initial channel: 2437 MHz
[  216.081090] ath9k: FULL-SLEEP -> AWAKE
[  216.092044] ath9k: ah->misc_mode 0x4
[  216.094160] ath9k: Attach a VIF of type: 2
[  216.094193] ath9k: Set channel: 2437 MHz
[  216.094197] ath9k: tx chmask: 1, rx chmask: 1
[  216.094320] ath9k: (2437 MHz) -> (2437 MHz), chanwidth: 1
[  216.100867] ath9k: ah->misc_mode 0x4
[  216.102987] ath9k: Set HW RX filter: 0x607
[  216.102994] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  216.103014] ath9k: BSS Changed PREAMBLE 1
[  216.103018] ath9k: BSS Changed CTS PROT 0
[  216.103022] ath9k: BSS Changed ASSOC 1
[  216.103025] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  216.105477] PM: Finishing wakeup.
[  216.105481] Restarting tasks ... done.
[  216.128225] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
[  216.128259] activated addBA response timer on tid 0
[  216.130182] Rx A-MPDU request on tid 0 result 0
[  216.139669] switched off addBA timer for tid 0 
[  216.139677] Aggregation is on for tid 0 

Ok resume from suspend  #5 complete. Now here goes another successfull
suspend but with some complaints from ACPI noted.

[  216.237502] ath9k: AWAKE -> NETWORK SLEEP
[  217.129138] ath9k: NETWORK SLEEP -> AWAKE
[  217.240499] ath9k: AWAKE -> NETWORK SLEEP
[  218.130666] ath9k: NETWORK SLEEP -> AWAKE
[  218.245793] ath9k: AWAKE -> NETWORK SLEEP
[  219.132386] ath9k: NETWORK SLEEP -> AWAKE
[  219.288081] ath9k: AWAKE -> NETWORK SLEEP
[  220.034303] ACPI: EC: missing confirmations, switch off interrupt mode.

Wonder what that is..

[  220.133204] ath9k: NETWORK SLEEP -> AWAKE
[  220.287540] ath9k: AWAKE -> NETWORK SLEEP
[  220.287596] ath9k: NETWORK SLEEP -> AWAKE
[  220.287678] ath9k: AWAKE -> NETWORK SLEEP
[  220.304659] ath9k: NETWORK SLEEP -> AWAKE
[  220.304780] ath9k: AWAKE -> NETWORK SLEEP
[  220.305334] ath9k: NETWORK SLEEP -> AWAKE
[  220.407614] ath9k: AWAKE -> NETWORK SLEEP
[  220.538072] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] 20090521 evregion-424
[  220.538112] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.SBRG.EC0_.BST2] (Node f7013e88), AE_TIME
[  220.538208] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.CBST] (Node f70160a8), AE_TIME
[  220.538251] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.BAT0._BST] (Node f7014fd8), AE_TIME
[  220.538341] ACPI Exception: AE_TIME, Evaluating _BST 20090521 battery-385

There goes that ACPI excemption.

Here goes successfull suspend #6:

[  220.565306] PM: Syncing filesystems ... done.
[  220.812903] PM: Preparing system for mem sleep
[  220.959826] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  220.961228] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  220.961314] PM: Entering mem sleep
[  220.961336] Suspending console(s) (use no_console_suspend to debug)
[  220.966334] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0

Note, we send the Tx BA session stop reequest when device is in NETWORK_SLEEP.

[  220.966353] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[  220.966392] ath9k: 
[  220.966401] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  220.966410] NETWORK SLEEP -> AWAKE
[  220.966506] ath9k: Detach Interface
[  220.966524] == Wake up!
[  220.968800] ath9k: AWAKE -> FULL-SLEEP
[  220.968810] == Sleep!
[  220.968813] ath9k: Driver halt
[  221.920357] ath9k 0000:01:00.0: PCI INT A disabled
[  221.944617] ACPI handle has no context!

[  222.026467] ACPI: Preparing to enter system sleep state S3

[  222.134152] Back to C!

[  223.082691] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18

[  225.298081] ath9k: Starting driver with initial channel: 2437 MHz
[  225.299099] ath9k: FULL-SLEEP -> AWAKE
[  225.310044] ath9k: ah->misc_mode 0x4
[  225.312175] ath9k: Attach a VIF of type: 2
[  225.312208] ath9k: Set channel: 2437 MHz
[  225.312212] ath9k: tx chmask: 1, rx chmask: 1
[  225.312334] ath9k: (2437 MHz) -> (2437 MHz), chanwidth: 1
[  225.318873] ath9k: ah->misc_mode 0x4
[  225.320975] ath9k: Set HW RX filter: 0x607
[  225.320981] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  225.320987] ath9k: BSS Changed PREAMBLE 1
[  225.320991] ath9k: BSS Changed CTS PROT 0
[  225.320995] ath9k: BSS Changed ASSOC 1
[  225.320998] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  225.323482] PM: Finishing wakeup.
[  225.323486] Restarting tasks ... done.
[  225.350006] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
[  225.350075] activated addBA response timer on tid 0
[  225.351993] Rx A-MPDU request on tid 0 result 0
[  225.354056] switched off addBA timer for tid 0 
[  225.354064] Aggregation is on for tid 0 
[  225.453681] ath9k: AWAKE -> NETWORK SLEEP
[  226.348955] ath9k: NETWORK SLEEP -> AWAKE
[  226.529134] ath9k: AWAKE -> NETWORK SLEEP
[  227.350638] ath9k: NETWORK SLEEP -> AWAKE
[  227.537846] ath9k: AWAKE -> NETWORK SLEEP
[  228.352545] ath9k: NETWORK SLEEP -> AWAKE
[  228.497730] ath9k: AWAKE -> NETWORK SLEEP
[  229.353944] ath9k: NETWORK SLEEP -> AWAKE
[  229.546220] ath9k: AWAKE -> NETWORK SLEEP
[  230.356288] ath9k: NETWORK SLEEP -> AWAKE
[  230.503293] ath9k: AWAKE -> NETWORK SLEEP

And we're up again.




Here's the failure coming up now. On the 6th suspend this time:

[  230.560286] PM: Syncing filesystems ... 
[  230.599622] ath9k: NETWORK SLEEP -> AWAKE
[  230.708382] ath9k: AWAKE -> NETWORK SLEEP
[  230.806539] done.
[  230.806549] PM: Preparing system for mem sleep
[  230.952445] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  230.953807] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  230.953892] PM: Entering mem sleep
[  230.953915] Suspending console(s) (use no_console_suspend to debug)
[  230.958315] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  230.958335] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[  230.958374] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  230.958402] ath9k: Detach Interface

In NETWORK_SLEEP while we Tx BA session stop request for TID 0 above.
But that's not the only thing we do here, we also call
ath9k_remove_interface() while in NETWORK_SLEEP which could cause
an issue. Its the only thing strikingly odd which I notice from
the logs.

After this we proceed to rest of the suspend, below starts
the ath9k_stop()

[  230.958421] == Wake up!
[  230.958426] ath9k: NETWORK SLEEP -> AWAKE
[  230.960795] ath9k: AWAKE -> NETWORK SLEEP
[  230.960802] ath9k: NETWORK SLEEP -> FULL-SLEEP
[  230.960812] == Sleep!
[  230.960814] ath9k: Driver halt

ath9k_stop() ends here.

[  230.960823] ath9k: FULL-SLEEP -> AWAKE
[  231.859368] ath9k 0000:01:00.0: PCI INT A disabled
[  231.883613] ACPI handle has no context!

[  232.062155] Back to C!

[  232.140041] ACPI: Waking up from system sleep state S3
[  233.028686] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  235.248074] ath9k: Starting driver with initial channel: 2437 MHz
[  235.397220] ath9k: timeout (100000 us) on reg 0x7000: 0xdeadbeef & 0x00000003 != 0x00000000
[  235.397228] ath9k: RTC stuck in MAC reset

Bleh.

[  235.397232] ath9k: Chip reset failed
[  235.397236] ath9k: Unable to reset hardware; reset status -22 (freq 2437 MHz)
[  235.397266] ath9k: Attach a VIF of type: 2
[  235.397314] ath9k: Set channel: 2437 MHz
[  235.397320] ath9k: tx chmask: 1, rx chmask: 1
[  235.397326] ath9k: Unable to set channel
[  235.397340] ath9k: Set HW RX filter: 0x2707
[  235.397348] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  235.397356] ath9k: BSS Changed PREAMBLE 1
[  235.397361] ath9k: BSS Changed CTS PROT 0
[  235.397366] ath9k: BSS Changed ASSOC 1
[  235.397371] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  235.400473] PM: Finishing wakeup.
[  235.400479] Restarting tasks ... done.
[  236.263277] irq 18: nobody cared (try booting with the "irqpoll" option)
[  236.263293] Pid: 1773, comm: Xorg Not tainted 2.6.31.4-intel-menlow #15
[  236.263300] Call Trace:
[  236.263318]  [<c105ca3e>] __report_bad_irq+0x2e/0x6f
[  236.263329]  [<c105cb74>] note_interrupt+0xf5/0x14d
[  236.263341]  [<c105d0a4>] handle_fasteoi_irq+0x7d/0x9b
[  236.263352]  [<c10048c1>] handle_irq+0x3b/0x46
[  236.263362]  [<c1004103>] do_IRQ+0x41/0x95
[  236.263372]  [<c1003189>] common_interrupt+0x29/0x30
[  236.263379] handlers:
[  236.263384] [<f8a2cd1b>] (ath_isr+0x0/0x12f [ath9k])
[  236.263423] Disabling IRQ #18

I just tried adding the PM stuff over ath9k_remove_interface and I still get the
issue. The patch is below.

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 420e165..4cb38b6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2145,6 +2145,10 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		return; /* another wiphy still in use */
 	}
 
+	/* Ensure HW is awake when we try to shut it down. */
+	printk("== Wake up!\n");
+	ath9k_ps_wakeup(sc);
+
 	if (sc->sc_flags & SC_OP_BTCOEX_ENABLED) {
 		ath9k_hw_btcoex_disable(sc->sc_ah);
 		if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
@@ -2165,7 +2169,11 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(sc->sc_ah);
 	ath9k_hw_configpcipowersave(sc->sc_ah, 1, 1);
+	ath9k_ps_restore(sc);
+
+	/* Finally, put the chip in FULL SLEEP mode */
 	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
+	printk("== Sleep!\n");
 
 	sc->sc_flags |= SC_OP_INVALID;
 
@@ -2268,6 +2276,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 
+	ath9k_ps_wakeup(sc);
+
 	/* Stop ANI */
 	del_timer_sync(&sc->ani.timer);
 
@@ -2292,6 +2302,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	sc->nvifs--;
 
+	ath9k_ps_restore(sc);
+
 	mutex_unlock(&sc->mutex);
 }
 
  Luis
