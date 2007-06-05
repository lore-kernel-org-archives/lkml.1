Return-Path: <linux-kernel-owner+w=401wt.eu-S1764425AbXFEKoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764425AbXFEKoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 06:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764033AbXFEKn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 06:43:58 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:19882 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764011AbXFEKn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 06:43:57 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Maxim Uvarov <muvarov@ru.mvista.com>
Subject: [PATCH] Performance Stats: Kernel patch
Date: Tue, 05 Jun 2007 14:43:50 +0000
Message-ID: <20070605144349.4636.53260.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Changes:

Names are renamed to task_context_switch_rates.




Patch makes available to the user the following
task and process performance statistics:
	* Involuntary Context Switches (task_struct->nivcsw)
	* Voluntary Context Switches (task_struct->nvcsw)
	           
Statistics information is available from:
	1. taskstats interface (Documentation/accounting/)
	2. /proc/PID/status (task only).

This data is useful for detecting hyperactivity
patterns between processes.
Signed-off-by: Maxim Uvarov <muvarov@ru.mvista.com>
                                                      
---

 Documentation/accounting/getdelays.c          |   19 +++++++++++++++++--
 Documentation/accounting/taskstats-struct.txt |    6 ++++++
 fs/proc/array.c                               |    8 ++++++++
 include/linux/taskstats.h                     |    5 ++++-
 kernel/taskstats.c                            |    4 ++++
 5 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index e9126e7..fcfe796 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -49,6 +49,7 @@ char name[100];
 int dbg;
 int print_delays;
 int print_io_accounting;
+int print_task_context_switch_rates;
 __u64 stime, utime;
 
 #define PRINTF(fmt, arg...) {			\
@@ -187,7 +188,7 @@ void print_delayacct(struct taskstats *t)
 	       "IO    %15s%15s\n"
 	       "      %15llu%15llu\n"
 	       "MEM   %15s%15s\n"
-	       "      %15llu%15llu\n\n",
+	       "      %15llu%15llu\n"
 	       "count", "real total", "virtual total", "delay total",
 	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
 	       t->cpu_delay_total,
@@ -196,6 +197,14 @@ void print_delayacct(struct taskstats *t)
 	       "count", "delay total", t->swapin_count, t->swapin_delay_total);
 }
 
+void task_context_switch_rates(struct taskstats *t)
+{
+	printf("\n\nTask   %15s%15s\n"
+	       "       %15lu%15lu\n",
+	       "voluntary", "nonvoluntary",
+	       t->nvcsw, t->nivcsw);
+}
+
 void print_ioacct(struct taskstats *t)
 {
 	printf("%s: read=%llu, write=%llu, cancelled_write=%llu\n",
@@ -227,7 +236,7 @@ int main(int argc, char *argv[])
 	struct msgtemplate msg;
 
 	while (1) {
-		c = getopt(argc, argv, "diw:r:m:t:p:v:l");
+		c = getopt(argc, argv, "qdiw:r:m:t:p:v:l");
 		if (c < 0)
 			break;
 
@@ -240,6 +249,10 @@ int main(int argc, char *argv[])
 			printf("printing IO accounting\n");
 			print_io_accounting = 1;
 			break;
+		case 'q':
+			printf("printing task/process context switch rates\n");
+			print_task_context_switch_rates = 1;
+			break;
 		case 'w':
 			strncpy(logfile, optarg, MAX_FILENAME);
 			printf("write to file %s\n", logfile);
@@ -381,6 +394,8 @@ int main(int argc, char *argv[])
 							print_delayacct((struct taskstats *) NLA_DATA(na));
 						if (print_io_accounting)
 							print_ioacct((struct taskstats *) NLA_DATA(na));
+						if (print_task_context_switch_rates)
+							task_context_switch_rates((struct taskstats *) NLA_DATA(na));
 						if (fd) {
 							if (write(fd, NLA_DATA(na), na->nla_len) < 0) {
 								err(1,"write error\n");
diff --git a/Documentation/accounting/taskstats-struct.txt b/Documentation/accounting/taskstats-struct.txt
index 661c797..dc2a7a1 100644
--- a/Documentation/accounting/taskstats-struct.txt
+++ b/Documentation/accounting/taskstats-struct.txt
@@ -22,6 +22,8 @@ There are three different groups of fields in the struct taskstats:
     /* Extended accounting fields end */
     Their values are collected if CONFIG_TASK_XACCT is set.
 
+4) Per-task and per-thread context switch rates statistics
+
 Future extension should add fields to the end of the taskstats struct, and
 should not change the relative position of each field within the struct.
 
@@ -158,4 +160,8 @@ struct taskstats {
 
 	/* Extended accounting fields end */
 
+4) Per-task and per-thread statistics
+	__u64	nvcsw;			/* Context voluntary switch counter */
+	__u64	nivcsw;			/* Context involuntary switch counter */
+
 }
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 70e4fab..cf406e8 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -290,6 +290,13 @@ static inline char *task_cap(struct task_struct *p, char *buffer)
 			    cap_t(p->cap_permitted),
 			    cap_t(p->cap_effective));
 }
+static inline char *task_context_switch_rates(struct task_struct *p, char *buffer)
+{
+	return buffer + sprintf(buffer, "voluntary_ctxt_switches:\t%lu\n"
+			    "nonvoluntary_ctxt_switches:\t%lu\n",
+			    p->nvcsw,
+			    p->nivcsw);
+}
 
 int proc_pid_status(struct task_struct *task, char * buffer)
 {
@@ -309,6 +316,7 @@ int proc_pid_status(struct task_struct *task, char * buffer)
 #if defined(CONFIG_S390)
 	buffer = task_show_regs(task, buffer);
 #endif
+	buffer = task_context_switch_rates(task, buffer);
 	return buffer - orig;
 }
 
diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
index 3fced47..6927f81 100644
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -31,7 +31,7 @@
  */
 
 
-#define TASKSTATS_VERSION	3
+#define TASKSTATS_VERSION	4
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -146,6 +146,9 @@ struct taskstats {
 	__u64	read_bytes;		/* bytes of read I/O */
 	__u64	write_bytes;		/* bytes of write I/O */
 	__u64	cancelled_write_bytes;	/* bytes of cancelled write I/O */
+
+	__u64  nvcsw;			/* voluntary_ctxt_switches */
+	__u64  nivcsw;			/* nonvoluntary_ctxt_switches */
 };
 
 
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 4c3476f..e5bc666 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -196,6 +196,8 @@ static int fill_pid(pid_t pid, struct task_struct *tsk,
 
 	/* fill in basic acct fields */
 	stats->version = TASKSTATS_VERSION;
+	stats->nvcsw = tsk->nvcsw;
+	stats->nivcsw = tsk->nivcsw;
 	bacct_add_tsk(stats, tsk);
 
 	/* fill in extended acct fields */
@@ -242,6 +244,8 @@ static int fill_tgid(pid_t tgid, struct task_struct *first,
 		 */
 		delayacct_add_tsk(stats, tsk);
 
+		stats->nvcsw += tsk->nvcsw;
+		stats->nivcsw += tsk->nivcsw;
 	} while_each_thread(first, tsk);
 
 	unlock_task_sighand(first, &flags);

