Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbYAUCzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbYAUCzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 21:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYAUCz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 21:55:29 -0500
Received: from relay1.sgi.com ([192.48.171.29]:41627 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031AbYAUCz3 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 21:55:29 -0500
Date: Mon, 21 Jan 2008 13:55:10 +1100
From: David Chinner <dgc@sgi.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org,
       mingo@redhat.com
Subject: Re: 2.6.24-rc8: possible circular locking dependency detected
Message-ID: <20080121025510.GY155259@sgi.com>
References: <alpine.DEB.1.00.0801182240310.6521@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0801182240310.6521@sheep.housecafe.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 10:45:17PM +0100, Christian Kujau wrote:
> Hi,
> 
> just FYI, upgrading to -rc8 gave the following messages in kern.log in
> the morning hours, when the backups were run:
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.24-rc8 #2
> -------------------------------------------------------
> rsync/23295 is trying to acquire lock:
>  (iprune_mutex){--..}, at: [<c017a552>] shrink_icache_memory+0x72/0x220
> 
> but task is already holding lock:
>  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0275056>] xfs_ilock+0x96/0xb0
> 
> which lock already depends on the new lock.

memory reclaim can occur when an inode lock is held,
causing i_iolock -> iprune_mutex to occur. This is quite
common.

During reclaim, while holding iprune_mutex, we lock a
different inode to complete the cleaning up of it,
resulting in iprune_mutex -> i_iolock.

At this point, lockdep gets upset and blats out a warning.

But, there's no problem here as it is always safe for us
to take the i_iolock in inode reclaim because it can never
be the same as the i_iolock that we've taken prior to memory
reclaim being entered. Therefore false positive.

Lockdep folk - we really need an annotation to prevent this false
positive from being reported because we are getting reports at
least once a week....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
