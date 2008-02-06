Return-Path: <linux-kernel-owner+w=401wt.eu-S1763878AbYBFXJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763878AbYBFXJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762206AbYBFXGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:06:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:20974 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763511AbYBFXGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jMR//DvMiKrcydyExEtKwYSqEnFT0tPiQONT3vA8gXdnc6MyVV4M+xjYUFtHcvAWpJMEYTsNF7uowuscLBYRGbzkwVJcfnpnpLKFVJyHGR6QAqkMc12ECER3Yp1rpl0MG1UbpzDgI8B3Va7ImKOiYpcsRzJ3UV5FPCwyXQGiEIU=
Message-ID: <6101e8c40802061506h65f8b61cs1b894441277c0df4@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:06:03 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {09/17} - sony-laptop-call-sonypi_compat_init-earlier - series for stable kernel #2
In-Reply-To: <6101e8c40802011734r7b99c3q7d24bf5678b83a0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011734r7b99c3q7d24bf5678b83a0b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattia Dongili <malattia@linux.it>
Date: Sun, 12 Aug 2007 07:20:27 +0000 (+0900)
Subject: sony-laptop: call sonypi_compat_init earlier
Patch-mainline: 2.6.23
References: 350984

sony-laptop: call sonypi_compat_init earlier

sonypi_compat uses a kfifo that needs to be present before _SRS is
called to be able to cope with the IRQs triggered when setting
resources.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Len Brown <len.brown@intel.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
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



On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: 015a916fbbf105bb15f4bbfd80c3b9b2f2e0d7db
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
