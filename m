Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbYIWN6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbYIWN6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYIWNsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:48:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52471 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbYIWNsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:48:17 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: [PATCH 19/40] KVM: kvmtrace: Remove use of bit fields in kvm trace structure
Date: Tue, 23 Sep 2008 16:46:33 +0300
Message-Id: <1222177614-26669-20-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

This patch fixes kvmtrace use on big endian systems. When using bit fields the
compiler will lay data out in the wrong order expected when laid down into a
file.
This fixes it by using one variable instead of using bit fields.

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h  |   17 ++++++++++++++---
 virt/kvm/kvm_trace.c |   17 +++++++++--------
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 8a3cead..8a16b08 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -311,9 +311,13 @@ struct kvm_s390_interrupt {
 
 /* This structure represents a single trace buffer record. */
 struct kvm_trace_rec {
-	__u32 event:28;
-	__u32 extra_u32:3;
-	__u32 cycle_in:1;
+	/* variable rec_val
+	 * is split into:
+	 * bits 0 - 27  -> event id
+	 * bits 28 -30  -> number of extra data args of size u32
+	 * bits 31      -> binary indicator for if tsc is in record
+	 */
+	__u32 rec_val;
 	__u32 pid;
 	__u32 vcpu_id;
 	union {
@@ -327,6 +331,13 @@ struct kvm_trace_rec {
 	} u;
 };
 
+#define TRACE_REC_EVENT_ID(val) \
+		(0x0fffffff & (val))
+#define TRACE_REC_NUM_DATA_ARGS(val) \
+		(0x70000000 & ((val) << 28))
+#define TRACE_REC_TCS(val) \
+		(0x80000000 & ((val) << 31))
+
 #define KVMIO 0xAE
 
 /*
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
index 58141f3..9acb78b 100644
--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -54,12 +54,13 @@ static void kvm_add_trace(void *probe_private, void *call_data,
 	struct kvm_trace *kt = kvm_trace;
 	struct kvm_trace_rec rec;
 	struct kvm_vcpu *vcpu;
-	int    i, extra, size;
+	int    i, size;
+	u32    extra;
 
 	if (unlikely(kt->trace_state != KVM_TRACE_STATE_RUNNING))
 		return;
 
-	rec.event	= va_arg(*args, u32);
+	rec.rec_val	= TRACE_REC_EVENT_ID(va_arg(*args, u32));
 	vcpu		= va_arg(*args, struct kvm_vcpu *);
 	rec.pid		= current->tgid;
 	rec.vcpu_id	= vcpu->vcpu_id;
@@ -67,21 +68,21 @@ static void kvm_add_trace(void *probe_private, void *call_data,
 	extra   	= va_arg(*args, u32);
 	WARN_ON(!(extra <= KVM_TRC_EXTRA_MAX));
 	extra 		= min_t(u32, extra, KVM_TRC_EXTRA_MAX);
-	rec.extra_u32   = extra;
 
-	rec.cycle_in 	= p->cycle_in;
+	rec.rec_val |= TRACE_REC_TCS(p->cycle_in)
+			| TRACE_REC_NUM_DATA_ARGS(extra);
 
-	if (rec.cycle_in) {
+	if (p->cycle_in) {
 		rec.u.cycle.cycle_u64 = get_cycles();
 
-		for (i = 0; i < rec.extra_u32; i++)
+		for (i = 0; i < extra; i++)
 			rec.u.cycle.extra_u32[i] = va_arg(*args, u32);
 	} else {
-		for (i = 0; i < rec.extra_u32; i++)
+		for (i = 0; i < extra; i++)
 			rec.u.nocycle.extra_u32[i] = va_arg(*args, u32);
 	}
 
-	size = calc_rec_size(rec.cycle_in, rec.extra_u32 * sizeof(u32));
+	size = calc_rec_size(p->cycle_in, extra * sizeof(u32));
 	relay_write(kt->rchan, &rec, size);
 }
 
-- 
1.6.0.1

