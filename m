Return-Path: <linux-kernel-owner+w=401wt.eu-S965520AbXBGFZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965520AbXBGFZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 00:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965639AbXBGFZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 00:25:53 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:33257 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965520AbXBGFZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 00:25:47 -0500
Message-ID: <45C962C3.2020904@in.ibm.com>
Date: Wed, 07 Feb 2007 10:55:23 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060918)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org, jkenisto@us.ibm.com,
       anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [RFC] [PATCH] To list all active probes in the system
References: <45C85097.1000106@in.ibm.com> <20070206100607.GA10296@infradead.org> <45C856F1.7060403@in.ibm.com> <45C894EA.4060305@in.ibm.com> <20070206145609.GA11249@slug>
In-Reply-To: <20070206145609.GA11249@slug>
Content-Type: multipart/mixed;
 boundary="------------060103070602020904000204"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060103070602020904000204
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Frederik Deweerdt wrote:
> Hi,
> 
> Comments below,
> 
> On Tue, Feb 06, 2007 at 08:17:06PM +0530, Srinivasa Ds wrote:
>> Srinivasa Ds wrote:
>>> Christoph Hellwig wrote:
>>>> On Tue, Feb 06, 2007 at 03:25:35PM +0530, Srinivasa Ds wrote:
>>>>> Hi folks
>>>>>
>>>>>         I have developed a patch, that lists all active probes in the
>>>>> system. I have done this through /proc interface. Currently list is
>>>>> available under /proc/kprobes/list. Any suggestions for better place and
>>>>> name??
>>>> /debug/kprobes/list? :)
>>>>
>>> Good Idea, I will update my patch to use debugfs.
>> Patch that uses debugfs.
>>
>> Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
>>
>>
>>
>>
>>
> 
>>  fs/debugfs/inode.c      |    4 ++
>>  include/linux/kprobes.h |    4 ++
>>  kernel/kprobes.c        |   92 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 100 insertions(+)
>>
>> Index: linux-2.6.20/fs/debugfs/inode.c
>> ===================================================================
>> --- linux-2.6.20.orig/fs/debugfs/inode.c
>> +++ linux-2.6.20/fs/debugfs/inode.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/namei.h>
>>  #include <linux/debugfs.h>
>>  #include <linux/fsnotify.h>
>> +#include <linux/kprobes.h>
>>  
>>  #define DEBUGFS_MAGIC	0x64626720
>>  
>> @@ -320,6 +321,9 @@ static int __init debugfs_init(void)
>>  	retval = register_filesystem(&debug_fs_type);
>>  	if (retval)
>>  		subsystem_unregister(&debug_subsys);
>> +#ifdef CONFIG_KPROBES
>> +	debugfs_kprobe_init();
>> +#endif
> The ifdef here could be skipped if ....
>>  	return retval;
>>  }
>>  
> [... snip ...]
>> Index: linux-2.6.20/include/linux/kprobes.h
>> ===================================================================
>> --- linux-2.6.20.orig/include/linux/kprobes.h
>> +++ linux-2.6.20/include/linux/kprobes.h
>> @@ -203,6 +203,7 @@ struct kretprobe_instance *get_free_rp_i
>>  void add_rp_inst(struct kretprobe_instance *ri);
>>  void kprobe_flush_task(struct task_struct *tk);
>>  void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
>> +void debugfs_kprobe_init(void);
>>  #else /* CONFIG_KPROBES */
>>  
>>  #define __kprobes	/**/
>> @@ -240,5 +241,8 @@ static inline void unregister_kretprobe(
>>  static inline void kprobe_flush_task(struct task_struct *tk)
>>  {
>>  }
>> +static inline void proc_kprobe_init(void)
>> +{
>> +}
> ... this was renamed to debugfs_kprobe_init() instead -which was your
> first intention I suppose ;)-
> 
> Regards,
> Frederik

Oh, Iam sorry, It should be renamed to debugfs_kprobe_init().

So finally

 My patch lists all active probes in the system by scanning through
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



--------------060103070602020904000204
Content-Type: text/plain;
 name="final-2.fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="final-2.fix"

 fs/debugfs/inode.c      |    2 +
 include/linux/kprobes.h |    4 ++
 kernel/kprobes.c        |   92 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

Index: linux-2.6.20/fs/debugfs/inode.c
===================================================================
--- linux-2.6.20.orig/fs/debugfs/inode.c
+++ linux-2.6.20/fs/debugfs/inode.c
@@ -25,6 +25,7 @@
 #include <linux/namei.h>
 #include <linux/debugfs.h>
 #include <linux/fsnotify.h>
+#include <linux/kprobes.h>
 
 #define DEBUGFS_MAGIC	0x64626720
 
@@ -320,6 +321,7 @@ static int __init debugfs_init(void)
 	retval = register_filesystem(&debug_fs_type);
 	if (retval)
 		subsystem_unregister(&debug_subsys);
+	debugfs_kprobe_init();
 	return retval;
 }
 
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
@@ -815,6 +817,96 @@ static int __init init_kprobes(void)
 	return err;
 }
 
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
+	unsigned int i = *(loff_t *) v;
+	unsigned long size, offset = 0;
+	char *modname, namebuf[128];
+	const char *sym = NULL;
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
+static struct file_operations proc_kprobes_operations = {
+	.open           = kprobes_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+void __kprobes debugfs_kprobe_init(void)
+{
+	struct dentry *dir;
+	
+	dir = debugfs_create_dir("kprobes", NULL);
+	if (dir == NULL)
+		return;
+	debugfs_create_file("list", 0444, dir , 0 , &proc_kprobes_operations);
+}
+
 __initcall(init_kprobes);
 
 EXPORT_SYMBOL_GPL(register_kprobe);
Index: linux-2.6.20/include/linux/kprobes.h
===================================================================
--- linux-2.6.20.orig/include/linux/kprobes.h
+++ linux-2.6.20/include/linux/kprobes.h
@@ -203,6 +203,7 @@ struct kretprobe_instance *get_free_rp_i
 void add_rp_inst(struct kretprobe_instance *ri);
 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
+void debugfs_kprobe_init(void);
 #else /* CONFIG_KPROBES */
 
 #define __kprobes	/**/
@@ -240,5 +241,8 @@ static inline void unregister_kretprobe(
 static inline void kprobe_flush_task(struct task_struct *tk)
 {
 }
+static inline void debugfs_kprobe_init(void)
+{
+}
 #endif				/* CONFIG_KPROBES */
 #endif				/* _LINUX_KPROBES_H */

--------------060103070602020904000204--
