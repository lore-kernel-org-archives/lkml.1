Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYJCQcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYJCQcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYJCQbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:31:38 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:35927 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbYJCQbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:31:36 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: serue@us.ibm.com, zohar@linux.vnet.ibm.com, akpm@linux-foundation.org,
       jmorris@namei.org
Subject: [PATCH 1/5] TPM: update char dev BKL pushdown
Date: Fri,  3 Oct 2008 13:30:06 -0300
Message-Id: <d209642eac2fed062156829d02507e00d51520b4.1223042186.git.srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
References: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
In-Reply-To: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
References: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
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

