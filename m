Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab0BCW4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:56:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757587Ab0BCW4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:56:08 -0500
Date: Wed, 3 Feb 2010 14:55:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: ebiederm@xmission.com (Eric W. Biederman), ankita@in.ibm.com,
       dedekind1@gmail.com,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, mohan@in.ibm.com
Subject: Re: [PATCH] lkdtm: Add debugfs access and loosen KPROBE ties
Message-Id: <20100203145503.b7f7c5d7.akpm@linux-foundation.org>
In-Reply-To: <20100203095224.55522f4c@marrow.netinsight.se>
References: <20100126105640.6bf9488c@marrow.netinsight.se>
	<2375c9f91001260208t31379702tb49cb57d12d5890b@mail.gmail.com>
	<20100126111853.10890fc6@marrow.netinsight.se>
	<2375c9f91001261853t1158a66aw86546a61e613338f@mail.gmail.com>
	<1264689482.1973.132.camel@localhost>
	<20100129071324.2521705c@marrow.netinsight.se>
	<20100129023327.021cb23d.akpm@linux-foundation.org>
	<m1eil4i85t.fsf@fess.ebiederm.org>
	<20100203095224.55522f4c@marrow.netinsight.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 09:52:24 +0100
Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> This patch adds a debugfs interface and additional failure modes to
> LKDTM to provide similar functionality to the provoke-crash driver
> submitted here:
> 
>   http://lwn.net/Articles/371208/
> 
> Crashes can now be induced either through module parameters (as before)
> or through the debugfs interface as in provoke-crash.
> 
> The patch also provides a new "direct" interface, where KPROBES are not
> used, i.e., the crash is invoked directly upon write to the debugfs
> file. When built without KPROBES configured, only this mode is available.
> 
> Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
> ---
> I reused the debugfs directory name from provoke-crash since I think the
> name is more descriptive than "lkdtm".
> 
> I also put some documentation in Documentation/fault-injection. While I
> know that the fault-injection framework isn't used for this driver, I
> think the name make sense (that's where I'd look for functionality like
> this).
> 
>
> ...
>
> +static void lkdtm_do_action(enum ctype which)
>  {
> -	printk(KERN_INFO "lkdtm : Crash point %s of type %s hit\n",
> -					 cpoint_name, cpoint_type);
> +	switch (which) {
> +	case PANIC:
> +		panic("dumptest");
> +		break;
> +	case BUG:
> +		BUG();
> +		break;
> +	case EXCEPTION:
> +		*((int *) 0) = 0;
> +		break;
> +	case LOOP:
> +		for (;;);

Please feed the patch through scripts/checkpatch.pl and contemplate the
resulting report.

> +		break;
> +	case OVERFLOW:
> +		(void) recursive_loop(0);
> +		break;
> +	case CORRUPT_STACK:
> +	{
> +		volatile u32 data[8];
> +		volatile u32 *p = data;
> +
> +		p[12] = 0x12345678;
> +	} break;

Like this:

	case CORRUPT_STACK: {
		volatile u32 data[8];
		volatile u32 *p = data;

		p[12] = 0x12345678;
		break;
	}

> +	case UNALIGNED_LOAD_STORE_WRITE:
> +	{
> +		static u8 data[5] __attribute__((aligned(4))) = {1,2,3,4,5};
> +		u32 *p;
> +		u32 val = 0x12345678;
> +
> +		p = (u32*)(data + 1);
> +		if (*p == 0)
> +			val = 0x87654321;
> +		*p = val;
> +	} break;
> +	case OVERWRITE_ALLOCATION:
> +	{
> +		size_t len = 1020;
> +		u32 *data = kmalloc(len, GFP_KERNEL);
> +
> +		data[1024 / sizeof(u32)] = 0x12345678;
> +		kfree(data);
> +	} break;
> +	case WRITE_AFTER_FREE:
> +	{
> +		size_t len = 1024;
> +		u32 *data = kmalloc(len, GFP_KERNEL);
> +
> +		kfree(data);
> +		schedule();
> +		memset(data, 0x78, len);
> +	} break;
> +	case NONE:
> +	default:
> +		break;
> +	}
> +
> +}
> +
>
> ...
>
> +static ssize_t do_register_entry(enum cname which, struct file *f,
> +		const char __user *user_buf, size_t count, loff_t *off)
> +{
> +	char *buf;
> +	int err;
> +
> +	if (count >= PAGE_SIZE)
> +		return -EINVAL;
> +
> +	buf = (char *)__get_free_page(GFP_TEMPORARY);

Someone ought to write

static inline void *__get_free_page_ptr(gfp_t flags)
{
	return (void *)__get_free_page(flags);
}

and then delete 100000000 typecasts.



The use of GFP_TEMPORARY is incorrect.  This page is not reclaimable.

> +	if (!buf)
> +		return -ENOMEM;
> +	if (copy_from_user(buf, user_buf, count)) {
> +		free_page((unsigned long) buf);
> +		return -EFAULT;
> +	}
> +	/* NULL-terminate and remove enter */
> +	buf[count] = '\0';
> +	if (buf[count - 1] == '\r' || buf[count - 1] == '\n')
> +		buf[count - 1] = '\0';

Use strim().

> +	cptype = parse_cp_type(buf, count);
> +	free_page((unsigned long) buf);

Write free_page_ptr() and delete another 100000000.

> +
> +	if (cptype == NONE)
> +		return -EINVAL;
> +
> +	err = lkdtm_register_cpoint(which);
> +	if (err < 0)
> +		return err;
> +
> +	*off += count;
> +
> +	return count;
> +}
> +
>
> ...
>
> +/* Special entry to just crash directly. Available without KPROBEs */
> +static ssize_t direct_entry(struct file *f, const char __user *user_buf,
> +		size_t count, loff_t *off)
> +{
> +	enum ctype type;
> +	char *buf;
> +
> +	if (count >= PAGE_SIZE)
> +		return -EINVAL;
> +	if (count < 1)
> +		return -EINVAL;
> +
> +	buf = (char *)__get_free_page(GFP_TEMPORARY);

GFP_KERNEL

> +	if (!buf)
> +		return -ENOMEM;
> +	if (copy_from_user(buf, user_buf, count)) {
> +		free_page((unsigned long) buf);
> +		return -EFAULT;
> +	}
> +	/* NULL-terminate and remove enter */
> +	buf[count] = '\0';
> +	if (buf[count - 1] == '\r' || buf[count - 1] == '\n')
> +		buf[count - 1] = '\0';

strim().

> +	type = parse_cp_type(buf, count);
> +	free_page((unsigned long) buf);
> +	if (type == NONE)
> +		return -EINVAL;
> +
> +	printk(KERN_INFO "lkdtm : Performing direct entry %s\n",
> +			cp_type_to_str(type));
> +	lkdtm_do_action(type);
> +	*off += count;
> +
> +	return count;
> +}
> +
> +struct crash_entry
> +{

struct crash_entry {

> +	const char *name;
> +	struct file_operations fops;
> +};
> +
> +static struct crash_entry crash_entries[] = {

const, perhaps.

> +	{"DIRECT",		{.read = lkdtm_debugfs_read,
> +			.open = lkdtm_debugfs_open, .write = direct_entry}},
> +	{"INT_HARDWARE_ENTRY",	{.read = lkdtm_debugfs_read,
> +			.open = lkdtm_debugfs_open, .write = int_hardware_entry}},
> +	{"INT_HW_IRQ_EN",	{.read = lkdtm_debugfs_read,
> +			.open = lkdtm_debugfs_open, .write = int_hw_irq_en}},
> +	{"INT_TASKLET_ENTRY",	{.read = lkdtm_debugfs_read,
> +			.open = lkdtm_debugfs_open, .write = int_tasklet_entry}},
> +	{"FS_DEVRW",		{.read = lkdtm_debugfs_read,
> +			.open = lkdtm_debugfs_open, .write = fs_devrw_entry}},
> +	{"MEM_SWAPOUT",		{.read = lkdtm_debugfs_read,
> +			.open = lkdtm_debugfs_open, .write = mem_swapout_entry}},
> +	{"TIMERADD",		{.read = lkdtm_debugfs_read,
> +			.open = lkdtm_debugfs_open, .write = timeradd_entry}},
> +	{"SCSI_DISPATCH_CMD",	{.read = lkdtm_debugfs_read,
> +			.open = lkdtm_debugfs_open, .write = scsi_dispatch_cmd_entry}},
> +	{"IDE_CORE_CP",		{.read = lkdtm_debugfs_read,
> +			.open = lkdtm_debugfs_open, .write = ide_core_cp_entry}},
> +};
> +
> +static struct dentry *lkdtm_debugfs_root;
> +
> +static int __init lkdtm_module_init(void)
> +{
> +	int ret = -EINVAL;
> +	int n_debugfs_entries = 1; /* Assume only the direct entry */
> +	int i;
> +
> +	/* Register debugfs interface */
> +	lkdtm_debugfs_root = debugfs_create_dir("provoke-crash", NULL);
> +	if (!lkdtm_debugfs_root) {
> +		printk(KERN_ERR "lkdtm: creating root dir failed\n");
> +		return -ENODEV;
> +	}
> +
> +#if defined(CONFIG_KPROBES)

#ifdef will suffice

> +	n_debugfs_entries = ARRAY_SIZE(crash_entries);
> +#endif
> +
> +	for (i = 0; i < n_debugfs_entries; i++) {

Sometimes you do

	for (i = ..., i < ...; i++)

and sometimes

	for (i = ..., i < ...; ++i)

The former is more typical.

> +		struct crash_entry *cur = &crash_entries[i];
> +		struct dentry *de;
> +
> +		de = debugfs_create_file(cur->name, 0644, lkdtm_debugfs_root,
> +				NULL, &cur->fops);
> +		if (de == NULL) {
> +			printk(KERN_ERR "lkdtm: could not create %s\n",
> +					cur->name);
> +			goto out_err;
> +		}
> +	}
> +
> +	if (lkdtm_parse_commandline() == -EINVAL) {
> +		printk(KERN_INFO "lkdtm : Invalid command\n");
> +		goto out_err;
>  	}
>  
> -	printk(KERN_INFO "lkdtm : Crash point %s of type %s registered\n",
> -						cpoint_name, cpoint_type);
> +	if (cpoint != INVALID && cptype != NONE)
> +	{

	if (cpoint != INVALID && cptype != NONE) {

> +		ret = lkdtm_register_cpoint(cpoint);
> +		if (ret < 0)
> +		{

ditto

> +			printk(KERN_INFO "lkdtm : Invalid crash point %d\n", cpoint);
> +			goto out_err;
> +		}
> +		printk(KERN_INFO "lkdtm : Crash point %s of type %s registered\n",
> +				cpoint_name, cpoint_type);

Please do s/lkdtm :/lkdtm:/ in all printks.

> +	}
> +	else

	} else {

> +		printk(KERN_INFO "lkdtm : No crash points registered, enable through debugfs\n");
> +

	}

>  	return 0;
> +
> +out_err:
> +	debugfs_remove_recursive(lkdtm_debugfs_root);
> +	return ret;
>  }
>  
>  static void __exit lkdtm_module_exit(void)
>  {
> -        unregister_jprobe(&lkdtm);
> -        printk(KERN_INFO "lkdtm : Crash point unregistered\n");
> +	debugfs_remove_recursive(lkdtm_debugfs_root);
> +
> +	unregister_jprobe(&lkdtm);
> +	printk(KERN_INFO "lkdtm : Crash point unregistered\n");

A colon does not terminate a sentence, so "lkdtm: crash point
unregistered" would be better (applies to whole patch).

>  }
>  
>  module_init(lkdtm_module_init);
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8c82a1d..67b1799 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -840,8 +840,7 @@ config DEBUG_FORCE_WEAK_PER_CPU
>  
>  config LKDTM
>  	tristate "Linux Kernel Dump Test Tool Module"
> -	depends on DEBUG_KERNEL
> -	depends on KPROBES
> +	depends on DEBUG_FS
>  	depends on BLOCK
>  	default n
>  	help
> @@ -852,7 +851,7 @@ config LKDTM
>  	called lkdtm.
>  
>  	Documentation on how to use the module can be found in
> -	drivers/misc/lkdtm.c
> +	Documentation/fault-injection/provoke-crashes.txt
>  
>  config FAULT_INJECTION
>  	bool "Fault-injection framework"
> -- 
> 1.6.0.4
