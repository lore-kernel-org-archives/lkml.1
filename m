Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZDGJHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZDGJHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZDGJHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:07:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:46936 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbZDGJHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:07:22 -0400
Date: Tue, 7 Apr 2009 09:06:48 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094517.368446033@chello.nl>
References: <20090406094517.368446033@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: update mmap() counter read, take 2
Message-ID: <tip-a2e87d06ddbe6e6fdb8d6d2e5e985efe4efb07dd@git.kernel.org>
Git-Commit-ID: a2e87d06ddbe6e6fdb8d6d2e5e985efe4efb07dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:06:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2e87d06ddbe6e6fdb8d6d2e5e985efe4efb07dd
Gitweb:     http://git.kernel.org/tip/a2e87d06ddbe6e6fdb8d6d2e5e985efe4efb07dd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:44:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:48:54 +0200

perf_counter: update mmap() counter read, take 2

Update the userspace read method.

Paul noted that:
 - userspace cannot observe ->lock & 1 on the same cpu.
 - we need a barrier() between reading ->lock and ->index
   to ensure we read them in that prticular order.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094517.368446033@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index f2b914d..e22ab47 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -170,22 +170,18 @@ struct perf_counter_mmap_page {
 	 *   u32 seq;
 	 *   s64 count;
 	 *
-	 * again:
-	 *   seq = pc->lock;
-	 *   if (unlikely(seq & 1)) {
-	 *     cpu_relax();
-	 *     goto again;
-	 *   }
+	 *   do {
+	 *     seq = pc->lock;
 	 *
-	 *   if (pc->index) {
-	 *     count = pmc_read(pc->index - 1);
-	 *     count += pc->offset;
-	 *   } else
-	 *     goto regular_read;
+	 *     barrier()
+	 *     if (pc->index) {
+	 *       count = pmc_read(pc->index - 1);
+	 *       count += pc->offset;
+	 *     } else
+	 *       goto regular_read;
 	 *
-	 *   barrier();
-	 *   if (pc->lock != seq)
-	 *     goto again;
+	 *     barrier();
+	 *   } while (pc->lock != seq);
 	 *
 	 * NOTE: for obvious reason this only works on self-monitoring
 	 *       processes.
