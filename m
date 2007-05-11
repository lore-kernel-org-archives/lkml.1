Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXEKMfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXEKMfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbXEKMfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:35:45 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:26320 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbXEKMfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rieWCtPofdHmr/88hZPpCw1m5PXF+9mKOm1AnCzOr5b8d4RgikKEYhTQPup9H7a9PedkhRZYpC26iLFFKM9bftazW6BPpcsEFI+cypWYemcIR4/g5+MnkQV7Y6buknbVi7tLAFX/CTtH8ougatWMNC6cLlMBXYwvzTEXZlbP9eQ=
Message-ID: <46446311.3000208@gmail.com>
Date: Fri, 11 May 2007 14:35:29 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: William Thompson <wt@electro-mechanical.com>, Mark Lord <liml@rtr.ca>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: [PATCH] libata: fallback to the other IDENTIFY on device error, take#2
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com> <20070501121703.GH5942@electro-mechanical.com> <46373AEE.6070908@rtr.ca> <20070501131818.GA18521@electro-mechanical.com> <46374354.7040307@gmail.com> <20070501172117.GA20328@electro-mechanical.com> <463F56F2.3010106@gmail.com> <4642627A.4030606@garzik.org>
In-Reply-To: <4642627A.4030606@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems the world isn't as frank as we thought and some devices lie
about who they are.  Fallback to the other IDENTIFY if IDENTIFY is
aborted by the device.  As this is the strategy used by IDE for a long
time, it shouldn't cause too much problem.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: William Thompson <wt@electro-mechanical.com>
---
Updated to fallback iff IDENTIFY is aborted by the device.

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4595d1f..96a7c6f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1654,7 +1654,7 @@ int ata_dev_read_id(struct ata_device *d
 	struct ata_taskfile tf;
 	unsigned int err_mask = 0;
 	const char *reason;
-	int tried_spinup = 0;
+	int may_fallback = 1, tried_spinup = 0;
 	int rc;
 
 	if (ata_msg_ctl(ap))
@@ -1698,11 +1698,31 @@ int ata_dev_read_id(struct ata_device *d
 			return -ENOENT;
 		}
 
+		/* Device or controller might have reported the wrong
+		 * device class.  Give a shot at the other IDENTIFY if
+		 * the current one is aborted by the device.
+		 */
+		if (may_fallback &&
+		    (err_mask == AC_ERR_DEV) && (tf.feature & ATA_ABORTED)) {
+			may_fallback = 0;
+
+			if (class == ATA_DEV_ATA)
+				class = ATA_DEV_ATAPI;
+			else
+				class = ATA_DEV_ATA;
+			goto retry;
+		}
+
 		rc = -EIO;
 		reason = "I/O error";
 		goto err_out;
 	}
 
+	/* Falling back doesn't make sense if ID data was read
+	 * successfully at least once.
+	 */
+	may_fallback = 0;
+
 	swap_buf_le16(id, ATA_ID_WORDS);
 
 	/* sanity check */
