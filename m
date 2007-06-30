Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbXF3DYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbXF3DYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXF3DYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:24:36 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34121 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbXF3DYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:24:34 -0400
Subject: [RFC PATCH 2/6] Driver Tracing Interface (DTI) code
From: Tom Zanussi <zanussi@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dwilder@us.ibm.com, HOLZHEU@de.ibm.com
Content-Type: text/plain
Date: Fri, 29 Jun 2007 22:23:53 -0500
Message-Id: <1183173834.24291.138.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Driver Tracing Interface (DTI) code.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 drivers/base/Kconfig           |   11 
 drivers/base/Makefile          |    1 
 drivers/base/dti.c             |  836 +++++++++++++++++++++++++++++++++++++++++
 drivers/base/dti_merged_view.c |  332 ++++++++++++++++
 include/linux/dti.h            |  293 ++++++++++++++
 5 files changed, 1473 insertions(+)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 5d6312e..fbc9c0e 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -49,6 +49,17 @@ config DEBUG_DEVRES
 
 	  If you are unsure about this, Say N here.
 
+config DTI
+	bool "Driver Tracing Interface (DTI)"
+	select GTSC
+	help
+	Provides  functions to write variable length trace records
+	into a wraparound memory trace buffer. One purpose of
+	this is to inspect the debug traces after a system crash in order to
+	analyze the reason for the failure. The traces are accessable from
+	system dumps via dump analysis tools like crash or lcrash. In live
+	systems the traces can be read via a debugfs interface.
+
 config SYS_HYPERVISOR
 	bool
 	default n
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index b39ea3f..7caa5f5 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 obj-$(CONFIG_SMP)	+= topology.o
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
+obj-$(CONFIG_DTI) += dti.o dti_merged_view.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/base/dti.c b/drivers/base/dti.c
new file mode 100644
index 0000000..2feec11
--- /dev/null
+++ b/drivers/base/dti.c
@@ -0,0 +1,836 @@
+/*
+ *    Linux Driver Tracing Interface.
+ *
+ *    Copyright (C) IBM Corp. 2007
+ *    Author(s): Tom Zanussi <zanussi@us.ibm.com>
+ *               Dave Wilder <wilder@us.ibm.com>
+ *               Michael Holzheu <holzheu@de.ibm.com>
+ */
+
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/relay.h>
+#include <linux/module.h>
+#include <linux/hardirq.h>
+#include <linux/dti.h>
+
+extern int dti_create_merged_views(struct dti_info *dti);
+extern void dti_remove_merged_views(struct dti_info *dti);
+struct file_operations level_fops;
+
+static inline int nr_sub(int size)
+{
+	if (size < 4)
+		return 0;
+	
+	if (size >= 8 * PAGE_SIZE)
+		return 8;
+	else
+		return 4;
+}
+
+static inline int sub_size(int size)
+{
+	if (size < 4)
+		return 0;
+	
+	if (size >= 8 * PAGE_SIZE)
+		return size / 8;
+	else
+		return size / 4;
+}
+
+/*
+ * For dti_printk, maximum size of klog formatting buffer beyond which
+ * truncation will occur
+ */
+#define DTI_PRINTF_TMPBUF_SIZE (1024)
+
+/* per-cpu dti_printf formatting temporary buffer */
+static char dti_printf_tmpbuf[NR_CPUS][DTI_PRINTF_TMPBUF_SIZE];
+
+/*
+ * Low-level registration functions
+ */
+
+static struct dti_info *__dti_register_level(const char *name, int level,
+					     int sub_size, int nr_sub,
+					     struct dti_handle *handle)
+{
+	struct dti_info *dti;
+
+	dti = kzalloc(sizeof(*dti), GFP_KERNEL);
+	if(!dti)
+		return NULL;
+
+	dti->trace = trace_setup("dti", name, sub_size, nr_sub,
+				 TRACE_FLIGHT_CHANNEL | TRACE_DISABLE_STATE);
+	if (!dti->trace)
+		goto setup_failed;
+	
+	dti->handle = handle;
+	dti->level = level;
+	dti->level_ctrl = debugfs_create_file("level", 0,
+					      dti->trace->dir, dti,
+					      &level_fops);
+	if (!dti->level_ctrl) {
+		printk("Couldn't create level control file\n");
+		goto level_failed;
+	}
+
+	strncpy(dti->name, name, NAME_MAX);
+
+	return dti;
+
+level_failed:
+	trace_cleanup(dti->trace);
+setup_failed:
+	kfree(dti);
+
+	return NULL;
+}
+
+/**
+ * dti_register_level: create trace dir and level ctrl file
+ *
+ * Internal - exported for setup macros.
+ */
+struct dti_info *dti_register_level(const char *name, int level,
+				    struct dti_handle *handle)
+{
+	return __dti_register_level(name, level, sub_size(handle->size),
+				    nr_sub(handle->size), handle);
+}
+EXPORT_SYMBOL_GPL(dti_register_level);
+
+static void dti_unregister_level(struct dti_info *dti)
+{
+	debugfs_remove(dti->level_ctrl);
+	trace_cleanup(dti->trace);
+	kfree(dti);
+}
+
+/**
+ * dti_register_channel: create channel part of new trace
+ */
+static int dti_register_channel(struct dti_info *dti)
+{
+	int rc = 0;
+	
+	rc = trace_start(dti->trace);
+	if (rc)
+		return rc;
+
+	if (dti_create_merged_views(dti)) {
+		rc = -ENOMEM;
+		goto failed_view;
+	}
+
+	return rc;
+
+failed_view:
+	trace_cleanup(dti->trace);
+	return rc;
+}
+
+static void dti_unregister_channel(struct dti_info *dti)
+{
+	dti_remove_merged_views(dti);
+	trace_cleanup_channel(dti->trace);
+}
+
+/**
+ * __dti_register: create new trace, explicitly specifying subbuffer sizes
+ * @name: name of trace
+ * @sub_size: size of subbuffer
+ * @nr_sub: number of subbuffers
+ * @init_level: initial log level e.g. DTI_LEVEL_DEFAULT, DTI_LEVEL_OFF, etc
+ *
+ * returns trace handle or NULL, if register failed.
+ *
+ * NOTE: use dti_register() if you don't care about sub-buffer details.
+ */
+struct dti_info *__dti_register(const char *name, int sub_size, int nr_sub,
+				int init_level)
+{
+	struct dti_info *dti;
+
+	dti = __dti_register_level(name, init_level, sub_size, nr_sub, NULL);
+	if (!dti)
+		return NULL;
+
+	if (dti_register_channel(dti)) {
+		dti_unregister_level(dti);
+		return NULL;
+	}
+	
+	return dti;
+}
+EXPORT_SYMBOL_GPL(__dti_register);
+
+/**
+ * dti_register: main registration function, creates new trace
+ * @name: name of trace
+ * @size: total size of buffer
+ * @init_level: initial log level e.g. DTI_LEVEL_DEFAULT, DTI_LEVEL_OFF, etc
+ *
+ * returns trace handle or NULL, if register failed.
+ */
+struct dti_info *dti_register(const char *name, int size, int init_level)
+{
+	int subsize = sub_size(size);
+	int nrsub = nr_sub(size);
+
+	if (subsize == 0 || nrsub == 0)
+		return NULL;
+
+	return __dti_register(name, subsize, nrsub, init_level);
+}
+EXPORT_SYMBOL_GPL(dti_register);
+
+/**
+ * dti_unregister: unregistration function, destroys trace
+ * @trace: trace handle
+ */
+void dti_unregister(struct dti_info *dti)
+{
+	if (!dti)
+		return;
+	
+	dti_unregister_channel(dti);
+	dti_unregister_level(dti);
+}
+EXPORT_SYMBOL_GPL(dti_unregister);
+
+/**
+ *	dti_register_work - register a channel asynchronously
+ *	@work: work struct that contains the the dti handle
+ *
+ *	This is the work function used to register a dti channel
+ *	asynchronously.
+ *
+ *	Internal - exported for setup macros.
+ */
+void dti_register_work(struct work_struct *work)
+{
+	struct dti_handle *handle =
+		container_of(work, struct dti_handle, work.work);
+
+	dti_register_channel(handle->info);
+}
+EXPORT_SYMBOL_GPL(dti_register_work);
+
+static void dti_register_async(struct dti_handle *handle)
+{
+	if (!handle->registered) {
+		handle->registered = 1;
+		schedule_delayed_work(&handle->work, 1);
+	}
+}
+
+/*
+ * Create channel now if possible, otherwise defer.  Return 0 only if the
+ * channel was successfully created and ready for use after this call.
+ */
+static int complete_channel(struct dti_handle *handle)
+{
+	unsigned long flags;
+	
+	spin_lock_irqsave(&handle->lock, flags);
+	if (handle->registered) {
+		spin_unlock_irqrestore(&handle->lock, flags);
+		return -EAGAIN;
+	}
+		
+	if (in_atomic() || irqs_disabled()) {
+		dti_register_async(handle);
+		spin_unlock_irqrestore(&handle->lock, flags);
+		return -EAGAIN;
+	}
+
+	handle->registered = 1;
+	spin_unlock_irqrestore(&handle->lock, flags);
+	
+	return dti_register_channel(handle->info);
+}
+
+/**
+ *	dti_initbuf_reserve - reserve slot in static channel buffer
+ */
+static inline void *dti_initbuf_reserve(struct dti_handle *handle,
+					size_t length)
+{
+	void *reserved;
+	unsigned int subbuf_size = handle->initbuf_size >> 1;
+
+	/* can't log events > initbuf_size / 2 */
+	if (length > subbuf_size)
+		return NULL;
+	
+	if (unlikely(handle->initbuf_offset + length > handle->initbuf_size)) {
+		handle->initbuf_pad[1] =
+			handle->initbuf_size - handle->initbuf_offset;
+		handle->initbuf_wrapped = 1;
+		handle->initbuf_offset = 0;
+	}
+	
+	if (unlikely(handle->initbuf_offset < subbuf_size &&
+		     handle->initbuf_offset + length >= subbuf_size)) {
+		handle->initbuf_pad[0] = subbuf_size - handle->initbuf_offset;
+		handle->initbuf_offset = subbuf_size;
+	}
+
+	reserved = handle->initbuf + handle->initbuf_offset;
+	handle->initbuf_offset += length;
+
+	return reserved;
+}
+
+/**
+ * __dti_reserve: reserve space in trace buffer, low-level (nonhandle) version
+ * @trace: trace handle
+ * @prio: priority of event (the lower, the higher the priority)
+ * @len: length to reserve
+ *
+ * returns pointer to event payload, if event is reserved. Otherwise NULL.
+ *
+ * NOTE: this is the main reserve function for non-handle event logging.
+ * dti_reserve, the handle version, uses it.
+ */
+void *__dti_reserve(struct dti_info *dti, int prio, size_t len)
+{
+	struct dti_event *event;
+	int event_len;
+
+	if (!dti)
+		return NULL;
+
+	if (prio > dti->level)
+		return NULL;
+
+	event_len = len + sizeof(*event);
+
+	event = relay_reserve(dti->trace->rchan, event_len);
+	if (!event)
+		return NULL;
+
+	event->time = sched_clock();
+	event->len = event_len;
+
+	return (void *)event + sizeof(*event);
+}
+EXPORT_SYMBOL_GPL(__dti_reserve);
+
+/**
+ * dti_reserve_early_handle: reserve in early trace buffer, handle version
+ */
+static void *dti_reserve_early_handle(struct dti_handle *handle, int prio,
+				      size_t len)
+{
+	struct dti_early_event *event;
+	int event_len;
+
+	if (!handle)
+		return NULL;
+
+	event_len = len + sizeof(*event);
+
+	event = dti_initbuf_reserve(handle, event_len);
+	if (!event)
+		return NULL;
+
+	event->cpu = smp_processor_id();
+	event->event.time = sched_clock();
+	event->event.len = len + sizeof(struct dti_event);
+
+	return (void *)event + sizeof(*event);
+}
+
+/**
+ * dti_reserve_early_fn: early reserve dispatch function
+ *
+ * Internal - exported for setup macros.
+ */
+void *dti_reserve_early_fn(struct dti_handle *handle,
+			   int prio, size_t len)
+{
+	void *rc = NULL;
+
+	if (handle->initbuf && prio <= handle->initlevel)
+		rc = dti_reserve_early_handle(handle, prio, len);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(dti_reserve_early_fn);
+
+/* dti_reserve_normal_fn: normal reserve dispatch function
+ *
+ * Internal - exported for setup macros.
+ */
+void *dti_reserve_normal_fn(struct dti_handle *handle,
+			    int prio, size_t len)
+{
+	void *rc = NULL;
+
+	if (handle->info->trace->rchan)
+		rc = __dti_reserve(handle->info, prio, len);
+	else if (prio <= handle->info->level) {
+		if (complete_channel(handle) == 0)
+			rc = __dti_reserve(handle->info, prio, len);
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(dti_reserve_normal_fn);
+
+/**
+ * dti_reserve_handle: reserve space in tracing buffer, handle version
+ * @handle: trace handle
+ * @prio: priority of event (the lower, the higher the priority)
+ * @len: length to reserve
+ *
+ * returns pointer to event payload, if event is reserved. Otherwise NULL.
+ *
+ * NOTE: dti.h defines dti_reserve() to use this on the static handles
+ * defined using DEFINE_DTI_HANDLE, so normally you'd use dti_reserve()
+ * instead of using this directly.
+ */
+void *dti_reserve_handle(struct dti_handle *handle, int prio, size_t len)
+{
+	return handle->reserve(handle, prio, len);
+}
+EXPORT_SYMBOL_GPL(dti_reserve_handle);
+
+static int vprintk_normal(struct dti_info *dti, int prio, const char* fmt,
+			  va_list args)
+{
+	struct dti_event *event;
+	void *buf;
+	int len, event_len, rc = -1;
+	unsigned long flags;
+
+	if (!dti)
+		return -1;
+
+	if (prio > dti->level)
+		return -1;
+
+	local_irq_save(flags);
+	buf = dti_printf_tmpbuf[smp_processor_id()];
+	len = vsnprintf(buf, DTI_PRINTF_TMPBUF_SIZE, fmt, args);
+	event_len = len + sizeof(*event);
+	event = relay_reserve(dti->trace->rchan, event_len);
+	if (event) {
+		event->time = sched_clock();
+		event->len = event_len;
+		memcpy(event->data, buf, len);
+		rc = 0;
+	}
+	local_irq_restore(flags);
+
+	return rc;
+}
+
+/**
+ * __dti_printk: write formatted string to trace, low-level (nonhandle) version
+ * @trace: trace struct pointer
+ * @fmt: format string
+ * @...: parameters
+ *
+ * returns 0, if event is written. Otherwise -1.
+ *
+ * NOTE: this is the main printk function for non-handle printing.
+ * dti_printk, the handle version, uses it.
+ */
+int __dti_printk(struct dti_info *dti, int prio, const char* fmt, ...)
+{
+	va_list args;
+	int rc;
+
+	va_start(args, fmt);
+	rc = vprintk_normal(dti, prio, fmt, args);
+	va_end(args);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(__dti_printk);
+
+static int vprintk_early(struct dti_handle *handle, int prio, const char* fmt,
+			 va_list args)
+{
+	struct dti_early_event *event;
+	void *buf;
+	int len, event_len, rc = -1;
+	unsigned long flags;
+
+	if (!handle)
+		return -1;
+
+	local_irq_save(flags);
+	buf = dti_printf_tmpbuf[smp_processor_id()];
+	len = vsnprintf(buf, DTI_PRINTF_TMPBUF_SIZE, fmt, args);
+	event_len = len + sizeof(*event);
+	event = dti_initbuf_reserve(handle, event_len);
+	if (event) {
+		event->cpu = smp_processor_id();
+		event->event.time = sched_clock();
+		event->event.len = len + sizeof(struct dti_event);
+		memcpy(event->event.data, buf, len);
+		rc = 0;
+	}
+	local_irq_restore(flags);
+
+	return rc;
+}
+
+/**
+ * dti_printk_early: write formatted string to trace, early version
+ */
+static int dti_printk_early(struct dti_handle *handle, int prio,
+			    const char* fmt, ...)
+{
+	va_list args;
+	int rc;
+
+	va_start(args, fmt);
+	rc = vprintk_early(handle, prio, fmt, args);
+	va_end(args);
+
+	return rc;
+}
+
+/**
+ * dti_printk_early_fn: early printk dispatch function
+ *
+ * Internal - exported for setup macros.
+ */
+int dti_printk_early_fn(struct dti_handle *handle,
+			int prio, const char* fmt, va_list args)
+{
+	int rc = -1;
+
+	if (handle->initbuf) {
+		if (prio <= handle->initlevel)
+			rc = dti_printk_early(handle, prio, fmt, args);
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(dti_printk_early_fn);
+
+/**
+ * dti_printk_normal_fn: normal printk dispatch function
+ *
+ * Internal - exported for setup macros.
+ */
+int dti_printk_normal_fn(struct dti_handle *handle,
+			 int prio, const char* fmt, va_list args)
+{
+	int rc = -1;
+
+	if (handle->info->trace->rchan)
+		rc = vprintk_normal(handle->info, prio, fmt, args);
+	else if (prio <= handle->info->level) {
+		if (complete_channel(handle) == 0)
+			rc = vprintk_normal(handle->info, prio, fmt, args);
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(dti_printk_normal_fn);
+
+/**
+ * dti_printk_handle: write formatted string to trace, handle version
+ * @handle: trace handle
+ * @fmt: format string
+ * @...: parameters
+ *
+ * returns 0, if event is written. Otherwise -1.
+ *
+ * NOTE: dti.h defines dti_printk() to use this on the static handles
+ * defined using DEFINE_DTI_HANDLE, so normally you'd use dti_printk()
+ * instead of using this directly.
+ */
+int dti_printk_handle(struct dti_handle *handle, int prio,
+		      const char* fmt, ...)
+{
+	va_list args;
+	int rc = -1;
+
+	va_start(args, fmt);
+	rc = handle->printk(handle, prio, fmt, args);
+	va_end(args);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(dti_printk_handle);
+
+/**
+ * __dti_event: write buffer to trace, low-level (nonhandle) version
+ * @trace: trace handle
+ * @prio: priority of event (the lower, the higher the priority)
+ * @buf: buffer to write
+ * @len: length of buffer
+ *
+ * returns 0, if event is written. Otherwise -1.
+ *
+ * NOTE: this is the main event function for non-handle event logging.
+ * dti_event, the handle version, uses it.
+ */
+int __dti_event(struct dti_info *dti,
+		int prio, const void* buf, size_t len)
+{
+	struct dti_event *event;
+	int event_len, rc = -1;
+	unsigned long flags;
+
+	if (!dti)
+		return -1;
+
+	if (prio > dti->level)
+		return -1;
+
+	event_len = len + sizeof(*event);
+
+	local_irq_save(flags);
+	event = relay_reserve(dti->trace->rchan, event_len);
+	if (event) {
+		event->time = sched_clock();
+		event->len = event_len;
+		memcpy(event->data, buf, len);
+		rc = 0;
+	}
+	local_irq_restore(flags);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(__dti_event);
+
+/**
+ * dti_event_early: write buffer to trace, early version
+ */
+static int dti_event_early(struct dti_handle *handle,
+			   int prio, const void* buf, size_t len)
+{
+	struct dti_early_event *event;
+	int event_len, rc = -1;
+	unsigned long flags;
+
+	if (!handle)
+		return -1;
+
+	event_len = len + sizeof(*event);
+
+	local_irq_save(flags);
+	event = dti_initbuf_reserve(handle, event_len);
+	if (event) {
+		event->cpu = smp_processor_id();
+		event->event.time = sched_clock();
+		event->event.len = len + sizeof(struct dti_event);
+		memcpy(event->event.data, buf, len);
+		rc = 0;
+	}
+	local_irq_restore(flags);
+
+	return rc;
+}
+
+/**
+ * dti_event_early_fn: early dti_event dispatch function
+ *
+ * Internal - exported for setup macros.
+ */
+int dti_event_early_fn(struct dti_handle *handle,
+		       int prio, const void* buf, size_t len)
+{
+	int rc = -1;
+
+	if (handle->initbuf && prio <= handle->initlevel)
+		rc = dti_event_early(handle, prio, buf, len);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(dti_event_early_fn);
+
+/**
+ * dti_event_normal_fn: normal dti_event dispatch function
+ *
+ * Internal - exported for setup macros.
+ */
+int dti_event_normal_fn(struct dti_handle *handle,
+			int prio, const void* buf, size_t len)
+{
+	int rc = -1;
+
+	if (handle->info->trace->rchan)
+		rc = __dti_event(handle->info, prio, buf, len);
+	else if (prio <= handle->info->level) {
+		if (complete_channel(handle) == 0)
+			rc = __dti_event(handle->info, prio, buf, len);
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(dti_event_normal_fn);
+
+/**
+ * dti_event_handle: write buffer to trace, handle version
+ * @handle: trace handle
+ * @prio: priority of event (the lower, the higher the priority)
+ * @buf: buffer to write
+ * @len: length of buffer
+ *
+ * returns 0, if event is written. Otherwise -1.
+ *
+ * NOTE: dti.h defines dti_event() to use this on the static handles
+ * defined using DEFINE_DTI_HANDLE, so normally you'd use dti_event()
+ * instead of using this directly.
+ */
+int dti_event_handle(struct dti_handle *handle,
+		     int prio, const void* buf, size_t len)
+{
+	return handle->event(handle, prio, buf, len);
+}
+EXPORT_SYMBOL_GPL(dti_event_handle);
+
+/**
+ *	dti_relog_initbuf - re-log static initbuf into real relay channel
+ *	@work: work struct that contains the the dti handle
+ *
+ *	The global initbuf may contain events from multiple cpus.  These
+ *	events must be put into their respective cpu buffers once the
+ *	per-cpu channel is available.
+ *
+ *	Internal - exported for setup macros.
+ */
+int dti_relog_initbuf(struct dti_handle *handle)
+{
+	void *initbuf, *reserved;
+	struct dti_early_event *event;
+	int rc = 0;
+	unsigned int left, i;
+	unsigned int n_subbufs = 2;
+	unsigned int subbuf_size = handle->initbuf_size >> 1;
+	unsigned int relog_idx = 0;
+	unsigned int relog_n = n_subbufs;
+	unsigned int sizediff = (sizeof(*event) - sizeof(struct dti_event));
+
+	rc = dti_register_channel(handle->info);
+	if (rc)
+		return rc;
+
+	if (handle->initbuf_wrapped && handle->initbuf_offset <= subbuf_size)
+		relog_idx = 1;
+
+	if (!handle->initbuf_wrapped && handle->initbuf_offset < subbuf_size)
+		relog_n = 1;
+
+	for (i = 0; i < relog_n; i++) {
+		initbuf = handle->initbuf + relog_idx * subbuf_size;
+		if (i == 0 && relog_n == 2)
+			left = subbuf_size - handle->initbuf_pad[relog_idx];
+		else
+			left = handle->initbuf_offset % subbuf_size;
+		
+		while (left) {
+			event = initbuf;
+			reserved = relay_reserve_cpu(handle->info->trace->rchan,
+						     event->event.len,
+						     event->cpu);
+			if (reserved)
+				memcpy(reserved, &event->event,
+				       event->event.len);
+			left -= event->event.len + sizediff;
+			initbuf += event->event.len + sizediff;
+		}
+		if (++relog_idx == n_subbufs)
+			relog_idx = 0;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(dti_relog_initbuf);
+
+/*
+ * control files
+ */
+static int level_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t level_read(struct file *filp, char __user *buffer,
+			  size_t count, loff_t *ppos)
+{
+	struct dti_info *dti = filp->private_data;
+	char buf[32];
+
+	sprintf(buf, "%d\n", dti->level);
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t level_write(struct file *filp, const char __user *buffer,
+			   size_t count, loff_t *ppos)
+{
+	char buf[16] = { '\0' };
+	char *tmp;
+	struct dti_info *dti = filp->private_data;
+	int new_level;
+
+	if (count > sizeof(buf) - 1)
+		return -EINVAL;
+	if (copy_from_user(buf, buffer, count))
+		return -EFAULT;
+	buf[count] = '\0';
+	if (strcmp(buf, DTI_LEVEL_OFF_STR) == 0) {
+		dti->level = DTI_LEVEL_OFF;
+		return count;
+	}
+	if (strcmp(buf, DTI_LEVEL_DESTROY_STR) == 0)
+		new_level = DTI_LEVEL_DESTROY;
+	else {
+		new_level = simple_strtol(buf, &tmp, 10);
+		if (tmp == buf)
+			return -EINVAL;
+		if ((new_level > DTI_LEVEL_MAX) ||
+		    (new_level == DTI_LEVEL_DESTROY && !dti->handle) ||
+		    (new_level < DTI_LEVEL_DESTROY))
+			return -EINVAL;
+	}
+	
+	if (new_level == DTI_LEVEL_DESTROY) {
+		dti_unregister_channel(dti);
+		dti->level = DTI_LEVEL_OFF;
+	}
+		
+	dti->level = new_level;
+
+	return count;
+}
+
+struct file_operations level_fops = {
+	.owner = THIS_MODULE,
+	.open =	 level_open,
+	.read =	 level_read,
+	.write = level_write
+};
+
+/**
+ * dti_set_level: set trace level
+ * @trace: trace handle
+ */
+void dti_set_level(struct dti_info *dti, int new_level)
+{
+	if ((new_level > DTI_LEVEL_MAX) || (new_level < DTI_LEVEL_OFF))
+		return;
+
+	dti->level = new_level;
+}
+EXPORT_SYMBOL_GPL(dti_set_level);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tom Zanussi <zanussi@us.ibm.com>,"
+	      "Dave Wilder <wilder@us.ibm.com>,"
+	      "Michael Holzheu <holzheu@de.ibm.com>");
+MODULE_DESCRIPTION("Linux Driver Tracing Interface");
diff --git a/drivers/base/dti_merged_view.c b/drivers/base/dti_merged_view.c
new file mode 100644
index 0000000..b3fee0f
--- /dev/null
+++ b/drivers/base/dti_merged_view.c
@@ -0,0 +1,332 @@
+/*
+ * Provides the user with a merged view of DTI's per-cpu buffers.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) David Wilder, IBM Corporation, 2007
+ *
+ * 2007-April   Created by David Wilder <dwilder@us.ibm.com>.
+ *		Sorting code adapted from dti-user (libdti.c)
+ *		created by Tom Zanussi <zanussi@us.ibm.com>
+ */
+
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/relay.h>
+#include <linux/module.h>
+#include <linux/dti.h>
+
+struct dti_merged_view_info {
+	void *next_event; /* NULL if at end of buffer */
+	struct timeval last_read;
+	int cpu;
+	unsigned long long bytes_left;
+	void *buf;
+        loff_t pos;
+};
+
+struct dti_merged_view {
+	void *current_header; /* header currently being read */
+	ssize_t header_bytes_left;
+	char header[80];
+	void *current_event; /* record currently being read */
+	ssize_t event_bytes_left;
+	struct rchan *chan;
+	int show_timestamps;
+	struct dti_merged_view_info info[NR_CPUS]; /* per-cpu buffer info */
+} __attribute__ ((packed));
+
+struct file_operations dti_merged_view_fops;
+struct file_operations dti_merged_ts_view_fops;
+
+/**
+ * dti_remove_merged_views: remove merged views
+ * @trace: trace handle
+ */
+void dti_remove_merged_views(struct dti_info *trace)
+{
+	if (trace->merged_view)
+		debugfs_remove(trace->merged_view);
+	trace->merged_view = NULL;
+
+	if (trace->merged_ts_view)
+		debugfs_remove(trace->merged_ts_view);
+	trace->merged_ts_view = NULL;
+}
+
+/**
+ * dti_create_merged_views:
+ * Creates merged view files in the trace's parent.
+ *
+ * @trace: trace handle to create view of
+ *
+ * returns 0 on sucess.
+ */
+int dti_create_merged_views(struct dti_info *dti)
+{
+	struct dentry *parent = dti->trace->dir;
+
+	dti->merged_view = debugfs_create_file("merged", 0, parent, dti,
+					       &dti_merged_view_fops);
+
+	if (dti->merged_view == NULL ||
+	    dti->merged_view == (struct dentry *)-ENODEV) 
+		goto cleanup;
+
+	dti->merged_ts_view = debugfs_create_file("merged-ts",
+						  0, parent, dti,
+						  &dti_merged_ts_view_fops);
+
+	if (dti->merged_ts_view == NULL ||
+	    dti->merged_ts_view == (struct dentry *)-ENODEV) 
+		goto cleanup;
+
+	return 0;
+cleanup:
+	dti_remove_merged_views(dti);
+
+	return -ENOMEM;
+}
+
+static int dti_merged_view_open(struct inode *inode, struct file *filp)
+{
+	struct dti_merged_view *view;
+	struct dti_info *dti = inode->i_private;
+	struct rchan *chan = dti->trace->rchan;
+	int i;
+	int trace_level;
+
+	view = kzalloc(sizeof(struct dti_merged_view), GFP_KERNEL);
+	if (!view )
+		return -ENOMEM;
+	filp->private_data = view;
+
+	/* Tracing must be shut off when copying the buffers */
+	trace_level = dti->level;
+	dti_set_level(dti, DTI_LEVEL_OFF);
+	relay_reset_consumed(chan);
+	view->chan = chan;
+
+	for_each_online_cpu(i){
+		view->info[i].buf = (void *)__get_free_page(GFP_KERNEL);
+		if (!view->info[i].buf )
+			goto free_buf;
+		view->info[i].cpu = i;
+	}
+
+	dti_set_level(dti, trace_level);
+
+	return 0;
+free_buf:
+	for_each_possible_cpu(i)
+		if (view->info[i].buf)
+			free_page((unsigned long)view->info[i].buf);
+	kfree(view);
+
+	return -ENOMEM;
+}
+
+static int dti_merged_ts_view_open(struct inode *inode, struct file *filp)
+{
+	struct dti_merged_view *view;
+	int ret;
+
+	ret = dti_merged_view_open(inode, filp);
+	if (!ret) {
+		view = filp->private_data;
+		view->show_timestamps = 1;
+	}
+
+	return ret;
+}
+
+static int dti_merged_view_close(struct inode *inode, struct file *filp)
+{
+	int i;
+	struct dti_merged_view *view = filp->private_data;
+	
+	for_each_possible_cpu(i)
+                if (view->info[i].buf)
+			free_page((unsigned long)view->info[i].buf);
+        kfree(view);
+
+	return 0;
+}
+
+static int compare_recs(const void *rec1, const void *rec2)
+{
+        const struct dti_event *event1 = rec1;
+        const struct dti_event *event2 = rec2;
+
+        if (event1->time < event2->time)
+                return -1;
+        else if (event1->time > event2->time)
+                return 1;
+
+        return 0;
+}
+
+static inline int header_bytes_left(struct dti_merged_view *view)
+{
+	if (view->show_timestamps)
+		return view->header_bytes_left;
+	
+	return 0;
+}
+
+static inline void build_header(struct dti_merged_view *view, unsigned int cpu,
+				struct dti_event *event)
+{
+	unsigned long nanosec_rem;
+
+	/* build header */
+	nanosec_rem = do_div(event->time, 1000000000);
+	view->header_bytes_left = sprintf(view->header,
+					  "[%5lu.%06lu][%d]",
+					  (unsigned long)event->time,
+					  nanosec_rem/1000,
+					  cpu);
+
+	view->current_header = view->header;
+}
+
+static int events_left(int cpu, struct dti_merged_view *view)
+{
+	size_t bytes_read;
+	int bytes_left = view->info[cpu].bytes_left;
+	struct dti_event *event = view->info[cpu].next_event;
+
+	if (bytes_left && bytes_left < sizeof(struct dti_event)) {
+		unsigned int offset = PAGE_SIZE - bytes_left;
+		void *header = view->info[cpu].buf + offset;
+		memcpy(view->info[cpu].buf, header, bytes_left);
+	} else if (bytes_left && bytes_left < event->len)
+		memcpy(view->info[cpu].buf, (void *)event, bytes_left);
+	else if (bytes_left)
+		return 1;
+
+	bytes_read = relay_kernel_read(view->chan->buf[cpu],
+				       view->info[cpu].buf + bytes_left,
+				       PAGE_SIZE - bytes_left,
+				       &view->info[cpu].pos);
+
+	view->info[cpu].bytes_left += bytes_read;
+
+	if (view->info[cpu].bytes_left) {
+		view->info[cpu].next_event = view->info[cpu].buf;
+		return 1;
+	}
+
+	return 0;
+}
+
+static void *next_smallest(int *smallest_cpu, struct dti_merged_view *view )
+{
+        int i;
+        void *next, *smallest = NULL;
+
+	for_each_possible_cpu(i) {
+		if (!events_left(i, view))
+			continue;
+
+                next = view->info[i].next_event;
+                if (next) {
+                        if (!smallest) {
+                                smallest = next;
+                                *smallest_cpu = i;
+                                continue;
+                        }
+                        if (compare_recs(next, smallest) < 0) {
+                                smallest = next;
+                                *smallest_cpu = i;
+                                continue;
+                        }
+                }
+        }
+
+        return smallest;
+}
+
+static ssize_t dti_merged_view_read(struct file *filp, char __user *buffer,
+				    size_t count, loff_t *ppos)
+{
+	struct dti_event *event;
+	loff_t pos = *ppos;
+	int smallest_cpu=0;
+	struct dti_merged_view *view = filp->private_data;
+
+	if (pos < 0)
+		return -EINVAL;
+
+	if (!header_bytes_left(view) && !view->event_bytes_left)  {
+		event = (struct dti_event *)next_smallest(&smallest_cpu, view);
+		if (!event)
+			return 0;
+		
+		view->current_event = event->data;
+		view->event_bytes_left = event->len - sizeof(*event);
+		view->info[smallest_cpu].next_event += event->len;
+		view->info[smallest_cpu].bytes_left -= event->len;
+
+		if (view->show_timestamps)
+			build_header(view, smallest_cpu, event);
+	}
+
+	if ((header_bytes_left(view) < 0) || view->event_bytes_left < 0)
+		return -EINVAL;
+
+	if (header_bytes_left(view)) { 
+		if (count > view->header_bytes_left)
+			count = view->header_bytes_left;
+
+		if (copy_to_user(buffer, view->current_header, count))
+                	return -EFAULT;
+
+		view->header_bytes_left -= count;
+		view->current_header += count;
+
+		return count;
+	}
+
+	if (view->event_bytes_left) {
+		if (count > view->event_bytes_left)
+			count = view->event_bytes_left;
+
+		if (copy_to_user(buffer, view->current_event, count)) 
+			return -EFAULT;
+
+		view->event_bytes_left -= count;
+		view->current_event += count;
+
+		return count;
+	}
+
+	return 0; /* not reached */
+}
+
+struct file_operations dti_merged_view_fops = {
+	.owner = THIS_MODULE,
+	.open =  dti_merged_view_open,
+	.read =  dti_merged_view_read,
+	.release = dti_merged_view_close
+};
+
+struct file_operations dti_merged_ts_view_fops = {
+	.owner = THIS_MODULE,
+	.open =  dti_merged_ts_view_open,
+	.read =  dti_merged_view_read,
+	.release = dti_merged_view_close
+};
+
diff --git a/include/linux/dti.h b/include/linux/dti.h
new file mode 100644
index 0000000..3206e6a
--- /dev/null
+++ b/include/linux/dti.h
@@ -0,0 +1,293 @@
+/*
+ *    Driver Tracing Interface.
+ *
+ *    Copyright (C) IBM Corp. 2007
+ */
+
+#ifndef _LINUX_DTI_H
+#define _LINUX_DTI_H
+
+#include <linux/gtsc.h>
+
+/*
+ * DTI 'log levels'
+ */
+
+#define DTI_LEVEL_MAX		7
+#define DTI_LEVEL_DEFAULT	3
+#define DTI_LEVEL_OFF_STR	"off"
+#define DTI_LEVEL_OFF		-1
+#define DTI_LEVEL_DESTROY_STR	"destroy"
+#define DTI_LEVEL_DESTROY	-2
+
+/* These match printk loglevels */
+#define DTI_LEVEL_EMERG		0
+#define DTI_LEVEL_ALERT		1
+#define DTI_LEVEL_CRIT		2
+#define DTI_LEVEL_ERR		3
+#define DTI_LEVEL_WARNING	4
+#define DTI_LEVEL_NOTICE	5
+#define DTI_LEVEL_INFO		6
+#define DTI_LEVEL_DEBUG		7
+
+extern struct dentry *dti_trace_root;
+struct dti_handle;
+
+/*
+ * raw channel struct
+ */
+struct dti_info {
+	char name[NAME_MAX + 1];
+	struct trace_info *trace;
+	int    level;
+	atomic_t dropped;
+	struct dentry *level_ctrl;
+	struct dentry *merged_view;
+	struct dentry *merged_ts_view;
+	struct dti_handle *handle;
+};
+
+/*
+ * autoregistering channel handle
+ */
+struct dti_handle {
+	char *name;
+	int size;
+	int initlevel;
+	struct dti_info *info;
+	spinlock_t lock;
+	int registered;
+	struct delayed_work work;
+        void *initbuf;
+	unsigned int initbuf_size;
+        unsigned int initbuf_offset;
+	unsigned int initbuf_wrapped;
+	unsigned int initbuf_pad[2];
+
+	int (*printk) (struct dti_handle *handle,
+		       int prio,
+		       const char *fmt,
+		       va_list args);
+	int (*event) (struct dti_handle *handle,
+		      int prio,
+		      const void* buf,
+		      size_t len);
+	void *(*reserve) (struct dti_handle *handle,
+			  int prio,
+			  size_t len);
+};
+
+/*
+ * DTI data header
+ */
+struct dti_event {
+	__u16 len;
+	__u64 time;
+	char data[0];
+}  __attribute__ ((packed));
+
+struct dti_early_event {
+	__u32 cpu;
+	struct dti_event event;
+}  __attribute__ ((packed));
+
+/*
+ * DTI handle-based API
+ */
+#ifdef CONFIG_DTI
+#define DEFINE_DTI_KERNEL_HANDLE(_handle, _name, _size, _initlevel, _initbuf, _initbuf_size) \
+	struct dti_handle _handle = { 					\
+		.name = _name,						\
+		.printk = dti_printk_early_fn,				\
+		.event = dti_event_early_fn,				\
+		.reserve = dti_reserve_early_fn,			\
+		.size = _size,						\
+		.initlevel = _initlevel,				\
+		.lock = SPIN_LOCK_UNLOCKED,				\
+		.work = __DELAYED_WORK_INITIALIZER(_handle.work,	\
+			dti_register_work),				\
+                .initbuf = _initbuf,					\
+                .initbuf_size = _initbuf_size,				\
+                .initbuf_offset = 0,					\
+                .initbuf_pad = {0},					\
+                .initbuf_wrapped = 0,					\
+		.info = NULL,						\
+	};								\
+	static int _handle ## _dti_init(void)				\
+	{								\
+		INIT_DTI_HANDLE(_handle);				\
+		return 0;						\
+	}								\
+	postcore_initcall(_handle ## _dti_init)				\
+
+#define DEFINE_DTI_MODULE_HANDLE(_handle, _name, _size, _initlevel)	\
+	struct dti_handle _handle = { 					\
+		.name = _name,						\
+		.printk = dti_printk_normal_fn,				\
+		.event = dti_event_normal_fn,				\
+		.reserve = dti_reserve_normal_fn,			\
+		.size = _size,						\
+		.initlevel = _initlevel,				\
+		.lock = SPIN_LOCK_UNLOCKED,				\
+		.work = __DELAYED_WORK_INITIALIZER(_handle.work,	\
+			dti_register_work),				\
+		.info = NULL,						\
+	}
+
+#define INIT_DTI_HANDLE(_handle)					\
+	do {								\
+		if(_handle.info)					\
+			break;						\
+		_handle.info = dti_register_level(_handle.name,	\
+					_handle.initlevel, &_handle);	\
+		if (!_handle.info)					\
+			return -ENOMEM;					\
+		_handle.printk = dti_printk_normal_fn;			\
+		_handle.event = dti_event_normal_fn;			\
+		_handle.reserve = dti_reserve_normal_fn;		\
+		if (_handle.initbuf)					\
+			dti_relog_initbuf(&_handle);			\
+	} while (0)
+
+#define CLEANUP_DTI_HANDLE(_handle)					\
+	do {				 				\
+		dti_unregister(_handle.info);				\
+	} while (0)
+
+#ifdef MODULE
+#define DEFINE_DTI_HANDLE(_handle, _name, _size, _initlevel)		\
+	DEFINE_DTI_MODULE_HANDLE(_handle, _name, _size, _initlevel)
+#define DEFINE_DTI_EARLY_HANDLE(_handle, _name, _size, _initlevel,	\
+				_initbuf, _initbuf_size)		\
+	DEFINE_DTI_KERNEL_HANDLE(_handle, _name, _size, _initlevel, NULL, 0)
+#else
+#define DEFINE_DTI_HANDLE(_handle, _name, _size, _initlevel)		\
+	DEFINE_DTI_KERNEL_HANDLE(_handle, _name, _size, _initlevel, NULL, 0)
+#define DEFINE_DTI_EARLY_HANDLE(_handle, _name, _size, _initlevel,	\
+				_initbuf, _initbuf_size)		\
+	DEFINE_DTI_KERNEL_HANDLE(_handle, _name, _size, _initlevel,	\
+				 _initbuf, _initbuf_size)
+#endif /* MODULE */
+#else
+#define DEFINE_DTI_KERNEL_HANDLE(_handle, _name, _size, _initlevel,	\
+				 _initbuf, _initbuf_size)
+#define DEFINE_DTI_MODULE_HANDLE(_handle, _name, _size, _initlevel)
+#define INIT_DTI_HANDLE(_handle)
+#define CLEANUP_DTI_HANDLE(_handle)
+#define DEFINE_DTI_HANDLE(_handle, _name, _size, _initlevel)
+#define DEFINE_DTI_EARLY_HANDLE(_handle, _name, _size, _initlevel,	\
+				_initbuf, _initbuf_size)
+#endif /* CONFIG_DTI */
+
+/*
+ * handle-based logging functions
+ */
+
+#ifdef CONFIG_DTI
+#define dti_printk(_handle, _prio, _fmt, _args...)	\
+	dti_printk_handle(&(_handle), _prio, _fmt, ## _args)
+#define dti_event(_handle, _prio, _buf, _len)	\
+	dti_event_handle(&(_handle),	_prio, _buf, _len)
+#define dti_reserve(_handle, _prio, _len)	\
+	dti_reserve_handle(&(_handle), _prio, _len)
+#else
+#define dti_printk(_handle, _prio, _fmt, ...)
+#define dti_event(_handle, _prio, _buf, _len)
+#define dti_reserve(_handle, _prio, _len)
+#endif
+
+/**
+ * dti_assert: stop tracing if assertion fails, handle version
+ * @_handle: trace handle
+ * @_expr: expression to test
+ *
+ * If _expr evaluates false, tracing is stopped for _handle
+ */
+#ifdef CONFIG_DTI
+#define dti_assert(_handle, _expr)					\
+	do {				 				\
+		if (!(_expr) && _handle.info)				\
+			dti_set_level(_handle.info, DTI_LEVEL_OFF);	\
+	} while (0)
+#else
+#define dti_assert(_handle, _expr)
+#endif
+
+/*
+ * DTI low-level API
+ */
+
+#ifdef CONFIG_DTI
+struct dti_info *dti_register(const char *name, int size, int init_level);
+struct dti_info *__dti_register(const char *name, int size, int nr_sub,
+				int init_level);
+void dti_unregister(struct dti_info *trace);
+int __dti_printk(struct dti_info *trace, int prio, const char* fmt, ...);
+int __dti_event(struct dti_info *trace, int prio, const void* buf, size_t len);
+void *__dti_reserve(struct dti_info *trace, int prio, size_t len);
+void dti_set_level(struct dti_info *trace, int new_level);
+#else
+static inline struct dti_info *dti_register(const char *name, int size,
+					    int init_level)
+{
+	return NULL;
+}
+static inline struct dti_info *__dti_register(const char *name, int size,
+					      int nr_sub, int init_level)
+{
+	return NULL;
+}
+static inline void dti_unregister(struct dti_info *trace) {}
+static inline int __dti_printk(struct dti_info *trace, int prio,
+			       const char* fmt, ...) { return 0; }
+static inline int __dti_event(struct dti_info *trace, int prio,
+			      const void* buf, size_t len) { return 0; }
+static inline void *__dti_reserve(struct dti_info *trace, int prio, size_t len)
+{
+	return NULL;
+}
+static inline void dti_set_level(struct dti_info *trace, int new_level) {}
+#endif
+
+/**
+ * __dti_assert_raw: stop tracing if assertion fails, low-level version
+ * @_info: trace info struct
+ * @_expr: expression to test
+ *
+ * If _expr evaluates false, tracing is stopped for _info
+ */
+#ifdef CONFIG_DTI
+#define __dti_assert(_info, _expr)					\
+	do {				 				\
+		if (!(_expr) && _info)					\
+			dti_set_level(_info, DTI_LEVEL_OFF);		\
+	} while (0)
+#else
+#define __dti_assert(_info, _expr)
+#endif
+
+/*
+ * non-API declarations
+ */
+
+struct dti_info *dti_register_level(const char *name, int level,
+				    struct dti_handle *handle);
+void dti_register_work(struct work_struct *work);
+int dti_printk_handle(struct dti_handle *handle,int prio,
+		      const char* fmt, ...);
+int dti_printk_early_fn(struct dti_handle *handle, int prio, const char* fmt,
+			va_list args);
+int dti_printk_normal_fn(struct dti_handle *handle, int prio, const char* fmt,
+			 va_list args);
+int dti_event_handle(struct dti_handle *handle, int prio, const void* buf,
+		     size_t len);
+int dti_event_early_fn(struct dti_handle *handle, int prio, const void* buf,
+		       size_t len);
+int dti_event_normal_fn(struct dti_handle *handle, int prio, const void* buf,
+			size_t len);
+void *dti_reserve_handle(struct dti_handle *handle, int prio, size_t len);
+void *dti_reserve_early_fn(struct dti_handle *handle, int prio, size_t len);
+void *dti_reserve_normal_fn(struct dti_handle *handle, int prio, size_t len);
+int dti_relog_initbuf(struct dti_handle *handle);
+
+#endif /* _LINUX_DTI_H */



