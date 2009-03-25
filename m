Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbZCYLjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbZCYLjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759567AbZCYLiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:38:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:39782 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236AbZCYLit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:38:49 -0400
Message-Id: <20090325113317.192910290@chello.nl>
References: <20090325113021.781490788@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 12:30:27 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/6] perf_counter: kerneltop: output event support
Content-Disposition: inline; filename=kerneltop-mmap-packets.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach kerneltop about the new output ABI.

XXX: anybody fancy integrating the PID/TID data into the output?

Bump the mmap_data pages a little because we bloated the output and
have to be more careful about overruns with structured data.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/kerneltop.c |   65 +++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 6 deletions(-)

Index: linux-2.6/Documentation/perf_counter/kerneltop.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/kerneltop.c
+++ linux-2.6/Documentation/perf_counter/kerneltop.c
@@ -134,6 +134,11 @@
 #endif
 
 #define unlikely(x)	__builtin_expect(!!(x), 0)
+#define min(x, y) ({				\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void) (&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2; })
 
 asmlinkage int sys_perf_counter_open(
         struct perf_counter_hw_event    *hw_event_uptr          __user,
@@ -178,7 +183,7 @@ static int			nr_cpus				=  0;
 static int			nmi				=  1;
 static int			group				=  0;
 static unsigned int		page_size;
-static unsigned int		mmap_pages			=  4;
+static unsigned int		mmap_pages			=  16;
 
 static char			*vmlinux;
 
@@ -1147,28 +1152,75 @@ static void mmap_read(struct mmap_data *
 	unsigned int head = mmap_read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
+	int diff;
 
 	gettimeofday(&this_read, NULL);
 
-	if (head - old > md->mask) {
+	/*
+	 * If we're further behind than half the buffer, there's a chance
+	 * the writer will bite our tail and screw up the events under us.
+	 *
+	 * If we somehow ended up ahead of the head, we got messed up.
+	 *
+	 * In either case, truncate and restart at head.
+	 */
+	diff = head - old;
+	if (diff > md->mask / 2 || diff < 0) {
 		struct timeval iv;
 		unsigned long msecs;
 
 		timersub(&this_read, &last_read, &iv);
 		msecs = iv.tv_sec*1000 + iv.tv_usec/1000;
 
-		fprintf(stderr, "WARNING: failed to keep up with mmap data.  Last read %lu msecs ago.\n", msecs);
+		fprintf(stderr, "WARNING: failed to keep up with mmap data."
+				"  Last read %lu msecs ago.\n", msecs);
 
+		/*
+		 * head points to a known good entry, start there.
+		 */
 		old = head;
 	}
 
 	last_read = this_read;
 
 	for (; old != head;) {
-		__u64 *ptr = (__u64 *)&data[old & md->mask];
-		old += sizeof(__u64);
+		struct event_struct {
+			struct perf_event_header header;
+			__u64 ip;
+			__u32 pid, tid;
+		} *event = (struct event_struct *)&data[old & md->mask];
+		struct event_struct event_copy;
+
+		unsigned int size = event->header.size;
 
-		process_event(*ptr, md->counter);
+		/*
+		 * Event straddles the mmap boundary -- header should always
+		 * be inside due to u64 alignment of output.
+		 */
+		if ((old & md->mask) + size != ((old + size) & md->mask)) {
+			unsigned int offset = old;
+			unsigned int len = sizeof(*event), cpy;
+			void *dst = &event_copy;
+
+			do {
+				cpy = min(md->mask + 1 - (offset & md->mask), len);
+				memcpy(dst, &data[offset & md->mask], cpy);
+				offset += cpy;
+				dst += cpy;
+				len -= cpy;
+			} while (len);
+
+			event = &event_copy;
+		}
+
+		old += size;
+
+		switch (event->header.type) {
+		case PERF_EVENT_IP:
+		case PERF_EVENT_IP | __PERF_EVENT_TID:
+			process_event(event->ip, md->counter);
+			break;
+		}
 	}
 
 	md->prev = old;
@@ -1214,6 +1266,7 @@ int main(int argc, char *argv[])
 			hw_event.irq_period	= event_count[counter];
 			hw_event.record_type	= PERF_RECORD_IRQ;
 			hw_event.nmi		= nmi;
+			hw_event.include_tid	= 1;
 
 			fd[i][counter] = sys_perf_counter_open(&hw_event, tid, cpu, group_fd, 0);
 			if (fd[i][counter] < 0) {

-- 

