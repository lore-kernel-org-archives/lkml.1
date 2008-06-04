Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYFDCoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYFDCoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYFDCn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:43:59 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:29077 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYFDCn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:43:58 -0400
Date: Tue, 3 Jun 2008 19:44:08 -0700
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 3/4] per-task-delay-accounting: update document and
 getdelays.c for memory reclaim
Message-Id: <20080603194408.f6462532.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update document and
make getdelays.c show delay accounting of memory reclaim.

For making a distinction between "swapping in pages" and "memory reclaim"
in getdelays.c, MEM is changed to SWAP.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
---
 Documentation/accounting/delay-accounting.txt |   11 ++++++++---
 Documentation/accounting/getdelays.c          |    8 ++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/Documentation/accounting/delay-accounting.txt b/Documentation/accounting/delay-accounting.txt
index 1443cd7..8a12f07 100644
--- a/Documentation/accounting/delay-accounting.txt
+++ b/Documentation/accounting/delay-accounting.txt
@@ -11,6 +11,7 @@ the delays experienced by a task while
 a) waiting for a CPU (while being runnable)
 b) completion of synchronous block I/O initiated by the task
 c) swapping in pages
+d) memory reclaim

 and makes these statistics available to userspace through
 the taskstats interface.
@@ -41,7 +42,7 @@ this structure. See
      include/linux/taskstats.h
 for a description of the fields pertaining to delay accounting.
 It will generally be in the form of counters returning the cumulative
-delay seen for cpu, sync block I/O, swapin etc.
+delay seen for cpu, sync block I/O, swapin, memory reclaim etc.

 Taking the difference of two successive readings of a given
 counter (say cpu_delay_total) for a task will give the delay
@@ -94,7 +95,9 @@ CPU	count	real total	virtual total	delay total
 	7876	92005750	100000000	24001500
 IO	count	delay total
 	0	0
-MEM	count	delay total
+SWAP	count	delay total
+	0	0
+RECLAIM	count	delay total
 	0	0

 Get delays seen in executing a given simple command
@@ -108,5 +111,7 @@ CPU	count	real total	virtual total	delay total
 	6	4000250		4000000		0
 IO	count	delay total
 	0	0
-MEM	count	delay total
+SWAP	count	delay total
+	0	0
+RECLAIM	count	delay total
 	0	0
diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index 40121b5..3f7755f 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -196,14 +196,18 @@ void print_delayacct(struct taskstats *t)
 	       "      %15llu%15llu%15llu%15llu\n"
 	       "IO    %15s%15s\n"
 	       "      %15llu%15llu\n"
-	       "MEM   %15s%15s\n"
+	       "SWAP  %15s%15s\n"
+	       "      %15llu%15llu\n"
+	       "RECLAIM  %12s%15s\n"
 	       "      %15llu%15llu\n",
 	       "count", "real total", "virtual total", "delay total",
 	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
 	       t->cpu_delay_total,
 	       "count", "delay total",
 	       t->blkio_count, t->blkio_delay_total,
-	       "count", "delay total", t->swapin_count, t->swapin_delay_total);
+	       "count", "delay total", t->swapin_count, t->swapin_delay_total,
+	       "count", "delay total",
+	       t->freepages_count, t->freepages_delay_total);
 }

 void task_context_switch_counts(struct taskstats *t)
-- 
1.5.0.6
