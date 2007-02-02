Return-Path: <linux-kernel-owner+w=401wt.eu-S1423118AbXBBF3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423118AbXBBF3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 00:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423119AbXBBF3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 00:29:16 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:45866 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423118AbXBBF3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 00:29:15 -0500
Date: Thu, 1 Feb 2007 21:29:06 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ethan Solomita <solo@google.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
In-Reply-To: <20070201200358.89dd2991.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0702012044090.10575@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
 <45C2960B.9070907@google.com> <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
 <20070201200358.89dd2991.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007, Andrew Morton wrote:

> > Peter Zilkstra addressed the NFS issue.
> 
> Did he?  Are you yet in a position to confirm that?

He provided a solution to fix the congestion issue in NFS. I thought 
that is what you were looking for? That should make NFS behave more
like a block device right?

As I said before I think NFS is inherently unfixable given the layering of 
a block device on top of the network stack (which consists of an unknown 
number of additional intermediate layers). Cpuset writeback needs to work 
in the same way as in a machine without cpusets. If fails then at least 
let the cpuset behave as if we had a machine all on our own and fail in 
both cases in the same way. Right now we create dangerous low memory 
conditions due to high dirty ratios in a cpuset created by not having a 
throttling method. The NFS problems also exist for non cpuset scenarios 
and we have by and large been able to live with it so I think they are 
lower priority. It seems that the basic problem is created by the dirty 
ratios in a cpuset.

BTW the block layer also may be layered with raid and stuff and then we 
have similar issues. There is no general way so far of handling these 
situations except by twiddling around with min_free_kbytes praying 5 Hail 
Mary's and trying again. Maybe we are able allocate all needed memory from 
PF_MEMALLOC processes during reclaim and hopefully there is now enough 
memory for these allocations and those that happen to occur during an 
interrupt while we reclaim.
