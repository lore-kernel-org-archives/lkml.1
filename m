Return-Path: <linux-kernel-owner+w=401wt.eu-S1763056AbZJOVPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763056AbZJOVPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbZJOVPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:15:47 -0400
Received: from kroah.org ([198.145.64.141]:43148 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbZJOVPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:15:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct 15 14:10:20 2009
Message-Id: <20091015211020.055924387@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 15 Oct 2009 11:54:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [2/3] SCSI: Fix protection scsi_data_buffer leak
References: <20091015185430.128674330@mini.kroah.org>
Content-Disposition: inline; filename=scsi-fix-protection-scsi_data_buffer-leak.patch
In-Reply-To: <20091015211112.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -243,10 +243,7 @@ scsi_host_alloc_command(struct Scsi_Host
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
@@ -260,9 +257,15 @@ struct scsi_cmnd *__scsi_get_command(str
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
 


