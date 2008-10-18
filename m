Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbYJRLJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbYJRLJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 07:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYJRLJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 07:09:12 -0400
Received: from 1wt.eu ([62.212.114.60]:4823 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYJRLJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 07:09:11 -0400
Date: Sat, 18 Oct 2008 13:08:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081018110826.GA25503@1wt.eu>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <20081017085604.GA20986@cs181140183.pp.htv.fi> <20081018090117.GR24654@1wt.eu> <20081018100401.GA6535@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018100401.GA6535@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

this is becoming off-topic, but there are some points which need to be
addressed. Please if you want to reply afterwards, be kind to strip the
CC list.

On Sat, Oct 18, 2008 at 01:04:01PM +0300, Adrian Bunk wrote:
> On Sat, Oct 18, 2008 at 11:01:18AM +0200, Willy Tarreau wrote:
> > On Fri, Oct 17, 2008 at 11:56:04AM +0300, Adrian Bunk wrote:
> >...
> > > Building software in a chroot is a common thing if you don't want to 
> > > setup a dedicated machine for a build environment (and all these hyped 
> > > virtualization solutions tend to not support architectures like alpha
> > > or parisc).
> > 
> > The chroot is OK when you want to maintain a few packages once in
> > a while (eg: have it on your notebook to build packages for your
> > customers' various distros). But it's not suited to maintain full
> > distros,
> 
> You claim Debian was not a full distro?

I'm not judging that, they build like they want. If they want to build
on the final target and have as many build machines as they support,
it's their problem. It's just very amateurish. I wouldn't like to be
the guy building the full distro in a chroot on an embedded ARM or MIPS
just because it's the target.

> > nor to cross-compile.
> 
> Scratchbox [1], e.g. used for building the software in Nokias Internet 
> Tablets [2] or the ARM Linux Internet Platform [3], is a chrooted 
> cross-compilation environment.
> 
> Yes, it works.

I'm not saying it does not work, I'm saying it's far from being practical
when you want to support multiple architectures or targets, and that it
will do nasty things under you without letting you know.

> And since a few years everyone can buy devices running software built 
> inside Scratchbox chroots.
> 
> > > The OpenSSL 0.9.8 config script is existing userspace, and it will 
> > > break.
> > 
> > And ? All distros shipping version 0.9.8 with a current kernel will
> > have no problem because they backport fixes only. Once the new kernel
> > is out, openssl will release a minor update with a few fixes and features,
> > one of them being tagged as "support for Linux 2.8 and above". New distros
> > will then have no trouble shipping a standard openssl with a standard
> > kernel. All software have always worked like this, I really don't see
> > the problem Adrian.
> 
> Since Debian has a "support a release until one year after the next 
> release" policy, Debian will at some point in the future build security 
> fixes for OpenSSL 0.9.8g (shipped with Debian 5.0) in chroots on 
> autobuilders running Debian 6.0 (runing kernel 2010.2.6).

The process you're describing is frighteningly broken. You're basically
telling me that the day openssl automatically detects and enables a
feature in the debian build environment, it will automatically enable
it for the target environment ? This is pure non-sense. If they build
like that, they'd better keep old boxes running the same distro as the
target to maintain stable releases, or it's urgent to stay away from
their stable versions as soon as you're aware they switched the build
machine ! I hope they don't build 32-bit x86 from 64-bit systems if
they proceed like this...

A build environment is what it is, a build environment. It contains
compilers, shells to run scripts, various interpreters and build tools,
possibily debuggers and editors, versionning systems, etc...

The target environment has nothing to do with the build environment.
It's the environment the binary will run on. If some project does
auto-detection of the build environment assuming it's the same as
the target, you have to force it to the target environment, and not
to dress up the build environment to look like it is the target one.

For instance, I would be very angry if I built a project which
automatically selected the use of epoll() for 2.4 target just
because I'm building on 2.6. And in fact, this seldom happens,
and setting a few variables or even patching configure or makefile
is enough to fix the issue (and it is the right thing to do).

> > > That is one example that "Will" definitely break (no matter how broken 
> > > or how easy to fix it is).
> > 
> > What makes you think that current 0.9.8g will work on 2.6.521 ?
> >...
> 
> Userspace ABIs of the kernel are usually stable.

Yes but they are not necessarily forward-compatible. If openssl believes
some feature is present in 2.6.521 because 521 is bigger than 233, you
will build a broken package which will not work with any distro running
your long-term 2.6.27 which does not have the feature introduced in .233.

Again, chroot builds are cool for *some* things. I too do use them a lot.
But they're very dangerous and must not be used for everything. And when
you know how to fix packages so that chroot is not a problem, then you
know how to fix the package not to require a chroot.

Willy

