Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZABCIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZABCIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 21:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZABCIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 21:08:05 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:39872 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753558AbZABCIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 21:08:04 -0500
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090101232705.GG10725@disturbed>
References: <20081230231152.10427.50620.stgit@hermosa.site>
	 <87fxk5ur0h.fsf@basil.nowhere.org> <1230688589.3470.45.camel@hermosa.site>
	 <20081231024609.GQ496@one.firstfloor.org>
	 <1230696664.3470.105.camel@hermosa.site> <20081231070802.GE10725@disturbed>
	 <1230738056.3470.150.camel@hermosa.site> <20090101232705.GG10725@disturbed>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Thu, 01 Jan 2009 19:07:56 -0700
Message-Id: <1230862076.3470.235.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-02 at 10:27 +1100, Dave Chinner wrote:
> On Wed, Dec 31, 2008 at 08:40:56AM -0700, Peter W. Morreale wrote:
..
> > 
> > For example, on a 'slow' device, I probably want to start flushing
> > sooner, rather than later.  On a fast device, perhaps we wait a bit
> > longer before starting flushing. 
> 
> I think you'll find the other way around. It's *hard* to keep a fast
> block device busy - you turn the memory cache over much, much faster
> so reclaim of the cache needs to happen much faster and this becomes
> the limiting factor when trying to write back multiple GB of data
> every second.

Nod.  However biasing flushing towards the fast block devices penalizes
applications referencing those devices.  Its good for reclaim in that we
get our space quicker, but future references may involve another read
since those pages may have been reallocated elsewhere. Consequently if
the onus of creating free space is biased towards the fastest devices,
applications referencing them may suffer.  Do I have that right?

>From a 1000ft view, it seems to me that we want all devices to reach the
finish line at the same time.  Each performing their appropriate share
of cleaning up based on the amount they contributed to the issue of a
dirty memory space.  

It seems to me that we want (by default) to spread out the cost of
reclaim on an even basis across all block devs.  


> 
> > At the end of the day we are governed by Little's Law, so we have to
> > optimize the exit from the system. 
> > 
> > In general, we want flushing to reach the minimum dirty threshold as
> > fast as possible since we are taking cycles away from our applications.
> 
> I disagree. You need a certain amount of memory for optimising
> operations such as avoiding writeback of short-term temporary files.
> e.g. do a build in one directory followed by a clean to make sure
> the build works. In that case, you want the object data held in
> memory so the only operations that hit the disk are creates and
> unlinks.

Heh, I don't think you disagree with giving cycles to applications,
right?  

Rereading, my statement, what I probably should have said was "reach the
_maximum_ dirty threshold", meaning that that we stop generic flushing
as soon as possible so things like temporary files are still cached.  

> 
> Remember, SSDs are still limited in their bandwidth and IOPS. The
> current SSDs (e.g. intel) have the capability of a small RAID array
> with a NVRAM write cache. Even though they are fast, we still need
> to optimise at a high level to make most efficient use of their
> limited resources....

> > (To me this is far more important than age...)  So, WIRWTD is to create
> > a heuristic that takes into account:
> > 
> > o Device speed
> 
> We caclculate that on the fly based on the flushing rate of
> the BDI.
> 
> > o nr pages dirty 'owned' by the device.
> 
> Already got that (bdi stats) and it is used for the above
> caclulation.
> 
> > o nr system dirty pages (e.g. existing dirty stuff)
> 
> Already got that.
> 
> > o age (or do we really care?)
> 
> Got that because we do care about ensuring the oldest
> dirty stuff gets written back before something newly dirtied.
> 
> > o tunings 
> >
> > Now we can weight flushing towards 'fast' devices to reach our
> > thresholds as well as ignore devices that offer little relief (e.g. have
> > no dirty pages outstanding)  
> 
> Check out:
> 
> /sys/block/*/bdi/min_ratio
> /sys/block/*/bdi/max_ratio
> 
> To change the proportions of the writeback pie a given block device
> will be given. I think that is what you want.
> 
> However, this still doesn't address the real problem with pdflush
> and flushing. That is, pdflush (like sync) assumes that the fastest
> (and only) way to flush a filesystem is to walk across dirty inodes
> in age order and flush their data followed by immediate flushing of
> the inode. That may work for ext3, but it's far from optimal for
> XFS, btrfs, etc which have far different optimal flushing
> strategies.
> 
> There's a bunch more info about these problems and the path we're
> trying to head down for XFS here:
> 
> http://xfs.org/index.php/Improving_inode_Caching
> 
> and specifically to this topic:
> 
> http://xfs.org/index.php/Improving_inode_Caching#Avoiding_the_Generic_pdflush_Code
> 

Thanks for these, I'll read on...

Best,
-PWM


> Cheers,
> 
> Dave.

