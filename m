Return-Path: <linux-kernel-owner+w=401wt.eu-S1764759AbZFLV1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764759AbZFLV1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762166AbZFLV1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:27:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42755 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757210AbZFLV1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:27:06 -0400
Date: Fri, 12 Jun 2009 17:24:44 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Message-Id: <60b91c42482cf69f925b43dc3e2c322da0f36130.1244837725.git.jbaron@redhat.com>
In-Reply-To: <cover.1244837725.git.jbaron@redhat.com>
References: <cover.1244837725.git.jbaron@redhat.com>
Subject: [PATCH 2/7] add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Call arch_init_ftrace_syscalls at boot, so we can determine the set of syscalls
for the syscall trace events.


Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 arch/x86/kernel/ftrace.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 30baa5b..9f2aa83 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -518,7 +518,7 @@ int syscall_name_to_nr(char *name)
 	return -1;
 }
 
-void arch_init_ftrace_syscalls(void)
+int arch_init_ftrace_syscalls(void)
 {
 	int i;
 	struct syscall_metadata *meta;
@@ -532,17 +532,19 @@ void arch_init_ftrace_syscalls(void)
 					FTRACE_SYSCALL_MAX, GFP_KERNEL);
 	if (!syscalls_metadata) {
 		WARN_ON(1);
-		return;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
 		meta = find_syscall_meta(psys_syscall_table[i]);
 		syscalls_metadata[i] = meta;
 	}
-	return;
+	return 0;
 
 	/* Paranoid: avoid overflow */
 end:
 	atomic_dec(&refs);
+	return 0;
 }
+arch_initcall(arch_init_ftrace_syscalls);
 #endif
-- 
1.6.0.6

