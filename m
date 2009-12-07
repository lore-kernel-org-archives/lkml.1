Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZLGFc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZLGFc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZLGFc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:32:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:49340 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbZLGFcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:32:54 -0500
Date: Mon, 7 Dec 2009 05:30:46 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       paulus@samba.org, acme@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B1C7EE1.8030906@cn.fujitsu.com>
References: <4B1C7EE1.8030906@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/sched: Fix 'perf sched trace'
Message-ID: <tip-c0777c5aa835a97ccc77d82e55388940f0140a61@git.kernel.org>
Git-Commit-ID: c0777c5aa835a97ccc77d82e55388940f0140a61
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0777c5aa835a97ccc77d82e55388940f0140a61
Gitweb:     http://git.kernel.org/tip/c0777c5aa835a97ccc77d82e55388940f0140a61
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Mon, 7 Dec 2009 12:04:49 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 06:26:22 +0100

perf/sched: Fix 'perf sched trace'

If we use 'perf sched trace', it will call symbol__init() again,
and can lead to a perf tool crash:

 [root@localhost perf]# ./perf sched trace
 *** glibc detected *** ./perf: free(): invalid next size (normal): 0x094c1898 ***
 ======= Backtrace: =========
 /lib/libc.so.6[0xb7602404]
 /lib/libc.so.6(cfree+0x96)[0xb76043b6]
 ./perf[0x80730fe]
 ./perf[0x8074c97]
 ./perf[0x805eb59]
 ./perf[0x80536fd]
 ./perf[0x804b618]
 ./perf[0x804bdc3]
 /lib/libc.so.6(__libc_start_main+0xe5)[0xb75a9735]
 ./perf[0x804af81]
 ======= Memory map: ========
 08048000-08158000 r-xp 00000000 fe:00 556831     /home/eric/....
 08158000-08168000 rw-p 0010f000 fe:00 556831     /home/eric/...
 08168000-085fe000 rw-p 00000000 00:00 0
 094ab000-094cc000 rw-p 00000000 00:00 0          [heap]

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
LKML-Reference: <4B1C7EE1.8030906@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-sched.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 45c46c7..7481ebd 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1888,13 +1888,18 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_sched(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init(0);
-
 	argc = parse_options(argc, argv, sched_options, sched_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
 		usage_with_options(sched_usage, sched_options);
 
+	/*
+	 * Aliased to 'perf trace' for now:
+	 */
+	if (!strcmp(argv[0], "trace"))
+		return cmd_trace(argc, argv, prefix);
+
+	symbol__init(0);
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "lat", 3)) {
@@ -1918,11 +1923,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 				usage_with_options(replay_usage, replay_options);
 		}
 		__cmd_replay();
-	} else if (!strcmp(argv[0], "trace")) {
-		/*
-		 * Aliased to 'perf trace' for now:
-		 */
-		return cmd_trace(argc, argv, prefix);
 	} else {
 		usage_with_options(sched_usage, sched_options);
 	}
