Return-Path: <linux-kernel-owner+w=401wt.eu-S933388AbYFGBTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbYFGBTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760389AbYFGBJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:29 -0400
Received: from sous-sol.org ([216.99.217.87]:42506 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627AbYFGBJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:22 -0400
Message-Id: <20080607010555.470605116@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>, matthieu.castet@parrot.com,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 10/50] libata: force hardreset if link is in powersave mode
Content-Disposition: inline; filename=libata-force-hardreset-if-link-is-in-powersave-mode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Tejun Heo <htejun@gmail.com>

Inhibiting link PM mode doesn't bring the link back online if it's
already in powersave mode.  If SRST is used in these cases, libata EH
thinks that the link is offline and fails detection.  Force hardreset
if link is in powersave mode.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/ata/libata-core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3947,6 +3947,7 @@ int ata_std_prereset(struct ata_link *li
 	struct ata_port *ap = link->ap;
 	struct ata_eh_context *ehc = &link->eh_context;
 	const unsigned long *timing = sata_ehc_deb_timing(ehc);
+	u32 sstatus;
 	int rc;
 
 	/* handle link resume */
@@ -3960,6 +3961,17 @@ int ata_std_prereset(struct ata_link *li
 	if (ap->flags & ATA_FLAG_PMP)
 		ehc->i.action |= ATA_EH_HARDRESET;
 
+	/* if link powersave is on, force hardreset */
+	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0) {
+		u8 ipm = sstatus >> 8;
+
+		if (ipm == 2 || ipm == 6) {
+			ata_link_printk(link, KERN_INFO, "link in powersave "
+				"mode (ipm=%d), forcing hardreset\n", ipm);
+			ehc->i.action |= ATA_EH_HARDRESET;
+		}
+	}
+
 	/* if we're about to do hardreset, nothing more to do */
 	if (ehc->i.action & ATA_EH_HARDRESET)
 		return 0;

-- 
