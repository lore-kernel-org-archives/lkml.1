Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbYHNAlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbYHNAlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYHNAlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:41:07 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:2709 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752981AbYHNAlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:41:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiADAGcZo0h5LAMbiGdsb2JhbACRcwEBAQ8gpHGBVQ
X-IronPort-AV: E=Sophos;i="4.32,204,1217773800"; 
   d="scan'208";a="181607977"
Date: Thu, 14 Aug 2008 10:41:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS Lock debugging noise or real problem?
Message-ID: <20080814004101.GE6119@disturbed>
Mail-Followup-To: Linda Walsh <xfs@tlinx.org>, xfs-oss <xfs@oss.sgi.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@sandeen.net>
References: <48A093A7.40606@tlinx.org> <48A09CA9.9080705@sandeen.net> <48A0F686.2090700@tlinx.org> <48A0F9FC.1070805@sandeen.net> <48A20E9E.9090100@tlinx.org> <20080813005852.GW6119@disturbed> <48A35A99.1080300@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A35A99.1080300@tlinx.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 03:05:13PM -0700, Linda Walsh wrote:
> Dave Chinner wrote:
>> Once again,
>> "a problem with the generic code inverting the normal lock order".
>>
>> This one cannot deadlock, though, because by definition
>> any inode on the unused list is, well, unused and hence we can't be
>> holding a reference to it...
> ----
>
> 	This is great, maybe...but what do you mean by "generic"?

generic code == non-filesystem specific kernel code that interfaces
with the filesystem code.

> 	Is this generic in the FS layer such that we'd see
> this with all FS types?

Any filesystem that does memory allocation with the same type of
lock held that it might take when reclaiming a inode.

This is a problem where we go:

	XFS: lock inode
	XFS: allocate memory
	  VM: free some memory
	    VM: shrink slab
	      VM: prune inode cache (takes iprune_mutex)
	        XFS: lock inode

i.e. the VM recurses back into the filesystem and lockdep sees
a different lock ordering.

> I'd *like* to keep lock provability 'on' -- but I don't want
> to waste people's time chasing after non-problems and so far I've
> seen at least 3 different locking sequences that all appear to be
> harmless.
>
> 	The problem with false positives is that it will either force
> the user to ignore (or turn off) the validation code, or generate
> periodic noise when these things arise...

Basically we've been told by the lockdep folk that the best way
to avoid these false positives is to effectively turn off lockdep
for all places where the inode is locked in the inode reclaim path.
That means lockdep would be mostly useless for XFS - I'd prefer to get
false positives reported than miss a rare case where it's really
telling the truth.

I've asked the lockdep ppl to treat stuff like memory reclaim and
the iprune_mutex specially because of this recursive calling nature
of memory reclaim, but so far nothing has happened....

FWIW, I think that recent changes have resulted in the xfs_fsr case
(swap_extents) being annotated properly so that one should go
away.

> 	Isn't it generally considered pretty 'bad' to generate so many
> false positives -- or is lock-proving only for for "lock debugging" --
> and not to be used except on development or test systems?

Well, any debugging code is really designed for test and dev systems,
not for production systems.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
