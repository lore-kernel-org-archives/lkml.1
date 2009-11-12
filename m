Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZKLSsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZKLSsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZKLSsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:48:40 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:9678 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZKLSsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:48:38 -0500
Subject: [PATCH 11/11] cciss: Fix weird usage of ENXIO in cciss_scsi.c
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:50:06 -0600
Message-ID: <20091112185006.23389.70.stgit@beardog.cce.hp.com>
In-Reply-To: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
References: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: Fix weird usage of ENXIO in cciss_scsi.c

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c      |    7 ++-----
 drivers/block/cciss_scsi.c |    2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1bd313d..eab81c6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -422,12 +422,9 @@ cciss_proc_write(struct file *file, const char __user *buf,
 	if (strncmp(ENGAGE_SCSI, buffer, sizeof ENGAGE_SCSI - 1) == 0) {
 		struct seq_file *seq = file->private_data;
 		ctlr_info_t *h = seq->private;
-		int rc;
 
-		rc = cciss_engage_scsi(h->ctlr);
-		if (rc != 0)
-			err = -rc;
-		else
+		err = cciss_engage_scsi(h->ctlr);
+		if (err == 0)
 			err = length;
 	} else
 #endif /* CONFIG_CISS_SCSI_TAPE */
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 237d2b3..5d0e46d 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1547,7 +1547,7 @@ cciss_engage_scsi(int ctlr)
 	if (sa->registered) {
 		printk("cciss%d: SCSI subsystem already engaged.\n", ctlr);
 		spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-		return ENXIO;
+		return -ENXIO;
 	}
 	sa->registered = 1;
 	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);

