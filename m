Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0CBAEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 19:04:36 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2336 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab0CBAEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 19:04:33 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Hugh Daschbach" <hdasch@broadcom.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "Chandra Seetharaman" <sekharan@us.ibm.com>,
       "Eddie Williams" <Eddie.Williams@steeleye.com>
cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Hugh Daschbach" <hdasch@broadcom.com>
Subject: [PATCH] Don't change direction flags in struct request.
Date: Thu, 18 Mar 2010 22:31:30 -0700
Message-ID: <1268976690-3386-2-git-send-email-hdasch@broadcom.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1268976690-3386-1-git-send-email-hdasch@broadcom.com>
References: <1268976690-3386-1-git-send-email-hdasch@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 6792898C38O129518088-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EMC multipath device handler should not change the I/O direction
flags of its trespass command request.

The CFQ elevator may BUG if the direction flags on an I/O request are
changed after allocation.  cfq_set_request() and cfq_put_request()
count READ and WRITE requests separately.  Changing the I/O request
direction after blk_get_request() allocates the request throws off
this CFQ accounting.

Signed-off-by: Hugh Daschbach <hdasch@broadcom.com>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 6196675..3709342 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -269,10 +269,12 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 				unsigned char *buffer)
 {
 	struct request *rq;
+	int mode = READ;
 	int len = 0;
 
-	rq = blk_get_request(sdev->request_queue,
-			(cmd == MODE_SELECT) ? WRITE : READ, GFP_NOIO);
+	if (cmd == MODE_SELECT || cmd == MODE_SELECT_10)
+		mode = WRITE;
+	rq = blk_get_request(sdev->request_queue, mode, GFP_NOIO);
 	if (!rq) {
 		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
 		return NULL;
@@ -284,12 +286,10 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 	switch (cmd) {
 	case MODE_SELECT:
 		len = sizeof(short_trespass);
-		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
 		break;
 	case MODE_SELECT_10:
 		len = sizeof(long_trespass);
-		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
 		break;
 	case INQUIRY:
-- 
1.6.6.196.g1f735


