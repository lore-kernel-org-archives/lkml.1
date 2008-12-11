Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbYLKWFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbYLKWFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbYLKWFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:05:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45219 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110AbYLKWFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:05:07 -0500
Message-ID: <49418E91.9090904@redhat.com>
Date: Thu, 11 Dec 2008 17:05:05 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Performance Counters for Linux, v3
Content-Type: multipart/mixed;
 boundary="------------030303080102000801070906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030303080102000801070906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I was taking a look at the proposed performance monitoring and kerneltop.c. I 
noticed that  http://redhat.com/~mingo/perfcounters/kerneltop.c doesn't work 
with the v3 version. I didn't see a more recent version available, so I made 
some modifications to make allow it to work with the v3 kernel (with the 
attached). However, I assume some where there is an updated version of kerneltop.c

The Documentation/perf-counters.txt doesn't describe how the group_fd is used. 
Found that -1 used to indicate not connected to any other fd.

-Will

--------------030303080102000801070906
Content-Type: text/x-patch;
 name="v3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v3.diff"

--- kerneltop.c.old	2008-12-11 15:34:58.000000000 -0500
+++ kerneltop.c	2008-12-11 16:06:28.000000000 -0500
@@ -62,15 +62,31 @@
 # define __NR_perf_counter_open 333
 #endif
 
+/*
+ * Hardware event to monitor via a performance monitoring counter:
+ */
+struct perf_counter_hw_event {
+	int64_t			type;
+
+	u_int64_t		irq_period;
+	u_int32_t		record_type;
+
+	u_int32_t		disabled     :  1, /* off by default */
+				nmi	     :  1, /* NMI sampling   */
+				raw	     :  1, /* raw event type */
+				__reserved_1 : 29;
+
+	u_int64_t		__reserved_2;
+};
+
 int
-perf_counter_open(int		hw_event_type,
-                  unsigned int	hw_event_period,
-                  unsigned int	record_type,
+perf_counter_open(struct perf_counter_hw_event *hw_event_uptr,
                   pid_t		pid,
-                  int		cpu)
+                  int		cpu,
+		  int		group_fd)
 {
-	return syscall(__NR_perf_counter_open, hw_event_type, hw_event_period,
-			record_type, pid, cpu);
+	return syscall(__NR_perf_counter_open, hw_event_uptr,
+		       pid, cpu, group_fd);
 }
 
 enum hw_event_types {
@@ -82,10 +98,6 @@
 	PERF_COUNT_BRANCH_MISSES,
 	PERF_COUNT_MAX,
 
-	/*
-	 * If this bit is set in the type, then trigger NMI sampling:
-	 */
-	PERF_COUNT_NMI			= (1 << 30),
 };
 
 const char *event_types [] = {
@@ -616,14 +628,14 @@
 {
 	struct pollfd event_array[MAX_NR_CPUS][MAX_COUNTERS];
 	int fd[MAX_NR_CPUS][MAX_COUNTERS];
-	unsigned int nmi_flag = 0;
-	unsigned int flags, cpu;
+	unsigned int cpu;
 	int i, counter;
 	uint64_t ip;
 	ssize_t res;
 #if USE_POLL
 	int ret;
 #endif
+	struct perf_counter_hw_event hw_event;
 
 	process_options(argc, argv);
 
@@ -633,18 +645,18 @@
 
 	assert(nr_cpus <= MAX_NR_CPUS);
 
-	if (nmi)
-		nmi_flag |= PERF_COUNT_NMI;
-
 	for (i = 0; i < nr_cpus; i++) {
 		for (counter = 0; counter < nr_counters; counter++) {
-			flags	= event_id[counter] | nmi_flag;
-
 			cpu	= profile_cpu;
 			if (tid == -1 && profile_cpu == -1)
 				cpu = i;
-
-			fd[i][counter] = perf_counter_open(flags, event_count[counter], 1, tid, cpu);
+			hw_event.type = event_id[counter];
+			hw_event.irq_period = event_count[counter];
+			hw_event.record_type = 1;
+			hw_event.nmi = nmi ? 1 : 0;
+				
+			fd[i][counter] = perf_counter_open(&hw_event, tid,
+							   cpu, -1 );
 			if (fd[i][counter] < 0) {
 				printf("kerneltop error: syscall returned with %d (%s)\n",
 					fd[i][counter], strerror(-fd[i][counter]));

--------------030303080102000801070906--
