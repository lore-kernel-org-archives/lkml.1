Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbZKKDvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbZKKDvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 22:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZKKDvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 22:51:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:65256 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZKKDu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 22:50:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ejyWErF5XgszPk4aC4re/afJHkx4CjeYMuv4m0w+Qc6wg1tt/pFeMXpSGYsqZajwas
         mOabfnwLtTBDyNRoGGPCMT8n6hS1ULvUCphSysMYF3AqkSg3PvOyxVrMtDeErshPQFnR
         k8+CSzrm/kLnCCiy8emL/nrihyu0lL10bC26E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 1/6] perf tools: Synthetize the targeted process
Date: Wed, 11 Nov 2009 04:51:02 +0100
Message-Id: <1257911467-28276-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't forget to also synthetize the targeted process from perf record
or we'll miss its dso in the events and then we won't be able to deal
with its build-id.

We are missing it because it is created after the existing synthetized
tasks but before the counters are enabled and can send its mapping
event.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/builtin-record.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cf2cd25..2b45d33 100644
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
-- 
1.6.2.3

