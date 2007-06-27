Return-Path: <linux-kernel-owner+w=401wt.eu-S1760498AbXF0MpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498AbXF0MpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbXF0Mo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:44:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49252 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756072AbXF0Mo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:44:58 -0400
Date: Wed, 27 Jun 2007 05:44:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@google.com>
cc: Ethan Solomita <solo@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
In-Reply-To: <20070627021408.493812fe.akpm@google.com>
Message-ID: <Pine.LNX.4.64.0706270527010.26731@schroedinger.engr.sgi.com>
References: <465FB6CF.4090801@google.com> <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>
 <46646A33.6090107@google.com> <Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com>
 <468023CA.2090401@google.com> <Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com>
 <20070626152204.b6b4bc3f.akpm@google.com> <Pine.LNX.4.64.0706262017260.24504@schroedinger.engr.sgi.com>
 <20070627021408.493812fe.akpm@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Andrew Morton wrote:

> I'm more concerned about all of Mel's code in -mm actually.  I don't recall
> anyone doing a full review recently and I'm still not sure that this is the
> overall direction in which we wish to go.  Last time I asked this everyone
> seemed a bit waffly and non-committal.

I have looked over this several times lately and it all seems quite okay. 
Still cannot find a justification for the movable zone (never had to 
use it in testing) but it seems that it makes memory unplug easier. The 
antifrag patchset together with a page migration patch simplifies the 
unplug patchset significantly.

I think the antifrag code is a significant step forward and will enable 
lots of other features (memory unplug, larger page use in SLUB, huge page 
allocs after boot). It may be useful to put memory compaction and memory 
unplug in at the same time (I think we can get there even for .23) so that 
we have a full package. With compaction we can finally recover from loads 
that typically cause memory to be split in a lot of disjoint pieces and 
get to a sitaution were we can dynamically reconfigure the number of huge 
pages at run time (Our customers currently reboot to do this which is a 
pain). Compaction increases the chance of I/O controllers being able to 
merge I/O requests since contiguous pages can be served by the page 
allocator again. Antifrag almost gets there but I can still construct 
allocation scenarios that fragment memory significantly.

Also compaction is a requirement if we ever want to support larger 
blocksizes. That would allow the removal of various layers that are now 
needed to compensate for not supporting larger pages.

The whole approach is useful to increase performance. We have seen 
several percentage points of performance wins with SLUB when allowing 
larger pages sizes. The use of huge pages is also mainly done for 
performance reasons. The large blocksize patch has shown a 50% performance 
increase even in its prototype form where we certainly have not solved 
server performance issues.

Even without large blocksize: The ability to restore the capability of the 
page allocator to serve pages that are in sequence can be used to shorten
the scatter gather lists in the I/O layer speeding up I/O.

I think this is an important contribution that will move a lot of other 
issues forward.

