Return-Path: <linux-kernel-owner+w=401wt.eu-S1764336AbXJXRJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764336AbXJXRJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761974AbXJXRJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:09:19 -0400
Received: from flatline.sindominio.net ([82.144.4.26]:54095 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761459AbXJXRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:09:18 -0400
Date: Wed, 24 Oct 2007 19:09:25 +0200
From: matthias.kaehlcke@gmail.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: [patch 1/3] MBCS: Convert algolock to mutex
Message-ID: <20071024170925.GI9824@traven>
Mail-Followup-To: matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20071024170049.949862374@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=char-mbcs-algolock-to-mutex
User-Agent: quilt/0.46-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MBCS: Convert the semaphore algolock to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--- kernel.orig/linux-2.6/drivers/char/mbcs.c	2007-10-23 17:37:56.000000000 +0200
+++ kernel/linux-2.6/drivers/char/mbcs.c	2007-10-23 17:40:16.000000000 +0200
@@ -24,6 +24,7 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/uio.h>
+#include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -282,7 +283,7 @@
 	void *mmr_base = soft->mmr_base;
 	union cm_control cm_control;
 
-	if (down_interruptible(&soft->algolock))
+	if (mutex_lock_interruptible(&soft->algolock))
 		return -ERESTARTSYS;
 
 	atomic_set(&soft->algo_done, 0);
@@ -299,7 +300,7 @@
 	cm_control.alg_go = 1;
 	MBCS_MMR_SET(mmr_base, MBCS_CM_CONTROL, cm_control.cm_control_reg);
 
-	up(&soft->algolock);
+	mutex_unlock(&soft->algolock);
 
 	return 0;
 }
@@ -765,7 +766,7 @@
 
 	init_MUTEX(&soft->dmawritelock);
 	init_MUTEX(&soft->dmareadlock);
-	init_MUTEX(&soft->algolock);
+	mutex_init(&soft->algolock);
 
 	mbcs_getdma_init(&soft->getdma);
 	mbcs_putdma_init(&soft->putdma);
Index: kernel/linux-2.6/drivers/char/mbcs.h
===================================================================
--- kernel.orig/linux-2.6/drivers/char/mbcs.h	2007-10-23 17:38:55.000000000 +0200
+++ kernel/linux-2.6/drivers/char/mbcs.h	2007-10-23 17:39:51.000000000 +0200
@@ -539,7 +539,7 @@
 	atomic_t algo_done;
 	struct semaphore dmawritelock;
 	struct semaphore dmareadlock;
-	struct semaphore algolock;
+	struct mutex algolock;
 };
 
 static int mbcs_open(struct inode *ip, struct file *fp);

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
