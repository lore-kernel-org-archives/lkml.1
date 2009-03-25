Return-Path: <linux-kernel-owner+w=401wt.eu-S1761063AbZCYMIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063AbZCYMIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759802AbZCYMHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:07:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:57133 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760421AbZCYMHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:07:52 -0400
Date: Wed, 25 Mar 2009 12:07:11 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       arjan@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com,
       mingo@elte.hu
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, fengguang.wu@intel.com,
       mingo@elte.hu
In-Reply-To: <20090325113317.192910290@chello.nl>
References: <20090325113317.192910290@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: kerneltop: output event support
Message-ID: <tip-ee8ff2070444f88524ef89555e3996c8be44170d@git.kernel.org>
Git-Commit-ID: ee8ff2070444f88524ef89555e3996c8be44170d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 12:07:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee8ff2070444f88524ef89555e3996c8be44170d
Gitweb:     http://git.kernel.org/tip/ee8ff2070444f88524ef89555e3996c8be44170d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Mar 2009 12:30:27 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 13:02:53 +0100

perf_counter: kerneltop: output event support

Teach kerneltop about the new output ABI.

XXX: anybody fancy integrating the PID/TID data into the output?

Bump the mmap_data pages a little because we bloated the output and
have to be more careful about overruns with structured data.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
LKML-Reference: <20090325113317.192910290@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/kerneltop.c |   65 +++++++++++++++++++++++++++++---
 1 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index 3e45bf6..fda1438 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
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
 
@@ -1147,28 +1152,75 @@ static void mmap_read(struct mmap_data *md)
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
+
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
 
-		process_event(*ptr, md->counter);
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
