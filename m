Return-Path: <linux-kernel-owner+w=401wt.eu-S1761871AbXKHShu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761871AbXKHShu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760820AbXKHShk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:37:40 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:53609 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbXKHShj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:37:39 -0500
Date: Thu, 8 Nov 2007 18:37:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, roppedisano@infracomspa.it,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, rjw@sisk.pl,
       linux-acpi@vger.kernel.org
Message-ID: <20071108183707.GA3008@srcf.ucam.org>
References: <4731C86B.1040704@infracomspa.it> <20071107121355.5eaf4496.akpm@linux-foundation.org> <47333CCF.1050403@infracomspa.it> <20071108094958.5c9b1b22.akpm@linux-foundation.org> <20071108180256.GB3491@havoc.gtf.org> <20071108101341.6c4f88d4.akpm@linux-foundation.org> <20071108182217.GA2685@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108182217.GA2685@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: [PATCH] Don't fail ata device revalidation for bad _GTF methods
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Experience suggests that the _GTF method may be bad. We currently fail 
device revalidation in that case, which seems excessive.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

---

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 08a52dd..545ea86 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -312,7 +312,7 @@ EXPORT_SYMBOL_GPL(ata_acpi_stm);
  *
  * RETURNS:
  * Number of taskfiles on success, 0 if _GTF doesn't exist or doesn't
- * contain valid data.  -errno on other errors.
+ * contain valid data.
  */
 static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 			   void **ptr_to_free)
@@ -339,7 +339,6 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 			ata_dev_printk(dev, KERN_WARNING,
 				       "_GTF evaluation failed (AE 0x%x)\n",
 				       status);
-			rc = -EIO;
 		}
 		goto out_free;
 	}
@@ -359,7 +358,6 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 		ata_dev_printk(dev, KERN_WARNING,
 			       "_GTF unexpected object type 0x%x\n",
 			       out_obj->type);
-		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -367,7 +365,6 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 		ata_dev_printk(dev, KERN_WARNING,
 			       "unexpected _GTF length (%d)\n",
 			       out_obj->buffer.length);
-		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -511,10 +508,7 @@ static int ata_acpi_exec_tfs(struct ata_device *dev)
 	int gtf_count, i, rc;
 
 	/* get taskfiles */
-	rc = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
-	if (rc < 0)
-		return rc;
-	gtf_count = rc;
+	gtf_count = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
 
 	/* execute them */
 	for (i = 0, rc = 0; i < gtf_count; i++) {

-- 
Matthew Garrett | mjg59@srcf.ucam.org
