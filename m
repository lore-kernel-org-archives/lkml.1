Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYHQT6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYHQT6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbYHQT4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:56:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:19610 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYHQT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qtpFjRUmYKRSlsb5i/GRyhRi2JU28UafZyFruwTeUCoqB7Ere7Wq64vIs/V8063v6E
         iSLgcBAIWunN+zBZY5qwaYv75rnxYSi7l/YhGIKgD+MaogJQdSZzrKdvTyCF5qSXw7Mr
         9NetVelF47mm0/JqjRbSc8V4LokZP9uejwmSc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 21:54:25 +0200
Message-Id: <20080817195425.13393.62956.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
References: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/9] ide: factor out reset error reporting from reset_pollfunc()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out reset error reporting from reset_pollfunc()
to ide_reset_report_error() helper.

While at it:
- fix KERN_* printk() levels
- remove 'switch ()'

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -940,6 +940,25 @@ static ide_startstop_t atapi_reset_pollf
 	return ide_stopped;
 }
 
+static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
+{
+	static const char *err_master_vals[] =
+		{ NULL, "passed", "formatter device error",
+		  "sector buffer error", "ECC circuitry error",
+		  "controlling MPU error" };
+
+	u8 err_master = err & 0x7f;
+
+	printk(KERN_ERR "%s: reset: master: ", hwif->name);
+	if (err_master && err_master < 6)
+		printk(KERN_CONT "%s", err_master_vals[err_master]);
+	else
+		printk(KERN_CONT "error (0x%02x?)", err);
+	if (err & 0x80)
+		printk(KERN_CONT "; slave: failed");
+	printk(KERN_CONT "\n");
+}
+
 /*
  * reset_pollfunc() gets invoked to poll the interface for completion every 50ms
  * during an ide reset operation. If the drives have not yet responded,
@@ -975,31 +994,14 @@ static ide_startstop_t reset_pollfunc (i
 		drive->failures++;
 		err = -EIO;
 	} else  {
-		printk("%s: reset: ", hwif->name);
 		tmp = ide_read_error(drive);
 
 		if (tmp == 1) {
-			printk("success\n");
+			printk(KERN_INFO "%s: reset: success\n", hwif->name);
 			drive->failures = 0;
 		} else {
+			ide_reset_report_error(hwif, tmp);
 			drive->failures++;
-			printk("master: ");
-			switch (tmp & 0x7f) {
-				case 1: printk("passed");
-					break;
-				case 2: printk("formatter device error");
-					break;
-				case 3: printk("sector buffer error");
-					break;
-				case 4: printk("ECC circuitry error");
-					break;
-				case 5: printk("controlling MPU error");
-					break;
-				default:printk("error (0x%02x?)", tmp);
-			}
-			if (tmp & 0x80)
-				printk("; slave: failed");
-			printk("\n");
 			err = -EIO;
 		}
 	}
