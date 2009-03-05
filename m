Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZCEOyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZCEOyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZCEOyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:54:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42669 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbZCEOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:54:14 -0500
Date: Thu, 5 Mar 2009 09:54:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 11/11] ftrace plugin for kernel symbol tracing using HW
 Breakpoint interfaces
In-Reply-To: <20090305044333.GM17747@in.ibm.com>
Message-ID: <alpine.DEB.2.00.0903050949360.26101@gandalf.stny.rr.com>
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305044333.GM17747@in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 5 Mar 2009, prasad@linux.vnet.ibm.com wrote:
>  };
> @@ -191,6 +194,17 @@ struct kmemtrace_free_entry {
>  	const void *ptr;
>  };
>  
> +struct trace_ksym {
> +	struct trace_entry	ent;
> +	struct hw_breakpoint	*ksym_hbkpt;
> +	unsigned long		ksym_addr;
> +	unsigned long		ip;
> +	pid_t			pid;

pid not needed, see below.

> +	struct hlist_node	ksym_hlist;
> +	char			ksym_name[KSYM_NAME_LEN];
> +	char			p_name[TASK_COMM_LEN];
> +};
> +
>  /*
>   * trace_flag_type is an enumeration that holds different
>   * states when a trace occurs. These are:
> @@ -302,6 +316,7 @@ extern void __ftrace_bad_type(void);
>  			  TRACE_KMEM_ALLOC);	\
>  		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
>  			  TRACE_KMEM_FREE);	\
> +		IF_ASSIGN(var, ent, struct trace_ksym, TRACE_KSYM); \
>  		__ftrace_bad_type();					\
>  	} while (0)
>  
> Index: linux-2.6-tip/kernel/trace/trace_ksym.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6-tip/kernel/trace/trace_ksym.c
> @@ -0,0 +1,399 @@
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/debugfs.h>
> +#include <linux/ftrace.h>
> +#include <linux/kallsyms.h>
> +#include <linux/uaccess.h>
> +
> +#include "trace.h"
> +#include "trace_output.h"
> +
> +/* For now, let us restrict the no. of symbols traced simultaneously to number
> + * of available hardware breakpoint registers.
> + */
> +#define KSYM_TRACER_MAX HB_NUM
> +
> +#define KSYM_TRACER_OP_LEN 3 /* rw- */
> +#define KSYM_FILTER_ENTRY_LEN (KSYM_NAME_LEN + KSYM_TRACER_OP_LEN + 1)
> +
> +#define KSYM_DEBUG 1
> +
> +static struct trace_array *ksym_trace_array;
> +
> +DEFINE_MUTEX(ksym_tracer_mutex);
> +
> +static unsigned int ksym_filter_entry_count;
> +static unsigned int ksym_tracing_enabled;
> +
> +static HLIST_HEAD(ksym_filter_head);
> +
> +/* HW Breakpoint related callback functions */
> +void ksym_hbkpt_installed(struct hw_breakpoint *temp, struct pt_regs
> +								*temp_regs)
> +{
> +}
> +
> +void ksym_hbkpt_uninstalled(struct hw_breakpoint *temp, struct
> +							pt_regs * temp_regs)
> +{
> +}
> +
> +void ksym_hbkpt_handler(struct hw_breakpoint *hbkpt, struct pt_regs *regs)
> +{
> +	struct ring_buffer_event *event;
> +	struct trace_array *tr;
> +	struct trace_ksym *entry;
> +	int pc;
> +
> +	if (!ksym_tracing_enabled)
> +		return;
> +
> +	tr = ksym_trace_array;
> +	pc = preempt_count();
> +
> +	event = trace_buffer_lock_reserve(tr, TRACE_KSYM,
> +							sizeof(*entry), 0, pc);
> +	if (!event)
> +		return;
> +
> +	entry = ring_buffer_event_data(event);
> +	strlcpy(entry->ksym_name, hbkpt->info.name, KSYM_SYMBOL_LEN);
> +	entry->ksym_hbkpt = hbkpt;
> +	entry->ip = instruction_pointer(regs);
> +	strlcpy(entry->p_name, current->comm, TASK_COMM_LEN);
> +
> +	entry->pid = current->pid;

You just duplicated the pid. In trace_buffer_lock_reserve we record
the pid in entry->ent.pid.


> +	trace_buffer_unlock_commit(tr, event, 0, pc);
> +}
> +
> +/* Valid access types are represented as
> + *
> + * rw- : Set Read/Write Access Breakpoint
> + * -w- : Set Write Access Breakpoint
> + * --- : Clear Breakpoints
> + * --x : Set Execution Break points (Not available yet)
> + *
> + */
> +static int ksym_trace_get_access_type(char *access_str)
> +{
> +	int pos, access = 0;
> +
> +	for (pos = 0; pos < KSYM_TRACER_OP_LEN; pos++) {
> +		switch (access_str[pos]) {
> +		case 'r':
> +			access += (pos == 0) ? 4 : -1;
> +			break;
> +		case 'w':
> +			access += (pos == 1) ? 2 : -1;
> +			break;
> +		case '-':
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
> +	switch (access) {
> +	case 6:
> +		access = HW_BREAKPOINT_RW;
> +		break;
> +	case 2:
> +		access = HW_BREAKPOINT_WRITE;
> +		break;
> +	case 0:
> +		access = 0;
> +	}
> +
> +	return access;
> +}
> +
> +/*
> + * There can be several possible malformed requests and we attempt to capture
> + * all of them. We enumerate some of the rules
> + * 1. We will not allow kernel symbols with ':' since it is used as a delimiter.
> + *    i.e. multiple ':' symbols disallowed. Possible uses are of the form
> + *    <module>:<ksym_name>:<op>.
> + * 2. No delimiter symbol ':' in the input string
> + * 3. Spurious operator symbols or symbols not in their respective positions
> + * 4. <ksym_name>:--- i.e. clear breakpoint request when ksym_name not in file
> + * 5. Kernel symbol not a part of /proc/kallsyms
> + * 6. Duplicate requests
> + */
> +static int parse_ksym_trace_str(char *input_string, char **ksymname,
> +							unsigned long *addr)
> +{
> +	char *delimiter = ":";
> +	int ret;
> +
> +	ret = -EINVAL;
> +	*ksymname = strsep(&input_string, delimiter);
> +	*addr = kallsyms_lookup_name(*ksymname);
> +
> +	/* Check for malformed request: (2), (1) and (5) */
> +	if ((!input_string) ||
> +		(strlen(input_string) != KSYM_TRACER_OP_LEN + 1) ||
> +		(*addr == 0))
> +		goto return_code;
> +
> +	ret = ksym_trace_get_access_type(input_string);
> +
> +return_code:
> +	return ret;
> +}
> +
> +static int process_new_ksym_entry(struct trace_ksym *entry, char *ksymname,
> +			     int op, unsigned long addr)
> +{
> +	if (ksym_filter_entry_count >= KSYM_TRACER_MAX) {
> +		printk(KERN_ERR "ksym_tracer: Maximum limit:(%d) reached. No"
> +			" new requests for tracing can be accepted now.\n",
> +			KSYM_TRACER_MAX);
> +		return -ENOSPC;
> +	}
> +
> +	entry = kzalloc(sizeof(struct trace_ksym), GFP_KERNEL);
> +	if (!entry)
> +		return -ENOMEM;
> +
> +	entry->ksym_hbkpt = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
> +	if (!entry->ksym_hbkpt)
> +		return -ENOMEM;
> +
> +	entry->ksym_hbkpt->info.name = ksymname;
> +	entry->ksym_hbkpt->info.type = op;
> +	entry->ksym_addr = entry->ksym_hbkpt->info.address = addr;
> +	entry->ksym_hbkpt->info.len = HW_BREAKPOINT_LEN_4;
> +	entry->ksym_hbkpt->priority = HW_BREAKPOINT_PRIO_NORMAL;
> +
> +	entry->ksym_hbkpt->installed = (void *)ksym_hbkpt_installed;
> +	entry->ksym_hbkpt->uninstalled = (void *)ksym_hbkpt_uninstalled;
> +	entry->ksym_hbkpt->triggered = (void *)ksym_hbkpt_handler;
> +
> +	if ((register_kernel_hw_breakpoint(entry->ksym_hbkpt)) < 0) {
> +		printk(KERN_INFO "ksym_tracer request failed. Try again"
> +					" later!!\n");
> +		kfree(entry);
> +		return -EAGAIN;
> +	}
> +	hlist_add_head(&(entry->ksym_hlist), &ksym_filter_head);
> +	printk(KERN_INFO "ksym_tracer changes are now effective\n");
> +
> +	ksym_filter_entry_count++;
> +
> +	return 0;
> +}
> +
> +static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
> +						size_t count, loff_t *ppos)
> +{
> +	struct trace_ksym *entry;
> +	struct hlist_node *node;
> +	char buf[KSYM_FILTER_ENTRY_LEN * KSYM_TRACER_MAX];
> +	ssize_t ret, cnt = 0;
> +
> +	mutex_lock(&ksym_tracer_mutex);
> +
> +	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
> +		cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt, "%s:",
> +				entry->ksym_hbkpt->info.name);
> +		if (entry->ksym_hbkpt->info.type == HW_BREAKPOINT_WRITE)
> +			cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt,
> +								"-w-\n");
> +		else if (entry->ksym_hbkpt->info.type == HW_BREAKPOINT_RW)
> +			cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt,
> +								"rw-\n");
> +	}
> +	ret = simple_read_from_buffer(ubuf, count, ppos, buf, strlen(buf));
> +	mutex_unlock(&ksym_tracer_mutex);
> +
> +	return ret;
> +}
> +
> +static ssize_t ksym_trace_filter_write(struct file *file,
> +					const char __user *buffer,
> +						size_t count, loff_t *ppos)
> +{
> +	struct trace_ksym *entry;
> +	struct hlist_node *node;
> +	char *input_string, *ksymname = NULL;
> +	unsigned long ksym_addr = 0;
> +	int ret, op, changed = 0;
> +
> +	input_string = kzalloc(count, GFP_KERNEL);
> +	if (!input_string)
> +		return -ENOMEM;
> +
> +	/* Ignore echo "" > ksym_trace_filter */
> +	if (count == 0)
> +		return 0;
> +
> +	if (copy_from_user(input_string, buffer, count))
> +		return -EFAULT;
> +
> +	ret = op = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
> +
> +	if (ret < 0)
> +		goto err_ret;
> +	mutex_lock(&ksym_tracer_mutex);
> +
> +	ret = -EINVAL;
> +	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
> +		if (entry->ksym_addr == ksym_addr) {
> +			/* Check for malformed request: (6) */
> +			if (entry->ksym_hbkpt->info.type != op)
> +				changed = 1;
> +			else
> +				goto err_ret;
> +			break;
> +		}
> +	}
> +	if (changed) {
> +		unregister_kernel_hw_breakpoint(entry->ksym_hbkpt);
> +		entry->ksym_hbkpt->info.type = op;
> +		if (op > 0) {
> +			ret = register_kernel_hw_breakpoint(entry->ksym_hbkpt);
> +			if (ret > 0) {
> +				ret = count;
> +				goto unlock_ret_path;
> +			}
> +			if (ret == 0) {
> +				ret = -ENOSPC;
> +				unregister_kernel_hw_breakpoint(entry->\
> +								ksym_hbkpt);
> +			}
> +		}
> +		ksym_filter_entry_count--;
> +		hlist_del(&(entry->ksym_hlist));
> +		kfree(entry->ksym_hbkpt);
> +		kfree(entry);
> +		ret = count;
> +		goto err_ret;
> +	} else {
> +		/* Check for malformed request: (4) */
> +		if (op == 0)
> +			goto err_ret;
> +
> +		ret = process_new_ksym_entry(entry, ksymname, op, ksym_addr);
> +		if (ret)
> +			goto err_ret;
> +	}
> +	ret = count;
> +	goto unlock_ret_path;
> +
> +err_ret:
> +	kfree(input_string);
> +
> +unlock_ret_path:
> +	mutex_unlock(&ksym_tracer_mutex);
> +	return ret;
> +}
> +
> +static const struct file_operations ksym_tracing_fops = {
> +	.open		= tracing_open_generic,
> +	.read		= ksym_trace_filter_read,
> +	.write		= ksym_trace_filter_write,
> +};
> +
> +static int ksym_trace_init(struct trace_array *tr)
> +{
> +	int cpu;
> +
> +	for_each_online_cpu(cpu)
> +		tracing_reset(tr, cpu);
> +	ksym_tracing_enabled = 1;
> +	ksym_trace_array = tr;
> +
> +	return 0;
> +}
> +
> +static void ksym_trace_reset(struct trace_array *tr)
> +{
> +	ksym_tracing_enabled = 0;
> +}
> +
> +#ifdef CONFIG_FTRACE_SELFTEST
> +int trace_selftest_startup_ksym(struct tracer *trace, struct trace_array *tr)
> +{
> +	/* TODO: Will be implemented later */
> +	return 0;
> +}
> +#endif /* CONFIG_FTRACE_SELFTEST */
> +
> +static void ksym_trace_print_header(struct seq_file *m)
> +{
> +
> +	seq_puts(m,
> +		 "#       TASK-PID      CPU#      Symbol         Type    "
> +		 "Function         \n");
> +	seq_puts(m,
> +		 "#          |           |          |              |         "
> +		 "|            \n");
> +}
> +
> +static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
> +{
> +	struct trace_entry *entry = iter->ent;
> +	struct trace_seq *s = &iter->seq;
> +	struct trace_ksym *field;
> +	char str[KSYM_SYMBOL_LEN];
> +	int ret;
> +
> +	trace_assign_type(field, entry);
> +
> +	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->p_name,
> +				field->pid, iter->cpu, field->ksym_name);

s/field->pid/entry->pid/

-- Steve

> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	switch (field->ksym_hbkpt->info.type) {
> +	case HW_BREAKPOINT_WRITE:
> +		ret = trace_seq_printf(s, " W  ");
> +		break;
> +	case HW_BREAKPOINT_RW:
> +		ret = trace_seq_printf(s, " RW ");
> +		break;
> +	default:
> +		return TRACE_TYPE_PARTIAL_LINE;
> +	}
> +
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	sprint_symbol(str, field->ip);
> +	ret = trace_seq_printf(s, "%-20s\n", str);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	return TRACE_TYPE_HANDLED;
> +}
> +
> +struct tracer ksym_tracer __read_mostly =
> +{
> +	.name		= "ksym_tracer",
> +	.init		= ksym_trace_init,
> +	.reset		= ksym_trace_reset,
> +#ifdef CONFIG_FTRACE_SELFTEST
> +	.selftest	= trace_selftest_startup_ksym,
> +#endif
> +	.print_header   = ksym_trace_print_header,
> +	.print_line	= ksym_trace_output
> +};
> +
> +__init static int init_ksym_trace(void)
> +{
> +	struct dentry *d_tracer;
> +	struct dentry *entry;
> +
> +	d_tracer = tracing_init_dentry();
> +	ksym_filter_entry_count = 0;
> +
> +	entry = debugfs_create_file("ksym_trace_filter", 0666, d_tracer,
> +				    NULL, &ksym_tracing_fops);
> +	if (!entry)
> +		pr_warning("Could not create debugfs "
> +			   "'ksym_trace_filter' file\n");
> +
> +	return register_tracer(&ksym_tracer);
> +
> +}
> +device_initcall(init_ksym_trace);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
