Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZIIXWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZIIXWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZIIXWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:22:19 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:50582 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754534AbZIIXWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:22:18 -0400
Date: Wed, 9 Sep 2009 17:22:18 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org
Cc: tpmdd-devel@lists.sourceforge.net, srajiv@linux.vnet.ibm.com,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       James Morris <jmorris@namei.org>, Jan Beulich <jbeulich@novell.com>
Subject: [PATCH] TPM: Fixup boot probe timeout for tpm_tis driver
Message-ID: <20090909232218.GK406@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When probing the device in tpm_tis_init the call request_locality
uses timeout_a, which wasn't being initalized until after
request_locality. This results in request_locality falsely timing
out if the chip is still starting. Move the initialization to before
request_locality.

This probably only matters for embedded cases (ie mine), a BIOS likely
gets the TPM into a state where this code path isn't necessary.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm_tis.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 241b5ae..c1e5ab8 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -450,6 +450,12 @@ static int tpm_tis_init(struct device *dev, u32 start,
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
@@ -457,12 +463,6 @@ static int tpm_tis_init(struct device *dev, u32 start,
 
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
1.5.4.2

