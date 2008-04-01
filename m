Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbYDAVsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbYDAVsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758009AbYDAVsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:48:23 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35989 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbYDAVsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:48:22 -0400
Date: Tue, 1 Apr 2008 14:47:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] dynamic printk - core infrastructure
Message-Id: <20080401144744.d0d10504.randy.dunlap@oracle.com>
In-Reply-To: <20080401194951.GC12029@redhat.com>
References: <20080401194951.GC12029@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008 15:49:51 -0400 Jason Baron wrote:

> 
> Add the ability to dynamically enable/disable pr_debug()/dev_dbg() in the
> kernel. Yes, these calls could be converted to printk(KERN_DEBUG), but there
> are enough to cause overhead. Additionally, the logs become difficult to read.
> Here, one can turn on and off these messages per .c source file via:
> 
> echo "add file.c" > /sys/kernel/debug/dynamic_printk/files
> echo "remove file.c" > /sys/kernel/debug/dynamic_printk/files

Is <filename> the full path name or just the basename of the file?
If just the basename, what happens for files that have duplicated
basenames throughout the kernel tree?

> There is also a special 'all' value that turns on all the debugging messages.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
> 
>  include/linux/device.h |   12 ++
>  include/linux/kernel.h |   11 ++
>  lib/Kconfig.debug      |   34 ++++++
>  lib/Makefile           |    2 
>  lib/dynamic_printk.c   |  253 ++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 312 insertions(+), 0 deletions(-)
>  create mode 100644 lib/dynamic_printk.c
> 
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index db375be..b007f61 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -587,6 +587,17 @@ extern const char *dev_driver_string(struct device *dev);
>  #define dev_info(dev, format, arg...)		\
>  	dev_printk(KERN_INFO , dev , format , ## arg)
>  
> +#ifdef CONFIG_DYNAMIC_PRINTK
> +extern void dyanmic_printk(char *, char *, ...);
> +DECLARE_IMV(char, dynamic_debug_on);
> +#define dev_dbg(dev, format, arg...)					\
> +	do {								\
> +	   if (unlikely(imv_read(dynamic_debug_on)))			\
> +		dynamic_printk(__FILE__, KERN_DEBUG "%s %s: " format,	\
> +				dev_driver_string(dev), (dev)->bus_id,	\
> +				## arg);				\
> +	} while (0)
> +#else
>  #ifdef DEBUG
>  #define dev_dbg(dev, format, arg...)		\
>  	dev_printk(KERN_DEBUG , dev , format , ## arg)
> @@ -597,6 +608,7 @@ dev_dbg(struct device *dev, const char *fmt, ...)
>  	return 0;
>  }
>  #endif
> +#endif
>  
>  #ifdef VERBOSE_DEBUG
>  #define dev_vdbg	dev_dbg
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index ff356b2..a311e87 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -14,6 +14,7 @@
>  #include <linux/compiler.h>
>  #include <linux/bitops.h>
>  #include <linux/log2.h>
> +#include <linux/immediate.h>
>  #include <asm/byteorder.h>
>  #include <asm/bug.h>
>  
> @@ -276,6 +277,15 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
>  #define pr_info(fmt, arg...) \
>  	printk(KERN_INFO fmt, ##arg)
>  
> +#ifdef CONFIG_DYNAMIC_PRINTK
> +extern void dynamic_printk(char *, char *, ...);
> +DECLARE_IMV(char, dynamic_debug_on);
> +#define pr_debug(fmt, ...)						\
> +     do {								\
> +	if (unlikely(imv_read(dynamic_debug_on)))			\
> +		dynamic_printk(__FILE__, KERN_DEBUG fmt, ##__VA_ARGS__);\
> +     } while (0)

That indentation should be more like it is in dev_dbg() above.

> +#else
>  #ifdef DEBUG
>  /* If you are writing a driver, please use dev_dbg instead */
>  #define pr_debug(fmt, arg...) \
> @@ -286,6 +296,7 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
>  	return 0;
>  }
>  #endif
> +#endif
>  
>  /*
>   *      Display an IP address in readable format.
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 0d8a5a4..5454c0a 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -615,4 +615,38 @@ config PROVIDE_OHCI1394_DMA_INIT
>  
>  	  See Documentation/debugging-via-ohci1394.txt for more information.
>  
> +config DYNAMIC_PRINTK
> +	bool "Enable dynamic printk() call support"
> +	default y

Why default yes?

> +	depends on PRINTK
> +	help
> +	  
> +	  allows pr_debug() and dev_dbg() calls to be dynamically enabled based

          Allows

> +	  upon their .c source file. Traditionally, these calls are only
> +	  enabled if one set #define DEBUG and recompiled the kernel. This
> +	  option obviates time consuming re-compiles.

                          time-consuming
> +
> +	  The impact of this compile option is a larger kerenl text size ~1%.

                                                        kernel

> +	  However, if CONFIG_IMMEDIATE is set, the run-time impact is 
> +	  negligible. Without CONFIG_IMMEDIATE set, a global variable is
> +	  referenced for each pr_debug() and dev_dbg() calls.
> +
> +	  Usage:
> +
> +	  The printing of pr_debug() and dev_dbg() is controlled by the
> +	  debugfs file, dynamic_printk/files. 
> +	
> +		echo "add foo.c" > dynamic_printk/files
> +		echo "remove foo.c" > dynamic_printk/files
> +

Does "cat dynamic_printk/files" do anything useful?

> +	  Also, a special "all" value will print all pr_debug() and dev_dbg() 
> +	  calls. ie:

                 I.e.:

> +
> +		echo "add all" > dynamic_printk/files
> +		echo "remove all" > dynamic_printk/files
> +
> +	  Finally, passing "dynamic_printk" at the command line enables all
> +	  pr_debug() and dev_dbg() call to come out (same as "all"). This mode

                                   calls

> +	  can be disabled via a "remove all"
> +	

Trailing whitespace (tab).

It looks like the use of "add/remove all" can only be done when
nr_entries == 0 (no filename entries in the hash list).
If that's the case, please document it.


>  source "samples/Kconfig"
> diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
> new file mode 100644
> index 0000000..008496b
> --- /dev/null
> +++ b/lib/dynamic_printk.c
> @@ -0,0 +1,253 @@
> +/*
> + * lib/dynamic_printk.c
> + *
> + * make pr_debug()/dev_dbg() calls runtime configurable based upon their .c file
> + *
> + * Copyright (C) 2008 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +#include <linux/seq_file.h>
> +#include <linux/debugfs.h>
> +#include <linux/fs.h>
> +#include <linux/proc_fs.h>
> +#include <linux/spinlock.h>
> +#include <linux/hash.h>
> +
> +#define FILE_HASH_BITS 5
> +#define FILE_TABLE_SIZE (1 << FILE_HASH_BITS)
> +
> +DEFINE_IMV(char, dynamic_debug_on) = 0;
> +EXPORT_IMV_SYMBOL_GPL(dynamic_debug_on);
> +
> +static int all;
> +static struct hlist_head file_table[FILE_TABLE_SIZE] =
> +	{ [0 ... FILE_TABLE_SIZE-1] = HLIST_HEAD_INIT };
> +static DECLARE_MUTEX(debug_list_mutex);
> +static int nr_entries;
> +
> +struct debug_name {
> +	struct hlist_node hlist;
> +	char *name;
> +};
> +
> +static inline unsigned int name_hash(char *name)
> +{
> +	unsigned int hash = full_name_hash(name, strlen(name));
> +	return (hash & ((1 << FILE_HASH_BITS) - 1));
> +}
> +
> +static struct debug_name *find_debug_file(char *file_name)
> +{
> +	int found = 0;
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct debug_name *element;
> +
> +	head = &file_table[name_hash(file_name)];
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(element, node, head, hlist) {
> +		if (!strcmp(element->name, file_name)) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +	if (found)
> +		return element;
> +	return NULL;
> +}
> +
> +static int add_debug_file(char *file_name)
> +{
> +	struct debug_name *new;
> +
> +	if (find_debug_file(file_name))
> +		return -EINVAL;
> +	new = kmalloc(sizeof(struct debug_name), GFP_KERNEL);
> +	if (!new)
> +		return -ENOMEM;
> +	INIT_HLIST_NODE(&new->hlist);
> +	new->name = file_name;
> +	hlist_add_head_rcu(&new->hlist,
> +			&file_table[name_hash(new->name)]);
> +	nr_entries++;
> +	return 0;
> +}
> +
> +static int remove_debug_file(char *file_name)
> +{
> +	struct debug_name *element;
> +
> +	element = find_debug_file(file_name);
> +	if (element == NULL)
> +		return -EINVAL;
> +	hlist_del_rcu(&element->hlist);
> +	synchronize_rcu();
> +	kfree(element->name);
> +	kfree(element);
> +	nr_entries--;
> +	return 0;
> +}
> +
> +void dynamic_printk(char *filename, char *fmt, ...)
> +{
> +	va_list args;
> +
> +	va_start(args, fmt);
> +	if (all)
> +		vprintk(fmt, args);
> +	else {
> +		if (find_debug_file(filename))
> +			vprintk(fmt, args);
> +	}
> +	va_end(args);
> +}
> +EXPORT_SYMBOL_GPL(dynamic_printk);
> +
> +static ssize_t pr_debug_write(struct file *file, const char __user *buf,
> +				size_t length, loff_t *ppos)
> +{
> +	char *buffer, *file_name, *s;
> +	int err;
> +
> +	if (!buf || length > PAGE_SIZE || length < 0)
> +		return -EINVAL;
> +
> +	buffer = (char *)__get_free_page(GFP_KERNEL);
> +	if (!buffer)
> +		return -ENOMEM;
> +
> +	err = -EFAULT;
> +	if (copy_from_user(buffer, buf, length))
> +		goto out;
> +
> +	err = -EINVAL;
> +	if (length < PAGE_SIZE)
> +		buffer[length] = '\0';
> +	else if (buffer[PAGE_SIZE-1])
> +		goto out;
> +
> +	err = -EINVAL;
> +	down(&debug_list_mutex);
> +	if (!strncmp("add all", buffer, 7)) {
> +		if (!all && (nr_entries == 0))
> +			imv_set(dynamic_debug_on, 1);
> +		all = 1;
> +		err = 0;
> +	} else if (!strncmp("remove all", buffer, 10)) {
> +		if (all && (nr_entries == 0))
> +			imv_set(dynamic_debug_on, 0);
> +		all = 0;
> +		err = 0;
> +	} else if (!strncmp("add ", buffer, 4)) {
> +		s = strstrip(buffer+4);

                            (buffer + 4);

> +		file_name = kmalloc(strlen(s)+1, GFP_KERNEL);

                                    strlen(s) + 1,

> +		if (!file_name) {
> +			err = -ENOMEM;
> +			goto out_up;
> +		}
> +		file_name = strcpy(file_name, s);
> +		err = add_debug_file(file_name);
> +		if (err && err != -ENOMEM)
> +			kfree(file_name);
> +		if (!err && (nr_entries == 1) && !all)
> +			imv_set(dynamic_debug_on, 1);
> +	} else if (!strncmp("remove ", buffer, 7)) {
> +		s = strstrip(buffer+7);

		spacing

> +		err = remove_debug_file(s);
> +		if (!err && (nr_entries == 0) && !all)
> +			imv_set(dynamic_debug_on, 0);
> +	}
> +	if (!err)
> +		err = length;
> +out_up:
> +	up(&debug_list_mutex);
> +out:
> +	free_page((unsigned long)buffer);
> +	return err;
> +}
> +
> +static void *pr_debug_seq_start(struct seq_file *f, loff_t *pos)
> +{
> +	return (*pos < FILE_TABLE_SIZE) ? pos : NULL;
> +}
> +
> +static void *pr_debug_seq_next(struct seq_file *s, void *v, loff_t *pos)
> +{
> +	(*pos)++;
> +	if (*pos >= FILE_TABLE_SIZE)
> +		return NULL;
> +	return pos;
> +}
> +
> +static void pr_debug_seq_stop(struct seq_file *s, void *v)
> +{
> +	/* Nothing to do */
> +}
> +
> +static int pr_debug_seq_show(struct seq_file *s, void *v)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct debug_name *element;
> +	unsigned int i = *(loff_t *) v;
> +
> +	if (i == 0 && all)
> +		seq_printf(s, "all\n");
> +	rcu_read_lock();
> +	head = &file_table[i];
> +	hlist_for_each_entry_rcu(element, node, head, hlist)
> +		seq_printf(s, "%s\n", element->name);
> +	rcu_read_unlock();
> +	return 0;
> +}
> +
> +static struct seq_operations pr_debug_seq_ops = {
> +	.start = pr_debug_seq_start,
> +	.next  = pr_debug_seq_next,
> +	.stop  = pr_debug_seq_stop,
> +	.show  = pr_debug_seq_show
> +};
> +
> +static int pr_debug_open(struct inode *inode, struct file *filp)
> +{
> +	return seq_open(filp, &pr_debug_seq_ops);
> +}
> +
> +static const struct file_operations pr_debug_operations = {
> +	.open           = pr_debug_open,
> +	.read           = seq_read,
> +	.write          = pr_debug_write,
> +	.llseek         = seq_lseek,
> +	.release        = seq_release,
> +};
> +
> +int __init dynamic_printk_init(void)
> +{
> +	struct dentry *dir, *file;
> +
> +	dir = debugfs_create_dir("dynamic_printk", NULL);
> +	if (!dir)
> +		return -ENOMEM;
> +	file = debugfs_create_file("files", 0644, dir, NULL,
> +					&pr_debug_operations);
> +	if (!file) {
> +		debugfs_remove(dir);
> +		return -ENOMEM;
> +	}
> +	return 0;
> +}
> +__initcall(dynamic_printk_init);
> +
> +static int __init dynamic_printk_setup(char *str)
> +{
> +	if (str)
> +		return -ENOENT;
> +	all = 1;
> +	imv_set(dynamic_debug_on, 1);
> +		return 0;

extra tab.

> +}
> +early_param("dynamic_printk", dynamic_printk_setup);

---
~Randy
