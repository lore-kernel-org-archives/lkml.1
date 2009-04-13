Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZDMWE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZDMWE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZDMWEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:04:48 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56710 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZDMWEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:04:46 -0400
Date: Tue, 14 Apr 2009 06:59:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC][patch] filesystem: Vmufat filesystem, version 4
Message-ID: <20090413215949.GD14847@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>,
	Josef 'Jeff' Sipek <jeffpc@josefsipek.net>,
	Sam Ravnborg <sam@ravnborg.org>
References: <1239654768.6542.10.camel@localhost.localdomain> <20090413210030.GA14847@linux-sh.org> <1239658604.6542.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239658604.6542.28.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 10:36:44PM +0100, Adrian McMenamin wrote:
> On Tue, 2009-04-14 at 06:00 +0900, Paul Mundt wrote:
> > Reviewing code is tedious work at best, making people that have taken the
> > time to participate in review do even more work to find updated versions
> > that may or may not have addressed their issues is remarkably poor
> > etiquette at best, especially when they haven't completed their review.
> > 
> 
> As far as I can see the three issues I haven't addressed were posting a
> further patch to magic.h and a couple of *suggestions* about code style.
> I will fix these points in due course, for sure. I have taken on board,
> afaics, all the substantive points for which thanks
> 
This got cut off, but the point remains that you have provided no
incremental comments in your changelog to note what has changed across
versions, so it's not obvious at first glance what issues have been
addressed and which ones have not.

Likewise, folks that have started looking at the code have cut their
review short pending an updated version with the aforementioned issues
corrected. This is the primary reason why you want to make sure all of
those nits are addressed and the Cc list maintained, especially if you
are still in 'RFC' mode.

> > Furthermore, the fact other file systems haven't done so is not an excuse
> > for you not to, especially as their reasons for doing so might be valid
> > (you of course haven't bothered citing what other file systems you are
> > referring to, so one can only vaguely postulate, though at least the
> > arguments for things like cramfs do not apply to vmufat).
> > 
> 
> I didn't say that it was - I was offering my explanation for having
> taken the decision to make it all one file and then seeing what the
> bounce back was... there are in fact a very large number of filesystems
> like this, not least of which of course is ext2 which has longer inode.c
> and super.c files than this inode.c
> 
Lines of code is a terrible metric. There are a lot of things you can
split out here that do not apply to other generic file systems. The
inode.c/super.c is the typical split for the fs, but a lot of the code
you are carrying around is for managing the on-disk format and other
VMU-specific oddities. It is useful to split this out logically and
compartmentalize where it makes sense, especially as there are far more
people who can review the file system part than the VMU part.

> > You should also think about whether you really want to go down the road
> > of decoupling this from the VMU device dependencies. vmufat is not and
> > never will be a general purpose file system, the on-disk format,
> > limitation in block numbering, etc. are all directly tied to the VMU
> > itself. Since you cited emulators as a potential user, these should be
> > emulating the VMU itself anyways before you worry about layering vmufat
> > on top of it. Trying to position this as a general purpose file system
> > will bring you a world of pain you really don't want.
> 
> The two compromises are that on a failed read of a block it tries again
> (as experience suggest that fixes most issues with the flaky VMU
> hardware - though I doubt emulator builders will replicate that) and
> that it does not write out a new date for the "superblock" on a change
> of the filesystem - to avoid wear on the flash on the VMU, but again not
> an issue for most emulator writers - I think the Kconfig makes it pretty
> clear this isn't a general purpose filesystem.
> 
Whether these hacks belong in the fs at all or not is another issue
entirely, but none of that addresses any of the things I noted.

This file system is tied directly to the VMU. Assumptions about the
on-disk format, block numbering limitations, etc. are all VMU
constraints, and papering over that in the Kconfig text is not
sufficient. This file system is and always will be tied to the VMU, and
you really do not want to decouple the two. What you do in loopback mode
for testing is your own business, but this will not work in the way
people expect on a fixed disk. You are only making things harder on
yourself by insisting that this is somehow generic.

The file system at least wants a dependency on the VMU (and I suppose
mtdblock) itself.
