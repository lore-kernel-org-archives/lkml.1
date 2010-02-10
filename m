Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0BJQca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:32:30 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6321 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab0BJQcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:32:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=p5kAJSg8eWfbnarzonlr7w3wg+9l6sNmeA7nZk7fz2Ti5fi81bQIqf4qLr7MwHoX3
	h0BI2hGFj5q8O13gbVGvQ==
Date: Wed, 10 Feb 2010 08:32:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 6/7 -mm] oom: avoid oom killer for lowmem allocations
In-Reply-To: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1002100229410.8001@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If memory has been depleted in lowmem zones even with the protection
afforded to it by /proc/sys/vm/lowmem_reserve_ratio, it is unlikely that
killing current users will help.  The memory is either reclaimable (or
migratable) already, in which case we should not invoke the oom killer at
all, or it is pinned by an application for I/O.  Killing such an
application may leave the hardware in an unspecified state and there is
no guarantee that it will be able to make a timely exit.

Lowmem allocations are now failed in oom conditions so that the task can
perhaps recover or try again later.  Killing current is an unnecessary
result for simply making a GFP_DMA or GFP_DMA32 page allocation and no
lowmem allocations use the now-deprecated __GFP_NOFAIL bit so retrying is
unnecessary.

Previously, the heuristic provided some protection for those tasks with 
CAP_SYS_RAWIO, but this is no longer necessary since we will not be
killing tasks for the purposes of ISA allocations.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1914,6 +1914,9 @@ rebalance:
 	 * running out of options and have to consider going OOM
 	 */
 	if (!did_some_progress) {
+		/* The oom killer won't necessarily free lowmem */
+		if (high_zoneidx < ZONE_NORMAL)
+			goto nopage;
 		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
 			if (oom_killer_disabled)
 				goto nopage;
