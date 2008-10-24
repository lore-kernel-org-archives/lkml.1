Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYJXUBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYJXUBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYJXUB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:01:27 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39329 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYJXUB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:01:27 -0400
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 16:01:27 EDT
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type;
	b=piFC06JNi2fJ3aIi7dzrtCB4OEZ2V1gSBOXnaDmFc/mTDw85RS6afD3StSoNgDH+4
	NEZULME3UuRarm6McdnMw==
Date: Fri, 24 Oct 2008 12:42:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org
Subject: [patch] cpusets: update mems allowed in page allocator
Message-ID: <alpine.DEB.1.10.0810241241520.10168@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If all allowable memory is unreclaimable, it is possible to loop forever
in the page allocator for ~__GFP_NORETRY allocations.

During this time, it is also possible for a task's cpuset to expand its
set of allowable nodes so that it now includes free memory.  The cached
copy of this set, current->mems_allowed, is stale, however, since there
has not been a subsequent call to cpuset_update_task_memory_state().

The cached copy of the set of allowable nodes is now updated in the page
allocator's slow path so the additional memory is available to
get_page_from_freelist().

Cc: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1547,6 +1547,7 @@ nofail_alloc:
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
+	cpuset_update_task_memory_state();
 	p->flags |= PF_MEMALLOC;
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
