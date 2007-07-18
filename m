Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbXGROMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbXGROMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbXGROMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:12:01 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:37655 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753708AbXGROMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:12:00 -0400
Subject: Re: block/bsg.c
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <200707180243.13368.bzolnier@gmail.com>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	 <1184710755.3378.30.camel@localhost.localdomain>
	 <469D52D1.1000803@garzik.org>  <200707180243.13368.bzolnier@gmail.com>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 09:11:57 -0500
Message-Id: <1184767917.3464.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 02:43 +0200, Bartlomiej Zolnierkiewicz wrote:
> [ James, please remeber to cc: linux-ide on IDE patches, thanks. ]

Blame Andrew ... I assumed he'd be reporting the problem to the relevant
lists, so I just did a reply all ...

> On Wednesday 18 July 2007, Jeff Garzik wrote:
> > James Bottomley wrote:
> > > @@ -1052,9 +1054,10 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
> > >  	int err, (*setfunc)(ide_drive_t *, int);
> > >  	u8 *val;
> > >  
> > > -	err = scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> > > -	if (err != -ENOTTY)
> > > -		return err;
> > > +	switch (cmd) {
> > > +	case SG_IO:
> > > +		return scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> > > +	}
> > >  
> > >  	switch (cmd) {
> > >  	case HDIO_GET_32BIT:	    val = &drive->io_32bit;	 goto read_val;
> > 
> > 
> > At that point you might as well use an 'if'.
> > 
> > But overall -- agreed.  ACK.
> 
> James/Jeff thanks for following the issue but NAK. ;)
> 
> Causes regression wrt ide-floppy CDROMEJECT/CDROMCLOSETRAY support when
> compared to 2.6.22 and SG_IO is not supported by ide-{disk,scsi,tape}.

Well ... that was why I put the case statement in ... I was sure there
would be other ioctls I missed.

> Luckily Linus has already fixed the issue properly.

Actually, no, that's just a reversion.  I think we need the attached to
complete all of this.

> BTW cmd == 1 IOCTL is not defined/used by IDE driver.

Andrew's trace clearly shows that something is sending cmd == 1 down, so
I'm nearly positive at one time this was a legitimate ioctl for IDE.
Anyway it's probably time to kill this deprecated ioctl in SCSI.

James

diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 077fb67..fe65473 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -156,6 +156,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#include <scsi/sg.h>
 
 /* default maximum number of failures */
 #define IDE_DEFAULT_MAX_FAILURES 	1
@@ -1173,6 +1174,7 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 
 		case CDROMEJECT:
 		case CDROMCLOSETRAY:
+		case SG_IO:
 			return scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
 
 		case HDIO_GET_BUSSTATE:


