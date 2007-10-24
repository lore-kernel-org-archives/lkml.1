Return-Path: <linux-kernel-owner+w=401wt.eu-S1764852AbXJXRKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764852AbXJXRKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764457AbXJXRJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:09:47 -0400
Received: from flatline.sindominio.net ([82.144.4.26]:54184 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764445AbXJXRJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:09:46 -0400
Date: Wed, 24 Oct 2007 19:09:52 +0200
From: matthias.kaehlcke@gmail.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: [patch 3/3] MBCS: Convert dmareadlock to mutex
Message-ID: <20071024170952.GK9824@traven>
Mail-Followup-To: matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20071024170049.949862374@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=char-mbcs-dmareadlock-to-mutex
User-Agent: quilt/0.46-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MBCS: Convert the semaphore dmareadlock to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--- kernel.orig/linux-2.6/drivers/char/mbcs.c	2007-10-23 17:43:36.000000000 +0200
+++ kernel/linux-2.6/drivers/char/mbcs.c	2007-10-23 17:44:11.000000000 +0200
@@ -348,7 +348,7 @@
 {
 	int rv = 0;
 
-	if (down_interruptible(&soft->dmareadlock))
+	if (mutex_lock_interruptible(&soft->dmareadlock))
 		return -ERESTARTSYS;
 
 	atomic_set(&soft->dmawrite_done, 0);
@@ -373,7 +373,7 @@
 	*off += len;
 
 dmaread_exit:
-	up(&soft->dmareadlock);
+	mutex_unlock(&soft->dmareadlock);
 
 	return rv;
 }
@@ -765,7 +765,7 @@
 	init_waitqueue_head(&soft->algo_queue);
 
 	mutex_init(&soft->dmawritelock);
-	init_MUTEX(&soft->dmareadlock);
+	mutex_init(&soft->dmareadlock);
 	mutex_init(&soft->algolock);
 
 	mbcs_getdma_init(&soft->getdma);
Index: kernel/linux-2.6/drivers/char/mbcs.h
===================================================================
--- kernel.orig/linux-2.6/drivers/char/mbcs.h	2007-10-23 17:43:38.000000000 +0200
+++ kernel/linux-2.6/drivers/char/mbcs.h	2007-10-23 17:44:33.000000000 +0200
@@ -538,7 +538,7 @@
 	atomic_t dmaread_done;
 	atomic_t algo_done;
 	struct mutex dmawritelock;
-	struct semaphore dmareadlock;
+	struct mutex dmareadlock;
 	struct mutex algolock;
 };
 

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
