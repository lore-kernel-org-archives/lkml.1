Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYDXVXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYDXVXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYDXVXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:23:42 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43188 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbYDXVXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:23:41 -0400
Message-ID: <4810FA44.9060402@us.ibm.com>
Date: Thu, 24 Apr 2008 14:23:16 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20080131)
MIME-Version: 1.0
To: prasad@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       hunt@redhat.com, michaele@au1.ibm.com, dave@linux.vnet.ibm.com
Subject: Re: [RFC Patch 1/1] debugfs_printk and debugfs_dump interface
References: <20080415111459.GB5295@in.ibm.com> <20080415112603.GA5770@in.ibm.com> <48066EBE.3040608@us.ibm.com> <20080421124329.GA14118@in.ibm.com>
In-Reply-To: <20080421124329.GA14118@in.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


debugfs_print makes a great improvement to the trace interface.   I 
missing a couple of bugs the first time I reviewed it.  Please see my 
comments in-line.

Dave..


> +static inline struct trace_info *init_trace_interface(struct
> +                        			debugfs_printk_data *dpk)
> +{
> +        struct trace_info *ti;
> +
> +        dpk->exists = trace_exists(dpk->parent_dir, dpk->dir, &ti);
> +
> +        switch(dpk->exists) {
> +
> +        case TRACE_PARENT_DIR_EXISTS:
> +        case TRACE_PARENT_DIR_ABSENT:
> +                if(!dpk->buf_size)
> +                        dpk->buf_size = DEFAULT_TRACE_BUF_SIZE;
> +                if(!dpk->sub_buf_size)
> +                        dpk->sub_buf_size = DEFAULT_TRACE_SUB_BUF_NR;
> +                if(!dpk->flags)
> +			dpk->flags = TRACE_FLIGHT_CHANNEL;
> +                ti = trace_setup(dpk->parent_dir, dpk->dir,
> +                        dpk->buf_size, dpk->sub_buf_size, dpk->flags);
> +                printk(KERN_INFO "Trace interface %s setup through "
> +                                                        "debugfs_printk\n",
> +                                                        ti->dir->d_iname);
> +                if (IS_ERR(ti)) {
> +                        printk(KERN_ERR "Trace interface could not be "
> +                        "initialised\n");
> +                        return PTR_ERR(ti);
> +                }
> +                /* Fall through */
> +        case TRACE_DIR_EXISTS:
> +             if (ti->state != TRACE_RUNNING) {

You should start the trace only if the current state is TRACE_SETUP (I 
think).  See my comment in debugfs_print()


		  if (ti->state == TRACE_SETUP)
> +                        trace_start(ti);
> +                }
> +        }
> +        return ti;
> +}
> +
> +/*
> + * debugfs_printk - A function to write into the debugfs mount 'directly'
> + * using 'trace' infrastructure
> + * @dpk - Structure containing info such as parent_dir and directory
> + * @format - String containing format string specifiers
> + * @ap - List of arguments
> + */
> +int debugfs_printk(struct debugfs_printk_data *dpk, char *format, ...)
> +{
> +	int ret;
> +	struct trace_info *ti;
> +	va_list(ap);
> +	unsigned long flags;
> +
> +	va_start(ap, format);
> +
> +	ti = init_trace_interface(dpk);

init_trace_interface() alway sets trace->state to TRACE_RUNNING .  The 
results is that the user is prevented from stopping the trace.  You can 
see this in fork_new_trace.

$ cat debug/trace_new_example/do_fork/state
running
$ echo stop > debug/trace_new_example/do_fork/state
$ cat debug/trace_new_example/do_fork/state
running

> +
> +	/* Now do the actual printing */
> +	/* Take an RCU Lock over the trace_info state */
> +	rcu_read_lock();
> +	/* Take a spinlock for the global buffer used by relay */
> +	if (dpk->flags & TRACE_GLOBAL_CHANNEL)
> +		spin_lock_irqsave(&trace_lock, flags);
> +	ret = trace_printf(ti, format, ap);
> +	if (dpk->flags & TRACE_GLOBAL_CHANNEL)
> +		spin_unlock_irqrestore(&trace_lock, flags);
> +	rcu_read_unlock();
> +
> +	va_end(ap);
> +	return ret;
> +}
> +EXPORT_SYMBOL(debugfs_printk);
> +
> +/*
> + * debugfs_printk - A function to write into the debugfs mount 'directly'
> + * using 'trace' infrastructure
> + * @dpk - Structure containing info such as parent_dir and directory
> + * @output - Data that needs to be output
> + * @output_len - Length of the output data
> + */
> +int debugfs_dump(struct debugfs_printk_data *dpk, const void *output,
> +							const int output_len)
> +{
> +	struct trace_info *ti;
> +	char *record;
> +
> +	ti = init_trace_interface(dpk);

Same issue as debugfs_printf,

You should also check for trace_running as you did for trace_printf.


> +
> +	/* Now do the actual printing */
> +	rcu_read_lock();
> +	record = relay_reserve(ti->rchan, output_len);
> +	if (record)
> +		memcpy(record, output, output_len);
> +	else
> +		return -ENOMEM;
> +	rcu_read_unlock();
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(debugfs_dump);
