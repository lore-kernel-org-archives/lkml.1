Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZFBOUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZFBOUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbZFBOUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:20:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:44609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757741AbZFBOUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:20:06 -0400
Date: Tue, 2 Jun 2009 14:19:31 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: tools: Better handle existing data files
Message-ID: <tip-97124d5e2df5b9eaa5bb684bb1e8ebc7e29d0f5d@git.kernel.org>
Git-Commit-ID: 97124d5e2df5b9eaa5bb684bb1e8ebc7e29d0f5d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 14:19:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97124d5e2df5b9eaa5bb684bb1e8ebc7e29d0f5d
Gitweb:     http://git.kernel.org/tip/97124d5e2df5b9eaa5bb684bb1e8ebc7e29d0f5d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 15:52:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 16:16:26 +0200

perf_counter: tools: Better handle existing data files

Provide an argument (-f) to overwrite existing data files.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 810fc27..bace7a8 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -7,6 +7,7 @@
 #include "util/parse-events.h"
 #include "util/string.h"
 
+#include <unistd.h>
 #include <sched.h>
 
 #define ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a)-1)
@@ -26,7 +27,7 @@ static unsigned int		realtime_prio			= 0;
 static int			system_wide			= 0;
 static pid_t			target_pid			= -1;
 static int			inherit				= 1;
-static int			nmi				= 1;
+static int			force				= 0;
 
 const unsigned int default_count[] = {
 	1000000,
@@ -337,7 +338,6 @@ static void open_counters(int cpu, pid_t pid)
 		hw_event.config		= event_id[counter];
 		hw_event.irq_period	= event_count[counter];
 		hw_event.record_type	= PERF_RECORD_IP | PERF_RECORD_TID;
-		hw_event.nmi		= nmi;
 		hw_event.mmap		= track;
 		hw_event.comm		= track;
 		hw_event.inherit	= (cpu < 0) && inherit;
@@ -387,13 +387,20 @@ static int __cmd_record(int argc, const char **argv)
 	int i, counter;
 	pid_t pid;
 	int ret;
+	struct stat st;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
 	assert(nr_cpus >= 0);
 
-	output = open(output_name, O_CREAT|O_EXCL|O_TRUNC|O_RDWR, S_IRUSR|S_IWUSR);
+	if (!stat(output_name, &st) && !force) {
+		fprintf(stderr, "Error, output file: %s exists, use -f to overwrite.\n",
+				output_name);
+		exit(-1);
+	}
+
+	output = open(output_name, O_CREAT|O_TRUNC|O_RDWR, S_IRUSR|S_IWUSR);
 	if (output < 0) {
 		perror("failed to create output file");
 		exit(-1);
@@ -473,6 +480,8 @@ static const struct option options[] = {
 		    "collect data with this RT SCHED_FIFO priority"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 			    "system-wide collection from all CPUs"),
+	OPT_BOOLEAN('f', "force", &force,
+			"overwrite existing data file"),
 	OPT_END()
 };
 
