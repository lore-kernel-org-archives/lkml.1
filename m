Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbYCKKwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbYCKKwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYCKKwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:52:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:10031 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYCKKwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DiHNnssc6RjQfvgibd5Vlb4UrHweMogvMs/Wearx8PTUbd8JLj8joyyoTWUkWZMtP938TYK9FvQwoPvsV6W7NtI3XTi2inlfo4RasBt5TIs6oK193Xc3fwdilXdXHoAq4EtQ4kIXj8JPxequF9Vyn1XeY9foWxwIo3rJy/1Z86c=
Message-ID: <47D6646F.9070109@gmail.com>
Date: Tue, 11 Mar 2008 19:52:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH libata-dev#upstream-fixes] ahci: request all PCI BARs
References: <47D6643A.6060001@gmail.com>
In-Reply-To: <47D6643A.6060001@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ahci is often implemented with accompanying SFF compatible interface
and legacy IDE driver may attach to the legacy IO ports when the
controller is already claimed by ahci and vice-versa.  This patch
makes ahci use pcim_iomap_regions_request_all() so that all IO regions
are claimed on attach.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/ata/ahci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: work/drivers/ata/ahci.c
===================================================================
--- work.orig/drivers/ata/ahci.c
+++ work/drivers/ata/ahci.c
@@ -2234,7 +2234,10 @@ static int ahci_init_one(struct pci_dev 
 	if (rc)
 		return rc;
 
-	rc = pcim_iomap_regions(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
+	/* AHCI controllers often implement SFF compatible interface.
+	 * Grab all PCI BARs just in case.
+	 */
+	rc = pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
