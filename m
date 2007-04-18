Return-Path: <linux-kernel-owner+w=401wt.eu-S2992614AbXDROcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992614AbXDROcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992624AbXDROcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:32:50 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:2574 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992614AbXDROct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:32:49 -0400
Message-ID: <46262C0E.9000103@rtr.ca>
Date: Wed, 18 Apr 2007 10:32:46 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, 7eggert@gmx.de,
       Chuck Ebbert <cebbert@redhat.com>, emisca <emisca.ml@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <88SeR-5Sf-15@gated-at.bofh.it>	<88Sov-662-3@gated-at.bofh.it>	<88SHV-6uL-29@gated-at.bofh.it>	<8agVk-3wc-81@gated-at.bofh.it>	<8b3IR-4mE-25@gated-at.bofh.it>	<8b3SA-4z3-5@gated-at.bofh.it>	<8b42g-51N-15@gated-at.bofh.it>	<8bbdm-7iS-27@gated-at.bofh.it>	<E1He8dA-0000mw-LI@be1.lrz>	<46260981.1040109@gmail.com>	<20070418132904.3322ba5f@the-village.bc.nu>	<46261337.3010406@gmail.com> <20070418140346.636879a1@the-village.bc.nu>
In-Reply-To: <20070418140346.636879a1@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>
> If you see a synchronize cache succeed and you then see the drive
> shutdown succeed then you know that a sync cache can be faked as ok
> safely. Any other command in between or after and it doesn't get faked
> 
> This seems pretty easy to deal with at command issue.

Yup.  It could be as trivial as this (untested, and not as nice
as Alan's full suggestion).

Signed-off-by:  Mark Lord <mlord@pobox.com>
---
--- linux/include/linux/libata.h.orig	2007-04-18 10:30:25.000000000 -0400
+++ linux/include/linux/libata.h	2007-04-18 10:30:28.000000000 -0400
@@ -499,6 +499,7 @@
 	struct ata_ering	ering;
 	int			spdn_cnt;
 	unsigned int		horkage;	/* List of broken features */
+	int			needs_flush;	/* bool: 1==written since last flush */
 #ifdef CONFIG_SATA_ACPI
 	/* ACPI objects info */
 	acpi_handle obj_handle;
--- linux/drivers/old/libata-scsi.c	2007-04-17 22:11:12.000000000 -0400
+++ linux/drivers/ata/libata-scsi.c	2007-04-18 10:27:29.000000000 -0400
@@ -2749,18 +2749,20 @@
 			return atapi_xlat;
 
 	switch (cmd) {
-	case READ_6:
-	case READ_10:
-	case READ_16:
-
 	case WRITE_6:
 	case WRITE_10:
 	case WRITE_16:
+		dev->needs_flush = 1;
+	case READ_6:
+	case READ_10:
+	case READ_16:
 		return ata_scsi_rw_xlat;
 
 	case SYNCHRONIZE_CACHE:
-		if (ata_try_flush_cache(dev))
+		if (dev->needs_flush && ata_try_flush_cache(dev)) {
 			return ata_scsi_flush_xlat;
+			dev->needs_flush = 0;
+		}
 		break;
 
 	case VERIFY:
