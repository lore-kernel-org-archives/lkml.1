Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbZB0Gik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbZB0Gik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZB0Gi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:38:29 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:57684 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZB0Gi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:38:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=ohAprjwFp3fviZCZETIWMhtDLQ9ekVLkkyh7wX1L2m/DmGhyGg+X6Elsq2dPssKzrO
         SE/Jpm3hV7wZO+FJOo+QiVEk3V7t5SgLXKVJ5QztFxOqQEiScKdnP7OjNsrsClMWpAiV
         qplzJrU9wHm/QBPfyDJrrWvEyekrmpC9uLLdk=
Date: Fri, 27 Feb 2009 07:38:22 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] ide: flags query macros
Message-ID: <20090227063822.GA26358@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com> <20090223073452.GA1764@uranus.ravnborg.org> <20090223082539.GA24465@gollum.tnic> <200902262235.58796.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200902262235.58796.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Unfortunately my main concern is still not addressed -- namely the lack of
> consistency between names of flags and names of inline functions, ie.:
> 
> -               i, (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT) ? "off" : "on");
> +               i, ide_dev_no_32bit_io(drive) ? "off" : "on");
> 
> This is really the major issue because introduction of this abstraction
> was supposed to make code more readable and maintainable...
> 
> With the current version I get exactly the opposite feeling:
> - we have now different naming used for flags and inline functions
> - we use inline functions only for checking if flags are set

Sorry about that, will think of better names and fix.

> My other complaint is about changing my beloved CodingStyle, i.e.:
> 
> -       if (drive->media != ide_disk ||
> -           (drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
> +       if (drive->media != ide_disk || !ide_dev_present(drive))
>                 select |= HT_PREFETCH_MODE;
> 
> I see '== 0' immediately while it takes a while to notice '!' (funny that
> long time ago I preferred '!' because it's shorter but in the practice it
> turns out to be less readable and more prone to cause subtle bugs during
> code changes, though YMMV).

:) this is funny, I feel the exact opposite way: If I see the "!" at the
beginning of the if-clause I just read "not" together with the function
name so for example for

if (!ide_dev_present(drive))

you have "if ide device _not_ present" or even more closely matched word
order would be "if not ide device present", well, you get the idea.
That's one of the reasons I was trying to have more readable names
for those inlines. And this way it is much more natural when reading
the code instead of "== 0" check where you still have to think a bit :).

> Also after checking the code I think ide_{d,a}flag_ naming is better
> as it doesn't overlap with normal ide code...
> 
> > > diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
> > > index df3df00..3553759 100644
> > > --- a/drivers/ide/ide-cd_ioctl.c
> > > +++ b/drivers/ide/ide-cd_ioctl.c
> > > @@ -86,7 +86,7 @@ int ide_cdrom_check_media_change_real(struct cdrom_device_info *cdi,
> > > 
> > >         if (slot_nr == CDSL_CURRENT) {
> > >                 (void) cdrom_check_status(drive, NULL);
> > > -               retval = (drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED) ? 1 : 0;
> > > +               retval = ide_dev_media_changed(drive) ? 1 : 0;
> > >                 drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
> > >                 return retval;
> > >         } else {
> > > 
> > > The use of ? 1 : 0; here is redundant.
> > > 
> > >                         if (drive->media == ide_disk) {
> > > -                               printk(KERN_INFO "%s: non-IDE drive, CHS=%d/%d/%d\n",
> > > +                               pr_info("%s: non-IDE drive, CHS=%d/%d/%d\n",
> > >                                         drive->name, drive->cyl,
> > >                                         drive->head, drive->sect);
> > >                         } else if (drive->media == ide_cdrom) {
> > > -                               printk(KERN_INFO "%s: ATAPI cdrom (?)\n", drive->name);
> > > +                               pr_info("%s: ATAPI cdrom (?)\n", drive->name);
> > >                         } else {
> > >                                 /* nuke it */
> > > -                               printk(KERN_WARNING "%s: Unknown device on bus refused identification. Ignoring.\n",
> > > +drive->name);
> > > +                               pr_warning("%s: Unknown device on bus refused "
> > > +                                          "identification, ignoring.\n",
> > > +                                          drive->name);
> > > I did not see this addressed in the changelog?
> > 
> > Actually, that was in the v1 changelog but got forgotten. Bart, can you
> > please add to the changelog
> > 
> > - shorten >80 lines
> 
> What about printk() -> pr_info()/pr_warning()?
> 
> [ Which brings us to consistency issues again -- do you plan to convert
>   whole IDE code to use pr_*()?  If yes, great but please do it in separate
>   patches -- I think that converting only some printk()s is not worth it. ]

Well, I don't know, this could just as well be a kernel janitor task.
I'll revert to printks here since there's more important stuff to do
now.

> Please spend more time on documenting your changes properly.
> 
> You don't have to write a poem ;) but for reviewer it is important
> to know if changes are intentional or accidental (since it could be 
> as well unintentional left-over from your private tree)...

Point taken.

> > >                                 drive->dev_flags &= ~IDE_DFLAG_PRESENT;
> > > 
> > > You have a nice set of inlines to facilitate testing bits,
> > > but not for the above use?
> > > I guess this was not worth the abstraction for now.
> > 
> > Yeah, those are next but I'd like to wait a bit until ide rewrite
> > settles...
> 
> This should happen in this patch to keep the consistency, moreover since
> you introduced nice macros to define "test" helpers you can now easily extend
> them for "clear" ones, i.e.:
> 
> +#define IDE_AFLAG_(name, flag) \
> +static inline int ide_test_aflag_##name(ide_drive_t *drive) \
> +{ \
> +       return !!(drive->atapi_flags & flag); \
> +} \
> +static inline void ide_clear_aflag_##name(ide_drive_t *drive) \
> +{ \
> +       drive->atapi_flags &= ~flag; \
> +}
> 
> BTW you may want to delay this patch after 2.6.30 as things should
> become much more peaceful then.

What exactly is the timeframe here? Do you want to have the updated
version for the 2.6.31 merge window?

-- 
Regards/Gruss,
    Boris.
