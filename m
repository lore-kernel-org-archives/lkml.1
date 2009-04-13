Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZDMDBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZDMDBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbZDMDBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:01:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61105 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbZDMDBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:01:41 -0400
Message-ID: <49E2AAB3.9010801@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 11:00:03 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ring_buffer: enlarge RB_MAX_SMALL_DATA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I am writing userspace tools for ftrace, I found
RB_MAX_SMALL_DATA is too small, some events waste an 'u32'
to save the actually length.

This fix will break previous userspace tools,
so complaints are also welcome.
--------------

Subject: [PATCH] ring_buffer: enlarge RB_MAX_SMALL_DATA

Impact: save memory in ring_buffer

I found 28bytes for an event data is sometimes too small,
it will waste an 'u32' to save the actually length for
events which data size > 28.

'len=5' in the next logs means the event size is sizeof(u32)*5=20 bytes,
it includes event head and event data. This logs are collected
in 32bits system.

syscall tracer:
time_stamp=391042354662405, len=10
time_stamp=391042354679741, len=5
time_stamp=391042354686278, len=9
time_stamp=391042354691465, len=5
time_stamp=391042354695348, len=9
time_stamp=391042354698631, len=5
time_stamp=391042354703472, len=7
time_stamp=391042354756153, len=5
time_stamp=391042354766952, len=7
time_stamp=391042354790733, len=5
time_stamp=391042355124535, len=10
time_stamp=391042355136474, len=5
time_stamp=391042355141883, len=9
time_stamp=391042355146048, len=5
time_stamp=391042355149837, len=9
time_stamp=391042355152939, len=5
time_stamp=391042355157944, len=7
time_stamp=391042355194303, len=5
time_stamp=391042355200947, len=10
time_stamp=391042355690428, len=5
time_stamp=391042355700443, len=9

kmemtrace tracer:
time_stamp=391116237929771, len=6
time_stamp=391116237935560, len=6
time_stamp=391116237937269, len=6
time_stamp=391116649408762, len=11
time_stamp=391116649415541, len=11
time_stamp=391116649421702, len=11
time_stamp=391116649428121, len=6
time_stamp=391116649612696, len=6
time_stamp=391116649616327, len=6
time_stamp=391116649948694, len=11
time_stamp=391116650097324, len=11
time_stamp=391116650111344, len=11
time_stamp=391116650116344, len=6
time_stamp=391116656377385, len=11
time_stamp=391116656383258, len=11
time_stamp=391116656399858, len=11
time_stamp=391116656406757, len=6
time_stamp=391116657165045, len=11
time_stamp=391116657172126, len=11
time_stamp=391116657178716, len=11
time_stamp=391116657185031, len=6
time_stamp=391116657268110, len=6
time_stamp=391116657273307, len=6
time_stamp=391116657275341, len=6
time_stamp=391116657276638, len=6
time_stamp=391116657283869, len=6

sched_switch tracer:
time_stamp=391250280621660, len=9
time_stamp=391250281277013, len=9
time_stamp=391250281328332, len=9
time_stamp=391250600954274, len=9
time_stamp=391250601092171, len=9
time_stamp=391250601276548, len=9
time_stamp=391250601342968, len=9
time_stamp=391250601616099, len=9
time_stamp=391250602099709, len=9
time_stamp=391250603414452, len=9
time_stamp=391250605580652, len=9
time_stamp=391250605598567, len=9

function_graph tracer:
time_stamp=391216875265827, len=11
time_stamp=391216875270031, len=5
time_stamp=391216875272943, len=5
time_stamp=391216875275169, len=5
time_stamp=391216875279253, len=11
time_stamp=391216875282684, len=5
time_stamp=391216875291602, len=11
time_stamp=391216875294898, len=5

After this fix applied, function_graph tracer:

time_stamp=395685660789931, len=5
time_stamp=395685660792751, len=10
time_stamp=395685660795807, len=5
time_stamp=395685660798260, len=10
time_stamp=395685660801224, len=10
time_stamp=395685660804164, len=10
time_stamp=395685660807068, len=5
time_stamp=395685660809314, len=5
time_stamp=395685660812001, len=10
time_stamp=395685660815589, len=10
time_stamp=395685660823151, len=5
time_stamp=395685660825215, len=5
time_stamp=395685660827697, len=5
time_stamp=395685660829589, len=10
time_stamp=395685660833558, len=10
time_stamp=395685660836630, len=10

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 3d3ab00..5298ee1 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -13,7 +13,7 @@ struct ring_buffer_iter;
  */
 struct ring_buffer_event {
 	kmemcheck_define_bitfield(bitfield, {
-		u32		type:2, len:3, time_delta:27;
+		u32		type:2, len:4, time_delta:26;
 	});
 
 	u32		array[];
@@ -31,7 +31,7 @@ struct ring_buffer_event {
  *				  everything else same as RINGBUF_TYPE_DATA
  *
  * @RINGBUF_TYPE_TIME_EXTEND:	Extend the time delta
- *				 array[0] = time delta (28 .. 59)
+ *				 array[0] = time delta (27 .. 58)
  *				 size = 8 bytes
  *
  * @RINGBUF_TYPE_TIME_STAMP:	Sync time stamp with external clock
@@ -64,7 +64,7 @@ void *ring_buffer_event_data(struct ring_buffer_event *event);
  * ring_buffer_event_time_delta - return the delta timestamp of the event
  * @event: the event to get the delta timestamp of
  *
- * The delta timestamp is the 27 bit timestamp since the last event.
+ * The delta timestamp is the 26 bit timestamp since the last event.
  */
 static inline unsigned
 ring_buffer_event_time_delta(struct ring_buffer_event *event)
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e773c57..33bdde2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -183,7 +183,7 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
 
 #define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
 #define RB_ALIGNMENT		4U
-#define RB_MAX_SMALL_DATA	28
+#define RB_MAX_SMALL_DATA	60
 
 enum {
 	RB_LEN_TIME_EXTEND = 8,
@@ -285,7 +285,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 #define for_each_buffer_cpu(buffer, cpu)		\
 	for_each_cpu(cpu, buffer->cpumask)
 
-#define TS_SHIFT	27
+#define TS_SHIFT	26
 #define TS_MASK		((1ULL << TS_SHIFT) - 1)
 #define TS_DELTA_TEST	(~TS_MASK)
 
@@ -330,7 +330,7 @@ static void free_buffer_page(struct buffer_page *bpage)
 }
 
 /*
- * We need to fit the time_stamp delta into 27 bits.
+ * We need to fit the time_stamp delta into 26 bits.
  */
 static inline int test_time_stamp(u64 delta)
 {
@@ -1299,7 +1299,7 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 	static int once;
 	int ret;
 
-	if (unlikely(*delta > (1ULL << 59) && !once++)) {
+	if (unlikely(*delta > (1ULL << 58) && !once++)) {
 		printk(KERN_WARNING "Delta way too big! %llu"
 		       " ts=%llu write stamp = %llu\n",
 		       (unsigned long long)*delta,


