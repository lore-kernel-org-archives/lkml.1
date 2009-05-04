Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbZEDPWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbZEDPWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbZEDPUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:20:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45334 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156AbZEDPUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:20:21 -0400
Message-Id: <20090504152021.349097001@goodmis.org>
References: <20090504151933.728781787@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 04 May 2009 11:19:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/6] ring-buffer: disable writers when resetting buffers
Content-Disposition: inline; filename=0006-ring-buffer-disable-writers-when-resetting-buffers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As a precaution, it is best to disable writing to the ring buffers
when reseting them.

[ Impact: prevent weird things if write happens during reset ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7ff1f57..24372d1 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2649,6 +2649,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
+	atomic_inc(&cpu_buffer->record_disabled);
+
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	__raw_spin_lock(&cpu_buffer->lock);
@@ -2658,6 +2660,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	__raw_spin_unlock(&cpu_buffer->lock);
 
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
+	atomic_dec(&cpu_buffer->record_disabled);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
-- 
1.6.2.4

-- 
