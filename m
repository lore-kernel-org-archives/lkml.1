Return-Path: <linux-kernel-owner+w=401wt.eu-S1761379AbZFIK0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761379AbZFIK0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760506AbZFIKTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:19:45 -0400
Received: from kroah.org ([198.145.64.141]:54916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760715AbZFIKTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:19:43 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:01 2009
Message-Id: <20090609094101.651695251@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:29 -0700
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
       alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 41/87] ide: fix 40-wire cable detection for TSST SH-S202* ATAPI devices (v2)
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=ide-fix-40-wire-cable-detection-for-tsst-sh-s202-atapi-devices.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 8369d5fa63260cc54464b4687aa6a0f78402d98e upstream.

Since 2.6.26 we support UDMA66 on ATAPI devices requiring IVB quirk:

  commit 8588a2b732928b343233af9b1855705b8286bed4
  ("ide: add SH-S202J to ivb_list[]")

We also later added support for more such devices in:

  commit e97564f362a93f8c248246c19828895950341252
  ("ide: More TSST drives with broken cable detection")

and in:

  commit 3ced5c49bd2d1f2c7f769e3a54385883de63a652
  ("ide: add TSSTcorp CDDVDW SH-S202H to ivb_list[]")

It turns out that such devices lack cable detection altogether
(which in turn results in incorrect detection of 40-wire cables
by our current cable detection strategy) so always handle them
by trusting host-side cable detection only.

v2:
Model detection fixup from Martin.

Reported-and-tested-by: Martin Lottermoser <Martin.Lottermoser@t-online.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-iops.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -587,8 +587,6 @@ EXPORT_SYMBOL_GPL(ide_in_drive_list);
 
 /*
  * Early UDMA66 devices don't set bit14 to 1, only bit13 is valid.
- * We list them here and depend on the device side cable detection for them.
- *
  * Some optical devices with the buggy firmwares have the same problem.
  */
 static const struct drive_list_entry ivb_list[] = {
@@ -632,10 +630,25 @@ u8 eighty_ninty_three (ide_drive_t *driv
 	 * - force bit13 (80c cable present) check also for !ivb devices
 	 *   (unless the slave device is pre-ATA3)
 	 */
-	if ((id[ATA_ID_HW_CONFIG] & 0x4000) ||
-	    (ivb && (id[ATA_ID_HW_CONFIG] & 0x2000)))
+	if (id[ATA_ID_HW_CONFIG] & 0x4000)
 		return 1;
 
+	if (ivb) {
+		const char *model = (char *)&id[ATA_ID_PROD];
+
+		if (strstr(model, "TSSTcorp CDDVDW SH-S202")) {
+			/*
+			 * These ATAPI devices always report 80c cable
+			 * so we have to depend on the host in this case.
+			 */
+			if (hwif->cbl == ATA_CBL_PATA80)
+				return 1;
+		} else {
+			/* Depend on the device side cable detection. */
+			if (id[ATA_ID_HW_CONFIG] & 0x2000)
+				return 1;
+		}
+	}
 no_80w:
 	if (drive->dev_flags & IDE_DFLAG_UDMA33_WARNED)
 		return 0;


