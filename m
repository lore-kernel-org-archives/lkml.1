Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZGVNEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZGVNEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZGVNEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:04:55 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60010 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbZGVNEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:04:53 -0400
Date: Wed, 22 Jul 2009 23:04:12 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Improve perf stat and perf record option
	parsing
Message-ID: <20090722130412.GD9029@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf stat and perf record currently look for all options on the command
line. This can lead to some confusion:

# perf stat ls -l
  Error: unknown switch `l'

While we can work around this by adding '--' before the command, the git
option parsing code can stop at the first non option:

# perf stat ls -l
 Performance counter stats for 'ls -l':
...

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/tools/perf/builtin-record.c
===================================================================
--- linux.trees.git.orig/tools/perf/builtin-record.c	2009-07-22 22:43:35.000000000 +1000
+++ linux.trees.git/tools/perf/builtin-record.c	2009-07-22 22:43:40.000000000 +1000
@@ -664,7 +664,8 @@ int cmd_record(int argc, const char **ar
 {
 	int counter;
 
-	argc = parse_options(argc, argv, options, record_usage, 0);
+	argc = parse_options(argc, argv, options, record_usage,
+		PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target_pid == -1 && !system_wide)
 		usage_with_options(record_usage, options);
 
Index: linux.trees.git/tools/perf/builtin-stat.c
===================================================================
--- linux.trees.git.orig/tools/perf/builtin-stat.c	2009-07-22 22:43:35.000000000 +1000
+++ linux.trees.git/tools/perf/builtin-stat.c	2009-07-22 22:43:40.000000000 +1000
@@ -511,7 +511,8 @@ int cmd_stat(int argc, const char **argv
 {
 	int status;
 
-	argc = parse_options(argc, argv, options, stat_usage, 0);
+	argc = parse_options(argc, argv, options, stat_usage,
+		PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0 || run_count > MAX_RUN)
