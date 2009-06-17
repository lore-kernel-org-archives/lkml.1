Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbZFQMTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbZFQMTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765268AbZFQMTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:19:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47369 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbZFQMTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:19:13 -0400
Date: Wed, 17 Jun 2009 13:19:14 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH] profile: Suppress warning about large allocations when
	profile=1 is specified
Message-ID: <20090617121913.GC28529@csn.ul.ie>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org> <20090616223649.719ea378.akpm@linux-foundation.org> <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu> <20090617113534.GA21276@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090617113534.GA21276@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 01:35:34PM +0200, Ingo Molnar wrote:
> and a separate warning popped up on another testbox:
> 
> [    0.000007] ------------[ cut here ]------------
> [    0.000017] WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask+0xfe/0x3fe()
> [    0.000020] Hardware name: 1951A26
> [    0.000022] Modules linked in:
> [    0.000027] Pid: 0, comm: swapper Not tainted 2.6.30-tip #6031
> [    0.000030] Call Trace:
> [    0.000037]  [<c102c1ce>] warn_slowpath_common+0x60/0x77
> [    0.000042]  [<c102c1f2>] warn_slowpath_null+0xd/0x10
> [    0.000046]  [<c107cca0>] __alloc_pages_nodemask+0xfe/0x3fe
> [    0.000052]  [<c10418df>] ? sched_clock_idle_wakeup_event+0x11/0x13
> [    0.000057]  [<c107cfb3>] alloc_pages_node+0x13/0x15
> [    0.000060]  [<c107cfe5>] __get_free_pages+0xe/0x1f
> [    0.000066]  [<c1099aee>] __kmalloc+0x2a/0x10e
> [    0.000070]  [<c1040271>] ? ktime_get+0x19/0x1b
> [    0.000077]  [<c142fdf7>] profile_init+0x47/0x81
> [    0.000084]  [<c16ed71a>] start_kernel+0x1b6/0x2c5
> [    0.000089]  [<c16ed06a>] __init_begin+0x6a/0x6f
> [    0.000099] ---[ end trace 4eaa2a86a8e2da22 ]---
> [    0.000999] Console: colour VGA+ 80x25
> 
> Config attached here too.
> 

Patch as follows

==== CUT HERE ====
profile: Suppress warning about large allocations when profile=1 is specified

When profile= is used, a large buffer is allocated early at boot. This can
be larger than what the page allocator can provide but the caller is able
to handle the situation. A warning is printed when too large an order is
given to the page allocator to indicate the caller might need fixing up
but the caller in this case is all right already. The warning looks
something like

[    0.000007] ------------[ cut here ]------------
[    0.000017] WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask+0xfe/0x3fe()
[    0.000020] Hardware name: 1951A26
[    0.000022] Modules linked in:
[    0.000027] Pid: 0, comm: swapper Not tainted 2.6.30-tip #6031
[    0.000030] Call Trace:
[    0.000037]  [<c102c1ce>] warn_slowpath_common+0x60/0x77
[    0.000042]  [<c102c1f2>] warn_slowpath_null+0xd/0x10
[    0.000046]  [<c107cca0>] __alloc_pages_nodemask+0xfe/0x3fe
[    0.000052]  [<c10418df>] ? sched_clock_idle_wakeup_event+0x11/0x13
[    0.000057]  [<c107cfb3>] alloc_pages_node+0x13/0x15
[    0.000060]  [<c107cfe5>] __get_free_pages+0xe/0x1f
[    0.000066]  [<c1099aee>] __kmalloc+0x2a/0x10e
[    0.000070]  [<c1040271>] ? ktime_get+0x19/0x1b
[    0.000077]  [<c142fdf7>] profile_init+0x47/0x81
[    0.000084]  [<c16ed71a>] start_kernel+0x1b6/0x2c5
[    0.000089]  [<c16ed06a>] __init_begin+0x6a/0x6f
[    0.000099] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000999] Console: colour VGA+ 80x25

This patch suppresses the warning for profile= when the order is too
high for the page allocator to satisfy.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 kernel/profile.c |    5 +++--
 mm/page_alloc.c  |    4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 69911b5..6a1ad37 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -117,11 +117,12 @@ int __ref profile_init(void)
 
 	cpumask_copy(prof_cpu_mask, cpu_possible_mask);
 
-	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
+	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL|__GFP_NOWARN);
 	if (prof_buffer)
 		return 0;
 
-	prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
+	prof_buffer = alloc_pages_exact(buffer_bytes,
+				GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN);
 	if (prof_buffer)
 		return 0;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a5f3c27..005b32d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1740,8 +1740,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * be using allocators in order of preference for an area that is
 	 * too large.
 	 */
-	if (WARN_ON_ONCE(order >= MAX_ORDER))
+	if (order >= MAX_ORDER) {
+		WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
 		return NULL;
+	}
 
 	/*
 	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and
