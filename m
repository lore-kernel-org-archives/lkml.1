Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZJXBIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZJXBIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZJXBEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:51700 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbZJXBEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:37 -0400
Date: Sat, 24 Oct 2009 01:03:35 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, efault@gmx.de, arjan@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, arjan@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091020064649.0e4959b2@infradead.org>
References: <20091020064649.0e4959b2@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf timechart: Fix the wakeup-arrows that point to non-visible processes
Message-ID: <tip-3bc2a39c69d423d5d1f0b3ef77960b1464c976a0@git.kernel.org>
Git-Commit-ID: 3bc2a39c69d423d5d1f0b3ef77960b1464c976a0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bc2a39c69d423d5d1f0b3ef77960b1464c976a0
Gitweb:     http://git.kernel.org/tip/3bc2a39c69d423d5d1f0b3ef77960b1464c976a0
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Tue, 20 Oct 2009 06:46:49 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 20 Oct 2009 03:39:16 +0200

perf timechart: Fix the wakeup-arrows that point to non-visible processes

The timechart wakeup arrows currently show no process
information when the waker/wakee are processes that are not
actually chosen to be shown on the timechart.

This patch fixes this oversight, by looking through all
processes (after giving preference to visible processes) as well
as falling back to just showing the PID if no name for the
process can be resolved.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091020064649.0e4959b2@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-timechart.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 702d8fe..e8a510d 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -765,19 +765,40 @@ static void draw_wakeups(void)
 					if (c->Y && c->start_time <= we->time && c->end_time >= we->time) {
 						if (p->pid == we->waker) {
 							from = c->Y;
-							task_from = c->comm;
+							task_from = strdup(c->comm);
 						}
 						if (p->pid == we->wakee) {
 							to = c->Y;
-							task_to = c->comm;
+							task_to = strdup(c->comm);
 						}
 					}
 					c = c->next;
 				}
+				c = p->all;
+				while (c) {
+					if (p->pid == we->waker && !from) {
+						from = c->Y;
+						task_from = strdup(c->comm);
+					}
+					if (p->pid == we->wakee && !to) {
+						to = c->Y;
+						task_to = strdup(c->comm);
+					}
+					c = c->next;
+				}
 			}
 			p = p->next;
 		}
 
+		if (!task_from) {
+			task_from = malloc(40);
+			sprintf(task_from, "[%i]", we->waker);
+		}
+		if (!task_to) {
+			task_to = malloc(40);
+			sprintf(task_to, "[%i]", we->wakee);
+		}
+
 		if (we->waker == -1)
 			svg_interrupt(we->time, to);
 		else if (from && to && abs(from - to) == 1)
@@ -785,6 +806,9 @@ static void draw_wakeups(void)
 		else
 			svg_partial_wakeline(we->time, from, task_from, to, task_to);
 		we = we->next;
+
+		free(task_from);
+		free(task_to);
 	}
 }
 
