Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYJDSNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYJDSNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 14:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYJDSN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 14:13:28 -0400
Received: from smtp01.zero.jp ([210.157.5.231]:17722 "EHLO smtp.zero.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753603AbYJDSN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 14:13:27 -0400
Date: Sat, 04 Oct 2008 14:11:06 -0400 (EDT)
Message-Id: <20081004.141106.07644919.k-ueda@ct.jp.nec.com>
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 1/2] scsi: refactor sdev/starget/shost busy checking
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20081004.140350.74754456.k-ueda@ct.jp.nec.com>
References: <20081004.140350.74754456.k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactors the busy checking codes of scsi_device,
Scsi_Host and scsi_target.  There should be no functional change.

This is a preparation for another patch which exports scsi's busy
state to the block layer for request stacking drivers.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_lib.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

Index: scsi-post-merge-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-post-merge-2.6.orig/drivers/scsi/scsi_lib.c
+++ scsi-post-merge-2.6/drivers/scsi/scsi_lib.c
@@ -529,6 +529,14 @@ static void scsi_single_lun_run(struct s
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
+static inline int scsi_device_is_busy(struct scsi_device *sdev)
+{
+	if (sdev->device_busy >= sdev->queue_depth || sdev->device_blocked)
+		return 1;
+
+	return 0;
+}
+
 static inline int scsi_target_is_busy(struct scsi_target *starget)
 {
 	return ((starget->can_queue > 0 &&
@@ -536,6 +544,15 @@ static inline int scsi_target_is_busy(st
 		 starget->target_blocked);
 }
 
+static inline int scsi_host_is_busy(struct Scsi_Host *shost)
+{
+	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
+	    shost->host_blocked || shost->host_self_blocked)
+		return 1;
+
+	return 0;
+}
+
 /*
  * Function:	scsi_run_queue()
  *
@@ -558,11 +575,7 @@ static void scsi_run_queue(struct reques
 		scsi_single_lun_run(sdev);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	while (!list_empty(&shost->starved_list) &&
-	       !shost->host_blocked && !shost->host_self_blocked &&
-		!((shost->can_queue > 0) &&
-		  (shost->host_busy >= shost->can_queue))) {
-
+	while (!list_empty(&shost->starved_list) && !scsi_host_is_busy(shost)) {
 		int flagset;
 
 		/*
@@ -1348,8 +1361,6 @@ int scsi_prep_fn(struct request_queue *q
 static inline int scsi_dev_queue_ready(struct request_queue *q,
 				  struct scsi_device *sdev)
 {
-	if (sdev->device_busy >= sdev->queue_depth)
-		return 0;
 	if (sdev->device_busy == 0 && sdev->device_blocked) {
 		/*
 		 * unblock after device_blocked iterates to zero
@@ -1363,7 +1374,7 @@ static inline int scsi_dev_queue_ready(s
 			return 0;
 		}
 	}
-	if (sdev->device_blocked)
+	if (scsi_device_is_busy(sdev))
 		return 0;
 
 	return 1;
@@ -1440,8 +1451,7 @@ static inline int scsi_host_queue_ready(
 			return 0;
 		}
 	}
-	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
-	    shost->host_blocked || shost->host_self_blocked) {
+	if (scsi_host_is_busy(shost)) {
 		if (list_empty(&sdev->starved_entry))
 			list_add_tail(&sdev->starved_entry, &shost->starved_list);
 		return 0;
