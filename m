Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZFBOPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZFBOPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZFBOOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:14:55 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:54352 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbZFBOOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=waj9cpgVBfNZIRcqK4v03PSydOq1LjoOs/IZiXFoRY0bVda1jw1wDUao4RM1djl5/w
         wn437z1gFh27AS90xs8AKNe9z9UjIztvwcFzsdP0JRGPyxQfQH7hXW12YiJ45MWiSSvY
         JcFSlm//moPCOxxtSPaqEJ3Pd14ImyZkTV3dI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/2] ide-tape: change IDE_AFLAG_IGNORE_DSC non-atomically
Date: Tue, 2 Jun 2009 15:17:52 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1243926308-32385-1-git-send-email-petkovbb@gmail.com> <200906021218.33787.bzolnier@gmail.com> <9ea470500906020608o14f8bc8dwaedabff70c1cb707@mail.gmail.com>
In-Reply-To: <9ea470500906020608o14f8bc8dwaedabff70c1cb707@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021517.53027.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 June 2009 15:08:27 Borislav Petkov wrote:
> Hi,
> 
> On Tue, Jun 2, 2009 at 12:18 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> 
> ..
> 
> >> --- a/drivers/ide/ide-tape.c
> >> +++ b/drivers/ide/ide-tape.c
> >> @@ -656,15 +656,24 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
> >>
> >>       if ((drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) == 0 &&
> >>           (rq->cmd[13] & REQ_IDETAPE_PC2) == 0)
> >> -             set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
> >> +             drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
> >>
> >>       if (drive->dev_flags & IDE_DFLAG_POST_RESET) {
> >> -             set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
> >> +             drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
> >>               drive->dev_flags &= ~IDE_DFLAG_POST_RESET;
> >>       }
> >>
> >> -     if (!test_and_clear_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags) &&
> >> -         (stat & ATA_DSC) == 0) {
> >> +     /*
> >> +      * This is a precaution for IDE_AFLAG_IGNORE_DSC being conditionally set
> >> +      * above. We don't need a stronger enforcement of ordering because the
> >> +      * read below cannot precede the earlier write out-of-order since it is
> >> +      * to the same location. Also, since we have the ide port locked during
> >> +      * the ->do_request(), we only have to be aware of gcc reordering stuff.
> >> +      */
> >> +     barrier();
> >
> > Are you seeing a real problem with gcc here?  No sane compiler should need
> > a barrier() here (we would probably need zillions of them in kernel if it
> > really does).
> 
> No, this is just a precaution. The asm I checked looked fine but since
> the flag is set and right afterwards checked, it will be bad if this
> somehow got reordered. I actually haven't checked whether anything like
> that would be possible, at all.

Please remove it then.
