Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbYLaPlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbYLaPlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 10:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYLaPlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 10:41:04 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:48926 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755144AbYLaPlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 10:41:02 -0500
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081231070802.GE10725@disturbed>
References: <20081230231152.10427.50620.stgit@hermosa.site>
	 <87fxk5ur0h.fsf@basil.nowhere.org> <1230688589.3470.45.camel@hermosa.site>
	 <20081231024609.GQ496@one.firstfloor.org>
	 <1230696664.3470.105.camel@hermosa.site> <20081231070802.GE10725@disturbed>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Wed, 31 Dec 2008 08:40:56 -0700
Message-Id: <1230738056.3470.150.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 18:08 +1100, Dave Chinner wrote:
> On Tue, Dec 30, 2008 at 09:11:04PM -0700, Peter W. Morreale wrote:
> > Actually, it seems to me that we need to look at a radically different
> > approach.  What about making background writes a property of the super
> > block? (which implies the file system)  Has that been discussed before?
> 
> Sure - there was a recent discussion in the context of how broken the
> sync(2) syscall is.
> 
> That is, some filesystems (e.g. XFS) have certain requirements
> to ensure sync actually works in all circumstances and the current
> methods that sync employs make it impossible to sync correctly.
> 
<snip>


Good point, but different. I was thinking merely in terms of the
forthcoming SSD devices and flushing, not syncing.  We are approaching
the point (from hardware...) where persistent storage is becoming
balanced (wrt speed) with RAM.  

This opens up a whole new world for cache considerations.  Consider that
if my persistent storage is as fast as memory, then I want my memory
cache size for that device to be 0 (zero) sized - there is no point.

However, I have a number of different devices on my system, some disk,
some SSD, some optical, etc.  Each has different characteristics, yet we
treat them identically.   

(well, almost identically - we run through the SB list (and
consequently, the devices) in reverse all the time :-)

WIRWTD ("What I Really Want To Do") is to incorporate the
characteristics of the devices into the caching so I can optimize both
my use of cache as well as the particular device(s). 

At the moment, we have two triggers, memory pressure (the dirty_*
tunings) and time (kupdate).  Once these thresholds are reached, we
indiscriminately (wrt devices) begin flushing to achieve the minimum
threshold again.  These are probably the right triggers from a system
perspective, but there are others we could consider as well.  

For example, on a 'slow' device, I probably want to start flushing
sooner, rather than later.  On a fast device, perhaps we wait a bit
longer before starting flushing. 

At the end of the day we are governed by Little's Law, so we have to
optimize the exit from the system. 

In general, we want flushing to reach the minimum dirty threshold as
fast as possible since we are taking cycles away from our applications.
(To me this is far more important than age...)  So, WIRWTD is to create
a heuristic that takes into account:

o Device speed
o nr pages dirty 'owned' by the device.
o nr system dirty pages (e.g. existing dirty stuff)
o age (or do we really care?)
o tunings 

Now we can weight flushing towards 'fast' devices to reach our
thresholds as well as ignore devices that offer little relief (e.g. have
no dirty pages outstanding)  

Perhaps the "cache maintenance responsibility" belongs to the device???

Best,
-PWM





