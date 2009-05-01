Return-Path: <linux-kernel-owner+w=401wt.eu-S1758407AbZEAK1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbZEAK1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 06:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbZEAK0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 06:26:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbZEAK0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 06:26:15 -0400
Message-Id: <20090501102533.296727903@chello.nl>
References: <20090501102315.367605848@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 01 May 2009 12:23:19 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] perf_counter: documetation update
Content-Disposition: inline; filename=perf_counter-doc.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation to reflect the current state of affairs

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/design.txt |  272 +++++++++++++++++++++++++++-------
 1 file changed, 219 insertions(+), 53 deletions(-)

Index: linux-2.6/Documentation/perf_counter/design.txt
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/design.txt
+++ linux-2.6/Documentation/perf_counter/design.txt
@@ -34,41 +34,47 @@ can be poll()ed.
 
 When creating a new counter fd, 'perf_counter_hw_event' is:
 
-/*
- * Event to monitor via a performance monitoring counter:
- */
 struct perf_counter_hw_event {
-	__u64			event_config;
-
-	__u64			irq_period;
-	__u64			record_type;
-	__u64			read_format;
+        /*
+         * The MSB of the config word signifies if the rest contains cpu
+         * specific (raw) counter configuration data, if unset, the next
+         * 7 bits are an event type and the rest of the bits are the event
+         * identifier.
+         */
+        __u64                   config;
+
+        __u64                   irq_period;
+        __u32                   record_type;
+        __u32                   read_format;
+
+        __u64                   disabled       :  1, /* off by default        */
+                                nmi            :  1, /* NMI sampling          */
+                                inherit        :  1, /* children inherit it   */
+                                pinned         :  1, /* must always be on PMU */
+                                exclusive      :  1, /* only group on PMU     */
+                                exclude_user   :  1, /* don't count user      */
+                                exclude_kernel :  1, /* ditto kernel          */
+                                exclude_hv     :  1, /* ditto hypervisor      */
+                                exclude_idle   :  1, /* don't count when idle */
+                                mmap           :  1, /* include mmap data     */
+                                munmap         :  1, /* include munmap data   */
+                                comm           :  1, /* include comm data     */
 
-	__u64			disabled       :  1, /* off by default        */
-				nmi	       :  1, /* NMI sampling          */
-				inherit	       :  1, /* children inherit it   */
-				pinned	       :  1, /* must always be on PMU */
-				exclusive      :  1, /* only group on PMU     */
-				exclude_user   :  1, /* don't count user      */
-				exclude_kernel :  1, /* ditto kernel          */
-				exclude_hv     :  1, /* ditto hypervisor      */
-				exclude_idle   :  1, /* don't count when idle */
+                                __reserved_1   : 52;
 
-				__reserved_1   : 55;
+        __u32                   extra_config_len;
+        __u32                   wakeup_events;  /* wakeup every n events */
 
-	__u32			extra_config_len;
-
-	__u32			__reserved_4;
-	__u64			__reserved_2;
-	__u64			__reserved_3;
+        __u64                   __reserved_2;
+        __u64                   __reserved_3;
 };
 
-The 'event_config' field specifies what the counter should count.  It
+The 'config' field specifies what the counter should count.  It
 is divided into 3 bit-fields:
 
-raw_type: 1 bit (most significant bit)		0x8000_0000_0000_0000
-type:	  7 bits (next most significant)	0x7f00_0000_0000_0000
-event_id: 56 bits (least significant)		0x00ff_0000_0000_0000
+raw_type: 1 bit   (most significant bit)	0x8000_0000_0000_0000
+type:	  7 bits  (next most significant)	0x7f00_0000_0000_0000
+event_id: 56 bits (least significant)		0x00ff_ffff_ffff_ffff
 
 If 'raw_type' is 1, then the counter will count a hardware event
 specified by the remaining 63 bits of event_config.  The encoding is
@@ -134,41 +140,56 @@ enum sw_event_ids {
 	PERF_COUNT_PAGE_FAULTS_MAJ	= 6,
 };
 
+Counters of the type PERF_TYPE_TRACEPOINT are available when the ftrace event
+tracer is available, and event_id values can be obtained from
+/debug/tracing/events/*/*/id
+
+
 Counters come in two flavours: counting counters and sampling
 counters.  A "counting" counter is one that is used for counting the
 number of events that occur, and is characterised by having
-irq_period = 0 and record_type = PERF_RECORD_SIMPLE.  A read() on a
-counting counter simply returns the current value of the counter as
-an 8-byte number.
+irq_period = 0.
+
+
+A read() on a counter returns the current value of the counter and possible
+additional values as specified by 'read_format', each value is a u64 (8 bytes)
+in size.
+
+/*
+ * Bits that can be set in hw_event.read_format to request that
+ * reads on the counter should return the indicated quantities,
+ * in increasing order of bit value, after the counter value.
+ */
+enum perf_counter_read_format {
+        PERF_FORMAT_TOTAL_TIME_ENABLED  =  1,
+        PERF_FORMAT_TOTAL_TIME_RUNNING  =  2,
+};
+
+Using these additional values one can establish the overcommit ratio for a
+particular counter allowing one to take the round-robin scheduling effect
+into account.
+
 
 A "sampling" counter is one that is set up to generate an interrupt
 every N events, where N is given by 'irq_period'.  A sampling counter
-has irq_period > 0 and record_type != PERF_RECORD_SIMPLE.  The
-record_type controls what data is recorded on each interrupt, and the
-available values are currently:
+has irq_period > 0. The record_type controls what data is recorded on each
+interrupt:
 
 /*
- * IRQ-notification data record type:
+ * Bits that can be set in hw_event.record_type to request information
+ * in the overflow packets.
  */
-enum perf_counter_record_type {
-	PERF_RECORD_SIMPLE		= 0,
-	PERF_RECORD_IRQ			= 1,
-	PERF_RECORD_GROUP		= 2,
-};
-
-A record_type value of PERF_RECORD_IRQ will record the instruction
-pointer (IP) at which the interrupt occurred.  A record_type value of
-PERF_RECORD_GROUP will record the event_config and counter value of
-all of the other counters in the group, and should only be used on a
-group leader (see below).  Currently these two values are mutually
-exclusive, but record_type will become a bit-mask in future and
-support other values.
-
-A sampling counter has an event queue, into which an event is placed
-on each interrupt.  A read() on a sampling counter will read the next
-event from the event queue.  If the queue is empty, the read() will
-either block or return an EAGAIN error, depending on whether the fd
-has been set to non-blocking mode or not.
+enum perf_counter_record_format {
+        PERF_RECORD_IP          = 1U << 0,
+        PERF_RECORD_TID         = 1U << 1,
+        PERF_RECORD_TIME        = 1U << 2,
+        PERF_RECORD_ADDR        = 1U << 3,
+        PERF_RECORD_GROUP       = 1U << 4,
+        PERF_RECORD_CALLCHAIN   = 1U << 5,
+};
+
+Such (and other) events will be recorded in a ring-buffer, which is
+available to user-space using mmap() (see below).
 
 The 'disabled' bit specifies whether the counter starts out disabled
 or enabled.  If it is initially disabled, it can be enabled by ioctl
@@ -206,6 +227,13 @@ The 'exclude_user', 'exclude_kernel' and
 way to request that counting of events be restricted to times when the
 CPU is in user, kernel and/or hypervisor mode.
 
+The 'mmap' and 'munmap' bits allow recording of PROT_EXEC mmap/munmap
+operations, these can be used to relate userspace IP addresses to actual
+code, even after the mapping (or even the whole process) is gone,
+these events are recorded in the ring-buffer (see below).
+
+The 'comm' bit allows tracking of process comm data on process creation.
+This too is recorded in the ring-buffer (see below).
 
 The 'pid' parameter to the perf_counter_open() system call allows the
 counter to be specific to a task:
@@ -250,6 +278,138 @@ can be meaningfully compared, added, div
 with each other, since they have counted events for the same set of
 executed instructions.
 
+
+Like stated, asynchronous events, like counter overflow or PROT_EXEC mmap
+tracking are logged into a ring-buffer. This ring-buffer is created and
+accessed through mmap().
+
+The mmap size should be 1+2^n pages, where the first page is a meta-data page
+(struct perf_counter_mmap_page) that contains various bits of information such
+as where the ring-buffer head is.
+
+/*
+ * Structure of the page that can be mapped via mmap
+ */
+struct perf_counter_mmap_page {
+        __u32   version;                /* version number of this structure */
+        __u32   compat_version;         /* lowest version this is compat with */
+
+        /*
+         * Bits needed to read the hw counters in user-space.
+         *
+         *   u32 seq;
+         *   s64 count;
+         *
+         *   do {
+         *     seq = pc->lock;
+         *
+         *     barrier()
+         *     if (pc->index) {
+         *       count = pmc_read(pc->index - 1);
+         *       count += pc->offset;
+         *     } else
+         *       goto regular_read;
+         *
+         *     barrier();
+         *   } while (pc->lock != seq);
+         *
+         * NOTE: for obvious reason this only works on self-monitoring
+         *       processes.
+         */
+        __u32   lock;                   /* seqlock for synchronization */
+        __u32   index;                  /* hardware counter identifier */
+        __s64   offset;                 /* add to hardware counter value */
+
+        /*
+         * Control data for the mmap() data buffer.
+         *
+         * User-space reading this value should issue an rmb(), on SMP capable
+         * platforms, after reading this value -- see perf_counter_wakeup().
+         */
+        __u32   data_head;              /* head in the data section */
+};
+
+NOTE: the hw-counter userspace bits are arch specific and are currently only
+      implemented on powerpc.
+
+The following 2^n pages are the ring-buffer which contains events of the form:
+
+#define PERF_EVENT_MISC_KERNEL          (1 << 0)
+#define PERF_EVENT_MISC_USER            (1 << 1)
+#define PERF_EVENT_MISC_OVERFLOW        (1 << 2)
+
+struct perf_event_header {
+        __u32   type;
+        __u16   misc;
+        __u16   size;
+};
+
+enum perf_event_type {
+
+        /*
+         * The MMAP events record the PROT_EXEC mappings so that we can
+         * correlate userspace IPs to code. They have the following structure:
+         *
+         * struct {
+         *      struct perf_event_header        header;
+         *
+         *      u32                             pid, tid;
+         *      u64                             addr;
+         *      u64                             len;
+         *      u64                             pgoff;
+         *      char                            filename[];
+         * };
+         */
+        PERF_EVENT_MMAP                 = 1,
+        PERF_EVENT_MUNMAP               = 2,
+
+        /*
+         * struct {
+         *      struct perf_event_header        header;
+         *
+         *      u32                             pid, tid;
+         *      char                            comm[];
+         * };
+         */
+        PERF_EVENT_COMM                 = 3,
+
+        /*
+         * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
+         * will be PERF_RECORD_*
+         *
+         * struct {
+         *      struct perf_event_header        header;
+         *
+         *      { u64                   ip;       } && PERF_RECORD_IP
+         *      { u32                   pid, tid; } && PERF_RECORD_TID
+         *      { u64                   time;     } && PERF_RECORD_TIME
+         *      { u64                   addr;     } && PERF_RECORD_ADDR
+         *
+         *      { u64                   nr;
+         *        { u64 event, val; }   cnt[nr];  } && PERF_RECORD_GROUP
+         *
+         *      { u16                   nr,
+         *                              hv,
+         *                              kernel,
+         *                              user;
+         *        u64                   ips[nr];  } && PERF_RECORD_CALLCHAIN
+         * };
+         */
+};
+
+NOTE: PERF_RECORD_CALLCHAIN is arch specific and currently only implemented
+      on x86.
+
+Notification of new events is possible through poll()/select()/epoll() and
+fcntl() managing signals.
+
+Normally a notification is generated for every page filled, however one can
+additionally set perf_counter_hw_event.wakeup_events to generate one every
+so many counter overflow events.
+
+Future work will include a splice() interface to the ring-buffer.
+
+
 Counters can be enabled and disabled in two ways: via ioctl and via
 prctl.  When a counter is disabled, it doesn't count or generate
 events but does continue to exist and maintain its count value.
@@ -269,6 +429,12 @@ group other than the leader only affects
 non-leader stops that counter from counting but doesn't affect any
 other counter.
 
+Additionally, non-inherited overflow counters can use
+
+	ioctl(fd, PERF_COUNTER_IOC_REFRESH, nr);
+
+to enable a counter for 'nr' events, after which it gets disabled again.
+
 A process can enable or disable all the counter groups that are
 attached to it, using prctl:
 

-- 

