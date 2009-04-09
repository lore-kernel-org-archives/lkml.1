Return-Path: <linux-kernel-owner+w=401wt.eu-S1764366AbZDIJHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764366AbZDIJHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759501AbZDIJHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:07:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:44557 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbZDIJHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:07:22 -0400
Date: Thu, 9 Apr 2009 09:06:36 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090409085524.427173196@chello.nl>
References: <20090409085524.427173196@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: optimize mmap/comm tracking
Message-ID: <tip-e37f8d14c1f56e274b3e827912f23f0b2fb7a7bb@git.kernel.org>
Git-Commit-ID: e37f8d14c1f56e274b3e827912f23f0b2fb7a7bb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 09:06:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e37f8d14c1f56e274b3e827912f23f0b2fb7a7bb
Gitweb:     http://git.kernel.org/tip/e37f8d14c1f56e274b3e827912f23f0b2fb7a7bb
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 9 Apr 2009 10:53:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 11:00:53 +0200

perf_counter: optimize mmap/comm tracking

Impact: performance optimization

The mmap/comm tracking code does quite a lot of work before it discovers
there's no interest in it, avoid that by keeping a counter.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090409085524.427173196@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b07195b..af9fd89 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -38,6 +38,10 @@ int perf_max_counters __read_mostly = 1;
 static int perf_reserved_percpu __read_mostly;
 static int perf_overcommit __read_mostly = 1;
 
+static atomic_t nr_mmap_tracking __read_mostly;
+static atomic_t nr_munmap_tracking __read_mostly;
+static atomic_t nr_comm_tracking __read_mostly;
+
 /*
  * Mutex for (sysadmin-configurable) counter reservations:
  */
@@ -1186,6 +1190,13 @@ static void free_counter(struct perf_counter *counter)
 {
 	perf_pending_sync(counter);
 
+	if (counter->hw_event.mmap)
+		atomic_dec(&nr_mmap_tracking);
+	if (counter->hw_event.munmap)
+		atomic_dec(&nr_munmap_tracking);
+	if (counter->hw_event.comm)
+		atomic_dec(&nr_comm_tracking);
+
 	if (counter->destroy)
 		counter->destroy(counter);
 
@@ -2128,7 +2139,12 @@ got_name:
 void perf_counter_mmap(unsigned long addr, unsigned long len,
 		       unsigned long pgoff, struct file *file)
 {
-	struct perf_mmap_event mmap_event = {
+	struct perf_mmap_event mmap_event;
+
+	if (!atomic_read(&nr_mmap_tracking))
+		return;
+
+	mmap_event = (struct perf_mmap_event){
 		.file   = file,
 		.event  = {
 			.header = { .type = PERF_EVENT_MMAP, },
@@ -2146,7 +2162,12 @@ void perf_counter_mmap(unsigned long addr, unsigned long len,
 void perf_counter_munmap(unsigned long addr, unsigned long len,
 			 unsigned long pgoff, struct file *file)
 {
-	struct perf_mmap_event mmap_event = {
+	struct perf_mmap_event mmap_event;
+
+	if (!atomic_read(&nr_munmap_tracking))
+		return;
+
+	mmap_event = (struct perf_mmap_event){
 		.file   = file,
 		.event  = {
 			.header = { .type = PERF_EVENT_MUNMAP, },
@@ -2725,6 +2746,13 @@ done:
 
 	counter->hw_ops = hw_ops;
 
+	if (counter->hw_event.mmap)
+		atomic_inc(&nr_mmap_tracking);
+	if (counter->hw_event.munmap)
+		atomic_inc(&nr_munmap_tracking);
+	if (counter->hw_event.comm)
+		atomic_inc(&nr_comm_tracking);
+
 	return counter;
 }
 
