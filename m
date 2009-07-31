Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZGaNQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZGaNQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZGaNQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:16:01 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:36780 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752665AbZGaNQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:16:01 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNNE61-03-UQG-01
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>, <stable@kernel.org>
Subject: [PATCH] ring-buffer: Fix advance of reader in rb_buffer_peek()
Date: Fri, 31 Jul 2009 14:56:03 +0200
Message-ID: <1249044963-26878-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.DEB.2.00.0907271601210.30108@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0907271601210.30108@gandalf.stny.rr.com>
X-OriginalArrivalTime: 31 Jul 2009 13:14:10.0864 (UTC) FILETIME=[CAF15300:01CA11E0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling rb_buffer_peek() from ring_buffer_consume() and a padding
event is returned, the function rb_advance_reader() is called
twice. This may lead to missing samples or under high workloads to the
warning below. This patch fixes this. If a padding event is returned
by rb_buffer_peek() it will be consumed by the calling function now.

Also, I simplified some code in ring_buffer_consume().

------------[ cut here ]------------
WARNING: at /dev/shm/.source/linux/kernel/trace/ring_buffer.c:2289 rb_advance_reader+0x2e/0xc5()
Hardware name: Anaheim
Modules linked in:
Pid: 29, comm: events/2 Tainted: G        W  2.6.31-rc3-oprofile-x86_64-standard-00059-g5050dc2 #1
Call Trace:
[<ffffffff8106776f>] ? rb_advance_reader+0x2e/0xc5
[<ffffffff81039ffe>] warn_slowpath_common+0x77/0x8f
[<ffffffff8103a025>] warn_slowpath_null+0xf/0x11
[<ffffffff8106776f>] rb_advance_reader+0x2e/0xc5
[<ffffffff81068bda>] ring_buffer_consume+0xa0/0xd2
[<ffffffff81326933>] op_cpu_buffer_read_entry+0x21/0x9e
[<ffffffff810be3af>] ? __find_get_block+0x4b/0x165
[<ffffffff8132749b>] sync_buffer+0xa5/0x401
[<ffffffff810be3af>] ? __find_get_block+0x4b/0x165
[<ffffffff81326c1b>] ? wq_sync_buffer+0x0/0x78
[<ffffffff81326c76>] wq_sync_buffer+0x5b/0x78
[<ffffffff8104aa30>] worker_thread+0x113/0x1ac
[<ffffffff8104dd95>] ? autoremove_wake_function+0x0/0x38
[<ffffffff8104a91d>] ? worker_thread+0x0/0x1ac
[<ffffffff8104dc9a>] kthread+0x88/0x92
[<ffffffff8100bdba>] child_rip+0xa/0x20
[<ffffffff8104dc12>] ? kthread+0x0/0x92
[<ffffffff8100bdb0>] ? child_rip+0x0/0x20
---[ end trace f561c0a58fcc89bd ]---

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@kernel.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 kernel/trace/ring_buffer.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bf27bb7..6eb8b97 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2383,7 +2383,6 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 		 * the box. Return the padding, and we will release
 		 * the current locks, and try again.
 		 */
-		rb_advance_reader(cpu_buffer);
 		return event;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
@@ -2519,6 +2518,8 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
 	event = rb_buffer_peek(buffer, cpu, ts);
+	if (event && event->type_len == RINGBUF_TYPE_PADDING)
+		rb_advance_reader(cpu_buffer);
 	if (dolock)
 		spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
@@ -2590,12 +2591,9 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 		spin_lock(&cpu_buffer->reader_lock);
 
 	event = rb_buffer_peek(buffer, cpu, ts);
-	if (!event)
-		goto out_unlock;
-
-	rb_advance_reader(cpu_buffer);
+	if (event)
+		rb_advance_reader(cpu_buffer);
 
- out_unlock:
 	if (dolock)
 		spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
-- 
1.6.3.3


