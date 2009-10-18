Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbZJRLOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbZJRLOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 07:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZJRLOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 07:14:35 -0400
Received: from ozlabs.org ([203.10.76.45]:54399 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZJRLO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 07:14:29 -0400
Date: Sun, 18 Oct 2009 22:09:29 +1100
From: Anton Blanchard <anton@samba.org>
To: benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org,
       a.p.zijlstra@chello.nl
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] perf_event: Add alignment-faults and emulation-faults
	software events
Message-ID: <20091018110929.GK4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add two more sw events that are common to many cpus.

Alignment faults: When a load or store is not aligned properly.

Emulation faults: When an instruction is emulated in software.

Both cause a very significant slowdown (100x or worse), so identifying and
fixing them is very important.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/include/linux/perf_event.h
===================================================================
--- linux.trees.git.orig/include/linux/perf_event.h	2009-10-16 11:17:17.000000000 +1100
+++ linux.trees.git/include/linux/perf_event.h	2009-10-16 11:17:29.000000000 +1100
@@ -102,6 +102,8 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_CPU_MIGRATIONS		= 4,
 	PERF_COUNT_SW_PAGE_FAULTS_MIN		= 5,
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
+	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
+	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
Index: linux.trees.git/include/linux/perf_counter.h
===================================================================
--- linux.trees.git.orig/include/linux/perf_counter.h	2009-10-16 11:16:10.000000000 +1100
+++ linux.trees.git/include/linux/perf_counter.h	2009-10-16 11:17:29.000000000 +1100
@@ -106,6 +106,8 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_CPU_MIGRATIONS		= 4,
 	PERF_COUNT_SW_PAGE_FAULTS_MIN		= 5,
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
+	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
+	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
Index: linux.trees.git/kernel/perf_event.c
===================================================================
--- linux.trees.git.orig/kernel/perf_event.c	2009-10-16 11:17:17.000000000 +1100
+++ linux.trees.git/kernel/perf_event.c	2009-10-16 11:17:29.000000000 +1100
@@ -4255,6 +4255,8 @@ static const struct pmu *sw_perf_event_i
 	case PERF_COUNT_SW_PAGE_FAULTS_MAJ:
 	case PERF_COUNT_SW_CONTEXT_SWITCHES:
 	case PERF_COUNT_SW_CPU_MIGRATIONS:
+	case PERF_COUNT_SW_ALIGNMENT_FAULTS:
+	case PERF_COUNT_SW_EMULATION_FAULTS:
 		if (!event->parent) {
 			atomic_inc(&perf_swevent_enabled[event_id]);
 			event->destroy = sw_perf_event_destroy;
Index: linux.trees.git/tools/perf/design.txt
===================================================================
--- linux.trees.git.orig/tools/perf/design.txt	2009-10-16 11:16:10.000000000 +1100
+++ linux.trees.git/tools/perf/design.txt	2009-10-16 11:17:29.000000000 +1100
@@ -137,6 +137,8 @@ enum sw_event_ids {
 	PERF_COUNT_SW_CPU_MIGRATIONS	= 4,
 	PERF_COUNT_SW_PAGE_FAULTS_MIN	= 5,
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ	= 6,
+	PERF_COUNT_SW_ALIGNMENT_FAULTS	= 7,
+	PERF_COUNT_SW_EMULATION_FAULTS	= 8,
 };
 
 Counters of the type PERF_TYPE_TRACEPOINT are available when the ftrace event
Index: linux.trees.git/tools/perf/util/parse-events.c
===================================================================
--- linux.trees.git.orig/tools/perf/util/parse-events.c	2009-10-16 11:16:10.000000000 +1100
+++ linux.trees.git/tools/perf/util/parse-events.c	2009-10-16 11:17:29.000000000 +1100
@@ -47,6 +47,8 @@ static struct event_symbol event_symbols
   { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
   { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
   { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
+  { CSW(ALIGNMENT_FAULTS),	"alignment-faults",	""		},
+  { CSW(EMULATION_FAULTS),	"emulation-faults",	""		},
 };
 
 #define __PERF_EVENT_FIELD(config, name) \
@@ -75,6 +77,8 @@ static const char *sw_event_names[] = {
 	"CPU-migrations",
 	"minor-faults",
 	"major-faults",
+	"alignment-faults",
+	"emulation-faults",
 };
 
 #define MAX_ALIASES 8
