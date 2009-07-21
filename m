Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZGUIam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZGUIam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 04:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbZGUIak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 04:30:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:56516 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753081AbZGUIaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 04:30:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/N2A9AMFrNKB2rP9oB8PZx7sLUQIzqzR3CIAxoDw
	jQ6EUHXpqn7Jal
Subject: [patch] perf_counter tools: give perf top inherit option
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 10:30:36 +0200
Message-Id: <1248165036.9795.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is applied on top of resurrect perf top annotation patch.  If that
one doesn't cut the mustard, please holler and I'll redo this one)

perf_counter tools: give perf top inherit option.

Currently, perf top -p only tracks the pid provided, which isn't very useful
for watching forky loads, so give it an inherit option.


Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 tools/perf/builtin-top.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/tools/perf/builtin-top.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-top.c
+++ linux-2.6/tools/perf/builtin-top.c
@@ -60,6 +60,7 @@ static int			count_filter			=  5;
 static int			print_entries			= 15;
 
 static int			target_pid			= -1;
+static int			inherit				=  0;
 static int			profile_cpu			= -1;
 static int			nr_cpus				=  0;
 static unsigned int		realtime_prio			=  0;
@@ -944,7 +945,7 @@ int group_fd;
 static void start_counter(int i, int counter)
 {
 	struct perf_counter_attr *attr;
-	unsigned int cpu;
+	int cpu;
 
 	cpu = profile_cpu;
 	if (target_pid == -1 && profile_cpu == -1)
@@ -954,6 +955,7 @@ static void start_counter(int i, int cou
 
 	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 	attr->freq		= freq;
+	attr->inherit		= (cpu < 0) && inherit;
 
 try_again:
 	fd[i][counter] = sys_perf_counter_open(attr, target_pid, cpu, group_fd, 0);
@@ -1080,6 +1082,8 @@ static const struct option options[] = {
 		    "only display functions with more events than this"),
 	OPT_BOOLEAN('g', "group", &group,
 			    "put the counters into a counter group"),
+	OPT_BOOLEAN('i', "inherit", &inherit,
+		    "child tasks inherit counters"),
 	OPT_STRING('s', "sym-annotate", &sym_filter, "symbol name",
 		    "symbol to annotate - requires -k option"),
 	OPT_BOOLEAN('z', "zero", &zero,


