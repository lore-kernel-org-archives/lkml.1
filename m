Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbYLZFLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbYLZFLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 00:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYLZFK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 00:10:59 -0500
Received: from phunq.net ([64.81.85.152]:48429 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750747AbYLZFK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 00:10:58 -0500
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 report: Tux3 for Christmas
Date: Thu, 25 Dec 2008 21:10:55 -0800
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org, tux3@tux3.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812252110.55967.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ho Ho Ho!

Santa came and went early this morning, and it seems he left a special 
little something under the tree for filesystem hackers: a Tux3 Kernel 
Playset.  (Some assembly required.)

Tux3 is running in kernel now, a little shaky but more or less as a 
Posix filesystem.  Fsx-linux[1] runs somewhat unreliably, with 
occasional asserts because of missing SMP locking: file btrees are 
properly locked, but the inode table and allocation bitmap have no 
protection whatsover.  It is actually kind of surprising that these 
runs complete at all at this point, and it is nice to see the failures 
showing up as asserts instead of oopses and lockups.

This is not yet a request for review because there are still a few 
things we feel must be in to call it presentable.  Mainly, completing 
SMP lock coverage and atomic commit, and cleaning up some block leaks.

Heavy development continues.  Most of it continues to be done in 
userspace.  In fact, 80 percent of the Tux3 kernel code also runs in 
user space.  The remainder is VFS API glue and wrappers to abstract 
away a few differences between kernel and userspace, like the fact that 
there is only one kind of inode in userspace and many in kernel.  I 
would have to say, this is probably the most unique aspect of Tux3 
right now.  We are able to implement major changes in user space and 
expect them to work in kernel on the first try.

Here is a quick HowTo, to get your Tux3 Playset up and running:

   # Get a kernel tree:
   wget http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.5.tar.bz2
   tar -xjf linux-2.6.26.5.tar.bz2
   cd linux-2.6.26.5

   # Get the Christmas tux3 patch and patch the kernel:
   wget http://tux3.org/patches/tux3-2.6.26.5-3
   patch <tux3-2.6.26.5-3 -p1

   # Build linux with tux3:
   make defconfig
   make CONFIG_TUX3=y
   sudo make install

   # Get the Christmas tux3 userspace snapshot:
   wget http://tux3.org/downloads/snapshots/tux3-20081225.tar.gz
   tar -xzf tux3-20081225.tar.gz
   cd tux3/user
   make

   # make a tux3 filesystem
   sudo ./tux3 mkfs /dev/<testpartition>

Boot and mount!

   cat /proc/filesystems | grep tux3 && mount /dev/<testpartition> /mnt

Also see my earlier guide to developing Tux3 under user mode linux:

   http://lwn.net/Articles/308950/

Caveats: Developmental filesystem!  Use if you want to poke and play, do 
not even think about storing valuable data on it.  Tux3 obeys sync at 
this point, but not fsync.  No atomic commit means that shutting off 
the power without sync _will_ corrupt the filesystem image.

More caveats: We do not handle source dependencies awfully well in the 
userspace makefile.  You need libpopt-dev and a few other things to 
build it.  Early code adopters know the drill: you see roughly what 
development packages are missing from the build errors.  Design 
documentation is copious but distributed throughout our mailing list 
archives.  We hope to do something about that soon.  In-source 
documentation is still very sparse, although some work has started on 
that, for example, commenting fields in the main data structures.  The 
kernel code runs with _loads_ of printk tracing output, which will be 
disabled with a runtime tracing flag pretty soon, but right now is the 
primary way we figure out what is going on inside.

Yet more caveats:  Although the coding style is largely "lindent", there 
are a few departures that may hurt some people's eyes, for example 
inline declarations.  Please bear with us.  We do it that way because 
it makes the code easier to refactor, still an important consideration 
at this point.  There are some C++ style comments, please do not be 
outraged.  This is one of our ways of saying FIXME: whatever 
transgressions those comments document should all be gone by the time 
this code is kernel-ready.

Even more caveats:  We build on 2.6.26.5 right now, which is getting 
ancient.  A sync-up with current Git trees is coming, and we will set 
up a proper Git tree for people to pull from.

Finally: Developers interested in taking a poke are more than welcome.  
There are lots of little bits still needing doing, and some of the work 
is really interesting.  We are doing something new and fun here, and we 
would like you to be a part of it.

  http://tux3.org
  irc.oftc.net #tux3

Regards,

Daniel

[1] fsx-linux filesystem exerciser:
    http://www.codemonkey.org.uk/projects/fsx/
