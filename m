Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYHAP2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYHAP2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYHAP2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:28:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:56464 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbYHAP2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:28:13 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/3] kgdb: fix gdb serial thread queries
Date: Fri,  1 Aug 2008 10:27:54 -0500
Message-Id: <1217604474-24239-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1217604474-24239-3-git-send-email-jason.wessel@windriver.com>
References: <1217604474-24239-1-git-send-email-jason.wessel@windriver.com>
 <1217604474-24239-2-git-send-email-jason.wessel@windriver.com>
 <1217604474-24239-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 01 Aug 2008 15:27:56.0369 (UTC) FILETIME=[2C273410:01C8F3EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The command "info threads" did not work correctly with kgdb.  It would
result in a silent kernel hang if used.

This patach addresses several problems.
 - Fix use of deprecated NR_CPUS
 - Fix kgdb to not walk linearly through the pid space
 - Correctly implement shadow pids
 - Change the threads per query to a #define
 - Fix kgdb_hex2long to work with negated values

The threads 0 and -1 are reserved to represent the current task.  That
means that CPU 0 will start with a shadow thread id of -2, and CPU 1
will have a shadow thread id of -3, etc...

>From the debugger you can switch to a shadow thread to see what one of
the other cpus was doing, however it is not possible to execute run
control operations on any other cpu execept the cpu executing the
kgdb_handle_exception().

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kgdb.c |   68 +++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index c0d45b2..eaa21fc 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -56,12 +56,14 @@
 
 static int kgdb_break_asap;
 
+#define KGDB_MAX_THREAD_QUERY 17
 struct kgdb_state {
 	int			ex_vector;
 	int			signo;
 	int			err_code;
 	int			cpu;
 	int			pass_exception;
+	unsigned long		thr_query;
 	unsigned long		threadid;
 	long			kgdb_usethreadid;
 	struct pt_regs		*linux_regs;
@@ -445,9 +447,14 @@ int kgdb_hex2long(char **ptr, unsigned long *long_val)
 {
 	int hex_val;
 	int num = 0;
+	int negate = 0;
 
 	*long_val = 0;
 
+	if (**ptr == '-') {
+		negate = 1;
+		(*ptr)++;
+	}
 	while (**ptr) {
 		hex_val = hex(**ptr);
 		if (hex_val < 0)
@@ -458,6 +465,9 @@ int kgdb_hex2long(char **ptr, unsigned long *long_val)
 		(*ptr)++;
 	}
 
+	if (negate)
+		*long_val = -*long_val;
+
 	return num;
 }
 
@@ -527,10 +537,16 @@ static void int_to_threadref(unsigned char *id, int value)
 static struct task_struct *getthread(struct pt_regs *regs, int tid)
 {
 	/*
-	 * Non-positive TIDs are remapped idle tasks:
+	 * Non-positive TIDs are remapped to the cpu shadow information
 	 */
-	if (tid <= 0)
-		return idle_task(-tid);
+	if (tid == 0 || tid == -1)
+		tid = -atomic_read(&kgdb_active) - 2;
+	if (tid < 0) {
+		if (kgdb_info[-tid - 2].task)
+			return kgdb_info[-tid - 2].task;
+		else
+			return idle_task(-tid - 2);
+	}
 
 	/*
 	 * find_task_by_pid_ns() does not take the tasklist lock anymore
@@ -737,14 +753,15 @@ setundefined:
 }
 
 /*
- * Remap normal tasks to their real PID, idle tasks to -1 ... -NR_CPUs:
+ * Remap normal tasks to their real PID,
+ * CPU shadow threads are mapped to -CPU - 2
  */
 static inline int shadow_pid(int realpid)
 {
 	if (realpid)
 		return realpid;
 
-	return -1-raw_smp_processor_id();
+	return -raw_smp_processor_id() - 2;
 }
 
 static char gdbmsgbuf[BUFMAX + 1];
@@ -838,7 +855,7 @@ static void gdb_cmd_getregs(struct kgdb_state *ks)
 		local_debuggerinfo = kgdb_info[ks->cpu].debuggerinfo;
 	} else {
 		local_debuggerinfo = NULL;
-		for (i = 0; i < NR_CPUS; i++) {
+		for_each_online_cpu(i) {
 			/*
 			 * Try to find the task on some other
 			 * or possibly this node if we do not
@@ -972,10 +989,13 @@ static int gdb_cmd_reboot(struct kgdb_state *ks)
 /* Handle the 'q' query packets */
 static void gdb_cmd_query(struct kgdb_state *ks)
 {
-	struct task_struct *thread;
+	struct task_struct *g;
+	struct task_struct *p;
 	unsigned char thref[8];
 	char *ptr;
 	int i;
+	int cpu;
+	int finished = 0;
 
 	switch (remcom_in_buffer[1]) {
 	case 's':
@@ -985,22 +1005,34 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 			break;
 		}
 
-		if (remcom_in_buffer[1] == 'f')
-			ks->threadid = 1;
-
+		i = 0;
 		remcom_out_buffer[0] = 'm';
 		ptr = remcom_out_buffer + 1;
-
-		for (i = 0; i < 17; ks->threadid++) {
-			thread = getthread(ks->linux_regs, ks->threadid);
-			if (thread) {
-				int_to_threadref(thref, ks->threadid);
+		if (remcom_in_buffer[1] == 'f') {
+			/* Each cpu is a shadow thread */
+			for_each_online_cpu(cpu) {
+				ks->thr_query = 0;
+				int_to_threadref(thref, -cpu - 2);
 				pack_threadid(ptr, thref);
 				ptr += BUF_THREAD_ID_SIZE;
 				*(ptr++) = ',';
 				i++;
 			}
 		}
+
+		do_each_thread(g, p) {
+			if (i >= ks->thr_query && !finished) {
+				int_to_threadref(thref, p->pid);
+				pack_threadid(ptr, thref);
+				ptr += BUF_THREAD_ID_SIZE;
+				*(ptr++) = ',';
+				ks->thr_query++;
+				if (ks->thr_query % KGDB_MAX_THREAD_QUERY == 0)
+					finished = 1;
+			}
+			i++;
+		} while_each_thread(g, p);
+
 		*(--ptr) = '\0';
 		break;
 
@@ -1023,15 +1055,15 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 			error_packet(remcom_out_buffer, -EINVAL);
 			break;
 		}
-		if (ks->threadid > 0) {
+		if ((int)ks->threadid > 0) {
 			kgdb_mem2hex(getthread(ks->linux_regs,
 					ks->threadid)->comm,
 					remcom_out_buffer, 16);
 		} else {
 			static char tmpstr[23 + BUF_THREAD_ID_SIZE];
 
-			sprintf(tmpstr, "Shadow task %d for pid 0",
-					(int)(-ks->threadid-1));
+			sprintf(tmpstr, "shadowCPU%d",
+					(int)(-ks->threadid - 2));
 			kgdb_mem2hex(tmpstr, remcom_out_buffer, strlen(tmpstr));
 		}
 		break;
-- 
1.5.5.1

