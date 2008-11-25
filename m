Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYKYTKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYKYTKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 14:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYKYTKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 14:10:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168AbYKYTK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 14:10:29 -0500
Date: Tue, 25 Nov 2008 11:09:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@lists.casi.polymtl.ca,
       Zhaolei <zhaolei@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LTTng kernel integration roadmap, update
Message-Id: <20081125110918.6cec3473.akpm@linux-foundation.org>
In-Reply-To: <20081125175937.GA525@mit.edu>
References: <20081124112842.GA15615@Krystal>
	<20081124114124.GA32459@infradead.org>
	<20081124122055.GA18626@Krystal>
	<alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com>
	<20081125055744.c3377164.akpm@linux-foundation.org>
	<20081125154011.GA4883@uranus.ravnborg.org>
	<20081125175937.GA525@mit.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 12:59:37 -0500 Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Nov 25, 2008 at 04:40:11PM +0100, Sam Ravnborg wrote:
> > > 
> > > Mathieu, if you're feeling keen I'd suggest that you just type `mkdir
> > > -p userspace/lttng' and build your userspace tools in there.
> > 
> > Maybe this can help...
> > 
> > 	Sam
> > 
> > diff --git a/usr/lttng/Makefile b/usr/lttng/Makefile
> > new file mode 100644
> > index 0000000..8667998
> > --- /dev/null
> > +++ b/usr/lttng/Makefile
> > @@ -0,0 +1,4 @@
> > +
> > +always := ltt
> > +
> > +hostprogs-y := ltt

^^ good start!

> hostprogs are intended to be run on the host during the compilation
> process, right?  What we really want is something that allows us to
> build userspace programs intended for use on the target, not the host,
> since they aren't going to be used when the system is compiled, but
> when the system is run.
> 
> This also brings up some interesting questions such as where would we
> install these userspace programs (which could be kernel version
> specific), and how they would be packaged.  In some ways, this is
> similar to a previously unsolved and unresolved problem with firmware
> which people want to move out of the kernel (but not for legal
> reasons, they swear, but because most of the time the firmware stays
> constant from version to version --- except when it doesn't).
> 
> The same arguments that are used for ejecting firmware from the kernel
> and not wanting to ship multiple versions of binaries with the kernel
> can also be used for these sorts of low-level userspace binaries which
> may be kernel version specific which are often duplicated.
> 
> I happen to disagree with those who wish to eject firmware from the
> kernel sources (because I don't believe it is for technology reasons,
> but because they want to be able to chant, "Unclean, Unclean!" as they
> type rm -rf firmware).  And I think we should need to be able to
> distribute userspace binaries in the kernel, because of the versioning
> issues and so we can guarantee that we get upgraded userspace tools
> into the hands of users when they upgrade to the latest kernel.org
> kernel and need certian updated userspace utilities where we want the
> stable kernel interface to be located at a kernel-shipped userspace
> program or library.   
> 
> However, we do need to understand that there are issues around
> building target userspace progs, where they get installed, changing
> the kernel packaging systems to include them in the kernel image
> package, creating some convention so users can set the appropriate
> search path in their shells depending on which kernel they have
> booted, etc.  These are not insurmountable problems.  But they are
> ones that we need to solve first.
> 

I think when you add in internationalisation, they _are_ insurmountable
problems.  I don't think that full-on shipping of userspace-ready
applications by the kernel team will prove practical.

But let's look at the problem which we're actually trying to solve. 
Developer A wishes to write some kernel monitoring/controlling code, so
he is forced to stick it on his website, keep reminding people to
download updates, act as an independent target of other people's
patches, etc, etc.  It's all a pain and horror, so developer A gives up
and implements his userspace code in the kernel instead.  It is, as a
result, technically inferior and English-only, but at least it got
there.

So I'd propose that userspace/foo/ be viewed as a code *development*
location, not a *delivery* location.  Once a tool has reached a
sufficient level of maturity, stability and usefulness then it's time
to ask the util-linux people "please take this", then remove it from
the kernel tree.  Or to create a separate package altogether, and to
remove the original from the kernel tree.

So userspace/foo/ doesn't have to be *fancy*.  It's a three- to twelve-
month thing where code can sit while kernel developers evolve it.  Its
main consumers at that time will be kernel developers and testers.


