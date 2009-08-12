Return-Path: <linux-kernel-owner+w=401wt.eu-S932377AbZHLJxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbZHLJxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbZHLJxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:53:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:54241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbZHLJw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:52:59 -0400
Date: Wed, 12 Aug 2009 09:52:15 GMT
From: tip-bot for Jens Axboe <jens.axboe@oracle.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       jens.axboe@oracle.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       jens.axboe@oracle.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090812091801.GC12579@kernel.dk>
References: <20090812091801.GC12579@kernel.dk>
Subject: [tip:perfcounters/urgent] perf record: Add missing -C option support for specifying profile cpu
Message-ID: <tip-009eb52b6580a92e5fb35f77f94b8cc11c963d9d@git.kernel.org>
Git-Commit-ID: 009eb52b6580a92e5fb35f77f94b8cc11c963d9d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 12 Aug 2009 09:52:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  009eb52b6580a92e5fb35f77f94b8cc11c963d9d
Gitweb:     http://git.kernel.org/tip/009eb52b6580a92e5fb35f77f94b8cc11c963d9d
Author:     Jens Axboe <jens.axboe@oracle.com>
AuthorDate: Wed, 12 Aug 2009 11:18:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 12 Aug 2009 11:35:45 +0200

perf record: Add missing -C option support for specifying profile cpu

perf top supports a -C for setting the profile CPU, but perf
record does not. This adds the same option for perf record,
allowing the user to specify a specific target profile CPU.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090812091801.GC12579@kernel.dk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 30b83de..de76008 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -35,6 +35,7 @@ static const char		*output_name			= "perf.data";
 static int			group				= 0;
 static unsigned int		realtime_prio			= 0;
 static int			system_wide			= 0;
+static int			profile_cpu			= -1;
 static pid_t			target_pid			= -1;
 static int			inherit				= 1;
 static int			force				= 0;
@@ -431,6 +432,8 @@ try_again:
 
 		if (err == EPERM)
 			die("Permission error - are you root?\n");
+		else if (err ==  ENODEV && profile_cpu != -1)
+			die("No such device - did you specify an out-of-range profile CPU?\n");
 
 		/*
 		 * If it's cycles then fall back to hrtimer
@@ -564,9 +567,15 @@ static int __cmd_record(int argc, const char **argv)
 		if (pid == -1)
 			pid = getpid();
 
-		open_counters(-1, pid);
-	} else for (i = 0; i < nr_cpus; i++)
-		open_counters(i, target_pid);
+		open_counters(profile_cpu, pid);
+	} else {
+		if (profile_cpu != -1) {
+			open_counters(profile_cpu, target_pid);
+		} else {
+			for (i = 0; i < nr_cpus; i++)
+				open_counters(i, target_pid);
+		}
+	}
 
 	if (file_new)
 		perf_header__write(header, output);
@@ -645,6 +654,8 @@ static const struct option options[] = {
 			    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('A', "append", &append_file,
 			    "append to the output file to do incremental profiling"),
+	OPT_INTEGER('C', "profile_cpu", &profile_cpu,
+			    "CPU to profile on"),
 	OPT_BOOLEAN('f', "force", &force,
 			"overwrite existing data file"),
 	OPT_LONG('c', "count", &default_interval,
