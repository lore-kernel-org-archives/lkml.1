Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZKCLnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZKCLnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZKCLnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:43:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49213 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZKCLnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:43:20 -0500
Message-ID: <4AF01735.9060409@cn.fujitsu.com>
Date: Tue, 03 Nov 2009 19:42:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ringbuffer: synchronize for resizing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 63446f1..db223fe 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1196,6 +1196,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
+	spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1210,6 +1211,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 		return;
 
 	rb_reset_cpu(cpu_buffer);
+	spin_unlock_irq(&cpu_buffer->reader_lock);
 
 	rb_check_pages(cpu_buffer);
 



