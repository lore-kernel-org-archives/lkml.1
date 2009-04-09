Return-Path: <linux-kernel-owner+w=401wt.eu-S1764110AbZDII4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764110AbZDII4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 04:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760921AbZDIIy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 04:54:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55937 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758400AbZDIIyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 04:54:24 -0400
Message-Id: <20090409085524.427173196@chello.nl>
References: <20090409085342.799915215@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 09 Apr 2009 10:53:44 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] perf_counter: optimize mmap/comm tracking
Content-Disposition: inline; filename=perf_counter-opt-tracing.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mmap/comm tracking code does quite a lot of work before it discovers
there's no interest in it, avoid that by keeping a counter.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
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
@@ -1186,6 +1190,13 @@ static void free_counter(struct perf_cou
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
@@ -2146,7 +2162,12 @@ void perf_counter_mmap(unsigned long add
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
 

-- 

