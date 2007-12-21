Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbXLUVPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbXLUVPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758539AbXLUVOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:14:47 -0500
Received: from homer.mvista.com ([63.81.120.158]:45547 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758546AbXLUVOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:14:46 -0500
Message-Id: <20071221205859.316759032@mvista.com>
References: <20071221205854.408865412@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 21 Dec 2007 00:00:04 -0800
Subject: [PATCH 4/4] usb: libusual: locking cleanup
References: <20071221205848.989157559@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, Pete Zaitcev <zaitcev@redhat.com>
Content-Disposition: inline; filename=libusual-locking-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I converted the usu_init_notify semaphore to normal mutex usage, and it 
should still prevent the request_module before the init routine is
complete. Before it acted more like a complete, now the mutex protects
two distinct section from running at the same time..

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/usb/storage/libusual.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6.23/drivers/usb/storage/libusual.c
===================================================================
--- linux-2.6.23.orig/drivers/usb/storage/libusual.c
+++ linux-2.6.23/drivers/usb/storage/libusual.c
@@ -9,6 +9,7 @@
 #include <linux/usb_usual.h>
 #include <linux/vmalloc.h>
 #include <linux/kthread.h>
+#include <linux/mutex.h>
 
 /*
  */
@@ -30,7 +31,7 @@ static atomic_t usu_bias = ATOMIC_INIT(U
 #define BIAS_NAME_SIZE  (sizeof("usb-storage"))
 static const char *bias_names[3] = { "none", "usb-storage", "ub" };
 
-static struct semaphore usu_init_notify;
+static DEFINE_MUTEX(usu_probe_mutex);
 static DECLARE_COMPLETION(usu_end_notify);
 static atomic_t total_threads = ATOMIC_INIT(0);
 
@@ -178,10 +179,7 @@ static int usu_probe_thread(void *arg)
 	int rc;
 	unsigned long flags;
 
-	/* A completion does not work here because it's counted. */
-	down(&usu_init_notify);
-	up(&usu_init_notify);
-
+	mutex_lock(&usu_probe_mutex);
 	rc = request_module(bias_names[type]);
 	spin_lock_irqsave(&usu_lock, flags);
 	if (rc == 0 && (st->fls & USU_MOD_FL_PRESENT) == 0) {
@@ -194,6 +192,7 @@ static int usu_probe_thread(void *arg)
 	}
 	st->fls &= ~USU_MOD_FL_THREAD;
 	spin_unlock_irqrestore(&usu_lock, flags);
+	mutex_unlock(&usu_probe_mutex);
 
 	complete_and_exit(&usu_end_notify, 0);
 }
@@ -204,10 +203,9 @@ static int __init usb_usual_init(void)
 {
 	int rc;
 
-	sema_init(&usu_init_notify, 0);
-
+	mutex_lock(&usu_probe_mutex);
 	rc = usb_register(&usu_driver);
-	up(&usu_init_notify);
+	mutex_unlock(&usu_probe_mutex);
 	return rc;
 }
 

-- 
