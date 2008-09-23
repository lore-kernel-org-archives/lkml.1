Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYIWN4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYIWN4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYIWNsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:48:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52436 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbYIWNrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:53 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: [PATCH 20/40] KVM: kvmtrace: replace get_cycles with ktime_get v3
Date: Tue, 23 Sep 2008 16:46:34 +0300
Message-Id: <1222177614-26669-21-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

The current kvmtrace code uses get_cycles() while the interpretation would be
easier using using nanoseconds. ktime_get() should give at least the same
accuracy as get_cycles on all architectures (even better on 32bit archs) but
at a better unit (e.g. comparable between hosts with different frequencies.

[avi: avoid ktime_t in public header]

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h  |    6 +++---
 virt/kvm/kvm_trace.c |   19 ++++++++++---------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 8a16b08..5d08f11 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -322,12 +322,12 @@ struct kvm_trace_rec {
 	__u32 vcpu_id;
 	union {
 		struct {
-			__u64 cycle_u64;
+			__u64 timestamp;
 			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
-		} __attribute__((packed)) cycle;
+		} __attribute__((packed)) timestamp;
 		struct {
 			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
-		} nocycle;
+		} notimestamp;
 	} u;
 };
 
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
index 9acb78b..41dcc84 100644
--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/relay.h>
 #include <linux/debugfs.h>
+#include <linux/ktime.h>
 
 #include <linux/kvm_host.h>
 
@@ -35,16 +36,16 @@ static struct kvm_trace *kvm_trace;
 struct kvm_trace_probe {
 	const char *name;
 	const char *format;
-	u32 cycle_in;
+	u32 timestamp_in;
 	marker_probe_func *probe_func;
 };
 
-static inline int calc_rec_size(int cycle, int extra)
+static inline int calc_rec_size(int timestamp, int extra)
 {
 	int rec_size = KVM_TRC_HEAD_SIZE;
 
 	rec_size += extra;
-	return cycle ? rec_size += KVM_TRC_CYCLE_SIZE : rec_size;
+	return timestamp ? rec_size += KVM_TRC_CYCLE_SIZE : rec_size;
 }
 
 static void kvm_add_trace(void *probe_private, void *call_data,
@@ -69,20 +70,20 @@ static void kvm_add_trace(void *probe_private, void *call_data,
 	WARN_ON(!(extra <= KVM_TRC_EXTRA_MAX));
 	extra 		= min_t(u32, extra, KVM_TRC_EXTRA_MAX);
 
-	rec.rec_val |= TRACE_REC_TCS(p->cycle_in)
+	rec.rec_val |= TRACE_REC_TCS(p->timestamp_in)
 			| TRACE_REC_NUM_DATA_ARGS(extra);
 
-	if (p->cycle_in) {
-		rec.u.cycle.cycle_u64 = get_cycles();
+	if (p->timestamp_in) {
+		rec.u.timestamp.timestamp = ktime_to_ns(ktime_get());
 
 		for (i = 0; i < extra; i++)
-			rec.u.cycle.extra_u32[i] = va_arg(*args, u32);
+			rec.u.timestamp.extra_u32[i] = va_arg(*args, u32);
 	} else {
 		for (i = 0; i < extra; i++)
-			rec.u.nocycle.extra_u32[i] = va_arg(*args, u32);
+			rec.u.notimestamp.extra_u32[i] = va_arg(*args, u32);
 	}
 
-	size = calc_rec_size(p->cycle_in, extra * sizeof(u32));
+	size = calc_rec_size(p->timestamp_in, extra * sizeof(u32));
 	relay_write(kt->rchan, &rec, size);
 }
 
-- 
1.6.0.1

