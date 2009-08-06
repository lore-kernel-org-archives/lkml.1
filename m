Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZHFXfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZHFXfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZHFXfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:35:21 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:1358 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbZHFXfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:35:20 -0400
X-IronPort-AV: E=Sophos;i="4.43,337,1246831200"; 
   d="scan'208";a="30872668"
Message-ID: <4A7B68C3.7040706@inria.fr>
Date: Fri, 07 Aug 2009 01:35:31 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix reading of perf.data file header
References: <20090623134749.GA6897@elte.hu> <4A40DFF5.7010207@inria.fr> <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr> <20090629192913.GA29295@elte.hu> <4A7B0C02.7060704@inria.fr> <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr> <20090806195924.GA22411@elte.hu>
In-Reply-To: <20090806195924.GA22411@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> It would be nice to add this as some "perf report -s/--stats" flag, 
> to not have to go via -D (which is a 'print debug output' kind of 
> ad-hoc thing and subject to format changes in the future).
>
> Would you be interested in sending a patch that adds that flag to 
> 'perf report', to print out these statistics entries (if any), in a 
> tabular form suitable for your purposes? Below is a past patch to 
> builtin-report.c that shows how to add new options.
>   

Here's a quick'n'dirty first try. Read events are copied in the
show_stat_event array during process_read_event. And __cmd_report sorts
the array by tid before displaying it.

perf report -S now shows the following after the existing output: (-s is
already used for something else).
It shows things like
# Per-thread statistics:
# PID    TID       Event          Count
  16709   16709   cache-misses   82727
  16709   16709   cache-references   41238768
  16709   16710   cache-misses   6462
  16709   16710   cache-references   76119375
or
# Per-thread statistics:
# PID    TID       Event          Count
  6268   6268   raw 0x1000001e0   494628
  6268   6268   raw 0x1000002e0   209113
  6268   6268   raw 0x1000004e0   307215
  6268   6268   raw 0x1000008e0   9203221
  6268   6269   raw 0x1000001e0   9210788
  6268   6269   raw 0x1000002e0   302344
  6268   6269   raw 0x1000004e0   198705
  6268   6269   raw 0x1000008e0   473471

Obviously, there's some a lot of nice pretty printing to do, but you'll
be able to tell whether the general idea is ok or not.

Brice


Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>

Index: linux-2.6.31/tools/perf/builtin-report.c
===================================================================
--- linux-2.6.31.orig/tools/perf/builtin-report.c	2009-08-07 00:42:55.000000000 +0200
+++ linux-2.6.31/tools/perf/builtin-report.c	2009-08-07 01:26:33.000000000 +0200
@@ -24,6 +24,8 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
+#include <stdlib.h>
+
 #define SHOW_KERNEL	1
 #define SHOW_USER	2
 #define SHOW_HV		4
@@ -52,6 +54,10 @@
 
 static int		full_paths;
 static int		show_nr_samples;
+static int		show_stat;
+static int		show_stat_events;
+static int		show_stat_event_max;
+static struct read_event	*show_stat_event;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
@@ -126,6 +132,8 @@
 	struct read_event		read;
 } event_t;
 
+static struct perf_counter_attr *perf_header__find_attr(u64 id);
+
 static int repsep_fprintf(FILE *fp, const char *fmt, ...)
 {
 	int n;
@@ -1350,6 +1358,13 @@
 	}
 }
 
+static int compar_read_event_by_tid(const void *e1, const void *e2)
+{
+	const struct read_event *event1 = e1;
+	const struct read_event *event2 = e2;
+	return event1->tid - event2->tid;
+}
+
 static size_t output__fprintf(FILE *fp, u64 total_samples)
 {
 	struct hist_entry *pos;
@@ -1430,6 +1445,21 @@
 	}
 	fprintf(fp, "\n");
 
+	if (show_stat && show_stat_events) {
+		int i;
+		qsort(&show_stat_event[0], show_stat_events, sizeof(struct read_event), compar_read_event_by_tid);
+		fprintf(fp, "# Per-thread statistics:\n");
+		fprintf(fp, "# PID    TID       Event          Count\n");
+		for(i=0; i<show_stat_events; i++) {
+			struct read_event *event = &show_stat_event[i];
+			struct perf_counter_attr *attr = perf_header__find_attr(event->id);
+			printf("  %d   %d   %s   %Lu\n",
+			       event->pid, event->tid,
+			       attr ? __event_name(attr->type, attr->config) : "unknown",
+			       event->value);
+		}
+	}
+
 	return ret;
 }
 
@@ -1703,6 +1733,24 @@
 {
 	struct perf_counter_attr *attr = perf_header__find_attr(event->read.id);
 
+	if (show_stat) {
+		if (!show_stat_event) {
+			show_stat_events = 0;
+			show_stat_event_max = 16;
+			show_stat_event = malloc(show_stat_event_max * sizeof(*show_stat_event));
+			if (!show_stat_event)
+				die("cannot allocate show_stat_event array");
+		}
+		if (show_stat_events == show_stat_event_max) {
+			show_stat_event_max *= 2;
+			show_stat_event = realloc(show_stat_event, show_stat_event_max * sizeof(*show_stat_event));
+			if (!show_stat_event)
+				die("cannot enlarge show_stat_event array");
+		}
+		memcpy(&show_stat_event[show_stat_events], &event->read, sizeof(struct read_event));
+		show_stat_events++;
+	}
+
 	dprintf("%p [%p]: PERF_EVENT_READ: %d %d %s %Lu\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
@@ -1998,6 +2046,8 @@
 		    "Show a column with the number of samples"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
+	OPT_BOOLEAN('S', "stat", &show_stat,
+		    "show per-thread event counters"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",


