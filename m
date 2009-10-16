Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZJPRSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZJPRSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZJPRSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:13 -0400
Received: from kroah.org ([198.145.64.141]:48418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZJPRSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:11 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:47 2009
Message-Id: <20091016171147.260975796@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:09:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [02/46] SCSI: Fix protection scsi_data_buffer leak
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=scsi-fix-protection-scsi_data_buffer-leak.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Martin K. Petersen <martin.petersen@oracle.com>

commit b4c2554d40ceac130a8d062eaa8838ed22158c45 upstream.

We would leak a scsi_data_buffer if the free_list command was of the
protected variety.

Reported-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -241,10 +241,7 @@ scsi_host_alloc_command(struct Scsi_Host
  */
 struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
-	struct scsi_cmnd *cmd;
-	unsigned char *buf;
-
-	cmd = scsi_host_alloc_command(shost, gfp_mask);
+	struct scsi_cmnd *cmd = scsi_host_alloc_command(shost, gfp_mask);
 
 	if (unlikely(!cmd)) {
 		unsigned long flags;
@@ -258,9 +255,15 @@ struct scsi_cmnd *__scsi_get_command(str
 		spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
 		if (cmd) {
+			void *buf, *prot;
+
 			buf = cmd->sense_buffer;
+			prot = cmd->prot_sdb;
+
 			memset(cmd, 0, sizeof(*cmd));
+
 			cmd->sense_buffer = buf;
+			cmd->prot_sdb = prot;
 		}
 	}
 


