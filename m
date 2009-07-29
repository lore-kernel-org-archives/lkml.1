Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZG2VFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZG2VFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZG2VFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:05:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47414 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZG2VFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:05:53 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Larry Woodman <lwoodman@redhat.com>, riel@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: [RFC PATCH 0/4] Add some trace events for the page allocator v2
Date: Wed, 29 Jul 2009 22:05:47 +0100
Message-Id: <1248901551-7072-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this version, I switched the CC list to match who Larry Woodman mailed
for his "mm tracepoints" patch which I wasn't previously aware of. In this
version, I brought the naming scheme more in line with Larry's as his naming
scheme was very sensible.

This patchset only considers the page-allocator-related events instead of the
much more comprehensive approach Larry took. I included a post-processing
script as Andrew's main complaint as I saw it with Larry's work was a lack
of tools that could give a higher-level view of what was going on. If this
works out, the other mm tracepoints can be deal with in piecemeal chunks.

Changelog since V1
  o Fix minor formatting error for the __rmqueue event
  o Add event for __pagevec_free
  o Bring naming more in line with Larry Woodman's tracing patch
  o Add an example post-processing script for the trace events

The following four patches add some trace events for the page allocator
under the heading of kmem (pagealloc heading instead?).

	Patch 1 adds events for plain old allocate and freeing of pages
	Patch 2 gives information useful for analysing fragmentation avoidance
	Patch 3 tracks pages going to and from the buddy lists as an indirect
		indication of zone lock hotness
	Patch 4 adds a post-processing script that aggegates the events to
		give a higher-level view

The first one could be used as an indicator as to whether the workload was
heavily dependant on the page allocator or not. You can make a guess based
on vmstat but you can't get a per-process breakdown. Depending on the call
path, the call_site for page allocation may be __get_free_pages() instead
of a useful callsite. Instead of passing down a return address similar to
slab debugging, the user should enable the stacktrace and seg-addr options
to get a proper stack trace.

The second patch would mainly be useful for users of hugepages and
particularly dynamic hugepage pool resizing as it could be used to tune
min_free_kbytes to a level that fragmentation was rarely a problem. My
main concern is that maybe I'm trying to jam too much into the TP_printk
that could be extrapolated after the fact if you were familiar with the
implementation. I couldn't determine if it was best to hold the hand of
the administrator even if it cost more to figure it out.

The third patch is trickier to draw conclusions from but high activity on
those events could explain why there were a large number of cache misses
on a page-allocator-intensive workload. The coalescing and splitting of
buddies involves a lot of writing of page metadata and cache line bounces
not to mention the acquisition of an interrupt-safe lock necessary to enter
this path.

The fourth patch parses the trace buffer to draw a higher-level picture of
what is going on broken down on a per-process basis.

All comments indicating whether this is generally useful and how it might
be improved are welcome.

