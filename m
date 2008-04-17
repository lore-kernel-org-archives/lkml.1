Return-Path: <linux-kernel-owner+w=401wt.eu-S933820AbYDQJbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820AbYDQJbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763600AbYDQJMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:12:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:38749 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763924AbYDQJMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:12:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sORK3tKzms38YpwPcWzNjTnKCQfXDiqTyZN6pPibzBhsm3q/6MCsb6whTEwl2PFgmoRrze6BZOx8UKq/ilfGYY+G1HvYat9QCpMHgGGxZzyJf5hzkJSyZ6Xhospr8O48uLIv9AOGsfOARE+S/5gKOLZG3vbrOsud9BI7z7FhYOE=
Message-ID: <9ea470500804170212md8ce430p42b3c1787ba95631@mail.gmail.com>
Date: Thu, 17 Apr 2008 11:12:30 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Roel Kluin" <12o3l@tiscali.nl>
Subject: Re: [PATCH 3/6] IDE: ide-cd: fix test unsigned var < 0
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4806C952.6030102@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48055F1A.9020706@tiscali.nl>
	 <200804170040.07397.bzolnier@gmail.com> <4806C952.6030102@tiscali.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 5:51 AM, Roel Kluin <12o3l@tiscali.nl> wrote:
> Bartlomiej Zolnierkiewicz wrote:
>  > Hi,
>  >
>  > On Wednesday 16 April 2008, Roel Kluin wrote:
>  >> Is this the right fix in this case?
>  >
>  > Yes, but it seems that 'valid' is only written to
>  > so it may be as well removed completely.
>  >
>  > Care to update the patch?
>  >
>  > Thanks,
>  > Bart
>
>  how about this?
>
>  Roel
>
>  ---
>  Clean up cdrom_analyze_sense_data()
>
>
>  Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>  ---
>  diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
>  index a60f5df..a5f3beb 100644
>
> --- a/drivers/ide/ide-cd.c
>  +++ b/drivers/ide/ide-cd.c
>  @@ -143,8 +143,6 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
>                               struct request_sense *sense)
>   {
>         unsigned long sector;
>  -       unsigned long bio_sectors;
>  -       unsigned long valid;
>         struct cdrom_info *info = drive->driver_data;
>
>         if (!cdrom_log_sense(drive, failed_command, sense))
>  @@ -174,13 +172,9 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
>                                  (sense->information[2] <<  8) |
>                                  (sense->information[3]);
>
>  -                       bio_sectors = bio_sectors(failed_command->bio);
>  -                       if (bio_sectors < 4)
>  -                               bio_sectors = 4;
>                         if (drive->queue->hardsect_size == 2048)
>                                 sector <<= 2;   /* Device sector size is 2K */
>  -                       sector &= ~(bio_sectors -1);
>
> -                       valid = (sector - failed_command->sector) << 9;
>  +                       sector &= ~(max(bio_sectors(failed_command->bio) - 1, 3));

Well, i don't think that this "optimization" makes the code more readable.
Besides, gcc does this anyway. Poor are only those who have to stare at it for
a couple of minutes just to understand what it says. Still, i don't object to
it completely and the "valid"-var can go. I'd rather keep the "unsigned long
bio_sectors;" part and do something of the likes of:

bio_sectors = bio_sectors(failed_command->bio);


(remove the "if (bio_sectors < 4)"-test)

... and later...

sector &= ~(max(bio_sectors - 1, 3));

which is, IMO, more readable.

Roel, would you redo your patch please? Thanks.

-- 
Regards/Gruß,
Boris
