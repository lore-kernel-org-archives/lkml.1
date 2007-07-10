Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbXGJDCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbXGJDCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760300AbXGJDCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:02:38 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756AbXGJDCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:02:37 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 02/33] hd.c: remove BIOS/CMOS queries
Date: Mon,  9 Jul 2007 19:51:41 -0700
Message-Id: <11840361432207-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840360383913-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
Message-Id: <de4df4ebeb6ec1bf47d4adf19f6a388035e2bfec.1184032748.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

An ST-506 disk these days is pretty much someone trying to pull ancient
data using an auxilliary controller.  Pulling data from the BIOS or CMOS
is just plain wrong, since it's likely to be the primary OS disk... and
would be user-entered data anyway.  Instead, require the user enters it
on the command line.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 drivers/ide/legacy/hd.c |   73 ++++++++---------------------------------------
 1 files changed, 12 insertions(+), 61 deletions(-)

diff --git a/drivers/ide/legacy/hd.c b/drivers/ide/legacy/hd.c
index 45ed035..9d7d8aa 100644
--- a/drivers/ide/legacy/hd.c
+++ b/drivers/ide/legacy/hd.c
@@ -718,74 +718,25 @@ static int __init hd_init(void)
 	device_timer.function = hd_times_out;
 	blk_queue_hardsect_size(hd_queue, 512);
 
-#ifdef __i386__
 	if (!NR_HD) {
-		extern struct drive_info drive_info;
-		unsigned char *BIOS = (unsigned char *) &drive_info;
-		unsigned long flags;
-		int cmos_disks;
-
-		for (drive=0 ; drive<2 ; drive++) {
-			hd_info[drive].cyl = *(unsigned short *) BIOS;
-			hd_info[drive].head = *(2+BIOS);
-			hd_info[drive].wpcom = *(unsigned short *) (5+BIOS);
-			hd_info[drive].ctl = *(8+BIOS);
-			hd_info[drive].lzone = *(unsigned short *) (12+BIOS);
-			hd_info[drive].sect = *(14+BIOS);
-#ifdef does_not_work_for_everybody_with_scsi_but_helps_ibm_vp
-			if (hd_info[drive].cyl && NR_HD == drive)
-				NR_HD++;
-#endif
-			BIOS += 16;
-		}
-
-	/*
-		We query CMOS about hard disks : it could be that 
-		we have a SCSI/ESDI/etc controller that is BIOS
-		compatible with ST-506, and thus showing up in our
-		BIOS table, but not register compatible, and therefore
-		not present in CMOS.
-
-		Furthermore, we will assume that our ST-506 drives
-		<if any> are the primary drives in the system, and 
-		the ones reflected as drive 1 or 2.
-
-		The first drive is stored in the high nibble of CMOS
-		byte 0x12, the second in the low nibble.  This will be
-		either a 4 bit drive type or 0xf indicating use byte 0x19 
-		for an 8 bit type, drive 1, 0x1a for drive 2 in CMOS.
-
-		Needless to say, a non-zero value means we have 
-		an AT controller hard disk for that drive.
-
-		Currently the rtc_lock is a bit academic since this
-		driver is non-modular, but someday... ?         Paul G.
-	*/
-
-		spin_lock_irqsave(&rtc_lock, flags);
-		cmos_disks = CMOS_READ(0x12);
-		spin_unlock_irqrestore(&rtc_lock, flags);
-
-		if (cmos_disks & 0xf0) {
-			if (cmos_disks & 0x0f)
-				NR_HD = 2;
-			else
-				NR_HD = 1;
-		}
-	}
-#endif /* __i386__ */
-#ifdef __arm__
-	if (!NR_HD) {
-		/* We don't know anything about the drive.  This means
+		/*
+		 * We don't know anything about the drive.  This means
 		 * that you *MUST* specify the drive parameters to the
 		 * kernel yourself.
+		 *
+		 * If we were on an i386, we used to read this info from
+		 * the BIOS or CMOS.  This doesn't work all that well,
+		 * since this assumes that this is a primary or secondary
+		 * drive, and if we're using this legacy driver, it's
+		 * probably an auxilliary controller added to recover
+		 * legacy data off an ST-506 drive.  Either way, it's
+		 * definitely safest to have the user explicitly specify
+		 * the information.
 		 */
 		printk("hd: no drives specified - use hd=cyl,head,sectors"
 			" on kernel command line\n");
-	}
-#endif
-	if (!NR_HD)
 		goto out;
+	}
 
 	for (drive=0 ; drive < NR_HD ; drive++) {
 		struct gendisk *disk = alloc_disk(64);
-- 
1.5.2.2

