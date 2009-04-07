Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbZDGJHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbZDGJHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZDGJHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:07:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:46953 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZDGJHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:07:42 -0400
Date: Tue, 7 Apr 2009 09:07:00 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094517.457320003@chello.nl>
References: <20090406094517.457320003@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: add more context information
Message-ID: <tip-9c03d88e328d5f28f13191622c2ea1349c36b799@git.kernel.org>
Git-Commit-ID: 9c03d88e328d5f28f13191622c2ea1349c36b799
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:07:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c03d88e328d5f28f13191622c2ea1349c36b799
Gitweb:     http://git.kernel.org/tip/9c03d88e328d5f28f13191622c2ea1349c36b799
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:48:54 +0200

perf_counter: add more context information

Change the callchain context entries to u16, so as to gain some space.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094517.457320003@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    4 ++--
 kernel/perf_counter.c        |    6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index e22ab47..f9d5cf0 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -507,10 +507,10 @@ extern void perf_counter_mmap(unsigned long addr, unsigned long len,
 extern void perf_counter_munmap(unsigned long addr, unsigned long len,
 				unsigned long pgoff, struct file *file);
 
-#define MAX_STACK_DEPTH		254
+#define MAX_STACK_DEPTH		255
 
 struct perf_callchain_entry {
-	u32	nr, hv, kernel, user;
+	u16	nr, hv, kernel, user;
 	u64	ip[MAX_STACK_DEPTH];
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 2a5d4f5..727624d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1657,9 +1657,7 @@ void perf_counter_do_pending(void)
  * Callchain support -- arch specific
  */
 
-struct perf_callchain_entry *
-__attribute__((weak))
-perf_callchain(struct pt_regs *regs)
+__weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 {
 	return NULL;
 }
@@ -1819,7 +1817,7 @@ void perf_counter_output(struct perf_counter *counter,
 		callchain = perf_callchain(regs);
 
 		if (callchain) {
-			callchain_size = (2 + callchain->nr) * sizeof(u64);
+			callchain_size = (1 + callchain->nr) * sizeof(u64);
 
 			header.type |= __PERF_EVENT_CALLCHAIN;
 			header.size += callchain_size;
