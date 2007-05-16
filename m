Return-Path: <linux-kernel-owner+w=401wt.eu-S1761052AbXEPQJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761052AbXEPQJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbXEPQJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:09:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:23493 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524AbXEPQJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:09:47 -0400
Message-ID: <a781481a0705160720p58f0730ehcb491bb6e111f924@mail.gmail.com>
Date: Wed, 16 May 2007 19:50:05 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC] select and dependencies in Kconfig
Cc: "Al Viro" <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, kbuild-devel@lists.sourceforge.net
In-Reply-To: <alpine.LFD.0.98.0705152046070.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1Ho2om-0003TN-Ah@ZenIV.linux.org.uk>
	 <20070516033335.GH4095@ftp.linux.org.uk>
	 <alpine.LFD.0.98.0705152046070.3890@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Tue, May 15, 2007 at 08:36:20PM +0100, Al Viro wrote:
> >
> > stuff that does select USB should depend on USB_ARCH_HAS_HCD, or we'll
> > end up with unbuildable configs.
>
> BTW, this kind of situation happens often enough, so how about doing
> the following: teach kconfig that if FOO selects BAR and BAR depends
> on <expr>, we should act as if FOO had explicit depends on <expr>.
>
> Rationale: if FOO selects BAR, BAR depends on <expr> and <expr> is false,
> turning FOO on will land us into unbuildable configuration (BAR turned on,
> dependencies of BAR are not satisfied).  It really happens often enough to
> be very annoying.  And we have fsckloads of dependencies that are there
> only because of such scenarios.  Gets especially nasty when BAR is selected
> by several dozens of options and dependencies of BAR change...

[ First off, "select"ing BAR that itself "depends on" BAZ is evil and
should be avoided, except where BAR is strictly library-like and thus
has simple or few basic dependencies. Still, like you say, dependencies
of BAR can change over time, or one could want to be lazy and wish to
avoid burdening users with having to pick dependencies _before_ the
option they're interested in -- especially with menuconfig not even
showing options whose dependencies are not satisfied already. ]

Anyway, I'd gotten into a couple of threads discussing precisely this over
the last couple of weeks, and thought of more-or-less a similar solution:
http://lkml.org/lkml/2007/5/7/332

When user picks FOO, we select BAR and note its dependencies (i.e. BAZ).
Build a complete dependency tree (FOO upwards), and show to the user all
the other config options (such as BAZ) that will now have to be picked
to satisfy user's selection of FOO without causing build breakages. If
user says yes, we *select* BAZ too (so now it can't be un-selected). If
user says no, FOO is not picked at all.

On 5/16/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> Implementing that is pretty simply; the only thing I'm not sure how to deal
> with is how to show such inherited dependencies in menuconfig et.al.

On 5/16/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Sounds sane. I wonder if there are any non-obvious gotchas, and I worry
> that the indirect dependency ends up getting really confusing at times,
> but I don't think the notion is broken - just worrying about how to *show*
> this to explain what is going on when people say "why can't I select X".

For menuconfig / xconfig it _could_ simply be another dialog box that
pops up the moment user picks FOO.

For config/oldconfig/etc non-curses/graphics-based ones, we could do
something like what "yum" does for package dependencies on Red Hat
and Fedora. Once the entire thing is done, just run through the entire
.config just generated, and build these complete dependency trees for
all picked options, and thus compiling a list of all the BAZ'es that also
need to be picked now to satisfy user's demand for the FOO's.
Simple Y/n then follows.

Satyam
