Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZGFMJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZGFMJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbZGFMIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:08:53 -0400
Received: from ozlabs.org ([203.10.76.45]:39069 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbZGFMIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:08:52 -0400
Date: Mon, 6 Jul 2009 22:08:15 +1000
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Add alignment-faults and emulation-faults sw
	events
Message-ID: <20090706120815.GC4391@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add two software events that are common to many cpus:

Alignment faults: When a load or store is not aligned properly and must be
performed by the kernel.

Emulation faults: When an instruction must be emulated by the kernel.

Both cause a very significant slowdown (potentially 100x or worse), so
identifying and fixing them is very important.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/include/linux/perf_counter.h
===================================================================
--- linux.trees.git.orig/include/linux/perf_counter.h	2009-07-06 21:50:53.000000000 +1000
+++ linux.trees.git/include/linux/perf_counter.h	2009-07-06 21:51:18.000000000 +1000
@@ -102,6 +102,8 @@
 	PERF_COUNT_SW_CPU_MIGRATIONS		= 4,
 	PERF_COUNT_SW_PAGE_FAULTS_MIN		= 5,
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
+	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
+	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
Index: linux.trees.git/kernel/perf_counter.c
===================================================================
--- linux.trees.git.orig/kernel/perf_counter.c	2009-07-06 21:50:53.000000000 +1000
+++ linux.trees.git/kernel/perf_counter.c	2009-07-06 21:51:18.000000000 +1000
@@ -3754,6 +3754,8 @@
 	case PERF_COUNT_SW_PAGE_FAULTS_MAJ:
 	case PERF_COUNT_SW_CONTEXT_SWITCHES:
 	case PERF_COUNT_SW_CPU_MIGRATIONS:
+	case PERF_COUNT_SW_ALIGNMENT_FAULTS:
+	case PERF_COUNT_SW_EMULATION_FAULTS:
 		if (!counter->parent) {
 			atomic_inc(&perf_swcounter_enabled[event]);
 			counter->destroy = sw_perf_counter_destroy;
Index: linux.trees.git/tools/perf/design.txt
===================================================================
--- linux.trees.git.orig/tools/perf/design.txt	2009-07-06 21:50:53.000000000 +1000
+++ linux.trees.git/tools/perf/design.txt	2009-07-06 21:51:18.000000000 +1000
@@ -137,6 +137,8 @@
 	PERF_COUNT_SW_CPU_MIGRATIONS	= 4,
 	PERF_COUNT_SW_PAGE_FAULTS_MIN	= 5,
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ	= 6,
+	PERF_COUNT_SW_ALIGNMENT_FAULTS	= 7,
+	PERF_COUNT_SW_EMULATION_FAULTS	= 8,
 };
 
 Counters of the type PERF_TYPE_TRACEPOINT are available when the ftrace event
Index: linux.trees.git/tools/perf/util/parse-events.c
===================================================================
--- linux.trees.git.orig/tools/perf/util/parse-events.c	2009-07-06 21:51:12.000000000 +1000
+++ linux.trees.git/tools/perf/util/parse-events.c	2009-07-06 21:51:18.000000000 +1000
@@ -38,6 +38,8 @@
   { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
   { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
   { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
+  { CSW(ALIGNMENT_FAULTS),	"alignment-faults",	""		},
+  { CSW(EMULATION_FAULTS),	"emulation-faults",	""		},
 };
 
 #define __PERF_COUNTER_FIELD(config, name) \
@@ -66,6 +68,8 @@
 	"CPU-migrations",
 	"minor-faults",
 	"major-faults",
+	"alignment-faults",
+	"emulation-faults",
 };
 
 #define MAX_ALIASES 8
