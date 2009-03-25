Return-Path: <linux-kernel-owner+w=401wt.eu-S1761127AbZCYMIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127AbZCYMIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760832AbZCYMHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:07:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:57134 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760788AbZCYMHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:07:53 -0400
Date: Wed, 25 Mar 2009 12:06:54 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       arjan@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com,
       mingo@elte.hu
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, fengguang.wu@intel.com,
       mingo@elte.hu
In-Reply-To: <20090325113317.013775235@chello.nl>
References: <20090325113317.013775235@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: optionally provide the pid/tid of the sampled task
Message-ID: <tip-fd46efb85aea330c364ece28621c06e5845680e3@git.kernel.org>
Git-Commit-ID: fd46efb85aea330c364ece28621c06e5845680e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 12:06:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd46efb85aea330c364ece28621c06e5845680e3
Gitweb:     http://git.kernel.org/tip/fd46efb85aea330c364ece28621c06e5845680e3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Mar 2009 12:30:25 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 13:02:52 +0100

perf_counter: optionally provide the pid/tid of the sampled task

Allow cpu wide counters to profile userspace by providing what process
the sample belongs to.

This raises the first issue with the output type, lots of these
options: group, tid, callchain, etc.. are non-exclusive and could be
combined, suggesting a bitfield.

However, things like the mmap() data stream doesn't fit in that.

How to split the type field...

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
LKML-Reference: <20090325113317.013775235@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    5 ++++-
 kernel/perf_counter.c        |   18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index c256635..7fdbdf8 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -127,8 +127,9 @@ struct perf_counter_hw_event {
 				exclude_kernel :  1, /* ditto kernel          */
 				exclude_hv     :  1, /* ditto hypervisor      */
 				exclude_idle   :  1, /* don't count when idle */
+				include_tid    :  1, /* include the tid */
 
-				__reserved_1   : 55;
+				__reserved_1   : 54;
 
 	__u32			extra_config_len;
 	__u32			__reserved_4;
@@ -164,6 +165,8 @@ struct perf_event_header {
 enum perf_event_type {
 	PERF_EVENT_IP		= 0,
 	PERF_EVENT_GROUP	= 1,
+
+	__PERF_EVENT_TID	= 0x100,
 };
 
 #ifdef __KERNEL__
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 7669afe..f3e1b27 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1528,16 +1528,30 @@ out:
 static void perf_output_simple(struct perf_counter *counter,
 			       int nmi, struct pt_regs *regs)
 {
+	unsigned int size;
 	struct {
 		struct perf_event_header header;
 		u64 ip;
+		u32 pid, tid;
 	} event;
 
 	event.header.type = PERF_EVENT_IP;
-	event.header.size = sizeof(event);
 	event.ip = instruction_pointer(regs);
 
-	perf_output_write(counter, nmi, &event, sizeof(event));
+	size = sizeof(event);
+
+	if (counter->hw_event.include_tid) {
+		/* namespace issues */
+		event.pid = current->group_leader->pid;
+		event.tid = current->pid;
+
+		event.header.type |= __PERF_EVENT_TID;
+	} else
+		size -= sizeof(u64);
+
+	event.header.size = size;
+
+	perf_output_write(counter, nmi, &event, size);
 }
 
 static void perf_output_group(struct perf_counter *counter, int nmi)
