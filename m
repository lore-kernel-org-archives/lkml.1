Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZHSNEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZHSNEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZHSNEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50588 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752027AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 39/47] KVM: remove old KVMTRACE support code
Date: Wed, 19 Aug 2009 16:02:35 +0300
Message-Id: <1250686963-8357-40-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Return EOPNOTSUPP for KVM_TRACE_ENABLE/PAUSE/DISABLE ioctls.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/Kconfig     |    3 -
 arch/powerpc/kvm/Kconfig  |   11 --
 arch/powerpc/kvm/Makefile |    2 -
 arch/s390/kvm/Kconfig     |    3 -
 arch/x86/kvm/Kconfig      |   12 --
 arch/x86/kvm/Makefile     |    1 -
 include/linux/kvm.h       |   31 +-----
 include/linux/kvm_host.h  |   31 -----
 virt/kvm/kvm_main.c       |    3 +-
 virt/kvm/kvm_trace.c      |  285 ---------------------------------------------
 10 files changed, 2 insertions(+), 380 deletions(-)
 delete mode 100644 virt/kvm/kvm_trace.c

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index cbadd8a..ef3e7be 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -47,9 +47,6 @@ config KVM_INTEL
 	  Provides support for KVM on Itanium 2 processors equipped with the VT
 	  extensions.
 
-config KVM_TRACE
-       bool
-
 source drivers/virtio/Kconfig
 
 endif # VIRTUALIZATION
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 46019dc..c299268 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -58,17 +58,6 @@ config KVM_E500
 
 	  If unsure, say N.
 
-config KVM_TRACE
-	bool "KVM trace support"
-	depends on KVM && MARKERS && SYSFS
-	select RELAY
-	select DEBUG_FS
-	default n
-	---help---
-	  This option allows reading a trace of kvm-related events through
-	  relayfs.  Note the ABI is not considered stable and will be
-	  modified in future updates.
-
 source drivers/virtio/Kconfig
 
 endif # VIRTUALIZATION
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 4f407f2..37655fe 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -8,8 +8,6 @@ EXTRA_CFLAGS += -Ivirt/kvm -Iarch/powerpc/kvm
 
 common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
 
-common-objs-$(CONFIG_KVM_TRACE)  += $(addprefix ../../../virt/kvm/, kvm_trace.o)
-
 CFLAGS_44x_tlb.o  := -I.
 CFLAGS_e500_tlb.o := -I.
 CFLAGS_emulate.o  := -I.
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index ad75ce3..bf164fc 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -34,9 +34,6 @@ config KVM
 
 	  If unsure, say N.
 
-config KVM_TRACE
-       bool
-
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/virtio/Kconfig
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 7fbedfd..b84e571 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -62,18 +62,6 @@ config KVM_AMD
 	  To compile this as a module, choose M here: the module
 	  will be called kvm-amd.
 
-config KVM_TRACE
-	bool "KVM trace support"
-	depends on KVM && SYSFS
-	select MARKERS
-	select RELAY
-	select DEBUG_FS
-	default n
-	---help---
-	  This option allows reading a trace of kvm-related events through
-	  relayfs.  Note the ABI is not considered stable and will be
-	  modified in future updates.
-
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/lguest/Kconfig
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 7c56850..afaaa76 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -7,7 +7,6 @@ CFLAGS_vmx.o := -I.
 
 kvm-y			+= $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
 				coalesced_mmio.o irq_comm.o eventfd.o)
-kvm-$(CONFIG_KVM_TRACE)	+= $(addprefix ../../../virt/kvm/, kvm_trace.o)
 kvm-$(CONFIG_IOMMU_API)	+= $(addprefix ../../../virt/kvm/, iommu.o)
 
 kvm-y			+= x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o \
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 6710518..76c6408 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -14,7 +14,7 @@
 
 #define KVM_API_VERSION 12
 
-/* for KVM_TRACE_ENABLE */
+/* for KVM_TRACE_ENABLE, deprecated */
 struct kvm_user_trace_setup {
 	__u32 buf_size; /* sub_buffer size of each per-cpu */
 	__u32 buf_nr; /* the number of sub_buffers of each per-cpu */
@@ -325,35 +325,6 @@ struct kvm_guest_debug {
 #define KVM_TRC_CYCLE_SIZE      8
 #define KVM_TRC_EXTRA_MAX       7
 
-/* This structure represents a single trace buffer record. */
-struct kvm_trace_rec {
-	/* variable rec_val
-	 * is split into:
-	 * bits 0 - 27  -> event id
-	 * bits 28 -30  -> number of extra data args of size u32
-	 * bits 31      -> binary indicator for if tsc is in record
-	 */
-	__u32 rec_val;
-	__u32 pid;
-	__u32 vcpu_id;
-	union {
-		struct {
-			__u64 timestamp;
-			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
-		} __attribute__((packed)) timestamp;
-		struct {
-			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
-		} notimestamp;
-	} u;
-};
-
-#define TRACE_REC_EVENT_ID(val) \
-		(0x0fffffff & (val))
-#define TRACE_REC_NUM_DATA_ARGS(val) \
-		(0x70000000 & ((val) << 28))
-#define TRACE_REC_TCS(val) \
-		(0x80000000 & ((val) << 31))
-
 #define KVMIO 0xAE
 
 /*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 06af936..0604d56 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -482,37 +482,6 @@ struct kvm_stats_debugfs_item {
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 extern struct dentry *kvm_debugfs_dir;
 
-#define KVMTRACE_5D(evt, vcpu, d1, d2, d3, d4, d5, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 5, d1, d2, d3, d4, d5)
-#define KVMTRACE_4D(evt, vcpu, d1, d2, d3, d4, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 4, d1, d2, d3, d4, 0)
-#define KVMTRACE_3D(evt, vcpu, d1, d2, d3, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 3, d1, d2, d3, 0, 0)
-#define KVMTRACE_2D(evt, vcpu, d1, d2, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 2, d1, d2, 0, 0, 0)
-#define KVMTRACE_1D(evt, vcpu, d1, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 1, d1, 0, 0, 0, 0)
-#define KVMTRACE_0D(evt, vcpu, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 0, 0, 0, 0, 0, 0)
-
-#ifdef CONFIG_KVM_TRACE
-int kvm_trace_ioctl(unsigned int ioctl, unsigned long arg);
-void kvm_trace_cleanup(void);
-#else
-static inline
-int kvm_trace_ioctl(unsigned int ioctl, unsigned long arg)
-{
-	return -EINVAL;
-}
-#define kvm_trace_cleanup() ((void)0)
-#endif
-
 #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
 static inline int mmu_notifier_retry(struct kvm_vcpu *vcpu, unsigned long mmu_seq)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f1e2e8c..bbb4029 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2398,7 +2398,7 @@ static long kvm_dev_ioctl(struct file *filp,
 	case KVM_TRACE_ENABLE:
 	case KVM_TRACE_PAUSE:
 	case KVM_TRACE_DISABLE:
-		r = kvm_trace_ioctl(ioctl, arg);
+		r = -EOPNOTSUPP;
 		break;
 	default:
 		return kvm_arch_dev_ioctl(filp, ioctl, arg);
@@ -2748,7 +2748,6 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
-	kvm_trace_cleanup();
 	tracepoint_synchronize_unregister();
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
deleted file mode 100644
index f598744..0000000
--- a/virt/kvm/kvm_trace.c
+++ /dev/null
@@ -1,285 +0,0 @@
-/*
- * kvm trace
- *
- * It is designed to allow debugging traces of kvm to be generated
- * on UP / SMP machines.  Each trace entry can be timestamped so that
- * it's possible to reconstruct a chronological record of trace events.
- * The implementation refers to blktrace kernel support.
- *
- * Copyright (c) 2008 Intel Corporation
- * Copyright (C) 2006 Jens Axboe <axboe@kernel.dk>
- *
- * Authors: Feng(Eric) Liu, eric.e.liu@intel.com
- *
- * Date:    Feb 2008
- */
-
-#include <linux/module.h>
-#include <linux/relay.h>
-#include <linux/debugfs.h>
-#include <linux/ktime.h>
-
-#include <linux/kvm_host.h>
-
-#define KVM_TRACE_STATE_RUNNING 	(1 << 0)
-#define KVM_TRACE_STATE_PAUSE 		(1 << 1)
-#define KVM_TRACE_STATE_CLEARUP 	(1 << 2)
-
-struct kvm_trace {
-	int trace_state;
-	struct rchan *rchan;
-	struct dentry *lost_file;
-	atomic_t lost_records;
-};
-static struct kvm_trace *kvm_trace;
-
-struct kvm_trace_probe {
-	const char *name;
-	const char *format;
-	u32 timestamp_in;
-	marker_probe_func *probe_func;
-};
-
-static inline int calc_rec_size(int timestamp, int extra)
-{
-	int rec_size = KVM_TRC_HEAD_SIZE;
-
-	rec_size += extra;
-	return timestamp ? rec_size += KVM_TRC_CYCLE_SIZE : rec_size;
-}
-
-static void kvm_add_trace(void *probe_private, void *call_data,
-			  const char *format, va_list *args)
-{
-	struct kvm_trace_probe *p = probe_private;
-	struct kvm_trace *kt = kvm_trace;
-	struct kvm_trace_rec rec;
-	struct kvm_vcpu *vcpu;
-	int    i, size;
-	u32    extra;
-
-	if (unlikely(kt->trace_state != KVM_TRACE_STATE_RUNNING))
-		return;
-
-	rec.rec_val	= TRACE_REC_EVENT_ID(va_arg(*args, u32));
-	vcpu		= va_arg(*args, struct kvm_vcpu *);
-	rec.pid		= current->tgid;
-	rec.vcpu_id	= vcpu->vcpu_id;
-
-	extra   	= va_arg(*args, u32);
-	WARN_ON(!(extra <= KVM_TRC_EXTRA_MAX));
-	extra 		= min_t(u32, extra, KVM_TRC_EXTRA_MAX);
-
-	rec.rec_val |= TRACE_REC_TCS(p->timestamp_in)
-			| TRACE_REC_NUM_DATA_ARGS(extra);
-
-	if (p->timestamp_in) {
-		rec.u.timestamp.timestamp = ktime_to_ns(ktime_get());
-
-		for (i = 0; i < extra; i++)
-			rec.u.timestamp.extra_u32[i] = va_arg(*args, u32);
-	} else {
-		for (i = 0; i < extra; i++)
-			rec.u.notimestamp.extra_u32[i] = va_arg(*args, u32);
-	}
-
-	size = calc_rec_size(p->timestamp_in, extra * sizeof(u32));
-	relay_write(kt->rchan, &rec, size);
-}
-
-static struct kvm_trace_probe kvm_trace_probes[] = {
-	{ "kvm_trace_entryexit", "%u %p %u %u %u %u %u %u", 1, kvm_add_trace },
-	{ "kvm_trace_handler", "%u %p %u %u %u %u %u %u", 0, kvm_add_trace },
-};
-
-static int lost_records_get(void *data, u64 *val)
-{
-	struct kvm_trace *kt = data;
-
-	*val = atomic_read(&kt->lost_records);
-	return 0;
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(kvm_trace_lost_ops, lost_records_get, NULL, "%llu\n");
-
-/*
- *  The relay channel is used in "no-overwrite" mode, it keeps trace of how
- *  many times we encountered a full subbuffer, to tell user space app the
- *  lost records there were.
- */
-static int kvm_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
-				     void *prev_subbuf, size_t prev_padding)
-{
-	struct kvm_trace *kt;
-
-	if (!relay_buf_full(buf)) {
-		if (!prev_subbuf) {
-			/*
-			 * executed only once when the channel is opened
-			 * save metadata as first record
-			 */
-			subbuf_start_reserve(buf, sizeof(u32));
-			*(u32 *)subbuf = 0x12345678;
-		}
-
-		return 1;
-	}
-
-	kt = buf->chan->private_data;
-	atomic_inc(&kt->lost_records);
-
-	return 0;
-}
-
-static struct dentry *kvm_create_buf_file_callack(const char *filename,
-						 struct dentry *parent,
-						 int mode,
-						 struct rchan_buf *buf,
-						 int *is_global)
-{
-	return debugfs_create_file(filename, mode, parent, buf,
-				   &relay_file_operations);
-}
-
-static int kvm_remove_buf_file_callback(struct dentry *dentry)
-{
-	debugfs_remove(dentry);
-	return 0;
-}
-
-static struct rchan_callbacks kvm_relay_callbacks = {
-	.subbuf_start 		= kvm_subbuf_start_callback,
-	.create_buf_file 	= kvm_create_buf_file_callack,
-	.remove_buf_file 	= kvm_remove_buf_file_callback,
-};
-
-static int do_kvm_trace_enable(struct kvm_user_trace_setup *kuts)
-{
-	struct kvm_trace *kt;
-	int i, r = -ENOMEM;
-
-	if (!kuts->buf_size || !kuts->buf_nr)
-		return -EINVAL;
-
-	kt = kzalloc(sizeof(*kt), GFP_KERNEL);
-	if (!kt)
-		goto err;
-
-	r = -EIO;
-	atomic_set(&kt->lost_records, 0);
-	kt->lost_file = debugfs_create_file("lost_records", 0444, kvm_debugfs_dir,
-					    kt, &kvm_trace_lost_ops);
-	if (!kt->lost_file)
-		goto err;
-
-	kt->rchan = relay_open("trace", kvm_debugfs_dir, kuts->buf_size,
-				kuts->buf_nr, &kvm_relay_callbacks, kt);
-	if (!kt->rchan)
-		goto err;
-
-	kvm_trace = kt;
-
-	for (i = 0; i < ARRAY_SIZE(kvm_trace_probes); i++) {
-		struct kvm_trace_probe *p = &kvm_trace_probes[i];
-
-		r = marker_probe_register(p->name, p->format, p->probe_func, p);
-		if (r)
-			printk(KERN_INFO "Unable to register probe %s\n",
-			       p->name);
-	}
-
-	kvm_trace->trace_state = KVM_TRACE_STATE_RUNNING;
-
-	return 0;
-err:
-	if (kt) {
-		if (kt->lost_file)
-			debugfs_remove(kt->lost_file);
-		if (kt->rchan)
-			relay_close(kt->rchan);
-		kfree(kt);
-	}
-	return r;
-}
-
-static int kvm_trace_enable(char __user *arg)
-{
-	struct kvm_user_trace_setup kuts;
-	int ret;
-
-	ret = copy_from_user(&kuts, arg, sizeof(kuts));
-	if (ret)
-		return -EFAULT;
-
-	ret = do_kvm_trace_enable(&kuts);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-static int kvm_trace_pause(void)
-{
-	struct kvm_trace *kt = kvm_trace;
-	int r = -EINVAL;
-
-	if (kt == NULL)
-		return r;
-
-	if (kt->trace_state == KVM_TRACE_STATE_RUNNING) {
-		kt->trace_state = KVM_TRACE_STATE_PAUSE;
-		relay_flush(kt->rchan);
-		r = 0;
-	}
-
-	return r;
-}
-
-void kvm_trace_cleanup(void)
-{
-	struct kvm_trace *kt = kvm_trace;
-	int i;
-
-	if (kt == NULL)
-		return;
-
-	if (kt->trace_state == KVM_TRACE_STATE_RUNNING ||
-	    kt->trace_state == KVM_TRACE_STATE_PAUSE) {
-
-		kt->trace_state = KVM_TRACE_STATE_CLEARUP;
-
-		for (i = 0; i < ARRAY_SIZE(kvm_trace_probes); i++) {
-			struct kvm_trace_probe *p = &kvm_trace_probes[i];
-			marker_probe_unregister(p->name, p->probe_func, p);
-		}
-		marker_synchronize_unregister();
-
-		relay_close(kt->rchan);
-		debugfs_remove(kt->lost_file);
-		kfree(kt);
-	}
-}
-
-int kvm_trace_ioctl(unsigned int ioctl, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	long r = -EINVAL;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	switch (ioctl) {
-	case KVM_TRACE_ENABLE:
-		r = kvm_trace_enable(argp);
-		break;
-	case KVM_TRACE_PAUSE:
-		r = kvm_trace_pause();
-		break;
-	case KVM_TRACE_DISABLE:
-		r = 0;
-		kvm_trace_cleanup();
-		break;
-	}
-
-	return r;
-}
-- 
1.6.3.3

