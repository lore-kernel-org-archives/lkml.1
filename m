Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbXJYWar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbXJYWar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXJYWaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:30:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57792 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbXJYWai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:30:38 -0400
From: Maarten Bressers <mbres@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk
Cc: James.Bottomley@SteelEye.com
Cc: tasio@hierro.tasio.net
Cc: dsd@gentoo.org
Subject: [PATCH RESEND] SCSI not showing tray status correctly
Message-Id: <20071025223037.C077D65309@smtp.gentoo.org>
Date: Thu, 25 Oct 2007 22:30:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Martin <tasio@tasio.net>

Greetings,

The following patch was submitted to the lkml in 2004 by David Martin
(http://lkml.org/lkml/2004/12/27/1). It wasn't accepted, but I was
unable to find a reason why, so I'm resending it now.

Without this patch the SCSI ioctl CDROM_DRIVE_STATUS always returns
CDS_TRAY_OPEN even if the tray is closed. This patch fixes that.
Gentoo bug report: http://bugs.gentoo.org/show_bug.cgi?id=196879

Signed-off by: Maarten Bressers <mbres@gentoo.org>

---

--- a/drivers/scsi/sr_ioctl.c	2007-10-09 22:31:38.000000000 +0200
+++ b/drivers/scsi/sr_ioctl.c	2007-10-25 22:57:21.000000000 +0200
@@ -310,6 +310,8 @@ int sr_lock_door(struct cdrom_device_inf
 
 int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 {
+	struct media_event_desc med;
+
 	if (CDSL_CURRENT != slot) {
 		/* we have no changer support */
 		return -EINVAL;
@@ -317,7 +319,10 @@ int sr_drive_status(struct cdrom_device_
 	if (0 == test_unit_ready(cdi->handle))
 		return CDS_DISC_OK;
 
-	return CDS_TRAY_OPEN;
+	if (!cdrom_get_media_event(cdi, &med) && med.door_open)
+		return CDS_TRAY_OPEN;
+
+	return CDS_NO_DISC;
 }
 
 int sr_disk_status(struct cdrom_device_info *cdi)
