Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbZELPPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbZELPPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZELPPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:15:12 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:64055 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbZELPPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cy0l7fhQ83X7x4qOBcFJ7CelWGlN7Yh1dwKOmvDrFab/eSA6gD0GKHl45RFsCRw4ay
         NJMnvEoAInaYE1ejtbPmSgvF8eFMWRYmmMF3ToEb4AYbel0OwqvzQzsZJ4ABFohfrZzg
         B4Xy50ckCBNjX7rz2HjBINOyx2czmPhTk/Epc=
Date: Tue, 12 May 2009 17:15:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 11/12] ftrace plugin for kernel symbol tracing using
	HWBreakpoint interfaces - v4
Message-ID: <20090512151504.GB6255@nowhere>
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com> <20090511115502.GL25673@in.ibm.com> <20090511221427.GB5965@nowhere> <20090512141944.GB6033@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512141944.GB6033@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 07:49:44PM +0530, K.Prasad wrote:
> On Tue, May 12, 2009 at 12:14:29AM +0200, Frederic Weisbecker wrote:
> > On Mon, May 11, 2009 at 05:25:02PM +0530, K.Prasad wrote:
> > > This patch adds an ftrace plugin to detect and profile memory access over kernel
> > > variables. It uses HW Breakpoint interfaces to 'watch memory addresses.
> > > 
> > > +void ksym_collect_stats(unsigned long hbp_hit_addr)
> > > +{
> > > +	struct hlist_node *node;
> > > +	struct trace_ksym *entry;
> > > +
> > > +	rcu_read_lock();
> > > +	hlist_for_each_entry_rcu(entry, node, &ksym_filter_head, ksym_hlist) {
> > > +		if ((entry->ksym_addr == hbp_hit_addr) &&
> > > +		    (entry->counter <= MAX_UL_INT)) {
> > > +			entry->counter++;
> > > +			break;
> > > +		}
> > > +	}
> > > +	rcu_read_unlock();
> > 
> > 
> > 
> > rcu looks a good idea to maintain your list.
> >
> 
> True, and there weren't many choices either. The earlier implementations
> with mutex/spin_lock turned out to be incorrect in their own way (while
> mutexes cannot be used inside exception handler context, spinlocks led to
> potential circular dependancy).
>  
> > > +static int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
> > > +{
> > > +	struct trace_ksym *entry;
> > > +	int ret;
> > > +
> > > +	if (ksym_filter_entry_count >= KSYM_TRACER_MAX) {
> > > +		printk(KERN_ERR "ksym_tracer: Maximum limit:(%d) reached. No"
> > > +		" new requests for tracing can be accepted now.\n",
> > > +			KSYM_TRACER_MAX);
> > > +		return -ENOSPC;
> > > +	}
> > > +
> > > +	entry = kzalloc(sizeof(struct trace_ksym), GFP_KERNEL);
> > > +	if (!entry)
> > > +		return -ENOMEM;
> > > +
> > > +	entry->ksym_hbp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
> > > +	if (!entry->ksym_hbp) {
> > > +		kfree(entry);
> > > +		return -ENOMEM;
> > > +	}
> > > +
> > > +	entry->ksym_hbp->info.name = ksymname;
> > > +	entry->ksym_hbp->info.type = op;
> > > +	entry->ksym_addr = entry->ksym_hbp->info.address = addr;
> > > +#ifdef CONFIG_X86
> > > +	entry->ksym_hbp->info.len = HW_BREAKPOINT_LEN_4;
> > > +#endif
> > > +	entry->ksym_hbp->triggered = (void *)ksym_hbp_handler;
> > > +
> > > +	ret = register_kernel_hw_breakpoint(entry->ksym_hbp);
> > > +	if (ret < 0) {
> > > +		printk(KERN_INFO "ksym_tracer request failed. Try again"
> > > +					" later!!\n");
> > > +		kfree(entry->ksym_hbp);
> > > +		kfree(entry);
> > > +		return -EAGAIN;
> > > +	}
> > > +	hlist_add_head_rcu(&(entry->ksym_hlist), &ksym_filter_head);
> > 
> > 
> > And then ksym_tracer_mutex protect concurrent writers.
> > 
> > 
> 
> Yes, they synchronise read/write operations over the list pointed by
> ksym_filter_head.
> 
> > > +	ksym_filter_entry_count++;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
> > > +						size_t count, loff_t *ppos)
> > > +{
> > > +	struct trace_ksym *entry;
> > > +	struct hlist_node *node;
> > > +	char buf[KSYM_FILTER_ENTRY_LEN * KSYM_TRACER_MAX];
> > > +	ssize_t ret, cnt = 0;
> > > +
> > > +	mutex_lock(&ksym_tracer_mutex);
> > > +
> > > +	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
> > 
> > 
> > 
> > And here you don't use the rcu version.
> > I guess it's fine since you're protected by the writer lock...
> > 
> 
> I couldn't use RCU here because the simple_read_from_buffer() is
> inatomic, and hence the mutex.



Ah indeed, it might sleep, you're right.


 
> > > +		cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt, "%s:",
> > > +				entry->ksym_hbp->info.name);
> > > +		if (entry->ksym_hbp->info.type == HW_BREAKPOINT_WRITE)
> > > +			cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt,
> > > +								"-w-\n");
> > > +		else if (entry->ksym_hbp->info.type == HW_BREAKPOINT_RW)
> > > +			cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt,
> > > +								"rw-\n");
> > > +	}
> > > +	ret = simple_read_from_buffer(ubuf, count, ppos, buf, strlen(buf));
> > > +	mutex_unlock(&ksym_tracer_mutex);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static ssize_t ksym_trace_filter_write(struct file *file,
> > > +					const char __user *buffer,
> > > +						size_t count, loff_t *ppos)
> > > +{
> > > +	struct trace_ksym *entry;
> > > +	struct hlist_node *node;
> > > +	char *input_string, *ksymname = NULL;
> > > +	unsigned long ksym_addr = 0;
> > > +	int ret, op, changed = 0;
> > > +
> > > +	/* Ignore echo "" > ksym_trace_filter */
> > > +	if (count == 0)
> > > +		return 0;
> > > +
> > > +	input_string = kzalloc(count, GFP_KERNEL);
> > > +	if (!input_string)
> > > +		return -ENOMEM;
> > > +
> > > +	if (copy_from_user(input_string, buffer, count)) {
> > > +		kfree(input_string);
> > > +		return -EFAULT;
> > > +	}
> > > +
> > > +	ret = op = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
> > > +	if (ret < 0) {
> > > +		kfree(input_string);
> > > +		return ret;
> > > +	}
> > > +
> > > +	mutex_lock(&ksym_tracer_mutex);
> > > +
> > > +	ret = -EINVAL;
> > > +	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
> > 
> > 
> > 
> > Same here, ok...
> > 
> > 
> > > +static int ksym_trace_init(struct trace_array *tr)
> > > +{
> > > +	int cpu, ret = 0;
> > > +
> > > +	for_each_online_cpu(cpu)
> > > +		tracing_reset(tr, cpu);
> > > +
> > > +	ksym_tracing_enabled = 1;
> > > +	ksym_trace_array = tr;
> > > +
> > > +#ifdef CONFIG_FTRACE_SELFTEST
> > > +	/* Check if we are re-entering self-test code during initialisation */
> > > +	if (ksym_selftest_dummy)
> > > +		goto ret_path;
> > > +
> > > +	ksym_selftest_dummy = 0;
> > > +
> > > +	/* Register the read-write tracing request */
> > > +	ret = process_new_ksym_entry(KSYM_SELFTEST_ENTRY, HW_BREAKPOINT_RW,
> > > +					(unsigned long)(&ksym_selftest_dummy));
> > > +
> > > +	if (ret < 0) {
> > > +		printk(KERN_CONT "ksym_trace read-write startup test failed\n");
> > > +		goto ret_path;
> > > +	}
> > > +	/* Perform a read and a write operation over the dummy variable to
> > > +	 * trigger the tracer
> > > +	 */
> > > +	if (ksym_selftest_dummy == 0)
> > > +		ksym_selftest_dummy++;
> > > +ret_path:
> > > +#endif /* CONFIG_FTRACE_SELFTEST */
> > 
> > 
> > It means that each time your tracer is selected, it will perform a selftest.
> > I think we only need this selftest once during the boot.
> > I would rather see that in the real selftest callback (trace_selftest_startup_kysm).
> >
> 
> > > +   if (ksym_selftest_dummy)
> > > +           goto ret_path;
> 
> The above check will help prevent a re-run of the test everytime init is
> executed.
> 
> A part of the selftest was kept in trace_ksym.c (and hence in
> ksym_trace_init()) in order to use functions local to this file, such as
> process_new_ksym_entry().



Ok.
May be you could just compute your selftests on the breakpoint themselves,
not on the entries in the ring buffer.

That's what do other tracers because it's usually convenient, but the main
focuse is the event itself, because the ring buffer is already tested.
The only thing you need to test is the hardware breakpoint triggering, then
you wouldn't need anymore the trace_selftest.c helpers and you could
implement your selftest directly in your tracer file.

I remember such thing has been discussed recently but I'm not sure
whether it concerned the kprobe tracer or yours.


  
> > > +__init static int init_ksym_trace(void)
> > > +{
> > > +	struct dentry *d_tracer;
> > > +	struct dentry *entry;
> > > +
> > > +	d_tracer = tracing_init_dentry();
> > > +	ksym_filter_entry_count = 0;
> > > +
> > > +	entry = debugfs_create_file("ksym_trace_filter", 0666, d_tracer,
> > 
> > 
> > 
> > Still writeable for everyone?
> > 
> > Thanks,
> > Frederic.
> >
> 
> Looks like I missed the change! Please find the next patchset to contain
> a '644' permission mode.



Thanks, I'm looking forward for the next version.

Frederic.


 
> Thanks for reviewing the code.
> 
> -- K.Prasad
> 

