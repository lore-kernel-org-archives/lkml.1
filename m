Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYKZH0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYKZH0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 02:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYKZH0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 02:26:30 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:10648 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbYKZH03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 02:26:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABaGLEl5LCiK/2dsb2JhbADSOIJ9
X-IronPort-AV: E=Sophos;i="4.33,667,1220193000"; 
   d="scan'208";a="238278142"
Date: Wed, 26 Nov 2008 18:26:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dan =?iso-8859-1?B?Tm/p?= <dpn@isomerica.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Lockdep warning for iprune_mutex at shrink_icache_memory
Message-ID: <20081126072625.GH6291@disturbed>
Mail-Followup-To: Dan =?iso-8859-1?B?Tm/p?= <dpn@isomerica.net>,
	linux-kernel@vger.kernel.org
References: <20081125064357.5a4f1420@tuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081125064357.5a4f1420@tuna>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 06:43:57AM -0500, Dan Noé wrote:
> I have experienced the following lockdep warning on 2.6.28-rc6.  I
> would be happy to help debug, but I don't know this section of code at
> all.
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.28-rc6git #1
> -------------------------------------------------------
> rsync/21485 is trying to acquire lock:
>  (iprune_mutex){--..}, at: [<ffffffff80310b14>]
> shrink_icache_memory+0x84/0x290
> 
> but task is already holding lock:
>  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffffa01fcae5>]
> xfs_ilock+0x75/0xb0 [xfs]

False positive. memory reclaim can be invoked while we
are holding an inode lock, which means we go:

	xfs_ilock -> iprune_mutex

And when the inode shrinker reclaims a dirty xfs inode,
we go:

	iprune_mutex -> xfs_ilock

However, this cannot deadlock as the first case can
only occur with a referenced inode, and the second case
can only occur with an unreferenced inode. Hence we can
never get a situation where the inode being locked on
either side of the iprune_mutex is the same inode so
deadlock is impossible.

To avoid this false positive, either we need to turn off
lockdep checking on xfs inodes (not going to happen), or memory
reclaim needs to be able to tell lockdep that recursion on
filesystem lock classes may occur. Perhaps we can add a
simple annotation to the iprune mutex initialisation as well as
the xfs ilock initialisation to indicate that such recursion
is possible and allowed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
