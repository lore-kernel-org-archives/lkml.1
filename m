Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbZJSVpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbZJSVpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbZJSVpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:45:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:37207 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782AbZJSVpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:45:51 -0400
Date: Tue, 20 Oct 2009 06:46:49 +0900
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 1/2] perf timechart: Fix the wakeup-arrows that point to
 non-visible processes
Message-ID: <20091020064649.0e4959b2@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 81e4574cf1e2091443dc254470a2160d7be0f940 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 20 Oct 2009 06:40:57 +0900
Subject: [PATCH 1/2] perf timechart: Fix the wakeup-arrows that point to non-visible processes

The timechart wakeup arrows currently show no process information when
the waker/wakee are processes that are not actually chosen to be shown
on the timechart.

This patch fixes this oversight, by looking through all processes
(after giving preference to visible processes) as well as falling back
to just showing the PID if no name for the process can be resolved.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
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
 
-- 
1.6.2.5



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
