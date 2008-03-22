Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYCVVvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYCVVvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbYCVVvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:51:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:4232 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbYCVVve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ROW3jVSAulM5Y43+zSAgAFnY3K6ctvbr+8NcZretxsKuVYoeT5pE74s3vnvz4NNPKvg8vjYxH8zHVW3lIR8zU0QMBunTUcpRodDoT4RLdmowkSoYGfPzU4UdkUmYI1sWIxeUVMWovntugQtyTsRb7dt6uT0dDQ4GDAxbOHS1IPE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 22 Mar 2008 23:06:31 +0100
Message-Id: <20080322220631.17636.78849.sendpatchset@localhost.localdomain>
In-Reply-To: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
References: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/8] cmd640: always auto-tune PIO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Default to tuning PIO0 and disabling prefetch prior to probing
  devices for CONFIG_BLK_DEV_CMD640_ENHANCED=y case.

* Always auto-tune PIO.

* Remove no longer used retrieve_drive_counts().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd640.c |   67 ++++++++---------------------------------------
 1 file changed, 12 insertions(+), 55 deletions(-)

Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -380,6 +380,7 @@ static void cmd640_dump_regs(void)
 }
 #endif
 
+#ifndef CONFIG_BLK_DEV_CMD640_ENHANCED
 /*
  * Check whether prefetch is on for a drive,
  * and initialize the unmask flags for safe operation.
@@ -400,9 +401,7 @@ static void __init check_prefetch(ide_dr
 		drive->no_io_32bit = 0;
 	}
 }
-
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-
+#else
 /*
  * Sets prefetch mode for a drive.
  */
@@ -459,34 +458,6 @@ static inline u8 pack_nibbles(u8 upper, 
 }
 
 /*
- * This routine retrieves the initial drive timings from the chipset.
- */
-static void __init retrieve_drive_counts(unsigned int index)
-{
-	u8 b;
-
-	/*
-	 * Get the internal setup timing, and convert to clock count
-	 */
-	b = get_cmd640_reg(arttim_regs[index]) & ~0x3f;
-	switch (b) {
-	case 0x00: b = 4; break;
-	case 0x80: b = 3; break;
-	case 0x40: b = 2; break;
-	default:   b = 5; break;
-	}
-	setup_counts[index] = b;
-
-	/*
-	 * Get the active/recovery counts
-	 */
-	b = get_cmd640_reg(drwtim_regs[index]);
-	active_counts[index]   = (b >> 4)   ? (b >> 4)   : 0x10;
-	recovery_counts[index] = (b & 0x0f) ? (b & 0x0f) : 0x10;
-}
-
-
-/*
  * This routine writes the prepared setup/active/recovery counts
  * for a drive into the cmd640 chipset registers to active them.
  */
@@ -681,7 +652,6 @@ static const struct ide_port_info cmd640
 	.chipset		= ide_cmd640,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA |
-				  IDE_HFLAG_NO_AUTOTUNE |
 				  IDE_HFLAG_ABUSE_PREFETCH |
 				  IDE_HFLAG_ABUSE_FAST_DEVSEL,
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
@@ -864,29 +834,16 @@ static int __init cmd640x_init(void)
 		}
 
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-		if (drive->autotune || ((index > 1) && second_port_toggled)) {
-			/*
-			 * Reset timing to the slowest speed and turn off
-			 * prefetch.  This way, the drive identify code has
-			 * a better chance.
-			 */
-			setup_counts    [index] = 4;	/* max possible */
-			active_counts   [index] = 16;	/* max possible */
-			recovery_counts [index] = 16;	/* max possible */
-			program_drive_counts(drive, index);
-			set_prefetch_mode(drive, index, 0);
-			printk("cmd640: drive%d timings/prefetch cleared\n", index);
-		} else {
-			/*
-			 * Record timings/prefetch without changing them.
-			 * This preserves any prior BIOS setup.
-			 */
-			retrieve_drive_counts (index);
-			check_prefetch(drive, index);
-			printk("cmd640: drive%d timings/prefetch(%s) preserved",
-				index, drive->no_io_32bit ? "off" : "on");
-			display_clocks(index);
-		}
+		/*
+		 * Reset timing to the slowest speed and turn off prefetch.
+		 * This way, the drive identify code has a better chance.
+		 */
+		setup_counts    [index] = 4;	/* max possible */
+		active_counts   [index] = 16;	/* max possible */
+		recovery_counts [index] = 16;	/* max possible */
+		program_drive_counts(drive, index);
+		set_prefetch_mode(drive, index, 0);
+		printk("cmd640: drive%d timings/prefetch cleared\n", index);
 #else
 		/*
 		 * Set the drive unmask flags to match the prefetch setting
