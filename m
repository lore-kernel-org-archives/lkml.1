Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZLVQzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZLVQzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 11:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZLVQzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 11:55:31 -0500
Received: from mail.atheros.com ([12.36.123.2]:40066 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbZLVQza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 11:55:30 -0500
Date: Tue, 22 Dec 2009 08:55:28 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@atheros.com>
CC: Sujith Manoharan <Sujith.Manoharan@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner
 case
Message-ID: <20091222165528.GE4385@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
 <19248.19829.293087.367661@gargle.gargle.HOWL>
 <20091222155005.GA4385@tux>
 <20091222162055.GC4385@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20091222162055.GC4385@tux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 08:20:55AM -0800, Luis Rodriguez wrote:
> On Tue, Dec 22, 2009 at 07:50:05AM -0800, Luis Rodriguez wrote:
> > On Mon, Dec 21, 2009 at 08:39:17PM -0800, Sujith Manoharan wrote:
> > > Luis Rodriguez wrote:
> > > > That log can be found here:
> > > >
> > > > http://bombadil.infradead.org/~mcgrof/logs/2.6.31-with-2.6.32-wireless/irq-disabled.txt
> > >
> > > Thanks for the log.
> > > It's a bug in ath9k, related to PowerSave.
> > >
> > > Can you test this patch ?
> > >
> > > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> > > index 3f5b887..419c382 100644
> > > --- a/drivers/net/wireless/ath/ath9k/main.c
> > > +++ b/drivers/net/wireless/ath/ath9k/main.c
> > > @@ -2504,6 +2504,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
> > >                 return; /* another wiphy still in use */
> > >         }
> > >
> > > +       /* Ensure HW is awake when we try to shut it down. */
> > > +       ath9k_ps_wakeup(sc);
> > > +
> > >         if (ah->btcoex_hw.enabled) {
> > >                 ath9k_hw_btcoex_disable(ah);
> > >                 if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
> > > @@ -2524,8 +2527,10 @@ static void ath9k_stop(struct ieee80211_hw *hw)
> > >         /* disable HAL and put h/w to sleep */
> > >         ath9k_hw_disable(ah);
> > >         ath9k_hw_configpcipowersave(ah, 1, 1);
> > > -       ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
> > > +       ath9k_ps_restore(sc);
> > >
> > > +       /* Finally, put the chip in FULL SLEEP mode */
> > > +       ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
> > >         sc->sc_flags |= SC_OP_INVALID;
> > >
> > >         mutex_unlock(&sc->mutex);
> >
> >
> > Thanks for the patch, doesn't cure it though. Below is the log
> > with debug=0xa00 (CONFIG | PS), you can see some successes prior to
> > the failure.
> 
> Here's the new log with 0x601, with a few pm-suspend successes above.

Let me massage this a little:

Here is one success:

> [  249.543348] ath9k: NETWORK SLEEP -> AWAKE
> [  249.549393] ath9k: AWAKE -> NETWORK SLEEP
> [  249.577650] PM: Syncing filesystems ...
> [  249.645775] ath9k: NETWORK SLEEP -> AWAKE
> [  249.651822] ath9k: AWAKE -> NETWORK SLEEP
> [  249.677281] done.
> [  249.677291] PM: Preparing system for mem sleep
> [  249.748159] ath9k: NETWORK SLEEP -> AWAKE
> [  249.754256] ath9k: AWAKE -> NETWORK SLEEP
> [  249.765132] ath9k: NETWORK SLEEP -> AWAKE

Device is awake prior to sending Tx BA.

> [  249.824923] Freezing user space processes ... (elapsed 0.00 seconds) done.
> [  249.826762] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> [  249.826830] PM: Entering mem sleep
> [  249.826853] Suspending console(s) (use no_console_suspend to debug)
> [  249.832057] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
> [  249.832077] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
> [  249.832110] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
> [  249.832130] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 6
> [  249.832141] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 6
> [  249.832166] ath9k: Detach Interface
> [  249.834435] ath9k: AWAKE -> FULL-SLEEP
> [  249.834446] ath9k: Driver halt
> [  249.858079] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  249.858457] sd 0:0:0:0: [sda] Stopping disk
> [  250.781437] ath9k 0000:01:00.0: PCI INT A disabled

> [  251.087088] Back to C!

> [  252.038696] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [  254.521068] ath9k: Starting driver with initial channel: 2437 MHz
> [  254.522086] ath9k: FULL-SLEEP -> AWAKE
> [  254.533094] ath9k: ah->misc_mode 0x4
> [  254.535214] ath9k: Attach a VIF of type: 2
> [  254.535248] ath9k: Set channel: 2437 MHz
> [  254.535252] ath9k: tx chmask: 1, rx chmask: 1
> [  254.535373] ath9k: (2437 MHz) -> (2437 MHz), chanwidth: 1
> [  254.541929] ath9k: ah->misc_mode 0x4
> [  254.544052] ath9k: Set HW RX filter: 0x607
> [  254.544058] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
> [  254.544065] ath9k: BSS Changed PREAMBLE 1
> [  254.544068] ath9k: BSS Changed CTS PROT 0
> [  254.544072] ath9k: BSS Changed ASSOC 1
> [  254.544076] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
> [  254.546454] PM: Finishing wakeup.
> [  254.546458] Restarting tasks ... done.
> [  254.589051] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
> [  254.589095] activated addBA response timer on tid 0
> [  254.615144] Rx A-MPDU request on tid 0 result 0
> [  254.717357] switched off addBA timer for tid 0
> [  254.717366] Aggregation is on for tid 0
> [  254.718297] switched off addBA timer for tid 0

Then this is the failure suspend:

> [  270.574054] ath9k: NETWORK SLEEP -> AWAKE
> [  270.582421] ath9k: AWAKE -> NETWORK SLEEP
> [  270.676431] ath9k: NETWORK SLEEP -> AWAKE
> [  270.682643] ath9k: AWAKE -> NETWORK SLEEP
> [  270.778860] ath9k: NETWORK SLEEP -> AWAKE
> [  270.989686] ath9k: AWAKE -> NETWORK SLEEP
> [  271.049041] ath9k: NETWORK SLEEP -> AWAKE
> [  271.304833] PM: Syncing filesystems ... done.
> [  271.307636] PM: Preparing system for mem sleep
> [  271.399307] ath9k: AWAKE -> NETWORK SLEEP

Below the device seems to go to sleep prior to sending the Tx BA, but I could have
sworn this happens in another successfull suspend before.

> [  271.448580] Freezing user space processes ... (elapsed 0.00 seconds) done.
> [  271.450215] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> [  271.450296] PM: Entering mem sleep
> [  271.450321] Suspending console(s) (use no_console_suspend to debug)
> [  271.456054] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
> [  271.456073] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
> [  271.456112] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
> [  271.456141] ath9k: Detach Interface
> [  271.456161] ath9k: NETWORK SLEEP -> AWAKE
> [  271.458525] ath9k: AWAKE -> NETWORK SLEEP
> [  271.458533] ath9k: NETWORK SLEEP -> FULL-SLEEP
> [  271.458544] ath9k:
> [  271.458547] ath9k: Driver halt
> [  271.458552] FULL-SLEEP -> AWAKE

And we leave it awake prior to suspend, hrm.

> [  271.485081] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  271.485444] sd 0:0:0:0: [sda] Stopping disk
> [  272.348209] ath9k 0000:01:00.0: PCI INT A disabled

> [  272.552139] Back to C!

> [  273.522696] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [  275.742070] ath9k: Starting driver with initial channel: 2437 MHz
> [  275.891791] ath9k: timeout (100000 us) on reg 0x7000: 0xdeadbeef & 0x00000003 != 0x00000000
> [  275.891799] ath9k: RTC stuck in MAC reset

AT this point hardware is already completely unresonsive.

> [  275.891803] ath9k: Chip reset failed
> [  275.891807] ath9k: Unable to reset hardware; reset status -22 (freq 2437 MHz)
> [  275.891827] ath9k: Attach a VIF of type: 2
> [  275.891867] ath9k: Set channel: 2437 MHz
> [  275.891873] ath9k: tx chmask: 1, rx chmask: 1
> [  275.891880] ath9k: Unable to set channel
> [  275.891894] ath9k: Set HW RX filter: 0x2707
> [  275.891901] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
> [  275.891910] ath9k: BSS Changed PREAMBLE 1
> [  275.891915] ath9k: BSS Changed CTS PROT 0
> [  275.891919] ath9k: BSS Changed ASSOC 1
> [  275.891924] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
> [  275.894481] PM: Finishing wakeup.
> [  275.894486] Restarting tasks ... done.
> [  276.835592] irq 18: nobody cared (try booting with the "irqpoll" option)
> [  276.835609] Pid: 1710, comm: Xorg Not tainted 2.6.31.4-intel-menlow #14
> [  276.835616] Call Trace:
> [  276.835636]  [<c105ca3e>] __report_bad_irq+0x2e/0x6f
> [  276.835646]  [<c105cb74>] note_interrupt+0xf5/0x14d
> [  276.835656]  [<c105d0a4>] handle_fasteoi_irq+0x7d/0x9b
> [  276.835668]  [<c10048c1>] handle_irq+0x3b/0x46
> [  276.835677]  [<c1004103>] do_IRQ+0x41/0x95
> [  276.835687]  [<c1003189>] common_interrupt+0x29/0x30
> [  276.835693] handlers:
> [  276.835698] [<f89a3d03>] (ath_isr+0x0/0x12f [ath9k])
> [  276.835739] Disabling IRQ #18

  Luis
