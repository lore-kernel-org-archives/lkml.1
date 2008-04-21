Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbYDUKdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbYDUKdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbYDUKaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:17 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37888
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbYDUKaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:02 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: [PATCH 09/31] KVM: Add kvm trace userspace interface
Date: Mon, 21 Apr 2008 13:29:35 +0300
Message-Id: <1208773797-7829-10-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng(Eric) Liu <eric.e.liu@intel.com>

This interface allows user a space application to read the trace of kvm
related events through relayfs.

Signed-off-by: Feng (Eric) Liu <eric.e.liu@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/Kconfig     |   11 ++
 arch/x86/kvm/Makefile    |    3 +
 include/linux/kvm_host.h |   14 +++
 virt/kvm/kvm_main.c      |    8 +-
 virt/kvm/kvm_trace.c     |  276 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 311 insertions(+), 1 deletions(-)
 create mode 100644 virt/kvm/kvm_trace.c

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 76c70ab..8d45fab 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -50,6 +50,17 @@ config KVM_AMD
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
+config KVM_TRACE
+	bool "KVM trace support"
+	depends on KVM && MARKERS && SYSFS
+	select RELAY
+	select DEBUG_FS
+	default n
+	---help---
+	  This option allows reading a trace of kvm-related events through
+	  relayfs.  Note the ABI is not considered stable and will be
+	  modified in future updates.
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/lguest/Kconfig
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 4d0c22e..c97d35c 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -3,6 +3,9 @@
 #
 
 common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o)
+ifeq ($(CONFIG_KVM_TRACE),y)
+common-objs += $(addprefix ../../../virt/kvm/, kvm_trace.o)
+endif
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/x86/kvm
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 578c363..bd0c2d2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/preempt.h>
+#include <linux/marker.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -309,5 +310,18 @@ struct kvm_stats_debugfs_item {
 	struct dentry *dentry;
 };
 extern struct kvm_stats_debugfs_item debugfs_entries[];
+extern struct dentry *debugfs_dir;
+
+#ifdef CONFIG_KVM_TRACE
+int kvm_trace_ioctl(unsigned int ioctl, unsigned long arg);
+void kvm_trace_cleanup(void);
+#else
+static inline
+int kvm_trace_ioctl(unsigned int ioctl, unsigned long arg)
+{
+	return -EINVAL;
+}
+#define kvm_trace_cleanup() ((void)0)
+#endif
 
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6a52c08..d5911d9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -60,7 +60,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
 
-static struct dentry *debugfs_dir;
+struct dentry *debugfs_dir;
 
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
@@ -1191,6 +1191,11 @@ static long kvm_dev_ioctl(struct file *filp,
 		r += PAGE_SIZE;    /* pio data page */
 #endif
 		break;
+	case KVM_TRACE_ENABLE:
+	case KVM_TRACE_PAUSE:
+	case KVM_TRACE_DISABLE:
+		r = kvm_trace_ioctl(ioctl, arg);
+		break;
 	default:
 		return kvm_arch_dev_ioctl(filp, ioctl, arg);
 	}
@@ -1519,6 +1524,7 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
+	kvm_trace_cleanup();
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
 	sysdev_unregister(&kvm_sysdev);
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
new file mode 100644
index 0000000..5425440
--- /dev/null
+++ b/virt/kvm/kvm_trace.c
@@ -0,0 +1,276 @@
+/*
+ * kvm trace
+ *
+ * It is designed to allow debugging traces of kvm to be generated
+ * on UP / SMP machines.  Each trace entry can be timestamped so that
+ * it's possible to reconstruct a chronological record of trace events.
+ * The implementation refers to blktrace kernel support.
+ *
+ * Copyright (c) 2008 Intel Corporation
+ * Copyright (C) 2006 Jens Axboe <axboe@kernel.dk>
+ *
+ * Authors: Feng(Eric) Liu, eric.e.liu@intel.com
+ *
+ * Date:    Feb 2008
+ */
+
+#include <linux/module.h>
+#include <linux/relay.h>
+#include <linux/debugfs.h>
+
+#include <linux/kvm_host.h>
+
+#define KVM_TRACE_STATE_RUNNING 	(1 << 0)
+#define KVM_TRACE_STATE_PAUSE 		(1 << 1)
+#define KVM_TRACE_STATE_CLEARUP 	(1 << 2)
+
+struct kvm_trace {
+	int trace_state;
+	struct rchan *rchan;
+	struct dentry *lost_file;
+	atomic_t lost_records;
+};
+static struct kvm_trace *kvm_trace;
+
+struct kvm_trace_probe {
+	const char *name;
+	const char *format;
+	u32 cycle_in;
+	marker_probe_func *probe_func;
+};
+
+static inline int calc_rec_size(int cycle, int extra)
+{
+	int rec_size = KVM_TRC_HEAD_SIZE;
+
+	rec_size += extra;
+	return cycle ? rec_size += KVM_TRC_CYCLE_SIZE : rec_size;
+}
+
+static void kvm_add_trace(void *probe_private, void *call_data,
+			  const char *format, va_list *args)
+{
+	struct kvm_trace_probe *p = probe_private;
+	struct kvm_trace *kt = kvm_trace;
+	struct kvm_trace_rec rec;
+	struct kvm_vcpu *vcpu;
+	int    i, extra, size;
+
+	if (unlikely(kt->trace_state != KVM_TRACE_STATE_RUNNING))
+		return;
+
+	rec.event	= va_arg(*args, u32);
+	vcpu		= va_arg(*args, struct kvm_vcpu *);
+	rec.pid		= current->tgid;
+	rec.vcpu_id	= vcpu->vcpu_id;
+
+	extra   	= va_arg(*args, u32);
+	WARN_ON(!(extra <= KVM_TRC_EXTRA_MAX));
+	extra 		= min_t(u32, extra, KVM_TRC_EXTRA_MAX);
+	rec.extra_u32   = extra;
+
+	rec.cycle_in 	= p->cycle_in;
+
+	if (rec.cycle_in) {
+		u64 cycle = 0;
+
+		cycle = get_cycles();
+		rec.u.cycle.cycle_lo = (u32)cycle;
+		rec.u.cycle.cycle_hi = (u32)(cycle >> 32);
+
+		for (i = 0; i < rec.extra_u32; i++)
+			rec.u.cycle.extra_u32[i] = va_arg(*args, u32);
+	} else {
+		for (i = 0; i < rec.extra_u32; i++)
+			rec.u.nocycle.extra_u32[i] = va_arg(*args, u32);
+	}
+
+	size = calc_rec_size(rec.cycle_in, rec.extra_u32 * sizeof(u32));
+	relay_write(kt->rchan, &rec, size);
+}
+
+static struct kvm_trace_probe kvm_trace_probes[] = {
+	{ "kvm_trace_entryexit", "%u %p %u %u %u %u %u %u", 1, kvm_add_trace },
+	{ "kvm_trace_handler", "%u %p %u %u %u %u %u %u", 0, kvm_add_trace },
+};
+
+static int lost_records_get(void *data, u64 *val)
+{
+	struct kvm_trace *kt = data;
+
+	*val = atomic_read(&kt->lost_records);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(kvm_trace_lost_ops, lost_records_get, NULL, "%llu\n");
+
+/*
+ *  The relay channel is used in "no-overwrite" mode, it keeps trace of how
+ *  many times we encountered a full subbuffer, to tell user space app the
+ *  lost records there were.
+ */
+static int kvm_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
+				     void *prev_subbuf, size_t prev_padding)
+{
+	struct kvm_trace *kt;
+
+	if (!relay_buf_full(buf))
+		return 1;
+
+	kt = buf->chan->private_data;
+	atomic_inc(&kt->lost_records);
+
+	return 0;
+}
+
+static struct dentry *kvm_create_buf_file_callack(const char *filename,
+						 struct dentry *parent,
+						 int mode,
+						 struct rchan_buf *buf,
+						 int *is_global)
+{
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+static int kvm_remove_buf_file_callback(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+	return 0;
+}
+
+static struct rchan_callbacks kvm_relay_callbacks = {
+	.subbuf_start 		= kvm_subbuf_start_callback,
+	.create_buf_file 	= kvm_create_buf_file_callack,
+	.remove_buf_file 	= kvm_remove_buf_file_callback,
+};
+
+static int do_kvm_trace_enable(struct kvm_user_trace_setup *kuts)
+{
+	struct kvm_trace *kt;
+	int i, r = -ENOMEM;
+
+	if (!kuts->buf_size || !kuts->buf_nr)
+		return -EINVAL;
+
+	kt = kzalloc(sizeof(*kt), GFP_KERNEL);
+	if (!kt)
+		goto err;
+
+	r = -EIO;
+	atomic_set(&kt->lost_records, 0);
+	kt->lost_file = debugfs_create_file("lost_records", 0444, debugfs_dir,
+					    kt, &kvm_trace_lost_ops);
+	if (!kt->lost_file)
+		goto err;
+
+	kt->rchan = relay_open("trace", debugfs_dir, kuts->buf_size,
+				kuts->buf_nr, &kvm_relay_callbacks, kt);
+	if (!kt->rchan)
+		goto err;
+
+	kvm_trace = kt;
+
+	for (i = 0; i < ARRAY_SIZE(kvm_trace_probes); i++) {
+		struct kvm_trace_probe *p = &kvm_trace_probes[i];
+
+		r = marker_probe_register(p->name, p->format, p->probe_func, p);
+		if (r)
+			printk(KERN_INFO "Unable to register probe %s\n",
+			       p->name);
+	}
+
+	kvm_trace->trace_state = KVM_TRACE_STATE_RUNNING;
+
+	return 0;
+err:
+	if (kt) {
+		if (kt->lost_file)
+			debugfs_remove(kt->lost_file);
+		if (kt->rchan)
+			relay_close(kt->rchan);
+		kfree(kt);
+	}
+	return r;
+}
+
+static int kvm_trace_enable(char __user *arg)
+{
+	struct kvm_user_trace_setup kuts;
+	int ret;
+
+	ret = copy_from_user(&kuts, arg, sizeof(kuts));
+	if (ret)
+		return -EFAULT;
+
+	ret = do_kvm_trace_enable(&kuts);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int kvm_trace_pause(void)
+{
+	struct kvm_trace *kt = kvm_trace;
+	int r = -EINVAL;
+
+	if (kt == NULL)
+		return r;
+
+	if (kt->trace_state == KVM_TRACE_STATE_RUNNING) {
+		kt->trace_state = KVM_TRACE_STATE_PAUSE;
+		relay_flush(kt->rchan);
+		r = 0;
+	}
+
+	return r;
+}
+
+void kvm_trace_cleanup(void)
+{
+	struct kvm_trace *kt = kvm_trace;
+	int i;
+
+	if (kt == NULL)
+		return;
+
+	if (kt->trace_state == KVM_TRACE_STATE_RUNNING ||
+	    kt->trace_state == KVM_TRACE_STATE_PAUSE) {
+
+		kt->trace_state = KVM_TRACE_STATE_CLEARUP;
+
+		for (i = 0; i < ARRAY_SIZE(kvm_trace_probes); i++) {
+			struct kvm_trace_probe *p = &kvm_trace_probes[i];
+			marker_probe_unregister(p->name, p->probe_func, p);
+		}
+
+		relay_close(kt->rchan);
+		debugfs_remove(kt->lost_file);
+		kfree(kt);
+	}
+}
+
+int kvm_trace_ioctl(unsigned int ioctl, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	long r = -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	switch (ioctl) {
+	case KVM_TRACE_ENABLE:
+		r = kvm_trace_enable(argp);
+		break;
+	case KVM_TRACE_PAUSE:
+		r = kvm_trace_pause();
+		break;
+	case KVM_TRACE_DISABLE:
+		r = 0;
+		kvm_trace_cleanup();
+		break;
+	}
+
+	return r;
+}
-- 
1.5.5

