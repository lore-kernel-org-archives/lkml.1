Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYJ1NUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYJ1NUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 09:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYJ1NUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 09:20:31 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4576 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbYJ1NUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 09:20:30 -0400
Subject: Re: Order 0 page allocation failure under heavy I/O load
From: Miquel van Smoorenburg <mikevs@xs4all.net>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081026225723.GO18495@disturbed>
References: <20081026225723.GO18495@disturbed>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 17:20:00 +0400
Message-Id: <1225200000.6482.4.camel@mikevs-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 09:57 +1100, Dave Chinner wrote:
> I've been running a workload in a UML recently to reproduce a
> problem, and I've been seeing all sorts of latency problems on
> the host. The hosts is running a standard debian kernel:
> 
> $ uname -a
> Linux disturbed 2.6.26-1-amd64 #1 SMP Wed Sep 10 15:31:12 UTC 2008 x86_64 GNU/Linux
> 
> Basically, the workload running in the UML is:
> 
> # fsstress -p 1024 -n 100000 -d /mnt/xfs2/fsstress.dir
> 
> Which runs 1024 fsstress processes inside the indicated directory.
> Being UML, that translates to 1024 processes on the host doing I/O
> to a single file in an XFS filesystem. The problem is that this
> load appears to be triggering OOM on the host. The host filesystem
> is XFS on a 2 disk MD raid0 stripe.
> 
> The host will hang for tens of seconds at a time with both CPU cores
> pegged at 100%, and eventually I get this in dmesg:
> 
> [1304740.261506] linux: page allocation failure. order:0, mode:0x10000
> [1304740.261516] Pid: 10705, comm: linux Tainted: P          2.6.26-1-amd64 #1
> [1304740.261520]
> [1304740.261520] Call Trace:
> [1304740.261557]  [<ffffffff802768db>] __alloc_pages_internal+0x3ab/0x3c4
> [1304740.261574]  [<ffffffff80295248>] kmem_getpages+0x96/0x15f

I saw the same thing, on i386 though. Never saw it on x86_64. For i386
it helped to recompile with the 2G/2G split set. But it appears that my
problem has been solved in 2.6.26.6 by the commit below. Perhaps your
hitting something similar. Your kernel version looks like a debian
version number, and if 2.6.26.6 fixes your problem, please file a debian
bug report so that lenny won't get released with this bug ....

commit 6b546b3dbbc51800bdbd075da923288c6a4fe5af
Author: Mel Gorman <mel@csn.ul.ie>
Date:   Sat Sep 13 22:05:39 2008 +0000

    mm: mark the correct zone as full when scanning zonelists
    
    commit 5bead2a0680687b9576d57c177988e8aa082b922 upstream
    
    The iterator for_each_zone_zonelist() uses a struct zoneref *z cursor when
    scanning zonelists to keep track of where in the zonelist it is.  The
    zoneref that is returned corresponds to the the next zone that is to be
    scanned, not the current one.  It was intended to be treated as an opaque
    list.
    
    When the page allocator is scanning a zonelist, it marks elements in the
    zonelist corresponding to zones that are temporarily full.  As the
    zonelist is being updated, it uses the cursor here;
    
      if (NUMA_BUILD)
            zlc_mark_zone_full(zonelist, z);
    
    This is intended to prevent rescanning in the near future but the zoneref
    cursor does not correspond to the zone that has been found to be full.
    This is an easy misunderstanding to make so this patch corrects the
    problem by changing zoneref cursor to be the current zone being scanned
    instead of the next one.
    
Mike.

