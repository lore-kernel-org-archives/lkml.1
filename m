Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbYLKQwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbYLKQwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbYLKQtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:10 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:23712 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbYLKQtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:49:07 -0500
X-BigFish: VPS1(zzzzzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBQ1D6-02-VMO-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/10] oprofile: implement switch/case in buffer_sync.c
Date: Thu, 11 Dec 2008 16:04:43 +0100
Message-ID: <1229007886-14362-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
References: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:26.0948 (UTC) FILETIME=[49EE1040:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 774b081..7d61ae8 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -561,6 +561,7 @@ void sync_buffer(int cpu)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
 	struct mm_struct *mm = NULL;
+	struct mm_struct *oldmm;
 	struct task_struct *new;
 	unsigned long cookie = 0;
 	int in_kernel = 1;
@@ -586,34 +587,39 @@ void sync_buffer(int cpu)
 		struct op_sample *s = &cpu_buf->buffer[cpu_buf->tail_pos];
 
 		if (is_code(s->eip)) {
-			if (s->event <= CPU_IS_KERNEL) {
+			switch (s->event) {
+			case 0:
+			case CPU_IS_KERNEL:
 				/* kernel/userspace switch */
 				in_kernel = s->event;
 				if (state == sb_buffer_start)
 					state = sb_sample_start;
 				add_kernel_ctx_switch(s->event);
-			} else if (s->event == CPU_TRACE_BEGIN) {
+				break;
+			case CPU_TRACE_BEGIN:
 				state = sb_bt_start;
 				add_trace_begin();
+				break;
 #ifdef CONFIG_OPROFILE_IBS
-			} else if (s->event == IBS_FETCH_BEGIN) {
+			case IBS_FETCH_BEGIN:
 				state = sb_bt_start;
 				add_ibs_begin(cpu_buf, IBS_FETCH_CODE, mm);
-			} else if (s->event == IBS_OP_BEGIN) {
+				break;
+			case IBS_OP_BEGIN:
 				state = sb_bt_start;
 				add_ibs_begin(cpu_buf, IBS_OP_CODE, mm);
+				break;
 #endif
-			} else {
-				struct mm_struct *oldmm = mm;
-
+			default:
 				/* userspace context switch */
+				oldmm = mm;
 				new = (struct task_struct *)s->event;
-
 				release_mm(oldmm);
 				mm = take_tasks_mm(new);
 				if (mm != oldmm)
 					cookie = get_exec_dcookie(mm);
 				add_user_ctx_switch(new, cookie);
+				break;
 			}
 		} else if (state >= sb_bt_start &&
 			   !add_sample(mm, s, in_kernel)) {
-- 
1.6.0.1


