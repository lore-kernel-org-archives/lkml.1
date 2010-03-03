Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0CCWGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:06:41 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:61640 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab0CCWGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:06:35 -0500
From: Eric B Munson <ebmunson@us.ibm.com>
To: a.p.zijlstra@chello.nl
Cc: paulus@samba.org, mingo@elte.hu, acme@redhat.com,
       linux-kernel@vger.kernel.org, Eric B Munson <ebmunson@us.ibm.com>
Subject: [PATCH] Enable the enable_on_exec flag if record forks the target
Date: Wed,  3 Mar 2010 22:06:27 +0000
Message-Id: <1267653987-11022-1-git-send-email-ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When forking its target, perf record can capture data from before the target
application is started.  Perf stat uses the enable_on_exec flag in the event
attributes to keep from displaying events from before the target program
starts, this patch adds the same functionality to perf record when it is will
fork the target process.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
---
 tools/perf/builtin-record.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 771533c..625076e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -224,7 +224,7 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 	return h_attr;
 }
 
-static void create_counter(int counter, int cpu, pid_t pid)
+static void create_counter(int counter, int cpu, pid_t pid, bool forks)
 {
 	char *filter = filters[counter];
 	struct perf_event_attr *attr = attrs + counter;
@@ -273,6 +273,9 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	attr->inherit		= inherit;
 	attr->disabled		= 1;
 
+	if (forks)
+		attr->enable_on_exec = 1;
+
 try_again:
 	fd[nr_cpu][counter] = sys_perf_event_open(attr, pid, cpu, group_fd, 0);
 
@@ -376,13 +379,13 @@ try_again:
 	ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_ENABLE);
 }
 
-static void open_counters(int cpu, pid_t pid)
+static void open_counters(int cpu, pid_t pid, bool forks)
 {
 	int counter;
 
 	group_fd = -1;
 	for (counter = 0; counter < nr_counters; counter++)
-		create_counter(counter, cpu, pid);
+		create_counter(counter, cpu, pid, forks);
 
 	nr_cpu++;
 }
@@ -542,10 +545,10 @@ static int __cmd_record(int argc, const char **argv)
 
 
 	if ((!system_wide && !inherit) || profile_cpu != -1) {
-		open_counters(profile_cpu, target_pid);
+		open_counters(profile_cpu, target_pid, forks);
 	} else {
 		for (i = 0; i < nr_cpus; i++)
-			open_counters(i, target_pid);
+			open_counters(i, target_pid, forks);
 	}
 
 	if (file_new) {
-- 
1.6.3.3

