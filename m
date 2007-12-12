Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbXLMAoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbXLMAoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 19:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759706AbXLMAnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 19:43:52 -0500
Received: from homer.mvista.com ([63.81.120.158]:48879 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759641AbXLMAnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 19:43:51 -0500
Message-Id: <20071213003032.547362071@mvista.com>
References: <20071213003028.676998182@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Dec 2007 00:00:03 -0800
Subject: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
References: <20071213003023.117964080@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de
Content-Disposition: inline; filename=bcm43xx-semaphore-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c |   30 ++++++++++++-------------
 1 file changed, 15 insertions(+), 15 deletions(-)

Index: linux-2.6.23/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
===================================================================
--- linux-2.6.23.orig/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
+++ linux-2.6.23/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
@@ -43,7 +43,7 @@
 
 static struct bcm43xx_debugfs fs;
 static char really_big_buffer[REALLY_BIG_BUFFER_SIZE];
-static DECLARE_MUTEX(big_buffer_sem);
+static DEFINE_MUTEX(big_buffer_mutex);
 
 
 static ssize_t write_file_dummy(struct file *file, const char __user *buf,
@@ -75,7 +75,7 @@ static ssize_t devinfo_read_file(struct 
 	u16 tmp16;
 	int i;
 
-	down(&big_buffer_sem);
+	mutex_lock(&big_buffer_mutex);
 
 	mutex_lock(&bcm->mutex);
 	spin_lock_irqsave(&bcm->irq_lock, flags);
@@ -125,7 +125,7 @@ out:
 	spin_unlock_irqrestore(&bcm->irq_lock, flags);
 	mutex_unlock(&bcm->mutex);
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	up(&big_buffer_sem);
+	mutex_unlock(&big_buffer_mutex);
 	return res;
 }
 
@@ -138,14 +138,14 @@ static ssize_t drvinfo_read_file(struct 
 	size_t pos = 0;
 	ssize_t res;
 
-	down(&big_buffer_sem);
+	mutex_lock(&big_buffer_mutex);
 
 	/* This is where the information is written to the "driver" file */
 	fappend(KBUILD_MODNAME " driver\n");
 	fappend("Compiled at: %s %s\n", __DATE__, __TIME__);
 
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	up(&big_buffer_sem);
+	mutex_unlock(&big_buffer_mutex);
 	return res;
 }
 
@@ -160,7 +160,7 @@ static ssize_t spromdump_read_file(struc
 	ssize_t res;
 	unsigned long flags;
 
-	down(&big_buffer_sem);
+	mutex_lock(&big_buffer_mutex);
 	mutex_lock(&bcm->mutex);
 	spin_lock_irqsave(&bcm->irq_lock, flags);
 	if (bcm43xx_status(bcm) != BCM43xx_STAT_INITIALIZED) {
@@ -175,7 +175,7 @@ out:
 	spin_unlock_irqrestore(&bcm->irq_lock, flags);
 	mutex_unlock(&bcm->mutex);
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	up(&big_buffer_sem);
+	mutex_unlock(&big_buffer_mutex);
 	return res;
 }
 
@@ -191,7 +191,7 @@ static ssize_t tsf_read_file(struct file
 	unsigned long flags;
 	u64 tsf;
 
-	down(&big_buffer_sem);
+	mutex_lock(&big_buffer_mutex);
 	mutex_lock(&bcm->mutex);
 	spin_lock_irqsave(&bcm->irq_lock, flags);
 	if (bcm43xx_status(bcm) != BCM43xx_STAT_INITIALIZED) {
@@ -207,7 +207,7 @@ out:
 	spin_unlock_irqrestore(&bcm->irq_lock, flags);
 	mutex_unlock(&bcm->mutex);
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	up(&big_buffer_sem);
+	mutex_unlock(&big_buffer_mutex);
 	return res;
 }
 
@@ -222,7 +222,7 @@ static ssize_t tsf_write_file(struct fil
 	unsigned long long tsf;
 
 	buf_size = min(count, sizeof (really_big_buffer) - 1);
-	down(&big_buffer_sem);
+	mutex_lock(&big_buffer_mutex);
 	if (copy_from_user(buf, user_buf, buf_size)) {
 	        res = -EFAULT;
 		goto out_up;
@@ -247,7 +247,7 @@ out_unlock:
 	spin_unlock_irqrestore(&bcm->irq_lock, flags);
 	mutex_unlock(&bcm->mutex);
 out_up:
-	up(&big_buffer_sem);
+	mutex_unlock(&big_buffer_mutex);
 	return res;
 }
 
@@ -265,7 +265,7 @@ static ssize_t txstat_read_file(struct f
 	struct bcm43xx_xmitstatus *status;
 	int i, cnt, j = 0;
 
-	down(&big_buffer_sem);
+	mutex_lock(&big_buffer_mutex);
 	mutex_lock(&bcm->mutex);
 	spin_lock_irqsave(&bcm->irq_lock, flags);
 
@@ -312,7 +312,7 @@ static ssize_t txstat_read_file(struct f
 	}
 	spin_unlock_irqrestore(&bcm->irq_lock, flags);
 	mutex_unlock(&bcm->mutex);
-	up(&big_buffer_sem);
+	mutex_unlock(&big_buffer_mutex);
 	return res;
 }
 
@@ -326,7 +326,7 @@ static ssize_t restart_write_file(struct
 	unsigned long flags;
 
 	buf_size = min(count, sizeof (really_big_buffer) - 1);
-	down(&big_buffer_sem);
+	mutex_lock(&big_buffer_mutex);
 	if (copy_from_user(buf, user_buf, buf_size)) {
 	        res = -EFAULT;
 		goto out_up;
@@ -348,7 +348,7 @@ out_unlock:
 	spin_unlock_irqrestore(&(bcm)->irq_lock, flags);
 	mutex_unlock(&(bcm)->mutex);
 out_up:
-	up(&big_buffer_sem);
+	mutex_unlock(&big_buffer_mutex);
 	return res;
 }
 

-- 
