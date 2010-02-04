Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab0BDRWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:22:53 -0500
Received: from kroah.org ([198.145.64.141]:34864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933320Ab0BDRWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:15 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:18 2010
Message-Id: <20100204171517.612715852@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [52/74] libata: retry link resume if necessary
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 5040ab67a2c6d5710ba497dc52a8f7035729d7b0 upstream.

Interestingly, when SIDPR is used in ata_piix, writes to DET in
SControl sometimes get ignored leading to detection failure.  Update
sata_link_resume() such that it reads back SControl after clearing DET
and retry if it's not clear.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: fengxiangjun <fengxiangjun@neusoft.com>
Reported-by: Jim Faulkner <jfaulkne@ccs.neu.edu>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3790,21 +3790,45 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 int sata_link_resume(struct ata_link *link, const unsigned long *params,
 		     unsigned long deadline)
 {
+	int tries = ATA_LINK_RESUME_TRIES;
 	u32 scontrol, serror;
 	int rc;
 
 	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
 		return rc;
 
-	scontrol = (scontrol & 0x0f0) | 0x300;
+	/*
+	 * Writes to SControl sometimes get ignored under certain
+	 * controllers (ata_piix SIDPR).  Make sure DET actually is
+	 * cleared.
+	 */
+	do {
+		scontrol = (scontrol & 0x0f0) | 0x300;
+		if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
+			return rc;
+		/*
+		 * Some PHYs react badly if SStatus is pounded
+		 * immediately after resuming.  Delay 200ms before
+		 * debouncing.
+		 */
+		msleep(200);
 
-	if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
-		return rc;
+		/* is SControl restored correctly? */
+		if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
+			return rc;
+	} while ((scontrol & 0xf0f) != 0x300 && --tries);
 
-	/* Some PHYs react badly if SStatus is pounded immediately
-	 * after resuming.  Delay 200ms before debouncing.
-	 */
-	msleep(200);
+	if ((scontrol & 0xf0f) != 0x300) {
+		ata_link_printk(link, KERN_ERR,
+				"failed to resume link (SControl %X)\n",
+				scontrol);
+		return 0;
+	}
+
+	if (tries < ATA_LINK_RESUME_TRIES)
+		ata_link_printk(link, KERN_WARNING,
+				"link resume succeeded after %d retries\n",
+				ATA_LINK_RESUME_TRIES - tries);
 
 	if ((rc = sata_link_debounce(link, params, deadline)))
 		return rc;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 6a9c4dd..7311225 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -354,6 +354,9 @@ enum {
 	/* max tries if error condition is still set after ->error_handler */
 	ATA_EH_MAX_TRIES	= 5,
 
+	/* sometimes resuming a link requires several retries */
+	ATA_LINK_RESUME_TRIES	= 5,
+
 	/* how hard are we gonna try to probe/recover devices */
 	ATA_PROBE_MAX_TRIES	= 3,
 	ATA_EH_DEV_TRIES	= 3,


