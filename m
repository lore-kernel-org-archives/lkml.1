Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYLFJUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYLFJUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 04:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYLFJU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 04:20:29 -0500
Received: from hpsmtp-eml18.KPNXCHANGE.COM ([213.75.38.118]:27974 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178AbYLFJUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 04:20:23 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch,rfc] usb: restore config before enabling device on resume
Date: Sat, 6 Dec 2008 10:20:17 +0100
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
References: <200812020320.31876.rjw@sisk.pl> <200812041900.27514.elendil@planet.nl> <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TPkOJ/1t1/3obXh"
Message-Id: <200812061020.19546.elendil@planet.nl>
X-OriginalArrivalTime: 06 Dec 2008 09:20:20.0098 (UTC) FILETIME=[DC0D9620:01C95783]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_TPkOJ/1t1/3obXh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 04 December 2008, Linus Torvalds wrote:
> Greg, Jesse, can you think about and look at the USB PCI resume
> ordering?
[...]
> In many ways the bigger worry is actually in the totally unrelated USB
> UHCI and EHCI drivers that resume _before_ the bridge does:
>
> 	uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
> 	uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> 	uhci_hcd 0000:00:1d.2: setting latency timer to 64
> 	uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
>	uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
>	usb usb7: root hub lost power or was reset
> 	ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
> 	ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> 	ehci_hcd 0000:00:1d.7: setting latency timer to 64
> 	ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10a)
>	ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0648000)
>
> and the worry I have here is that we actually enable the device
> _before_ we've restored the BAR information. That sounds very iffy. It
> sounds doubly iffy in the 'resume from hibernate' case, where we are
> going to have an already-set-up PCI bus and the config space values are
> going to all be live as we reprogram them.
>
> That "restoring config space at offset 0x8" thing is where we restore
> the BAR (dword 0x8 = offset 0x20 = PCI_BASE_ADDRESS_4), and we're
> changing it from 0x1 to 0x2101, with the IO BAR enabled. In this case,
> the old value meant that the BAR started out disabled, but hibernate
> would have been different.
>
> So I'd _much_ rather have seen the sequence have the BAR restore
> sequence be something like
>
> 	uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
>	uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
>	uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
> 	uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> 	uhci_hcd 0000:00:1d.2: setting latency timer to 64
>
> instead. Possibly even with an explicit disable of the
> memory/IO/busmaster bits before the whole sequence.

I've taken a very naive look at this, basically by comparing what usb
(usb/core/hcd-pci.c) is doing compared to other drivers.

I used the following command to get an overview:
$ git grep -E -n -C5 "pci_(enable_device|set_master|restore_state|power_state.*D0)"
(The line numbers give some indication whether work is split over functions.)

Most drivers seem to do some variation of the following, which looks
logical and is in line with Documentation/power/pci.txt:
pci_set_power_state(dev, PCI_D0);
pci_restore_state(dev);
pci_enable_device(dev);
pci_set_master(dev);

But quite a lot of drivers (including usb and e.g. ide/setup-pci.c) do
something like:
pci_enable_device(dev);
pci_set_master(dev);
pci_restore_state(dev);

Maybe the whole tree should get a review for this?

Anyway, I gave the patch below a try on both my notebook and desktop.
My desktop has USB keyboard and mouse and the notebook has wireless and
a fingerprint scanner on USB. Everything still worked after resume.

Diff of the resume dmesg of my motebook attached. Looks better I think?

Cheers,
FJP


--Boundary-00=_TPkOJ/1t1/3obXh
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="usb_resume.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="usb_resume.patch"

From: Frans Pop <elendil@planet.nl>

usb: restore state before enabling device on resume
    
When resuming from suspend, restore the PCI config before
enabling the device.
    
Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 5b87ae7..85bcd80 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -389,11 +389,9 @@ int usb_hcd_pci_resume(struct pci_dev *dev)
 		dev_dbg(hcd->self.controller, "PCI legacy resume\n");
 	}
 
-	/* NOTE:  the PCI API itself is asymmetric here.  We don't need to
-	 * pci_set_power_state(PCI_D0) since that's part of re-enabling;
-	 * but that won't re-enable bus mastering.  Yet pci_disable_device()
-	 * explicitly disables bus mastering...
-	 */
+	pci_set_power_state(dev, PCI_D0);
+	pci_restore_state(dev);
+
 	retval = pci_enable_device(dev);
 	if (retval < 0) {
 		dev_err(hcd->self.controller,
@@ -401,7 +399,6 @@ int usb_hcd_pci_resume(struct pci_dev *dev)
 		return retval;
 	}
 	pci_set_master(dev);
-	pci_restore_state(dev);
 
 	clear_bit(HCD_FLAG_SAW_IRQ, &hcd->flags);
 

--Boundary-00=_TPkOJ/1t1/3obXh
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="dmesg_resume.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="dmesg_resume.diff"

 Back to C!
 Extended CMOS year: 2000
 ricoh-mmc: Resuming.
 ricoh-mmc: Controller is now disabled.
 Enabling non-boot CPUs ...
 SMP alternatives: switching to SMP code
 Booting processor 1 APIC 0x1 ip 0x6000
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 2660.03 BogoMIPS (lpj=5320063)
+Calibrating delay using timer specific routine.. 2660.00 BogoMIPS (lpj=5320000)
 CPU: L1 I cache: 32K, L1 D cache: 32K
 CPU: L2 cache: 2048K
 CPU: Physical Processor ID: 0
 CPU: Processor Core ID: 1
 x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
 CPU1: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
 CPU0 attaching NULL sched-domain.
 Switched to high resolution mode on CPU 1
 CPU0 attaching sched-domain:
  domain 0: span 0-1 level MC
   groups: 0 1
   domain 1: span 0-1 level CPU
    groups: 0-1
 CPU1 attaching sched-domain:
  domain 0: span 0-1 level MC
   groups: 1 0
   domain 1: span 0-1 level CPU
    groups: 0-1
 CPU1 is up
 ACPI: Waking up from system sleep state S3
 APIC error on CPU1: 00(40)
 ACPI: EC: non-query interrupt received, switching to interrupt mode
 pci 0000:00:02.0: restoring config space at offset 0x8 (was 0x1, writing 0x2001)
 pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x4, writing 0xe0500004)
 pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
 pci 0000:00:03.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
 pci 0000:00:03.0: restoring config space at offset 0x4 (was 0xfed12004, writing 0xe0600004)
 pci 0000:00:03.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
 pci 0000:00:03.2: restoring config space at offset 0x8 (was 0x1, writing 0x2031)
 pci 0000:00:03.2: restoring config space at offset 0x7 (was 0x1, writing 0x2021)
 pci 0000:00:03.2: restoring config space at offset 0x6 (was 0x1, writing 0x2019)
 pci 0000:00:03.2: restoring config space at offset 0x5 (was 0x1, writing 0x2011)
 pci 0000:00:03.2: restoring config space at offset 0x4 (was 0x1, writing 0x2009)
 pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00001)
 serial 0000:00:03.3: restoring config space at offset 0xf (was 0x200, writing 0x20a)
 serial 0000:00:03.3: restoring config space at offset 0x5 (was 0x0, writing 0xe0601000)
 serial 0000:00:03.3: restoring config space at offset 0x4 (was 0x1, writing 0x2041)
 serial 0000:00:03.3: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00007)
 e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
 e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0x2061)
 e1000e 0000:00:19.0: restoring config space at offset 0x5 (was 0x0, writing 0xe0640000)
 e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
 e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
 e1000e 0000:00:19.0: setting latency timer to 64
 e1000e 0000:00:19.0: wake-up capability disabled by ACPI
 e1000e 0000:00:19.0: PME# disabled
 e1000e 0000:00:19.0: wake-up capability disabled by ACPI
 e1000e 0000:00:19.0: PME# disabled
 e1000e 0000:00:19.0: irq 509 for MSI/MSI-X
-uhci_hcd 0000:00:1a.0: enabling device (0000 -> 0001)
-uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
-uhci_hcd 0000:00:1a.0: setting latency timer to 64
 uhci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
 uhci_hcd 0000:00:1a.0: restoring config space at offset 0x8 (was 0x1, writing 0x2081)
+uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800005)
+uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
+uhci_hcd 0000:00:1a.0: setting latency timer to 64
 usb usb1: root hub lost power or was reset
-uhci_hcd 0000:00:1a.1: enabling device (0000 -> 0001)
-uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
-uhci_hcd 0000:00:1a.1: setting latency timer to 64
 uhci_hcd 0000:00:1a.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
 uhci_hcd 0000:00:1a.1: restoring config space at offset 0x8 (was 0x1, writing 0x20a1)
+uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800005)
+uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
+uhci_hcd 0000:00:1a.1: setting latency timer to 64
 usb usb3: root hub lost power or was reset
-ehci_hcd 0000:00:1a.7: enabling device (0000 -> 0002)
-ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
-ehci_hcd 0000:00:1a.7: setting latency timer to 64
 ehci_hcd 0000:00:1a.7: restoring config space at offset 0xf (was 0x300, writing 0x30b)
 ehci_hcd 0000:00:1a.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0641000)
+ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900006)
+ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
+ehci_hcd 0000:00:1a.7: setting latency timer to 64
 HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
 HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
 HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
 HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
 HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
 HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
 HDA Intel 0000:00:1b.0: setting latency timer to 64
 pcieport-driver 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x4010a)
 pcieport-driver 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
 pcieport-driver 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
 pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0x0, writing 0x200000f0)
 pcieport-driver 0000:00:1c.0: restoring config space at offset 0x6 (was 0x0, writing 0x80800)
 pcieport-driver 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
 pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
 pcieport-driver 0000:00:1c.0: setting latency timer to 64
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x4020a)
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xe000e000)
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0xf0)
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
 pcieport-driver 0000:00:1c.1: setting latency timer to 64
-uhci_hcd 0000:00:1d.0: enabling device (0000 -> 0001)
-uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
-uhci_hcd 0000:00:1d.0: setting latency timer to 64
 uhci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
 uhci_hcd 0000:00:1d.0: restoring config space at offset 0x8 (was 0x1, writing 0x20c1)
+uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800005)
+uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
+uhci_hcd 0000:00:1d.0: setting latency timer to 64
 usb usb5: root hub lost power or was reset
-uhci_hcd 0000:00:1d.1: enabling device (0000 -> 0001)
-uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
-uhci_hcd 0000:00:1d.1: setting latency timer to 64
 uhci_hcd 0000:00:1d.1: restoring config space at offset 0xf (was 0x200, writing 0x20b)
 uhci_hcd 0000:00:1d.1: restoring config space at offset 0x8 (was 0x1, writing 0x20e1)
+uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800005)
+uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
+uhci_hcd 0000:00:1d.1: setting latency timer to 64
 usb usb6: root hub lost power or was reset
-uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
-uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
-uhci_hcd 0000:00:1d.2: setting latency timer to 64
 uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
 uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
+uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800005)
+uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
+uhci_hcd 0000:00:1d.2: setting latency timer to 64
 usb usb7: root hub lost power or was reset
-ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
-ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
-ehci_hcd 0000:00:1d.7: setting latency timer to 64
 ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10a)
 ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0648000)
+ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900006)
+ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
+ehci_hcd 0000:00:1d.7: setting latency timer to 64
 pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
 pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xe030e010)
 pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100107)
 pci 0000:00:1e.0: setting latency timer to 64
 ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x10a)
 ata_piix 0000:00:1f.1: restoring config space at offset 0x8 (was 0xc01, writing 0x2121)
 ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
 ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 ata_piix 0000:00:1f.1: setting latency timer to 64
 ata2: port disabled. ignoring.
 ACPI Exception (exoparg2-0444): AE_AML_PACKAGE_LIMIT, Index (000000005) is beyond end of object [20080926]
 ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.C2C3] (Node ffff88007e01de80), AE_AML_PACKAGE_LIMIT
 ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.C003.C0F6.C3F3._STM] (Node ffff88007e043dc0), AE_AML_PACKAGE_LIMIT
 ata1: ACPI set timing mode failed (status=0x300b)
 iwlagn 0000:10:00.0: enabling device (0000 -> 0002)
 iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
 iwlagn 0000:10:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
 iwlagn 0000:10:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xe0000004)
 iwlagn 0000:10:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
 iwlagn 0000:10:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
 iwlagn 0000:10:00.0: irq 508 for MSI/MSI-X
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0xf (was 0x3000100, writing 0x580010b)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0xe (was 0x0, writing 0x18fc)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0xd (was 0x0, writing 0x1800)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0xc (was 0x0, writing 0x14fc)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0xb (was 0x0, writing 0x1400)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0xa (was 0x0, writing 0x87fff000)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0x9 (was 0x0, writing 0x84000000)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0x8 (was 0x0, writing 0x83fff000)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0x7 (was 0x0, writing 0x80000000)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0x6 (was 0x0, writing 0xb0060302)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0x4 (was 0x0, writing 0xe0100000)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0x3 (was 0x820000, writing 0x82a800)
 yenta_cardbus 0000:02:06.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
 ohci1394 0000:02:06.1: restoring config space at offset 0xf (was 0x4020200, writing 0x4020205)
 ohci1394 0000:02:06.1: restoring config space at offset 0x4 (was 0x0, writing 0xe0101000)
 ohci1394 0000:02:06.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
 ohci1394 0000:02:06.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
 Registered led device: iwl-phy0:radio
 Registered led device: iwl-phy0:assoc
 Registered led device: iwl-phy0:RX
 Registered led device: iwl-phy0:TX
 ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
 sdhci-pci 0000:02:06.2: restoring config space at offset 0xf (was 0x300, writing 0x30a)
 sdhci-pci 0000:02:06.2: restoring config space at offset 0x4 (was 0x0, writing 0xe0102000)
 sdhci-pci 0000:02:06.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
 sdhci-pci 0000:02:06.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
 sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
 sd 0:0:0:0: [sda] Starting disk
 ata1.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
 ata1.01: ACPI cmd ef/03:40:00:00:00:b0 filtered out
 ata1.00: ACPI cmd ef/03:01:00:00:00:a0 filtered out
 ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
 ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
 ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
 ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
 ata1.00: configured for UDMA/100
 ata1.01: configured for MWDMA2
 ata1.00: configured for UDMA/100
 ata1.01: configured for MWDMA2
 ata1: EH complete
 sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
 sd 0:0:0:0: [sda] Write Protect is off
 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
 sd 0:0:0:0: [sda] Write Protect is off
 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
-usb 5-2: reset full speed USB device using uhci_hcd and address 2
 usb 1-1: reset full speed USB device using uhci_hcd and address 2
 irq 19: nobody cared (try booting with the "irqpoll" option)
-Pid: 0, comm: swapper Not tainted 2.6.28-rc7-test-resumefix #67
+Pid: 0, comm: swapper Not tainted 2.6.28-rc7-test-resumefix+usb #70
 Call Trace:
- <IRQ>  [<ffffffffa00ee9e1>] ? ohci_irq_handler+0x60/0x7e9 [ohci1394]
+ <IRQ>  [<ffffffffa01009e1>] ? ohci_irq_handler+0x60/0x7e9 [ohci1394]
  [<ffffffff8026aa4d>] __report_bad_irq+0x38/0x87
  [<ffffffff8026abaa>] note_interrupt+0x10e/0x174
  [<ffffffff8026b262>] handle_fasteoi_irq+0xa7/0xd1
  [<ffffffff8020eb87>] do_IRQ+0x73/0xe4
  [<ffffffff8020c626>] ret_from_intr+0x0/0xa
  <EOI>  [<ffffffffa0012606>] ? acpi_idle_enter_bm+0x26b/0x2b2 [processor]
  [<ffffffffa00125fc>] ? acpi_idle_enter_bm+0x261/0x2b2 [processor]
  [<ffffffff8024f30f>] ? notifier_call_chain+0x33/0x5b
- [<ffffffff803b9c64>] ? cpuidle_idle_call+0x8c/0xc4
+ [<ffffffff803b9c6c>] ? cpuidle_idle_call+0x8c/0xc4
  [<ffffffff8020b312>] ? cpu_idle+0x4a/0x9a
  [<ffffffff8042c5c8>] ? rest_init+0x5c/0x5e
 handlers:
-[<ffffffffa00ee981>] (ohci_irq_handler+0x0/0x7e9 [ohci1394])
+[<ffffffffa0100981>] (ohci_irq_handler+0x0/0x7e9 [ohci1394])
 Disabling IRQ #19
+usb 5-2: reset full speed USB device using uhci_hcd and address 2
 pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 pci 0000:00:02.0: setting latency timer to 64
 Restarting tasks ... done.

--Boundary-00=_TPkOJ/1t1/3obXh--
