Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZFGPjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZFGPjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZFGPjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:39:37 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:33704 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZFGPjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YjxTZ4QNliNpE800dLbiZX9CtwLO5JAOhjmdWVXgshlgeDkOcYeGTPDHyULXB6syBk
         EZnIeLCi9g3lKyhH0EftGVZ28Yhv+i8vZURkrF40aGbauv6DTp5+n2tLrd3oulfNve+c
         NSGr5VYD4bVlnsOl1C3joQD98Ltkr0Jug3koI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [git pull] IDE fixes
Date: Sun, 7 Jun 2009 17:44:23 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <200906071657.49513.bzolnier@gmail.com> <1244387931.8262.24.camel@mulgrave.site>
In-Reply-To: <1244387931.8262.24.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906071744.23629.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 17:18:51 you wrote:
> On Sun, 2009-06-07 at 16:57 +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 07 June 2009 16:38:56 James Bottomley wrote:
> > > On Sun, 2009-06-07 at 15:21 +0100, Alan Cox wrote:
> > > > > diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> > > > > index 99e33ef..4bc2c43 100644
> > > > > --- a/fs/partitions/check.c
> > > > > +++ b/fs/partitions/check.c
> > > > 
> > > > 
> > > > You seriously want to add code to the core partition handling logic
> > > > moments before release when we know we have all sorts of devices with
> > > > weird behaviours ?
> > > > 
> > > > This should be .31 stuff where we can take the time to see how it works
> > > > on all sorts of weird real world devices (eg those with 2K sector size)
> > > > and the like.
> > > 
> > > Absolutely seconded.
> > > 
> > > Plus this is only one of the proposals for dealing with IDE native sizes
> > > moving through the process.  The other one is in libata with the gendisk
> > > proposal for alt size instead of your set_capacity callback.   The last
> > 
> > ->set_capacity callback is needed for drivers/ide regardless of alt_size
> > sysfs interface and it don't conflict with it in any way.
> 
> It's used as a heuristic for selecting native vs protected disk size
> depending on what the partition table says ... I grant that's one way to
> handle the problem.
> 
> > Those patches are a complimentary work to Tejun's alt_size patches. 
> > 
> > They don't export anything to user-space.
> 
> So you're trying to solve the problem heuristically, and Tejun is trying
> to provide the user with full information.   At the end of the day it
> would be nice to get agreement on how we do this *before* exposing it to
> users.  It's certainly possible we could do both, but for that to happen

Sure.  My patches don't export anything to user-space.

If you find any code parts controversial please post them and I'll be
more than happy to discuss them in details.

> libata would have to implement .get_capacity() is that going to be the
> case?

Now we get the real source of Alan's and your complains...

Those patches (among other things) make IDE superior overt libata w.r.t.
HPA handling so libata now has to catch up.

Honestly, this should be solved on technical basis by somebody posting
needed libata patches instead of attempts to slow down IDE fixes.

> > > thing we want is two separate mechanisms for this, so trying to push
> > > anything upstream before we have agreement on direction is premature ...
> > > trying to send a feature as a bug fix is doubly so.
> > 
> > James, please (re-)read commits, then bug #13365 at kernel.org and if you
> > still find some code parts controversial I'll be happy to discuss them.
> 
> Um, that's a red herring, isn't it?  That bug complains that a migration
> from IDE to libata failed because IDE was ignoring HPA and libata was
> respecting it resulting in a disk under libata whose partition table was
> too big for its HPA reduced capacity; the fix was to turn off libata HPA
> in that configuration.  As far as I can tell nothing in the code you've
> added actually fixes that bug.  To fix it, we'd have to add a
> get_capacity() method to libata as well so that it could use your
> partition heuristics to turn off the HPA.

Indeed.

Though first you have to get somebody from libata agree that this is a bug
and that it should get fixed.  Then somebody would need to do the work.

However my patches make it *easier* for libata developers to fix the
aforementioned compatibility issue.

> What your code does instead is to add HPA handling to IDE so that you no
> longer always ignore it ... that's fine, but it's still a feature
> enhancement not a bug fix.

If you look at the whole HPA handling from the Big Picture perspective
(taking new system installs into account when the old behavior could
result in all sorts of problems including firmware corruption) than it
*really* is a bug fix.
