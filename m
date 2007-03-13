Return-Path: <linux-kernel-owner+w=401wt.eu-S1030802AbXCMRFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030802AbXCMRFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030804AbXCMRFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:05:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35974 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030802AbXCMRFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:05:41 -0400
Subject: Re: [RFC][PATCH 2/7] RSS controller core
From: Dave Hansen <hansendc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill Korotaev <dev@sw.ru>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Mel Gorman <MELGOR@ie.ibm.com>,
       Andy Wihitcroft <apw@shadowen.org>
In-Reply-To: <20070313034834.14013bb0.akpm@linux-foundation.org>
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	 <20070306140036.4e85bd2f.akpm@linux-foundation.org>
	 <45F3F581.9030503@sw.ru>
	 <20070311045111.62d3e9f9.akpm@linux-foundation.org>
	 <20070312010039.GC21861@MAIL.13thfloor.at>
	 <1173724979.11945.103.camel@localhost.localdomain>
	 <20070312224129.GC21258@MAIL.13thfloor.at>
	 <20070312220439.677b4787.akpm@linux-foundation.org>
	 <45F67AC9.4080707@sw.ru>
	 <20070313034834.14013bb0.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 10:05:33 -0700
Message-Id: <1173805534.6680.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 03:48 -0800, Andrew Morton wrote: 
> If we use a physical zone-based containment scheme: fake-numa,
> variable-sized zones, etc then it all becomes moot.  You set up a container
> which has 1.5GB of physial memory then toss processes into it.  As that
> process set increases in size it will toss out stray pages which shouldn't
> be there, then it will start reclaiming and swapping out its own pages and
> eventually it'll get an oom-killing.

I was just reading through the (comprehensive) thread about this from
last week, so forgive me if I missed some of it.  The idea is really
tempting, precisely because I don't think anyone really wants to have to
screw with the reclaim logic.  

I'm just brain-dumping here, hoping that somebody has already thought
through some of this stuff.  It's not a bitch-fest, I promise. :)

How do we determine what is shared, and goes into the shared zones?
Once we've allocated a page, it's too late because we already picked.
Do we just assume all page cache is shared?  Base it on filesystem,
mount, ...?  Mount seems the most logical to me, that a sysadmin would
have to set up a container's fs, anyway, and will likely be doing
special things to shared data, anyway (r/o bind mounts :).

There's a conflict between the resize granularity of the zones, and the
storage space their lookup consumes.  We'd want a container to have a
limited ability to fill up memory with stuff like the dcache, so we'd
appear to need to put the dentries inside the software zone.  But, that
gets us to our inability to evict arbitrary dentries.  After a while,
would containers tend to pin an otherwise empty zone into place?  We
could resize it, but what is the cost of keeping zones that can be
resized down to a small enough size that we don't mind keeping it there?
We could merge those "orphaned" zones back into the shared zone. Were
there any requirements about physical contiguity?  What about minimum
zone sizes?

If we really do bind a set of processes strongly to a set of memory on a
set of nodes, then those really do become its home NUMA nodes.  If the
CPUs there get overloaded, running it elsewhere will continue to grab
pages from the home.  Would this basically keep us from ever being able
to move tasks around a NUMA system?

-- Dave

