Return-Path: <linux-kernel-owner+w=401wt.eu-S1760421AbYBYWjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421AbYBYWjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbYBYWjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:39:01 -0500
Received: from havoc.gtf.org ([69.61.125.42]:56953 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337AbYBYWjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:39:00 -0500
Date: Mon, 25 Feb 2008 17:38:59 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20080225223859.GA24360@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(additional explanation for the revert is in the full changeset
description)

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |    5 ++++-
 drivers/ata/libata.h      |    1 -
 2 files changed, 4 insertions(+), 2 deletions(-)

Adrian Bunk (1):
      make atapi_dmadir static

Jeff Garzik (1):
      Revert "power_state: get rid of write-only variable in SATA"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fbc2435..4fbcce7 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -113,7 +113,7 @@ int atapi_enabled = 1;
 module_param(atapi_enabled, int, 0444);
 MODULE_PARM_DESC(atapi_enabled, "Enable discovery of ATAPI devices (0=off, 1=on)");
 
-int atapi_dmadir = 0;
+static int atapi_dmadir = 0;
 module_param(atapi_dmadir, int, 0444);
 MODULE_PARM_DESC(atapi_dmadir, "Enable ATAPI DMADIR bridge support (0=off, 1=on)");
 
@@ -6567,6 +6567,8 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 	ata_lpm_enable(host);
 
 	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
+	if (rc == 0)
+		host->dev->power.power_state = mesg;
 	return rc;
 }
 
@@ -6585,6 +6587,7 @@ void ata_host_resume(struct ata_host *host)
 {
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
+	host->dev->power.power_state = PMSG_ON;
 
 	/* reenable link pm */
 	ata_lpm_disable(host);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 6036ded..aa884f7 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -56,7 +56,6 @@ enum {
 extern unsigned int ata_print_id;
 extern struct workqueue_struct *ata_aux_wq;
 extern int atapi_enabled;
-extern int atapi_dmadir;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
