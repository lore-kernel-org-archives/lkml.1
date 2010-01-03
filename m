Return-Path: <linux-kernel-owner+w=401wt.eu-S1751736Ab0ACD2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab0ACD2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 22:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311Ab0ACD2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 22:28:13 -0500
Received: from thunk.org ([69.25.196.29]:33328 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab0ACD2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 22:28:12 -0500
Date: Sat, 2 Jan 2010 22:27:58 -0500
From: tytso@mit.edu
To: Christian Kujau <lists@nerdbynature.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100103032758.GP828@thunk.org>
Mail-Followup-To: tytso@mit.edu, Christian Kujau <lists@nerdbynature.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
References: <20100102163644.GA5076@nowhere>
 <20100102174311.GA30016@basil.fritz.box>
 <20100102190213.GC5076@nowhere>
 <20100102192337.GB30016@basil.fritz.box>
 <20100102201138.GF5076@nowhere>
 <20100102210101.GN828@thunk.org>
 <20100102210653.GH5076@nowhere>
 <20100102233603.GO828@thunk.org>
 <20100103015208.GJ5076@nowhere>
 <alpine.DEB.2.01.1001021800450.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1001021800450.3483@bogon.housecafe.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 06:05:13PM -0800, Christian Kujau wrote:
> On Sun, 3 Jan 2010 at 02:52, Frederic Weisbecker wrote:
> > [: 53: ==: unexpected operator
> > common.rc: Error: $TEST_DEV (/dev/sda3) is not a MOUNTED xfs filesystem
> 
> Yeah, I'm playing around with xfstests as well, but apparently they're 
> assuming !/bin/sh will be run under /bin/bash, which is not always the 
> case. A short fix is to link /bin/sh to /bin/bash, but perhaps some of the 
> tests can be tweaked to run under /bin/sh as well.
> 
> > I'm not sure how I can run these tests on a non-xfs partitions.
> > I must be missing something.
> 
> I haven't found an easy way to do this yet without rewriting a few 
> routines (mkfs, mount, etc...). As Ted is already using xfstests for 
> btrfs, ext4, maybe he wants to share his magic? :-)

I'm using it for ext4.  It looks like someone has already tried using
the xfstests with reiserfs; take a look at common.rc; you'll see case
statements for xfs, udf, nfs, ext2/3/4, reiserfs, and gfs2.  Someone
who wants to use xfstests for some other file system may need to
further edit common.rc.  I thought the btrfs folks were using it as
well, but at least the kernel.org git tree for xfstests doesn't seem
to show any btrfs references in common.rc, so perhaps I'm wrong about
btrfs developers using xfstests (or they haven't sent their patches
back upstream).  I'm not sure how well tested the reiserfs support is,
so you may need to edit common.rc as necessary.

In any case, the README file has pretty much what you need.  I
personally run my test kernels using KVM, and I have a run-test script
which invokes check as follows:

#!/bin/sh
export TEST_DEV=/dev/sdb
export TEST_DIR=/test
export SCRATCH_DEV=/dev/sdc1
export SCRATCH_MNT=/scratch
export EXT_MOUNT_OPTIONS="-o block_validity"
exec ./check -ext4 $*

/dev/sdb is an ext4-formated filesystem, which you're supposed to not
reformat from run to run, so that some testing can be done with an
"aged" file system.  The scratch filesystem will be reformatted for
various tests, so you shouldn't keep anything valueable on it.

I also have a 1k block file system on /dev/sdd, so I invoke check as
follows to check to make sure things work when blocksize != pagesize:

#!/bin/sh
export TEST_DEV=/dev/sdd
export TEST_DIR=/test-1k
export SCRATCH_DEV=/dev/sdc1
export SCRATCH_MNT=/scratch
export MKFS_OPTIONS="-b 1024"
exec ./check -ext4 $*

As far as the inconsistency between TEST_DIR versus SCRATCH_MNT ---
all I can say is, the XFS engineers who threw together the xfstests
scripts may have been very good file system engineers, but they
obviously weren't very well used as UI/User Experience designers.  :-)
(The documentation isn't all that great either, but patches sent to
xfs@oss.sgi.com do tend to be accepted and merged into the kernel.org
tree if they are clean.)

Hope this helps,

						- Ted
