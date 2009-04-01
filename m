Return-Path: <linux-kernel-owner+w=401wt.eu-S1764914AbZDAM6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764914AbZDAM6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764892AbZDAM5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:57:35 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:17176 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbZDAM5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:57:34 -0400
Subject: Re: Linux 2.6.29
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090331235509.GU26138@disturbed>
References: <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>
	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>
	 <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed>
	 <1238417751.30488.12.camel@think.oraclecorp.com>
	 <20090331235509.GU26138@disturbed>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 08:53:33 -0400
Message-Id: <1238590413.18549.7.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49D363D6.0145:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 10:55 +1100, Dave Chinner wrote:
> On Mon, Mar 30, 2009 at 08:55:51AM -0400, Chris Mason wrote:
> > On Mon, 2009-03-30 at 10:14 +1100, Dave Chinner wrote:
> > > On Sat, Mar 28, 2009 at 11:17:08AM -0400, Mark Lord wrote:
> > > > The better solution seems to be the rather obvious one:
> > > >
> > > >   the filesystem should commit data to disk before altering metadata.
> > > 
> > > Generalities are bad. For example:
> > > 
> > > write();
> > > unlink();
> > > <do more stuff>
> > > close();
> > > 
> > > This is a clear case where you want metadata changed before data is
> > > committed to disk. In many cases, you don't even want the data to
> > > hit the disk here.
> > > 
> > > Similarly, rsync does the magic open,write,close,rename sequence
> > > without an fsync before the rename. And it doesn't need the fsync,
> > > either. The proposed implicit fsync on rename will kill rsync
> > > performance, and I think that may make many people unhappy....
> > > 
> > 
> > Sorry, I'm afraid that rsync falls into the same category as the
> > kde/gnome apps here.
> 
> I disagree.
>
> > There are a lot of backup programs built around rsync, and every one of
> > them risks losing the old copy of the file by renaming an unflushed new
> > copy over it.
> 
> If you crash while rsync is running, then the state of the copy
> is garbage anyway. You have to restart from scratch and rsync will
> detect such failures and resync the file. gnome/kde have no
> mechanism for such recovery.
> 

If this were the recovery system they had in mind, then why use rename
at all?  They could just as easily overwrite the original in place.
Using rename implies they want to replace the old with a complete new
version.

There's also the window where you crash after the rsync is done but
before all the new data safely makes it into the replacement files.

> > rsync needs the flushing about a million times more than gnome and kde,
> > and it doesn't have any option to do it automatically.
> 
> And therein lies the problem with a "flush-before-rename"
> semantic....

Here I was just talking about a rsync --flush-after-rename or something,
not an option from the kernel.

-chris


