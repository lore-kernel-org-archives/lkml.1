Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbZBZVey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbZBZVey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZBZVeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:34:44 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:54103 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZBZVen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:34:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=estHQ4ysueZS8t7Xauo5R1nUfEa3yMfUK4+M9J0vYznZAwC7kMZVGngVfsPy1aFQFc
         u238dIHGvNIwkERziSkHAK+mFUxeafWRi1tp10F41iam/NdlM5sF/USwIf+gsmO2/T5j
         g1nmHFRO8S1GSn/ggSsu1Wmmzwry3Wjbl765Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 0/10] ide: flags query macros
Date: Thu, 26 Feb 2009 22:35:58 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090225; KDE/4.2.0; i686; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com> <20090223073452.GA1764@uranus.ravnborg.org> <20090223082539.GA24465@gollum.tnic>
In-Reply-To: <20090223082539.GA24465@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902262235.58796.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Borislav Petkov wrote:
> On Mon, Feb 23, 2009 at 08:34:52AM +0100, Sam Ravnborg wrote:
> > On Mon, Feb 23, 2009 at 08:04:13AM +0100, Borislav Petkov wrote:
> > > > Since it is not a lot of modified lines and the change is rather
> > > > straightforward it could as well be done in a single patch...
> > > 
> > > here's version 2:
> > > --
> > > From: Borislav Petkov <petkovbb@gmail.com>
> > > Date: Mon, 23 Feb 2009 07:58:23 +0100
> > > Subject: [PATCH] ide: flags query macros
> > > 
> > > Add drive->atapi_flags and drive->dev_flags macro wrappers
> > > 
> > > v2:
> > > - use static inlines for better typechecking
> > > - use macro indirection for convenience
> > > 
> > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > 
> > Version 2 looks much better - thanks.

Yep, definitely an improvement.

Unfortunately my main concern is still not addressed -- namely the lack of
consistency between names of flags and names of inline functions, ie.:

-               i, (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT) ? "off" : "on");
+               i, ide_dev_no_32bit_io(drive) ? "off" : "on");

This is really the major issue because introduction of this abstraction
was supposed to make code more readable and maintainable...

With the current version I get exactly the opposite feeling:
- we have now different naming used for flags and inline functions
- we use inline functions only for checking if flags are set

My other complaint is about changing my beloved CodingStyle, i.e.:

-       if (drive->media != ide_disk ||
-           (drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+       if (drive->media != ide_disk || !ide_dev_present(drive))
                select |= HT_PREFETCH_MODE;

I see '== 0' immediately while it takes a while to notice '!' (funny that
long time ago I preferred '!' because it's shorter but in the practice it
turns out to be less readable and more prone to cause subtle bugs during
code changes, though YMMV).

Also after checking the code I think ide_{d,a}flag_ naming is better
as it doesn't overlap with normal ide code...

> > diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
> > index df3df00..3553759 100644
> > --- a/drivers/ide/ide-cd_ioctl.c
> > +++ b/drivers/ide/ide-cd_ioctl.c
> > @@ -86,7 +86,7 @@ int ide_cdrom_check_media_change_real(struct cdrom_device_info *cdi,
> > 
> >         if (slot_nr == CDSL_CURRENT) {
> >                 (void) cdrom_check_status(drive, NULL);
> > -               retval = (drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED) ? 1 : 0;
> > +               retval = ide_dev_media_changed(drive) ? 1 : 0;
> >                 drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
> >                 return retval;
> >         } else {
> > 
> > The use of ? 1 : 0; here is redundant.
> > 
> >                         if (drive->media == ide_disk) {
> > -                               printk(KERN_INFO "%s: non-IDE drive, CHS=%d/%d/%d\n",
> > +                               pr_info("%s: non-IDE drive, CHS=%d/%d/%d\n",
> >                                         drive->name, drive->cyl,
> >                                         drive->head, drive->sect);
> >                         } else if (drive->media == ide_cdrom) {
> > -                               printk(KERN_INFO "%s: ATAPI cdrom (?)\n", drive->name);
> > +                               pr_info("%s: ATAPI cdrom (?)\n", drive->name);
> >                         } else {
> >                                 /* nuke it */
> > -                               printk(KERN_WARNING "%s: Unknown device on bus refused identification. Ignoring.\n",
> > +drive->name);
> > +                               pr_warning("%s: Unknown device on bus refused "
> > +                                          "identification, ignoring.\n",
> > +                                          drive->name);
> > I did not see this addressed in the changelog?
> 
> Actually, that was in the v1 changelog but got forgotten. Bart, can you
> please add to the changelog
> 
> - shorten >80 lines

What about printk() -> pr_info()/pr_warning()?

[ Which brings us to consistency issues again -- do you plan to convert
  whole IDE code to use pr_*()?  If yes, great but please do it in separate
  patches -- I think that converting only some printk()s is not worth it. ]

Please spend more time on documenting your changes properly.

You don't have to write a poem ;) but for reviewer it is important
to know if changes are intentional or accidental (since it could be 
as well unintentional left-over from your private tree)...

> >                                 drive->dev_flags &= ~IDE_DFLAG_PRESENT;
> > 
> > You have a nice set of inlines to facilitate testing bits,
> > but not for the above use?
> > I guess this was not worth the abstraction for now.
> 
> Yeah, those are next but I'd like to wait a bit until ide rewrite
> settles...

This should happen in this patch to keep the consistency, moreover since
you introduced nice macros to define "test" helpers you can now easily extend
them for "clear" ones, i.e.:

+#define IDE_AFLAG_(name, flag) \
+static inline int ide_test_aflag_##name(ide_drive_t *drive) \
+{ \
+       return !!(drive->atapi_flags & flag); \
+} \
+static inline void ide_clear_aflag_##name(ide_drive_t *drive) \
+{ \
+       drive->atapi_flags &= ~flag; \
+}

BTW you may want to delay this patch after 2.6.30 as things should
become much more peaceful then.

Thanks,
Bart
