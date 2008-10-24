Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYJXHpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYJXHpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYJXHou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:44:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:52948 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYJXHot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VlBiFsKUOx9MCt276n0wRLHeoS5p32YOPK+JLknfNKb1cN48xbts76AZ3mGVV7JWbm
         poMmQhTdVub1esqy3xP5bVbZYBMoGGEXTNay91vqm2PQbo4PyVmrRpsOy7TzZECS4rij
         T3SpkITlu8Z8Hmu/mV7Rtng6NfDyn7D0sYsuM=
Message-ID: <a8e1da0810240044o115fa6e3h32c1184bcfc6f5e5@mail.gmail.com>
Date: Fri, 24 Oct 2008 15:44:49 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: 2.6.27-rc1 (2fca5c): libata: kernel cant boot
Cc: "Paul Mundt" <lethal@linux-sh.org>,
       "Alexander Beregalov" <a.beregalov@gmail.com>, tj@kernel.org,
       torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
In-Reply-To: <20081024072428.GP22217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810240004t2d7c3bdah2bea77a6a49bb7c4@mail.gmail.com>
	 <20081024070955.GN22217@kernel.dk> <20081024071329.GO22217@kernel.dk>
	 <20081024071608.GA3879@linux-sh.org>
	 <20081024072428.GP22217@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 3:24 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Fri, Oct 24 2008, Paul Mundt wrote:
>> On Fri, Oct 24, 2008 at 09:13:29AM +0200, Jens Axboe wrote:
>> > On Fri, Oct 24 2008, Jens Axboe wrote:
>> > > On Fri, Oct 24 2008, Alexander Beregalov wrote:
>> > > > Hi
>> > > >
>> > > > commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e
>> > > > Author: Jens Axboe <jens.axboe@oracle.com>
>> > > > Date:   Wed Oct 22 09:34:49 2008 +0200
>> > > >
>> > > >     libata: switch to using block layer tagging support
>> > > >
>> > > >
>> > > > This kernel can not read even 0 sector on disk with rootfs. It
>> > > > initialized disk, but cant read it at all.
>> > > >  CMD646 on Sparc
>> > > >
>> > > > Rverting helped.
>> > >
>> > > Doh, how annoying! What driver does that controller use? PATA doesn't
>> > > even use NCQ, so it's a bit of an oddity that it makes a difference at
>> > > all.
>> > >
>> > > Can you provide the boot messages?
>> >
>> > Darn, this smells like a train wreck. I'm assuming this fixes it?
>> >
>> Yes, that fixes it.

To confirm: 2.6.28-rc1 ata-piix, fixed for me as well.

>
> OK, that's pretty bad. 2.6.28-rc1 will not work on any box using libata
> with non-ncq disks. If you need me, I'll be at the bar.
>
> ----------
>
> From e598055dde1951c47c8b3522616f6ebff0ed9847 Mon Sep 17 00:00:00 2001
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Fri, 24 Oct 2008 09:22:42 +0200
> Subject: [PATCH] libata: fix bug with non-ncq devices
>
> The recent commit 201f1b98822078c808b5e2d379a6ddbfc0a06ee1 to enable
> support for block layer tagging in libata was broken for non-NCQ
> devices. The block layer initializes the tag field to -1 to detect
> invalid uses of a tag, and if the libata devices does NOT support
> NCQ, we just used that field to index the internal command list.
> So we need to check for -1 first and only use the tag field if
> it's valid.
>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/ata/libata-scsi.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index d5b9b72..4b95c43 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -708,7 +708,11 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
>  {
>        struct ata_queued_cmd *qc;
>
> -       qc = ata_qc_new_init(dev, cmd->request->tag);
> +       if (cmd->request->tag != -1)
> +               qc = ata_qc_new_init(dev, cmd->request->tag);
> +       else
> +               qc = ata_qc_new_init(dev, 0);
> +
>        if (qc) {
>                qc->scsicmd = cmd;
>                qc->scsidone = done;
> --
> 1.6.0.2.588.g3102
>
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
dave
