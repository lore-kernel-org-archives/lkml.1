Return-Path: <linux-kernel-owner+w=401wt.eu-S1761153AbZDAKSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761153AbZDAKSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758115AbZDAKPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:15:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:33963 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018AbZDAKO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:14:58 -0400
Date: Wed, 1 Apr 2009 10:14:25 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330171024.047961770@chello.nl>
References: <20090330171024.047961770@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: re-arrange the perf_event_type
Message-ID: <tip-06cb4a0996bf4d2b47058aff0e0192819efe502f@git.kernel.org>
Git-Commit-ID: 06cb4a0996bf4d2b47058aff0e0192819efe502f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:14:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06cb4a0996bf4d2b47058aff0e0192819efe502f
Gitweb:     http://git.kernel.org/tip/06cb4a0996bf4d2b47058aff0e0192819efe502f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Mar 2009 19:07:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 11:33:37 +0200

perf_counter: re-arrange the perf_event_type

Breaks ABI yet again :-)

Change the event type so that [0, 2^31-1] are regular event types, but
[2^31, 2^32-1] forms a bitmask for overflow events.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090330171024.047961770@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    6 +++-
 kernel/perf_counter.c        |   56 ++++++++++++++++++-----------------------
 2 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 037a811..edf5bfb 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -210,13 +210,15 @@ struct perf_event_header {
 };
 
 enum perf_event_type {
-	PERF_EVENT_IP		= 0,
+
 	PERF_EVENT_GROUP	= 1,
 
 	PERF_EVENT_MMAP		= 2,
 	PERF_EVENT_MUNMAP	= 3,
 
-	__PERF_EVENT_TID	= 0x100,
+	PERF_EVENT_OVERFLOW	= 1UL << 31,
+	__PERF_EVENT_IP		= 1UL << 30,
+	__PERF_EVENT_TID	= 1UL << 29,
 };
 
 #ifdef __KERNEL__
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 4471e7e..d93e9dd 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1754,50 +1754,44 @@ static void perf_output_end(struct perf_output_handle *handle)
 	rcu_read_unlock();
 }
 
-static int perf_output_write(struct perf_counter *counter, int nmi,
-			     void *buf, ssize_t size)
-{
-	struct perf_output_handle handle;
-	int ret;
-
-	ret = perf_output_begin(&handle, counter, size, nmi);
-	if (ret)
-		goto out;
-
-	perf_output_copy(&handle, buf, size);
-	perf_output_end(&handle);
-
-out:
-	return ret;
-}
-
 static void perf_output_simple(struct perf_counter *counter,
 			       int nmi, struct pt_regs *regs)
 {
-	unsigned int size;
+	int ret;
+	struct perf_output_handle handle;
+	struct perf_event_header header;
+	u64 ip;
 	struct {
-		struct perf_event_header header;
-		u64 ip;
 		u32 pid, tid;
-	} event;
+	} tid_entry;
 
-	event.header.type = PERF_EVENT_IP;
-	event.ip = instruction_pointer(regs);
+	header.type = PERF_EVENT_OVERFLOW;
+	header.size = sizeof(header);
 
-	size = sizeof(event);
+	ip = instruction_pointer(regs);
+	header.type |= __PERF_EVENT_IP;
+	header.size += sizeof(ip);
 
 	if (counter->hw_event.include_tid) {
 		/* namespace issues */
-		event.pid = current->group_leader->pid;
-		event.tid = current->pid;
+		tid_entry.pid = current->group_leader->pid;
+		tid_entry.tid = current->pid;
 
-		event.header.type |= __PERF_EVENT_TID;
-	} else
-		size -= sizeof(u64);
+		header.type |= __PERF_EVENT_TID;
+		header.size += sizeof(tid_entry);
+	}
 
-	event.header.size = size;
+	ret = perf_output_begin(&handle, counter, header.size, nmi);
+	if (ret)
+		return;
+
+	perf_output_put(&handle, header);
+	perf_output_put(&handle, ip);
+
+	if (counter->hw_event.include_tid)
+		perf_output_put(&handle, tid_entry);
 
-	perf_output_write(counter, nmi, &event, size);
+	perf_output_end(&handle);
 }
 
 static void perf_output_group(struct perf_counter *counter, int nmi)
