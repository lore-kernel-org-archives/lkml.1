Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYHYG7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYHYG7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 02:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYHYG7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 02:59:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:50531 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYHYG7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 02:59:00 -0400
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       hch@lst.de
In-Reply-To: <20080825010213.GO5706@disturbed>
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com>
	 <20080825010213.GO5706@disturbed>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 08:57:44 +0200
Message-Id: <1219647464.20732.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 11:02 +1000, Dave Chinner wrote:
> On Fri, Aug 22, 2008 at 10:12:59PM +0100, Daniel J Blueman wrote:
> > On 2.6.27-rc4 with various debug options enabled, lockdep claims lock
> > ordering issues with XFS [1] - easiest reproducer is just running
> > xfs_fsr. Mount options I was using were
> > 'nobarrier,noatime,nodiratime'.
> > 
> > Thanks,
> >   Daniel
> > 
> > --- [1]
> > 
> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.27-rc4-224c #1
> > -------------------------------------------------------
> > xfs_fsr/5763 is trying to acquire lock:
> >  (&(&ip->i_lock)->mr_lock/2){--..}, at: [<ffffffff803ad8fc>] xfs_ilock+0x8c/0xb0
> > 
> > but task is already holding lock:
> >  (&(&ip->i_iolock)->mr_lock/3){--..}, at: [<ffffffff803ad915>]
> > xfs_ilock+0xa5/0xb0
> 
> False positive. We do:
> 
> 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> 	.....
> 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 	xfs_iunlock(tip, XFS_ILOCK_EXCL);
> 	.....
> 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
> 
> Which is a perfectly valid thing to do.
> 
> The problem is that lockdep is complaining about the second call
> to xfs_lock_two_inodes(), which uses the subclasses 2 and 3.
> effectively it is seeing:
> 
> 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> 		iolock/2
> 		ilock/2
> 		iolock/3
> 		ilock/3
> 	.....
> 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
> 		ilock/2
> 		ilock/3
> 
> 
> But because the original lock order was ilock/2->iolock/3, the
> second call to xfs_lock_two_inodes is seeing iolock/3->ilock/2
> which it then complains about....

Does the annotation I used for
double_lock_balance()/double_unlock_balance() work?

Basically, it assumes the held lock (this_rq) has subclass 0, but
because double_lock_balance() can unlock and relock, depending on order,
it can end up being 1 at the end. So what we do is reset the subclass
(after unlocking the now 0 lock) to 0 using lock_set_subclass().


