Return-Path: <linux-kernel-owner+w=401wt.eu-S932272AbZGABXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbZGABXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbZGABE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:04:27 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:59249 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765524AbZGABET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:04:19 -0400
From: Andy Isaacson <adi@vmware.com>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: adi@hexapodia.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       dds@google.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com,
       Andy Isaacson <adi@vmware.com>
Subject: [PATCH 6/6] tpm_tis: add workarounds for iTPM
Date: Tue, 30 Jun 2009 18:04:15 -0700
Message-Id: <1246410255-6839-7-git-send-email-adi@vmware.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1246410255-6839-1-git-send-email-adi@vmware.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Lenovo platforms (X200 and T400, maybe others) have an "iTPM" which
does not quite conform to the TPM spec.  With one small hack the iTPM
seems to work OK.

iTPM does not set TPM_STS_DATA_EXPECT reliably during multi-burst
transfers.  (STS_DATA_EXPECT appears to be set after the final burst,
not after each burst.)  So we give up and don't attempt to report
errors during write.

Based on a patch from Colin Didier and the tpmdd-devel mailing list:
http://cybione.org/~cdidier/log/data/200812020841/itpm.diff

Signed-off-by: Andy Isaacson <adi@vmware.com>
---
 drivers/char/tpm/tpm_tis.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 7f0cb6c..07ac7e0 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -85,6 +85,7 @@ struct tpm_data {
 	void __iomem *tpm_address;
 	int tpm_size;
 	int tpm_irq;
+	int itpm;
 };
 
 static int check_locality(struct tpm_chip *chip, int l)
@@ -277,6 +278,7 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	int rc, status, burstcnt;
 	size_t count = 0;
 	u32 ordinal;
+	struct tpm_data *tpm = to_acpi_device(chip->dev)->driver_data;
 
 	if (request_locality(chip, 0) < 0)
 		return -EBUSY;
@@ -303,7 +305,7 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 		wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
 			      &chip->vendor.int_queue);
 		status = tpm_tis_status(chip);
-		if ((status & TPM_STS_DATA_EXPECT) == 0) {
+		if (!tpm->itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
 			rc = -EIO;
 			goto out_err;
 		}
@@ -444,12 +446,17 @@ static int interrupts = 1;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
+static int itpm;
+module_param(itpm, bool, 0444);
+MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
+
 static int tpm_tis_init(struct device *dev, resource_size_t start,
 			resource_size_t len, unsigned int irq)
 {
 	u32 vendor, intfcaps, intmask;
 	int rc, i;
 	struct tpm_chip *chip;
+	struct tpm_data *tpm = to_acpi_device(dev)->driver_data;
 
 	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
 		return -ENODEV;
@@ -477,6 +484,11 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		 "1.2 TPM (%04X:%04X rev %d)\n", vendor & 0xffff,
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
+	if (itpm || vendor == 0x10208086) {
+		dev_info(dev, "Intel iTPM workaround enabled\n");
+		tpm->itpm = 1;
+	}
+
 	/* Figure out the capabilities */
 	intfcaps =
 	    ioread32(chip->vendor.iobase +
-- 
1.6.3.1

