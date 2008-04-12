Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYDLSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYDLSwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbYDLSvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:51:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:16218 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbYDLSvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JWgasJJfZoi4C7keUkQAAMKBCtjDFhDdt5mb6c4U2buNbG41+DALEc9bNp0IxLWlavF29j5qBa6e0Dv1gsQMwn/+sFpFoBqntjmtOeHYo/5Smkob7JmyEGwJ9oAzHG1F+yMSnAEJAW14OPR+hsIuSJxLJHeoryNw1lWdAWcKRIk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/5] ide: skip "VLB sync" if host uses MMIO
Date: Sat, 12 Apr 2008 21:03:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804122103.51449.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Skip "VLB sync" in ata_{in,out}put_data() if host uses MMIO.

* Use I/O ops directly in ata_vlb_sync() an drop no longer needed
  'ide_drive_t *drive' argument.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -227,11 +227,11 @@ static void ide_tf_read(ide_drive_t *dri
  * of the sector count register location, with interrupts disabled
  * to ensure that the reads all happen together.
  */
-static void ata_vlb_sync(ide_drive_t *drive, unsigned long port)
+static void ata_vlb_sync(unsigned long port)
 {
-	(void) HWIF(drive)->INB(port);
-	(void) HWIF(drive)->INB(port);
-	(void) HWIF(drive)->INB(port);
+	(void)inb(port);
+	(void)inb(port);
+	(void)inb(port);
 }
 
 /*
@@ -255,9 +255,9 @@ static void ata_input_data(ide_drive_t *
 	if (io_32bit) {
 		unsigned long uninitialized_var(flags);
 
-		if (io_32bit & 2) {
+		if ((io_32bit & 2) && !mmio) {
 			local_irq_save(flags);
-			ata_vlb_sync(drive, io_ports->nsect_addr);
+			ata_vlb_sync(io_ports->nsect_addr);
 		}
 
 		if (mmio)
@@ -265,7 +265,7 @@ static void ata_input_data(ide_drive_t *
 		else
 			insl(data_addr, buf, len / 4);
 
-		if (io_32bit & 2)
+		if ((io_32bit & 2) && !mmio)
 			local_irq_restore(flags);
 
 		if ((len & 3) >= 2) {
@@ -298,9 +298,9 @@ static void ata_output_data(ide_drive_t 
 	if (io_32bit) {
 		unsigned long uninitialized_var(flags);
 
-		if (io_32bit & 2) {
+		if ((io_32bit & 2) && !mmio) {
 			local_irq_save(flags);
-			ata_vlb_sync(drive, io_ports->nsect_addr);
+			ata_vlb_sync(io_ports->nsect_addr);
 		}
 
 		if (mmio)
@@ -308,7 +308,7 @@ static void ata_output_data(ide_drive_t 
 		else
 			outsl(data_addr, buf, len / 4);
 
-		if (io_32bit & 2)
+		if ((io_32bit & 2) && !mmio)
 			local_irq_restore(flags);
 
 		if ((len & 3) >= 2) {
