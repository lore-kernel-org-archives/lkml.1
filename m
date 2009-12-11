Return-Path: <linux-kernel-owner+w=401wt.eu-S1762396AbZLKEum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762396AbZLKEum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762301AbZLKEui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:50:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34001 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761324AbZLKEue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:50:34 -0500
X-Authority-Analysis: v=1.0 c=1 a=s9WF7PX5mecA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=zT-67OtNb6Dhs-qJ6ZcA:9 a=Q3d5x_9lSWY78BrlUkEA:7 a=C9di2kLXzIGydXDhVtrCkf2bYaUA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091211045040.002791834@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Dec 2009 23:50:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] [PATCH 2/2] ring-buffer: Move resize integrity check under reader lock
References: <20091211045003.107725797@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Move-resize-integrity-check-under-reader.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

While using an application that does splice on the ftrace ring
buffer at start up, I triggered an integrity check failure.

Looking into this, I discovered that resizing the buffer performs
an integrity check after the buffer is resized. This check unfortunately
is preformed after it releases the reader lock. If a reader is
reading the buffer it may cause the integrity check to trigger a
false failure.

This patch simply moves the integrity checker under the protection
of the ring buffer reader lock.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0d64c51..eccb4cf 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1208,9 +1208,9 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 		return;
 
 	rb_reset_cpu(cpu_buffer);
-	spin_unlock_irq(&cpu_buffer->reader_lock);
-
 	rb_check_pages(cpu_buffer);
+
+	spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
 static void
@@ -1233,9 +1233,9 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		list_add_tail(&bpage->list, cpu_buffer->pages);
 	}
 	rb_reset_cpu(cpu_buffer);
-	spin_unlock_irq(&cpu_buffer->reader_lock);
-
 	rb_check_pages(cpu_buffer);
+
+	spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
 /**
-- 
1.6.5


