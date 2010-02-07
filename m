Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab0BGLcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:32:20 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:39618 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab0BGLbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:31:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fEpIuS80uaHOCEsFRgZttdu2d/r1CkUGOPqcyvly3EK3/k+Cknmg0fX2/DlcTcTFBa
         rs5Omf7eL1R+Pl2ggUCGwCVjhe9IVZGjCVISHUWylaU/wpzbQ4uaMoaCGqnDDzmWRlw0
         DMoWx5Ja51pI3kCNpIXSTv1yi4z8dQGykB2GQ=
From: highguy@gmail.com
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       andrea@suse.de, tglx@linutronix.de, akpm@linux-foundation.org,
       peterz@infradead.org, Stijn Devriendt <stijn@stijn.telenet.be>
Subject: [PATCH 2/6] Allow min/max thresholds for wakeups
Date: Sun,  7 Feb 2010 12:30:55 +0100
Message-Id: <1265542259-5596-3-git-send-email-HIGHGuY@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265542259-5596-2-git-send-email-HIGHGuY@gmail.com>
References: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-2-git-send-email-HIGHGuY@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stijn Devriendt <stijn@stijn.telenet.be>

---
 include/linux/perf_event.h |    5 +++--
 kernel/perf_event.c        |   28 ++++++++++++++++++++++++----
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 827a221..0fa235e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -183,6 +183,7 @@ struct perf_event_attr {
 	union {
 		__u64		sample_period;
 		__u64		sample_freq;
+		__u64           max_threshold;        /* maximum threshold     */
 	};
 
 	__u64			sample_type;
@@ -203,16 +204,16 @@ struct perf_event_attr {
 				enable_on_exec :  1, /* next exec enables     */
 				task           :  1, /* trace fork/exit       */
 				watermark      :  1, /* wakeup_watermark      */
+				threshold      :  1, /* tresholds             */
 
 				__reserved_1   : 49;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
 		__u32		wakeup_watermark; /* bytes before wakeup   */
+		__u64           min_threshold;    /* minimum threshold     */
 	};
 
-	__u32			__reserved_2;
-
 	__u64			bp_addr;
 	__u32			bp_type;
 	__u32			bp_len;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 42dc18d..70ca6e1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1401,6 +1401,8 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 		if (!event->attr.freq || !event->attr.sample_freq)
 			continue;
 
+		if (event->attr.threshold)
+			continue;
 		/*
 		 * if the specified freq < HZ then we need to skip ticks
 		 */
@@ -1921,6 +1923,15 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	struct perf_event *event = file->private_data;
 	unsigned int events = atomic_xchg(&event->poll, 0);
 
+	if (event->attr.threshold)
+	{
+		u64 count = atomic64_read(&event->count);
+		if (count < event->attr.min_threshold)
+			events |= POLLIN;
+		else if (count > event->attr.max_threshold)
+			events &= ~POLLIN;
+	}
+
 	poll_wait(file, &event->waitq, wait);
 
 	return events;
@@ -1979,6 +1990,9 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
 	if (!event->attr.sample_period)
 		return -EINVAL;
 
+	if (event->attr.threshold)
+		return -EINVAL;
+
 	size = copy_from_user(&value, arg, sizeof(value));
 	if (size != sizeof(value))
 		return -EFAULT;
@@ -2675,6 +2689,9 @@ static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
 
 static void __perf_output_wakeup(struct perf_event* event, int nmi)
 {
+	if (event->attr.threshold && atomic64_read(&event->count) > event->attr.max_threshold)
+		return;
+	
 	atomic_set(&event->poll, POLLIN);
 
 	if (nmi) {
@@ -2895,7 +2912,7 @@ void perf_output_end(struct perf_output_handle *handle)
 	struct perf_event *event = handle->event;
 	struct perf_mmap_data *data = handle->data;
 
-	int wakeup_events = event->attr.wakeup_events;
+	int wakeup_events = event->attr.thresold ? 1 : event->attr.wakeup_events;
 
 	if (handle->sample && wakeup_events) {
 		int events = atomic_inc_return(&data->events);
@@ -4445,7 +4462,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 
 	hwc = &event->hw;
 	hwc->sample_period = attr->sample_period;
-	if (attr->freq && attr->sample_freq)
+	if (attr->threshold || (attr->freq && attr->sample_freq))
 		hwc->sample_period = 1;
 	hwc->last_period = hwc->sample_period;
 
@@ -4571,7 +4588,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (attr->type >= PERF_TYPE_MAX)
 		return -EINVAL;
 
-	if (attr->__reserved_1 || attr->__reserved_2)
+	if (attr->__reserved_1)
 		return -EINVAL;
 
 	if (attr->sample_type & ~(PERF_SAMPLE_MAX-1))
@@ -4674,6 +4691,9 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EACCES;
 	}
 
+	if (attr.threshold && (attr.freq || attr.watermark))
+		return -EINVAL;
+	
 	if (attr.freq) {
 		if (attr.sample_freq > sysctl_perf_event_sample_rate)
 			return -EINVAL;
@@ -4862,7 +4882,7 @@ inherit_event(struct perf_event *parent_event,
 	else
 		child_event->state = PERF_EVENT_STATE_OFF;
 
-	if (parent_event->attr.freq)
+	if (parent_event->attr.freq || parent_event->attr.threshold)
 		child_event->hw.sample_period = parent_event->hw.sample_period;
 
 	child_event->overflow_handler = parent_event->overflow_handler;
-- 
1.6.6

