Return-Path: <linux-kernel-owner+w=401wt.eu-S2992748AbXDYNMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992748AbXDYNMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992739AbXDYNMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:12:40 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34442 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S2992731AbXDYNMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:12:38 -0400
Message-ID: <377506695.54393@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 25 Apr 2007 21:11:33 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] on-demand readahead
Message-ID: <20070425131133.GA26863@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This is a minimal readahead algorithm that aims to replace the current one.
It is more flexible and reliable, while maintaining almost the same behavior
and performance. Also it is full integrated with adaptive readahead.

It is designed to be called on demand:
	- on a missing page, to do synchronous readahead
	- on a lookahead page, to do asynchronous readahead

In this way it eliminated the awkward workarounds for cache hit/miss,
readahead thrashing, retried read, and unaligned read. It also adopts the
data structure introduced by adaptive readahead, parameterizes readahead
pipelining with `lookahead_index', and reduces the current/ahead windows
to one single window.

The patch is made convenient for testing out.
Do a
	# echo 2 > /proc/sys/vm/readahead_ratio
and it is selected.
Do a
	# echo 1 > /proc/sys/vm/readahead_ratio
and the vanilla readahead is selected.

Comments and benchmark numbers are welcome, thank you.


HEURISTICS

The logic deals with four cases:

	- sequential-next
		found a consistent readahead window, so push it forward

	- random
		standalone small read, so read as is

	- sequential-first
		create a new readahead window for a sequential/oversize request

	- lookahead-clueless
		hit a lookahead page not associated with the readahead window,
		so create a new readahead window and ramp it up

In each case, three parameters are determined:

	- readahead index: where the next readahead begins
	- readahead size:  how much to readahead
	- lookahead size:  when to do the next readahead (for pipelining)


BEHAVIORS

The old behaviors are maximally preserved for trivial sequential/random reads.
Notable changes are:

	- It no longer imposes strict sequential checks.
	  It might help some interleaved cases, and clustered random reads.
	  It does introduce risks of a random lookahead hit triggering an
	  unexpected readahead. But in general it is more likely to do good
	  than to do evil.

	- Interleaved reads are supported in a minimal way.
	  Their chances of being detected and proper handled are still low.

	- Readahead thrashings are better handled.
	  The current readahead leads to tiny average I/O sizes, because it
	  never turn back for the thrashed pages.  They have to be fault in
	  by do_generic_mapping_read() one by one.  Whereas the on-demand
	  readahead will redo readahead for them.


OVERHEADS

The new code reduced the overheads of

	- excessively calling the readahead routine on small sized reads
	  (the current readahead code insists on seeing all requests)

	- doing a lot of pointless page-cache lookups for small cached files
	  (the current readahead only turns itself off after 256 cache hits,
	  unfortunately most files are < 1MB, so never see that chance)

That accounts for speedup of
	- 0.3% on 1-page sequential reads on sparse file
	- 1.2% on 1-page cache hot sequential reads
	- 3.2% on 256-page cache hot sequential reads
	- 1.3% on cache hot `tar /lib`

However, it does introduce one extra page-cache lookup per cache miss, which
impacts random reads slightly. That's 1% overheads for 1-page random reads on
sparse file.


PERFORMANCE

The basic benchmark setup is
	- 2.6.20 kernel with on-demand readahead
	- 1MB max readahead size
	- 2.9GHz Intel Core 2 CPU
	- 2GB memory
	- 160G/8M Hitachi SATA II 7200 RPM disk

The benchmarks show that
	- it maintains the same performance for trivial sequential/random reads
	- sysbench/OLTP performance on MySQL gains up to 8%
	- performance on readahead thrashing gains up to 3 times


iozone throughput (KB/s): roughly the same
==========================================
iozone -c -t1 -s 4096m -r 64k

			       2.6.20          on-demand      gain
first run
	  "  Initial write "   61437.27        64521.53      +5.0%
	  "        Rewrite "   47893.02        48335.20      +0.9%
	  "           Read "   62111.84        62141.49      +0.0%
	  "        Re-read "   62242.66        62193.17      -0.1%
	  "   Reverse Read "   50031.46        49989.79      -0.1%
	  "    Stride read "    8657.61         8652.81      -0.1%
	  "    Random read "   13914.28        13898.23      -0.1%
	  " Mixed workload "   19069.27        19033.32      -0.2%
	  "   Random write "   14849.80        14104.38      -5.0%
	  "         Pwrite "   62955.30        65701.57      +4.4%
	  "          Pread "   62209.99        62256.26      +0.1%

second run
	  "  Initial write "   60810.31        66258.69      +9.0%
	  "        Rewrite "   49373.89        57833.66     +17.1%
	  "           Read "   62059.39        62251.28      +0.3%
	  "        Re-read "   62264.32        62256.82      -0.0%
	  "   Reverse Read "   49970.96        50565.72      +1.2%
	  "    Stride read "    8654.81         8638.45      -0.2%
	  "    Random read "   13901.44        13949.91      +0.3%
	  " Mixed workload "   19041.32        19092.04      +0.3%
	  "   Random write "   14019.99        14161.72      +1.0%
	  "         Pwrite "   64121.67        68224.17      +6.4%
	  "          Pread "   62225.08        62274.28      +0.1%

In summary, writes are unstable, reads are pretty close on average:

			  access pattern  2.6.20  on-demand   gain
				   Read  62085.61  62196.38  +0.2%
				Re-read  62253.49  62224.99  -0.0%
			   Reverse Read  50001.21  50277.75  +0.6%
			    Stride read   8656.21   8645.63  -0.1%
			    Random read  13907.86  13924.07  +0.1%
	 		 Mixed workload  19055.29  19062.68  +0.0%
				  Pread  62217.53  62265.27  +0.1%


aio-stress: roughly the same
============================
aio-stress -l -s4096 -r128 -t1 -o1 knoppix511-dvd-cn.iso
aio-stress -l -s4096 -r128 -t1 -o3 knoppix511-dvd-cn.iso

					2.6.20      on-demand  delta
			sequential	 92.57s      92.54s    -0.0%
			random		311.87s     312.15s    +0.1%


sysbench fileio: roughly the same
=================================
sysbench --test=fileio --file-io-mode=async --file-test-mode=rndrw \
	 --file-total-size=4G --file-block-size=64K \
	 --num-threads=001 --max-requests=10000 --max-time=900 run

				threads    2.6.20   on-demand    delta
		first run
				      1   59.1974s    59.2262s  +0.0%
				      2   58.0575s    58.2269s  +0.3%
				      4   48.0545s    47.1164s  -2.0%
				      8   41.0684s    41.2229s  +0.4%
				     16   35.8817s    36.4448s  +1.6%
				     32   32.6614s    32.8240s  +0.5%
				     64   23.7601s    24.1481s  +1.6%
				    128   24.3719s    23.8225s  -2.3%
				    256   23.2366s    22.0488s  -5.1%

		second run
				      1   59.6720s    59.5671s  -0.2%
				      8   41.5158s    41.9541s  +1.1%
				     64   25.0200s    23.9634s  -4.2%
				    256   22.5491s    20.9486s  -7.1%

Note that the numbers are not very stable because of the writes.
The overall performance is close when we sum all seconds up:

                sum all up               495.046s    491.514s   -0.7%


sysbench oltp (trans/sec): up to 8% gain
========================================
sysbench --test=oltp --oltp-table-size=10000000 --oltp-read-only \
	 --mysql-socket=/var/run/mysqld/mysqld.sock \
	 --mysql-user=root --mysql-password=readahead \
	 --num-threads=064 --max-requests=10000 --max-time=900 run

	10000-transactions run
				threads    2.6.20   on-demand    gain
				      1     62.81       64.56   +2.8%
				      2     67.97       70.93   +4.4%
				      4     81.81       85.87   +5.0%
				      8     94.60       97.89   +3.5%
				     16     99.07      104.68   +5.7%
				     32     95.93      104.28   +8.7%
				     64     96.48      103.68   +7.5%
	5000-transactions run
				      1     48.21       48.65   +0.9%
				      8     68.60       70.19   +2.3%
				     64     70.57       74.72   +5.9%
	2000-transactions run
				      1     37.57       38.04   +1.3%
				      2     38.43       38.99   +1.5%
				      4     45.39       46.45   +2.3%
				      8     51.64       52.36   +1.4%
				     16     54.39       55.18   +1.5%
				     32     52.13       54.49   +4.5%
				     64     54.13       54.61   +0.9%

That's interesting results. Some investigations show that
	- MySQL is accessing the db file non-uniformly: some parts are
	  more hot than others
	- It is mostly doing 4-page random reads, and sometimes doing two
	  reads in a row, the latter one triggers a 16-page readahead.
	- The on-demand readahead leaves many lookahead pages (flagged
	  PG_readahead) there. Many of them will be hit, and trigger
	  more readahead pages. Which might save more seeks.
	- Naturally, the readahead windows tend to lie in hot areas,
	  and the lookahead pages in hot areas is more likely to be hit.
	- The more overall read density, the more possible gain.

That also explains the adaptive readahead tricks for clustered random reads.


readahead thrashing: 3 times better
===================================
We boot kernel with "mem=128m single", and start a 100KB/s stream on every
second, until reaching 200 streams.

			      max throughput     min avg I/O size
		2.6.20:            5MB/s               16KB
		on-demand:        15MB/s              140KB

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/filemap.c   |   11 +++--
 mm/readahead.c |  101 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 105 insertions(+), 7 deletions(-)

--- linux-2.6.21-rc7-mm1.orig/mm/readahead.c
+++ linux-2.6.21-rc7-mm1/mm/readahead.c
@@ -733,6 +733,11 @@ unsigned long max_sane_readahead(unsigne
 
 #ifdef CONFIG_ADAPTIVE_READAHEAD
 
+static int prefer_ondemand_readahead(void)
+{
+	return readahead_ratio == 2;
+}
+
 /*
  * Move pages in danger (of thrashing) to the head of inactive_list.
  * Not expected to happen frequently.
@@ -1608,6 +1613,92 @@ thrashing_recovery_readahead(struct addr
 	return ra_submit(ra, mapping, filp);
 }
 
+/*
+ *  Get the previous window size, ramp it up, and
+ *  return it as the new window size.
+ */
+static inline unsigned long get_next_ra_size2(struct file_ra_state *ra,
+						unsigned long max)
+{
+	unsigned long cur = ra->readahead_index - ra->ra_index;
+	unsigned long newsize;
+
+        if (cur < max / 16) {
+                newsize = 4 * cur;
+        } else {
+                newsize = 2 * cur;
+        }
+
+	return min(newsize, max);
+}
+
+/*
+ * On-demand readahead.
+ * A minimal readahead algorithm for trivial sequential/random reads.
+ */
+unsigned long
+ondemand_readahead(struct address_space *mapping,
+		   struct file_ra_state *ra, struct file *filp,
+		   struct page *page, pgoff_t offset,
+		   unsigned long req_size, unsigned long max)
+{
+	pgoff_t ra_index;	/* readahead index */
+	unsigned long ra_size;	/* readahead size */
+	unsigned long la_size;	/* lookahead size */
+	int sequential;
+
+	sequential = (offset - ra->prev_page <= 1UL) || (req_size > max);
+
+	/*
+	 * Lookahead/readahead hit, assume sequential access.
+	 * Ramp up sizes, and push forward the readahead window.
+	 */
+	if (offset && (offset == ra->lookahead_index ||
+			offset == ra->readahead_index)) {
+		ra_index = ra->readahead_index;
+		ra_size = get_next_ra_size2(ra, max);
+		la_size = ra_size;
+		goto fill_ra;
+	}
+
+	/*
+	 * Standalone, small read.
+	 * Read as is, and do not pollute the readahead state.
+	 */
+	if (!page && !sequential) {
+		return __do_page_cache_readahead(mapping, filp,
+						offset, req_size, 0);
+	}
+
+	/*
+	 * It may be one of
+	 * 	- first read on start of file
+	 * 	- sequential cache miss
+	 * 	- oversize random read
+	 * Start readahead for it.
+	 */
+	ra_index = offset;
+	ra_size = get_init_ra_size(req_size, max);
+	la_size = ra_size > req_size ? ra_size - req_size : ra_size;
+
+	/*
+	 * Hit on a lookahead page without valid readahead state.
+	 * E.g. interleaved reads.
+	 * Not knowing its readahead pos/size, bet on the minimal possible one.
+	 */
+	if (page) {
+		ra_index++;
+		ra_size = min(4 * ra_size, max);
+	}
+
+fill_ra:
+	ra_set_index(ra, offset, ra_index);
+	ra_set_size(ra, ra_size, la_size);
+	ra_set_class(ra, RA_CLASS_NONE);
+
+	return ra_submit(ra, mapping, filp);
+}
+
 /**
  * page_cache_readahead_adaptive - thrashing safe adaptive read-ahead
  * @mapping, @ra, @filp, @offset, @req_size: the same as page_cache_readahead()
@@ -1675,6 +1766,11 @@ page_cache_readahead_adaptive(struct add
 	if (!page && (ra->flags & RA_FLAG_NFSD))
 		goto readit;
 
+	/* on-demand read-ahead */
+	if (prefer_ondemand_readahead())
+		return ondemand_readahead(mapping, ra, filp, page,
+					  offset, req_size, ra_max);
+
 	/*
 	 * Start of file.
 	 */
@@ -1684,14 +1780,13 @@ page_cache_readahead_adaptive(struct add
 	/*
 	 * Recover from possible thrashing.
 	 */
-	if (!page && offset - ra->prev_index <= 1 && ra_has_index(ra, offset))
+	if (!page && ra_has_index(ra, offset))
 		return thrashing_recovery_readahead(mapping, filp, ra, offset);
 
 	/*
 	 * State based sequential read-ahead.
 	 */
-	if (offset == ra->prev_index + 1 &&
-	    offset == ra->lookahead_index &&
+	if (offset == ra->lookahead_index &&
 					!debug_option(disable_clock_readahead))
 		return clock_based_readahead(mapping, filp, ra, page,
 						offset, req_size, ra_max);
--- linux-2.6.21-rc7-mm1.orig/mm/filemap.c
+++ linux-2.6.21-rc7-mm1/mm/filemap.c
@@ -946,13 +946,16 @@ void do_generic_mapping_read(struct addr
 find_page:
 		page = find_get_page(mapping, index);
 		if (prefer_adaptive_readahead()) {
-			if (!page || PageReadahead(page)) {
-				ra.prev_index = prev_index;
+			if (!page) {
+				page_cache_readahead_adaptive(mapping,
+						&ra, filp, page,
+						index, last_index - index);
+				page = find_get_page(mapping, index);
+			}
+			if (page && PageReadahead(page)) {
 				page_cache_readahead_adaptive(mapping,
 						&ra, filp, page,
 						index, last_index - index);
-				if (!page)
-					page = find_get_page(mapping, index);
 			}
 		}
 		if (unlikely(page == NULL)) {

