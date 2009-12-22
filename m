Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZLVPuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZLVPuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZLVPuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:50:10 -0500
Received: from mail.atheros.com ([12.36.123.2]:37562 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbZLVPuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:50:08 -0500
Date: Tue, 22 Dec 2009 07:50:05 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sujith Manoharan <Sujith.Manoharan@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner
 case
Message-ID: <20091222155005.GA4385@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
 <19248.19829.293087.367661@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <19248.19829.293087.367661@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 08:39:17PM -0800, Sujith Manoharan wrote:
> Luis Rodriguez wrote:
> > That log can be found here:
> >
> > http://bombadil.infradead.org/~mcgrof/logs/2.6.31-with-2.6.32-wireless/irq-disabled.txt
> 
> Thanks for the log.
> It's a bug in ath9k, related to PowerSave.
> 
> Can you test this patch ?
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 3f5b887..419c382 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -2504,6 +2504,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
>                 return; /* another wiphy still in use */
>         }
> 
> +       /* Ensure HW is awake when we try to shut it down. */
> +       ath9k_ps_wakeup(sc);
> +
>         if (ah->btcoex_hw.enabled) {
>                 ath9k_hw_btcoex_disable(ah);
>                 if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
> @@ -2524,8 +2527,10 @@ static void ath9k_stop(struct ieee80211_hw *hw)
>         /* disable HAL and put h/w to sleep */
>         ath9k_hw_disable(ah);
>         ath9k_hw_configpcipowersave(ah, 1, 1);
> -       ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
> +       ath9k_ps_restore(sc);
> 
> +       /* Finally, put the chip in FULL SLEEP mode */
> +       ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
>         sc->sc_flags |= SC_OP_INVALID;
> 
>         mutex_unlock(&sc->mutex);


Thanks for the patch, doesn't cure it though. Below is the log
with debug=0xa00 (CONFIG | PS), you can see some successes prior to
the failure.

[   89.314013] PM: Syncing filesystems ... done.
[   89.316956] PM: Preparing system for mem sleep
[   89.476090] Freezing user space processes ... (elapsed 0.00 seconds) done.
[   89.477287] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[   89.477402] PM: Entering mem sleep
[   89.477423] Suspending console(s) (use no_console_suspend to debug)
[   89.481334] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[   89.481350] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[   89.481385] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[   89.481403] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 6
[   89.481412] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 6
[   89.481435] ath9k: Detach Interface
[   89.483686] ath9k: Driver halt
[   89.506171] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   89.506558] sd 0:0:0:0: [sda] Stopping disk
[   90.428257] ath9k 0000:01:00.0: PCI INT A disabled
[   90.452700] ACPI handle has no context!
[   90.452714] atl1c 0000:02:00.0: PME# disabled
[   90.452727] atl1c 0000:02:00.0: PCI INT A disabled
[   90.452737] ACPI handle has no context!
[   90.496318] ata6: port disabled. ignoring.
[   90.496393] ata_piix 0000:00:1f.1: PCI INT A disabled
[   90.496411] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[   90.496423] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[   90.496435] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[   90.496445] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[   90.496456] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[   90.513762] i915 0000:00:02.0: PCI INT A disabled
[   90.524494] ehci_hcd 0000:00:1d.7: PME# disabled
[   90.535424] ACPI: Preparing to enter system sleep state S3
[   90.623765] Disabling non-boot CPUs ...
[   90.626106] CPU 1 is now offline
[   90.626112] SMP alternatives: switching to UP code
[   90.630152] CPU1 is down
[   90.630175] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[   90.630175] Back to C!
[   90.630175] Enabling non-boot CPUs ...
[   90.630175] SMP alternatives: switching to SMP code
[   90.633737] Booting processor 1 APIC 0x1 ip 0x6000
[   90.629500] Initializing CPU#1
[   90.629500] Calibrating delay using timer specific routine.. 3331.28 BogoMIPS (lpj=1665643)
[   90.629500] CPU: L1 I cache: 32K, L1 D cache: 24K
[   90.629500] CPU: L2 cache: 512K
[   90.629500] CPU: Physical Processor ID: 0
[   90.629500] CPU: Processor Core ID: 0
[   90.629500] mce: CPU supports 5 MCE banks
[   90.629500] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[   90.704950] CPU1: Intel(R) Atom(TM) CPU N280   @ 1.66GHz stepping 02
[   90.705036] Switched to high resolution mode on CPU 1
[   90.709037] CPU1 is up
[   90.709043] ACPI: Waking up from system sleep state S3
[   91.068418] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[   91.068437] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100504)
[   91.068516] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[   91.068584] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[   91.068601] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[   91.068668] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[   91.068707] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[   91.068746] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[   91.068784] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[   91.068832] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[   91.068854] ehci_hcd 0000:00:1d.7: PME# disabled
[   91.069022] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[   91.427502] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   91.427511] i915 0000:00:02.0: setting latency timer to 64
[   91.489057] [drm] LVDS-8: set mode 1024x600 e
[   91.509264] pci 0000:00:02.1: PME# disabled
[   91.509276] pci 0000:00:1b.0: PME# disabled
[   91.509306] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   91.509317] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   91.509345] usb usb2: root hub lost power or was reset
[   91.509371] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[   91.509381] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   91.509407] usb usb3: root hub lost power or was reset
[   91.509431] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[   91.509441] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   91.509467] usb usb4: root hub lost power or was reset
[   91.509491] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 20 (level, low) -> IRQ 20
[   91.509500] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   91.509527] usb usb5: root hub lost power or was reset
[   91.509564] ehci_hcd 0000:00:1d.7: PME# disabled
[   91.509572] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   91.509582] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   91.509616] pci 0000:00:1e.0: setting latency timer to 64
[   91.509632] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   91.509640] ata_piix 0000:00:1f.1: setting latency timer to 64
[   91.511298] ata6: port disabled. ignoring.
[   91.511330] ahci 0000:00:1f.2: setting latency timer to 64
[   91.511406] atl1c 0000:02:00.0: PME# disabled
[   91.511417] atl1c 0000:02:00.0: PME# disabled
[   91.574708] atl1c 0000:02:00.0: irq 28 for MSI/MSI-X
[   91.574790] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   91.817141] ata3: SATA link down (SStatus 0 SControl 300)
[   91.970144] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   91.972350] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[   91.975267] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[   91.975693] ata1.00: configured for UDMA/133
[   91.986140] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xf t4
[   91.986149] ata1: irq_stat 0x00000040, connection status changed
[   91.986168] ata1: hard resetting link
[   92.047230] sd 0:0:0:0: [sda] Starting disk
[   92.709167] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   92.798901] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[   92.801624] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[   92.802079] ata1.00: configured for UDMA/133
[   92.802092] ata1: EH complete
[   92.960162] usb 1-8: reset high speed USB device using ehci_hcd and address 3
[   93.241146] usb 5-1: reset full speed USB device using uhci_hcd and address 2
[   93.956141] ath9k: Starting driver with initial channel: 2437 MHz
[   93.970209] ath9k: Attach a VIF of type: 2
[   93.970243] ath9k: Set channel: 2437 MHz
[   93.970248] ath9k: tx chmask: 1, rx chmask: 1
[   93.970372] ath9k: (2437 MHz) -> (2437 MHz), chanwidth: 1
[   93.979039] ath9k: Set HW RX filter: 0x607
[   93.979046] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[   93.979052] ath9k: BSS Changed PREAMBLE 1
[   93.979056] ath9k: BSS Changed CTS PROT 0
[   93.979060] ath9k: BSS Changed ASSOC 1
[   93.979063] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[   93.981491] PM: Finishing wakeup.
[   93.981496] Restarting tasks ... done.
[   93.989532] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
[   93.989575] activated addBA response timer on tid 0
[   93.991477] Rx A-MPDU request on tid 0 result 0
[   93.992306] switched off addBA timer for tid 0 
[   93.992314] Aggregation is on for tid 0 
[   94.194880] ath9k: Reconfigure Beacon timers based on timestamp from the AP
[  104.540982] PM: Syncing filesystems ... done.
[  104.767013] PM: Preparing system for mem sleep
[  104.913718] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  104.915436] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  104.915545] PM: Entering mem sleep
[  104.915568] Suspending console(s) (use no_console_suspend to debug)
[  104.920338] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  104.920354] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[  104.920390] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  104.920477] ath9k: Detach Interface
[  104.922778] ath9k: Driver halt
[  104.946162] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  104.946594] sd 0:0:0:0: [sda] Stopping disk
[  105.863851] ath9k 0000:01:00.0: PCI INT A disabled
[  105.887700] ACPI handle has no context!
[  105.887714] atl1c 0000:02:00.0: PME# disabled
[  105.887724] ACPI handle has no context!
[  105.931316] ata6: port disabled. ignoring.
[  105.931391] ata_piix 0000:00:1f.1: PCI INT A disabled
[  105.931409] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  105.931422] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  105.931433] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  105.931444] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  105.931454] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  105.947618] i915 0000:00:02.0: PCI INT A disabled
[  105.958499] ehci_hcd 0000:00:1d.7: PME# disabled
[  105.969427] ACPI: Preparing to enter system sleep state S3
[  106.057766] Disabling non-boot CPUs ...
[  106.060109] CPU 1 is now offline
[  106.060114] SMP alternatives: switching to UP code
[  106.064092] CPU1 is down
[  106.064115] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[  106.064115] Back to C!
[  106.064115] Enabling non-boot CPUs ...
[  106.064115] SMP alternatives: switching to SMP code
[  106.067695] Booting processor 1 APIC 0x1 ip 0x6000
[  106.063466] Initializing CPU#1
[  106.063466] Calibrating delay using timer specific routine.. 3331.28 BogoMIPS (lpj=1665640)
[  106.063466] CPU: L1 I cache: 32K, L1 D cache: 24K
[  106.063466] CPU: L2 cache: 512K
[  106.063466] CPU: Physical Processor ID: 0
[  106.063466] CPU: Processor Core ID: 0
[  106.063466] mce: CPU supports 5 MCE banks
[  106.063466] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[  106.138940] CPU1: Intel(R) Atom(TM) CPU N280   @ 1.66GHz stepping 02
[  106.139028] Switched to high resolution mode on CPU 1
[  106.143036] CPU1 is up
[  106.143042] ACPI: Waking up from system sleep state S3
[  106.503519] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100504)
[  106.503607] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  106.503691] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[  106.503765] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  106.503809] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  106.503852] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  106.503895] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  106.503948] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[  106.503973] ehci_hcd 0000:00:1d.7: PME# disabled
[  106.504158] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  106.866491] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  106.866500] i915 0000:00:02.0: setting latency timer to 64
[  106.928044] [drm] LVDS-8: set mode 1024x600 e
[  106.948245] pci 0000:00:02.1: PME# disabled
[  106.948259] pci 0000:00:1b.0: PME# disabled
[  106.948291] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  106.948303] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  106.948331] usb usb2: root hub lost power or was reset
[  106.948358] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[  106.948367] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  106.948394] usb usb3: root hub lost power or was reset
[  106.948418] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[  106.948428] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  106.948454] usb usb4: root hub lost power or was reset
[  106.948478] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 20 (level, low) -> IRQ 20
[  106.948487] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  106.948514] usb usb5: root hub lost power or was reset
[  106.948552] ehci_hcd 0000:00:1d.7: PME# disabled
[  106.948561] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  106.948570] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  106.948604] pci 0000:00:1e.0: setting latency timer to 64
[  106.948620] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  106.948628] ata_piix 0000:00:1f.1: setting latency timer to 64
[  106.950291] ata6: port disabled. ignoring.
[  106.950322] ahci 0000:00:1f.2: setting latency timer to 64
[  106.950400] atl1c 0000:02:00.0: PME# disabled
[  106.950410] atl1c 0000:02:00.0: PME# disabled
[  107.013705] atl1c 0000:02:00.0: irq 28 for MSI/MSI-X
[  107.013790] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  107.256171] ata3: SATA link down (SStatus 0 SControl 300)
[  107.307148] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  107.309315] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  107.312183] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  107.312628] ata1.00: configured for UDMA/133
[  107.323167] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xf t4
[  107.323176] ata1: irq_stat 0x00000040, connection status changed
[  107.323195] ata1: hard resetting link
[  107.485042] sd 0:0:0:0: [sda] Starting disk
[  108.046178] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  108.118587] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  108.121397] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  108.121810] ata1.00: configured for UDMA/133
[  108.121822] ata1: EH complete
[  108.280150] usb 1-8: reset high speed USB device using ehci_hcd and address 3
[  108.560140] usb 5-1: reset full speed USB device using uhci_hcd and address 2
[  109.275204] ath9k: Starting driver with initial channel: 2437 MHz
[  109.289246] ath9k: Attach a VIF of type: 2
[  109.289299] ath9k: Set channel: 2437 MHz
[  109.289305] ath9k: tx chmask: 1, rx chmask: 1
[  109.289406] ath9k: (2437 MHz) -> (2437 MHz), chanwidth: 1
[  109.298089] ath9k: Set HW RX filter: 0x607
[  109.298096] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  109.298102] ath9k: BSS Changed PREAMBLE 1
[  109.298106] ath9k: BSS Changed CTS PROT 0
[  109.298109] ath9k: BSS Changed ASSOC 1
[  109.298113] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  109.300513] PM: Finishing wakeup.
[  109.300518] Restarting tasks ... done.
[  109.330297] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
[  109.330341] activated addBA response timer on tid 0
[  109.335364] Rx A-MPDU request on tid 0 result 0
[  109.336199] switched off addBA timer for tid 0 
[  109.336207] Aggregation is on for tid 0 
[  109.532250] ath9k: Reconfigure Beacon timers based on timestamp from the AP
[  115.600983] PM: Syncing filesystems ... done.
[  115.603769] PM: Preparing system for mem sleep
[  115.747184] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  115.748611] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  115.748728] PM: Entering mem sleep
[  115.748750] Suspending console(s) (use no_console_suspend to debug)
[  115.754153] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  115.754174] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[  115.754216] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  115.754245] ath9k: Detach Interface
[  115.756642] ath9k: Driver halt
[  115.783163] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  115.783598] sd 0:0:0:0: [sda] Stopping disk
[  116.710137] ath9k 0000:01:00.0: PCI INT A disabled
[  116.734702] ACPI handle has no context!
[  116.734716] atl1c 0000:02:00.0: PME# disabled
[  116.734726] ACPI handle has no context!
[  116.778319] ata6: port disabled. ignoring.
[  116.778395] ata_piix 0000:00:1f.1: PCI INT A disabled
[  116.778413] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  116.778425] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  116.778436] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  116.778447] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  116.778458] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  116.794206] i915 0000:00:02.0: PCI INT A disabled
[  116.805495] ehci_hcd 0000:00:1d.7: PME# disabled
[  116.816424] ACPI: Preparing to enter system sleep state S3
[  116.910764] Disabling non-boot CPUs ...
[  116.913107] CPU 1 is now offline
[  116.913113] SMP alternatives: switching to UP code
[  116.917119] CPU1 is down
[  116.917142] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[  116.917142] Back to C!
[  116.917142] Enabling non-boot CPUs ...
[  116.917142] SMP alternatives: switching to SMP code
[  116.920718] Booting processor 1 APIC 0x1 ip 0x6000
[  116.916492] Initializing CPU#1
[  116.916492] Calibrating delay using timer specific routine.. 3331.29 BogoMIPS (lpj=1665646)
[  116.916492] CPU: L1 I cache: 32K, L1 D cache: 24K
[  116.916492] CPU: L2 cache: 512K
[  116.916492] CPU: Physical Processor ID: 0
[  116.916492] CPU: Processor Core ID: 0
[  116.916492] mce: CPU supports 5 MCE banks
[  116.916492] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[  116.991936] CPU1: Intel(R) Atom(TM) CPU N280   @ 1.66GHz stepping 02
[  116.992269] Switched to high resolution mode on CPU 1
[  116.996025] CPU1 is up
[  116.996032] ACPI: Waking up from system sleep state S3
[  117.358521] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100504)
[  117.358609] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  117.358694] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[  117.358767] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  117.358812] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  117.358855] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  117.358898] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  117.358951] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[  117.358976] ehci_hcd 0000:00:1d.7: PME# disabled
[  117.359162] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  117.721142] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  117.721150] i915 0000:00:02.0: setting latency timer to 64
[  117.782697] [drm] LVDS-8: set mode 1024x600 e
[  117.802897] pci 0000:00:02.1: PME# disabled
[  117.802907] pci 0000:00:1b.0: PME# disabled
[  117.802934] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  117.802944] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  117.802973] usb usb2: root hub lost power or was reset
[  117.802998] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[  117.803021] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  117.803048] usb usb3: root hub lost power or was reset
[  117.803073] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[  117.803083] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  117.803109] usb usb4: root hub lost power or was reset
[  117.803133] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 20 (level, low) -> IRQ 20
[  117.803143] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  117.803169] usb usb5: root hub lost power or was reset
[  117.803207] ehci_hcd 0000:00:1d.7: PME# disabled
[  117.803215] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  117.803224] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  117.803264] pci 0000:00:1e.0: setting latency timer to 64
[  117.803285] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  117.803296] ata_piix 0000:00:1f.1: setting latency timer to 64
[  117.804929] ata6: port disabled. ignoring.
[  117.804956] ahci 0000:00:1f.2: setting latency timer to 64
[  117.805035] atl1c 0000:02:00.0: PME# disabled
[  117.805043] atl1c 0000:02:00.0: PME# disabled
[  117.868714] atl1c 0000:02:00.0: irq 28 for MSI/MSI-X
[  117.868799] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  118.110161] ata3: SATA link down (SStatus 0 SControl 300)
[  118.161152] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  118.165385] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  118.168239] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  118.168643] ata1.00: configured for UDMA/133
[  118.179174] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xf t4
[  118.179183] ata1: irq_stat 0x00400040, connection status changed
[  118.179202] ata1: hard resetting link
[  118.340197] sd 0:0:0:0: [sda] Starting disk
[  118.902173] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  118.971400] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  118.974183] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  118.974608] ata1.00: configured for UDMA/133
[  118.974621] ata1: EH complete
[  119.133147] usb 1-8: reset high speed USB device using ehci_hcd and address 3
[  119.413139] usb 5-1: reset full speed USB device using uhci_hcd and address 2
[  120.128210] ath9k: Starting driver with initial channel: 2437 MHz
[  120.277768] ath9k: timeout (100000 us) on reg 0x7000: 0xdeadbeef & 0x00000003 != 0x00000000
[  120.277804] ath9k: Attach a VIF of type: 2
[  120.277853] ath9k: Set channel: 2437 MHz
[  120.277860] ath9k: tx chmask: 1, rx chmask: 1
[  120.277875] ath9k: Set HW RX filter: 0x2707
[  120.277883] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  120.277892] ath9k: BSS Changed PREAMBLE 1
[  120.277897] ath9k: BSS Changed CTS PROT 0
[  120.277902] ath9k: BSS Changed ASSOC 1
[  120.277906] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  120.280886] PM: Finishing wakeup.
[  120.280892] Restarting tasks ... done.
[  121.233472] irq 18: nobody cared (try booting with the "irqpoll" option)
[  121.233488] Pid: 2336, comm: gnome-terminal Not tainted 2.6.31.4-intel-menlow #13
[  121.233495] Call Trace:
[  121.233513]  [<c105ca3e>] __report_bad_irq+0x2e/0x6f
[  121.233525]  [<c105cb74>] note_interrupt+0xf5/0x14d
[  121.233535]  [<c105d0a4>] handle_fasteoi_irq+0x7d/0x9b
[  121.233546]  [<c10048c1>] handle_irq+0x3b/0x46
[  121.233555]  [<c1004103>] do_IRQ+0x41/0x95
[  121.233564]  [<c1003189>] common_interrupt+0x29/0x30
[  121.233571] handlers:
[  121.233576] [<f89bad03>] (ath_isr+0x0/0x12f [ath9k])
[  121.233616] Disabling IRQ #18
[  134.922394] atl1c 0000:02:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>

