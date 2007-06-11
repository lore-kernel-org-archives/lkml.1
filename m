Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbXFKVqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbXFKVqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbXFKVq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:46:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:28564 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbXFKVq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:46:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=IVlLqnQUjjLSEXD9JzwPGYNIFp5P+G1p1NEiGONLYLEoDFbB/kLA8AFH+gf345e4aBwM2z9WtS9QBtdiHHh4kE2RBprnD7N4eqeSujGgNp2i8Co9efyjx3K4y7G9escnsxAHPCXrEbH/Olkb3UITZY3KbS96Sm10IqGs+sGD7+c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.22-rc4-mm2: Resume from RAM on HPC nx6325 broken
Date: Tue, 12 Jun 2007 00:01:19 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Lee Trager <lt73@cs.drexel.edu>
References: <200706111649.00578.rjw@sisk.pl> <200706112203.30032.bzolnier@gmail.com>
In-Reply-To: <200706112203.30032.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706120001.20013.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On the second thought...

On Monday 11 June 2007, Bartlomiej Zolnierkiewicz wrote:

> I find it hard to accept that IDE patch is to blame for that. ;)

Arrgghhh :)  It looks more likely now...

> --- a/drivers/ide/ide.c
> +++ b/drivers/ide/ide.c
> @@ -1010,9 +1010,11 @@ static int generic_ide_resume(struct dev
>  {
>  	ide_drive_t *drive = dev->driver_data;
>  	ide_hwif_t *hwif = HWIF(drive);
> +	ide_driver_t *drv = to_ide_driver(dev->driver);
>  	struct request rq;
>  	struct request_pm_state rqpm;
>  	ide_task_t args;
> +	int err;
>  
>  	/* Call ACPI _STM only once */
>  	if (!(drive->dn % 2))
> @@ -1029,7 +1031,12 @@ static int generic_ide_resume(struct dev
>  	rqpm.pm_step = ide_pm_state_start_resume;
>  	rqpm.pm_state = PM_EVENT_ON;
>  
> -	return ide_do_drive_cmd(drive, &rq, ide_head_wait);
> +	err = ide_do_drive_cmd(drive, &rq, ide_head_wait);
> +
> +	if (err == 0 && drv && drv->resume)

Could you try replacing this by

if (err == 0 && dev->driver && drv->resume)

and see if it fixes the problem?

If dev->driver is NULL drv won't be because to_ide_driver() is just
a wrapper for container_of().

Thanks,
Bart
