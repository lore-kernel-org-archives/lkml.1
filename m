Return-Path: <linux-kernel-owner+w=401wt.eu-S934055AbYF3Who@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055AbYF3Who (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933371AbYF3Wha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:37:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933737AbYF3Wh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:37:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
Date: Tue, 1 Jul 2008 00:38:41 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Elias Oltmanns <eo@nebensachen.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <4744FD87.7010301@goop.org> <200806302300.45018.rjw@sisk.pl> <20080630222128.GP29319@disturbed>
In-Reply-To: <20080630222128.GP29319@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807010038.43362.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, Dave Chinner wrote:
> On Mon, Jun 30, 2008 at 11:00:43PM +0200, Rafael J. Wysocki wrote:
> > On Monday, 30 of June 2008, Dave Chinner wrote:
> > > On Sun, Jun 29, 2008 at 11:37:31PM -0700, Jeremy Fitzhardinge wrote:
> > > > Dave Chinner wrote:
> > > >> On Mon, Jun 30, 2008 at 01:22:47AM +0200, Rafael J. Wysocki wrote:
> > > >>> Well, it seems we can handle this on the block layer level, by temporarily
> > > >>> replacing the elevator with something that will selectively prevent fs I/O
> > > >>> from reaching the layers below it.
> > > >>
> > > >> Why? What part of freeze_bdev() doesn't work for you?
> > > >
> > > > Well, my original problem - which is still an issue - is that a process  
> > > > writing to a frozen XFS filesystem is stuck in D state, and therefore  
> > > > cannot be frozen as part of suspend.
> > 
> > I thought we were talking about the post-freezer situation.
> > 
> > > Silly me - how could I forget the three headed monkey getting in
> > > the way of our happy trip to beer island?
> > > 
> > > Seriously, though, how is stopping I/O in the elevator is going to
> > > change that?
> > 
> > We can do that after creating the image and before we let devices run again.
> > This way we won't need to worry about the freezer.
> 
> You're suggesting that you let processes trying to do I/O continue
> until *after* the memory image is taken?

I'm not going to let the data get to the disk.

> How is that going to work? 
> You've got to quiesce the filesystems totally *before* taking an image
> of memory - it's the only way to guarantee that they are the
> in-memory state and on disk state are consistent state on resume.

No, it's not the only way.

We have to ensure that the fs data that did't make it to the disk(s)
before creating the snapshot image will not be written to the disk(s) after
the image has been created.  In theory one can think of many ways to achieve
that and the freezing of filesystems is certainly one of those.

> Don't re-invent the wheel - use the API we already have that does
> exactly what needs to be done.
> 
> > > What do you do with a sync I/O (read or write)? The 
> > > process is going to have to go to sleep somewhere in D state waiting
> > > for that I/O to complete.  If you're going to intercept such
> > > processes somewhere else to do something magic, then why not put
> > > that magic in vfs_check_frozen()?
> > 
> > This might work too, but it would be nice to do something independent of the
> > freezer, so that we can drop the freezer when we want and not when we are
> > forced to.
> 
> vfs_check_frozen() is completely independent of the process freezer.

Well, can you please tell me how exactly that works, then?

Thanks,
Rafael
