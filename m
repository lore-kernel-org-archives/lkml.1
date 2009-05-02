Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZEBCa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZEBCa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 22:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZEBCaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 22:30:04 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:28493 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZEBCaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 22:30:00 -0400
X-IronPort-AV: E=Sophos;i="4.40,281,1238976000"; 
   d="scan'208";a="158433888"
Date: Fri, 1 May 2009 19:30:00 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-usb@vger.kernel.org, greg@kroah.com,
       linux-scsi@vger.kernel.org, netdev@vger.kernel.org, arjan@infradead.org
Subject: [PATCH 5/5] initdev:kernel: USB and SCSI block init device
	notification, v3
Message-ID: <20090502023000.GA16076@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu

Add notification of device discovery for USB and SCSI block devices.

History
v3	Change bootdev_* to initdev_*
v2	Correct location of call to bootdev_found
v1	Initial version

Signed-off-by: Alan Stern <stern@rowland.harvard.edu
Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 drivers/scsi/scsi_scan.c  |    2 ++
 drivers/usb/storage/usb.c |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6f51ca4..735b061 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1834,6 +1834,7 @@ static int do_scan_async(void *_data)
 	struct async_scan_data *data = _data;
 	do_scsi_scan_host(data->shost);
 	scsi_finish_async_scan(data);
+	initdev_probe_done(BOOTDEV_BLOCK_MASK);
 	return 0;
 }
 
@@ -1855,6 +1856,7 @@ void scsi_scan_host(struct Scsi_Host *shost)
 		return;
 	}
 
+	initdev_found(BOOTDEV_BLOCK_MASK);
 	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
 	if (IS_ERR(p))
 		do_scan_async(data);
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 8060b85..ea7abab 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -837,6 +837,7 @@ static int usb_stor_scan_thread(void * __us)
 		/* Should we unbind if no devices were detected? */
 	}
 
+	initdev_probe_done(BOOTDEV_BLOCK_MASK);
 	complete_and_exit(&us->scanning_done, 0);
 }
 
@@ -937,10 +938,12 @@ int usb_stor_probe2(struct us_data *us)
 	}
 
 	/* Start up the thread for delayed SCSI-device scanning */
+	initdev_found(BOOTDEV_BLOCK_MASK);
 	th = kthread_create(usb_stor_scan_thread, us, "usb-stor-scan");
 	if (IS_ERR(th)) {
 		printk(KERN_WARNING USB_STORAGE 
 		       "Unable to start the device-scanning thread\n");
+		initdev_probe_done(BOOTDEV_BLOCK_MASK);
 		complete(&us->scanning_done);
 		quiesce_and_remove_host(us);
 		result = PTR_ERR(th);
