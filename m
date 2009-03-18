Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbZCRJUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbZCRJUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbZCRJTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:19:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:57642 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbZCRJTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:19:36 -0400
Date: Wed, 18 Mar 2009 09:18:55 GMT
From: Carsten Emde <Carsten.Emde@osadl.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, Carsten.Emde@osadl.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, Carsten.Emde@osadl.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:tracing/tasks] tracing: fix command line to pid reverse map
Message-ID: <tip-a635cf0497342978d417cae19d4a4823932977ff@git.kernel.org>
Git-Commit-ID: a635cf0497342978d417cae19d4a4823932977ff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 09:18:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a635cf0497342978d417cae19d4a4823932977ff
Gitweb:     http://git.kernel.org/tip/a635cf0497342978d417cae19d4a4823932977ff
Author:     Carsten Emde <Carsten.Emde@osadl.org>
AuthorDate: Wed, 18 Mar 2009 09:00:41 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 10:10:18 +0100

tracing: fix command line to pid reverse map

Impact: fix command line to pid mapping

map_cmdline_to_pid[] is checked in trace_save_cmdline(), but never
updated. This results in stale pid to command line mappings and the
tracer output will associate the wrong comm string.

Signed-off-by: Carsten Emde <Carsten.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 06c69a2..305c562 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -738,8 +738,7 @@ void trace_stop_cmdline_recording(void);
 
 static void trace_save_cmdline(struct task_struct *tsk)
 {
-	unsigned map;
-	unsigned idx;
+	unsigned pid, idx;
 
 	if (!tsk->pid || unlikely(tsk->pid > PID_MAX_DEFAULT))
 		return;
@@ -757,10 +756,17 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	if (idx == NO_CMDLINE_MAP) {
 		idx = (cmdline_idx + 1) % SAVED_CMDLINES;
 
-		map = map_cmdline_to_pid[idx];
-		if (map != NO_CMDLINE_MAP)
-			map_pid_to_cmdline[map] = NO_CMDLINE_MAP;
+		/*
+		 * Check whether the cmdline buffer at idx has a pid
+		 * mapped. We are going to overwrite that entry so we
+		 * need to clear the map_pid_to_cmdline. Otherwise we
+		 * would read the new comm for the old pid.
+		 */
+		pid = map_cmdline_to_pid[idx];
+		if (pid != NO_CMDLINE_MAP)
+			map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;
 
+		map_cmdline_to_pid[idx] = tsk->pid;
 		map_pid_to_cmdline[tsk->pid] = idx;
 
 		cmdline_idx = idx;
