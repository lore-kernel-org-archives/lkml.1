Return-Path: <linux-kernel-owner+w=401wt.eu-S1422935AbXBHLqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422935AbXBHLqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 06:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422939AbXBHLqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 06:46:22 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:59964 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422935AbXBHLqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 06:46:21 -0500
Message-ID: <45CB0D87.8070808@in.ibm.com>
Date: Thu, 08 Feb 2007 17:16:15 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060918)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Frederik Deweerdt <deweerdt@free.fr>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jkenisto@us.ibm.com,
       anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [RFC] [PATCH] To list all active probes in the system---Take-2
References: <45C85097.1000106@in.ibm.com> <20070206100607.GA10296@infradead.org> <45C856F1.7060403@in.ibm.com> <45C894EA.4060305@in.ibm.com> <20070206145609.GA11249@slug> <45C962C3.2020904@in.ibm.com> <20070207142717.5da4d8d4.akpm@linux-foundation.org>
In-Reply-To: <20070207142717.5da4d8d4.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------010202090703000609090004"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010202090703000609090004
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Wed, 07 Feb 2007 10:55:23 +0530
> Srinivasa Ds <srinivasa@in.ibm.com> wrote:
> 
>> --- linux-2.6.20.orig/fs/debugfs/inode.c
>> +++ linux-2.6.20/fs/debugfs/inode.c
>> @@ -25,6 +25,7 @@
>>  
>>  	if (retval)
>>  		subsystem_unregister(&debug_subsys);
>> +	debugfs_kprobe_init();
>>  	return retval;
>>  }
> 
> eww.  Didn't it feel bad when you did that?
> 
> 
> As this module has a dependency upon debugfs, I'd have thought the
> approproate way of expressing that would be to run debugfs_kprobe_init()
> at a lower initcall priority than debugfs_init()
> 
>> +
>> +	if (dir == NULL)
>> +		return;
>> +	debugfs_create_file("list", 0444, dir , 0 , &proc_kprobes_operations);
>> +}
>> +
>>  __initcall(init_kprobes);
> 
> debugfs_init() already runs at core_initcall level, presumably so that
> debugfs clients can use plain old module_init().
> 
>> +static inline void debugfs_kprobe_init(void)
>> +{
>> +}
> 
> In which case we don't need this.	

Updating the patch according to Andrew's comment.

  This patch lists all active probes in the system by scanning through
kprobe_table[]. It takes care of aggregate handlers and prints the type
of the probe.
Letter "k" for kprobes, "j" for jprobes, "r" for kretprobes. It also
lists address of the instruction,its symbolic name(function name +
offset) and the module name. One can access this file through
/sys/kernel/debug/kprobes/list.

Output looks like this
=====================
llm40:~/a # cat /sys/kernel/debug/kprobes/list
c0169ae3  r  sys_read+0x0
c0169ae3  k  sys_read+0x0
c01694c8  k  vfs_write+0x0
c0167d20  r  sys_open+0x0
f8e658a6  k  reiserfs_delete_inode+0x0  reiserfs
c0120f4a  k  do_fork+0x0
c0120f4a  j  do_fork+0x0
c0169b4a  r  sys_write+0x0
c0169b4a  k  sys_write+0x0
c0169622  r  vfs_read+0x0
=================================


Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>



--------------010202090703000609090004
Content-Type: text/x-patch;
 name="list.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="list.patch"

 kprobes.c |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

Index: linux-2.6.20/kernel/kprobes.c
===================================================================
--- linux-2.6.20.orig/kernel/kprobes.c
+++ linux-2.6.20/kernel/kprobes.c
@@ -39,6 +39,8 @@
 #include <linux/moduleloader.h>
 #include <linux/kallsyms.h>
 #include <linux/freezer.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
@@ -815,6 +817,108 @@ static int __init init_kprobes(void)
 	return err;
 }
 
+#ifdef CONFIG_DEBUG_FS
+static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
+               const char *sym, int offset,char *modname)
+{
+	char *kprobe_type;
+
+	if (p->pre_handler == pre_handler_kretprobe)
+		kprobe_type = "r";
+	else if (p->pre_handler == setjmp_pre_handler)
+		kprobe_type = "j";
+	else
+		kprobe_type = "k";
+	if (sym)
+		seq_printf(pi, "%p  %s  %s+0x%x  %s\n", p->addr, kprobe_type,
+			sym, offset, (modname ? modname : " "));
+	else
+		seq_printf(pi, "%p  %s  %p\n", p->addr, kprobe_type, p->addr);
+}
+
+void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
+{
+	return (*pos < KPROBE_TABLE_SIZE) ? pos : NULL;
+}
+
+void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos >= KPROBE_TABLE_SIZE)
+		return NULL;
+	return pos;
+}
+
+void __kprobes kprobe_seq_stop(struct seq_file *f, void *v)
+{
+	/* Nothing to do */
+}
+
+int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p, *kp;
+	const char *sym = NULL;
+	unsigned int i = *(loff_t *) v;
+	unsigned long size, offset = 0;
+	char *modname, namebuf[128];
+
+	head = &kprobe_table[i];
+	preempt_disable();
+	hlist_for_each_entry_rcu(p, node, head, hlist) {
+		sym = kallsyms_lookup((unsigned long)p->addr, &size,
+					&offset, &modname, namebuf);
+		if (p->pre_handler == aggr_pre_handler) {
+			list_for_each_entry_rcu(kp, &p->list, list)
+				report_probe(pi, kp, sym, offset, modname);
+		} else
+			report_probe(pi, p, sym, offset, modname);
+	}
+	preempt_enable();
+	return 0;
+}
+
+struct seq_operations kprobes_seq_ops = {
+	.start = kprobe_seq_start,
+	.next  = kprobe_seq_next,
+	.stop  = kprobe_seq_stop,
+	.show  = show_kprobe_addr
+};
+
+static int __kprobes kprobes_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &kprobes_seq_ops);
+}
+
+static struct file_operations debugfs_kprobes_operations = {
+	.open           = kprobes_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+static int __kprobes debugfs_kprobe_init(void)
+{
+	struct dentry *dir, *file;
+
+	dir = debugfs_create_dir("kprobes", NULL);
+	if (!dir)
+		return -ENOMEM;
+
+	file = debugfs_create_file("list", 0444, dir , 0 ,
+				&debugfs_kprobes_operations);
+	if (!file) {
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+module_init(debugfs_kprobe_init);
+#endif /* CONFIG_DEBUG_FS */
+
 __initcall(init_kprobes);
 
 EXPORT_SYMBOL_GPL(register_kprobe);

--------------010202090703000609090004--
