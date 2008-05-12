Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbYELTVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbYELTVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbYELTUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:20:37 -0400
Received: from 66-189-124-104.dhcp.oxfr.ma.charter.com ([66.189.124.104]:58181
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751317AbYELTUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:20:34 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 0/3] sched: core balancer
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org
Date: Mon, 12 May 2008 14:14:00 -0400
Message-ID: <20080512181248.5257.74801.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter, Srivatsa,

The following series is an RFC for some code I wrote in conjunction with
some rt/cfs load-balancing enhancements.  The enhancements arent quite
ready to see the light of day yet, but this particular fix is ready for
comment.  It applies to sched-devel.

This series addresses a problem that I discovered while working on the rt/cfs
load-balancer, but it appears it could affect upstream too (though its much
less likely to ever occur).

Patches 1&2 move the existing balancer data into a "sched_balancer" container
called "group_balancer".  Patch #3 then adds a new type of balancer called a
"core balancer".

Here is the problem statement (also included in Documentation/scheduler):

	Core Balancing
	----------------------
	
	The standard group_balancer manages SCHED_OTHER tasks based on a
	hierarchy of sched_domains and sched_groups as dictated by the
	physical cache/node topology of the hardware.  Each group may contain
	one or more cores which have a specific relationship to other members
	of the group. Balancing is always performed on an inter-group basis.
	
	For example, consider a quad-core, dual socket Intel Xeon system.  It
	has a total of 8 cores across one logical NUMA node, with a cache
	shared between cores [0,2], [1,3], [4,6], [5,7].  From a
	sched_domain/group perspective on core 0, this looks like the
	following: 
	
	domain-0: (MC)
	  span: 0x5
	  groups = 2 -> [0], [2]
	  domain-1: (SMP)
	    span: 0xff
	    groups = 4 -> [0,2], [1,3], [4,6], [5,7]
	    domain-2: (NUMA)
	      span: 0xff
	      groups = 1 -> [0-7]
	
	Recall that balancing is always inter-group, and will get more
	aggressive in the lower domains than the higher ones.  The balancing
	logic will attempt to balance between [0],[2] first, [0,2], [1,3],
	[4,6], [5,7] second, and [0-7] last.  Note that since domain-2 only
	consists of 1 group, it will never result in a balance decision since
	there must be at least two groups to consider.
	
	This layout is quite logical.  The idea is that [0], and [2] can
	balance between each other aggresively in a very efficient manner
	since they share a cache.  Once the load is equalized between two
	cache-peers, domain-1 can spread the load out between the other
	peer-groups.  This represents a pretty good way to structure the
	balancing operations.
	
	However, there is one slight problem with the group_balancer: Since we
	always balance inter-group, intra-group imbalances may result in
	suboptimal behavior if we hit the condition where lower-level domains
	(domain-0 in this example) are ineffective.  This condition can arise
	whenever a domain-level imbalance cannot be resolved such that the
	group has a high aggregate load rating, yet some cores are relatively
	idle. 
	
	For example, if a core has a large but affined load, or otherwise
	untouchable tasks (e.g. RT tasks), SCHED_OTHER will not be able to
	equalize the load.  The net result is that one or more members of the
	group may remain relatively unloaded, while the load rating for the
	entire group is high.  The higher layer domains will only consider the
	group as a whole, and the lower level domains are left powerless to
	equalize the vacuum.
	
	To address this concern, core_balancer adds the concept of a new
	grouping of cores at each domain-level: a per-core grouping (each core
	in its own unique group).  This "core_balancer" group is configured to
	run much less aggressively than its topologically relevant brother:
	"group_balancer". Core_balancer will sweep through the cores every so
	often, correcting intra-group vacuums left over from lower level
	domains.  In most cases, the group_balancer should have already
	established equilibrium, therefore benefiting from the hardwares
	natural affinity hierarchy.  In the cases where it cannot achieve
	equilibrium, the core_balancer tries to take it one step closer.
	
	By default, group_balancer runs at sd->min_interval, whereas
	core_balancer starts at sd->max_interval (both of which will respond
	to dynamic programming).  Both will employ a multiplicative backoff
	algorithm when faced with repeated migration failure.

---

Regards,
-Greg


