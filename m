Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXEPX6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXEPX6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXEPX5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:57:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36644 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755714AbXEPX5y (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:57:54 -0400
Date: Thu, 17 May 2007 09:57:31 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com
Subject: Re: [2/3] 2.6.22-rc1: known regressions v2 - XFS
Message-ID: <20070516235731.GR85884050@sgi.com>
References: <464B6743.9000607@googlemail.com> <464B6A2B.9020703@googlemail.com> <20070516233419.GP85884050@sgi.com> <464B9664.2040200@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B9664.2040200@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 04:40:20PM -0700, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> > Jeremy has tentatively indicated that the patch has fixed the problem.
> > Have you seen any more problems since applying the patch, Jeremy?
> >   
> 
> No, it continues to seem sound with casual use; I would have expected to
> see the problem reoccur by now.  I'd like to rerun the full set of tests
> I did before to be sure, but so far so good.  No other apparent
> regressions either.

Good to here. I think the problem is fixed, then.

> Also, the match between the observed symptoms and the bugfix is very
> good, which adds confidence (ie, no element of "it works now but we
> don't know why").  I guess the only remaining concern is whether there
> are any other paths which fail to dirty the inode.

There aren't any that I can see - if more come up we'll deal with
them then.

> Did you manage to repro the problem?

xfs_io is my friend ;)

Without patch:

# touch /mnt/scratch/fred
# xfs_io -c "pwrite 0 5" -c "s" -c "pwrite 5 5" /mnt/scratch/fred
wrote 5/5 bytes at offset 0
5.000000 bytes, 1 ops; 0.0000 sec (78.755 KiB/sec and 16129.0323 ops/sec)
wrote 5/5 bytes at offset 5
5.000000 bytes, 1 ops; 0.0000 sec (542.535 KiB/sec and 111111.1111 ops/sec)
# umount /mnt/scratch; mount /mnt/scratch; ls -l /mnt/scratch/fred
-rw-r--r-- 1 root      root      5 May 17 10:04 fred
#

So the second 5 byte write didn't change the file size.

With patch:

# touch /mnt/scratch/fred
# xfs_io -c "pwrite 0 5" -c "s" -c "pwrite 5 5" /mnt/scratch/fred
wrote 5/5 bytes at offset 0
5.000000 bytes, 1 ops; 0.0000 sec (76 KiB/sec and 15625.0000 ops/sec)
wrote 5/5 bytes at offset 5
5.000000 bytes, 1 ops; 0.0000 sec (610 KiB/sec and 125000.0000 ops/sec)
# umount /mnt/scratch; mount /mnt/scratch; ls -l /mnt/scratch/fred
-rw-r--r-- 1 root      root     10 May 17 09:53 fred
#

So yes, I've reproduced it and confirmed the patch fixes the problem.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
