Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXKRXf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXKRXf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 18:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXKRXfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 18:35:50 -0500
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:50784 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbXKRXft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 18:35:49 -0500
Message-ID: <4740CBA3.4090708@selhorst.net>
Date: Mon, 19 Nov 2007 00:32:51 +0100
From: Marcel Selhorst <tpm@selhorst.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071117)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, Kylene Jo Hall <kjhall@us.ibm.com>
Subject: [PATCH] TPM TIS device driver locality request
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.1-5; AVE: 7.6.0.34; VDF: 7.0.0.227; host: mail)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

during the initialization of the TPM TIS driver, the necessary
locality has to be requested earlier in the init-process. Depending on
the used TPM chip, this leads to wrong information.
For example: Lenovo X61s with Atmel TPM:

tpm_tis 00:0a: 1.2 TPM (device-id 0xFFFF, rev-id 255)

But correct is:

tpm_tis 00:0c: 1.2 TPM (device-id 0x3203, rev-id 9)

This short patch fixes this issue.

Signed-Off-by Marcel Selhorst <tpm@selhorst.net>
---
--- tpm_tis.c.orig      2007-11-19 00:21:09.000000000 +0100
+++ tpm_tis.c   2007-11-19 00:21:23.000000000 +0100
@@ -450,6 +450,11 @@ static int tpm_tis_init(struct device *d
                goto out_err;
        }

+       if (request_locality(chip, 0) != 0) {
+               rc = -ENODEV;
+               goto out_err;
+       }
+
        vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));

        /* Default timeouts */
@@ -487,11 +492,6 @@ static int tpm_tis_init(struct device *d
        if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
                dev_dbg(dev, "\tData Avail Int Support\n");

-       if (request_locality(chip, 0) != 0) {
-               rc = -ENODEV;
-               goto out_err;
-       }
-
        /* INTERRUPT Setup */
        init_waitqueue_head(&chip->vendor.read_queue);
        init_waitqueue_head(&chip->vendor.int_queue);
