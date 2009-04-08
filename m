Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZDIAAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZDIAAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbZDHX7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:59:52 -0400
Received: from bld-mail05.adl2.internode.on.net ([203.16.214.69]:56271 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757403AbZDHX7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:59:50 -0400
X-Greylist: delayed 927 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2009 19:59:49 EDT
Date: Thu, 9 Apr 2009 09:44:08 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ak@linux.intel.com, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
Message-ID: <20090408234408.GA16929@discord.disaster>
References: <20090324150517.GX27476@kernel.dk> <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com> <20090325152751.GV27476@kernel.dk> <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com> <20090326084205.GG27476@kernel.dk> <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com> <20090331104933.GJ5178@kernel.dk> <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com> <20090403081131.GP5178@kernel.dk> <Pine.LNX.4.64.0904080855340.28196@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904080855340.28196@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 09:37:56AM -0400, Mikulas Patocka wrote:
> The used trick is basically to take a lock that prevents filesystem-wide 
> updates, submit remaining writes (don't wait), submit the barrier that 
> causes transition to new generation (don't wait) and release the lock. The 
> lock is held for minimum time, no IO is waited for inside the lock. This 
> trick can't be done without barriers, without barriers you'd have to wait 
> inside the lock.

Woo! You just described the technique XFS uses to guarantee
ordering of metadata and log IO (i.e. asynchronous barriers). ;)

> AFAIK this is the only piece of code that uses barriers to improve 
> performance. All the other filesystems use barriers just as a way to flush 
> cache and don't overlap barrier request with any other requests.

The problem is, disks often slow down when you issue barriers. It
doesn't matter what purpose you are using barriers for, they change
the order in which the disk would retire the I/O and hence that
changes performance. Issue enough barriers and performance will
drop noticably.

In the case of XFS, we need to guarantee ordering of every single
log write w.r.t. metadata writeback. Hence barriers are issued
relatively frequently (several a second) and so disks operate at
spindle speed rather than cache speed.  It is the frequency of
barrier IO that slows XFS down, not the way they are implemented.
Your technique will show exactly the same behaviour if you issue
barriers frequently enough.

Cheers,

Dave.
-- 
Dave Chinner
dgc@evostor.com
