Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZCYVGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZCYVGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZCYVGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:06:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50563 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZCYVGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:06:40 -0400
Message-Id: <20090325210542.382565314@chello.nl>
References: <20090325210419.408653980@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 22:04:22 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/3] perf_counter: kerneltop: parse the mmap data stream
Content-Disposition: inline; filename=kerneltop-mmap-events.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

frob the kerneltop code to print the mmap data in the stream

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/kerneltop.c |   39 ++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

Index: linux-2.6/Documentation/perf_counter/kerneltop.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/kerneltop.c
+++ linux-2.6/Documentation/perf_counter/kerneltop.c
@@ -1184,12 +1184,29 @@ static void mmap_read(struct mmap_data *
 	last_read = this_read;
 
 	for (; old != head;) {
-		struct event_struct {
+		struct ip_event {
 			struct perf_event_header header;
 			__u64 ip;
 			__u32 pid, tid;
-		} *event = (struct event_struct *)&data[old & md->mask];
-		struct event_struct event_copy;
+		};
+		struct mmap_event {
+			struct perf_event_header header;
+			__u32 pid, tid;
+			__u64 start;
+			__u64 len;
+			__u64 pgoff;
+			char filename[PATH_MAX];
+		};
+
+		typedef union event_union {
+			struct perf_event_header header;
+			struct ip_event ip;
+			struct mmap_event mmap;
+		} event_t;
+
+		event_t *event = (event_t *)&data[old & md->mask];
+
+		event_t event_copy;
 
 		unsigned int size = event->header.size;
 
@@ -1199,7 +1216,7 @@ static void mmap_read(struct mmap_data *
 		 */
 		if ((old & md->mask) + size != ((old + size) & md->mask)) {
 			unsigned int offset = old;
-			unsigned int len = sizeof(*event), cpy;
+			unsigned int len = min(sizeof(*event), size), cpy;
 			void *dst = &event_copy;
 
 			do {
@@ -1218,7 +1235,18 @@ static void mmap_read(struct mmap_data *
 		switch (event->header.type) {
 		case PERF_EVENT_IP:
 		case PERF_EVENT_IP | __PERF_EVENT_TID:
-			process_event(event->ip, md->counter);
+			process_event(event->ip.ip, md->counter);
+			break;
+
+		case PERF_EVENT_MMAP:
+		case PERF_EVENT_MUNMAP:
+			printf("%s: %Lu %Lu %Lu %s\n",
+					event->header.type == PERF_EVENT_MMAP
+					  ? "mmap" : "munmap",
+					event->mmap.start,
+					event->mmap.len,
+					event->mmap.pgoff,
+					event->mmap.filename);
 			break;
 		}
 	}
@@ -1267,6 +1295,7 @@ int main(int argc, char *argv[])
 			hw_event.record_type	= PERF_RECORD_IRQ;
 			hw_event.nmi		= nmi;
 			hw_event.include_tid	= 1;
+			hw_event.mmap		= 1;
 
 			fd[i][counter] = sys_perf_counter_open(&hw_event, tid, cpu, group_fd, 0);
 			if (fd[i][counter] < 0) {

-- 

