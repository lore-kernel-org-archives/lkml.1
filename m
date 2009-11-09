Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZKIJ2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZKIJ2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZKIJ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:28:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:46905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbZKIJ2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:28:41 -0500
Date: Mon, 9 Nov 2009 09:28:00 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       rusty@rustcorp.com.au, efault@gmx.de, mitake@dcl.info.waseda.ac.jp,
       jkosina@suse.cz, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       a.p.zijlstra@chello.nl, efault@gmx.de, mitake@dcl.info.waseda.ac.jp,
       jkosina@suse.cz, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257737465-7546-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257737465-7546-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Fix bench/sched-pipe.c to wait for child process
Message-ID: <tip-5ff0cfc67f00fe0feaa1da0b2359232ea4aa0ee7@git.kernel.org>
Git-Commit-ID: 5ff0cfc67f00fe0feaa1da0b2359232ea4aa0ee7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ff0cfc67f00fe0feaa1da0b2359232ea4aa0ee7
Gitweb:     http://git.kernel.org/tip/5ff0cfc67f00fe0feaa1da0b2359232ea4aa0ee7
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Mon, 9 Nov 2009 12:31:05 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 9 Nov 2009 08:14:30 +0100

perf bench: Fix bench/sched-pipe.c to wait for child process

Ingo reported this small 'perf bench sched pipe' output problem:

 | $ ./perf bench sched pipe
 | (executing 1000000 pipe operations between two tasks)
 |
 |	Total time:4.898 sec
 | $		4.898586 usecs/op
 |		204140 ops/sec
 |
 | the shell prompt came back before the usecs/op and ops/sec line
 | was printed. Process teardown race, lack of wait() or so?

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
LKML-Reference: <1257737465-7546-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
