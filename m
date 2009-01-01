Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbZAAX1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbZAAX1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 18:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZAAX1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 18:27:23 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:58710 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbZAAX1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 18:27:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqUCAIrdXEl5LB1fgWdsb2JhbACTewEBFiKsQAiJYYQ4CIEy
X-IronPort-AV: E=Sophos;i="4.36,315,1228051800"; 
   d="scan'208";a="285401606"
Date: Fri, 2 Jan 2009 10:27:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Peter W. Morreale" <pmorreale@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
Message-ID: <20090101232705.GG10725@disturbed>
Mail-Followup-To: "Peter W. Morreale" <pmorreale@novell.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <20081230231152.10427.50620.stgit@hermosa.site> <87fxk5ur0h.fsf@basil.nowhere.org> <1230688589.3470.45.camel@hermosa.site> <20081231024609.GQ496@one.firstfloor.org> <1230696664.3470.105.camel@hermosa.site> <20081231070802.GE10725@disturbed> <1230738056.3470.150.camel@hermosa.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230738056.3470.150.camel@hermosa.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 08:40:56AM -0700, Peter W. Morreale wrote:
> On Wed, 2008-12-31 at 18:08 +1100, Dave Chinner wrote:
> > On Tue, Dec 30, 2008 at 09:11:04PM -0700, Peter W. Morreale wrote:
> > > Actually, it seems to me that we need to look at a radically different
> > > approach.  What about making background writes a property of the super
> > > block? (which implies the file system)  Has that been discussed before?
> > 
> > Sure - there was a recent discussion in the context of how broken the
> > sync(2) syscall is.
> > 
> > That is, some filesystems (e.g. XFS) have certain requirements
> > to ensure sync actually works in all circumstances and the current
> > methods that sync employs make it impossible to sync correctly.
> > 
> <snip>
> 
> 
> Good point, but different. I was thinking merely in terms of the
> forthcoming SSD devices and flushing, not syncing.  We are approaching
> the point (from hardware...) where persistent storage is becoming
> balanced (wrt speed) with RAM.  

Flushing is simply the first part of syncing ;)

> This opens up a whole new world for cache considerations.  Consider that
> if my persistent storage is as fast as memory, then I want my memory
> cache size for that device to be 0 (zero) sized - there is no point.

mmap()?

> However, I have a number of different devices on my system, some disk,
> some SSD, some optical, etc.  Each has different characteristics, yet we
> treat them identically.   
> 
> (well, almost identically - we run through the SB list (and
> consequently, the devices) in reverse all the time :-)
> 
> WIRWTD ("What I Really Want To Do") is to incorporate the
> characteristics of the devices into the caching so I can optimize both
> my use of cache as well as the particular device(s). 

IOWs you want the block device characteristics determine the caching
and flushing techniques the higher layers use.

> At the moment, we have two triggers, memory pressure (the dirty_*
> tunings) and time (kupdate).  Once these thresholds are reached, we
> indiscriminately (wrt devices) begin flushing to achieve the minimum
> threshold again.  These are probably the right triggers from a system
> perspective, but there are others we could consider as well.  
> 
> For example, on a 'slow' device, I probably want to start flushing
> sooner, rather than later.  On a fast device, perhaps we wait a bit
> longer before starting flushing. 

I think you'll find the other way around. It's *hard* to keep a fast
block device busy - you turn the memory cache over much, much faster
so reclaim of the cache needs to happen much faster and this becomes
the limiting factor when trying to write back multiple GB of data
every second.

> At the end of the day we are governed by Little's Law, so we have to
> optimize the exit from the system. 
> 
> In general, we want flushing to reach the minimum dirty threshold as
> fast as possible since we are taking cycles away from our applications.

I disagree. You need a certain amount of memory for optimising
operations such as avoiding writeback of short-term temporary files.
e.g. do a build in one directory followed by a clean to make sure
the build works. In that case, you want the object data held in
memory so the only operations that hit the disk are creates and
unlinks.

Remember, SSDs are still limited in their bandwidth and IOPS. The
current SSDs (e.g. intel) have the capability of a small RAID array
with a NVRAM write cache. Even though they are fast, we still need
to optimise at a high level to make most efficient use of their
limited resources....

> (To me this is far more important than age...)  So, WIRWTD is to create
> a heuristic that takes into account:
> 
> o Device speed

We caclculate that on the fly based on the flushing rate of
the BDI.

> o nr pages dirty 'owned' by the device.

Already got that (bdi stats) and it is used for the above
caclulation.

> o nr system dirty pages (e.g. existing dirty stuff)

Already got that.

> o age (or do we really care?)

Got that because we do care about ensuring the oldest
dirty stuff gets written back before something newly dirtied.

> o tunings 
>
> Now we can weight flushing towards 'fast' devices to reach our
> thresholds as well as ignore devices that offer little relief (e.g. have
> no dirty pages outstanding)  

Check out:

/sys/block/*/bdi/min_ratio
/sys/block/*/bdi/max_ratio

To change the proportions of the writeback pie a given block device
will be given. I think that is what you want.

However, this still doesn't address the real problem with pdflush
and flushing. That is, pdflush (like sync) assumes that the fastest
(and only) way to flush a filesystem is to walk across dirty inodes
in age order and flush their data followed by immediate flushing of
the inode. That may work for ext3, but it's far from optimal for
XFS, btrfs, etc which have far different optimal flushing
strategies.

There's a bunch more info about these problems and the path we're
trying to head down for XFS here:

http://xfs.org/index.php/Improving_inode_Caching

and specifically to this topic:

http://xfs.org/index.php/Improving_inode_Caching#Avoiding_the_Generic_pdflush_Code

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
