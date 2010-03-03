Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab0CCAWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:22:19 -0500
Received: from smtp-out.google.com ([216.239.33.17]:22444 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0CCAWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:22:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=kL0eftIY+qfPIJ4NIYKGX8Q7Xh+tEtHLu+IlwMxfRZGB2BGERpdSQYlKJLISDndHw
	3vAjo+gYv3sWb0d32QqIw==
From: eranian@google.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, robert.richter@amd.com, eranian@gmail.com,
       davem@davemloft.net
Subject: [PATCH] perf_events: add sampling period randomization support (v2)
Date: Tue,  2 Mar 2010 16:21:45 -0800
Message-Id: <1267575705-10054-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.6.6.2
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for randomizing the sampling period.  Randomization
is very useful to mitigate the bias that exists with sampling. The random
number generator does not need to be sophisticated. This patch uses the
builtin random32() generator.

Randomization is activated by setting perf_event_attr.random_period_width
to a non-zero value. It represents the width of the mask to apply to the
random value, i.e, maximum range of variation. The random value is applied
AROUND the period, i.e., period may be longer or shorter with a maximum
variation of half the bit width. Thus, on average the sampling period remains
equal to the initial period passed in perf_event_attr.sample_period.

Note that randomization is not available when a target interrupt rate
(freq) is enabled.

The last used period can be collected using the PERF_SAMPLE_PERIOD flag
in sample_type.

Randomization is implemented in generic code thus it applies to all
PMU models and software events.

	Signed-off-by: Stephane Eranian <eranian@google.com>

--
 include/linux/perf_event.h |    3 +++
 kernel/perf_event.c        |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 04f06b4..9848e08 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -214,6 +214,8 @@ struct perf_event_attr {
 	__u32			bp_type;
 	__u64			bp_addr;
 	__u64			bp_len;
+
+	__u8			random_period_width;
 };
 
 /*
@@ -877,6 +879,7 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+extern void perf_randomize_event_period(struct perf_event *event);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a661e79..c581a99 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -30,6 +30,7 @@
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/random.h>
 
 #include <asm/irq_regs.h>
 
@@ -3866,6 +3867,9 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 	else
 		perf_event_output(event, nmi, data, regs);
 
+	if (event->attr.random_period_width)
+		perf_randomize_event_period(event);
+
 	return ret;
 }
 
@@ -3876,6 +3880,22 @@ int perf_event_overflow(struct perf_event *event, int nmi,
 	return __perf_event_overflow(event, nmi, 1, data, regs);
 }
 
+void perf_randomize_event_period(struct perf_event *event)
+{
+	u64 mask = ((1ULL << event->attr.random_period_width) - 1);
+	u64 new_seed;
+
+	new_seed = random32();
+
+	if (unlikely(mask >> 32))
+		new_seed |= (u64)random32() << 32;
+
+	event->hw.sample_period = event->attr.sample_period
+				+ (new_seed & mask) - (mask >> 1);
+
+	event->hw.last_period = event->hw.sample_period;
+}
+
 /*
  * Generic software event infrastructure
  */
@@ -4665,6 +4685,28 @@ done:
 	return event;
 }
 
+static int perf_check_random_period(struct perf_event_attr *attr)
+{
+	u8 width = attr->random_period_width;
+	u64 period = attr->sample_period;
+	u64 half;
+
+	if (width > 63 || attr->freq)
+		return -EINVAL;
+
+	half =  (1ULL << (width - 1)) - 1;
+
+	/* overflow */
+	if ((period + half) < period)
+		return -EINVAL;
+
+	/* underflow and zero */
+	if (period  <= half)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			  struct perf_event_attr *attr)
 {
@@ -4736,6 +4778,8 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (attr->read_format & ~(PERF_FORMAT_MAX-1))
 		return -EINVAL;
 
+	if (attr->random_period_width)
+		ret = perf_check_random_period(attr);
 out:
 	return ret;
 
