Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462Ab0AZXzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab0AZXzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663Ab0AZXnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:49 -0500
Received: from kroah.org ([198.145.64.141]:35344 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab0AZXno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:27 2010
Message-Id: <20100126233927.583402057@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [51/98] [SCSI] fcoe, libfc: fix an libfc issue with queue ramp down in libfc
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasu Dev <vasu.dev@intel.com>

commit 14caf44c69184ed72d46a2f883311daf27a4192f upstream.

The cmd_per_lun value is used by scsi-ml as fall back lowest
queue_depth value but in case of libfc cmd_per_lun is set to
same value as max queue_depth = 32.

So this patch reduces cmd_per_lun value to 3 and configures
each lun with default max queue_depth 32 in fc_slave_alloc.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Acked-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/fcoe/fcoe.c    |    2 +-
 drivers/scsi/libfc/fc_fcp.c |   14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -137,7 +137,7 @@ static struct scsi_host_template fcoe_sh
 	.change_queue_depth = fc_change_queue_depth,
 	.change_queue_type = fc_change_queue_type,
 	.this_id = -1,
-	.cmd_per_lun = 32,
+	.cmd_per_lun = 3,
 	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
 	.use_clustering = ENABLE_CLUSTERING,
 	.sg_tablesize = SG_ALL,
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2049,18 +2049,16 @@ EXPORT_SYMBOL(fc_eh_host_reset);
 int fc_slave_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
-	int queue_depth;
 
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	if (sdev->tagged_supported) {
-		if (sdev->host->hostt->cmd_per_lun)
-			queue_depth = sdev->host->hostt->cmd_per_lun;
-		else
-			queue_depth = FC_FCP_DFLT_QUEUE_DEPTH;
-		scsi_activate_tcq(sdev, queue_depth);
-	}
+	if (sdev->tagged_supported)
+		scsi_activate_tcq(sdev, FC_FCP_DFLT_QUEUE_DEPTH);
+	else
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
+					FC_FCP_DFLT_QUEUE_DEPTH);
+
 	return 0;
 }
 EXPORT_SYMBOL(fc_slave_alloc);


