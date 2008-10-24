Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbYJXGF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbYJXGF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 02:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYJXGFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 02:05:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:57110 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYJXGFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 02:05:15 -0400
Message-ID: <49016599.5030406@suse.de>
Date: Fri, 24 Oct 2008 08:05:13 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Michael Holzheu <HOLZHEU@de.ibm.com>
Subject: [PATCH] DASD: send 'change' uevents
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------080002030203080504050806"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080002030203080504050806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi Martin,

this patch modifies the DASD driver to sent out 'change' events
whenever the internal state machine transitions in or out of the
'ready' state. This is required for udev so that vol_id and friends
can actually read from the disk.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------080002030203080504050806
Content-Type: text/plain;
 name="dasd-send-change-events"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dasd-send-change-events"

DASD: Send 'change' uevents

A DASD is only useable after the internal state machine transitioned
to 'ready', way after the device has been added to sysfs.
So we need to send out a 'change' event here to notify udev.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 0a225cc..447fcdc 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -335,7 +335,9 @@ static int dasd_state_unfmt_to_basic(struct dasd_device *device)
 static int
 dasd_state_ready_to_online(struct dasd_device * device)
 {
-	int rc;
+	int rc, i;
+	struct gendisk *disk = device->bdev->bd_disk;
+	struct hd_struct *p;
 
 	if (device->discipline->ready_to_online) {
 		rc = device->discipline->ready_to_online(device);
@@ -345,6 +347,15 @@ dasd_state_ready_to_online(struct dasd_device * device)
 	device->state = DASD_STATE_ONLINE;
 	if (device->block)
 		dasd_schedule_block_bh(device->block);
+
+	kobject_uevent(&disk->kobj, KOBJ_CHANGE);
+	/* send uevents for all partitions */
+	for (i = 1; i < disk->minors; i++) {
+		p = disk->part[i-1];
+		if (!p || !p->nr_sects)
+			continue;
+		kobject_uevent(&p->kobj, KOBJ_CHANGE);
+	}
 	return 0;
 }
 
@@ -353,7 +364,9 @@ dasd_state_ready_to_online(struct dasd_device * device)
  */
 static int dasd_state_online_to_ready(struct dasd_device *device)
 {
-	int rc;
+	int rc, i;
+	struct gendisk *disk = device->bdev->bd_disk;
+	struct hd_struct *p;
 
 	if (device->discipline->online_to_ready) {
 		rc = device->discipline->online_to_ready(device);
@@ -361,6 +374,14 @@ static int dasd_state_online_to_ready(struct dasd_device *device)
 			return rc;
 	}
 	device->state = DASD_STATE_READY;
+	/* send uevents for all partitions */
+	for (i = 1; i < disk->minors; i++) {
+		p = disk->part[i-1];
+		if (!p || !p->nr_sects)
+			continue;
+		kobject_uevent(&p->kobj, KOBJ_CHANGE);
+	}
+	kobject_uevent(&disk->kobj, KOBJ_CHANGE);
 	return 0;
 }
 

--------------080002030203080504050806--
