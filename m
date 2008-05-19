Return-Path: <linux-kernel-owner+w=401wt.eu-S1765367AbYESXYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765367AbYESXYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764910AbYESXWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:22:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764839AbYESXWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:22:38 -0400
Date: Mon, 19 May 2008 16:21:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com,
       prasad@linux.vnet.ibm.com
Subject: Re: [RFC Patch 1/1] trace_printk and trace_dump interface - v2
Message-Id: <20080519162149.50f58b80.akpm@linux-foundation.org>
In-Reply-To: <op.ua90vfwv03j166@prasadkr_t60p.in.ibm.com>
References: <op.ua9axd2a03j166@prasadkr_t60p.in.ibm.com>
	<op.ua9a1r0y03j166@prasadkr_t60p.in.ibm.com>
	<op.ua90vfwv03j166@prasadkr_t60p.in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 07:52:16 +0530
"K.Prasad" <prasad@linux.vnet.ibm.com> wrote:

> Resending this patch due to style issues found in previous patch.
> 
> This patch introduces two new interfaces called trace_printk and
> trace_dump which can be used to print to the debugfs mount directly.
> It uses the 'trace' infrastructure underneath and is a patch over it.
> A sample file is also created to demonstrate its ease of use.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>   Documentation/trace.txt        |   22 ++++
>   include/linux/trace.h          |   57 +++++++++++
>   lib/trace.c                    |  205  
> ++++++++++++++++++++++++++++++++++++++++-
>   samples/trace/Makefile         |    2
>   samples/trace/fork_new_trace.c |   99 +++++++++++++++++++

The patch is wordwrapped and space-stuffed.

> ...
>
>   static void remove_tree(struct trace_info *trace)
>   {
> +	struct list_head *pos, *temp;
> +	struct trace_dir *dr = NULL;
> +
>   	mutex_lock(&trace_mutex);
>   	debugfs_remove(trace->dir);
> 
> +	list_for_each_safe(pos, temp, &trace_dirs) {
> +		dr = list_entry(pos, struct trace_dir, trace_dir_list);

list_for_each_entry_safe()?

> +		if (dr->ti == trace) {
> +			list_del(pos);
> +			kfree(dr);
> +		}
> +	}
>   	if (trace->root) {
>   		if (--trace->root->users == 0)
>   			remove_root(trace);
> @@ -142,11 +153,17 @@ static struct trace_root *lookup_root(co
>   static struct dentry *create_tree(struct trace_info *trace, const char  
> *root,
>   				  const char *name)
>   {
> -	struct dentry *dir = NULL;
> +	struct trace_dir *temp;
> 
>   	if (root == NULL || name == NULL)
>   		return ERR_PTR(-EINVAL);
> 
> +	temp = kzalloc(sizeof(struct trace_dir), GFP_KERNEL);
> +	if ((temp == NULL) || (strlen(name) > TRACE_NAME_SIZE))
> +		return ERR_PTR(-ENOMEM);

This can leak `temp'.

I suspect it has an off-by-one.

You should check the incoming args before allocating any resources or
doing anything which has side-effects.

> +	strlcpy(temp->trace_dir_name, name, sizeof(temp->trace_dir_name));

then use kstrdup().

Please don't call variables "temp" or "tmp".  Surely something more
communcative can be thought up.

>   	mutex_lock(&trace_mutex);
> 
>   	trace->root = lookup_root(root);
> @@ -155,17 +172,49 @@ static struct dentry *create_tree(struct
>   		goto err;
>   	}
> 
> -	dir = debugfs_create_dir(name, trace->root->root);
> -	if (IS_ERR(dir))
> +	temp->trace_root = trace->root->root;
> +	temp->trace_dir = debugfs_create_dir(name, trace->root->root);
> +
> +	if (IS_ERR(temp->trace_dir))
>   		remove_root(trace);
> -	else
> +	else {
>   		trace->root->users++;
> +		temp->ti = trace;
> +		list_add_tail(&temp->trace_dir_list, &trace_dirs);
> +	}
> 
>   err:
>   	mutex_unlock(&trace_mutex);
> -	return dir;
> +	return temp->trace_dir;
>   }
> 
> +int trace_exists(const char *parent_dir, const char *dir,
> +					struct trace_info **ti)
> +{
> +	struct list_head *pos;
> +	struct trace_root *r;
> +	struct trace_dir *temp;
> +
> +	list_for_each(pos, &trace_roots) {
> +		r = list_entry(pos, struct trace_root, list);

list_for_each_entry()?

> +		if (!strcmp(parent_dir, r->name))
> +			goto search_dir;
> +	}
> +	return TRACE_PARENT_DIR_ABSENT;
> +
> + search_dir:
> +	list_for_each(pos, &trace_dirs) {
> +		temp = list_entry(pos, struct trace_dir, trace_dir_list);
> +
> +		if (!strcmp(dir, temp->trace_dir_name)) {
> +			*ti = temp->ti;
> +			return TRACE_DIR_EXISTS;
> +		}
> +	}
> +	return TRACE_PARENT_DIR_EXISTS;
> +}
> +EXPORT_SYMBOL_GPL(trace_exists);

I wonder if the whole "trace_*" namespace was a good choice.  There are
other trace patches in-kernel, out-of-kernel and presumably in our
future.

>   static int dropped_open(struct inode *inode, struct file *filp)
>   {
>   	filp->private_data = inode->i_private;
> @@ -561,3 +610,149 @@ void trace_cleanup(struct trace_info *tr
>   	kfree(trace);
>   }
>   EXPORT_SYMBOL_GPL(trace_cleanup);
> +
> +/**
> + *	trace_cleanup_all - Removes all trace directories under a parent_dir
> + *	@parent_dir: Name of the parent directory
> + */
> +void trace_cleanup_all(const char *parent_dir)
> +{
> +	struct list_head *pos, *pos_temp;
> +	struct trace_dir *temp;
> +
> +	list_for_each_safe(pos, pos_temp, &trace_dirs) {
> +		temp = list_entry(pos, struct trace_dir, trace_dir_list);

list_for_each_entry_safe()?

> +		if (!strncmp(parent_dir, temp->trace_root->d_iname, \
> +							strlen(parent_dir)))
> +			trace_cleanup(temp->ti);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(trace_cleanup_all);
>
> ...
>
> +static inline int init_trace_interface(struct trace_printk_data *tpk)
> +{
> +	int ret = 0;
> +	tpk->exists = trace_exists(tpk->parent_dir, tpk->dir, &tpk->ti);
> +
> +	switch (tpk->exists) {
> +
> +	case TRACE_PARENT_DIR_EXISTS:
> +	case TRACE_PARENT_DIR_ABSENT:
> +		if (!tpk->buf_size)
> +			tpk->buf_size = DEFAULT_TRACE_BUF_SIZE;
> +		if (!tpk->sub_buf_size)
> +			tpk->sub_buf_size = DEFAULT_TRACE_SUB_BUF_NR;
> +		tpk->ti = trace_setup(tpk->parent_dir, tpk->dir,
> +				tpk->buf_size, tpk->sub_buf_size, tpk->flags);
> +		printk(KERN_INFO "Trace interface %s setup\n",
> +							tpk->ti->dir->d_iname);
> +		if (IS_ERR(tpk->ti)) {
> +			printk(KERN_ERR "Error initialising %s interface\n",
> +							tpk->ti->dir->d_iname);
> +			return -EPERM;
> +		}
> +	/* Fall through */
> +	case TRACE_DIR_EXISTS:
> +		if (tpk->ti->state == TRACE_SETUP)
> +			ret = trace_start(tpk->ti);
> +		else
> +			ret = -EPERM;
> +	}
> +
> +	return 0;
> +}

Two callsites, far too large to be inlined.

Please just don't use inline at all, except in exceptional
circumstances.  The compiler will work it out for normal usage.

> +/**
> + * trace_printk - Output a string to debugfs mount 'directly' using  
> 'trace'
> + * @tpk: Structure containing info such as parent_dir and directory
> + * @format: String containing format string specifiers
> + * @ap: List of arguments
> + */
> +int trace_printk(struct trace_printk_data *tpk, char *format, ...)
> +{
> +	int ret = 0;
> +	va_list(ap);
> +	unsigned long flags = 0;

So I look at this and wonder "why did that need initialising?"

> +	va_start(ap, format);
> +
> +	ret = init_trace_interface(tpk);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	/* Now do the actual printing */
> +	/* Take an RCU Lock over the trace_info state */
> +	rcu_read_lock();
> +	/* Take a spinlock for the global buffer used by relay */
> +	if (tpk->flags & TRACE_GLOBAL_CHANNEL)
> +		spin_lock_irqsave(&tpk->ti->trace_lock, flags);

ah, because you got a compiler warning.

That's why we have "uninitialized_var()": so the reader can understand
what is happening.  Plus uninitialized_var() generates no code, whereas
that assignment generates additional text.

uninitialized_var() is fairly sucky, but adding a mysterious,
seemingly-unneeded and code-generating "= 0" is suckier.

> +	ret = trace_printf(tpk->ti, format, ap);
> +	if (tpk->flags & TRACE_GLOBAL_CHANNEL)
> +		spin_unlock_irqrestore(&tpk->ti->trace_lock, flags);
> +	rcu_read_unlock();
> +
> +	va_end(ap);
> +	return ret;
> +}
> +EXPORT_SYMBOL(trace_printk);
> +
> +/**
> + * trace_dump - Output binary into debugfs mount 'directly' using 'trace'
> + * @tpk: Structure containing info such as parent_dir and directory
> + * @output: Data that needs to be output
> + * @output_len: Length of the output data
> + */
> +int trace_dump(struct trace_printk_data *tpk, const void *output,
> +							const int output_len)
> +{
> +	char *record;
> +	unsigned long flags = 0;

there too.

> +	int ret = 0;
> +
> +	ret = init_trace_interface(tpk);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	/* Now do the actual printing */
> +	rcu_read_lock();
> +	/* Take a spinlock for the global buffer used by relay */
> +	if (tpk->flags & TRACE_GLOBAL_CHANNEL)
> +		spin_lock_irqsave(&tpk->ti->trace_lock, flags);

Making a callee's locking behaviour dependent upon an incoming argument
is considered poor style and earns nastygrams from Linus.  Is there no
sane alternative?

> +	record = relay_reserve(tpk->ti->rchan, output_len);
> +
> +	if (record && trace_running(tpk->ti))
> +		memcpy(record, output, output_len);
> +	else {
> +		if (record)
> +			ret = -EPERM;
> +		else
> +			ret = -ENOMEM;
> +	}
> +	if (tpk->flags & TRACE_GLOBAL_CHANNEL)
> +		spin_unlock_irqrestore(&tpk->ti->trace_lock, flags);
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(trace_dump);
>
> ...
>
> +int init_module(void)
> +{
> +	int ret = 0;
> +	int len_parent_dir, len_dir;
> +
> +	/* setup the kprobe */
> +	kp.pre_handler = handler_pre;
> +	kp.post_handler = NULL;
> +	kp.fault_handler = NULL;
> +	kp.symbol_name = PROBE_POINT;
> +	ret = register_kprobe(&kp);
> +	if (ret) {
> +		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
> +		return ret;
> +	}
> +
> +	len_parent_dir = strlen(SAMPLE_PARENT_DIR) + 1;
> +	/* Initialising len_dir to the larger of the two dir names */
> +	len_dir = strlen("kprobe_struct") + 1;
> +
> +	tpk = kzalloc(sizeof(*tpk), GFP_KERNEL);
> +	if (!tpk)
> +		ret = 1;
> +
> +	tpk->parent_dir = SAMPLE_PARENT_DIR;
> +
> +	/* Let's do a binary dump of struct kprobe using trace_dump */
> +	tpk->dir = "kprobes_struct";
> +	tpk->flags = TRACE_GLOBAL_CHANNEL;
> +	trace_dump(tpk, &kp, sizeof(kp));
> +
> +	/* Now change the directory to collect fork pid data */
> +	tpk->dir = PROBE_POINT;
> +
> +	if (ret)
> +		printk(KERN_ERR "Unable to find required free memory. "
> +				"Trace new sample module loading aborted");
> +	return ret;
> +}
> +
> +void cleanup_module(void)
> +{
> +	unregister_kprobe(&kp);
> +
> +	/* Just a single cleanup call passing the parent dir string */
> +	trace_cleanup_all(SAMPLE_PARENT_DIR);
> +}
> +MODULE_LICENSE("GPL");

Do init_module() and cleanup_module() actually get called?  We _used_
to have magic code which automatically calls those functions but I'd
have thought it got removed years ago?

Anyway, we should be using module_init() and module_exit() here, and
those functions should have static scope.

> Index: linux-blktrace-many/samples/trace/Makefile
> ===================================================================
> --- linux-blktrace-many.orig/samples/trace/Makefile
> +++ linux-blktrace-many/samples/trace/Makefile
> @@ -1,4 +1,4 @@
>   # builds the trace example kernel modules;
>   # then to use (as root):  insmod <fork_trace.ko>
> 
> -obj-$(CONFIG_SAMPLE_TRACE) := fork_trace.o
> +obj-$(CONFIG_SAMPLE_TRACE) := fork_trace.o fork_new_trace.o
> Index: linux-blktrace-many/Documentation/trace.txt
> ===================================================================
> --- linux-blktrace-many.orig/Documentation/trace.txt
> +++ linux-blktrace-many/Documentation/trace.txt
> @@ -150,6 +150,28 @@ The steps a kernel data provider takes t
>   5) Destroy the trace channel and underlying relay channel -
>      trace_cleanup().
> 
> +Alternatively the user may choose to make use of two new interfaces --
> +trace_printk() and trace_dump() -- to setup trace interface and
> +trace_cleanup_all() to tear-down the same.
> +
> +Steps to use:
> +1) Create and populate an instance of trace_printk_data structure. The  
> fields
> +   parent_dir and dir are mandatory. The fields buf_size, sub_buf_size  
> and flags
> +   are optional and will take default values if not populated. The field
> +   'exists' and ti are for the trace infrastructure to use. The pointer  
> to the
> +   'struct trace_info' i.e. ti may be used to perform fine granular  
> operations
> +   such as determine the state of the 'trace', stop individual traces,  
> etc.
> +2) Default values for buf_size and sub_buf_size are 4096, 40 respectively.
> +3) Use trace_dump() to output binary data which may be acted upon by a
> +   high-level program (say dumping a structure). trace_printk() can be  
> used
> +   for string output. Pass a pointer to the instance of trace_printk_data
> +   structure to these functions along with other parameters. The output  
> from
> +   these functions can be found at
> +   <debugfs_mount>/<parent_dir>/<dir>/trace<0..n>.
> +4) trace_cleanup_all() for a given parent directory will cleanup and  
> remove all
> +   trace directories created under the specified directory.
> +5) Sample code for the same can be found in samples/trace/fork_new_trace.c

wordwrapping...

I often fix it, but I think we need v3 on this one.
