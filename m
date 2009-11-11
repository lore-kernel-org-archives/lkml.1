Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZKKHnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZKKHnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZKKHna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:43:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:40849 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbZKKHna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:43:30 -0500
Date: Wed, 11 Nov 2009 07:42:46 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1257911467-28276-1-git-send-email-fweisbec@gmail.com>
References: <1257911467-28276-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Synthetize the targeted process
Message-ID: <tip-de8967214d8ce536161a1ad6538ad1cb82e7428d@git.kernel.org>
Git-Commit-ID: de8967214d8ce536161a1ad6538ad1cb82e7428d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de8967214d8ce536161a1ad6538ad1cb82e7428d
Gitweb:     http://git.kernel.org/tip/de8967214d8ce536161a1ad6538ad1cb82e7428d
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 11 Nov 2009 04:51:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Nov 2009 07:30:17 +0100

perf tools: Synthetize the targeted process

Don't forget to also synthetize the targeted process from perf
record or we'll miss its dso in the events and then we won't be
able to deal with its build-id.

We are missing it because it is created after the existing
synthetized tasks but before the counters are enabled and can
send its mapping event.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
LKML-Reference: <1257911467-28276-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ab33381..9f98b86 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -497,13 +497,22 @@ static int __cmd_record(int argc, const char **argv)
 	if (target_pid == -1 && argc) {
 		pid = fork();
 		if (pid < 0)
-			perror("failed to fork");
+			die("failed to fork");
 
 		if (!pid) {
 			if (execvp(argv[0], (char **)argv)) {
 				perror(argv[0]);
 				exit(-1);
 			}
+		} else {
+			/*
+			 * Wait a bit for the execv'ed child to appear
+			 * and be updated in /proc
+			 * FIXME: Do you know a less heuristical solution?
+			 */
+			usleep(1000);
+			event__synthesize_thread(pid,
+						 process_synthesized_event);
 		}
 
 		child_pid = pid;
