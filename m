Return-Path: <linux-kernel-owner+w=401wt.eu-S1764682AbXJXRJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764682AbXJXRJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763464AbXJXRJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:09:32 -0400
Received: from flatline.sindominio.net ([82.144.4.26]:54135 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763041AbXJXRJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:09:31 -0400
Date: Wed, 24 Oct 2007 19:09:33 +0200
From: matthias.kaehlcke@gmail.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: [patch 2/3] MBCS: Convert dmawritelock to mutex
Message-ID: <20071024170933.GJ9824@traven>
Mail-Followup-To: matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20071024170049.949862374@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=char-mbcs-dmawritelock-to-mutex
User-Agent: quilt/0.46-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MBCS: Convert the semaphore dmawritelock to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Index: kernel/linux-2.6/drivers/char/mbcs.h
===================================================================
--- kernel.orig/linux-2.6/drivers/char/mbcs.h	2007-10-23 17:50:50.000000000 +0200
+++ kernel/linux-2.6/drivers/char/mbcs.h	2007-10-24 17:02:12.000000000 +0200
@@ -537,7 +537,7 @@
 	atomic_t dmawrite_done;
 	atomic_t dmaread_done;
 	atomic_t algo_done;
-	struct semaphore dmawritelock;
+	struct mutex dmawritelock;
 	struct semaphore dmareadlock;
 	struct mutex algolock;
 };
Index: kernel/linux-2.6/drivers/char/mbcs.c
===================================================================
--- kernel.orig/linux-2.6/drivers/char/mbcs.c	2007-10-23 17:50:50.000000000 +0200
+++ kernel/linux-2.6/drivers/char/mbcs.c	2007-10-24 17:02:12.000000000 +0200
@@ -311,7 +311,7 @@
 {
 	int rv = 0;
 
-	if (down_interruptible(&soft->dmawritelock))
+	if (mutex_lock_interruptible(&soft->dmawritelock))
 		return -ERESTARTSYS;
 
 	atomic_set(&soft->dmawrite_done, 0);
@@ -337,7 +337,7 @@
 	*off += len;
 
 dmawrite_exit:
-	up(&soft->dmawritelock);
+	mutex_unlock(&soft->dmawritelock);
 
 	return rv;
 }
@@ -764,7 +764,7 @@
 	init_waitqueue_head(&soft->dmaread_queue);
 	init_waitqueue_head(&soft->algo_queue);
 
-	init_MUTEX(&soft->dmawritelock);
+	mutex_init(&soft->dmawritelock);
 	init_MUTEX(&soft->dmareadlock);
 	mutex_init(&soft->algolock);
 

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
