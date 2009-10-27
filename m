Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZJ0NEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZJ0NEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZJ0NEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:04:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49133 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbZJ0NEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:04:10 -0400
Date: Tue, 27 Oct 2009 13:03:32 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256592199-9608-1-git-send-email-acme@redhat.com>
References: <1256592199-9608-1-git-send-email-acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Fix race where process can disappear while reading its /proc/pid/tasks
Message-ID: <tip-7f3bedcc93f935631d2363f23de1cc80f04fdf3e@git.kernel.org>
Git-Commit-ID: 7f3bedcc93f935631d2363f23de1cc80f04fdf3e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f3bedcc93f935631d2363f23de1cc80f04fdf3e
Gitweb:     http://git.kernel.org/tip/7f3bedcc93f935631d2363f23de1cc80f04fdf3e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 26 Oct 2009 19:23:17 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 27 Oct 2009 13:51:53 +0100

perf record: Fix race where process can disappear while reading its /proc/pid/tasks

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1256592199-9608-1-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ac5ddff..9e1638c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -206,6 +206,7 @@ static pid_t pid_synthesize_comm_event(pid_t pid, int full)
 
 	fp = fopen(filename, "r");
 	if (fp == NULL) {
+out_race:	
 		/*
 		 * We raced with a task exiting - just return:
 		 */
@@ -247,6 +248,9 @@ static pid_t pid_synthesize_comm_event(pid_t pid, int full)
 	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
 
 	tasks = opendir(filename);
+	if (tasks == NULL)
+		goto out_race;
+
 	while (!readdir_r(tasks, &dirent, &next) && next) {
 		char *end;
 		pid = strtol(dirent.d_name, &end, 10);
