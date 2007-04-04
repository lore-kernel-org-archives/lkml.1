Return-Path: <linux-kernel-owner+w=401wt.eu-S2992883AbXDDMW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992883AbXDDMW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 08:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992890AbXDDMW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 08:22:26 -0400
Received: from thunk.org ([69.25.196.29]:55977 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992883AbXDDMWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 08:22:25 -0400
Date: Wed, 4 Apr 2007 08:21:54 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Miller <davem@davemloft.net>, dwmw2@infradead.org, paulus@samba.org,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404122154.GF31973@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>, dwmw2@infradead.org,
	paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <1175663999.2932.8.camel@shinybook.infradead.org> <17939.15726.114059.679277@cargo.ozlabs.ibm.com> <1175666635.2932.17.camel@shinybook.infradead.org> <20070404.011208.120446173.davem@davemloft.net> <20070404083803.GA13134@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404083803.GA13134@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 09:38:03AM +0100, Russell King wrote:
> I think your perception is more wrong than you could ever think.
> Montavista would absolutely love all serial ports to be under the
> ttyS* naming, especially on ARM where there is a wide variety of
> different possibilities - ttyAM, ttySA, ttyPXA, ttyAMA, and so
> the list goes on.  It apparantly gives their support department
> real headaches.
> 
> There are similar feelings from the handhelds.org community.
> 
> However, despite people pressing for it, there's yet to be a *sane*
> *technical* *solution* to the problem.  All I've seen so far is one
> bad hack.

It is certainly technically doable.  The problem is that there's a lot
of hard work between where we are and there, and serial ports have
never been important enough so that somoene has been able to justify
the intensive amounts of work to get there.

What I've always wanted to do if I could clone myself and/or had
unlimited amounts of time/funding to work on the problem, is that a
huge amount of what is in the "serial layer" needs to be pushed into
the tty layer (and things like the hangup code needs to be pushed into
VFS as revoke(2), for which thankfully we're starting to see patches
that do this).  Essentially, there is a huge amount of *hair* in the
8250 driver which really should have gone into tty layer, and some of
the hair (like locked termios, the last remants of callout device
support, etc.) should just be removed.

The other thing I would probably do if I were to do it all over again
is allow serial devices to be named independent of /dev/ttySx
interface, these days probably using /sysfs, so that you could easily
query to figure out what serial controllers/cards were on the system,
and assign specific controllers/ports to specific /dev/ttySx devices.
We could also provide a registration system to allow on-line
configuration of non-probeable serial cards attached to primitive
buses that don't alllow probing, such as the ISA bus, although perhaps
that's much less important in this day and age.

The bottom line is thre's a huge amount of history and legacy in the
serial driver, but it hasn't been as _important_ for it to get the
kind of modern rewrite that we've had in our other device subsystems.
And such a rewrite is something that really evolve, but needs to be a
big-bang reorganization, and that's something rather painful that we
don't do as well as the gradual evolution approach.  But it works well
enough, and hey, my laptop doesn't even have any serial ports (unless
I plug in a USB serial card or I dock it in my docking station), and
after all, all right-thinking serial ports are implemented using
8250-derived UART's, so the current system has been Good Enough for
the vast majority of Linux users.  (And as Linus will tell you, he's a
big fan of the Good Enough/"Worse is Better"/New Jersey approach as
opposed to the equisitely overdesigned MIT/Stanford approach.)

So if we're going to do the "Worse is Better" thing, what I'd suggest
doing is that someone simply submit a hack so that pmac_zilog can
steal minor numbers and use /dev/ttyS0.  I accepted the patch way back
when I was serial maintainer; Russell ripped it out when he became the
serial maintainer; but now that he's no longer the serial maintainer,
he doesn't get to complain about that any more :-)

So my suggestion would be to simply submit patch to share minor
numbers directly to Linus/Andrew (since there is no current serial
maintainer) and see if they accept it.

Regards,

					- Ted
