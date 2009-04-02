Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbZDBMGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbZDBMGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbZDBMFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:05:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:42375 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627AbZDBMFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:05:13 -0400
Date: Thu, 2 Apr 2009 12:03:47 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090402091319.323309784@chello.nl>
References: <20090402091319.323309784@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: per event wakeups
Message-ID: <tip-b202978dae5fce00d19480360f165a181be19704@git.kernel.org>
Git-Commit-ID: b202978dae5fce00d19480360f165a181be19704
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 12:03:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b202978dae5fce00d19480360f165a181be19704
Gitweb:     http://git.kernel.org/tip/b202978dae5fce00d19480360f165a181be19704
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 2 Apr 2009 11:12:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Apr 2009 13:52:59 +0200

perf_counter: per event wakeups

By request, provide a way to request a wakeup every 'n' events instead
of every page of output.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090402091319.323309784@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    3 ++-
 kernel/perf_counter.c        |   10 +++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 06a6fba..5428ba1 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -145,7 +145,7 @@ struct perf_counter_hw_event {
 				__reserved_1   : 53;
 
 	__u32			extra_config_len;
-	__u32			__reserved_4;
+	__u32			wakeup_events;	/* wakeup every n events */
 
 	__u64			__reserved_2;
 	__u64			__reserved_3;
@@ -321,6 +321,7 @@ struct perf_mmap_data {
 	int				nr_pages;
 	atomic_t			wakeup;
 	atomic_t			head;
+	atomic_t			events;
 	struct perf_counter_mmap_page   *user_page;
 	void 				*data_pages[0];
 };
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 995063d..9bcab10 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1760,7 +1760,15 @@ static void perf_output_copy(struct perf_output_handle *handle,
 
 static void perf_output_end(struct perf_output_handle *handle)
 {
-	if (handle->wakeup)
+	int wakeup_events = handle->counter->hw_event.wakeup_events;
+
+	if (wakeup_events) {
+		int events = atomic_inc_return(&handle->data->events);
+		if (events >= wakeup_events) {
+			atomic_sub(wakeup_events, &handle->data->events);
+			__perf_output_wakeup(handle);
+		}
+	} else if (handle->wakeup)
 		__perf_output_wakeup(handle);
 	rcu_read_unlock();
 }
