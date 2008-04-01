Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbYDAVpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbYDAVpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYDAVpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:45:47 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:49818 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYDAVpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:45:46 -0400
Date: Tue, 1 Apr 2008 23:45:22 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com
Message-ID: <20080401214522.GL7279@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it> <12048053473401-git-send-email-giometti@linux.it> <20080320130356.69ab65fe.akpm@linux-foundation.org> <20080325144400.GG8959@enneenne.com> <20080327202531.a924e5d9.akpm@linux-foundation.org> <20080401084214.GY7279@enneenne.com> <20080401015555.f267d970.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401015555.f267d970.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/7] LinuxPPS core support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 01:55:55AM -0700, Andrew Morton wrote:
> 
> This can all be handled with suitable locking and refcounting.  The device
> which is delivering PPS interrupts has a reference on the PPS data
> structures.  If userspace has PPS open then it also has a reference.
> 
> The thread of control which releases the last reference to the PPS data
> structures also frees them all up.  This may require a schedule_work() if
> we need to support release-from-interrupt (as it appears that we do), but
> that's OK - we just need to be able to make the PPS data structures
> ineligible for new lookups while the schedule_work() is pending.
> 
> There should be no need for any thread of control to wait for any other thread
> of control to do anything.  Get the refcounting right and everything
> can be done synchronously.

Here my solution by using get/put functions:

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index d75c8c8..61c1569 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -59,6 +59,62 @@ static void pps_add_offset(struct pps_ktime *ts, struct pps_ktime *offset)
  * Exported functions
  */
 
+/* pps_get_source - find a PPS source
+ *
+ * 	source: the PPS source ID.
+ *
+ * This function is used to find an already registered PPS source into the
+ * system.
+ *
+ * The function returns NULL if found nothing, otherwise it returns a pointer
+ * to the PPS source data struct (the refcounter is incremented by 1).
+ */
+
+struct pps_device *pps_get_source(int source)
+{
+	struct pps_device *pps;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pps_idr_lock, flags);
+
+	pps = idr_find(&pps_idr, source);
+	if (pps != NULL)
+		atomic_inc(&pps->usage);
+
+	spin_unlock_irqrestore(&pps_idr_lock, flags);
+
+	return pps;
+}
+
+/* pps_put_source - free the PPS source data
+ *
+ *	pps: a pointer to the PPS source.
+ *
+ * This function is used to free a PPS data struct if its refcount is 0.
+ */
+
+void pps_put_source(struct pps_device *pps)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pps_idr_lock, flags);
+
+        BUG_ON(atomic_read(&pps->usage) == 0);
+
+	if (!atomic_dec_and_test(&pps->usage))
+		goto exit;
+
+	/* No more reference to the PPS source. We can safely remove the
+	 * PPS data struct.
+	 */
+	idr_remove(&pps_idr, pps->id);
+
+	kfree(pps);
+
+exit:
+	spin_unlock_irqrestore(&pps_idr_lock, flags);
+}
+
 /* pps_register_source - add a PPS source in the system
  *
  *	info: the PPS info struct
@@ -133,8 +189,7 @@ int pps_register_source(struct pps_source_info *info, int default_params)
 
 	init_waitqueue_head(&pps->queue);
 	spin_lock_init(&pps->lock);
-	atomic_set(&pps->usage, 0);
-	init_waitqueue_head(&pps->usage_queue);
+	atomic_set(&pps->usage, 1);
 
 	/* Create the char device */
 	err = pps_register_cdev(pps);
@@ -179,21 +234,14 @@ void pps_unregister_source(int source)
 	pps = idr_find(&pps_idr, source);
 
 	if (!pps) {
+		BUG();
 		spin_unlock_irq(&pps_idr_lock);
 		return;
 	}
-
-	/* This should be done first in order to deny IRQ handlers
-	 * to access PPS structs
-	 */
-
-	idr_remove(&pps_idr, pps->id);
 	spin_unlock_irq(&pps_idr_lock);
 
-	wait_event(pps->usage_queue, atomic_read(&pps->usage) == 0);
-
 	pps_unregister_cdev(pps);
-	kfree(pps);
+	pps_put_source(pps);
 }
 EXPORT_SYMBOL(pps_unregister_source);
 
@@ -231,16 +279,7 @@ void pps_event(int source, int event, void *data)
 		return;
 	}
 
-	spin_lock_irqsave(&pps_idr_lock, flags);
-	pps = idr_find(&pps_idr, source);
-
-	/* If we find a valid PPS source we lock it before leaving
-	 * the lock!
-	 */
-	if (pps)
-		atomic_inc(&pps->usage);
-	spin_unlock_irqrestore(&pps_idr_lock, flags);
-
+	pps = pps_get_source(source);
 	if (!pps)
 		return;
 
@@ -286,9 +325,6 @@ void pps_event(int source, int event, void *data)
 	spin_unlock_irqrestore(&pps->lock, flags);
 
 	/* Now we can release the PPS source for (possible) deregistration */
-	spin_lock_irqsave(&pps_idr_lock, flags);
-	atomic_dec(&pps->usage);
-	wake_up_all(&pps->usage_queue);
-	spin_unlock_irqrestore(&pps_idr_lock, flags);
+	pps_put_source(pps);
 }
 EXPORT_SYMBOL(pps_event);
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 5cbfeb9..a46f8f4 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -214,15 +214,7 @@ static int pps_cdev_open(struct inode *inode, struct file *file)
 						struct pps_device, cdev);
 	int found;
 
-	spin_lock_irq(&pps_idr_lock);
-	found = idr_find(&pps_idr, pps->id) != NULL;
-
-	/* Lock the PPS source against (possible) deregistration */
-	if (found)
-		atomic_inc(&pps->usage);
-
-	spin_unlock_irq(&pps_idr_lock);
-
+	found = pps_get_source(pps->id) != 0;
 	if (!found)
 		return -ENODEV;
 
@@ -236,8 +228,7 @@ static int pps_cdev_release(struct inode *inode, struct file *file)
 	struct pps_device *pps = file->private_data;
 
 	/* Free the PPS source and wake up (possible) deregistration */
-	atomic_dec(&pps->usage);
-	wake_up_all(&pps->usage_queue);
+	pps_put_source(pps);
 
 	return 0;
 }
diff --git a/include/linux/pps.h b/include/linux/pps.h
index aca0e77..e23aaa6 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -173,7 +173,6 @@ struct pps_device {
 	spinlock_t lock;
 
 	atomic_t usage;				/* usage count */
-	wait_queue_head_t usage_queue;
 };
 
 /*
@@ -189,6 +188,8 @@ extern struct device_attribute pps_attrs[];
  * Exported functions
  */
 
+struct pps_device *pps_get_source(int source);
+extern void pps_put_source(struct pps_device *pps);
 extern int pps_register_source(struct pps_source_info *info,
 				int default_params);
 extern void pps_unregister_source(int source);


I'll send a new patchset ASAP!

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
