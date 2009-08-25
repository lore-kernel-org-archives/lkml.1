Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZHYMbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZHYMbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 08:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZHYMbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 08:31:01 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:59370 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbZHYMbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 08:31:00 -0400
Date: Tue, 25 Aug 2009 14:31:11 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 00/12] add syscall tracepoints V3 - s390 arch update
Message-ID: <20090825123111.GD4639@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
	fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
	rostedt@goodmis.org, peterz@infradead.org,
	mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
	mbligh@google.com, lizf@cn.fujitsu.com,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <cover.1249932670.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1249932670.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I looked at your recent syscall tracepoint patches and I have few
more s390 arch updates.

This patch includes s390 arch updates for:
- tracing: Map syscall name to number (syscall_name_to_nr())
- tracing: Call arch_init_ftrace_syscalls at boot
- tracing: add support traceopint ids (set_syscall_{enter,exit}_id())

The patch already uses "NR_syscalls" instead of FTRACE_SYSCALL_MAX.

The patch is based on today's linux-next (20090825).
Since few of your patches already include s390 changes,
I would appreciate if you could add the patch to your patch set.

If you have any remarks, please let me know. 
  
Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 arch/s390/include/asm/ftrace.h |    4 ++++
 arch/s390/kernel/ftrace.c      |   36 +++++++++++++++++++++++++++---------
 2 files changed, 31 insertions(+), 9 deletions(-)

--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -220,6 +220,29 @@ struct syscall_metadata *syscall_nr_to_m
 	return syscalls_metadata[nr];
 }
 
+int syscall_name_to_nr(char *name)
+{
+	int i;
+
+	if (!syscalls_metadata)
+		return -1;
+	for (i = 0; i < NR_syscalls; i++)
+		if (syscalls_metadata[i])
+			if (!strcmp(syscalls_metadata[i]->name, name))
+				return i;
+	return -1;
+}
+
+void set_syscall_enter_id(int num, int id)
+{
+	syscalls_metadata[num]->enter_id = id;
+}
+
+void set_syscall_exit_id(int num, int id)
+{
+	syscalls_metadata[num]->exit_id = id;
+}
+
 static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 {
 	struct syscall_metadata *start;
@@ -237,24 +260,19 @@ static struct syscall_metadata *find_sys
 	return NULL;
 }
 
-void arch_init_ftrace_syscalls(void)
+static int __init arch_init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
 	int i;
-	static atomic_t refs;
-
-	if (atomic_inc_return(&refs) != 1)
-		goto out;
 	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) * NR_syscalls,
 				    GFP_KERNEL);
 	if (!syscalls_metadata)
-		goto out;
+		return -ENOMEM;
 	for (i = 0; i < NR_syscalls; i++) {
 		meta = find_syscall_meta((unsigned long)sys_call_table[i]);
 		syscalls_metadata[i] = meta;
 	}
-	return;
-out:
-	atomic_dec(&refs);
+	return 0;
 }
+arch_initcall(arch_init_ftrace_syscalls);
 #endif
