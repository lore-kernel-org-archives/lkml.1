Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab0CKOnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:43:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:43453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608Ab0CKOna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:43:30 -0500
Date: Thu, 11 Mar 2010 14:42:23 GMT
From: "tip-bot for eranian@google.com" <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268288765-5326-1-git-send-email-eranian@google.com>
References: <1268288765-5326-1-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Improve task_sched_in()
Message-ID: <tip-9b33fa6ba0e2f90fdf407501db801c2511121564@git.kernel.org>
Git-Commit-ID: 9b33fa6ba0e2f90fdf407501db801c2511121564
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:42:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b33fa6ba0e2f90fdf407501db801c2511121564
Gitweb:     http://git.kernel.org/tip/9b33fa6ba0e2f90fdf407501db801c2511121564
Author:     eranian@google.com <eranian@google.com>
AuthorDate: Wed, 10 Mar 2010 22:26:05 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 15:23:28 +0100

perf_events: Improve task_sched_in()

This patch is an optimization in perf_event_task_sched_in() to avoid
scheduling the events twice in a row.

Without it, the perf_disable()/perf_enable() pair is invoked twice,
thereby pinned events counts while scheduling flexible events and we go
throuh hw_perf_enable() twice.

By encapsulating, the whole sequence into perf_disable()/perf_enable() we
ensure, hw_perf_enable() is going to be invoked only once because of the
refcount protection.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268288765-5326-1-git-send-email-eranian@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 52c69a3..3853d49 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1368,6 +1368,8 @@ void perf_event_task_sched_in(struct task_struct *task)
 	if (cpuctx->task_ctx == ctx)
 		return;
 
+	perf_disable();
+
 	/*
 	 * We want to keep the following priority order:
 	 * cpu pinned (that don't need to move), task pinned,
@@ -1380,6 +1382,8 @@ void perf_event_task_sched_in(struct task_struct *task)
 	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
 
 	cpuctx->task_ctx = ctx;
+
+	perf_enable();
 }
 
 #define MAX_INTERRUPTS (~0ULL)
