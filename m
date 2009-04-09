Return-Path: <linux-kernel-owner+w=401wt.eu-S1764770AbZDIJzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764770AbZDIJzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764381AbZDIJzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:55:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:40699 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763098AbZDIJzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:55:12 -0400
Date: Thu, 9 Apr 2009 09:54:32 GMT
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
Message-ID: <tip-9ee318a7825929bc3734110b83ae8e20e53d9de3@git.kernel.org>
Git-Commit-ID: 9ee318a7825929bc3734110b83ae8e20e53d9de3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 09:54:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ee318a7825929bc3734110b83ae8e20e53d9de3
Gitweb:     http://git.kernel.org/tip/9ee318a7825929bc3734110b83ae8e20e53d9de3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 9 Apr 2009 10:53:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 11:50:43 +0200

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
 kernel/perf_counter.c |   39 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b07195b..76376ec 100644
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
 
@@ -2005,7 +2016,12 @@ static void perf_counter_comm_event(struct perf_comm_event *comm_event)
 
 void perf_counter_comm(struct task_struct *task)
 {
-	struct perf_comm_event comm_event = {
+	struct perf_comm_event comm_event;
+
+	if (!atomic_read(&nr_comm_tracking))
+		return;
+       
+	comm_event = (struct perf_comm_event){
 		.task	= task,
 		.event  = {
 			.header = { .type = PERF_EVENT_COMM, },
@@ -2128,7 +2144,12 @@ got_name:
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
@@ -2146,7 +2167,12 @@ void perf_counter_mmap(unsigned long addr, unsigned long len,
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
@@ -2725,6 +2751,13 @@ done:
 
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
 
