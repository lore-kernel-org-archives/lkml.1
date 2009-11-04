Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZKDLKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZKDLKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZKDLKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:10:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:39722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbZKDLKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:10:14 -0500
Date: Wed, 4 Nov 2009 11:09:43 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
       laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <4AF01735.9060409@cn.fujitsu.com>
References: <4AF01735.9060409@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ring-buffer: Synchronize resizing buffer with reader lock
Message-ID: <tip-f7112949f6a4cd6883d66c882d568c2197321de6@git.kernel.org>
Git-Commit-ID: f7112949f6a4cd6883d66c882d568c2197321de6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7112949f6a4cd6883d66c882d568c2197321de6
Gitweb:     http://git.kernel.org/tip/f7112949f6a4cd6883d66c882d568c2197321de6
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 3 Nov 2009 19:42:45 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 4 Nov 2009 00:04:20 -0500

ring-buffer: Synchronize resizing buffer with reader lock

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
 
