Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZGLLN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZGLLN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 07:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZGLLNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 07:13:21 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:52931 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZGLLNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 07:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QHM0XJ6No2qDGeL+y6NKg4Gi3/RoK18BGPryLVmnLLdS2p6bsWhEA0NbUzYJHO2XD5
         08+zlnGYyk4UWcSj79EeJi6kW5Blustdtej2UYPVpUtI0t6yPjxN8eZzG+Gi53mfzwRf
         b3Y7sSF4+XZOae+XVx/hwI08eCwEk6Kk7wNXA=
MIME-Version: 1.0
Date: Sun, 12 Jul 2009 17:13:18 +0600
Message-ID: <b9df5fa10907120413l21761e1cxfc26436481954c2a@mail.gmail.com>
Subject: [PATCH] block: Mark virtio_blk with __refdata in virtio_blk.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: axboe@kernel.dk
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Impact: Fix false positive warning.

The variable virtio_blk references the function virtblk_probe() (which
is in .devinit section) and also references the function
virtblk_remove() ( which is in .devexit section). So, virtio_blk
simultaneously refers .devinit and .devexit section. To avoid this
messup, we mark virtio_blk as __refdata.

We were warned by the following warning:

  LD      drivers/block/built-in.o
WARNING: drivers/block/built-in.o(.data+0xc8dc): Section mismatch in
reference from the variable virtio_blk to the function
.devinit.text:virtblk_probe()
The variable virtio_blk references
the function __devinit virtblk_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/block/built-in.o(.data+0xc8e0): Section mismatch in
reference from the variable virtio_blk to the function
.devexit.text:virtblk_remove()
The variable virtio_blk references
the function __devexit virtblk_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/drivers/block/virtio_blk.c	2009-07-10 12:30:16.000000000 +0600
+++ rakib/drivers/block/virtio_blk.c	2009-07-12 11:44:43.000000000 +0600
@@ -424,7 +424,8 @@ static unsigned int features[] = {
 	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_IDENTIFY
 };

-static struct virtio_driver virtio_blk = {
+/* We were warned by false positive warning, so __refdata comes into rescue. */
+static struct virtio_driver __refdata virtio_blk = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
