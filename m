Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935911Ab0CMAyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:54:38 -0500
Received: from kroah.org ([198.145.64.141]:46934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935430Ab0CMAbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:36 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:10 2010
Message-Id: <20100313002710.482763927@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [060/145] SCSI: qla1280: Drop host_lock while requesting firmware
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Ben Hutchings <ben@decadent.org.uk>

commit 2cec802980727f1daa46d8c31b411e083d49d7a2 upstream.

request_firmware() may sleep and it appears to be safe to release the
spinlock here.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla1280.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1640,8 +1640,10 @@ qla1280_load_firmware_pio(struct scsi_ql
 	uint16_t mb[MAILBOX_REGISTER_COUNT], i;
 	int err;
 
+	spin_unlock_irq(ha->host->host_lock);
 	err = request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
 			       &ha->pdev->dev);
+	spin_lock_irq(ha->host->host_lock);
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       ql1280_board_tbl[ha->devnum].fwname, err);
@@ -1699,8 +1701,10 @@ qla1280_load_firmware_dma(struct scsi_ql
 		return -ENOMEM;
 #endif
 
+	spin_unlock_irq(ha->host->host_lock);
 	err = request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
 			       &ha->pdev->dev);
+	spin_lock_irq(ha->host->host_lock);
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       ql1280_board_tbl[ha->devnum].fwname, err);


