Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbZLPRhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbZLPRhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762620AbZLPRhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:37:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:47555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762608AbZLPRhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:37:04 -0500
Date: Wed, 16 Dec 2009 17:34:30 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091216165904.987643843@chello.nl>
References: <20091216165904.987643843@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Use per-task-per-cpu events for inherited events
Message-ID: <tip-60ab271617cec607380099f3ed8e84916e48323b@git.kernel.org>
Git-Commit-ID: 60ab271617cec607380099f3ed8e84916e48323b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60ab271617cec607380099f3ed8e84916e48323b
Gitweb:     http://git.kernel.org/tip/60ab271617cec607380099f3ed8e84916e48323b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 17:55:56 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 18:30:13 +0100

perf record: Use per-task-per-cpu events for inherited events

Create events with a pid and cpu contraint for inherited events
so that we get a stream per cpu, instead of all cpus contending
on a single stream.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: fweisbec@gmail.com
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091216165904.987643843@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9b7c6d8..63136d0 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -278,7 +278,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
 
 	attr->mmap		= track;
 	attr->comm		= track;
-	attr->inherit		= (cpu < 0) && inherit;
+	attr->inherit		= inherit;
 	attr->disabled		= 1;
 
 try_again:
@@ -537,7 +537,7 @@ static int __cmd_record(int argc __used, const char **argv)
 	}
 
 
-	if (!system_wide || profile_cpu != -1) {
+	if ((!system_wide && !inherit) || profile_cpu != -1) {
 		open_counters(profile_cpu, target_pid);
 	} else {
 		for (i = 0; i < nr_cpus; i++)
