Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZHMUBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZHMUBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbZHMUBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:01:23 -0400
Received: from kroah.org ([198.145.64.141]:41991 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbZHMUAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:00:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:35 2009
Message-Id: <20090813195135.112037059@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 71/74] ring-buffer: Fix advance of reader in rb_buffer_peek()
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=ring-buffer-fix-advance-of-reader-in-rb_buffer_peek.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robert Richter <robert.richter@amd.com>

Backport for 2.6.30-stable of:

 469535a ring-buffer: Fix advance of reader in rb_buffer_peek()

When calling rb_buffer_peek() from ring_buffer_consume() and a
padding event is returned, the function rb_advance_reader() is
called twice. This may lead to missing samples or under high
workloads to the warning below. This patch fixes this. If a padding
event is returned by rb_buffer_peek() it will be consumed by the
calling function now.

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
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ring_buffer.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2102,7 +2102,6 @@ rb_buffer_peek(struct ring_buffer *buffe
 		 * the box. Return the padding, and we will release
 		 * the current locks, and try again.
 		 */
-		rb_advance_reader(cpu_buffer);
 		return event;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
@@ -2219,6 +2218,8 @@ ring_buffer_peek(struct ring_buffer *buf
  again:
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	event = rb_buffer_peek(buffer, cpu, ts);
+	if (event && event->type == RINGBUF_TYPE_PADDING)
+		rb_advance_reader(cpu_buffer);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	if (event && event->type == RINGBUF_TYPE_PADDING) {
@@ -2283,12 +2284,9 @@ ring_buffer_consume(struct ring_buffer *
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	event = rb_buffer_peek(buffer, cpu, ts);
-	if (!event)
-		goto out_unlock;
-
-	rb_advance_reader(cpu_buffer);
+	if (event)
+		rb_advance_reader(cpu_buffer);
 
- out_unlock:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
  out:


