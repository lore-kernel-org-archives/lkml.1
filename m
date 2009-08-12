Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbZHLJSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbZHLJSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbZHLJSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:18:02 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41978 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222AbZHLJSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:18:01 -0400
Date: Wed, 12 Aug 2009 11:18:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: mingo@elte.hu
Subject: [PATCH] perf: add support for specifying profile cpu for record
Message-ID: <20090812091801.GC12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

perf top supports a -C for setting the profile CPU, but perf record does
not. This adds the same option for perf record, allowing the user to
specify a specific target profile CPU.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6da0992..8e85543 100644
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
@@ -425,6 +426,9 @@ try_again:
 
 		if (err == EPERM)
 			die("Permission error - are you root?\n");
+		else if (err ==  ENODEV && profile_cpu != -1)
+			die("No such device - did you specify an out-of-range"
+				" profile CPU?\n");
 
 		/*
 		 * If it's cycles then fall back to hrtimer
@@ -554,9 +558,13 @@ static int __cmd_record(int argc, const char **argv)
 		if (pid == -1)
 			pid = getpid();
 
-		open_counters(-1, pid);
-	} else for (i = 0; i < nr_cpus; i++)
-		open_counters(i, target_pid);
+		open_counters(profile_cpu, pid);
+	} else if (profile_cpu != -1)
+		open_counters(profile_cpu, target_pid);
+	else {
+		for (i = 0; i < nr_cpus; i++)
+			open_counters(i, target_pid);
+	}
 
 	if (file_new)
 		perf_header__write(header, output);
@@ -635,6 +643,8 @@ static const struct option options[] = {
 			    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('A', "append", &append_file,
 			    "append to the output file to do incremental profiling"),
+	OPT_INTEGER('C', "profile_cpu", &profile_cpu,
+			    "CPU to profile on"),
 	OPT_BOOLEAN('f', "force", &force,
 			"overwrite existing data file"),
 	OPT_LONG('c', "count", &default_interval,

-- 
Jens Axboe

