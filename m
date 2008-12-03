Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYLCA6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYLCA6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYLCA6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:58:06 -0500
Received: from smtp-out.google.com ([216.239.45.13]:61361 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbYLCA6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:58:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=r67ninoxEK/ZuLQAZ105rJeZtCfkcXImQq0qmlFCnPLjXunqT6AaeRsbOawKwPJos
	/tyulO+h5Whj1/mNL5pMA==
MIME-Version: 1.0
In-Reply-To: <5df78e1d0812021626y68c7241ahfdba4d37c7840e10@mail.gmail.com>
References: <5df78e1d0812021626y68c7241ahfdba4d37c7840e10@mail.gmail.com>
Date: Tue, 2 Dec 2008 16:58:00 -0800
Message-ID: <5df78e1d0812021658o1bac08a2v870d73698ff35ed3@mail.gmail.com>
Subject: [RFC PATCH 3/3] kernel tracing prototype
From: Jiaying Zhang <jiayingz@google.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>, Martin Bligh <mbligh@google.com>,
       Michael Rubin <mrubin@google.com>, Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refer to the previous email
"[RFC PATCH 0/3] A couple of feature requests to the unified trace buffer".

A kernel tracing prototype that uses the unified trace buffer to keep
the collected trace data.

Index: linux-2.6.26.2/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.26.2.orig/include/asm-generic/vmlinux.lds.h
2008-11-25 11:32:26.000000000 -0800
+++ linux-2.6.26.2/include/asm-generic/vmlinux.lds.h    2008-11-25
11:32:37.000000000 -0800
@@ -50,6 +50,9 @@
       MEM_KEEP(init.data)                                             \
       MEM_KEEP(exit.data)                                             \
       . = ALIGN(8);                                                   \
+       VMLINUX_SYMBOL(__start___ktraces) = .;                          \
+       *(__ktrace)                                                     \
+       VMLINUX_SYMBOL(__stop___ktraces) = .;                           \
       VMLINUX_SYMBOL(__start___markers) = .;                          \
       *(__markers)                                                    \
       VMLINUX_SYMBOL(__stop___markers) = .;
@@ -60,6 +63,7 @@
               VMLINUX_SYMBOL(__start_rodata) = .;                     \
               *(.rodata) *(.rodata.*)                                 \
               *(__vermagic)           /* Kernel version magic */      \
+               *(__ktrace_strings)     /* Ktrace: strings */           \
               *(__markers_strings)    /* Markers: strings */          \
       }                                                               \
                                                                       \
Index: linux-2.6.26.2/include/linux/ktrace.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26.2/include/linux/ktrace.h       2008-11-25
11:32:37.000000000 -0800
@@ -0,0 +1,73 @@
+#ifndef _LINUX_KTRACE_H
+#define _LINUX_KTRACE_H
+
+#include <linux/types.h>
+
+struct kernel_trace;
+
+typedef void ktrace_probe_func(struct kernel_trace *, void *, size_t);
+
+struct kernel_trace {
+       const char      *name;
+       const char      *format;  /* format string describing variable list */
+       u32             enabled:1, event_id:31;
+       ktrace_probe_func *func;  /* probe function */
+       struct list_head list;  /* list head linked to the hash table entry */
+} __attribute__((aligned(8)));
+
+extern int ktrace_enabled;
+
+/*
+ * Make sure the alignment of the structure in the __ktrace section will
+ * not add unwanted padding between the beginning of the section and the
+ * structure. Force alignment to the same alignment as the section start.
+ */
+
+#define DEFINE_KTRACE_STRUCT(name)     struct ktrace_struct_##name
+
+#ifdef CONFIG_KTRACE
+#define DO_TRACE(name, format, args...)
         \
+       do {                                                            \
+               static const char __kstrtab_##name[]                    \
+               __attribute__((section("__ktrace_strings")))            \
+               = #name "\0" format;                                    \
+               static struct kernel_trace __ktrace_##name              \
+               __attribute__((section("__ktrace"), aligned(8))) =      \
+               { __kstrtab_##name, &__kstrtab_##name[sizeof(#name)],   \
+               0, 0, NULL, LIST_HEAD_INIT(__ktrace_##name.list) };     \
+               __ktrace_check_format(format, ## args);                 \
+               if (unlikely(ktrace_enabled) &&                         \
+                               unlikely(__ktrace_##name.enabled)) {    \
+                       struct ktrace_struct_##name karg = { args };    \
+                       (*__ktrace_##name.func)                         \
+                       (&__ktrace_##name, &karg, sizeof(karg));        \
+               }                                                       \
+       } while (0)
+
+#else /* !CONFIG_KTRACE */
+#define DO_TRACE(name, format, args...)
+#endif
+
+/* To be used for string format validity checking with gcc */
+static inline void __printf(1, 2) ___ktrace_check_format(const char *fmt, ...)
+{
+}
+
+#define __ktrace_check_format(format, args...)                         \
+       do {                                                            \
+               if (0)                                                  \
+                       ___ktrace_check_format(format, ## args);        \
+       } while (0)
+
+
+int init_ktrace(void);
+void exit_ktrace(void);
+
+/* get the trace buffer information */
+#define KTRACE_BUF_GET_SIZE     _IOR(0xF5, 0x00,__u32)
+#define KTRACE_BUF_GET_PRODUCED _IOR(0xF5, 0x01,__u32)
+#define KTRACE_BUF_GET_CONSUMED _IOR(0xF5, 0x02,__u32)
+#define KTRACE_BUF_PUT_PRODUCED _IOW(0xF5, 0x03,__u32)
+#define KTRACE_BUF_PUT_CONSUMED _IOW(0xF5, 0x04,__u32)
+
+#endif
Index: linux-2.6.26.2/kernel/module.c
===================================================================
--- linux-2.6.26.2.orig/kernel/module.c 2008-11-25 11:32:26.000000000 -0800
+++ linux-2.6.26.2/kernel/module.c      2008-11-25 11:32:37.000000000 -0800
@@ -1770,6 +1770,8 @@
       unsigned int unusedgplcrcindex;
       unsigned int markersindex;
       unsigned int markersstringsindex;
+       unsigned int ktraceindex;
+       unsigned int ktracestringsindex;
       struct module *mod;
       long err = 0;
       void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -2050,6 +2052,10 @@
       markersstringsindex = find_sec(hdr, sechdrs, secstrings,
                                       "__markers_strings");

+       ktraceindex = find_sec(hdr, sechdrs, secstrings, "__ktrace");
+       ktracestringsindex = find_sec(hdr, sechdrs, secstrings,
+                                       "__ktrace_strings");
+
       /* Now do relocations. */
       for (i = 1; i < hdr->e_shnum; i++) {
               const char *strtab = (char *)sechdrs[strindex].sh_addr;
@@ -2077,6 +2083,11 @@
               sechdrs[markersindex].sh_size / sizeof(*mod->markers);
 #endif

+#ifdef CONFIG_KTRACE
+       mod->ktrace = (void *)sechdrs[ktraceindex].sh_addr;
+       mod->num_ktrace =
+               sechdrs[ktraceindex].sh_size / sizeof(*mod->ktrace);
+#endif
        /* Find duplicate symbols */
       err = verify_export_symbols(mod);

@@ -2099,6 +2110,7 @@
               marker_update_probe_range(mod->markers,
                       mod->markers + mod->num_markers);
 #endif
+
       err = module_finalize(hdr, sechdrs, mod);
       if (err < 0)
               goto cleanup;
Index: linux-2.6.26.2/include/linux/module.h
===================================================================
--- linux-2.6.26.2.orig/include/linux/module.h  2008-11-25
11:32:26.000000000 -0800
+++ linux-2.6.26.2/include/linux/module.h       2008-11-25
11:32:37.000000000 -0800
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/marker.h>
+#include <linux/ktrace.h>
 #include <asm/local.h>

 #include <asm/module.h>
@@ -342,6 +343,11 @@
       struct marker *markers;
       unsigned int num_markers;
 #endif
+#ifdef CONFIG_KTRACE
+       struct kernel_trace *ktrace;
+       unsigned int num_ktrace;
+#endif
+
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
Index: linux-2.6.26.2/kernel/ktrace/ktrace-mod.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26.2/kernel/ktrace/ktrace-mod.c   2008-11-25
11:32:37.000000000 -0800
@@ -0,0 +1,41 @@
+/*
+ * kernel/ktrace-mod.c
+ *
+ * the kernel tracing module wrapper
+ *
+ * Copyright 2008- Google Inc.
+ * Original Author:
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/bitmap.h>
+#include <linux/rcupdate.h>
+#include <linux/relay.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/linkage.h>
+#include <linux/debugfs.h>
+#include <linux/timer.h>
+#include <linux/delay.h>
+#include <linux/jhash.h>
+#include <linux/ktrace.h>
+#include <linux/ring_buffer.h>
+
+static int __init init_ktrace_module(void)
+{
+       return init_ktrace();
+}
+
+static void __exit exit_ktrace_module(void)
+{
+       exit_ktrace();
+}
+
+module_init(init_ktrace_module);
+module_exit(exit_ktrace_module);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jiaying Zhang <jiayingz@google.com>");
+MODULE_DESCRIPTION("Kernel Tracing Module");
+
Index: linux-2.6.26.2/kernel/ktrace/ktrace.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26.2/kernel/ktrace/ktrace.c       2008-11-25
16:34:31.000000000 -0800
@@ -0,0 +1,658 @@
+/*
+ * kernel/ktrace.c
+ *
+ * Implementation of the kernel tracing for linux kernel 2.6.
+ *
+ * Copyright 2008- Google Inc.
+ * Original Author: Jiaying Zhang
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/bitmap.h>
+#include <linux/poll.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/linkage.h>
+#include <linux/debugfs.h>
+#include <linux/timer.h>
+#include <linux/delay.h>
+#include <linux/jhash.h>
+#include <linux/ktrace.h>
+#include <linux/ring_buffer.h>
+
+int ktrace_enabled = 0;
+EXPORT_SYMBOL(ktrace_enabled);
+static uint16_t ktrace_next_id = 0;
+
+extern struct kernel_trace __start___ktraces[];
+extern struct kernel_trace __stop___ktraces[];
+
+static DEFINE_MUTEX(ktrace_mutex);
+
+/* ktrace hash table entry structure and variables */
+struct ktrace_entry {
+       struct hlist_node       hlist;
+       char                    *name;
+       char                    *format;
+       ktrace_probe_func       *func;
+       u32                     enabled:1, event_id:31;
+       struct list_head        klist;  /* list of loaded ktraces */
+};
+
+#define KTRACE_HASH_BITS 6
+#define KTRACE_HASH_SIZE (1 << KTRACE_HASH_BITS)
+static struct hlist_head ktrace_table[KTRACE_HASH_SIZE];
+
+/* debugfs directory variables */
+static struct dentry *tracedir = NULL;
+static struct dentry *eventdir = NULL;
+
+/* ring buffer code */
+static unsigned long trace_buf_size = 16384UL;
+struct ring_buffer *trace_buffer = NULL;
+static DECLARE_WAIT_QUEUE_HEAD(trace_wait); /* waitqueue for trace_data_poll */
+static struct timer_list trace_timer; /* reader wake-up timer */
+#define TRACEREAD_WAKEUP_INTERVAL      1000
+static struct kref ktrace_kref;
+
+/*
+static void
+ring_buffer_probe(struct kernel_trace *kt, void *data, size_t event_size)
+{
+       struct ring_buffer_event *event;
+       void *trace_event;
+       unsigned long flag;
+
+
+       event = __ring_buffer_lock_reserve(trace_buffer,
+                       sizeof(uint16_t) + event_size);
+       trace_event = ring_buffer_event_data(event);
+       *(uint16_t *) trace_event = kt->event_id;
+       memcpy(trace_event + sizeof(uint16_t), data, event_size);
+       __ring_buffer_unlock_commit(trace_buffer, event);
+}
+*/
+
+static void
+ring_buffer_probe(struct kernel_trace *kt, void *data, size_t event_size)
+{
+       struct ring_buffer_event *event;
+       void *trace_event;
+       unsigned long flag;
+
+
+       event = ring_buffer_lock_reserve(trace_buffer,
+                       sizeof(uint16_t) + event_size, &flag);
+       trace_event = ring_buffer_event_data(event);
+       *(uint16_t *) trace_event = kt->event_id;
+       memcpy(trace_event + sizeof(uint16_t), data, event_size);
+       ring_buffer_unlock_commit(trace_buffer, event, flag);
+}
+
+/* timer function used to defer ring buffer reader waking */
+static void wakeup_readers(unsigned long data)
+{
+       wake_up_interruptible(&trace_wait);
+       mod_timer(&trace_timer, jiffies + TRACEREAD_WAKEUP_INTERVAL);
+}
+
+/* function for reading ktrace metadata info */
+static void *tracing_info_start(struct seq_file *seq, loff_t *pos)
+{
+       return (*pos >= KTRACE_HASH_SIZE) ? NULL : &ktrace_table[*pos];
+}
+
+static void *tracing_info_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+       ++*pos;
+       return (*pos >= KTRACE_HASH_SIZE) ? NULL : &ktrace_table[*pos];
+}
+
+static int tracing_info_show(struct seq_file *seq, void *v)
+{
+       struct hlist_head *head = v;
+       struct hlist_node *node;
+       struct ktrace_entry *entry;
+       hlist_for_each_entry(entry, node, head, hlist)
+               seq_printf(seq, "name '%s' format '%s' id %u %s\n",
+                       entry->name, entry->format, entry->event_id,
+                       entry->enabled ? "enabled" : "disabled");
+       return 0;
+}
+
+static void tracing_info_stop(struct seq_file *seq, void *v)
+{
+}
+
+static struct seq_operations tracing_info_seq_ops = {
+       .start  = tracing_info_start,
+       .next   = tracing_info_next,
+       .show   = tracing_info_show,
+       .stop   = tracing_info_stop,
+};
+
+static int tracing_info_open(struct inode *inode, struct file *file)
+{
+       return seq_open(file, &tracing_info_seq_ops);
+}
+
+static struct file_operations traceinfo_file_operations = {
+       .open   = tracing_info_open,
+       .read   = seq_read,
+       .llseek = seq_lseek,
+       .release = seq_release,
+};
+
+/* functions for reading/writing the global 'enabled' control file */
+static ssize_t tracing_control_read(struct file *filp, char __user *ubuf,
+               size_t cnt, loff_t *ppos)
+{
+       int ret;
+       char buf[64];
+       ret = sprintf(buf, "%u\n", ktrace_enabled);
+       return simple_read_from_buffer(ubuf, cnt, ppos, buf, ret);
+}
+
+static ssize_t tracing_control_write(struct file *filp, const char
__user *ubuf,
+               size_t cnt, loff_t *ppos)
+{
+       int ret;
+       char buf[64];
+       unsigned long val;
+
+       if (cnt >= sizeof(buf))
+               return -EINVAL;
+       if (copy_from_user(&buf, ubuf, cnt))
+               return -EFAULT;
+       buf[cnt] = 0;
+
+       ret = strict_strtoul(buf, 10, &val);
+       if (ret < 0)
+               return ret;
+
+       if (val ^ ktrace_enabled) {
+               if (val) {
+                       set_kernel_trace_flag_all_tasks();
+                       trace_timer.expires =
+                               jiffies + TRACEREAD_WAKEUP_INTERVAL;
+                       add_timer(&trace_timer);
+                       ktrace_enabled = 1;
+               } else {
+                       clear_kernel_trace_flag_all_tasks();
+                       ktrace_enabled = 0;
+                       del_timer_sync(&trace_timer);
+               }
+       }
+
+       filp->f_pos += cnt;
+       return cnt;
+}
+
+static struct file_operations tracecontrol_file_operations = {
+       .read   = tracing_control_read,
+       .write  = tracing_control_write,
+};
+
+/* functions for reading/writing a trace event file */
+static int update_ktrace(struct ktrace_entry *entry,
+               ktrace_probe_func *func, int enabled)
+{
+       struct kernel_trace *iter;
+       /* no need to update the list if the tracing is not initialied */
+       if (!tracedir)
+               return 0;
+       entry->enabled = enabled;
+       entry->func = func;
+       list_for_each_entry(iter, &entry->klist, list) {
+               iter->func = func;
+               iter->enabled = enabled;
+       }
+       return 0;
+}
+
+static int ktrace_probe_register(struct ktrace_entry *entry,
+               ktrace_probe_func *probefunc)
+{
+       return update_ktrace(entry, probefunc, 1);
+}
+
+static int ktrace_probe_unregister(struct ktrace_entry *entry)
+{
+       return update_ktrace(entry, NULL, 0);
+}
+
+static int ktrace_control_open(struct inode *inode, struct file *filp)
+{
+       filp->private_data = inode->i_private;
+       return 0;
+}
+
+static ssize_t ktrace_control_read(struct file *filp, char __user *ubuf,
+               size_t cnt, loff_t *ppos)
+{
+       int ret;
+       char buf[64];
+       struct ktrace_entry *entry = filp->private_data;
+
+       ret = sprintf(buf, "%u\n", entry->enabled);
+       return simple_read_from_buffer(ubuf, cnt, ppos, buf, ret);
+}
+
+static ssize_t ktrace_control_write(struct file *filp, const char __user *ubuf,
+               size_t cnt, loff_t *ppos)
+{
+       int ret;
+       char buf[64];
+       unsigned long val;
+       struct ktrace_entry *entry = filp->private_data;
+
+       if (cnt >= sizeof(buf))
+               return -EINVAL;
+       if (copy_from_user(&buf, ubuf, cnt))
+               return -EFAULT;
+       buf[cnt] = 0;
+
+       ret = strict_strtoul(buf, 10, &val);
+       if (ret < 0)
+               return ret;
+       val = !!val;
+
+       mutex_lock(&ktrace_mutex);
+       if (val ^ entry->enabled) {
+               if (val)
+                       ktrace_probe_register(entry, ring_buffer_probe);
+               else
+                       ktrace_probe_unregister(entry);
+       }
+       mutex_unlock(&ktrace_mutex);
+       return cnt;
+}
+
+static struct file_operations ktracecontrol_file_operations = {
+       .open   = ktrace_control_open,
+       .read   = ktrace_control_read,
+       .write  = ktrace_control_write,
+};
+
+/* functions for adding/removing a trace event. Protected by mutex lock.
+ * Called during initialization or after loading a module */
+static struct ktrace_entry * add_ktrace(struct kernel_trace *ktrace)
+{
+       struct ktrace_entry *entry;
+       size_t name_len = strlen(ktrace->name) + 1;
+       u32 hash = jhash(ktrace->name, name_len-1, 0);
+       struct hlist_head *head;
+       struct hlist_node *node;
+       struct dentry *dentry;
+
+       if (!tracedir)
+               return 0;
+       head = &ktrace_table[hash & ((1 << KTRACE_HASH_BITS)-1)];
+       hlist_for_each_entry(entry, node, head, hlist) {
+               if (!strcmp(ktrace->name, entry->name)) {
+                       if (strcmp(ktrace->format, entry->format)) {
+                               printk(KERN_WARNING "the format of tracepoint "
+                                       "\'%s\' changes from \'%s\' to \'%s\'."
+                                       "Please re-load ktrace module first!\n",
+                                       ktrace->name, entry->format,
+                                       ktrace->format);
+                               return ERR_PTR(-EINVAL);
+                       }
+                       ktrace->enabled = entry->enabled;
+                       ktrace->func = entry->func;
+                       if (list_empty(&entry->klist))
+                               goto add_head;
+                       list_add_tail(&ktrace->list, &entry->klist);
+                       return entry;
+               }
+       }
+       entry = kmalloc(sizeof(struct ktrace_entry), GFP_KERNEL);
+       if (!entry)
+               return ERR_PTR(-ENOMEM);
+       entry->name = kmalloc(name_len, GFP_KERNEL);
+       if (!entry->name)
+               return ERR_PTR(-ENOMEM);
+       memcpy(entry->name, ktrace->name, name_len);
+       if (ktrace->format) {
+               size_t format_len = strlen(ktrace->format) + 1;
+               entry->format = kmalloc(format_len, GFP_KERNEL);
+               if (!entry->format)
+                       return ERR_PTR(-ENOMEM);
+               memcpy(entry->format, ktrace->format, format_len);
+       } else
+               entry->format = NULL;
+       entry->func = ktrace->func;
+       entry->enabled = 0;
+       entry->event_id = ktrace_next_id ++;
+       INIT_LIST_HEAD(&entry->klist);
+       hlist_add_head(&entry->hlist, head);
+add_head:
+       list_add(&ktrace->list, &entry->klist);
+       dentry = debugfs_create_file(entry->name, 0444, eventdir,
+                               entry, &ktracecontrol_file_operations);
+       if (!dentry)
+               printk("Couldn't create debugfs '%s' entry\n", entry->name);
+       return entry;
+}
+
+static int remove_ktrace(struct kernel_trace *ktrace, int free)
+{
+       struct ktrace_entry *entry;
+       size_t name_len = strlen(ktrace->name) + 1;
+       u32 hash = jhash(ktrace->name, name_len-1, 0);
+       struct hlist_head *head;
+       struct hlist_node *node, *temp;
+       struct dentry *dentry;
+
+       if (!tracedir)
+               return 0;
+       list_del(&ktrace->list);
+       head = &ktrace_table[hash & ((1 << KTRACE_HASH_BITS)-1)];
+       hlist_for_each_entry_safe(entry, node, temp, head, hlist)
+               if (!strcmp(ktrace->name, entry->name)) {
+                       if (list_empty(&entry->klist)) {
+                               dentry = lookup_one_len(entry->name,
+                                       eventdir, strlen(entry->name));
+                               if (dentry && !IS_ERR(dentry)) {
+                                       debugfs_remove(dentry);
+                                       dput(dentry);
+                               }
+                               entry->enabled = 0;
+                               if (free) {
+                                       hlist_del(&entry->hlist);
+                                       kfree(entry->name);
+                                       kfree(entry->format);
+                                       kfree(entry);
+                               }
+                       }
+                       return 0;
+               }
+       return -1;
+}
+
+/* Add/remove tracepoints contained in a module to the ktrace hash table.
+ * Called at the end of module load/unload. */
+static int ktrace_module_notify(struct notifier_block * self,
+               unsigned long val, void * data)
+{
+#ifdef CONFIG_MODULES
+       struct kernel_trace *iter;
+       struct module *mod = data;
+
+       if (val != MODULE_STATE_COMING && val != MODULE_STATE_GOING)
+               return 0;
+       mutex_lock(&ktrace_mutex);
+       for (iter = mod->ktrace; iter < mod->ktrace + mod->num_ktrace; iter ++)
+               if (val == MODULE_STATE_COMING)
+                       add_ktrace(iter);
+               else
+                       remove_ktrace(iter, 0);
+       mutex_unlock(&ktrace_mutex);
+#endif
+       return 0;
+}
+
+static struct notifier_block ktrace_module_nb = {
+       .notifier_call  = ktrace_module_notify,
+};
+
+/* functions for user-space programs to read data from tracing buffer */
+static int trace_data_open(struct inode *inode, struct file *filp)
+{
+       filp->private_data = inode->i_private;
+       kref_get(&ktrace_kref);
+       return 0;
+}
+
+static void release_trace_buffer(struct kref *kref)
+{
+       ring_buffer_free(trace_buffer);
+       trace_buffer = NULL;
+}
+
+static int trace_data_release(struct inode *inode, struct file *filp)
+{
+       kref_put(&ktrace_kref, release_trace_buffer);
+       return 0;
+}
+
+static unsigned int trace_data_poll(struct file *filp, poll_table *poll_table)
+{
+       struct ring_buffer_per_cpu *cpu_buffer = filp->private_data;
+       if (!ktrace_enabled)
+               return POLLERR;
+       if (filp->f_mode & FMODE_READ) {
+               while (1) {
+                       poll_wait(filp, &trace_wait, poll_table);
+                       if (!ring_buffer_per_cpu_empty(cpu_buffer))
+                               return POLLIN | POLLRDNORM;
+               }
+       }
+       return 0;
+}
+
+static int trace_buf_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+       struct ring_buffer_per_cpu *cpu_buffer = vma->vm_private_data;
+       pgoff_t pgoff = vmf->pgoff;
+       struct page *page;
+
+       if (!trace_buffer)
+               return VM_FAULT_OOM;
+       if ((page = ring_buffer_get_page(cpu_buffer, pgoff)) == NULL)
+               return VM_FAULT_SIGBUS;
+       get_page(page);
+       vmf->page = page;
+       return 0;
+}
+
+static struct vm_operations_struct trace_data_mmap_ops = {
+       .fault = trace_buf_fault,
+};
+
+static int trace_data_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+       unsigned long length = vma->vm_end - vma->vm_start;
+       struct ring_buffer_per_cpu *cpu_buffer = filp->private_data;
+
+       if (length != ring_buffer_size(trace_buffer))
+               return -EINVAL;
+       vma->vm_ops = &trace_data_mmap_ops;
+       vma->vm_flags |= VM_DONTEXPAND;
+       vma->vm_private_data = cpu_buffer;
+       return 0;
+}
+
+static int trace_data_ioctl(struct inode *inode, struct file *filp,
+               unsigned int cmd, unsigned long arg)
+{
+       u32 __user *argp = (u32 __user *)arg;
+       struct ring_buffer_per_cpu *cpu_buffer = filp->private_data;
+
+       if (!trace_buffer || !tracedir)
+               return -EINVAL;
+       switch (cmd) {
+       case KTRACE_BUF_GET_SIZE:
+       {
+               unsigned long bufsize;
+               bufsize = ring_buffer_size(trace_buffer);
+               return put_user((u32)bufsize, argp);
+       }
+       case KTRACE_BUF_GET_PRODUCED:
+               return
put_user((u32)ring_buffer_get_produced(cpu_buffer), argp);
+       case KTRACE_BUF_GET_CONSUMED:
+               return
put_user((u32)ring_buffer_get_consumed(cpu_buffer), argp);
+       case KTRACE_BUF_PUT_CONSUMED:
+       {
+               u32 consumed, consumed_old;
+               unsigned long bufsize = ring_buffer_size(trace_buffer);
+               int ret;
+
+               ret = get_user(consumed, argp);
+               if (ret) {
+                       printk("error getting consumed value: %d\n", ret);
+                       return ret;
+               }
+               consumed_old = ring_buffer_get_consumed(cpu_buffer);
+               if (consumed == consumed_old)
+                       return 0;
+               ring_buffer_advance_reader(cpu_buffer, consumed - consumed_old);
+               break;
+       }
+       default:
+               return -ENOIOCTLCMD;
+       }
+       return 0;
+}
+
+static struct file_operations tracedata_file_operations = {
+       .open           = trace_data_open,
+       .poll           = trace_data_poll,
+       .mmap           = trace_data_mmap,
+       .ioctl          = trace_data_ioctl,
+       .release        = trace_data_release,
+};
+
+static int create_debugfs(void)
+{
+       struct dentry *entry, *bufdir;
+       struct ring_buffer_per_cpu *cpu_buffer;
+       char *tmpname;
+       int cpu;
+
+       tracedir = debugfs_create_dir("ktrace", NULL);
+       if (!tracedir) {
+               printk("Couldn't create debugfs directory\n");
+               return -ENOMEM;
+       }
+
+       bufdir = debugfs_create_dir("buffers", tracedir);
+       if (!bufdir) {
+               printk("Couldn't create 'buffers' directory\n");
+               return -ENOMEM;
+       }
+
+       tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
+       if (!tmpname)
+               return -ENOMEM;
+       for_each_possible_cpu(cpu) {
+               snprintf(tmpname, NAME_MAX, "%s%d", "cpu", cpu);
+               cpu_buffer = ring_buffer_cpu(trace_buffer, cpu);
+               entry = debugfs_create_file(tmpname, 0444, bufdir, cpu_buffer,
+                       &tracedata_file_operations);
+               if (!entry) {
+                       printk("Couldn't create debugfs \'%s\' entry\n",
+                                       tmpname);
+                       return -ENOMEM;
+               }
+       }
+       kfree(tmpname);
+
+       entry = debugfs_create_file("enabled", 0444, tracedir, NULL,
+                       &tracecontrol_file_operations);
+       if (!entry) {
+               printk("Couldn't create debugfs 'enabled' entry\n");
+               return -ENOMEM;
+       }
+
+       entry = debugfs_create_file("info", 0222, tracedir, NULL,
+                       &traceinfo_file_operations);
+       if (!entry) {
+               printk("Couldn't create debugfs 'info' entry\n");
+               return -ENOMEM;
+       }
+
+       eventdir = debugfs_create_dir("events", tracedir);
+       if (!eventdir) {
+               printk("Couldn't create 'events' directory\n");
+               return -ENOMEM;
+       }
+       return 0;
+}
+
+static int remove_debugfs(void)
+{
+       struct dentry *dentry, *bufdir;
+       char *tmpname;
+       int cpu;
+
+       bufdir = lookup_one_len("buffers", tracedir, strlen("buffers"));
+       if (!bufdir || IS_ERR(bufdir))
+               return -EIO;
+       tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
+       if (!tmpname)
+               return -ENOMEM;
+       for_each_possible_cpu(cpu) {
+               snprintf(tmpname, NAME_MAX, "%s%d", "cpu", cpu);
+               dentry = lookup_one_len(tmpname, bufdir, strlen(tmpname));
+               if (dentry && !IS_ERR(dentry)) {
+                       debugfs_remove(dentry);
+                       dput(dentry);
+               }
+       }
+       kfree(tmpname);
+       debugfs_remove(bufdir);
+
+       dentry = lookup_one_len("enabled", tracedir, strlen("enabled"));
+       if (dentry && !IS_ERR(dentry)) {
+               debugfs_remove(dentry);
+               dput(dentry);
+       }
+       dentry = lookup_one_len("info", tracedir, strlen("info"));
+       if (dentry && !IS_ERR(dentry)) {
+               debugfs_remove(dentry);
+               dput(dentry);
+       }
+       debugfs_remove(eventdir);
+       debugfs_remove(tracedir);
+       eventdir = NULL;
+       tracedir = NULL;
+       return 0;
+}
+
+int init_ktrace(void)
+{
+       struct kernel_trace *iter;
+       int i, err;
+
+       ktrace_next_id = 0;
+       kref_set(&ktrace_kref, 1);
+       trace_buffer = ring_buffer_alloc(trace_buf_size, RB_FL_OVERWRITE);
+       if (trace_buffer == NULL)
+               return -ENOMEM;
+       setup_timer(&trace_timer, wakeup_readers, 0);
+       for (i = 0; i < KTRACE_HASH_SIZE; i++)
+               INIT_HLIST_HEAD(&ktrace_table[i]);
+
+       mutex_lock(&ktrace_mutex);
+       if ((err = create_debugfs()) != 0)
+               goto out;
+       for (iter = __start___ktraces; iter < __stop___ktraces; iter++)
+               add_ktrace(iter);
+       err = register_module_notifier(&ktrace_module_nb);
+out:
+       mutex_unlock(&ktrace_mutex);
+       return err;
+}
+EXPORT_SYMBOL_GPL(init_ktrace);
+
+void exit_ktrace(void)
+{
+       struct kernel_trace *iter;
+
+       if (ktrace_enabled) {
+               clear_kernel_trace_flag_all_tasks();
+               ktrace_enabled = 0;
+               del_timer_sync(&trace_timer);
+       }
+       mutex_lock(&ktrace_mutex);
+       for (iter = __start___ktraces; iter < __stop___ktraces; iter++)
+               remove_ktrace(iter, 1);
+       unregister_module_notifier(&ktrace_module_nb);
+       remove_debugfs();
+       mutex_unlock(&ktrace_mutex);
+
+       kref_put(&ktrace_kref, release_trace_buffer);
+}
+EXPORT_SYMBOL_GPL(exit_ktrace);
