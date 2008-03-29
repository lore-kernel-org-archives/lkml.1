Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYC2SoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYC2SoF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbYC2Sny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:43:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:43988 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbYC2Snx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=mmDYuV/9nOu1LXCxTQ3D8wukIquR3qS0DWPT4ayDgYmhIkrXhL6fnBubXIRdWvEQP9dr1J6YbYawLQMs54czpA9n/F8EUwz6e5Sf+/VS4hTgKUWvtBa7fIXDWJv2wfxdFafw7cfLCownkUPyYL8c7ctgH4htW7/O87VE1UVL4k0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] Revert "ide: change master/slave IDENTIFY order"
Date: Sat, 29 Mar 2008 19:57:24 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803291957.25205.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit b140b99c413ce410197cfcd4014e757cd745226a.

[ conflict in drivers/ide/ide-probe.c fixed manually ]

It turned out that probing order change causes problems for some drives:

	http://bugzilla.kernel.org/show_bug.cgi?id=10239

Since root causes are still being investigated and are unlikely to be fixed
before 2.6.25 lets revert this change for now.  As a result cable detection
becomes less reliable when compared with 2.6.24 but the affected drives are
useable again.

Reported-by: Richard Genoud <richard.genoud@gmail.com>
Bisected-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c  |    1 +
 drivers/ide/ide-probe.c |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index c419266..01b9220 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -595,6 +595,7 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 
 	/*
 	 * FIXME:
+	 * - change master/slave IDENTIFY order
 	 * - force bit13 (80c cable present) check also for !ivb devices
 	 *   (unless the slave device is pre-ATA3)
 	 */
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 194ecb0..47a1149 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -774,9 +774,10 @@ static int ide_probe_port(ide_hwif_t *hwif)
 		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
 
 	/*
-	 * Need to probe slave device first to make it release PDIAG-.
+	 * Second drive should only exist if first drive was found,
+	 * but a lot of cdrom drives are configured as single slaves.
 	 */
-	for (unit = MAX_DRIVES - 1; unit >= 0; unit--) {
+	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
 		drive->dn = (hwif->channel ? 2 : 0) + unit;
 		(void) probe_for_drive(drive);
