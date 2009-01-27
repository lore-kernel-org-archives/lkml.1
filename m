Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbZA0E6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbZA0E6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 23:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZA0E6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 23:58:38 -0500
Received: from phunq.net ([64.81.85.152]:36180 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751857AbZA0E6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 23:58:36 -0500
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 Report: Kernel development moved to Git mainline
Date: Mon, 26 Jan 2009 20:58:33 -0800
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org, tux3@tux3.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901262058.34187.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tux3 kernel development is now tracking Linus mainline, and will no
longer maintain compatibility with older kernels.  With the arrival of
delayed allocation, Tux3 now compiles only on kernels newer than
2.6.28.  A patch against v2.6.29-rc1 is here:

   http://tux3.org/patches/tux3-v2.6.29-rc1

Tux3 user space development remains in Mercurial:

   http://hg.tux3.org/tux3/

The Mercurial tree contains a complete, current copy of the fs/tux3
kernel files.  Our normal development mode is to add new functionality
and unit tests in user space, then port to kernel.  Sometimes it goes
the other way, with kernel changes backported to userspace.  In any
case, I use rsync to keep the Git and Mercurial kernel files in sync:

   rsync -t .../hg/tux3/user/kernel/* fs/tux3/ && make CONFIG_TUX3=y

There will be a public git tree soon.  For today, there is a patch
against Linus's tagged revision v2.6.29-rc1, the most recent one that
builds UML without a patch.  (I still do the majority of my Tux3 kernel
development on UML, while Hirofumi uses KVM and real machines, and
others use Xen.)

Status

Tux3 now uses delayed allocation, which is not just a performance hack
but a step in the direction of atomic commit.  Tux3 now keeps its
metadata blocks in a normal inode->mapping owned by the filesystem,
rather than the blockdev mapping, which has a different superblock than
the fs.  This sounds like a big change, but it was actually pretty
easy and not much code.  We made this change because block_dev.c is
dependent on buffer_head, and has its own ideas how metadata flushing
should be done.  Rather than fight with it, we switched.  It is nice to
be able to find our own superblock, given a buffer.  We will eventually
replace buffers entirely, with a new mechanism called block handles
that provides the block state we need with 16 bytes per page instead of
the 192 bytes worth of circular buffer list you get now with 1K blocks.

Tux3 has passed 27 hours of fsx-linux stress testing under memory
pressure, with delalloc and the new volmap metadata mapping.  We will
now say sayonara to stability for a while, as atomic commit goes in.
When atomic commit is in, the main structure of Tux3 is done, and we
plan to call for review at that time, leaving a bunch of features and
optimizations for later.  We expect Tux3 will perform decently as an
Ext3-class filesystem at that point, including crash recovery, though
it will be no benchmark champion before further optimization.

Build instructions

If you already have Linus's Git tree, please be nice and clone it
locally, otherwise:

   # Clone Linus's Git tree:
   git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
   cd linux-2.6
   git checkout v2.6.29-rc1

   # Get the current Tux3 patch and apply it:
   wget http://tux3.org/patches/tux3-v2.6.29-rc1
   patch <tux3-v2.6.29-rc1 -p1

   # Build linux with tux3:
   make defconfig
   make CONFIG_TUX3=y
   sudo make install

   # Check out the Tux3 user space Mercurial tree:
   hg clone http://hg.tux3.org/tux3/
   cd tux3/user
   make

   # make a tux3 filesystem
   sudo ./tux3 mkfs /dev/<testpartition>

Boot and mount!

   cat /proc/filesystems | grep tux3 && mount /dev/<testpartition> /mnt

Recovery after crash or unexpected shutdown is easy:

   tux3 mkfs <volname>

Regards,

Daniel
