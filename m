Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZHMHwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZHMHwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZHMHwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:52:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:52942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZHMHwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:52:23 -0400
Subject: [PATCH 3/2] perf tools: Fixup read ABI breakage
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090812153529.716542680@chello.nl>
References: <20090812153529.716542680@chello.nl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Aug 2009 09:51:53 +0200
Message-Id: <1250149914.10001.65.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf tools: Fixup read ABI breakage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Aug 13 09:03:33 CEST 2009

Update the perf tool to the new read output format.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-stat.c   |    8 +++++---
 tools/perf/util/event.h     |   10 ++++++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6/tools/perf/builtin-record.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-record.c
+++ linux-2.6/tools/perf/builtin-record.c
@@ -370,9 +370,9 @@ static void create_counter(int counter, 
 	struct perf_header_attr *h_attr;
 	int track = !counter; /* only the first counter needs these */
 	struct {
-		u64 count;
 		u64 time_enabled;
 		u64 time_running;
+		u64 count;
 		u64 id;
 	} read_data;
 
Index: linux-2.6/tools/perf/builtin-stat.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-stat.c
+++ linux-2.6/tools/perf/builtin-stat.c
@@ -168,10 +168,12 @@ static void read_counter(int counter)
 		close(fd[cpu][counter]);
 		fd[cpu][counter] = -1;
 
-		count[0] += single_count[0];
 		if (scale) {
-			count[1] += single_count[1];
-			count[2] += single_count[2];
+			count[0] += single_count[2]; /* value   */
+			count[1] += single_count[0]; /* enabled */
+			count[2] += single_count[1]; /* running */
+		} else {
+			count[0] += single_count[0]; /* value   */
 		}
 	}
 
Index: linux-2.6/tools/perf/util/event.h
===================================================================
--- linux-2.6.orig/tools/perf/util/event.h
+++ linux-2.6/tools/perf/util/event.h
@@ -4,6 +4,9 @@
 #include "util.h"
 #include <linux/list.h>
 
+/*
+ * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
+ */
 struct ip_event {
 	struct perf_event_header header;
 	u64 ip;
@@ -38,12 +41,15 @@ struct lost_event {
 	u64 lost;
 };
 
-struct read_event {
+/*
+ * PERF_FORMAT_ENABLED | PERF_FORMAT_RUNNING | PERF_FORMAT_ID
+ */
+struct read_event {
 	struct perf_event_header header;
 	u32 pid,tid;
-	u64 value;
 	u64 time_enabled;
 	u64 time_running;
+	u64 value;
 	u64 id;
 };
 

