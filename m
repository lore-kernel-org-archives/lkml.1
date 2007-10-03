Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbXJCJdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbXJCJdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXJCJdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:33:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43966 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbXJCJdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:33:23 -0400
Subject: [PATCH] lockstat: documentation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20071002084239.7371820c.randy.dunlap@oracle.com>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <20070927235034.ae7bd73d.akpm@linux-foundation.org>
	 <1190998853.6702.17.camel@heimdal.trondhjem.org>
	 <20070928114930.2c201324.akpm@linux-foundation.org>
	 <1191005339.18147.89.camel@lappy>
	 <20070928121642.56a380ce.akpm@linux-foundation.org>
	 <1191332161.13204.70.camel@twins>
	 <20071002084239.7371820c.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 11:28:08 +0200
Message-Id: <1191403688.5572.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Randy!

update patch below.

---
Subject: lockstat: documentation

Provide some documentation for CONFIG_LOCK_STAT

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/lockstat.txt |  120 +++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug          |    2 
 2 files changed, 122 insertions(+)

Index: linux-2.6/Documentation/lockstat.txt
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/lockstat.txt
@@ -0,0 +1,120 @@
+
+LOCK STATISTICS
+
+- WHAT
+
+As the name suggests, it provides statistics on locks.
+
+- WHY
+
+Because things like lock contention can severely impact performance.
+
+- HOW
+
+Lockdep already has hooks in the lock functions and maps lock instances to
+lock classes. We build on that. The graph below shows the relation between
+the lock functions and the various hooks therein.
+
+        __acquire
+            |
+           lock _____
+            |        \
+            |    __contended
+            |         |
+            |       <wait>
+            | _______/
+            |/
+            |
+       __acquired
+            |
+            .
+          <hold>
+            .
+            |
+       __release
+            |
+         unlock
+
+lock, unlock	- the regular lock functions
+__*		- the hooks
+<> 		- states
+
+With these hooks we provide the following statistics:
+
+ con-bounces       - number of lock contention that involved x-cpu data
+ contentions       - number of lock acquisitions that had to wait
+ wait time min     - shortest (non-0) time we ever had to wait for a lock
+           max     - longest time we ever had to wait for a lock
+           total   - total time we spend waiting on this lock
+ acq-bounces       - number of lock acquisitions that involved x-cpu data
+ acquisitions      - number of times we took the lock
+ hold time min     - shortest (non-0) time we ever held the lock
+           max     - longest time we ever held the lock
+           total   - total time this lock was held
+
+From these number various other statistics can be derived, such as:
+
+ hold time average = hold time total / acquisitions
+
+These numbers are gathered per lock class, per read/write state (when
+applicable).
+
+It also tracks 4 contention points per class. A contention point is a call site
+that had to wait on lock acquisition.
+
+ - USAGE
+
+Look at the current lock statistics:
+
+( line numbers not part of actual output, done for clarity in the explanation
+  below )
+
+# less /proc/lock_stat
+
+01 lock_stat version 0.2
+02 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+03                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
+04 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+05
+06               &inode->i_data.tree_lock-W:            15          21657           0.18     1093295.30 11547131054.85             58          10415           0.16          87.51        6387.60
+07               &inode->i_data.tree_lock-R:             0              0           0.00           0.00           0.00          23302         231198           0.25           8.45       98023.38
+08               --------------------------
+09                 &inode->i_data.tree_lock              0          [<ffffffff8027c08f>] add_to_page_cache+0x5f/0x190
+10
+11 ...............................................................................................................................................................................................
+12
+13                              dcache_lock:          1037           1161           0.38          45.32         774.51           6611         243371           0.15         306.48       77387.24
+14                              -----------
+15                              dcache_lock            180          [<ffffffff802c0d7e>] sys_getcwd+0x11e/0x230
+16                              dcache_lock            165          [<ffffffff802c002a>] d_alloc+0x15a/0x210
+17                              dcache_lock             33          [<ffffffff8035818d>] _atomic_dec_and_lock+0x4d/0x70
+18                              dcache_lock              1          [<ffffffff802beef8>] shrink_dcache_parent+0x18/0x130
+
+This excerpt shows the first two lock class statistics. Line 01 shows the
+output version - each time the format changes this will be updated. Line 02-04
+show the header with column descriptions. Lines 05-10 and 13-18 show the actual
+statistics. These statistics come in two parts; the actual stats separated by a
+short separator (line 08, 14) from the contention points.
+
+The first lock (05-10) is a read/write lock, and shows two lines above the
+short separator. The contention points don't match the column descriptors,
+they have two: contentions and [<IP>] symbol.
+
+
+View the top contending locks:
+
+# grep : /proc/lock_stat | head
+              &inode->i_data.tree_lock-W:            15          21657           0.18     1093295.30 11547131054.85             58          10415           0.16          87.51        6387.60
+              &inode->i_data.tree_lock-R:             0              0           0.00           0.00           0.00          23302         231198           0.25           8.45       98023.38
+                             dcache_lock:          1037           1161           0.38          45.32         774.51           6611         243371           0.15         306.48       77387.24
+                         &inode->i_mutex:           161            286 18446744073709       62882.54     1244614.55           3653          20598 18446744073709       62318.60     1693822.74
+                         &zone->lru_lock:            94             94           0.53           7.33          92.10           4366          32690           0.29          59.81       16350.06
+              &inode->i_data.i_mmap_lock:            79             79           0.40           3.77          53.03          11779          87755           0.28         116.93       29898.44
+                        &q->__queue_lock:            48             50           0.52          31.62          86.31            774          13131           0.17         113.08       12277.52
+                        &rq->rq_lock_key:            43             47           0.74          68.50         170.63           3706          33929           0.22         107.99       17460.62
+                      &rq->rq_lock_key#2:            39             46           0.75           6.68          49.03           2979          32292           0.17         125.17       17137.63
+                         tasklist_lock-W:            15             15           1.45          10.87          32.70           1201           7390           0.58          62.55       13648.47
+
+Clear the statistics:
+
+# echo 0 > /proc/lock_stat
Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug
+++ linux-2.6/lib/Kconfig.debug
@@ -309,6 +309,8 @@ config LOCK_STAT
 	help
 	 This feature enables tracking lock contention points
 
+	 For more details, see Documentation/lockstat.txt
+
 config DEBUG_LOCKDEP
 	bool "Lock dependency engine debugging"
 	depends on DEBUG_KERNEL && LOCKDEP


