Return-Path: <linux-kernel-owner+w=401wt.eu-S1423184AbXBBH3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423184AbXBBH3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423191AbXBBH3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:29:10 -0500
Received: from brick.kernel.dk ([62.242.22.158]:22055 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423184AbXBBH3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:29:08 -0500
Date: Fri, 2 Feb 2007 08:31:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070202073117.GS10305@kernel.dk>
References: <20070129204528.eb8d695e.akpm@osdl.org> <Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com> <20070131162422.6bccc52c.akpm@osdl.org> <Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com> <20070131163638.290f40c1.akpm@osdl.org> <20070201062018.GC33919298@melbourne.sgi.com> <20070131231253.fdebc9f5.akpm@osdl.org> <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com> <20070201191857.GQ10305@kernel.dk> <20070202040858.GN33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202040858.GN33919298@melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02 2007, David Chinner wrote:
> On Thu, Feb 01, 2007 at 08:18:57PM +0100, Jens Axboe wrote:
> > That down() probably wants a replug to precede it. Probably something
> > like:
> > 
> >         if (atomic_read(&bp->b_io_remaining))
> >                 blk_replug_current_nested();
> > 
> > for xfs_buf_wait_unpin() and xfs_buf_lock(). Does this fix it?
> 
> Jens, this patch looks like you originally removed the explicit
> unplug calls that XFS used to prevent metadata I/O hangs and now you
> are putting them back.  Correct?
> 
> Reading on from Andrew's earlier comments, shouldn't XFS have
> worked unchanged? I'm just trying to understand why you removed
> the explicit unplugs in the first place.....

It should, the problem is if someone has plugged higher up in the
hierarchy, then you do need the explicit replug to drain that before
going to sleep and waiting for IO to complete. Not very happy about that
situation, I'd prefer if that happened automagically. I'll likely change
the code to fix that, so we don't have to sprinkle
blk_replug_current_nested() and always call io_schedule() instead of
schedule(). It's just going to cause too many problems.

-- 
Jens Axboe

