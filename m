Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbZFWHvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbZFWHvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbZFWHv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:51:26 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:63369 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757408AbZFWHvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:51:24 -0400
From: Frans Pop <elendil@planet.nl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: Improve "weird block size" error message
Date: Tue, 23 Jun 2009 09:51:23 +0200
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906211446.38598.elendil@planet.nl> <200906222101.38586.elendil@planet.nl> <200906222335.06700.bzolnier@gmail.com>
In-Reply-To: <200906222335.06700.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906230951.24615.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jun 2009 07:51:25.0372 (UTC) FILETIME=[68833FC0:01C9F3D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Bartlomiej Zolnierkiewicz wrote:
> On Monday 22 June 2009 21:01:37 Frans Pop wrote:
> > There is one thing I should mention here. I have been seeing the
> > following error with this CD drive:
> > ide-cd: hdd: weird block size 2352
> > ide-cd: hdd: default to 2kb block size
>
> This is just a harmless warning coming from enabling of the workaround
> for weird ATAPI devices (the one you have in this sparc machine seems
> to score really high on the weirdness scale ;) introduced by commit
> e8e7b9e.

In that case I'd like to propose the following patch. Currently the error
can get printed much to frequently when there's a disc in the drive.
Example:

Jun 13 18:06:28 gimli kernel: ide-cd: hdd: weird block size 2352
Jun 13 18:06:28 gimli kernel: ide-cd: hdd: default to 2kb block size
Jun 13 18:06:32 gimli kernel: ide-cd: hdd: weird block size 2352
Jun 13 18:06:42 gimli kernel: ide-cd: hdd: default to 2kb block size
Jun 13 18:07:02 gimli kernel: ide-cd: hdd: weird block size 2352
Jun 13 18:07:02 gimli kernel: ide-cd: hdd: default to 2kb block size
Jun 13 18:07:05 gimli kernel: ide-cd: hdd: weird block size 2352
Jun 13 18:07:05 gimli kernel: ide-cd: hdd: default to 2kb block size
Jun 13 18:07:09 gimli kernel: ide-cd: hdd: weird block size 2352
Jun 13 18:07:09 gimli kernel: ide-cd: hdd: default to 2kb block size
Jun 13 18:07:14 gimli kernel: ide-cd: hdd: weird block size 2352
Jun 13 18:07:14 gimli kernel: ide-cd: hdd: default to 2kb block size
Jun 13 18:07:35 gimli kernel: ide-cd: hdd: weird block size 2352
Jun 13 18:07:35 gimli kernel: ide-cd: hdd: default to 2kb block size
Jun 13 18:07:51 gimli kernel: ide-cd: hdd: weird block size 2352
Jun 13 18:07:51 gimli kernel: ide-cd: hdd: default to 2kb block size

I was not using the CD at all here. I suspect HAL's stupid polling to be
the culprit as I first saw it after upgrading X.Org packages to a version
which depends on HAL. I since disabled polling for the device, but I
still feel that warning once should be sufficient as IIUC the value is
device dependent and not medium dependent.

With the patch it only gets printed once, when the driver is initialized.

Cheers,
FJP

---
From: Frans Pop <elendil@planet.nl>
Subject: ide-cd: Improve "weird block size" error message

Currently the error gets repeated too frequently, for example
each time HAL polls the device when a disc is present. Avoid that
by using printk_once instead of printk.
Also join the error and corrective action messages into a single line.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 4a19686..7ec6996 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -886,10 +886,9 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	case 4096:
 		break;
 	default:
-		printk(KERN_ERR PFX "%s: weird block size %u\n",
+		printk_once(KERN_ERR PFX "%s: weird block size %u; "
+				"setting default block size to 2048\n",
 				drive->name, blocklen);
-		printk(KERN_ERR PFX "%s: default to 2kb block size\n",
-				drive->name);
 		blocklen = 2048;
 		break;
 	}
