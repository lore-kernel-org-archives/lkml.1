Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZIAMvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZIAMvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZIAMvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:51:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:37748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbZIAMvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:51:08 -0400
Message-ID: <4A9D18B7.3010405@kernel.org>
Date: Tue, 01 Sep 2009 21:51:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Meelis Roos <mroos@linux.ee>
Subject: [GIT PULL] percpu fixes for 2.6.31-rc8
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 01 Sep 2009 12:51:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please consider pulling from the following percpu fixes tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

This branch contains one critical fix for sparc64.  Dynamic percpu
allocator in 2.6.31 tree still assumed that cpu0 always exists which
is not true on certain sparc64 machines.  This leads to malfunction in
the allocator leading to unmapping of used area and then oops.  This
was reported in the following thread.

 http://thread.gmane.org/gmane.linux.ports.sparc/12138

Using raw_smp_processor_id() instead of 0 in two places fixes the
problem.  Devel branch had both (sans raw_ prefix) but the first one
was no longer necessary and dropped.  Both chunk->page[] array and
vmalloc area back pointing which the fix touches are always done for
all possible cpus in unison and what changes is percpu now uses
raw_smp_processor_id() to use any possible one of the cpus instead of
explicit 0.  Given that the changes have been in linux-next for some
time now, I believe these changes to be quite safe.

Thanks.
---
  Tejun Heo (1):
        percpu: don't assume existence of cpu0

 mm/percpu.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 5fe3784..3311c89 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -197,7 +197,12 @@ static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
 static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
 				     int page_idx)
 {
-	return *pcpu_chunk_pagep(chunk, 0, page_idx) != NULL;
+	/*
+	 * Any possible cpu id can be used here, so there's no need to
+	 * worry about preemption or cpu hotplug.
+	 */
+	return *pcpu_chunk_pagep(chunk, raw_smp_processor_id(),
+				 page_idx) != NULL;
 }

 /* set the pointer to a chunk in a page struct */
@@ -297,6 +302,14 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 		return pcpu_first_chunk;
 	}

+	/*
+	 * The address is relative to unit0 which might be unused and
+	 * thus unmapped.  Offset the address to the unit space of the
+	 * current processor before looking it up in the vmalloc
+	 * space.  Note that any possible cpu id can be used here, so
+	 * there's no need to worry about preemption or cpu hotplug.
+	 */
+	addr += raw_smp_processor_id() * pcpu_unit_size;
 	return pcpu_get_page_chunk(vmalloc_to_page(addr));
 }

