Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526Ab0ADUUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0ADUUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 15:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093Ab0ADUU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 15:20:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52412 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab0ADUU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 15:20:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QWsAq0lxFAhegK0wu4Xukbi6u8b/koOi/SPHlw5Z7mUC1m3vjLZ/Y9ajNpBm3gJKaq
         CzjfnG6jxxcJ6L6Zm5fWJ860JoAiw1NRFjpttDqgg8OJXvJjvJFRnOmnFt+vA6ikM2M0
         sC9OCv2ukfwEns+bQYUaXFp439lbYqxaWpwqE=
Date: Mon, 4 Jan 2010 21:20:22 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: tytso@mit.edu
Cc: Christian Kujau <lists@nerdbynature.de>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100104202019.GB5205@nowhere>
References: <20100102174311.GA30016@basil.fritz.box> <20100102190213.GC5076@nowhere> <20100102192337.GB30016@basil.fritz.box> <20100102201138.GF5076@nowhere> <20100102210101.GN828@thunk.org> <20100102210653.GH5076@nowhere> <20100102233603.GO828@thunk.org> <20100103015208.GJ5076@nowhere> <alpine.DEB.2.01.1001021800450.3483@bogon.housecafe.de> <20100103032758.GP828@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100103032758.GP828@thunk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 10:27:58PM -0500, tytso@mit.edu wrote:
> On Sat, Jan 02, 2010 at 06:05:13PM -0800, Christian Kujau wrote:
> > On Sun, 3 Jan 2010 at 02:52, Frederic Weisbecker wrote:
> > > [: 53: ==: unexpected operator
> > > common.rc: Error: $TEST_DEV (/dev/sda3) is not a MOUNTED xfs filesystem
> > 
> > Yeah, I'm playing around with xfstests as well, but apparently they're 
> > assuming !/bin/sh will be run under /bin/bash, which is not always the 
> > case. A short fix is to link /bin/sh to /bin/bash, but perhaps some of the 
> > tests can be tweaked to run under /bin/sh as well.
> > 
> > > I'm not sure how I can run these tests on a non-xfs partitions.
> > > I must be missing something.
> > 
> > I haven't found an easy way to do this yet without rewriting a few 
> > routines (mkfs, mount, etc...). As Ted is already using xfstests for 
> > btrfs, ext4, maybe he wants to share his magic? :-)
> 
> I'm using it for ext4.  It looks like someone has already tried using
> the xfstests with reiserfs; take a look at common.rc; you'll see case
> statements for xfs, udf, nfs, ext2/3/4, reiserfs, and gfs2.  Someone
> who wants to use xfstests for some other file system may need to
> further edit common.rc.  I thought the btrfs folks were using it as
> well, but at least the kernel.org git tree for xfstests doesn't seem
> to show any btrfs references in common.rc, so perhaps I'm wrong about
> btrfs developers using xfstests (or they haven't sent their patches
> back upstream).  I'm not sure how well tested the reiserfs support is,
> so you may need to edit common.rc as necessary.
> 
> In any case, the README file has pretty much what you need.  I
> personally run my test kernels using KVM, and I have a run-test script
> which invokes check as follows:
> 
> #!/bin/sh
> export TEST_DEV=/dev/sdb
> export TEST_DIR=/test
> export SCRATCH_DEV=/dev/sdc1
> export SCRATCH_MNT=/scratch
> export EXT_MOUNT_OPTIONS="-o block_validity"
> exec ./check -ext4 $*
> 
> /dev/sdb is an ext4-formated filesystem, which you're supposed to not
> reformat from run to run, so that some testing can be done with an
> "aged" file system.  The scratch filesystem will be reformatted for
> various tests, so you shouldn't keep anything valueable on it.
> 
> I also have a 1k block file system on /dev/sdd, so I invoke check as
> follows to check to make sure things work when blocksize != pagesize:
> 
> #!/bin/sh
> export TEST_DEV=/dev/sdd
> export TEST_DIR=/test-1k
> export SCRATCH_DEV=/dev/sdc1
> export SCRATCH_MNT=/scratch
> export MKFS_OPTIONS="-b 1024"
> exec ./check -ext4 $*



Ok. Thanks a lot for all these details. It seems to be working
now that I have edited some shebang and replaced /bin/sh by
/bin/bash, like Christopher suggested.


 
> As far as the inconsistency between TEST_DIR versus SCRATCH_MNT ---
> all I can say is, the XFS engineers who threw together the xfstests
> scripts may have been very good file system engineers, but they
> obviously weren't very well used as UI/User Experience designers.  :-)



Agreed :)



> (The documentation isn't all that great either, but patches sent to
> xfs@oss.sgi.com do tend to be accepted and merged into the kernel.org
> tree if they are clean.)
> 
> Hope this helps,


Yeah, thanks!

