Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbZKDGtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbZKDGtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZKDGss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:48:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZKDGsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:48:46 -0500
Message-Id: <20091104064850.522343875@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 04 Nov 2009 01:48:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2] [PATCH 1/2] ring-buffer: Synchronize resizing buffer with reader lock
References: <20091104064825.546743711@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Synchronize-resizing-buffer-with-reader-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

We got a sudden panic when we reduced the size of the
ringbuffer.

We can reproduce the panic by the following steps:

echo 1 > events/sched/enable
cat trace_pipe > /dev/null &

while ((1))
do
echo 12000 > buffer_size_kb
echo 512 > buffer_size_kb
done

(not more than 5 seconds, panic ...)

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4AF01735.9060409@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3ffa502..5dd017f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1193,6 +1193,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
+	spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1207,6 +1208,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 		return;
 
 	rb_reset_cpu(cpu_buffer);
+	spin_unlock_irq(&cpu_buffer->reader_lock);
 
 	rb_check_pages(cpu_buffer);
 
-- 
1.6.3.3


