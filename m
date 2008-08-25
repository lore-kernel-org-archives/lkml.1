Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYHYBC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYHYBC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 21:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYHYBCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 21:02:19 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:23506 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368AbYHYBCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 21:02:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjEEALOgsUh5LD0wiGdsb2JhbACSLgEBDyCfaYFq
X-IronPort-AV: E=Sophos;i="4.32,264,1217773800"; 
   d="scan'208";a="179393358"
Date: Mon, 25 Aug 2008 11:02:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, hch@lst.de
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
Message-ID: <20080825010213.GO5706@disturbed>
Mail-Followup-To: Daniel J Blueman <daniel.blueman@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	hch@lst.de
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 10:12:59PM +0100, Daniel J Blueman wrote:
> On 2.6.27-rc4 with various debug options enabled, lockdep claims lock
> ordering issues with XFS [1] - easiest reproducer is just running
> xfs_fsr. Mount options I was using were
> 'nobarrier,noatime,nodiratime'.
> 
> Thanks,
>   Daniel
> 
> --- [1]
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.27-rc4-224c #1
> -------------------------------------------------------
> xfs_fsr/5763 is trying to acquire lock:
>  (&(&ip->i_lock)->mr_lock/2){--..}, at: [<ffffffff803ad8fc>] xfs_ilock+0x8c/0xb0
> 
> but task is already holding lock:
>  (&(&ip->i_iolock)->mr_lock/3){--..}, at: [<ffffffff803ad915>]
> xfs_ilock+0xa5/0xb0

False positive. We do:

	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
	.....
	xfs_iunlock(ip, XFS_ILOCK_EXCL);
	xfs_iunlock(tip, XFS_ILOCK_EXCL);
	.....
	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);

Which is a perfectly valid thing to do.

The problem is that lockdep is complaining about the second call
to xfs_lock_two_inodes(), which uses the subclasses 2 and 3.
effectively it is seeing:

	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
		iolock/2
		ilock/2
		iolock/3
		ilock/3
	.....
	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
		ilock/2
		ilock/3


But because the original lock order was ilock/2->iolock/3, the
second call to xfs_lock_two_inodes is seeing iolock/3->ilock/2
which it then complains about....

Christoph - I think we're going to need to pass a lockdep 'order'
flag into xfs_lock_two_inodes() to avoid this so the second call
can use different classes to the first call. Or perhaps a '_nested'
variant of the call...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
