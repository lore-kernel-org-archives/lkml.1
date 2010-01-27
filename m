Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619Ab0A0Edl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0A0Edl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 23:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033Ab0A0Edk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 23:33:40 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:52985 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab0A0Edj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 23:33:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=h9Jg92BmRpkmooWF18Mu/iP4EIw+kGakQ4SMQMwceSyAjaBkbo3mHxEvRzh7i7nEHJ
         jtDQ9EOsk1V/tWUs3FjcU99qiprWpJR8iLyJKmpFJABHyWA31XRdbEp/c6UW4kMhT1Xh
         STNP3SGKAWsyMsBjrdDCS6d0w0XvWIXLp5m8U=
Message-ID: <4B5FC213.1060601@gmail.com>
Date: Tue, 26 Jan 2010 22:33:23 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
CC: Mike Cui <cuicui@gmail.com>, Peer Chen <pchen@nvidia.com>
Subject: [PATCH] ahci: disable FPDMA auto-activate optimization on NVIDIA
 AHCI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Cui reported that his system with an NVIDIA MCP79 (aka MCP7A) chipset
stopped working with 2.6.32. The problem appears to be that 2.6.32 now enables
the FPDMA auto-activate optimization in the ahci driver. The drive works fine
with this enabled on an Intel AHCI so this appears to be a chipset bug.
Since MCP79 is a fairly recent NVIDIA chipset and we don't have any info on
whether any other NVIDIA chipsets have this issue, disable FPDMA AA optimization
on all NVIDIA AHCI controllers for now.

Should address http://bugzilla.kernel.org/show_bug.cgi?id=14922

Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

---

Mike, can you test this out and make sure this resolves the problem for you?

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index b8bea10..47e57dc 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -3067,8 +3067,16 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
