Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYIWRVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYIWRVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYIWRV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:21:26 -0400
Received: from igw1.br.ibm.com ([32.104.18.24]:33793 "EHLO igw1.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbYIWRVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:21:25 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jmoriss@namei.org, serue@linux.vnet.ibm.com,
       zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
       paulmck@linux.vnet.ibm.com, debora@linux.vnet.ibm.com
Subject: [PATCH 1/4] TPM: update char dev BKL pushdown
Date: Tue, 23 Sep 2008 14:19:26 -0300
Message-Id: <1222190371-23814-1-git-send-email-srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the BKL calls from the TPM driver, which
were added in the overall misc-char-dev-BKL-pushdown.patch,
as they are not needed.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ae766d8..ceba608 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -954,13 +954,16 @@ EXPORT_SYMBOL_GPL(tpm_store_cancel);
 
 /*
  * Device file system interface to the TPM
+ *
+ * It's assured that the chip will be opened just once,
+ * by the check of is_open variable, which is protected
+ * by driver_lock.
  */
 int tpm_open(struct inode *inode, struct file *file)
 {
 	int rc = 0, minor = iminor(inode);
 	struct tpm_chip *chip = NULL, *pos;
 
-	lock_kernel();
 	spin_lock(&driver_lock);
 
 	list_for_each_entry(pos, &tpm_chip_list, list) {
@@ -990,19 +993,16 @@ int tpm_open(struct inode *inode, struct file *file)
 	if (chip->data_buffer == NULL) {
 		chip->num_opens--;
 		put_device(chip->dev);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 
 	atomic_set(&chip->data_pending, 0);
 
 	file->private_data = chip;
-	unlock_kernel();
 	return 0;
 
 err_out:
 	spin_unlock(&driver_lock);
-	unlock_kernel();
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_open);
-- 
1.5.6.3

