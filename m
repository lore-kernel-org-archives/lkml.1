Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZFOIed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZFOIed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZFOIeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:34:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:57907 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757097AbZFOIeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:34:11 -0400
Date: Mon, 15 Jun 2009 08:33:43 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record: Fix fast task-exit race
Message-ID: <tip-613d8602292165f86ba1969784fea01a06d55900@git.kernel.org>
Git-Commit-ID: 613d8602292165f86ba1969784fea01a06d55900
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 08:33:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  613d8602292165f86ba1969784fea01a06d55900
Gitweb:     http://git.kernel.org/tip/613d8602292165f86ba1969784fea01a06d55900
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 15 Jun 2009 08:17:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 15 Jun 2009 09:08:31 +0200

perf record: Fix fast task-exit race

Recording with -a (or with -p) can race with tasks going away:

   couldn't open /proc/8440/maps

Causing an early exit() and no recording done.

Do not abort the recording session - instead just skip that task.

Also, only print the warnings under -v.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a177a59..e1dfef2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -202,8 +202,12 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0) {
-		fprintf(stderr, "couldn't open %s\n", filename);
-		exit(EXIT_FAILURE);
+		/*
+		 * We raced with a task exiting - just return:
+		 */
+		if (verbose)
+			fprintf(stderr, "couldn't open %s\n", filename);
+		return;
 	}
 	if (read(fd, bf, sizeof(bf)) < 0) {
 		fprintf(stderr, "couldn't read %s\n", filename);
@@ -273,8 +277,12 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 
 	fp = fopen(filename, "r");
 	if (fp == NULL) {
-		fprintf(stderr, "couldn't open %s\n", filename);
-		exit(EXIT_FAILURE);
+		/*
+		 * We raced with a task exiting - just return:
+		 */
+		if (verbose)
+			fprintf(stderr, "couldn't open %s\n", filename);
+		return;
 	}
 	while (1) {
 		char bf[BUFSIZ], *pbf = bf;
