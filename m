Return-Path: <linux-kernel-owner+w=401wt.eu-S1751242AbXBUMlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbXBUMlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 07:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXBUMlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 07:41:15 -0500
Received: from lazybastard.de ([212.112.238.170]:60249 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbXBUMlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 07:41:14 -0500
Date: Wed, 21 Feb 2007 12:37:53 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Juan Piernas Canovas <piernas@ditec.um.es>
Cc: Sorin Faibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070221123753.GA464@lazybastard.org>
References: <20070216091321.GA28092@lazybastard.org> <45D642A4.5010009@tmr.com> <20070217151108.GA301@lazybastard.org> <45D7450F.6090309@tmr.com> <20070217183646.GE301@lazybastard.org> <op.tnwuonh3rwwil4@muki-1mj5c5mxes> <20070218055936.GF301@lazybastard.org> <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es> <20070220003059.GJ7813@lazybastard.org> <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 February 2007 05:36:22 +0100, Juan Piernas Canovas wrote:
> >
> >I don't see how you can guarantee 50% free segments.  Can you explain
> >that bit?
> It is quite simple. If 50% of your segments are busy, and the other 50% 
> are free, and the file system needs a new segment, the cleaner starts 
> freeing some of busy ones. If the cleaner is unable to free one segment at 
> least, your file system gets "full" (and it returns a nice ENOSPC error). 
> This solution wastes the half of your storage device, but it is 
> deadlock-free. Obviously, there are better approaches.

Ah, ok.  It is deadlock free, if the maximal height of your tree is 2.
It is not 100% deadlock free if the height is 3 or more.

Also, I strongly suspect that your tree is higher than 2.  A medium
sized directory will have data blocks, indirect blocks and the inode
proper, which gives you a height of 3.  Your inodes need to get accessed
somehow and unless they have fixed positions like in ext2, you need a
further tree structure of some sorts, so you're more likely looking at a
height of 5.

With a height of 5, you would need to keep 80% of you metadata free.
That is starting to get wasteful.

So I suspect that my proposed alternate cleaner mechanism or the even
better "hole plugging" mechanism proposed in the paper a few posts above
would be a better path to follow.

> >A fine principle to work with.  Surprisingly, what is the worst case for
> >you is the common case for LogFS, so maybe I'm more interested in it
> >than most people.  Or maybe I'm just more paranoid.
> 
> No, you are right. It is the common case for LogFS because it has data and 
> meta-data blocks in the same address space, but that is not the case of 
> DualFS. Anyway, I'm very interested in your work because any solution to 
> the problem of the GC will be also applicable to DualFS. So, keep up with 
> it. ;-)

Actually, no.  It is the common case for LogFS because it is designed
for flash media.  Unlike hard disks, flash lifetime is limited by the
amount of data written to it.  Therefore, having a cleaner run when the
filesystem is idle would cause unnecessary writes and reduce lifetime.

As a result, the LogFS cleaner runs as lazily as possible and the
filesystem tries hard not to mix data with different lifetimes in one
segment.  LogFS tries to avoid the cleaner like the plague.  But if it
ever needs to run it, the deadlock scenario is very close and I need to
be very aware of it. :)

In a way, the DualFS approach does not change rules for the
log-structured filesystem at all.  If you had designed your filesystem
in such a way that you simply used two existent filesystems and wrote
Actual Data (AD) to one, Metadata (MD) to another, what is MD to DualFS
is plain data to one of your underlying filesystems.  It can cause a bit
of confusion, because I tend to call MD "data" and you tend to call AD
"data", but that is about all.

Jörn

-- 
But this is not to say that the main benefit of Linux and other GPL
software is lower-cost. Control is the main benefit--cost is secondary.
-- Bruce Perens
