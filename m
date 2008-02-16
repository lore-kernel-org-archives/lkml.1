Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYBPQnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYBPQnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbYBPQng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:43:36 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:43843 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbYBPQne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:43:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=ukFuK1Kidh54MxkrL3tqovfad2j9SpBRKY4UgMlIG0okejjYd7yghrae1LxIot1eBKYN2jBCUJdWMWJHRvUL51hecRV9tATp2/Svp35iVQ+zTLQ0o+v1kZhL1ZHyW4Brn3x8QKegwZCplsViWwwg0GdtGaUYDLMqZdlmkmtz2Hg=
Date: Sat, 16 Feb 2008 17:43:02 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Optiarc DVD RW AD-5200A audio playing
Message-ID: <20080216164302.GP13446@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Stefan Bader <stefan.bader@canonical.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
References: <47B5EDB7.5050709@canonical.com> <20080216090532.GK13446@gollum.tnic> <200802161624.02768.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802161624.02768.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 04:24:01PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Saturday 16 February 2008, Borislav Petkov wrote:
> > On Fri, Feb 15, 2008 at 02:53:27PM -0500, Stefan Bader wrote:
> > > Hello Borislav,
> > > 
> > > I worked on a problem with an DVD driver (model=Optiarc DVD RW AD-5200A)
> > > which obviously has the same problem as some Matshita drives. The
> > > following patch was reported to enabled audio playing on this drive.
> > > Would this approach be suitable for upstream or are there other
> > > solutions to this problem?
> > > 
> > > Regards,
> > > Stefan
> > > 
> > > --- a/drivers/ide/ide-cd.c
> > > +++ b/drivers/ide/ide-cd.c
> > > @@ -2988,7 +2988,8 @@ int ide_cdrom_probe_capabilities (ide_drive_t *drive)
> > >  	if (strcmp(drive->id->model, "MATSHITADVD-ROM SR-8187") == 0 ||
> > >  	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8186") == 0 ||
> > >  	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8176") == 0 ||
> > > -	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8174") == 0)
> > > +	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8174") == 0 ||
> > > +	    strcmp(drive->id->model, "Optiarc DVD RW AD-5200A") == 0)
> > >  		CDROM_CONFIG_FLAGS(drive)->audio_play = 1;
> > > 
> > >  #if ! STANDARD_ATAPI
> > 
> > Hi Stefan,
> > 
> > just to make sure that the audioplay bit is not set in the capabilities page,
> > can you please try the following patch applied against 2.6.25-rc2 and send me
> > the output. Thanks!
> > 
> > @Bart: by the way, this cdi->mask thingy is kinda unintuitive doing double
> > negation to check whether a feature is supported or not. Yeah, this comes from
> > "above," i.e. uniform cdrom layer. But still, shouldn't we use a cdi->caps_flags
> > or something similar instead, which mirrors the caps page bits setting?
> 
> It seems so (at least having negative flags is very unintuitive) but they
> might be some reason for this ugliness, Jens?
> 
> [ Please also remember that since cdrom layer is _uniform_ it may be not
>   possible and/or desirable to have 1-1 mapping between caps page bits
>   and the future cdi->caps_flags. ]
> 
> > commit 435f0f4496a1b32af2d542f43b2370a890fe2f83
> > Author: Borislav Petkov <petkovbb@gmail.com>
> > Date:   Sat Feb 16 09:56:36 2008 +0100
> > 
> >     ide-cd: Enable audio play quirk for Optiarc DVD RW AD-5200A drive
> >     
> >     Reported-by: Stefan Bader <stefan.bader@canonical.com>
> >     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > 
> > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > index f77db6b..2c9d06e 100644
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -1750,6 +1750,10 @@ int ide_cdrom_probe_capabilities (ide_drive_t *drive)
> >  		cdi->mask &= ~(CDC_DVD_RAM | CDC_RAM);
> >  	if (buf[8 + 3] & 0x10)
> >  		cdi->mask &= ~CDC_DVD_R;
> > +	if (!(buf[8 + 4] & 0x01)) {
> 
> Hmm, shouldn't there be '&& (cd->cd_flags & IDE_CD_FLAG_PLAY_AUDIO_OK)'
> to prevent false positives?

I wanted to see whether the caps page reports the audioplay bit off...

> 
> > +		printk(KERN_INFO "ide-cd: audio play not advertised in caps page,"
> 
> Would be nice to also printk() the device name.

... but printing the device model is actually a good idea and this will rule out
false positives, so Stefan, please drop the previous patch and test the updated
one below. Thanks.


commit 6cc44b0ce5c9270b15d456eb9ffa91b855e4e0d0
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Sat Feb 16 09:56:36 2008 +0100

    ide-cd: Enable audio play quirk for Optiarc DVD RW AD-5200A drive
    
    Reported-by: Stefan Bader <stefan.bader@canonical.com>
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index f77db6b..4c9984f 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1750,6 +1750,11 @@ int ide_cdrom_probe_capabilities (ide_drive_t *drive)
 		cdi->mask &= ~(CDC_DVD_RAM | CDC_RAM);
 	if (buf[8 + 3] & 0x10)
 		cdi->mask &= ~CDC_DVD_R;
+	if (!(buf[8 + 4] & 0x01)) {
+		printk(KERN_INFO "ide-cd: audio play not advertised in caps "
+				"page for drive model [%s], enabling quirk.\n",
+				drive->id->model);
+	}
 	if ((buf[8 + 4] & 0x01) || (cd->cd_flags & IDE_CD_FLAG_PLAY_AUDIO_OK))
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 
@@ -1929,6 +1934,7 @@ static const struct cd_list_entry ide_cd_quirks_list[] = {
 	{ "MATSHITADVD-ROM SR-8186", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
 	{ "MATSHITADVD-ROM SR-8176", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
 	{ "MATSHITADVD-ROM SR-8174", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
+	{ "Optiarc DVD RW AD-5200A", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK      },
 	{ NULL, NULL, 0 }
 };
 

-- 
Regards/Gruﬂ,
    Boris.
