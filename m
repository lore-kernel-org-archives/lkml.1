Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831Ab0CMATn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:19:43 -0500
Received: from kroah.org ([198.145.64.141]:60503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934780Ab0CMATb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:31 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:05 2010
Message-Id: <20100313001505.250188739@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Hancock <hancockrwd@gmail.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 001/123] ahci: disable FPDMA auto-activate optimization on NVIDIA AHCI
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Robert Hancock <hancockrwd@gmail.com>

commit 453d3131ec7aab82eaaa8401a50522a337092aa8 upstream.

Mike Cui reported that his system with an NVIDIA MCP79 (aka MCP7A)
chipset stopped working with 2.6.32. The problem appears to be that
2.6.32 now enables the FPDMA auto-activate optimization in the ahci
driver. The drive works fine with this enabled on an Intel AHCI so
this appears to be a chipset bug.  Since MCP79 is a fairly recent
NVIDIA chipset and we don't have any info on whether any other NVIDIA
chipsets have this issue, disable FPDMA AA optimization on all NVIDIA
AHCI controllers for now.

Should address http://bugzilla.kernel.org/show_bug.cgi?id=14922

Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
While-we-investigate-issue-this-patch-looks-good-to-me-by:
	Prajakta Gudadhe <pgudadhe@nvidia.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -3082,8 +3082,16 @@ static int ahci_init_one(struct pci_dev
 	ahci_save_initial_config(pdev, hpriv);
 
 	/* prepare host */
-	if (hpriv->cap & HOST_CAP_NCQ)
-		pi.flags |= ATA_FLAG_NCQ | ATA_FLAG_FPDMA_AA;
+	if (hpriv->cap & HOST_CAP_NCQ) {
+		pi.flags |= ATA_FLAG_NCQ;
+		/* Auto-activate optimization is supposed to be supported on
+		   all AHCI controllers indicating NCQ support, but it seems
+		   to be broken at least on some NVIDIA MCP79 chipsets.
+		   Until we get info on which NVIDIA chipsets don't have this
+		   issue, if any, disable AA on all NVIDIA AHCIs. */
+		if (pdev->vendor != PCI_VENDOR_ID_NVIDIA)
+			pi.flags |= ATA_FLAG_FPDMA_AA;
+	}
 
 	if (hpriv->cap & HOST_CAP_PMP)
 		pi.flags |= ATA_FLAG_PMP;


