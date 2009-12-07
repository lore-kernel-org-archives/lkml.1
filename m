Return-Path: <linux-kernel-owner+w=401wt.eu-S934499AbZLGEGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934499AbZLGEGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 23:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933296AbZLGEGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 23:06:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51081 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933180AbZLGEGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 23:06:23 -0500
Message-ID: <4B1C7EE1.8030906@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 12:04:49 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] perf/sched: fix 'perf sched trace'
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we use 'perf sched trace', it will call symbol__init() again,
and can lead perf tool crash:

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
-- 
1.6.1.2

