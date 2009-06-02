Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZFBPWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZFBPWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZFBPWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:22:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:49875 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbZFBPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=v1fKsDnywO9gkMEybWaE11QZSy5R49ZwCfcs3QJJ9+TQvc6UMDH/hYY191hlmIJv5z
         0D7mtM0KNxy392J9D0rAVR1KL8xSWwFOTfQbocMw5kJSPSUAnjCg1zfVAMWCA4LIdhFV
         r18r319GvmXzvuT0MqxONRUCcW/u+vVWdnp6I=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH] tty_io: add an API to get device corresponding to tty_struct
Date: Tue,  2 Jun 2009 19:21:38 +0400
Message-Id: <1243956098-20155-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/char/tty_io.c |   20 ++++++++++++++++++++
 include/linux/tty.h   |    1 +
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 66b99a2..0160500 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3026,6 +3026,26 @@ dev_t tty_devnum(struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_devnum);
 
+static int dev_match_devt(struct device *dev, void *data)
+{
+	dev_t *devt = data;
+	return dev->devt == *devt;
+}
+
+/**
+ * 	tty_get_device - get a device corresponding to tty
+ * 	@tty: the struct that describes the tty device
+ *
+ * 	Returns a pointer to the struct device for this tty device
+ * 	(or NULL in case of error).
+ */
+struct device *tty_get_device(struct tty_struct *tty)
+{
+	dev_t devt = tty_devnum(tty);
+	return class_find_device(tty_class, NULL, &devt, dev_match_devt);
+}
+EXPORT_SYMBOL(tty_get_device);
+
 void proc_clear_tty(struct task_struct *p)
 {
 	unsigned long flags;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index fc39db9..d17ba1e 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -413,6 +413,7 @@ extern int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
 extern dev_t tty_devnum(struct tty_struct *tty);
+struct device *tty_get_device(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
-- 
1.6.3.1

