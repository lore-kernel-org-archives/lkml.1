Return-Path: <linux-kernel-owner+w=401wt.eu-S938030AbXHHSa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938030AbXHHSa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762493AbXHHSao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:30:44 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:56098 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760165AbXHHSan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:30:43 -0400
Subject: Re: [PATCH 0/3] Use one zonelist per node instead of multiple
	zonelists v2
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>, pj@sgi.com, ak@suse.de,
       kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0708081025330.12652@schroedinger.engr.sgi.com>
References: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie>
	 <Pine.LNX.4.64.0708081025330.12652@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 08 Aug 2007 14:30:19 -0400
Message-Id: <1186597819.5055.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 10:36 -0700, Christoph Lameter wrote:
> On Wed, 8 Aug 2007, Mel Gorman wrote:
> 
> > These are the range of performance losses/gains I found when running against
> > 2.6.23-rc1-mm2. The set and these machines are a mix of i386, x86_64 and
> > ppc64 both NUMA and non-NUMA.
> > 
> > Total CPU time on Kernbench: -0.20% to  3.70%
> > Elapsed   time on Kernbench: -0.32% to  3.62%
> > page_test from aim9:         -2.17% to 12.42%
> > brk_test  from aim9:         -6.03% to 11.49%
> > fork_test from aim9:         -2.30% to  5.42%
> > exec_test from aim9:         -0.68% to  3.39%
> > Size reduction of pg_dat_t:   0     to  7808 bytes (depends on alignment)
> 
> Looks good.
> 
> > o Remove bind_zonelist() (Patch in progress, very messy right now)
> 
> Will this also allow us to avoid always hitting the first node of an 
> MPOL_BIND first?

An idea:

Apologies if someone already suggested this and I missed it.  Too much
traffic...

instead of passing a zonelist for BIND policy, how about passing [to
__alloc_pages(), I think] a starting node, a nodemask, and gfp flags for
zone and modifiers.  For various policies, the arguments would look like
this:

Policy		start node	nodemask

default		local node	cpuset_current_mems_allowed

preferred	preferred_node	cpuset_current_mems_allowed

interleave	computed node	cpuset_current_mems_allowed

bind		local node	policy nodemask [replaces bind
				zonelist in mempolicy]

Then, just walk the zonelist for the starting node--already ordered by
distance--filtering by gfp_zone() and nodemask.  Done "right", this
should always return memory from the closest allowed node [based on the
nodemask argument] to the starting node.  And, it would eliminate the
custom zonelists for bind policy.  Can also eliminate cpuset checks in
the allocation loop because that constraint would already be applied to
the nodemask argument.

The fast path--when we hit in the target zone on the starting
node--might be faster.  Once we have to start falling back to other
nodes/zones, we've pretty much fallen off the fast path anyway, I think.

Bind policy would suffer a hit when the nodemask does not include the
local node from which the allocation occurs.  I.e., this would always be
a fallback case.

Too backed up to investigate further right now.  

I will add Mel's patches to my test tree, tho'.

Lee

