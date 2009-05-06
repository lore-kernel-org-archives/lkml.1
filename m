Return-Path: <linux-kernel-owner+w=401wt.eu-S1758882AbZEFE01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbZEFE01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZEFEXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:23:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZEFEXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:23:34 -0400
Message-Id: <20090506042334.272154001@goodmis.org>
References: <20090506042101.231470089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 00:21:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/11] ring-buffer: disable writers when resetting buffers
Content-Disposition: inline; filename=0007-ring-buffer-disable-writers-when-resetting-buffers.patch
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
index 9e42a74..7876df0 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2650,6 +2650,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
+	atomic_inc(&cpu_buffer->record_disabled);
+
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	__raw_spin_lock(&cpu_buffer->lock);
@@ -2659,6 +2661,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	__raw_spin_unlock(&cpu_buffer->lock);
 
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
+	atomic_dec(&cpu_buffer->record_disabled);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
-- 
1.6.2.4

-- 
