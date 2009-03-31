Return-Path: <linux-kernel-owner+w=401wt.eu-S1762343AbZCaXz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762343AbZCaXz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbZCaXzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:55:47 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:32160 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbZCaXzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:55:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEALtJ0kl5LJex/2dsb2JhbADOR4N6Bg
X-IronPort-AV: E=Sophos;i="4.39,304,1235914200"; 
   d="scan'208";a="322664603"
Date: Wed, 1 Apr 2009 10:55:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090331235509.GU26138@disturbed>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <1238417751.30488.12.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238417751.30488.12.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 08:55:51AM -0400, Chris Mason wrote:
> On Mon, 2009-03-30 at 10:14 +1100, Dave Chinner wrote:
> > On Sat, Mar 28, 2009 at 11:17:08AM -0400, Mark Lord wrote:
> > > The better solution seems to be the rather obvious one:
> > >
> > >   the filesystem should commit data to disk before altering metadata.
> > 
> > Generalities are bad. For example:
> > 
> > write();
> > unlink();
> > <do more stuff>
> > close();
> > 
> > This is a clear case where you want metadata changed before data is
> > committed to disk. In many cases, you don't even want the data to
> > hit the disk here.
> > 
> > Similarly, rsync does the magic open,write,close,rename sequence
> > without an fsync before the rename. And it doesn't need the fsync,
> > either. The proposed implicit fsync on rename will kill rsync
> > performance, and I think that may make many people unhappy....
> > 
> 
> Sorry, I'm afraid that rsync falls into the same category as the
> kde/gnome apps here.

I disagree.

> There are a lot of backup programs built around rsync, and every one of
> them risks losing the old copy of the file by renaming an unflushed new
> copy over it.

If you crash while rsync is running, then the state of the copy
is garbage anyway. You have to restart from scratch and rsync will
detect such failures and resync the file. gnome/kde have no
mechanism for such recovery.

> rsync needs the flushing about a million times more than gnome and kde,
> and it doesn't have any option to do it automatically.

And therein lies the problem with a "flush-before-rename"
semantic....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
