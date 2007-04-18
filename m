Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbXDRVrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbXDRVrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbXDRVrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:47:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbXDRVrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:47:01 -0400
Date: Wed, 18 Apr 2007 17:48:07 -0400
From: Josef Bacik <jwhiter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] fix for async scsi scan sysfs problem
Message-ID: <20070418214805.GA1481@korben.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm having a problem on the newest version of linus's git tree with my qla2xxx
card.  This is on a UP box, the problem doesn't happen on my similarly
configured SMP box.  When I unload and then try to load the qla2xxx driver again
I get this message

kobject_add failed for 3:0:0:0 with -EEXIST, don't try to register
things with the same name in the same directory.
 [<c0405ea6>] show_trace_log_lvl+0x1a/0x2f
 [<c0406456>] show_trace+0x12/0x14
 [<c04064d1>] dump_stack+0x16/0x18
 [<c04e6e86>] kobject_shadow_add+0xcd/0x1df
 [<c04e6fa2>] kobject_add+0xa/0xc
 [<c0557ae1>] device_add+0xab/0x62e
 [<d0873a0f>] scsi_sysfs_add_sdev+0x2d/0x1eb [scsi_mod]
 [<d0871db8>] scsi_probe_and_add_lun+0x974/0xaa5 [scsi_mod]
 [<d087240a>] __scsi_scan_target+0xc0/0x5f1 [scsi_mod]
 [<d0872ec5>] scsi_scan_target+0x97/0xa6 [scsi_mod]
 [<d08b1c34>] fc_scsi_scan_rport+0x5a/0x76 [scsi_transport_fc]
 [<c0435f33>] run_workqueue+0x89/0x14e
 [<c0436949>] worker_thread+0xf8/0x124
 [<c043911b>] kthread+0xb3/0xdc
 [<c0405b4f>] kernel_thread_helper+0x7/0x10
 =======================

I traced this down to the async scanning doing a kobject_add for that object,
the backtrace below shows the path we took to add it.

 [<c0405ea6>] show_trace_log_lvl+0x1a/0x2f
 [<c0406456>] show_trace+0x12/0x14
 [<c04064d1>] dump_stack+0x16/0x18
 [<c04e6e86>] kobject_shadow_add+0xcd/0x1df
 [<c04e6fa2>] kobject_add+0xa/0xc
 [<c055a45c>] class_device_add+0x9e/0x3ad
 [<d0873a3c>] scsi_sysfs_add_sdev+0x5a/0x1eb [scsi_mod]
 [<d0872cd4>] do_scan_async+0x62/0xf8 [scsi_mod]
 [<c043911b>] kthread+0xb3/0xdc
 [<c0405b4f>] kernel_thread_helper+0x7/0x10
 =======================

Looking through everything I came to the conclusion that we don't really need
the scsi_sysfs_add_devices in scsi_finish_async_scan, which gets run everytime
we do a do_scan_async.  In doing the scanning, if we come upon anything we will
already be registering the device with sysfs so the scsi_sysfs_add_devices step
is kind of useless.  I tested this and it worked fine on my UP box (where the
problem was happening) and my SMP box (where the problem wasn't happening).  Now
I'm not entirely sure if this is correct, but I'm attaching the patch that I
used to fix it for me, please point out if I've done something wrong or if there
is a different way this needs to be fixed.  Thank you,

Josef

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0949145..2c8527b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1661,15 +1661,6 @@ int scsi_scan_host_selected(struct Scsi_
 	return 0;
 }
 
-static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
-{
-	struct scsi_device *sdev;
-	shost_for_each_device(sdev, shost) {
-		if (scsi_sysfs_add_sdev(sdev) != 0)
-			scsi_destroy_sdev(sdev);
-	}
-}
-
 /**
  * scsi_prep_async_scan - prepare for an async scan
  * @shost: the host which will be scanned
@@ -1741,8 +1732,6 @@ static void scsi_finish_async_scan(struc
 
 	wait_for_completion(&data->prev_finished);
 
-	scsi_sysfs_add_devices(shost);
-
 	spin_lock(&async_scan_lock);
 	shost->async_scan = 0;
 	list_del(&data->list);
