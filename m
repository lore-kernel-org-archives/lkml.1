Return-Path: <linux-kernel-owner+w=401wt.eu-S1760998AbXGCSJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbXGCSJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 14:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbXGCSJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 14:09:46 -0400
Received: from mail0.lsil.com ([147.145.40.20]:52344 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbXGCSJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 14:09:44 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/5] use mutex instead of semaphore in Megaraid Mailbox driver
Date: Tue, 3 Jul 2007 12:09:05 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229B88A44@NAMAIL2.ad.lsil.com>
In-Reply-To: <20070701162921.GD3940@traven>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/5] use mutex instead of semaphore in Megaraid Mailbox driver
Thread-Index: Ace7/Nx+sjzvyO+wS0S/0uF61CcWPwBoDz7Q
From: "Patro, Sumant" <Sumant.Patro@lsi.com>
To: "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>,
       "DL-MegaRAID Linux" <megaraidlinux@lsi.com>,
       <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
X-OriginalArrivalTime: 03 Jul 2007 18:09:06.0854 (UTC) FILETIME=[3F0ADC60:01C7BD9D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you Matthias for the patch.

Regards,

Sumant

-----Original Message-----
From: Matthias Kaehlcke [mailto:matthias.kaehlcke@gmail.com] 
Sent: Sunday, July 01, 2007 9:29 AM
To: DL-MegaRAID Linux; linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org; akpm@linux-foundation.org
Subject: [PATCH 1/5] use mutex instead of semaphore in Megaraid Mailbox
driver

The Megaraid Mailbox driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/scsi/megaraid/mega_common.h
b/drivers/scsi/megaraid/mega_common.h
index 26e1e6c..fef9ac9 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -21,6 +21,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c
b/drivers/scsi/megaraid/megaraid_mbox.c
index 04d0b69..2cecc64 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -3957,7 +3957,7 @@ megaraid_sysfs_alloc_resources(adapter_t *adapter)
 		megaraid_sysfs_free_resources(adapter);
 	}
 
-	sema_init(&raid_dev->sysfs_sem, 1);
+	mutex_init(&raid_dev->sysfs_mtx);
 
 	init_waitqueue_head(&raid_dev->sysfs_wait_q);
 
@@ -4058,7 +4058,7 @@ megaraid_sysfs_get_ldmap(adapter_t *adapter)
 	/*
 	 * Allow only one read at a time to go through the sysfs
attributes
 	 */
-	down(&raid_dev->sysfs_sem);
+	mutex_lock(&raid_dev->sysfs_mtx);
 
 	uioc	= raid_dev->sysfs_uioc;
 	mbox64	= raid_dev->sysfs_mbox64;
@@ -4134,7 +4134,7 @@ megaraid_sysfs_get_ldmap(adapter_t *adapter)
 
 	del_timer_sync(timerp);
 
-	up(&raid_dev->sysfs_sem);
+	mutex_unlock(&raid_dev->sysfs_mtx);
 
 	return rval;
 }
diff --git a/drivers/scsi/megaraid/megaraid_mbox.h
b/drivers/scsi/megaraid/megaraid_mbox.h
index 9de803c..626459d 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.h
+++ b/drivers/scsi/megaraid/megaraid_mbox.h
@@ -168,7 +168,7 @@ typedef struct {
  * @hw_error			: set if FW not responding
  * @fast_load			: If set, skip physical device scanning
  * @channel_class		: channel class, RAID or SCSI
- * @sysfs_sem			: semaphore to serialize access to sysfs
res.
+ * @sysfs_mtx			: mutex to serialize access to sysfs
res.
  * @sysfs_uioc			: management packet to issue FW calls
from sysfs
  * @sysfs_mbox64		: mailbox packet to issue FW calls from
sysfs
  * @sysfs_buffer		: data buffer for FW commands issued
from sysfs
@@ -208,7 +208,7 @@ typedef struct {
 	int				hw_error;
 	int				fast_load;
 	uint8_t				channel_class;
-	struct semaphore		sysfs_sem;
+	struct mutex			sysfs_mtx;
 	uioc_t				*sysfs_uioc;
 	mbox64_t			*sysfs_mbox64;
 	caddr_t				sysfs_buffer;

--
Matthias Kaehlcke
Linux Application Developer
Barcelona

         An ounce of practice is worth more than tons of preaching
                            (Mahatma Gandhi)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
