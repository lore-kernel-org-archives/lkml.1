Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYKZFWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYKZFWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYKZFWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:22:01 -0500
Received: from phunq.net ([64.81.85.152]:36730 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750749AbYKZFV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:21:59 -0500
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 Report: Now in kernel and the fun begins
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Cc: linux-fsdevel@vger.kernel.org
Date: Tue, 25 Nov 2008 21:21:58 -0800
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811252121.58223.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If it seems a little quiet over here in Tux3 land, that is just because
we have been busy.

The start of the Tux3 kernel port was announced on the Tux3 mailing list 
on November 14th, and two weeks later Hirofumi Ogawa had it mostly 
working:

   http://tux3.org/pipermail/tux3/2008-November/000321.html
   http://tux3.org/pipermail/tux3/2008-November/000351.html
   http://tux3.org/tux3

Hirofumi must have set some kind of record by getting to first mount in 
one week from a standing start!  This is a very early port with bugs 
and missing features, including major missing functionality like atomic 
commit, smp locking and versioning.  But it mounts, and we can read 
files, list directories and exercise lots of other functionality.  A 
common code base runs both in kernel and in user space under FUSE, 
which I think is unique and also very useful.  Even though the kernel 
port has a bug that keeps it from writing to files as of today, we can 
already create files in user space, mount the volume in kernel and read 
them back.

We have two repositories: a git repostory with a full kernel tree 
incorporating Tux3 (which I will not advertise for now because of the 
limited bandwidth of my server) and a Mercurial repository with the 
userspace code and the kernel code in a subdirectory:

   hg layout for userspace: tux3/user/kernel/*
   git layout for kernel: linux/fs/tux3/*

The tux3/user/* files #include the user/kernel files, which are the same 
as the fs/tux3 kernel directory.  In user space, we build and run unit 
tests for many tricky bits like btree operations and inode attribute 
packing.  We also build two kinds of Tux3 filesystem in user space: 
a "tux3fs" that runs as a FUSE filesystem and a "tux3" command that 
provides syntax like:

   tux3 mkfs <volume>
   tux3 read <volume> <file>
   echo <text> | tux3 write <volume> <file>

Where <volume> can be a /dev/<partition> or a file.

Many thanks to Conrad Meyer for the original FUSE port, and to Tero 
Roponen for the low level FUSE port:

   http://tux3.org/pipermail/tux3/2008-September/000115.html
   http://tux3.org/pipermail/tux3/2008-September/000128.html

Both of these came as welcome surprises, and proved immediately valuable 
to the Tux3 development effort.  With FUSE, suddenly we could test real 
filesystem functionality and spot many issues quickly.  The tux3 
command turned out to be indispensable too, for creating filesystem 
images to test under FUSE and later under Hirofumi's kernel port.

Hirofumi started his involvement with Tux3 by creating an amazing tool, 
a hack of Tux3 that reads the structure of a tux3 volume and turns it 
into a a graphic representation:

   http://userweb.kernel.org/~hirofumi/tux3.img.dot.png

This turned out to be more than just a way to make pretty pictures - the 
image above actually shows a bug.  The second extent of the rightmost 
inode (number 14, hex 0xe) has a physical block number of zero, but 
that should be 0x11 according to the tracing output:

   http://userweb.kernel.org/~hirofumi/serial.txt
     489 1 entry groups:
     490   0/2: 0 => f/1; 1 => 11/1;
     491 tux3_get_block: dirty b_blocknr e
     492 tux3_get_block: <== inum e, mapped 1, block 11, size 1000

We see that a correct file data index leaf ("deaf") was created (the 
second extent is 1 => 11/1, meaning logical address 1 maps to physical 
extent 0x11 of length 1 block).  But on disk we got a zero in that 
extent instead of 0x11.  Hmm.  Obviously, this little bug has a very 
short life expectancy, because it is unlucky enough to find itself 
looking straight down the barrel of a high caliber debugging cannon.  
One thing I can say: debugging this way is much more fun than usual.

The mercurial repostitory is here:

   http://tux3.org/tux3

The kernel patch is here:

   http://tux3.org/patches/tux3-2.6.26.5-0

This patch only needs to be applied once, then development can be 
tracked by pulling from the Mercurial repository and copying the 
user/kernel/* files from there to linux-2.6.26.5/fs/tux3/.  There is a 
git repository too, but my limited bandwidth means that pulling from 
Mercurial and copying the files is better for now.

The functionality we have today is roughly like a buggy Ext2 with 
missing features.  While it is very definitely not something you want 
to store your files on, this undeniably is Tux3 and demonstrates a lot 
of new design elements that I have described in some detail over the 
last few months.  The variable length inodes, the attribute packing, 
the btree design, the compact extent encoding and deduplication of 
extended attribute names are all working out really well.

The Tux3 project mission has changed over the course of the last few 
months.  At first the idea was to "be better than ZFS".  Now the main 
goal is more specific: we wish to uphold the classic principles of Unix 
system design.  That is, while Tux3 should do what ZFS does, it should 
do it without rampant layer violations.  Filesystems should be 
filesystems and volume managers should be volume managers.  We need 
better integration between these instead of new islands of 
functionality, breeding new sets of bugs.  Also, we do not wish to boil 
the oceans, but to run lean and mean.  We do not need to boil the 
oceans in order to support both the largest and the smallest 
conceivable volumes over the course of the next few decades.

I continue to take inspiration and guidance from Matt Dillon, whose 
Dragonfly BSD Hammer design is perhaps closest in spirit to that of 
Tux3.  Also, many thanks to Timothy Huber for cheerleading this effort 
from the very beginning and applying his considerable graphic talent in 
ways that will shortly become apparent.  And to Shapor Naghibzadeh for 
making dleaf.c work, no small feat, and many other things.  And Maciej 
Zenczykowski for contributing "junkfs", which is about to become very 
useful as we shall see next week.

There remains much to do before Tux3 gets to the point of head-to-head 
benchmarking.  But there is also a huge amount done.  If you were 
thinking of dropping by to see what is going on and maybe lend a hand, 
now is the perfect time to do it:

   http://tux3.org/cgi-bin/mailman/listinfo/tux3
   irc.oftc.net #tux3

Regards,

Daniel
