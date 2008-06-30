Return-Path: <linux-kernel-owner+w=401wt.eu-S1764166AbYF3U7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764166AbYF3U7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYF3U66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:58:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52248 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYF3U65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:58:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
Date: Mon, 30 Jun 2008 23:00:43 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Elias Oltmanns <eo@nebensachen.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <4744FD87.7010301@goop.org> <48687F2B.2000402@goop.org> <20080630123356.GO29319@disturbed>
In-Reply-To: <20080630123356.GO29319@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806302300.45018.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 30 of June 2008, Dave Chinner wrote:
> On Sun, Jun 29, 2008 at 11:37:31PM -0700, Jeremy Fitzhardinge wrote:
> > Dave Chinner wrote:
> >> On Mon, Jun 30, 2008 at 01:22:47AM +0200, Rafael J. Wysocki wrote:
> >>> On Monday, 30 of June 2008, Dave Chinner wrote:
> >>>> On Thu, Jun 26, 2008 at 05:09:10PM +0200, Pavel Machek wrote:
> >>>>>>> Is this the same thing the per-device IO-queue-freeze patches for
> >>>>>>> HDAPS also
> >>>>>>> need to do?  If so, you may want to talk to Elias Oltmanns
> >>>>>>> <eo@nebensachen.de> about it.  Added to CC.
> >>>>>>>             
> >>>>>> Thanks for the heads up Henrique. Even though these issues seem to be
> >>>>>> related up to a certain degree, there probably are some important
> >>>>>> differences. When suspending a system, the emphasis is on leaving the
> >>>>>> system in a consistent state (think of journalled file systems), whereas
> >>>>>> disk shock protection is mainly concerned with stopping I/O as soon as
> >>>>>> possible. As yet, I cannot possibly say to what extend these two
> >>>>>> concepts can be reconciled in the sense of sharing some common code.
> >>>>>>           
> >>>>> Actually, I believe requirements are same.
> >>>>>
> >>>>> 'don't do i/o in dangerous period'.
> >>>>>
> >>>>> swsusp will just do sync() before entering dangerous period. That
> >>>>> provides consistent-enough state...
> >>>>>         
> >>>> As I've said many times before - if the requirement is "don't do
> >>>> I/O" then you have to freeze the filesystem. In no way does 'sync'
> >>>> prevent filesystems from doing I/O.....
> >>>>       
> >>> Well, it seems we can handle this on the block layer level, by temporarily
> >>> replacing the elevator with something that will selectively prevent fs I/O
> >>> from reaching the layers below it.
> >>
> >> Why? What part of freeze_bdev() doesn't work for you?
> >
> > Well, my original problem - which is still an issue - is that a process  
> > writing to a frozen XFS filesystem is stuck in D state, and therefore  
> > cannot be frozen as part of suspend.

I thought we were talking about the post-freezer situation.

> Silly me - how could I forget the three headed monkey getting in
> the way of our happy trip to beer island?
> 
> Seriously, though, how is stopping I/O in the elevator is going to
> change that?

We can do that after creating the image and before we let devices run again.
This way we won't need to worry about the freezer.

> What do you do with a sync I/O (read or write)? The 
> process is going to have to go to sleep somewhere in D state waiting
> for that I/O to complete.  If you're going to intercept such
> processes somewhere else to do something magic, then why not put
> that magic in vfs_check_frozen()?

This might work too, but it would be nice to do something independent of the
freezer, so that we can drop the freezer when we want and not when we are
forced to.

Thanks,
Rafael
