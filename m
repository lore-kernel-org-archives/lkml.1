Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZKAP0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZKAP0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 10:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZKAP0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 10:26:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60937 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbZKAP0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 10:26:38 -0500
Date: Sun, 1 Nov 2009 16:26:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20091101152637.GA17882@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Jiri Olsa (4):
      tracing: Update *ppos instead of filp->f_pos
      tracing: Fix trace_seq_printf() return value
      tracing: Fix comment typo and documentation example
      tracing: Remove cpu arg from the rb_time_stamp() function


 Documentation/trace/ftrace.txt |    2 ++
 include/linux/trace_seq.h      |    2 +-
 kernel/trace/ftrace.c          |    2 +-
 kernel/trace/ring_buffer.c     |   12 ++++++------
 kernel/trace/trace.c           |    8 ++++----
 kernel/trace/trace_output.c    |    5 ++++-
 6 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 957b22f..8179692 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1231,6 +1231,7 @@ something like this simple program:
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include <string.h>
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
@@ -1265,6 +1266,7 @@ const char *find_debugfs(void)
                return NULL;
        }
 
+       strcat(debugfs, "/tracing/");
        debugfs_found = 1;
 
        return debugfs;
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index c134dd1..09077f6 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -7,7 +7,7 @@
 
 /*
  * Trace sequences are used to allow a function to call several other functions
- * to create a string of data to use (up to a max of PAGE_SIZE.
+ * to create a string of data to use (up to a max of PAGE_SIZE).
  */
 
 struct trace_seq {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 37ba67e..9c451a1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -740,7 +740,7 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
  out:
 	mutex_unlock(&ftrace_profile_lock);
 
-	filp->f_pos += cnt;
+	*ppos += cnt;
 
 	return cnt;
 }
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d4ff019..3ffa502 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -483,7 +483,7 @@ struct ring_buffer_iter {
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
 
-static inline u64 rb_time_stamp(struct ring_buffer *buffer, int cpu)
+static inline u64 rb_time_stamp(struct ring_buffer *buffer)
 {
 	/* shift to debug/test normalization and TIME_EXTENTS */
 	return buffer->clock() << DEBUG_SHIFT;
@@ -494,7 +494,7 @@ u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
 	u64 time;
 
 	preempt_disable_notrace();
-	time = rb_time_stamp(buffer, cpu);
+	time = rb_time_stamp(buffer);
 	preempt_enable_no_resched_notrace();
 
 	return time;
@@ -599,7 +599,7 @@ static struct list_head *rb_list_head(struct list_head *list)
 }
 
 /*
- * rb_is_head_page - test if the give page is the head page
+ * rb_is_head_page - test if the given page is the head page
  *
  * Because the reader may move the head_page pointer, we can
  * not trust what the head page is (it may be pointing to
@@ -1868,7 +1868,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		 * Nested commits always have zero deltas, so
 		 * just reread the time stamp
 		 */
-		*ts = rb_time_stamp(buffer, cpu_buffer->cpu);
+		*ts = rb_time_stamp(buffer);
 		next_page->page->time_stamp = *ts;
 	}
 
@@ -2111,7 +2111,7 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 1000))
 		goto out_fail;
 
-	ts = rb_time_stamp(cpu_buffer->buffer, cpu_buffer->cpu);
+	ts = rb_time_stamp(cpu_buffer->buffer);
 
 	/*
 	 * Only the first commit can update the timestamp.
@@ -2681,7 +2681,7 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 EXPORT_SYMBOL_GPL(ring_buffer_entries);
 
 /**
- * ring_buffer_overrun_cpu - get the number of overruns in buffer
+ * ring_buffer_overruns - get the number of overruns in buffer
  * @buffer: The ring buffer
  *
  * Returns the total number of overruns in the ring buffer
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c820b03..b20d3ec 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2440,7 +2440,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 			return ret;
 	}
 
-	filp->f_pos += cnt;
+	*ppos += cnt;
 
 	return cnt;
 }
@@ -2582,7 +2582,7 @@ tracing_ctrl_write(struct file *filp, const char __user *ubuf,
 	}
 	mutex_unlock(&trace_types_lock);
 
-	filp->f_pos += cnt;
+	*ppos += cnt;
 
 	return cnt;
 }
@@ -2764,7 +2764,7 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 	if (err)
 		return err;
 
-	filp->f_pos += ret;
+	*ppos += ret;
 
 	return ret;
 }
@@ -3299,7 +3299,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 		}
 	}
 
-	filp->f_pos += cnt;
+	*ppos += cnt;
 
 	/* If check pages failed, return ENOMEM */
 	if (tracing_disabled)
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ed17565..b6c12c6 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -69,6 +69,9 @@ enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
  * @s: trace sequence descriptor
  * @fmt: printf format string
  *
+ * It returns 0 if the trace oversizes the buffer's free
+ * space, 1 otherwise.
+ *
  * The tracer may use either sequence operations or its own
  * copy to user routines. To simplify formating of a trace
  * trace_seq_printf is used to store strings into a special
@@ -95,7 +98,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 
 	s->len += ret;
 
-	return len;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
