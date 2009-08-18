Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbZHRLQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbZHRLQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758737AbZHRLQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:16:07 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50477 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbZHRLQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:16:06 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Linux Memory Management List <linux-mm@kvack.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [RFC PATCH 0/3] Reduce searching in the page allocator fast-path
Date: Tue, 18 Aug 2009 12:15:59 +0100
Message-Id: <1250594162-17322-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches are a revisit of the proposal to remove searching
in the page allocator fast-path by maintaining multiple free-lists in the
per-cpu structure. At the time the search was introduced, increasing the
per-cpu structures would waste a lot of memory as per-cpu structures were
statically allocated at compile-time. This is no longer the case.

These patches have been brought up before but the results as to whether
they helped or not were inconclusive and I was worried about the pcpu drain
path. While the patches in various guises have been ACKd, they were never
merged because the performance results were always shaky. I beefed up the
of the testing methodology and the results indicate either no improvements
or small gains with two exceptionally large gains. I'm marginally happier
with the free path than I was previously.

The patches are as follows. They are based on mmotm-2009-08-12.

Patch 1 adds multiple lists to struct per_cpu_pages, one per
	migratetype that can be stored on the PCP lists.

Patch 2 notes that the pcpu drain path check empty lists multiple times. The
	patch  reduces the number of checks by maintaining a count of free
	lists encountered. Lists containing pages will then free multiple
	pages in batch

Patch 3 notes that the per-cpu structure is larger than it needs to be because
	pcpu->high and batch are read-mostly variables shared by the
	zone. The patch moves those fields to struct zone.

The patches were tested with kernbench, aim9, netperf udp/tcp, hackbench and
sysbench.  The netperf tests were not bound to any CPU in particular and
were run such that the results should be 99% confidence that the reported
results are within 1% of the estimated mean. sysbench was run with a
postgres background and read-only tests. Similar to netperf, it was run
multiple times so that it's 99% confidence results are within 1%. The
patches were tested on x86, x86-64 and ppc64 as

x86:	Intel Pentium D 3GHz with 8G RAM (no-brand machine)
	kernbench	- No significant difference, variance well within noise
	aim9		- 3-6% gain on page_test and brk_test
	netperf-udp	- No significant differences
	netperf-tcp	- Small variances, very close to noise
	hackbench	- Small variances, very close to noise
	sysbench	- Small gains, very close to noise

x86-64:	AMD Phenom 9950 1.3GHz with 8G RAM (no-brand machine)
	kernbench	- No significant difference, variance well within noise
	aim9		- No significant difference
	netperf-udp	- No difference until buffer >= PAGE_SIZE
				4096	+1.39%
				8192	+6.80%
				16384	+9.55%
	netperf-tcp	- No difference until buffer >= PAGE_SIZE
				4096	+14.14%
				8192	+ 0.23% (not significant)
				16384	-12.56%
	hackbench	- Small gains, very close to noise
	sysbench	- Small gains/losses, very close to noise

ppc64:	PPC970MP 2.5GHz with 10GB RAM (it's a terrasoft powerstation)
	kernbench	- No significant difference, variance well within noise
	aim9		- No significant difference
	netperf-udp	- 2-3% gain for almost all buffer sizes tested
	netperf-tcp	- losses on small buffers, gains on larger buffers
			  possibly indicates some bad caching effect. Suspect
			  struct zone could be laid out much better
	hackbench	- Small 1-2% gains
	sysbench	- 5-7% gain

For the most part, performance differences are marginal with some noticeable
exceptions. netperf-udp on x86-64 gained heavily as did sysbench on ppc64. I
suspect the TCP results, particularly for small buffers, point to some
cache line bouncing effect which I haven't pinned down yet.

 include/linux/mmzone.h |   10 ++-
 mm/page_alloc.c        |  162 +++++++++++++++++++++++++++---------------------
 mm/vmstat.c            |    4 +-
 3 files changed, 100 insertions(+), 76 deletions(-)

