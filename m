Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbZLaObk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZLaObk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 09:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZLaObh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 09:31:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:57099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbZLaObg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 09:31:36 -0500
Date: Thu, 31 Dec 2009 14:30:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       stable@kernel.org, tglx@linutronix.de, liming.wang@windriver.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
       liming.wang@windriver.com, mingo@elte.hu
In-Reply-To: <1262185684.7135.222.camel@laptop>
References: <1262185684.7135.222.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix NULL deref in inheritance code
Message-ID: <tip-05cbaa2853cdfc255fdd04e65a82bfe9208c4e52@git.kernel.org>
Git-Commit-ID: 05cbaa2853cdfc255fdd04e65a82bfe9208c4e52
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05cbaa2853cdfc255fdd04e65a82bfe9208c4e52
Gitweb:     http://git.kernel.org/tip/05cbaa2853cdfc255fdd04e65a82bfe9208c4e52
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 30 Dec 2009 16:00:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Dec 2009 13:11:31 +0100

perf: Fix NULL deref in inheritance code

Liming found a NULL deref when a task has a perf context but no
counters  when it forks.

This can occur in two cases, a race during construction where
the fork hits after installing the context but before the first
counter gets inserted, or more reproducably, a fork after the
last counter is closed (which leaves the context around).

Reported-by: Wang Liming <liming.wang@windriver.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
CC: <stable@kernel.org>
LKML-Reference: <1262185684.7135.222.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 03cc061..58ed1da 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5148,7 +5148,7 @@ int perf_event_init_task(struct task_struct *child)
 					    GFP_KERNEL);
 			if (!child_ctx) {
 				ret = -ENOMEM;
-				goto exit;
+				break;
 			}
 
 			__perf_event_init_context(child_ctx, child);
@@ -5164,7 +5164,7 @@ int perf_event_init_task(struct task_struct *child)
 		}
 	}
 
-	if (inherited_all) {
+	if (child_ctx && inherited_all) {
 		/*
 		 * Mark the child context as a clone of the parent
 		 * context, or of whatever the parent is a clone of.
@@ -5184,7 +5184,6 @@ int perf_event_init_task(struct task_struct *child)
 		get_ctx(child_ctx->parent_ctx);
 	}
 
-exit:
 	mutex_unlock(&parent_ctx->mutex);
 
 	perf_unpin_context(parent_ctx);
