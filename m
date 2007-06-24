Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbXFXXXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbXFXXXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFXXXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:23:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60041 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751081AbXFXXXE (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:23:04 -0400
Date: Mon, 25 Jun 2007 09:22:46 +1000
From: David Chinner <dgc@sgi.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: [REGRESSION 2.6-git] possible circular locking dependency detected with XFS
Message-ID: <20070624232246.GF86004887@sgi.com>
References: <6101e8c40706221340k65f15957k39a04193cb6e7c01@mail.gmail.com> <6bffcb0e0706221553s3a74ef58hcadc69bfa252283@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0706221553s3a74ef58hcadc69bfa252283@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 12:53:11AM +0200, Michal Piotrowski wrote:
> Hi Oliver,
> 
> On 22/06/07, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> >Hi all!
> >
> >I found this info:
> >
> >======================================================= [ INFO: possible
> >circular locking dependency detected ] 2.6.22-rc5-wifi1 #2
> >------------------------------------------------------- mount/2209 is
> >trying to acquire lock: (&(&ip->i_lock)->mr_lock/1){--..}, at: [<c022b62d>]
> >xfs_ilock+0x66/0x90
> >
> >but task is already holding lock: (&(&ip->i_lock)->mr_lock){----}, at:
> >[<c022b62d>] xfs_ilock+0x66/0x90
> >
> 
> AFAIR it is not a regression. It is a known bug (harmless).

FWIW, it's not even a bug. The bug (if any) is due to the fact we
can't properly express the XFS locking rules with lockdep. We
recently added a bunch of notations that fixed the common false
positives we were seeing, but as a result, it appears we now have a
whole new set of false positive reports coming in that are even
harder to fix.

As Christoph Hellwig has previously noted, the correct way to fix
this in XFS is to completely change the locking within XFS directory
operations to do strict parent/child locking like the VFS does.
Unfortunately, that's not as simple as it sounds, because inode
flushing and log tail pushing rely on inodes being locked in
ascending inode order to prevent deadlocks within XFS. 

That means when we lock multiple inodes in link, rename, etc, we
have to lock them in ascending order. The exception to this is
create, mkdir, mknod because the newly created inode will not be
locked by definition so it is always safe to lock it.

Hence if the new inode's number is less than the parent inode's
number we can get lockdep warning about circular locking
dependencies which don't actually exist. That is where this warning
is coming from....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
