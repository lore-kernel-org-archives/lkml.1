Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbYBPRep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYBPRep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbYBPRef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:34:35 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:19550 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbYBPRed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:34:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=HWiI3JYk+ac+AUA07celqARGGQzs9HXT7DIGWKQmwTw7jIaZvqWDKnh2jmpin22fBKyJS4dy0KTho47xYwLDlX48dr3IBvu20M+pk36gQJYepCl8sLsq/j22TwH0TVId+PMN44Qp9nogWsCGIkvTwYP5eaPtn+9nv5R14nr3vBw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: Optiarc DVD RW AD-5200A audio playing
Date: Sat, 16 Feb 2008 18:48:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
References: <47B5EDB7.5050709@canonical.com> <200802161624.02768.bzolnier@gmail.com> <20080216164302.GP13446@gollum.tnic>
In-Reply-To: <20080216164302.GP13446@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802161848.24475.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2008, Borislav Petkov wrote:
> On Sat, Feb 16, 2008 at 04:24:01PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > On Saturday 16 February 2008, Borislav Petkov wrote:
> > > On Fri, Feb 15, 2008 at 02:53:27PM -0500, Stefan Bader wrote:
> > > > Hello Borislav,
> > > > 
> > > > I worked on a problem with an DVD driver (model=Optiarc DVD RW AD-5200A)
> > > > which obviously has the same problem as some Matshita drives. The
> > > > following patch was reported to enabled audio playing on this drive.
> > > > Would this approach be suitable for upstream or are there other
> > > > solutions to this problem?
> > > > 
> > > > Regards,
> > > > Stefan
> > > > 
> > > > --- a/drivers/ide/ide-cd.c
> > > > +++ b/drivers/ide/ide-cd.c
> > > > @@ -2988,7 +2988,8 @@ int ide_cdrom_probe_capabilities (ide_drive_t *drive)
> > > >  	if (strcmp(drive->id->model, "MATSHITADVD-ROM SR-8187") == 0 ||
> > > >  	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8186") == 0 ||
> > > >  	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8176") == 0 ||
> > > > -	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8174") == 0)
> > > > +	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8174") == 0 ||
> > > > +	    strcmp(drive->id->model, "Optiarc DVD RW AD-5200A") == 0)
> > > >  		CDROM_CONFIG_FLAGS(drive)->audio_play = 1;
> > > > 
> > > >  #if ! STANDARD_ATAPI
> > > 
> > > Hi Stefan,
> > > 
> > > just to make sure that the audioplay bit is not set in the capabilities page,
> > > can you please try the following patch applied against 2.6.25-rc2 and send me
> > > the output. Thanks!
> > > 
> > > @Bart: by the way, this cdi->mask thingy is kinda unintuitive doing double
> > > negation to check whether a feature is supported or not. Yeah, this comes from
> > > "above," i.e. uniform cdrom layer. But still, shouldn't we use a cdi->caps_flags
> > > or something similar instead, which mirrors the caps page bits setting?
> > 
> > It seems so (at least having negative flags is very unintuitive) but they
> > might be some reason for this ugliness, Jens?
> > 
> > [ Please also remember that since cdrom layer is _uniform_ it may be not
> >   possible and/or desirable to have 1-1 mapping between caps page bits
> >   and the future cdi->caps_flags. ]
> > 
> > > commit 435f0f4496a1b32af2d542f43b2370a890fe2f83
> > > Author: Borislav Petkov <petkovbb@gmail.com>
> > > Date:   Sat Feb 16 09:56:36 2008 +0100
> > > 
> > >     ide-cd: Enable audio play quirk for Optiarc DVD RW AD-5200A drive
> > >     
> > >     Reported-by: Stefan Bader <stefan.bader@canonical.com>
> > >     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > > 
> > > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > > index f77db6b..2c9d06e 100644
> > > --- a/drivers/ide/ide-cd.c
> > > +++ b/drivers/ide/ide-cd.c
> > > @@ -1750,6 +1750,10 @@ int ide_cdrom_probe_capabilities (ide_drive_t *drive)
> > >  		cdi->mask &= ~(CDC_DVD_RAM | CDC_RAM);
> > >  	if (buf[8 + 3] & 0x10)
> > >  		cdi->mask &= ~CDC_DVD_R;
> > > +	if (!(buf[8 + 4] & 0x01)) {
> > 
> > Hmm, shouldn't there be '&& (cd->cd_flags & IDE_CD_FLAG_PLAY_AUDIO_OK)'
> > to prevent false positives?
> 
> I wanted to see whether the caps page reports the audioplay bit off...

we still need IDE_CD_FLAG_PLAY_AUDIO_OK flag to be _set_ to enable the quirk

> > 
> > > +		printk(KERN_INFO "ide-cd: audio play not advertised in caps page,"
> > 
> > Would be nice to also printk() the device name.
> 
> ... but printing the device model is actually a good idea and this will rule out
> false positives, so Stefan, please drop the previous patch and test the updated
> one below. Thanks.
> 
> 
> commit 6cc44b0ce5c9270b15d456eb9ffa91b855e4e0d0
> Author: Borislav Petkov <petkovbb@gmail.com>
> Date:   Sat Feb 16 09:56:36 2008 +0100
> 
>     ide-cd: Enable audio play quirk for Optiarc DVD RW AD-5200A drive
>     
>     Reported-by: Stefan Bader <stefan.bader@canonical.com>
>     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index f77db6b..4c9984f 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1750,6 +1750,11 @@ int ide_cdrom_probe_capabilities (ide_drive_t *drive)
>  		cdi->mask &= ~(CDC_DVD_RAM | CDC_RAM);
>  	if (buf[8 + 3] & 0x10)
>  		cdi->mask &= ~CDC_DVD_R;
> +	if (!(buf[8 + 4] & 0x01)) {
> +		printk(KERN_INFO "ide-cd: audio play not advertised in caps "
> +				"page for drive model [%s], enabling quirk.\n",
> +				drive->id->model);

if IDE_CD_FLAG_PLAY_AUDIO_OK flag is not set the above message is _bogus_
(because the quirk won't be enabled)

[ how's about just deleting the whole printk() to preserve simplicity? ]

> +	}
>  	if ((buf[8 + 4] & 0x01) || (cd->cd_flags & IDE_CD_FLAG_PLAY_AUDIO_OK))
>  		cdi->mask &= ~CDC_PLAY_AUDIO;
>  
> @@ -1929,6 +1934,7 @@ static const struct cd_list_entry ide_cd_quirks_list[] = {
>  	{ "MATSHITADVD-ROM SR-8186", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
>  	{ "MATSHITADVD-ROM SR-8176", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
>  	{ "MATSHITADVD-ROM SR-8174", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
> +	{ "Optiarc DVD RW AD-5200A", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK      },
>  	{ NULL, NULL, 0 }
>  };
