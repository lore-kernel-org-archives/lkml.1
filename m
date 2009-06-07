Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZFGPTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZFGPTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbZFGPS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:18:56 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51394 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541AbZFGPSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:18:55 -0400
Subject: Re: [git pull] IDE fixes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200906071657.49513.bzolnier@gmail.com>
References: <200906071444.33047.bzolnier@gmail.com>
	 <20090607152151.3cb01901@lxorguk.ukuu.org.uk>
	 <1244385536.8262.5.camel@mulgrave.site>
	 <200906071657.49513.bzolnier@gmail.com>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 10:18:51 -0500
Message-Id: <1244387931.8262.24.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 16:57 +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 07 June 2009 16:38:56 James Bottomley wrote:
> > On Sun, 2009-06-07 at 15:21 +0100, Alan Cox wrote:
> > > > diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> > > > index 99e33ef..4bc2c43 100644
> > > > --- a/fs/partitions/check.c
> > > > +++ b/fs/partitions/check.c
> > > 
> > > 
> > > You seriously want to add code to the core partition handling logic
> > > moments before release when we know we have all sorts of devices with
> > > weird behaviours ?
> > > 
> > > This should be .31 stuff where we can take the time to see how it works
> > > on all sorts of weird real world devices (eg those with 2K sector size)
> > > and the like.
> > 
> > Absolutely seconded.
> > 
> > Plus this is only one of the proposals for dealing with IDE native sizes
> > moving through the process.  The other one is in libata with the gendisk
> > proposal for alt size instead of your set_capacity callback.   The last
> 
> ->set_capacity callback is needed for drivers/ide regardless of alt_size
> sysfs interface and it don't conflict with it in any way.

It's used as a heuristic for selecting native vs protected disk size
depending on what the partition table says ... I grant that's one way to
handle the problem.

> Those patches are a complimentary work to Tejun's alt_size patches. 
> 
> They don't export anything to user-space.

So you're trying to solve the problem heuristically, and Tejun is trying
to provide the user with full information.   At the end of the day it
would be nice to get agreement on how we do this *before* exposing it to
users.  It's certainly possible we could do both, but for that to happen
libata would have to implement .get_capacity() is that going to be the
case?

> > thing we want is two separate mechanisms for this, so trying to push
> > anything upstream before we have agreement on direction is premature ...
> > trying to send a feature as a bug fix is doubly so.
> 
> James, please (re-)read commits, then bug #13365 at kernel.org and if you
> still find some code parts controversial I'll be happy to discuss them.

Um, that's a red herring, isn't it?  That bug complains that a migration
from IDE to libata failed because IDE was ignoring HPA and libata was
respecting it resulting in a disk under libata whose partition table was
too big for its HPA reduced capacity; the fix was to turn off libata HPA
in that configuration.  As far as I can tell nothing in the code you've
added actually fixes that bug.  To fix it, we'd have to add a
get_capacity() method to libata as well so that it could use your
partition heuristics to turn off the HPA.

What your code does instead is to add HPA handling to IDE so that you no
longer always ignore it ... that's fine, but it's still a feature
enhancement not a bug fix.

James


