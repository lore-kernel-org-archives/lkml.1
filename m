Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZEJVgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZEJVgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbZEJVgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:36:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34859 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbZEJVgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=fob4EHgdzO60+o2nsZxl3mJLoY0vHpryFD4jfvPAkb3MDIDTc0I0+YyOM+XpU1274m
         E46GE5wopg5IXqa2r6OW85+d9rsIuU0DpM+uQunY9rQuYhDUlm4EKLPWjglyStNft9wF
         Fn8D95HjU20e7jioHhhOzt2DmDVVF5a1fSX90=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 05/14] ide-atapi: add a buffer-arg to ide_queue_pc_tail
Date: Sun, 10 May 2009 23:32:35 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <1241855134-4984-6-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1241855134-4984-6-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905102332.35931.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 May 2009 09:45:25 Borislav Petkov wrote:
> This is in preparation of removing ide_atapi_pc. Expose the buffer as an
> argument to ide_queue_pc_tail with later replacing it with local buffer
> or even kmalloc'ed one if needed due to stack usage constraints.
> 
> Also, add the possibility of passing a NULL-ptr buffer for cmds which
> don't transfer data besides the cdb.
> 
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-atapi.c        |   12 ++++++------
>  drivers/ide/ide-floppy.c       |   17 ++++++++---------
>  drivers/ide/ide-floppy_ioctl.c |   16 ++++++++--------
>  drivers/ide/ide-tape.c         |   37 ++++++++++++++++++-------------------
>  include/linux/ide.h            |    2 +-
>  5 files changed, 41 insertions(+), 43 deletions(-)

[...]

> @@ -1637,11 +1636,11 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
>  {
>  	idetape_tape_t *tape = drive->driver_data;
>  	struct ide_atapi_pc pc;
> -	u8 *caps;
> +	u8 buf[24], *caps;
>  	u8 speed, max_speed;
>  
>  	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
> -	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer)) {
> +	if (ide_queue_pc_tail(drive, tape->disk, &pc, buf, pc.req_xfer)) {
>  		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
>  				" some default values\n");
>  		tape->blk_size = 512;
> @@ -1650,7 +1649,7 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
>  		put_unaligned(6*52, (u16 *)&tape->caps[16]);
>  		return;
>  	}
> -	caps = pc.buf + 4 + pc.buf[3];
> +	caps = buf + 4 + buf[3];

Ideally the above change should also be in the separate patch
(or at least documented in the description of this patch).
