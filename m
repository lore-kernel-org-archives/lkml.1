Return-Path: <linux-kernel-owner+w=401wt.eu-S933518AbYBGUGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbYBGUGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761295AbYBGUDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:34 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:38630 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050AbYBGUDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dRE1GF3lbimVfrj0SlkYtd7mpUkvBksH/9u9VJiO7PCoHE7w4FV992zwW7r1mu3RcOMsBAjm+R3Ojnsz5Cqir2gVPT3w00l412+n+9wC8MxzK3oedMAMZkIDoSQX1ozowTarmyXbiY3fZr6R5YEPoCp6asUMGuecXRltgSla6Dc=
Message-ID: <6101e8c40802071203w14fadb44m6732cc551d5613df@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:29 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {07/14} - sony-laptop: call sonypi_compat_init earlier - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: sony-laptop-call-sonypi_compat_init-earlier.patch

From: Mattia Dongili <malattia@linux.it>
Date: Sun, 12 Aug 2007 07:20:27 +0000 (+0900)
Subject: sony-laptop: call sonypi_compat_init earlier
Patch-mainline: 2.6.23
References: 350984

sony-laptop: call sonypi_compat_init earlier

mainline: 015a916fbbf105bb15f4bbfd80c3b9b2f2e0d7db

sonypi_compat uses a kfifo that needs to be present before _SRS is
called to be able to cope with the IRQs triggered when setting
resources.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Len Brown <len.brown@intel.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
---
 drivers/misc/sony-laptop.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/misc/sony-laptop.c	2007-11-28 10:52:13.000000000 -0500
+++ b/drivers/misc/sony-laptop.c	2008-01-02 15:17:42.000000000 -0500
@@ -2068,8 +2068,6 @@ static int sony_pic_remove(struct acpi_d
 	struct sony_pic_ioport *io, *tmp_io;
 	struct sony_pic_irq *irq, *tmp_irq;

-	sonypi_compat_exit();
-
 	if (sony_pic_disable(device)) {
 		printk(KERN_ERR DRV_PFX "Couldn't disable device.\n");
 		return -ENXIO;
@@ -2079,6 +2077,8 @@ static int sony_pic_remove(struct acpi_d
 	release_region(spic_dev.cur_ioport->io.minimum,
 			spic_dev.cur_ioport->io.address_length);

+	sonypi_compat_exit();
+
 	sony_laptop_remove_input();

 	/* pf attrs */
@@ -2144,6 +2144,9 @@ static int sony_pic_add(struct acpi_devi
 		goto err_free_resources;
 	}

+	if (sonypi_compat_init())
+		goto err_remove_input;
+
 	/* request io port */
 	list_for_each_entry(io, &spic_dev.ioports, list) {
 		if (request_region(io->io.minimum, io->io.address_length,
@@ -2158,7 +2161,7 @@ static int sony_pic_add(struct acpi_devi
 	if (!spic_dev.cur_ioport) {
 		printk(KERN_ERR DRV_PFX "Failed to request_region.\n");
 		result = -ENODEV;
-		goto err_remove_input;
+		goto err_remove_compat;
 	}

 	/* request IRQ */
@@ -2198,9 +2201,6 @@ static int sony_pic_add(struct acpi_devi
 	if (result)
 		goto err_remove_pf;

-	if (sonypi_compat_init())
-		goto err_remove_pf;
-
 	return 0;

 err_remove_pf:
@@ -2216,6 +2216,9 @@ err_release_region:
 	release_region(spic_dev.cur_ioport->io.minimum,
 			spic_dev.cur_ioport->io.address_length);

+err_remove_compat:
+	sonypi_compat_exit();
+
 err_remove_input:
 	sony_laptop_remove_input();



-- 
Thanks,
Oliver
