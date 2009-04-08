Return-Path: <linux-kernel-owner+w=401wt.eu-S934466AbZDHRAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934466AbZDHRAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934413AbZDHQ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:59:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:60397 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934277AbZDHQ7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:59:39 -0400
Date: Wed, 8 Apr 2009 16:57:45 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090408130408.769271806@chello.nl>
References: <20090408130408.769271806@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: provide misc bits in the event header
Message-ID: <tip-6fab01927e8bdbbc77bafba2abb4810c5591ad52@git.kernel.org>
Git-Commit-ID: 6fab01927e8bdbbc77bafba2abb4810c5591ad52
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:57:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6fab01927e8bdbbc77bafba2abb4810c5591ad52
Gitweb:     http://git.kernel.org/tip/6fab01927e8bdbbc77bafba2abb4810c5591ad52
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 8 Apr 2009 15:01:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 18:53:27 +0200

perf_counter: provide misc bits in the event header

Limit the size of each record to 64k (or should we count in multiples
of u64 and have a 512K limit?), this gives 16 bits or spare room in the
header, which we can use for misc bits, so as to not have to grow the
record with u64 every time we have a few bits to report.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090408130408.769271806@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    6 +++++-
 kernel/perf_counter.c        |    3 +++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 7f5d353..5bd8817 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -201,9 +201,13 @@ struct perf_counter_mmap_page {
 	__u32   data_head;		/* head in the data section */
 };
 
+#define PERF_EVENT_MISC_KERNEL	(1 << 0)
+#define PERF_EVENT_MISC_USER	(1 << 1)
+
 struct perf_event_header {
 	__u32	type;
-	__u32	size;
+	__u16	misc;
+	__u16	size;
 };
 
 enum perf_event_type {
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 84a3908..4af98f9 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1831,6 +1831,9 @@ static void perf_counter_output(struct perf_counter *counter,
 	header.type = PERF_EVENT_COUNTER_OVERFLOW;
 	header.size = sizeof(header);
 
+	header.misc = user_mode(regs) ?
+		PERF_EVENT_MISC_USER : PERF_EVENT_MISC_KERNEL;
+
 	if (record_type & PERF_RECORD_IP) {
 		ip = instruction_pointer(regs);
 		header.type |= __PERF_EVENT_IP;
