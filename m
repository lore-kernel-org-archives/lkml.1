Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYGAGjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYGAGjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYGAGjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:39:02 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:63654 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbYGAGjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:39:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEGAPRsaUh5LFnmWmdsb2JhbACSeQEdnjA
X-IronPort-AV: E=Sophos;i="4.27,730,1204464600"; 
   d="scan'208";a="139351596"
Date: Tue, 1 Jul 2008 16:38:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: xfs-masters@oss.sgi.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Elias Oltmanns <eo@nebensachen.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
Message-ID: <20080701063835.GQ29319@disturbed>
Mail-Followup-To: xfs-masters@oss.sgi.com,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Elias Oltmanns <eo@nebensachen.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Kyle Moffett <mrmacman_g4@mac.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
References: <4744FD87.7010301@goop.org> <200806302300.45018.rjw@sisk.pl> <20080630222128.GP29319@disturbed> <200807010038.43362.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807010038.43362.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 12:38:41AM +0200, Rafael J. Wysocki wrote:
> On Tuesday, 1 of July 2008, Dave Chinner wrote:
> > On Mon, Jun 30, 2008 at 11:00:43PM +0200, Rafael J. Wysocki wrote:
> > > On Monday, 30 of June 2008, Dave Chinner wrote:
> > > > On Sun, Jun 29, 2008 at 11:37:31PM -0700, Jeremy Fitzhardinge wrote:
> > > > > Dave Chinner wrote:
> > > > >> On Mon, Jun 30, 2008 at 01:22:47AM +0200, Rafael J. Wysocki wrote:
> > > > >>> Well, it seems we can handle this on the block layer level, by temporarily
> > > > >>> replacing the elevator with something that will selectively prevent fs I/O
> > > > >>> from reaching the layers below it.
> > > > >>
> > > > >> Why? What part of freeze_bdev() doesn't work for you?
> > > > >
> > > > > Well, my original problem - which is still an issue - is that a process  
> > > > > writing to a frozen XFS filesystem is stuck in D state, and therefore  
> > > > > cannot be frozen as part of suspend.
> > > 
> > > I thought we were talking about the post-freezer situation.
> > > 
> > > > Silly me - how could I forget the three headed monkey getting in
> > > > the way of our happy trip to beer island?
> > > > 
> > > > Seriously, though, how is stopping I/O in the elevator is going to
> > > > change that?
> > > 
> > > We can do that after creating the image and before we let devices run again.
> > > This way we won't need to worry about the freezer.
> > 
> > You're suggesting that you let processes trying to do I/O continue
> > until *after* the memory image is taken?
> 
> I'm not going to let the data get to the disk.

Yes, but you still haven't answered the original question - What are
you going to do with sync I/O that leaves a process in D state
because you've prevented the I/O from being completed?

> > > > What do you do with a sync I/O (read or write)? The 
> > > > process is going to have to go to sleep somewhere in D state waiting
> > > > for that I/O to complete.  If you're going to intercept such
> > > > processes somewhere else to do something magic, then why not put
> > > > that magic in vfs_check_frozen()?
> > > 
> > > This might work too, but it would be nice to do something independent of the
> > > freezer, so that we can drop the freezer when we want and not when we are
> > > forced to.
> > 
> > vfs_check_frozen() is completely independent of the process freezer.
> 
> Well, can you please tell me how exactly that works, then?

Try looking at the code. When we freeze a filesystem sb->s_frozen
changes state depending on the level of freeze currently obtained
by the filesystem. And:

#define vfs_check_frozen(sb, level) \
        wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))

Pretty bloody simple, really.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
