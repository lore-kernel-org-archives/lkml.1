Return-Path: <linux-kernel-owner+w=401wt.eu-S1764253AbZLQJlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764253AbZLQJlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764232AbZLQJlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:41:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46887 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZLQJk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:40:59 -0500
Date: Thu, 17 Dec 2009 10:40:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: -tip: origin tree build failure
Message-ID: <20091217094041.GA24708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's -tip fails to build due to upstream commit 
1a9b5b7fe0c5dad8a635288882d36785dea742f9 ("mm: export stable page flags") 
(authored and merged yesterday) causing the following build failure on x86 
when CONFIG_PROC_PAGE_MONITOR is disabled:

 mm/built-in.o: In function `hwpoison_filter':
  (.text+0x39fbf): undefined reference to `stable_page_flags'

The bug is that the stable_page_flags() API is only available under 
CONFIG_PROC_PAGE_MONITOR, but utilized in mm/memory-failure.c unconditionally.

I've applied the patch below to -tip for now, which expresses this dependency 
in the Kconfig. (Eventually a cleaner solution would be to factor such ABI 
details out of procfs, they dont belong there.)

A technical critique: as i pointed it out in the past on lkml, this whole 
ad-hoc exporting of MM details via /proc is ill advised. It's a limiting 
interface for instrumentation (we could do so much more and could integrate it 
so much better with a similar amount of intrusion), and it also creates 
needless ABI dependencies with user-space tooling.

This should be prototyped in debugfs and sufficiently integrated with other 
instrumentation frameworks in the kernel. I made a few suggestions and we even 
wrote patches in the past to help that out:

 3383e37: tracing, page-allocator: Add a postprocessing script for page-allocator-related ftrace events
 c33b359: tracing, page-allocator: Add trace event for page traffic related to the buddy lists
 0d524fb: tracing, mm: Add trace events for anti-fragmentation falling back to other migratetypes
 b9a2817: tracing, page-allocator: Add trace events for page allocation and page freeing
 eb46710: tracing/mm: rename 'trigger' file to 'dump_range'
 1487a7a: tracing/mm: fix mapcount trace record field
 dcac8cd: tracing/mm: add page frame snapshot trace

Unfortunately nothing of that was pursued from the MM and hwpoison side and 
now this inferior version goes upstream, and as two separate ABIs straight 
away. (the /proc ABI and the memory-failure filter ABI) Not very well designed 
and not very helpful IMO, and this will come back to haunt us in the future.

We know how to do this correctly, why not embrace, utilize and expand those 
instrumentation facilities?

Also, a workflow observation - i tried to figure out the history of the bug 
but the Git timestamps show this weirdness:

 commit 1a9b5b7fe0c5dad8a635288882d36785dea742f9
 Author:     Wu Fengguang <fengguang.wu@intel.com>
 AuthorDate: Wed Dec 16 12:19:59 2009 +0100
 Commit:     Andi Kleen <ak@linux.intel.com>
 CommitDate: Wed Dec 16 12:19:59 2009 +0100

that's precisely the same author and commit date, but author and committer are 
different - how is that possible? No combination of git-am, git-rebase and git 
commit --amend can achieve this kind of timestamp.

I checked the other 'HWPOISON' commits as well that were merged yesterday - 
they have a similarly damaged history.

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/mm/Kconfig b/mm/Kconfig
index 43ea8c3..d7bd560 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -243,6 +243,7 @@ config ARCH_SUPPORTS_MEMORY_FAILURE
 config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
+	select PROC_PAGE_MONITOR
 	bool "Enable recovery from hardware memory errors"
 	help
 	  Enables code to recover from some memory failures on systems
