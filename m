Return-Path: <linux-kernel-owner+w=401wt.eu-S933751AbXKOHJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbXKOHJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932627AbXKOGsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:48:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43759 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762766AbXKOGsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:48:20 -0500
Date: Wed, 14 Nov 2007 22:45:54 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>
Subject: [patch 37/40] libata: backport ATA_FLAG_NO_SRST and
	ATA_FLAG_ASSUME_ATA
Message-ID: <20071115064554.GL19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-backport-ata_flag_no_srst-and-ata_flag_assume_ata.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <htejun@gmail.com>

Differs from mainline, but the functionality is already there.

Backport ATA_FLAG_NO_SRST and ATA_FLAG_ASSUME_ATA.  These are
originally link flags (ATA_LFLAG_*) but link abstraction doesn't exist
on 2.6.23, so make it port flags.

This is for the following workaround for ASUS P5W DH Deluxe.

These new flags don't introduce any behavior change unless set and
nobody sets them yet.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |   32 ++++++++++++++++++++++++--------
 include/linux/libata.h  |    2 ++
 2 files changed, 26 insertions(+), 8 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1759,9 +1759,11 @@ static int ata_do_reset(struct ata_port 
 	return 0;
 }
 
-static int ata_eh_followup_srst_needed(int rc, int classify,
-				       const unsigned int *classes)
+static int ata_eh_followup_srst_needed(struct ata_port *ap, int rc,
+				int classify, const unsigned int *classes)
 {
+	if (ap->flags & ATA_FLAG_NO_SRST)
+		return 0;
 	if (rc == -EAGAIN)
 		return 1;
 	if (rc != 0)
@@ -1792,7 +1794,8 @@ static int ata_eh_reset(struct ata_port 
 	 */
 	action = ehc->i.action;
 	ehc->i.action &= ~ATA_EH_RESET_MASK;
-	if (softreset && (!hardreset || (!sata_set_spd_needed(ap) &&
+	if (softreset && (!hardreset || (!(ap->flags & ATA_FLAG_NO_SRST) &&
+					 !sata_set_spd_needed(ap) &&
 					 !(action & ATA_EH_HARDRESET))))
 		ehc->i.action |= ATA_EH_SOFTRESET;
 	else
@@ -1855,7 +1858,7 @@ static int ata_eh_reset(struct ata_port 
 	rc = ata_do_reset(ap, reset, classes, deadline);
 
 	if (reset == hardreset &&
-	    ata_eh_followup_srst_needed(rc, classify, classes)) {
+	    ata_eh_followup_srst_needed(ap, rc, classify, classes)) {
 		/* okay, let's do follow-up softreset */
 		reset = softreset;
 
@@ -1870,8 +1873,8 @@ static int ata_eh_reset(struct ata_port 
 		ata_eh_about_to_do(ap, NULL, ATA_EH_RESET_MASK);
 		rc = ata_do_reset(ap, reset, classes, deadline);
 
-		if (rc == 0 && classify &&
-		    classes[0] == ATA_DEV_UNKNOWN) {
+		if (rc == 0 && classify && classes[0] == ATA_DEV_UNKNOWN &&
+		    !(ap->flags & ATA_FLAG_ASSUME_ATA)) {
 			ata_port_printk(ap, KERN_ERR,
 					"classification failed\n");
 			rc = -EINVAL;
@@ -1879,6 +1882,10 @@ static int ata_eh_reset(struct ata_port 
 		}
 	}
 
+	/* if we skipped follow-up srst, clear rc */
+	if (rc == -EAGAIN)
+		rc = 0;
+
 	if (rc && try < ARRAY_SIZE(ata_eh_reset_timeouts)) {
 		unsigned long now = jiffies;
 
@@ -1906,8 +1913,17 @@ static int ata_eh_reset(struct ata_port 
 		/* After the reset, the device state is PIO 0 and the
 		 * controller state is undefined.  Record the mode.
 		 */
-		for (i = 0; i < ATA_MAX_DEVICES; i++)
-			ap->device[i].pio_mode = XFER_PIO_0;
+		for (i = 0; i < ata_port_max_devices(ap); i++) {
+			struct ata_device *dev = &ap->device[i];
+
+			dev->pio_mode = XFER_PIO_0;
+
+			if (ata_port_offline(ap))
+				continue;
+
+			if (ap->flags & ATA_FLAG_ASSUME_ATA)
+				classes[dev->devno] = ATA_DEV_ATA;
+		}
 
 		/* record current link speed */
 		if (sata_scr_read(ap, SCR_STATUS, &sstatus) == 0)
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -177,6 +177,8 @@ enum {
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
+	ATA_FLAG_NO_SRST	= (1 << 18),
+	ATA_FLAG_ASSUME_ATA	= (1 << 19),
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be

-- 
