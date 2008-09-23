Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYIWRUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYIWRUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYIWRUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:20:01 -0400
Received: from igw3.br.ibm.com ([32.104.18.26]:48921 "EHLO igw3.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbYIWRUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:20:00 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jmoriss@namei.org, serue@linux.vnet.ibm.com,
       zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
       paulmck@linux.vnet.ibm.com, debora@linux.vnet.ibm.com
Subject: [PATCH 2/4] TPM: num_opens to is_open variable change
Date: Tue, 23 Sep 2008 14:19:27 -0300
Message-Id: <1222190371-23814-2-git-send-email-srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renames num_open to is_open, as only one process can open the file at a time.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.c |    7 +++----
 drivers/char/tpm/tpm.h |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ceba608..dfd4e7f 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -978,20 +978,19 @@ int tpm_open(struct inode *inode, struct file *file)
 		goto err_out;
 	}
 
-	if (chip->num_opens) {
+	if (test_and_set_bit(0, &chip->is_open)) {
 		dev_dbg(chip->dev, "Another process owns this TPM\n");
 		rc = -EBUSY;
 		goto err_out;
 	}
 
-	chip->num_opens++;
 	get_device(chip->dev);
 
 	spin_unlock(&driver_lock);
 
 	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
 	if (chip->data_buffer == NULL) {
-		chip->num_opens--;
+		clear_bit(0, &chip->is_open);
 		put_device(chip->dev);
 		return -ENOMEM;
 	}
@@ -1016,7 +1015,7 @@ int tpm_release(struct inode *inode, struct file *file)
 	file->private_data = NULL;
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	atomic_set(&chip->data_pending, 0);
-	chip->num_opens--;
+	clear_bit(0, &chip->is_open);
 	put_device(chip->dev);
 	kfree(chip->data_buffer);
 	spin_unlock(&driver_lock);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index e885148..2756cab 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -90,7 +90,7 @@ struct tpm_chip {
 	struct device *dev;	/* Device stuff */
 
 	int dev_num;		/* /dev/tpm# */
-	int num_opens;		/* only one allowed */
+	unsigned long is_open;	/* only one allowed */
 	int time_expired;
 
 	/* Data passed to and from the tpm via the read/write calls */
-- 
1.5.6.3

