Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbYLKQyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbYLKQyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbYLKQtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:21 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:24455 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbYLKQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:49:18 -0500
X-BigFish: VPS24(z3335wz78fbpzzzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBQ1DK-01-7Q5-01
From: Robert Richter <robert.richter@amd.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 7/9] oprofile: remove nr_available_slots()
Date: Thu, 11 Dec 2008 17:42:01 +0100
Message-ID: <1229013723-8191-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:57.0150 (UTC) FILETIME=[5BEE85E0:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is no longer available after the port to the new ring
buffer. Its removal can lead to incomplete sampling sequences since
IBS samples and backtraces are transfered in multiple samples. Due to
a full buffer, samples could be lost any time. The userspace daemon
has to live with such incomplete sampling sequences as long as the
data within one sample is consistent.

This will be fixed by changing the internal buffer data there all data
of one IBS sample or a backtrace is packed in a single ring buffer
entry. This is possible since the new ring buffer supports variable
data size.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |   34 ----------------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index eb280ec..7f7fc95 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -145,18 +145,6 @@ void end_cpu_work(void)
 	flush_scheduled_work();
 }
 
-/* compute number of available slots in cpu_buffer queue */
-static unsigned long nr_available_slots(struct oprofile_cpu_buffer const *b)
-{
-	unsigned long head = b->head_pos;
-	unsigned long tail = b->tail_pos;
-
-	if (tail > head)
-		return (tail - head) - 1;
-
-	return tail + (b->buffer_size - head) - 1;
-}
-
 static inline void
 add_sample(struct oprofile_cpu_buffer *cpu_buf,
 	   unsigned long pc, unsigned long event)
@@ -206,11 +194,6 @@ static int log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
 		return 0;
 	}
 
-	if (nr_available_slots(cpu_buf) < 3) {
-		cpu_buf->sample_lost_overflow++;
-		return 0;
-	}
-
 	is_kernel = !!is_kernel;
 
 	task = current;
@@ -233,11 +216,6 @@ static int log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
 
 static int oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
 {
-	if (nr_available_slots(cpu_buf) < 4) {
-		cpu_buf->sample_lost_overflow++;
-		return 0;
-	}
-
 	add_code(cpu_buf, CPU_TRACE_BEGIN);
 	cpu_buf->tracing = 1;
 	return 1;
@@ -291,12 +269,6 @@ void oprofile_add_ibs_sample(struct pt_regs * const regs,
 
 	cpu_buf->sample_received++;
 
-	if (nr_available_slots(cpu_buf) < MAX_IBS_SAMPLE_SIZE) {
-		/* we can't backtrace since we lost the source of this event */
-		cpu_buf->sample_lost_overflow++;
-		return;
-	}
-
 	/* notice a switch from user->kernel or vice versa */
 	if (cpu_buf->last_is_kernel != is_kernel) {
 		cpu_buf->last_is_kernel = is_kernel;
@@ -342,12 +314,6 @@ void oprofile_add_trace(unsigned long pc)
 	if (!cpu_buf->tracing)
 		return;
 
-	if (nr_available_slots(cpu_buf) < 1) {
-		cpu_buf->tracing = 0;
-		cpu_buf->sample_lost_overflow++;
-		return;
-	}
-
 	/*
 	 * broken frame can give an eip with the same value as an
 	 * escape code, abort the trace if we get it
-- 
1.6.0.1


