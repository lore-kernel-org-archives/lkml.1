Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbZGPRoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbZGPRoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932891AbZGPRoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:44:07 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:57763 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890AbZGPRoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:44:06 -0400
Subject: [PATCH] TPM: DATA_EXPECT bit check bypass
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andy Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, adi@hexapodia.org, dds@google.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
In-Reply-To: <1247765210.30736.3.camel@dyn531421.br.ibm.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246410255-6839-6-git-send-email-adi@vmware.com>
	 <20090701110136.576a1d14@lxorguk.ukuu.org.uk>
	 <1246455920.9140.28.camel@blackbox>
	 <1247765210.30736.3.camel@dyn531421.br.ibm.com>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 14:43:32 -0300
Message-Id: <1247766212.30736.17.camel@dyn531421.br.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sending now inline in order to work ok with git-am, sorry for the flood.

This patch depends on patch http://patchwork.kernel.org/patch/33486/

Since the iTPM doesn't set the DATA_EXPECT bit when it should, we bypass
this bit check in case we're running the code over this specific TPM.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.h     |    1 +
 drivers/char/tpm/tpm_tis.c |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8e00b4d..ed4ecf0 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -109,6 +109,7 @@ struct tpm_chip {
 
        struct list_head list;
        void (*release) (struct device *);
+       bool is_itpm;
 };
 
 #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index aec1931..74a60d7 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -27,6 +27,7 @@
 #include "tpm.h"
 
 #define TPM_HEADER_SIZE 10
+#define ITPM_ID "INTC0102"
 
 enum tis_access {
        TPM_ACCESS_VALID = 0x80,
@@ -293,7 +294,9 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
                wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
                              &chip->vendor.int_queue);
                status = tpm_tis_status(chip);
-               if ((status & TPM_STS_DATA_EXPECT) == 0) {
+               /* iTPM never sets the DATA_EXPECT bit */
+               if (((status & TPM_STS_DATA_EXPECT) == 0) &&
+                    (!chip->is_itpm)) {
                        rc = -EIO;
                        goto out_err;
                }
@@ -582,6 +585,12 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
        tpm_get_timeouts(chip);
        tpm_continue_selftest(chip);
 
+       for (i=0; i < 8; i++)
+               if (ITPM_ID[i] != to_pnp_dev(dev)->id->id[i])
+                       break;
+       if (i == 8)
+               chip->is_itpm = 1;
+
        return 0;
 out_err:
        if (chip->vendor.iobase)
-- 
1.6.3.1


