Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0CMMZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:25:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:37743 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0CMMZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:25:08 -0500
Date: Sat, 13 Mar 2010 12:24:37 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com
In-Reply-To: <4B949E43.2010906@cn.fujitsu.com>
References: <4B949E43.2010906@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ring-buffer: Move disabled check into preempt disable section
Message-ID: <tip-52fbe9cde7fdb5c6fac196d7ebd2d92d05ef3cd4@git.kernel.org>
Git-Commit-ID: 52fbe9cde7fdb5c6fac196d7ebd2d92d05ef3cd4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 12:24:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52fbe9cde7fdb5c6fac196d7ebd2d92d05ef3cd4
Gitweb:     http://git.kernel.org/tip/52fbe9cde7fdb5c6fac196d7ebd2d92d05ef3cd4
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Mon, 8 Mar 2010 14:50:43 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 12 Mar 2010 20:26:56 -0500

ring-buffer: Move disabled check into preempt disable section

The ring buffer resizing and resetting relies on a schedule RCU
action. The buffers are disabled, a synchronize_sched() is called
and then the resize or reset takes place.

But this only works if the disabling of the buffers are within the
preempt disabled section, otherwise a window exists that the buffers
can be written to while a reset or resize takes place.

Cc: stable@kernel.org
Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B949E43.2010906@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8c1b2d2..54191d6 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2232,12 +2232,12 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return NULL;
 
-	if (atomic_read(&buffer->record_disabled))
-		return NULL;
-
 	/* If we are tracing schedule, we don't want to recurse */
 	resched = ftrace_preempt_disable();
 
+	if (atomic_read(&buffer->record_disabled))
+		goto out_nocheck;
+
 	if (trace_recursive_lock())
 		goto out_nocheck;
 
@@ -2469,11 +2469,11 @@ int ring_buffer_write(struct ring_buffer *buffer,
 	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return -EBUSY;
 
-	if (atomic_read(&buffer->record_disabled))
-		return -EBUSY;
-
 	resched = ftrace_preempt_disable();
 
+	if (atomic_read(&buffer->record_disabled))
+		goto out;
+
 	cpu = raw_smp_processor_id();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
