Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZCELeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZCELeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZCELeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:34:10 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:46702 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZCELeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:34:09 -0500
Date: Thu, 5 Mar 2009 17:03:59 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces
Message-ID: <20090305113359.GA25213@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305044333.GM17747@in.ibm.com> <20090305063703.GB5359@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305063703.GB5359@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 07:37:04AM +0100, Frederic Weisbecker wrote:
> On Thu, Mar 05, 2009 at 10:13:33AM +0530, prasad@linux.vnet.ibm.com wrote:
> > This patch adds an ftrace plugin to detect and profile memory access over
> > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > addresses.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > ---
> 
> 
> Hi,
> 
> Nice feature. And moreover the standardized hardware breakpoints could
> be helpful for tracing.
> 
> Just some comments below.
> 
>

Hi,
  Thanks for reviewing the code and pointing out the potential memory
leaks. The next iteration of this code should contain fixes for them.
I've explained the usage of 'entry' field inline.
 
> > +struct trace_ksym {
> > +	struct trace_entry	ent;
> > +	struct hw_breakpoint	*ksym_hbkpt;
> > +	unsigned long		ksym_addr;
> > +	unsigned long		ip;
> > +	pid_t			pid;
> 
> 
> Just a doubt here.
> The current pid is automatically recorded on trace_buffer_lock_reserve()
> (or unlock_commit, don't remember), so if this pid is the current one, you
> don't need to reserve a room for it, current pid is on struct trace_entry.
>

It's a carriage from an old version of the code which used the old
ring-buffer APIs like ring_buffer_lock_reserve(). I will now use the
"pid" field in "struct trace_entry".
 
> > +static int process_new_ksym_entry(struct trace_ksym *entry, char *ksymname,
> > +			     int op, unsigned long addr)
> > +{
> > +	if (ksym_filter_entry_count >= KSYM_TRACER_MAX) {
> > +		printk(KERN_ERR "ksym_tracer: Maximum limit:(%d) reached. No"
> > +			" new requests for tracing can be accepted now.\n",
> > +			KSYM_TRACER_MAX);
> > +		return -ENOSPC;
> > +	}
> > +
> > +	entry = kzalloc(sizeof(struct trace_ksym), GFP_KERNEL);
> 
> 
> I'm not sure I understand, you passed an allocated entry to that function, no?
> If your are using entry as a local variable, it doesn't make sense to pass it
> as a parameter.
> 
> 
> > +	if (!entry)
> > +		return -ENOMEM;
> >
> > +	entry->ksym_hbkpt = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
> > +	if (!entry->ksym_hbkpt)
> > +		return -ENOMEM;
> 
> 
> Ouch, what happens here to the memory pointed by entry?
> 
>

A potential leak....will fix this and the others you've pointed below.
 
> > +
> > +	entry->ksym_hbkpt->info.name = ksymname;
> > +	entry->ksym_hbkpt->info.type = op;
> > +	entry->ksym_addr = entry->ksym_hbkpt->info.address = addr;
> > +	entry->ksym_hbkpt->info.len = HW_BREAKPOINT_LEN_4;
> > +	entry->ksym_hbkpt->priority = HW_BREAKPOINT_PRIO_NORMAL;
> > +
> > +	entry->ksym_hbkpt->installed = (void *)ksym_hbkpt_installed;
> > +	entry->ksym_hbkpt->uninstalled = (void *)ksym_hbkpt_uninstalled;
> > +	entry->ksym_hbkpt->triggered = (void *)ksym_hbkpt_handler;
> > +
> > +	if ((register_kernel_hw_breakpoint(entry->ksym_hbkpt)) < 0) {
> > +		printk(KERN_INFO "ksym_tracer request failed. Try again"
> > +					" later!!\n");
> > +		kfree(entry);
> > +		return -EAGAIN;
> 
> 
> You forgot to free entry->ksym_hbkpt
> 
> 
> > +	}
> > +	hlist_add_head(&(entry->ksym_hlist), &ksym_filter_head);
> > +	printk(KERN_INFO "ksym_tracer changes are now effective\n");
> > +
> > +	ksym_filter_entry_count++;
> > +
> > +	return 0;
> > +}
> > +
> > +static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
> > +						size_t count, loff_t *ppos)
> > +{
> > +	struct trace_ksym *entry;
> > +	struct hlist_node *node;
> > +	char buf[KSYM_FILTER_ENTRY_LEN * KSYM_TRACER_MAX];
> > +	ssize_t ret, cnt = 0;
> > +
> > +	mutex_lock(&ksym_tracer_mutex);
> > +
> > +	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
> > +		cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt, "%s:",
> > +				entry->ksym_hbkpt->info.name);
> > +		if (entry->ksym_hbkpt->info.type == HW_BREAKPOINT_WRITE)
> > +			cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt,
> > +								"-w-\n");
> > +		else if (entry->ksym_hbkpt->info.type == HW_BREAKPOINT_RW)
> > +			cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt,
> > +								"rw-\n");
> > +	}
> > +	ret = simple_read_from_buffer(ubuf, count, ppos, buf, strlen(buf));
> > +	mutex_unlock(&ksym_tracer_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static ssize_t ksym_trace_filter_write(struct file *file,
> > +					const char __user *buffer,
> > +						size_t count, loff_t *ppos)
> > +{
> > +	struct trace_ksym *entry;
> > +	struct hlist_node *node;
> > +	char *input_string, *ksymname = NULL;
> > +	unsigned long ksym_addr = 0;
> > +	int ret, op, changed = 0;
> > +
> > +	input_string = kzalloc(count, GFP_KERNEL);
> > +	if (!input_string)
> > +		return -ENOMEM;
> > +
> > +	/* Ignore echo "" > ksym_trace_filter */
> > +	if (count == 0)
> > +		return 0;
> 
> 
> You forgot to free input_string in !count case.
> 
> 
> > +
> > +	if (copy_from_user(input_string, buffer, count))
> > +		return -EFAULT;
> 
> 
> Ditto.
> 
> > +	ret = op = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
> > +
> > +	if (ret < 0)
> > +		goto err_ret;
> 
> 
> Ah, here you didn't forget.
> 
> 
> > +	mutex_lock(&ksym_tracer_mutex);
> > +
> > +	ret = -EINVAL;
> > +	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
> > +		if (entry->ksym_addr == ksym_addr) {
> > +			/* Check for malformed request: (6) */
> > +			if (entry->ksym_hbkpt->info.type != op)
> > +				changed = 1;
> > +			else
> > +				goto err_ret;
> > +			break;
> > +		}
> > +	}
> > +	if (changed) {
> > +		unregister_kernel_hw_breakpoint(entry->ksym_hbkpt);
> > +		entry->ksym_hbkpt->info.type = op;
> > +		if (op > 0) {
> > +			ret = register_kernel_hw_breakpoint(entry->ksym_hbkpt);
> > +			if (ret > 0) {
> > +				ret = count;
> > +				goto unlock_ret_path;
> > +			}
> > +			if (ret == 0) {
> > +				ret = -ENOSPC;
> > +				unregister_kernel_hw_breakpoint(entry->\
> > +								ksym_hbkpt);
> > +			}
> > +		}
> > +		ksym_filter_entry_count--;
> > +		hlist_del(&(entry->ksym_hlist));
> > +		kfree(entry->ksym_hbkpt);
> > +		kfree(entry);
> > +		ret = count;
> > +		goto err_ret;
> > +	} else {
> > +		/* Check for malformed request: (4) */
> > +		if (op == 0)
> > +			goto err_ret;
> > +
> > +		ret = process_new_ksym_entry(entry, ksymname, op, ksym_addr);
> 
> 
> You are passing an allocated entry as a parameter, but later on process_new_ksym_entry()
> you allocate a new space for entry.
> I'm confused.
> 
>

When changed = 1, entry points to the existing instance of 'struct
trace_ksym' and will be used for changing the type of breakpoint. If the
input is a new request to ksym_trace_filter file process_new_ksym_entry()
takes a pointer to 'struct trace_ksym' i.e entry for
allocation/initialisation rather than use it as a parameter in the true
sense.

This is similar to the usage of parameters 'ksymname and addr' in
parse_ksym_trace_str() where they are used to return multiple values.

I hope you find the usage acceptable.
 
> > +
> > +__init static int init_ksym_trace(void)
> > +{
> > +	struct dentry *d_tracer;
> > +	struct dentry *entry;
> > +
> > +	d_tracer = tracing_init_dentry();
> > +	ksym_filter_entry_count = 0;
> > +
> > +	entry = debugfs_create_file("ksym_trace_filter", 0666, d_tracer,
> > +				    NULL, &ksym_tracing_fops);
> > +	if (!entry)
> > +		pr_warning("Could not create debugfs "
> > +			   "'ksym_trace_filter' file\n");
> > +
> > +	return register_tracer(&ksym_tracer);
> > +
> > +}
> > +device_initcall(init_ksym_trace);
> 
> 
> Well, the rest looks good.
> 
>

Thanks again for your comments.

-- K.Prasad 
