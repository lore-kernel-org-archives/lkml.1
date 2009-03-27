Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbZC0TEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbZC0TEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZC0TD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:03:56 -0400
Received: from THUNK.ORG ([69.25.196.29]:45558 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbZC0TDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:03:55 -0400
Date: Fri, 27 Mar 2009 15:03:39 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327190339.GW6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <20090327171955.78662c1e@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903271058060.3994@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903271058060.3994@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 11:05:58AM -0700, Linus Torvalds wrote:
> 
> Alan. Repeat after me: "fsync()+close() is basically useless for any app 
> that expects user interaction under load".
> 
> That's a FACT, not an opinion.

This is a fact for ext3 with data=ordered mode.  Which is the default
and dominant filesystem today, yes.  But it's not true for most other
filesystems.  Hopefully at some point we will migrate people off of
ext3 to something better.  Ext4 is available today, and is much better
at this than ext4.  In the long run, btrfs will be better yet.  The
issue then is how do we transition people away from making assumptions
that were essentially only true for ext3's data=ordered mode.  Ext4,
btrfs, XFS, all will have the property that if you fsync() a small
file, it will be fast, and it won't inflict major delays for other
programs running on the same system.

You've said for a long that that ext3 is really bad in that it
inflicts this --- I agree with you.  People should use other
filesystems which are better.  This includes ext4, which is completely
format compatible with ext3.  They don't even have to switch on
extents support to get better behaviour.  Just mounting an ext3
filesystem with ext4 will result in better behaviour.

So maybe we can't tell application writers, *today*, that they should
use fsync().  But in the future, we should be able to tell them that.
Or maybe we can tell them that if they want, they can use some new
interface, such as a proposed fbarrier() that will do the right thing
(including perhaps being a no-op on ext3) no matter what the
filesystem might be.

I do believe that the last thing we should do is tell people that
because of the characteristics of ext3s, which you yourself have said
sucks, and which we've largely fixed for ext4, and which isn't a
problem with other filesystems, including some that may likely replace
ext3 *and* ext4, that we should give people advice that will lock
applications into doing some very bad things for the indefinite
future.

And I'm not blaming userspace; this is at least as much, if not
entirely, ext3's fault.  What that means is we need to work on a way
of providing a transition path back to a better place for the overall
system, which includes both the kernel and userspace application
libraries, such as those found in GNOME, KDE, et. al.

> So look for a middle ground. Not this crazy militant "user apps must do 
> fsync()" crap. Because that is simply not a realistic scenario.

Agreed, we need a middle ground.  We need a transition path that
recognizes that ext3 won't be the dominant filesystem for Linux in
perpetuity, and that ext3's data=ordered semantics will someday no
longer be a major factor in application design.  fbarrier() semantics
might be one approach; there may be others.  It's something we need to
figure out.

						- Ted
