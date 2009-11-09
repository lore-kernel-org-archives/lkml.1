Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbZKIDN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbZKIDN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZKIDN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:13:57 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59938 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZKIDN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:13:57 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] perf bench:Fix bench/sched-pipe.c to wait child process
Date: Mon,  9 Nov 2009 12:13:08 +0900
Message-Id: <1257736388-7303-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091109.120908.552412311744460070.mitake@dcl.info.waseda.ac.jp>
References: <20091109.120908.552412311744460070.mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed bench/sched-pipe.c to avoid the below case
notified by Ingo Molnar,

---

$ ./perf bench sched pipe
(executing 1000000 pipe operations between two tasks)

	Total time:4.898 sec
$ 		4.898586 usecs/op
		204140 ops/sec

the shell prompt came back before the usecs/op and ops/sec line was
printed. Process teardown race, lack of wait() or so?

---

This caused by lack of calling waitpid() by parent process,
so I added it.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 tools/perf/bench/sched-pipe.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 3214ed2..6a29100 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -26,6 +26,7 @@
 #include <errno.h>
 #include <assert.h>
 #include <sys/time.h>
+#include <sys/types.h>
 
 #define LOOPS_DEFAULT 1000000
 static int loops = LOOPS_DEFAULT;
@@ -58,8 +59,8 @@ int bench_sched_pipe(int argc, const char **argv,
 	 * discarding returned value of read(), write()
 	 * causes error in building environment for perf
 	 */
-	int ret;
-	pid_t pid;
+	int ret, wait_stat;
+	pid_t pid, retpid;
 
 	argc = parse_options(argc, argv, options,
 			     bench_sched_pipe_usage, 0);
@@ -87,8 +88,11 @@ int bench_sched_pipe(int argc, const char **argv,
 	gettimeofday(&stop, NULL);
 	timersub(&stop, &start, &diff);
 
-	if (pid)
+	if (pid) {
+		retpid = waitpid(pid, &wait_stat, 0);
+		assert((retpid == pid) && WIFEXITED(wait_stat));
 		return 0;
+	}
 
 	if (simple)
 		printf("%lu.%03lu\n",
-- 
1.6.5.2

