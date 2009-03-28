Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZC1Tv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZC1Tv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZC1TuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:50:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZC1TuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:50:08 -0400
Message-Id: <20090328194929.845667682@chello.nl>
References: <20090328194359.426029037@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 28 Mar 2009 20:44:04 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/9] perf_counter: kerneltop: parse the mmap data stream
Content-Disposition: inline; filename=kerneltop-mmap-events.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

frob the kerneltop code to print the mmap data in the stream

Better use would be collecting the IPs per PID and mapping them onto
the provided userspace code.. TODO

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/kerneltop.c |   50 +++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 6 deletions(-)

Index: linux-2.6/Documentation/perf_counter/kerneltop.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/kerneltop.c
+++ linux-2.6/Documentation/perf_counter/kerneltop.c
@@ -184,6 +184,8 @@ static int			nmi				=  1;
 static int			group				=  0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			=  16;
+static int			use_mmap			= 0;
+static int			use_munmap			= 0;
 
 static char			*vmlinux;
 
@@ -333,6 +335,8 @@ static void display_help(void)
 	" -z        --zero             # zero counts after display\n"
 	" -D        --dump_symtab      # dump symbol table to stderr on startup\n"
 	" -m pages  --mmap_pages=<pages> # number of mmap data pages\n"
+	" -M        --mmap_info        # print mmap info stream\n"
+	" -U        --munmap_info      # print munmap info stream\n"
 	);
 
 	exit(0);
@@ -1052,9 +1056,11 @@ static void process_options(int argc, ch
 			{"stat",	no_argument,		NULL, 'S'},
 			{"zero",	no_argument,		NULL, 'z'},
 			{"mmap_pages",	required_argument,	NULL, 'm'},
+			{"mmap_info",	no_argument,		NULL, 'M'},
+			{"munmap_info",	no_argument,		NULL, 'U'},
 			{NULL,		0,			NULL,  0 }
 		};
-		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hn:m:p:s:Sx:z",
+		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hn:m:p:s:Sx:zMU",
 				    long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1092,6 +1098,8 @@ static void process_options(int argc, ch
 		case 'x': vmlinux			= strdup(optarg); break;
 		case 'z': zero				=              1; break;
 		case 'm': mmap_pages			=   atoi(optarg); break;
+		case 'M': use_mmap			=              1; break;
+		case 'U': use_munmap			=              1; break;
 		default: error = 1; break;
 		}
 	}
@@ -1172,12 +1180,29 @@ static void mmap_read(struct mmap_data *
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
 
@@ -1187,7 +1212,7 @@ static void mmap_read(struct mmap_data *
 		 */
 		if ((old & md->mask) + size != ((old + size) & md->mask)) {
 			unsigned int offset = old;
-			unsigned int len = sizeof(*event), cpy;
+			unsigned int len = min(sizeof(*event), size), cpy;
 			void *dst = &event_copy;
 
 			do {
@@ -1206,7 +1231,18 @@ static void mmap_read(struct mmap_data *
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
@@ -1255,6 +1291,8 @@ int main(int argc, char *argv[])
 			hw_event.record_type	= PERF_RECORD_IRQ;
 			hw_event.nmi		= nmi;
 			hw_event.include_tid	= 1;
+			hw_event.mmap		= use_mmap;
+			hw_event.munmap		= use_munmap;
 
 			fd[i][counter] = sys_perf_counter_open(&hw_event, tid, cpu, group_fd, 0);
 			if (fd[i][counter] < 0) {

-- 

