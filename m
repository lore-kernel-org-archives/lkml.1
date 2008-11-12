Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbYKLAmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbYKLAmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYKLA1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:27:00 -0500
Received: from kroah.org ([198.145.64.141]:42622 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752473AbYKLA07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:59 -0500
Date: Tue, 11 Nov 2008 16:24:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Shane Huang <Shane.Huang@amd.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 42/49] libata: fix last_reset timestamp handling
Message-ID: <20081112002423.GQ10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-fix-last_reset-timestamp-handling.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 19b723218bde79c60a394a3caee9eb156ac2d356 upstream

ehc->last_reset is used to ensure that resets are not issued too
close to each other.  It's initialized to jiffies minus one minute
on EH entry.  However, when new links are initialized after PMP is
probed, new links have zero for this timestamp resulting in long wait
depending on the current jiffies.

This patch makes last_set considered iff ATA_EHI_DID_RESET is set, in
which case last_reset is always initialized.  As an added precaution,
WARN_ON() is added so that warning is printed if last_reset is
in future.

This problem is spotted and debugged by Shane Huang.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Shane Huang <Shane.Huang@amd.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -604,9 +604,6 @@ void ata_scsi_error(struct Scsi_Host *ho
 				if (ata_ncq_enabled(dev))
 					ehc->saved_ncq_enabled |= 1 << devno;
 			}
-
-			/* set last reset timestamp to some time in the past */
-			ehc->last_reset = jiffies - 60 * HZ;
 		}
 
 		ap->pflags |= ATA_PFLAG_EH_IN_PROGRESS;
@@ -2209,17 +2206,21 @@ int ata_eh_reset(struct ata_link *link, 
 	if (link->flags & ATA_LFLAG_NO_SRST)
 		softreset = NULL;
 
-	now = jiffies;
-	deadline = ata_deadline(ehc->last_reset, ATA_EH_RESET_COOL_DOWN);
-	if (time_before(now, deadline))
-		schedule_timeout_uninterruptible(deadline - now);
+	/* make sure each reset attemp is at least COOL_DOWN apart */
+	if (ehc->i.flags & ATA_EHI_DID_RESET) {
+		now = jiffies;
+		WARN_ON(time_after(ehc->last_reset, now));
+		deadline = ata_deadline(ehc->last_reset,
+					ATA_EH_RESET_COOL_DOWN);
+		if (time_before(now, deadline))
+			schedule_timeout_uninterruptible(deadline - now);
+	}
 
 	spin_lock_irqsave(ap->lock, flags);
 	ap->pflags |= ATA_PFLAG_RESETTING;
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
-	ehc->last_reset = jiffies;
 
 	ata_link_for_each_dev(dev, link) {
 		/* If we issue an SRST then an ATA drive (not ATAPI)
@@ -2285,7 +2286,6 @@ int ata_eh_reset(struct ata_link *link, 
 	/*
 	 * Perform reset
 	 */
-	ehc->last_reset = jiffies;
 	if (ata_is_host_link(link))
 		ata_eh_freeze_port(ap);
 
@@ -2297,6 +2297,7 @@ int ata_eh_reset(struct ata_link *link, 
 					reset == softreset ? "soft" : "hard");
 
 		/* mark that this EH session started with reset */
+		ehc->last_reset = jiffies;
 		if (reset == hardreset)
 			ehc->i.flags |= ATA_EHI_DID_HARDRESET;
 		else
@@ -2404,7 +2405,7 @@ int ata_eh_reset(struct ata_link *link, 
 
 	/* reset successful, schedule revalidation */
 	ata_eh_done(link, NULL, ATA_EH_RESET);
-	ehc->last_reset = jiffies;
+	ehc->last_reset = jiffies;	/* update to completion time */
 	ehc->i.action |= ATA_EH_REVALIDATE;
 
 	rc = 0;

-- 
