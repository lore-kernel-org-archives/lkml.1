Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZJZVX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZJZVX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZJZVX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:23:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:37748 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZJZVX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:23:26 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/3] perf record: process can disappear while reading its /proc/pid/tasks
Date: Mon, 26 Oct 2009 19:23:17 -0200
Message-Id: <1256592199-9608-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <y>
References: <y>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.5.5.1

