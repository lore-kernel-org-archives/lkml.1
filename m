Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbXBDQMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbXBDQMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 11:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXBDQMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 11:12:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:33878 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbXBDQMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 11:12:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=O6VKDKSotQqoNwC1HcZM4ccziSCMc0GkyaBJzXu7a6qlmoYU2Fi1Qoo1REyLzijMrYbkYURbswjIci2yUfzI7triIWalK8f9GD15RbPvKyeshIlU/1w6IC3coHigFrXYISgWQhy7DwqGrUcHKOLz8SYrG+PAG5OlsYx95VHI3RY=
Date: Sun, 4 Feb 2007 17:12:09 +0100
From: Miguel Ojeda <maxextreme@gmail.com>
To: dwalker@mvista.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: crash on CONFIG_CFAG12864B=y in 2.6.20-rc3-mm1
Message-Id: <20070204171209.f9cc9cbf.maxextreme@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here it is the patch, just a draft.

I have checked the Makefile to ensure that ks0108 was being called before than cfag12864b at boot, still, I'm not sure and I don't know if this will prevent the crash if ks0108 fails to init.

Daniel, please test it.

drivers-add-lcd-support-update10.patch.draft
Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
---
diff --git a/drivers/auxdisplay/cfag12864b.c b/drivers/auxdisplay/cfag12864b.c
index 889583d..cb44cb4 100644
--- a/drivers/auxdisplay/cfag12864b.c
+++ b/drivers/auxdisplay/cfag12864b.c
@@ -312,6 +312,17 @@ EXPORT_SYMBOL_GPL(cfag12864b_disable);
 EXPORT_SYMBOL_GPL(cfag12864b_isenabled);
 
 /*
+ * Is the module inited?
+ */
+
+static unsigned char cfag12864b_inited;
+unsigned char cfag12864b_isinited(void)
+{
+	return cfag12864b_inited;
+}
+EXPORT_SYMBOL_GPL(cfag12864b_isinited);
+
+/*
  * Module Init & Exit
  */
 
@@ -319,6 +330,13 @@ static int __init cfag12864b_init(void)
 {
 	int ret = -EINVAL;
 
+	/* ks0108_init() must be called first */
+	if (!ks0108_isinited()) {
+		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
+			"ks0108 is not initialized\n");
+		goto none;
+	}
+
 	if (PAGE_SIZE < CFAG12864B_SIZE) {
 		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
 			"page size (%i) < cfag12864b size (%i)\n",
@@ -354,6 +372,7 @@ static int __init cfag12864b_init(void)
 	cfag12864b_clear();
 	cfag12864b_on();
 
+	cfag12864b_inited = 1;
 	return 0;
 
 cachealloced:
diff --git a/drivers/auxdisplay/cfag12864bfb.c b/drivers/auxdisplay/cfag12864bfb.c
index 94765e7..66fafbb 100644
--- a/drivers/auxdisplay/cfag12864bfb.c
+++ b/drivers/auxdisplay/cfag12864bfb.c
@@ -137,7 +137,14 @@ static struct platform_device *cfag12864
 
 static int __init cfag12864bfb_init(void)
 {
-	int ret;
+	int ret = -EINVAL;
+
+	/* cfag12864b_init() must be called first */
+	if (!cfag12864b_isinited()) {
+		printk(KERN_ERR CFAG12864BFB_NAME ": ERROR: "
+			"cfag12864b is not initialized\n");
+		goto none;
+	}
 
 	if (cfag12864b_enable()) {
 		printk(KERN_ERR CFAG12864BFB_NAME ": ERROR: "
@@ -162,6 +169,7 @@ static int __init cfag12864bfb_init(void
 		}
 	}
 
+none:
 	return ret;
 }
 
diff --git a/drivers/auxdisplay/ks0108.c b/drivers/auxdisplay/ks0108.c
index a637575..e6c3646 100644
--- a/drivers/auxdisplay/ks0108.c
+++ b/drivers/auxdisplay/ks0108.c
@@ -111,6 +111,17 @@ EXPORT_SYMBOL_GPL(ks0108_address);
 EXPORT_SYMBOL_GPL(ks0108_page);
 
 /*
+ * Is the module inited?
+ */
+
+static unsigned char ks0108_inited;
+unsigned char ks0108_isinited(void)
+{
+	return ks0108_inited;
+}
+EXPORT_SYMBOL_GPL(ks0108_isinited);
+
+/*
  * Module Init & Exit
  */
 
@@ -142,6 +153,7 @@ static int __init ks0108_init(void)
 		goto registered;
 	}
 
+	ks0108_inited = 1;
 	return 0;
 
 registered:
diff --git a/include/linux/cfag12864b.h b/include/linux/cfag12864b.h
index 0bc45e6..1605dd8 100644
--- a/include/linux/cfag12864b.h
+++ b/include/linux/cfag12864b.h
@@ -73,5 +73,10 @@ extern void cfag12864b_disable(void);
  */
 extern unsigned char cfag12864b_isenabled(void);
 
+/*
+ * Is the module inited?
+ */
+extern unsigned char cfag12864b_isinited(void);
+
 #endif /* _CFAG12864B_H_ */
 
diff --git a/include/linux/ks0108.h b/include/linux/ks0108.h
index 8047d4b..a2c54ac 100644
--- a/include/linux/ks0108.h
+++ b/include/linux/ks0108.h
@@ -43,4 +43,7 @@ extern void ks0108_address(unsigned char
 /* Set the controller's current page (0..7) */
 extern void ks0108_page(unsigned char page);
 
+/* Is the module inited? */
+extern unsigned char ks0108_isinited(void);
+
 #endif /* _KS0108_H_ */
