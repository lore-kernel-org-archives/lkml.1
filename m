Return-Path: <linux-kernel-owner+w=401wt.eu-S1762963AbYDQBTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762963AbYDQBTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759858AbYDQBIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:16 -0400
Received: from sous-sol.org ([216.99.217.87]:58912 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759799AbYDQBIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:14 -0400
Message-Id: <20080417010351.709292051@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:08 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>,
       =?UTF-8?q?Jan=20B=C3=BCcken?= <jb.faq@gmx.de>,
       Alan Cox <alan@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Daniel Drake <dsd@gentoo.org>
Subject: libata: assume no device is attached if both IDENTIFYs are aborted
Content-Disposition: inline; filename=libata-assume-no-device-is-attached-if-both-identifys-are-aborted.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Tejun Heo <htejun@gmail.com>

upstream commit: 1ffc151fcddf524d0c76709d7e7a2af0255acb6b

This is to fix bugzilla #10254.  QSI cdrom attached to pata_sis as
secondary master appears as phantom device for the slave.
Interestingly, instead of not setting DRQ after IDENTIFY which
triggers NODEV_HINT, it aborts both IDENTIFY and IDENTIFY PACKET which
makes EH retry.

Modify EH such that it assumes no device is attached if both flavors
of IDENTIFY are aborted by the device.  There really isn't much point
in retrying when the device actively aborts the commands.

While at it, convert NODEV detection message to ata_dev_printk() to
help debugging obscure detection problems.

This problem was reported by Jan Bücken.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jan Bücken <jb.faq@gmx.de>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>

dsd@gentoo.org notes:

This patch fixes http://bugs.gentoo.org/211369

Cc: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/ata/libata-core.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1936,24 +1936,34 @@ int ata_dev_read_id(struct ata_device *d
 				     id, sizeof(id[0]) * ATA_ID_WORDS, 0);
 	if (err_mask) {
 		if (err_mask & AC_ERR_NODEV_HINT) {
-			DPRINTK("ata%u.%d: NODEV after polling detection\n",
-				ap->print_id, dev->devno);
+			ata_dev_printk(dev, KERN_DEBUG,
+				       "NODEV after polling detection\n");
 			return -ENOENT;
 		}
 
-		/* Device or controller might have reported the wrong
-		 * device class.  Give a shot at the other IDENTIFY if
-		 * the current one is aborted by the device.
-		 */
-		if (may_fallback &&
-		    (err_mask == AC_ERR_DEV) && (tf.feature & ATA_ABORTED)) {
-			may_fallback = 0;
+		if ((err_mask == AC_ERR_DEV) && (tf.feature & ATA_ABORTED)) {
+			/* Device or controller might have reported
+			 * the wrong device class.  Give a shot at the
+			 * other IDENTIFY if the current one is
+			 * aborted by the device.
+			 */
+			if (may_fallback) {
+				may_fallback = 0;
 
-			if (class == ATA_DEV_ATA)
-				class = ATA_DEV_ATAPI;
-			else
-				class = ATA_DEV_ATA;
-			goto retry;
+				if (class == ATA_DEV_ATA)
+					class = ATA_DEV_ATAPI;
+				else
+					class = ATA_DEV_ATA;
+				goto retry;
+			}
+
+			/* Control reaches here iff the device aborted
+			 * both flavors of IDENTIFYs which happens
+			 * sometimes with phantom devices.
+			 */
+			ata_dev_printk(dev, KERN_DEBUG,
+				       "both IDENTIFYs aborted, assuming NODEV\n");
+			return -ENOENT;
 		}
 
 		rc = -EIO;

-- 
