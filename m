Return-Path: <linux-kernel-owner+w=401wt.eu-S934192AbXEMPxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192AbXEMPxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 11:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbXEMPxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 11:53:42 -0400
Received: from verein.lst.de ([213.95.11.210]:43171 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757798AbXEMPxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 11:53:41 -0400
Date: Sun, 13 May 2007 17:53:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: kraxel@bytesex.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] saa7134-tvaudio: kthread conversion
Message-ID: <20070513155325.GA9567@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/media/video/saa7134/saa7134-tvaudio.c
===================================================================
--- linux-2.6.orig/drivers/media/video/saa7134/saa7134-tvaudio.c	2007-05-13 16:40:49.000000000 +0200
+++ linux-2.6/drivers/media/video/saa7134/saa7134-tvaudio.c	2007-05-13 16:42:23.000000000 +0200
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <asm/div64.h>
@@ -341,10 +342,8 @@ static void tvaudio_setmode(struct saa71
 
 static int tvaudio_sleep(struct saa7134_dev *dev, int timeout)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	add_wait_queue(&dev->thread.wq, &wait);
-	if (dev->thread.scan1 == dev->thread.scan2 && !dev->thread.shutdown) {
+	if (dev->thread.scan1 == dev->thread.scan2 &&
+	    !kthread_should_stop()) {
 		if (timeout < 0) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
@@ -353,7 +352,6 @@ static int tvaudio_sleep(struct saa7134_
 						(msecs_to_jiffies(timeout));
 		}
 	}
-	remove_wait_queue(&dev->thread.wq, &wait);
 	return dev->thread.scan1 != dev->thread.scan2;
 }
 
@@ -505,11 +503,10 @@ static int tvaudio_thread(void *data)
 	unsigned int i, audio, nscan;
 	int max1,max2,carrier,rx,mode,lastmode,default_carrier;
 
-	daemonize("%s", dev->name);
 	allow_signal(SIGTERM);
 	for (;;) {
 		tvaudio_sleep(dev,-1);
-		if (dev->thread.shutdown || signal_pending(current))
+		if (kthread_should_stop() || signal_pending(current))
 			goto done;
 
 	restart:
@@ -618,7 +615,7 @@ static int tvaudio_thread(void *data)
 		for (;;) {
 			if (tvaudio_sleep(dev,5000))
 				goto restart;
-			if (dev->thread.shutdown || signal_pending(current))
+			if (kthread_should_stop() || signal_pending(current))
 				break;
 			if (UNSET == dev->thread.mode) {
 				rx = tvaudio_getstereo(dev,&tvaudio[i]);
@@ -634,7 +631,6 @@ static int tvaudio_thread(void *data)
 	}
 
  done:
-	complete_and_exit(&dev->thread.exit, 0);
 	return 0;
 }
 
@@ -782,7 +778,6 @@ static int tvaudio_thread_ddep(void *dat
 	struct saa7134_dev *dev = data;
 	u32 value, norms, clock;
 
-	daemonize("%s", dev->name);
 	allow_signal(SIGTERM);
 
 	clock = saa7134_boards[dev->board].audio_clock;
@@ -796,7 +791,7 @@ static int tvaudio_thread_ddep(void *dat
 
 	for (;;) {
 		tvaudio_sleep(dev,-1);
-		if (dev->thread.shutdown || signal_pending(current))
+		if (kthread_should_stop() || signal_pending(current))
 			goto done;
 
 	restart:
@@ -876,7 +871,6 @@ static int tvaudio_thread_ddep(void *dat
 	}
 
  done:
-	complete_and_exit(&dev->thread.exit, 0);
 	return 0;
 }
 
@@ -973,7 +967,6 @@ int saa7134_tvaudio_getstereo(struct saa
 
 int saa7134_tvaudio_init2(struct saa7134_dev *dev)
 {
-	DECLARE_MUTEX_LOCKED(sem);
 	int (*my_thread)(void *data) = NULL;
 
 	switch (dev->pci->device) {
@@ -986,15 +979,15 @@ int saa7134_tvaudio_init2(struct saa7134
 		break;
 	}
 
-	dev->thread.pid = -1;
+	dev->thread.thread = NULL;
 	if (my_thread) {
 		/* start tvaudio thread */
-		init_waitqueue_head(&dev->thread.wq);
-		init_completion(&dev->thread.exit);
-		dev->thread.pid = kernel_thread(my_thread,dev,0);
-		if (dev->thread.pid < 0)
+		dev->thread.thread = kthread_run(my_thread, dev, "%s", dev->name);
+		if (IS_ERR(dev->thread.thread)) {
 			printk(KERN_WARNING "%s: kernel_thread() failed\n",
 			       dev->name);
+			/* XXX: missing error handling here */
+		}
 		saa7134_tvaudio_do_scan(dev);
 	}
 
@@ -1004,12 +997,9 @@ int saa7134_tvaudio_init2(struct saa7134
 
 int saa7134_tvaudio_fini(struct saa7134_dev *dev)
 {
-	/* shutdown tvaudio thread */
-	if (dev->thread.pid >= 0) {
-		dev->thread.shutdown = 1;
-		wake_up_interruptible(&dev->thread.wq);
-		wait_for_completion(&dev->thread.exit);
-	}
+	if (dev->thread.thread)
+		kthread_stop(dev->thread.thread);
+
 	saa_andorb(SAA7134_ANALOG_IO_SELECT, 0x07, 0x00); /* LINE1 */
 	return 0;
 }
@@ -1020,10 +1010,10 @@ int saa7134_tvaudio_do_scan(struct saa71
 		dprintk("sound IF not in use, skipping scan\n");
 		dev->automute = 0;
 		saa7134_tvaudio_setmute(dev);
-	} else if (dev->thread.pid >= 0) {
+	} else if (dev->thread.thread) {
 		dev->thread.mode = UNSET;
 		dev->thread.scan2++;
-		wake_up_interruptible(&dev->thread.wq);
+		wake_up_process(dev->thread.thread);
 	} else {
 		dev->automute = 0;
 		saa7134_tvaudio_setmute(dev);
Index: linux-2.6/drivers/media/video/saa7134/saa7134.h
===================================================================
--- linux-2.6.orig/drivers/media/video/saa7134/saa7134.h	2007-05-13 16:40:49.000000000 +0200
+++ linux-2.6/drivers/media/video/saa7134/saa7134.h	2007-05-13 16:41:09.000000000 +0200
@@ -327,10 +327,7 @@ struct saa7134_pgtable {
 
 /* tvaudio thread status */
 struct saa7134_thread {
-	pid_t                      pid;
-	struct completion          exit;
-	wait_queue_head_t          wq;
-	unsigned int               shutdown;
+	struct task_struct	   *thread;
 	unsigned int               scan1;
 	unsigned int               scan2;
 	unsigned int               mode;
