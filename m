Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZCEQVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZCEQVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZCEQVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:21:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38070 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZCEQVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:21:37 -0500
Date: Thu, 5 Mar 2009 11:21:33 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH][GIT PULL] add tracing_on/tracing_off to kernel.h
Message-ID: <alpine.DEB.2.00.0903051120110.26101@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      tracing: add tracing_on/tracing_off to kernel.h

----
 include/linux/kernel.h      |   29 ++++++++++++++++++++++++++++-
 include/linux/ring_buffer.h |   15 ---------------
 2 files changed, 28 insertions(+), 16 deletions(-)
---------------------------
commit 2002c258faaa8f89543df284fdbaa9e4b171547f
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Mar 5 10:35:56 2009 -0500

    tracing: add tracing_on/tracing_off to kernel.h
    
    Impact: cleanup
    
    The functions tracing_start/tracing_stop have been moved to kernel.h.
    These are not the functions a developer most likely wants to use
    when they want to insert a place to stop tracing and restart it from
    user space.
    
    tracing_start/tracing_stop was created to work with things like
    suspend to ram, where even calling smp_processor_id() can crash the
    system. The tracing_start/tracing_stop was used to stop the tracer from
    doing anything. These are still light weight functions, but add a bit
    more overhead to be able to stop the tracers. They also have no interface
    back to userland. That is, if the kernel calls tracing_stop, userland
    can not start tracing.
    
    What a developer most likely wants to use is tracing_on/tracing_off.
    These are very light weight functions (simply sets or clears a bit).
    These functions just stop recording into the ring buffer. The tracers
    don't even know that this happens except that they would receive NULL
    from the ring_buffer_lock_reserve function.
    
    Also, there's a way for the user land to enable or disable this bit.
    In debugfs/tracing/tracing_on, a user may echo "0" (same as tracing_off())
    or echo "1" (same as tracing_on()) into this file. This becomes handy when
    a kernel developer is debugging and wants tracing to turn off when it
    hits an anomaly. Then the developer can examine the trace, and restart
    tracing if they want to try again (echo 1 > tracing_on).
    
    This patch moves the prototypes for tracing_on/tracing_off to kernel.h
    and comments their use, so that a kernel developer will know how
    to use them.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 08bf5da..d4614a8 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -369,8 +369,35 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 
 /*
  * General tracing related utility functions - trace_printk(),
- * tracing_start()/tracing_stop:
+ * tracing_on/tracing_off and tracing_start()/tracing_stop
+ *
+ * Use tracing_on/tracing_off when you want to quickly turn on or off
+ * tracing. It simply enables or disables the recording of the trace events.
+ * This also corresponds to the user space debugfs/tracing/tracing_on
+ * file, which gives a means for the kernel and userspace to interact.
+ * Place a tracing_off() in the kernel where you want tracing to end.
+ * From user space, examine the trace, and then echo 1 > tracing_on
+ * to continue tracing.
+ *
+ * tracing_stop/tracing_start has slightly more overhead. It is used
+ * by things like suspend to ram where disabling the recording of the
+ * trace is not enough, but tracing must actually stop because things
+ * like calling smp_processor_id() may crash the system.
+ *
+ * Most likely, you want to use tracing_on/tracing_off.
  */
+#ifdef CONFIG_RING_BUFFER
+void tracing_on(void);
+void tracing_off(void);
+/* trace_off_permanent stops recording with no way to bring it back */
+void tracing_off_permanent(void);
+int tracing_is_on(void);
+#else
+static inline void tracing_on(void) { }
+static inline void tracing_off(void) { }
+static inline void tracing_off_permanent(void) { }
+static inline int tracing_is_on(void) { return 0; }
+#endif
 #ifdef CONFIG_TRACING
 extern void tracing_start(void);
 extern void tracing_stop(void);
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 79fcbc4..b1a0068 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -124,21 +124,6 @@ void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
 size_t ring_buffer_page_len(void *page);
 
 
-/*
- * The below functions are fine to use outside the tracing facility.
- */
-#ifdef CONFIG_RING_BUFFER
-void tracing_on(void);
-void tracing_off(void);
-void tracing_off_permanent(void);
-int tracing_is_on(void);
-#else
-static inline void tracing_on(void) { }
-static inline void tracing_off(void) { }
-static inline void tracing_off_permanent(void) { }
-static inline int tracing_is_on(void) { return 0; }
-#endif
-
 void *ring_buffer_alloc_read_page(struct ring_buffer *buffer);
 void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data);
 int ring_buffer_read_page(struct ring_buffer *buffer, void **data_page,

