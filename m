Return-Path: <linux-kernel-owner+w=401wt.eu-S1752382AbXJUMNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbXJUMNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 08:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbXJUMNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 08:13:11 -0400
Received: from smtp2a.orange.fr ([80.12.242.139]:30204 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbXJUMNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 08:13:09 -0400
X-ME-UUID: 20071021121307130.1FEA3700008D@mwinf2a11.orange.fr
Date: Sun, 21 Oct 2007 14:08:42 +0200
From: Philippe Elie <phil.el@wanadoo.fr>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sami Farin <safari-kernel@safari.iki.fi>
Subject: [patch 1/2] oProfile: oops when profile_pc() return ~0LU
Message-ID: <20071021120842.GA2886@zaniah>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Elie <phil.el@wanadoo.fr>

Instruction pointer returned by profile_pc() can be a random value. This
break the assumption than we can safely set struct op_sample.eip field to
a magic value to signal to the per-cpu buffer reader side special event
like task switch ending up in a segfault in get_task_mm() when profile_pc()
return ~0UL. Fixed by exchanging the meaning of eip/event field for these
specials events.

Special thanks to Sami Farin who reported the oops and helped patiently
to narrow down the problem.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sami Farin <safari-kernel@safari.iki.fi>

---
 drivers/oprofile/buffer_sync.c |   12 ++++++------
 drivers/oprofile/cpu_buffer.c  |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

Beside Sami, Jesse Barnes already reported this bug two years ago
but I've been unable to understand it at this time.

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 8134c7e..7a4ccc7 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -514,21 +514,21 @@ void sync_buffer(int cpu)
 	for (i = 0; i < available; ++i) {
 		struct op_sample * s = &cpu_buf->buffer[cpu_buf->tail_pos];
  
-		if (is_code(s->eip)) {
-			if (s->event <= CPU_IS_KERNEL) {
+		if (is_code(s->event)) {
+			if (s->eip <= CPU_IS_KERNEL) {
 				/* kernel/userspace switch */
-				in_kernel = s->event;
+				in_kernel = s->eip;
 				if (state == sb_buffer_start)
 					state = sb_sample_start;
-				add_kernel_ctx_switch(s->event);
-			} else if (s->event == CPU_TRACE_BEGIN) {
+				add_kernel_ctx_switch(s->eip);
+			} else if (s->eip == CPU_TRACE_BEGIN) {
 				state = sb_bt_start;
 				add_trace_begin();
 			} else {
 				struct mm_struct * oldmm = mm;
 
 				/* userspace context switch */
-				new = (struct task_struct *)s->event;
+				new = (struct task_struct *)s->eip;
 
 				release_mm(oldmm);
 				mm = take_tasks_mm(new);
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index a83c3db..c856530 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -156,7 +156,7 @@ add_sample(struct oprofile_cpu_buffer * cpu_buf,
 static inline void
 add_code(struct oprofile_cpu_buffer * buffer, unsigned long value)
 {
-	add_sample(buffer, ESCAPE_CODE, value);
+	add_sample(buffer, value, ESCAPE_CODE);
 }
 
 /* This must be safe from any context. It's safe writing here

