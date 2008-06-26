Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbYFZMjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbYFZMjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbYFZM32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:28 -0400
Received: from il.qumranet.com ([212.179.150.194]:32383 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYFZM2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Tan, Li" <li.tan@intel.com>
Subject: [PATCH 40/50] KVM: Support mixed endian machines
Date: Thu, 26 Jun 2008 15:28:22 +0300
Message-Id: <1214483312-9265-41-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tan, Li <li.tan@intel.com>

Currently kvmtrace is not portable. This will prevent from copying a
trace file from big-endian target to little-endian workstation for analysis.
In the patch, kernel outputs metadata containing a magic number to trace
log, and changes 64-bit words to be u64 instead of a pair of u32s.

Signed-off-by: Tan Li <li.tan@intel.com>
Acked-by: Jerone Young <jyoung5@us.ibm.com>
Acked-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h  |    4 ++--
 virt/kvm/kvm_trace.c |   18 ++++++++++++------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 1c908ac..0ea064c 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -318,14 +318,14 @@ struct kvm_trace_rec {
 	__u32 vcpu_id;
 	union {
 		struct {
-			__u32 cycle_lo, cycle_hi;
+			__u64 cycle_u64;
 			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
 		} cycle;
 		struct {
 			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
 		} nocycle;
 	} u;
-};
+} __attribute__((packed));
 
 #define KVMIO 0xAE
 
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
index 0e49547..58141f3 100644
--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -72,11 +72,7 @@ static void kvm_add_trace(void *probe_private, void *call_data,
 	rec.cycle_in 	= p->cycle_in;
 
 	if (rec.cycle_in) {
-		u64 cycle = 0;
-
-		cycle = get_cycles();
-		rec.u.cycle.cycle_lo = (u32)cycle;
-		rec.u.cycle.cycle_hi = (u32)(cycle >> 32);
+		rec.u.cycle.cycle_u64 = get_cycles();
 
 		for (i = 0; i < rec.extra_u32; i++)
 			rec.u.cycle.extra_u32[i] = va_arg(*args, u32);
@@ -114,8 +110,18 @@ static int kvm_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
 {
 	struct kvm_trace *kt;
 
-	if (!relay_buf_full(buf))
+	if (!relay_buf_full(buf)) {
+		if (!prev_subbuf) {
+			/*
+			 * executed only once when the channel is opened
+			 * save metadata as first record
+			 */
+			subbuf_start_reserve(buf, sizeof(u32));
+			*(u32 *)subbuf = 0x12345678;
+		}
+
 		return 1;
+	}
 
 	kt = buf->chan->private_data;
 	atomic_inc(&kt->lost_records);
-- 
1.5.6

