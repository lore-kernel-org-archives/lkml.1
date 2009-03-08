Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbZCHUv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbZCHUv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 16:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZCHUvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 16:51:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34741 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbZCHUvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 16:51:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [RFC][PATCH][0/8] PM: Rework suspend-resume ordering to avoid problems with shared interrupts
Date: Sun, 8 Mar 2009 21:50:54 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-pm@lists.linux-foundation.org
References: <200902221837.49396.rjw@sisk.pl> <200903071119.16651.rjw@sisk.pl> <200903082028.03720.elendil@planet.nl>
In-Reply-To: <200903082028.03720.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903082150.55377.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 March 2009, Frans Pop wrote:
> (Most CCs dropped.)
> 
> Hi Rafael,

Hi Frans,

> Rafael J. Wysocki wrote:
> > The following patches modifiy the way in which we handle disabling
> > interrupts during suspend and enabling them during resume.  They also
> > change the ordering of the core suspend and hibernation code to take
> > advantage of the new approach to the interrupts and modify the PCI PM
> > core to avoid a few problems.
> 
> I've given this series a try on my HP 2510p. I've seen no regressions
> with suspend to RAM.

Great, thanks for testing!

> Below is a diff between suspend/resume dmesg from before (based on rc5)
> and after (rc7 + series) the patch, with some comments.
> Nothing looks really wrong, but there are some surprising changes.
> 
> Essentially JFYI though.
> 
> Cheers,
> FJP
> 
>     PM: Syncing filesystems ... done.
>     Freezing user space processes ... (elapsed 0.00 seconds) done.
>     Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
>     Suspending console(s) (use no_console_suspend to debug)
>     sd 0:0:0:0: [sda] Synchronizing SCSI cache
>     sd 0:0:0:0: [sda] Stopping disk
>     ACPI handle has no context!
>     ACPI handle has no context!
>     sdhci-pci 0000:02:06.2: PME# disabled
>     sdhci-pci 0000:02:06.2: PCI INT C disabled
>     ACPI handle has no context!
>     ACPI handle has no context!
> # Bogus: result of using wireless instead of wired networking.
>    +iwlagn 0000:10:00.0: PCI INT A disabled
>     ata2: port disabled. ignoring.
>     ata_piix 0000:00:1f.1: PCI INT A disabled
>     ehci_hcd 0000:00:1d.7: PCI INT A disabled
>     ehci_hcd 0000:00:1d.7: PME# disabled
>     uhci_hcd 0000:00:1d.2: PCI INT C disabled
>     uhci_hcd 0000:00:1d.1: PCI INT B disabled
>     uhci_hcd 0000:00:1d.0: PCI INT A disabled
>     HDA Intel 0000:00:1b.0: PCI INT A disabled
>     HDA Intel 0000:00:1b.0: power state changed by ACPI to D3
>     ehci_hcd 0000:00:1a.7: PCI INT C disabled
>     ehci_hcd 0000:00:1a.7: PME# disabled
>     uhci_hcd 0000:00:1a.1: PCI INT B disabled
>     uhci_hcd 0000:00:1a.0: PCI INT A disabled
>     e1000e 0000:00:19.0: PME# enabled
>     e1000e 0000:00:19.0: wake-up capability enabled by ACPI
>     e1000e 0000:00:19.0: PME# enabled
>     e1000e 0000:00:19.0: wake-up capability enabled by ACPI
>     e1000e 0000:00:19.0: PCI INT A disabled
>     ACPI handle has no context!
> # This has moved up a bit. Looks more logical.

This is a result of patch 2/8, intentional.

>    +ricoh-mmc: Suspending.
>    +ricoh-mmc: Controller is now re-enabled.
>     ACPI: Preparing to enter system sleep state S3
>     Disabling non-boot CPUs ...
>     CPU 1 is now offline
>     SMP alternatives: switching to UP code
>     CPU0 attaching NULL sched-domain.
>     CPU1 attaching NULL sched-domain.
>     CPU0 attaching NULL sched-domain.
>     CPU1 is down
>    -ricoh-mmc: Suspending.
>    -ricoh-mmc: Controller is now re-enabled.
>     Extended CMOS year: 2000
> 
>     Back to C!
>    +CPU0: Thermal monitoring enabled (TM2)
>     Extended CMOS year: 2000
> # This whole block has moved up before early config space restores.
> # No changes in the block itself.

Yes this also is an intentional result of patch 2/8.

>    +Enabling non-boot CPUs ...
>    +SMP alternatives: switching to SMP code
>    +Booting processor 1 APIC 0x1 ip 0x6000
>    +Initializing CPU#1
>    +Calibrating delay using timer specific routine.. 2660.04 BogoMIPS (lpj=5320097)
>    +CPU: L1 I cache: 32K, L1 D cache: 32K
>    +CPU: L2 cache: 2048K
>    +[ds] using Core 2/Atom configuration
>    +CPU: Physical Processor ID: 0
>    +CPU: Processor Core ID: 1
>    +CPU1: Thermal monitoring enabled (TM2)
>    +CPU1: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
>    +CPU0 attaching NULL sched-domain.
>    +Switched to high resolution mode on CPU 1
>    +CPU0 attaching sched-domain:
>    + domain 0: span 0-1 level MC
>    +  groups: 0 1
>    +CPU1 attaching sched-domain:
>    + domain 0: span 0-1 level MC
>    +  groups: 1 0
>    +CPU1 is up
>    +ACPI: Waking up from system sleep state S3
>     pci 0000:00:02.0: restoring config space at offset 0x8 (was 0x1, writing 0x2001)
> # These don't need restoring anymore?

I think they generally do, but the restored values may (and often are)
identical to the current ones.

>    -pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x4, writing 0xe0500004)
>    -pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
>    -pci 0000:00:03.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
>    -pci 0000:00:03.0: restoring config space at offset 0x4 (was 0xfed12004, writing 0xe0600004)
>    -pci 0000:00:03.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
>    -pci 0000:00:03.2: restoring config space at offset 0x8 (was 0x1, writing 0x2031)
>    -pci 0000:00:03.2: restoring config space at offset 0x7 (was 0x1, writing 0x2021)
>    -pci 0000:00:03.2: restoring config space at offset 0x6 (was 0x1, writing 0x2019)
>    -pci 0000:00:03.2: restoring config space at offset 0x5 (was 0x1, writing 0x2011)
>    -pci 0000:00:03.2: restoring config space at offset 0x4 (was 0x1, writing 0x2009)
>    -pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00001)
>     serial 0000:00:03.3: restoring config space at offset 0xf (was 0x200, writing 0x20a)
>     serial 0000:00:03.3: restoring config space at offset 0x5 (was 0x0, writing 0xe0601000)
>     serial 0000:00:03.3: restoring config space at offset 0x4 (was 0x1, writing 0x2041)
>     serial 0000:00:03.3: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00007)
>     e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
>     e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0x2061)
>     e1000e 0000:00:19.0: restoring config space at offset 0x5 (was 0x0, writing 0xe0640000)
>     e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
> # These have moved down to late resume.

That's a bit strange.  It looks like the registers changed after we had
restored them during "early" resume.  So either we hadn't actually restored
them (it would be interesting to find out why), or they really changed (again,
it would be interesting to see why).

>    -uhci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
>    -uhci_hcd 0000:00:1a.0: restoring config space at offset 0x8 (was 0x1, writing 0x2081)
>    -uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
>    -uhci_hcd 0000:00:1a.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
>    -uhci_hcd 0000:00:1a.1: restoring config space at offset 0x8 (was 0x1, writing 0x20a1)
>    -uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
>     ehci_hcd 0000:00:1a.7: restoring config space at offset 0xf (was 0x300, writing 0x30b)
>     ehci_hcd 0000:00:1a.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0641000)
>     ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
>     HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
>     HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
>     HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
>     pcieport-driver 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x4010a)
>     pcieport-driver 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
>     pcieport-driver 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
>     pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0x0, writing 0x200000f0)
>     pcieport-driver 0000:00:1c.0: restoring config space at offset 0x6 (was 0x0, writing 0x80800)
>     pcieport-driver 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
>     pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
>     pcieport-driver 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x4020a)
>     pcieport-driver 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
>     pcieport-driver 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xe000e000)
>     pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0xf0)
>     pcieport-driver 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
>     pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
> # These have moved down to late resume.

The last comment applies here too.

>    -uhci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
>    -uhci_hcd 0000:00:1d.0: restoring config space at offset 0x8 (was 0x1, writing 0x20c1)
>    -uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
>    -uhci_hcd 0000:00:1d.1: restoring config space at offset 0xf (was 0x200, writing 0x20b)
>    -uhci_hcd 0000:00:1d.1: restoring config space at offset 0x8 (was 0x1, writing 0x20e1)
>    -uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
>    -uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
>    -uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
>    -uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
>     ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10a)
>     ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0648000)
>     ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
> # These have disappeared.

Good.

>    -pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x83f18001)
>    -pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xe030e010)
>    -pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x228000f0, writing 0x22803030)
>    -pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100107)
> # First two moved to late resume.

Again, a bit strange.

> # The third already happened during late resume (duplicated).
>    -ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x10a)
>    -ata_piix 0000:00:1f.1: restoring config space at offset 0x8 (was 0xc01, writing 0x2121)
>    -ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
>     iwlagn 0000:10:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
>     iwlagn 0000:10:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xe0000004)
>     iwlagn 0000:10:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
>     iwlagn 0000:10:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0xf (was 0x3000100, writing 0x580010b)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0xe (was 0x0, writing 0x34fc)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0xd (was 0x0, writing 0x3400)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0xc (was 0x0, writing 0x30fc)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0xb (was 0x0, writing 0x3000)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0xa (was 0x0, writing 0x87fff000)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0x9 (was 0x0, writing 0x84000000)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0x8 (was 0x0, writing 0x83fff000)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0x7 (was 0x0, writing 0x80000000)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0x6 (was 0x0, writing 0xb0060302)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0x4 (was 0x0, writing 0xe0100000)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0x3 (was 0x820000, writing 0x82a800)
>     yenta_cardbus 0000:02:06.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
>     ohci1394 0000:02:06.1: restoring config space at offset 0xf (was 0x4020200, writing 0x4020205)
>     ohci1394 0000:02:06.1: restoring config space at offset 0x4 (was 0x0, writing 0xe0101000)
>     ohci1394 0000:02:06.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
>     ohci1394 0000:02:06.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
>     sdhci-pci 0000:02:06.2: restoring config space at offset 0xf (was 0x300, writing 0x30a)
>     sdhci-pci 0000:02:06.2: restoring config space at offset 0x4 (was 0x0, writing 0xe0102000)
>     sdhci-pci 0000:02:06.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
>     sdhci-pci 0000:02:06.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
> # Some changes; a lot just got dropped.
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0xf (was 0x300, writing 0xffffffff)
>    +ricoh-mmc 0000:02:06.3: restoring config space at offset 0xf (was 0x300, writing 0x30a)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0xe (was 0x0, writing 0xffffffff)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0xd (was 0x80, writing 0xffffffff)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0xc (was 0x0, writing 0xffffffff)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0xb (was 0x30c9103c, writing 0xffffffff)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0xa (was 0x0, writing 0xffffffff)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0x9 (was 0x0, writing 0xffffffff)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0x8 (was 0x0, writing 0xffffffff)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0x7 (was 0x0, writing 0xffffffff)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0x6 (was 0x0, writing 0xffffffff)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0x5 (was 0x0, writing 0xffffffff)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0x4 (was 0x0, writing 0xffffffff)
>    +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x4 (was 0x0, writing 0xe0103000)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0x3 (was 0x800000, writing 0xffffffff)
>    +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0x2 (was 0x8800011, writing 0xffffffff)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0x1 (was 0x2100000, writing 0xffffffff)
>    +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
>    -ricoh-mmc 0000:02:06.3: restoring config space at offset 0x0 (was 0x8431180, writing 0xffffffff)
>     ricoh-mmc: Resuming.
>     ricoh-mmc: Controller is now disabled.
>    -Enabling non-boot CPUs ...
>    -SMP alternatives: switching to SMP code
>    -Booting processor 1 APIC 0x1 ip 0x6000
>    -Initializing CPU#1
>    -Calibrating delay using timer specific routine.. 2660.07 BogoMIPS (lpj=5320158)
>    -CPU: L1 I cache: 32K, L1 D cache: 32K
>    -CPU: L2 cache: 2048K
>    -[ds] using Core 2/Atom configuration
>    -CPU: Physical Processor ID: 0
>    -CPU: Processor Core ID: 1
>    -CPU1: Thermal monitoring enabled (TM2)
>    -x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
>    -CPU1: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
>    -CPU0 attaching NULL sched-domain.
>    -Switched to high resolution mode on CPU 1
>    -CPU0 attaching sched-domain:
>    - domain 0: span 0-1 level MC
>    -  groups: 0 1
>    -CPU1 attaching sched-domain:
>    - domain 0: span 0-1 level MC
>    -  groups: 1 0
>    -CPU1 is up
>    -ACPI: Waking up from system sleep state S3
>     ACPI: EC: non-query interrupt received, switching to interrupt mode
>     pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900403, writing 0x900003)
>     pci 0000:00:02.0: PME# disabled
>     pci 0000:00:02.1: PME# disabled
>     pci 0000:00:03.0: PME# disabled
>     pci 0000:00:03.2: PME# disabled
>     e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
>     e1000e 0000:00:19.0: setting latency timer to 64
>     e1000e 0000:00:19.0: wake-up capability disabled by ACPI
>     e1000e 0000:00:19.0: PME# disabled
>     e1000e 0000:00:19.0: wake-up capability disabled by ACPI
>     e1000e 0000:00:19.0: PME# disabled
>     e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
>    +uhci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
>    +uhci_hcd 0000:00:1a.0: restoring config space at offset 0x8 (was 0x1, writing 0x2081)
>    +uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
>     uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>     uhci_hcd 0000:00:1a.0: setting latency timer to 64
>     usb usb1: root hub lost power or was reset
>    +uhci_hcd 0000:00:1a.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
>    +uhci_hcd 0000:00:1a.1: restoring config space at offset 0x8 (was 0x1, writing 0x20a1)
>    +uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
>     uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
>     uhci_hcd 0000:00:1a.1: setting latency timer to 64
>     usb usb3: root hub lost power or was reset
>     ehci_hcd 0000:00:1a.7: PME# disabled
>     ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>     ehci_hcd 0000:00:1a.7: setting latency timer to 64
>     ehci_hcd 0000:00:1a.7: PME# disabled
> # Called twice now?
>     HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
>    +HDA Intel 0000:00:1b.0: power state changed by ACPI to D0

Yeah, it's not nice.  The problem is that pci_set_power_state() doesn't
check if the power state is already correct before calling the platform to
change it.  The platform should cope with that, but it shouldn't be called
for the second time at all.

In fact I have a patch to change this behavior, but I consider it as a separate
thing.

>     HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>     HDA Intel 0000:00:1b.0: setting latency timer to 64
>     pcieport-driver 0000:00:1c.0: setting latency timer to 64
>     pcieport-driver 0000:00:1c.1: setting latency timer to 64
>    +uhci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
>    +uhci_hcd 0000:00:1d.0: restoring config space at offset 0x8 (was 0x1, writing 0x20c1)
>    +uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
>     uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
>     uhci_hcd 0000:00:1d.0: setting latency timer to 64
>     usb usb5: root hub lost power or was reset
>    +uhci_hcd 0000:00:1d.1: restoring config space at offset 0xf (was 0x200, writing 0x20b)
>    +uhci_hcd 0000:00:1d.1: restoring config space at offset 0x8 (was 0x1, writing 0x20e1)
>    +uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
>     uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
>     uhci_hcd 0000:00:1d.1: setting latency timer to 64
>     usb usb6: root hub lost power or was reset
>    +uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
>    +uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
>    +uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
>     uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>     uhci_hcd 0000:00:1d.2: setting latency timer to 64
>     usb usb7: root hub lost power or was reset
>     ehci_hcd 0000:00:1d.7: PME# disabled
>     ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
>     ehci_hcd 0000:00:1d.7: setting latency timer to 64
>     ehci_hcd 0000:00:1d.7: PME# disabled
>     pci 0000:00:1e.0: setting latency timer to 64
>    +ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x10a)
>    +ata_piix 0000:00:1f.1: restoring config space at offset 0x8 (was 0xc01, writing 0x2121)
>     ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
>     ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>     ata_piix 0000:00:1f.1: setting latency timer to 64
>     ata2: port disabled. ignoring.
>     ACPI Exception (exoparg2-0445): AE_AML_PACKAGE_LIMIT, Index (000000005) is beyond end of object [20081204]
>     ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C2C3] (Node ffff88007e01dea0), AE_AML_PACKAGE_LIMIT
>     ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C003.C0F6.C3F3._STM] (Node ffff88007e043de0), AE_AML_PACKAGE_LIMIT
>     ata1: ACPI set timing mode failed (status=0x300b)
> # Remaining differences are bogus: result of using wireless instead of wired networking.

OK

Thanks for the debugging work.

Best,
Rafael
