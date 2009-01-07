Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZAGO3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZAGO3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZAGO3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:29:00 -0500
Received: from THUNK.ORG ([69.25.196.29]:40796 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZAGO27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:28:59 -0500
Date: Wed, 7 Jan 2009 09:28:55 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, ccache@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090107142854.GB17110@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>,
	ccache@lists.samba.org, linux-kernel@vger.kernel.org
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <20090107131221.GA17110@mit.edu> <4964BEAA.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4964BEAA.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 01:39:38PM +0000, Jan Beulich wrote:
> >>> Theodore Tso <tytso@mit.edu> 07.01.09 14:12 >>>
> >objcopy: not stripping symbol `__ksymtab_strings' because it is named in a relocation
> 
> Another thing I've never seen in any of my builds - these strings always
> get relocations against the corresponding section symbol.

Just to be clear; it doesn't always fail; it seems to be random (or at
least, I haven't had time to try to suss out why sometimes
__ksymtab_strings is being used in a relocation):

  INSTALL fs/cifs/cifs.ko
  INSTALL fs/coda/coda.ko
  INSTALL fs/configfs/configfs.ko
objcopy: not stripping symbol `__ksymtab_strings' because it is named in a relocation
  INSTALL fs/dlm/dlm.ko
objcopy: not stripping symbol `__ksymtab_strings' because it is named in a relocation
  INSTALL fs/ecryptfs/ecryptfs.ko
  INSTALL fs/efs/efs.ko
  INSTALL fs/ext2/ext2.ko
  INSTALL fs/fat/fat.ko
objcopy: not stripping symbol `__ksymtab_strings' because it is named in a relocation
  INSTALL fs/fat/msdos.ko
  INSTALL fs/fat/vfat.ko
  INSTALL fs/freevxfs/freevxfs.ko

This is on an Ubuntu Hardy system, if this helps.  I'm using gcc
4.2.4, and binutils version 2.18.1~cvs20080103-0ubuntu1.

> ># objcopy --strip-debug --wildcard --strip-symbols /usr/projects/linux/linux-2.6/scripts/strip-symbols fs/xfs/xfs.ko /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko  || (cp fs/xfs/xfs.ko /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko ; strip --strip-debug /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko)
> 
> I'd rather insert a second objcopy attempt here with just --strip-debug.

Yes, that makes sense, of course.

> In a separate response I already explained what the goal here is - size
> reduction (i.e. making distro package sizes as well as foot print on disk
> smaller, thus improving the already existing stripping). And it's not only
> about __crc_*, those are just the ones that when removed have the
> biggest overall effect. And, as pointed out above, the vmlinux stripping
> patch, which has an even more significant effect as it reduces the in-
> memory kernel size when using KALLSYMS_ALL, depends on this one.

I'm all for size reduction; the problem is that I don't have one of
Linus's fancy machines that can do 10 second full kernel compiles.  So
I'm very much reliant on ccache, and a 70% increase in kernel
compilation time, when a full compile already takes order of magnitude
5-10 minutes (this is for my personal no-modules, stripped-down
development build), is very painful and easily noticed.

Maybe we need to modify ccache, or pull ccache into the kernel sources
and then hack it for our unique, and apparently , constantly
growing-in-complexity build complexity.  One thing that would really
help is some documentation and some way of seeing *all* of the steps
that are getting executed when we compile a .c to .o file.  One of the
things I noticed is that make V=1 only showed the cc -S step, but it
seemd to mask out the other steps of what was going on, which forced
me to go diving into the kbuild scripts --- and for someone who isn't
daily hacking the kbuild scripts, and who needed to trace all of the
macros, and who might not know at their fingertips what $(filter-out
...), $(wildcard ...), and $(notdir ...) do --- it's highly painful.

I'm sure this is just my own ignorance, but a tutorial in how the
kbuild system works, which files are involved, where to look for
various things, and a short summary to all of the gmake magic which
gets used would be very helpful.

> I have to admit that I generally dislike the tendency for everything to
> always only grow, and hence I'm trying to find opportunities to shrink
> stuff where possible. I've got a couple of other patches in my local
> queue that also aim in that direction, plus there are a few thoughts on
> improvements beyond that.

I'm certainly sympathetic to this.  I just also have this desire to
make sure that it is possible to do kernel hacking on a X61-class
laptop, and that mongo-expensive 8 socket, quad-core systems with vast
amounts of memories aren't necessary in order to do compile-edit-debug
cycles in reasonable amounts of time.  :-/

(And BTW, I consider the pre-2.6.28 compile times only barely
acceptable; most of this isn't kbuild's fault, I know, it includes the
fact that link steps are still slow, and gcc is constantly getting
increasingly slower over time.  Sigh...  I will just note wryly that
it used to be that I could compile 0.9x kernels on a 40 MHz 386
machine in 10 minutes.  Some 15 years later, it still takes roughly
the same amount of time to compile a kernel, even though computers
have gotten vastly faster since then.  Something seems wrong with
that....  :-)

						- Ted
