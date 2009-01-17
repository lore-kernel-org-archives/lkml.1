Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbZAQIM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbZAQIM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 03:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZAQIMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 03:12:15 -0500
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:30857 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050AbZAQIMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 03:12:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMAfcUl5LBUR/2dsb2JhbADLN4Vy
X-IronPort-AV: E=Sophos;i="4.37,280,1231075800"; 
   d="scan'208";a="284902357"
Date: Sat, 17 Jan 2009 19:12:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mike Waychison <mikew@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 0/8] Deferred dput() and iput() -- reducing lock
	contention
Message-ID: <20090117081210.GL8071@disturbed>
Mail-Followup-To: Mike Waychison <mikew@google.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 06:29:36PM -0800, Mike Waychison wrote:
> We've noticed that at times it can become very easy to have a system begin to
> livelock on dcache_lock/inode_lock (specifically in atomic_dec_and_lock()) when
> a lot of dentries are getting finalized at the same time (massive delete and
> large fdtable destructions are two paths I've seen cause problems).
> 
> This patchset is an attempt to try and reduce the locking overheads associated
> with final dput() and final iput().  This is done by batching dentries and
> inodes into per-process queues and processing them in 'parallel' to consolidate
> some of the locking.

Hmmmm. This deferring of dput/iput will have the same class of
effects on filesystems as the recent reverted changes to make
generic_delete_inode() an asynchronous process. That is, it
temporally separates the transaction for namespace deletion (i.e.
unlink) from the transaction that completes the inode deletion that
occurs, typically, during ->clear_inode. See the recent thread
titled:

[PATCH] async: Don't call async_synchronize_full_special() while holding sb_lock

For more details.

I suspect that change is likely to cause worse problems than the
async changes in that it doesn't have a cap on the number of
deferred operations.....

> Besides various workload testing,

Details?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
