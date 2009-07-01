Return-Path: <linux-kernel-owner+w=401wt.eu-S1764777AbZGABXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764777AbZGABXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765518AbZGABEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:04:24 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:34989 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765521AbZGABES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:04:18 -0400
From: Andy Isaacson <adi@vmware.com>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: adi@hexapodia.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       dds@google.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com,
       Andy Isaacson <adi@vmware.com>
Subject: [PATCH 3/6] tpm_tis: set timeouts before calling request_locality
Date: Tue, 30 Jun 2009 18:04:12 -0700
Message-Id: <1246410255-6839-4-git-send-email-adi@vmware.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1246410255-6839-1-git-send-email-adi@vmware.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Intel iTPM implementations, the timeouts must be set before
calling request_locality.

Based on a patch from Colin Didier and the tpmdd-devel mailing list:
http://cybione.org/~cdidier/log/data/200812020841/itpm.diff

Signed-off-by: Andy Isaacson <adi@vmware.com>
---
 drivers/char/tpm/tpm_tis.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index e859e0e..e0bda02 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -450,6 +450,12 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		goto out_err;
 	}
 
+	/* Default timeouts */
+	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
+	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+
 	if (request_locality(chip, 0) != 0) {
 		rc = -ENODEV;
 		goto out_err;
@@ -457,12 +463,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 
 	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
 
-	/* Default timeouts */
-	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
-	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-
 	dev_info(dev,
 		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
-- 
1.6.3.1

