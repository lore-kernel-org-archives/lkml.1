Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbYCFVWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbYCFVWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYCFVVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:21:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:38442 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYCFVVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:21:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Z6iV0l5avesLwdasRZz5vWN74KgmoJ2a9dh2aTpROdVG9XLdjhc3U50IvCebVAEuufq7JnzCh0k+/NISzG3yZbbVyv7v46IGGUQLPA3M9U92krISxRDK5TbufYWrcVAkqpUqb+JQ4U7F9IF3mjNtsE4Mps+wtmQ+8y45vCBW+MA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: walt <w41ter@gmail.com>
Subject: Re: Commit 9f10d9ee breaks CD mounting/burning
Date: Thu, 6 Mar 2008 22:35:00 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@googlemail.com>
References: <fqngjf$cjf$1@ger.gmane.org>
In-Reply-To: <fqngjf$cjf$1@ger.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803062235.00396.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 06 March 2008, walt wrote:
> Hi Bartolmiej,
> 
> For me, this commit causes the problem it's intended to fix:
> 
> commit 9f10d9ee0ac6d79d7bc8b9a158bf4a29322d84d3
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Tue Feb 26 21:50:35 2008 +0100
> 
>      ide-cd: fix 'ireason' handling for REQ_TYPE_ATA_PC requests
> 
>      This fixes some hangs caused by not finishing the transfer before ending
>      the request and also makes use of 'ireason == 1' quirk for spurious IRQs.
> 
> When I mount a CD there is a long delay, and I see this error message:
> 
> hdc: ide_cd_check_ireason: wrong transfer direction!
> cdrom: failed setting lba address space
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> <repeated many times>
> 
> When I revert this commit everything works properly again, including
> CD burning.
> 
> Here is the drive info:
> 
> hdc: TSSTcorpCD/DVDW SH-S182M, ATAPI CD/DVD-ROM drive
> hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> hdc: UDMA/33 mode selected
> hdc: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
> Uniform CD-ROM driver Revision: 3.20
> hdc: UDMA/33 mode selected
> 
> I'm happy to try patches or supply more info, just let me know
> what you need.

Does the following patch help?

[ Borislav, please take a look and double check that it is OK. ]

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: mark REQ_TYPE_ATA_PC write requests with REQ_RW flag

On Thursday 06 March 2008, walt wrote:

> For me, this commit causes the problem it's intended to fix:
> 
> commit 9f10d9ee0ac6d79d7bc8b9a158bf4a29322d84d3
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Tue Feb 26 21:50:35 2008 +0100
> 
>      ide-cd: fix 'ireason' handling for REQ_TYPE_ATA_PC requests
> 
>      This fixes some hangs caused by not finishing the transfer before ending
>      the request and also makes use of 'ireason == 1' quirk for spurious IRQs.
> 
> When I mount a CD there is a long delay, and I see this error message:
> 
> hdc: ide_cd_check_ireason: wrong transfer direction!
> cdrom: failed setting lba address space
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> <repeated many times>
> 
> When I revert this commit everything works properly again, including
> CD burning.

It turned out that REQ_TYPE_ATA_PC write requests were not marked as such
(the previous commit assumed them to be).

Reported-by: walt <w41ter@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd_ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/drivers/ide/ide-cd_ioctl.c
===================================================================
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -457,6 +457,10 @@ int ide_cdrom_packet(struct cdrom_device
 	   layer. the packet must be complete, as we do not
 	   touch it at all. */
 	ide_cd_init_rq(drive, &req);
+
+	if (cgc->data_direction == CGC_DATA_WRITE)
+		req.cmd_flags |= REQ_RW;
+
 	memcpy(req.cmd, cgc->cmd, CDROM_PACKET_SIZE);
 	if (cgc->sense)
 		memset(cgc->sense, 0, sizeof(struct request_sense));

