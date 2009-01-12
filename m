Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbZALG5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbZALG5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 01:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZALG4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 01:56:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:21383 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbZALG4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:56:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,251,1231142400"; 
   d="scan'208";a="421533704"
Subject: [PATCH 3/3]async sd shutdown
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 14:56:46 +0800
Message-Id: <1231743406.5867.52.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sd shutdown is quite slow. It sometimes will take about 1s for shutdown.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/scsi/sd.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

Index: linux/drivers/scsi/sd.c
===================================================================
--- linux.orig/drivers/scsi/sd.c	2009-01-12 14:38:05.000000000 +0800
+++ linux/drivers/scsi/sd.c	2009-01-12 14:41:31.000000000 +0800
@@ -98,6 +98,7 @@ static int  sd_revalidate_disk(struct ge
 static int  sd_probe(struct device *);
 static int  sd_remove(struct device *);
 static void sd_shutdown(struct device *);
+static void sd_sync_shutdown(struct device *);
 static int sd_suspend(struct device *, pm_message_t state);
 static int sd_resume(struct device *);
 static void sd_rescan(struct device *);
@@ -1962,7 +1963,7 @@ static int sd_remove(struct device *dev)
 
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
-	sd_shutdown(dev);
+	sd_sync_shutdown(dev);
 
 	mutex_lock(&sd_ref_mutex);
 	dev_set_drvdata(dev, NULL);
@@ -2028,8 +2029,9 @@ static int sd_start_stop_device(struct s
  * the normal SCSI command structure.  Wait for the command to
  * complete.
  */
-static void sd_shutdown(struct device *dev)
+static void sd_async_shutdown(void *data, async_cookie_t cookie)
 {
+	struct device *dev = data;
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 
 	if (!sdkp)
@@ -2048,6 +2050,17 @@ static void sd_shutdown(struct device *d
 	scsi_disk_put(sdkp);
 }
 
+static void sd_shutdown(struct device *dev)
+{
+	async_schedule(sd_async_shutdown, dev);
+}
+
+static void sd_sync_shutdown(struct device *dev)
+{
+	async_cookie_t cookie = async_schedule(sd_async_shutdown, dev);
+	async_synchronize_cookie(cookie);
+}
+
 static int sd_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);


