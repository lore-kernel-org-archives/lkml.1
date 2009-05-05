Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZEESgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZEESgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757856AbZEESfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:35:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:58332 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902AbZEESfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:35:15 -0400
Date: Tue, 5 May 2009 18:34:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090505155437.232686598@chello.nl>
References: <20090505155437.232686598@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: fix the output lock
Message-ID: <tip-22c1558e51c210787c6cf75d8905246fc91ec030@git.kernel.org>
Git-Commit-ID: 22c1558e51c210787c6cf75d8905246fc91ec030
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 05 May 2009 18:34:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22c1558e51c210787c6cf75d8905246fc91ec030
Gitweb:     http://git.kernel.org/tip/22c1558e51c210787c6cf75d8905246fc91ec030
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 May 2009 17:50:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 May 2009 20:18:32 +0200

perf_counter: fix the output lock

Use -1 instead of 0 as unlocked, since 0 is a valid cpu number.

( This is not an issue right now but will be once we allow multiple
  counters to output to the same mmap area. )

[ Impact: prepare code for multi-counter profile output ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090505155437.232686598@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 2d13427..c881afe 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1409,6 +1409,7 @@ static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
 	}
 
 	data->nr_pages = nr_pages;
+	atomic_set(&data->lock, -1);
 
 	rcu_assign_pointer(counter->data, data);
 
@@ -1755,7 +1756,7 @@ static void perf_output_lock(struct perf_output_handle *handle)
 	if (in_nmi() && atomic_read(&data->lock) == cpu)
 		return;
 
-	while (atomic_cmpxchg(&data->lock, 0, cpu) != 0)
+	while (atomic_cmpxchg(&data->lock, -1, cpu) != -1)
 		cpu_relax();
 
 	handle->locked = 1;
@@ -1784,7 +1785,7 @@ again:
 	 * NMI can happen here, which means we can miss a done_head update.
 	 */
 
-	cpu = atomic_xchg(&data->lock, 0);
+	cpu = atomic_xchg(&data->lock, -1);
 	WARN_ON_ONCE(cpu != smp_processor_id());
 
 	/*
@@ -1794,7 +1795,7 @@ again:
 		/*
 		 * Since we had it locked, we can lock it again.
 		 */
-		while (atomic_cmpxchg(&data->lock, 0, cpu) != 0)
+		while (atomic_cmpxchg(&data->lock, -1, cpu) != -1)
 			cpu_relax();
 
 		goto again;
