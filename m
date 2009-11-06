Return-Path: <linux-kernel-owner+w=401wt.eu-S933258AbZKFWqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbZKFWqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbZKFWqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:46:17 -0500
Received: from kroah.org ([198.145.64.141]:56693 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169AbZKFWW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:28 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:40 2009
Message-Id: <20091106221540.421494604@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Chuck Ebbert <cebbert@redhat.com>
Subject: [13/99] ahci: revert "Restore SB600 sata controller 64 bit DMA"
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=ahci-revert-restore-sb600-sata-controller-64-bit-dma.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chuck Ebbert <cebbert@redhat.com>

revert commit 58a09b38cfcd700b796ea07ae3d2e0efbb28b561
("[libata] ahci: Restore SB600 SATA controller 64 bit DMA")

Upstream commit 58a09b38cfcd700b796ea07ae3d2e0efbb28b561 does
nearly the same thing but this patch is simplified for 2.6.31

Disables 64-bit DMA for _all_ boards, unlike 2.6.32 which adds a
whitelist. (The whitelist function requires a fairly large patch
that touches unrelated code.)

Doesn't revert the DMI part as other backported patches might need
the exported symbol.

Applies to 2.6.31.4

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |   52 ++--------------------------------------------------
 1 file changed, 2 insertions(+), 50 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -433,7 +433,8 @@ static const struct ata_port_info ahci_p
 	[board_ahci_sb600] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
-				 AHCI_HFLAG_NO_MSI | AHCI_HFLAG_SECT255),
+				 AHCI_HFLAG_32BIT_ONLY | AHCI_HFLAG_NO_MSI |
+				 AHCI_HFLAG_SECT255),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
@@ -2602,51 +2603,6 @@ static void ahci_p5wdh_workaround(struct
 	}
 }
 
-/*
- * SB600 ahci controller on ASUS M2A-VM can't do 64bit DMA with older
- * BIOS.  The oldest version known to be broken is 0901 and working is
- * 1501 which was released on 2007-10-26.  Force 32bit DMA on anything
- * older than 1501.  Please read bko#9412 for more info.
- */
-static bool ahci_asus_m2a_vm_32bit_only(struct pci_dev *pdev)
-{
-	static const struct dmi_system_id sysids[] = {
-		{
-			.ident = "ASUS M2A-VM",
-			.matches = {
-				DMI_MATCH(DMI_BOARD_VENDOR,
-					  "ASUSTeK Computer INC."),
-				DMI_MATCH(DMI_BOARD_NAME, "M2A-VM"),
-			},
-		},
-		{ }
-	};
-	const char *cutoff_mmdd = "10/26";
-	const char *date;
-	int year;
-
-	if (pdev->bus->number != 0 || pdev->devfn != PCI_DEVFN(0x12, 0) ||
-	    !dmi_check_system(sysids))
-		return false;
-
-	/*
-	 * Argh.... both version and date are free form strings.
-	 * Let's hope they're using the same date format across
-	 * different versions.
-	 */
-	date = dmi_get_system_info(DMI_BIOS_DATE);
-	year = dmi_get_year(DMI_BIOS_DATE);
-	if (date && strlen(date) >= 10 && date[2] == '/' && date[5] == '/' &&
-	    (year > 2007 ||
-	     (year == 2007 && strncmp(date, cutoff_mmdd, 5) >= 0)))
-		return false;
-
-	dev_printk(KERN_WARNING, &pdev->dev, "ASUS M2A-VM: BIOS too old, "
-		   "forcing 32bit DMA, update BIOS\n");
-
-	return true;
-}
-
 static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
 {
 	static const struct dmi_system_id broken_systems[] = {
@@ -2857,10 +2813,6 @@ static int ahci_init_one(struct pci_dev 
 	if (board_id == board_ahci_sb700 && pdev->revision >= 0x40)
 		hpriv->flags &= ~AHCI_HFLAG_IGN_SERR_INTERNAL;
 
-	/* apply ASUS M2A_VM quirk */
-	if (ahci_asus_m2a_vm_32bit_only(pdev))
-		hpriv->flags |= AHCI_HFLAG_32BIT_ONLY;
-
 	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
 


