Return-Path: <linux-kernel-owner+w=401wt.eu-S934169AbZIDUPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169AbZIDUPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934160AbZIDUPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:15:09 -0400
Received: from kroah.org ([198.145.64.141]:36335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934120AbZIDUOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:57 2009
Message-Id: <20090904200857.279447289@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: [patch 47/48] SCSI: sr: report more accurate drive status after closing the tray.
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=scsi-sr-report-more-accurate-drive-status-after-closing-the-tray.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Jones <pjones@redhat.com>

commit 96bcc722c47d07b6fd05c9d0cb3ab8ea5574c5b1 upstream

[SCSI] sr: report more accurate drive status after closing the tray.

So, what's happening here is that the drive is reporting a sense of
2/4/1 ("logical unit is becoming ready") from sr_test_unit_ready(), and
then we ask for the media event notification before checking that result
at all.  The check_media_event_descriptor() call isn't getting a check
condition, but it's also reporting that the tray is closed and that
there's no media.  In actuality it doesn't yet know if there's media or
not, but there's no way to express that in the media event status field.

My current thought is that if it told us the device isn't yet ready, we
should return that immediately, since there's nothing that'll tell us
any more data than that reliably:

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

---
 drivers/scsi/sr_ioctl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -309,6 +309,11 @@ int sr_drive_status(struct cdrom_device_
 	if (0 == sr_test_unit_ready(cd->device, &sshdr))
 		return CDS_DISC_OK;
 
+	/* SK/ASC/ASCQ of 2/4/1 means "unit is becoming ready" */
+	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == NOT_READY
+			&& sshdr.asc == 0x04 && sshdr.ascq == 0x01)
+		return CDS_DRIVE_NOT_READY;
+
 	if (!cdrom_get_media_event(cdi, &med)) {
 		if (med.media_present)
 			return CDS_DISC_OK;


