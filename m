Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbYG1WOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbYG1WOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYG1WO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:14:26 -0400
Received: from outbound-mail-108.bluehost.com ([69.89.22.8]:53891 "HELO
	outbound-mail-108.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750827AbYG1WOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:14:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=K1eHjbu5dcQgjhN+12YqTTTYQEDXsqZn7syLZbnc4s+JcvpaMXHq4OcvVpkP7bRwwHOpVqzY1E4ICZUhbYw3jh47mFV0eItE4byFrzvafYMNxm3X8hnKlcKQnJjdY7Gt;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH PROPOSAL] libata/pci: Move D3 hack handling from libata into PCI
Date: Mon, 28 Jul 2008 15:14:20 -0700
User-Agent: KMail/1.9.9
Cc: jeff@garzik.org, greg@kroah.com, linux-kernel@vger.kernel.org
References: <20080724171838.591f6a31@lxorguk.ukuu.org.uk> <200807241311.24384.jbarnes@virtuousgeek.org> <20080724211426.26bb15fe@lxorguk.ukuu.org.uk>
In-Reply-To: <20080724211426.26bb15fe@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281514.20923.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2008 1:14 pm Alan Cox wrote:
> On Thu, 24 Jul 2008 13:11:24 -0700
>
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Thursday, July 24, 2008 9:18 am Alan Cox wrote:
> > > Libata has some hacks to deal with certain controllers going silly in
> > > D3 state. The right way to handle this is to keep a PCI device flag for
> > > such devices. That can then be generalised for no ATA devices with
> > > power problems.
> > >
> > > Signed-off-by: Alan Cox <alan@redhat.com>
> >
> > Looks pretty reasonable to me; do you want me to take the drivers/ata
> > bits along with the PCI stuff?
> >
> > Btw, what happens to these devices in D3hot?  Do they behave like they're
> > in D3cold or something and require a reset?  Or do they otherwise kill
> > the bus somehow?
>
> They lose some of their configuration bits in a manner we can't restore.
> The end effect of that is that if we disable/re-enable them they can't be
> put back into proper DMA mode.
>
> Windows it seems doesn't do this to these devices and the BIOS re-inits
> the legacy ATA controllers during boot up which makes suspend/resume work.

I applied the PCI bits of this patch to my for-linus branch (see below for
diff), thanks Alan.

Jesse

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c95f77d..0a3d856 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -572,6 +572,10 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t st
                if (!ret)
                        pci_update_current_state(dev);
        }
+       /* This device is quirked not to be put into D3, so
+          don't put it in D3 */
+       if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
+               return 0;

        error = pci_raw_set_power_state(dev, state);

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 12d4893..0fb3650 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -923,6 +923,19 @@ static void __init quirk_ide_samemode(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_10, qu

+/*
+ * Some ATA devices break if put into D3
+ */
+
+static void __devinit quirk_no_ata_d3(struct pci_dev *pdev)
+{
+       /* Quirk the legacy ATA devices only. The AHCI ones are ok */
+       if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
+               pdev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_ANY_ID, quirk_no_ata_d3)
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, PCI_ANY_ID, quirk_no_ata_d3);
+
 /* This was originally an Alpha specific thing, but it really fits here.
  * The i82375 PCI/EISA bridge appears as non-classified. Fix that.
  */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1d296d3..825be38 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -124,6 +124,8 @@ enum pci_dev_flags {
         * generation too.
         */
        PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG = (__force pci_dev_flags_t) 1,
+       /* Device configuration is irrevocably lost if disabled into D3 */
+       PCI_DEV_FLAGS_NO_D3 = (__force pci_dev_flags_t) 2,
 };

 typedef unsigned short __bitwise pci_bus_flags_t;


