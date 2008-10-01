Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbYJAEjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbYJAEjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 00:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYJAEjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 00:39:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbYJAEjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 00:39:10 -0400
Message-Id: <20081001043908.122153176@goodmis.org>
References: <20081001042951.412019606@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Oct 2008 00:29:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Pekka Paalanen <pq@iki.fi>, Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Bligh <mbligh@google.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ring_buffer: remove raw from local_irq_save
Content-Disposition: inline; filename=ring-buffer-remove-raw.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The raw_local_irq_save causes issues with lockdep. We don't need it
so replace them with local_irq_save.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-01 00:04:39.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-01 00:05:07.000000000 -0400
@@ -847,7 +847,7 @@ ring_buffer_lock_reserve(struct ring_buf
 	if (atomic_read(&buffer->record_disabled))
 		return NULL;
 
-	raw_local_irq_save(*flags);
+	local_irq_save(*flags);
 	cpu = raw_smp_processor_id();
 
 	if (!cpu_isset(cpu, buffer->cpumask))
@@ -909,7 +909,7 @@ int ring_buffer_unlock_commit(struct rin
 	rb_commit(cpu_buffer, event);
 
 	spin_unlock(&cpu_buffer->lock);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
 	return 0;
 }
@@ -1583,13 +1583,13 @@ void ring_buffer_reset_cpu(struct ring_b
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	spin_lock(&cpu_buffer->lock);
 
 	rb_reset_cpu(cpu_buffer);
 
 	spin_unlock(&cpu_buffer->lock);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 }
 
 /**

-- 
