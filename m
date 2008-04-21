Return-Path: <linux-kernel-owner+w=401wt.eu-S1762618AbYDURax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762618AbYDURax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbYDURaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:30:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41533 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbYDURaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:30:05 -0400
Date: Mon, 21 Apr 2008 10:14:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: prasad@linux.vnet.ibm.com
Cc: David Wilder <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, hunt@redhat.com, michaele@au1.ibm.com,
       dave@linux.vnet.ibm.com
Subject: Re: [RFC Patch 1/1] debugfs_printk and debugfs_dump interface
Message-Id: <20080421101403.cecf4d7b.randy.dunlap@oracle.com>
In-Reply-To: <20080421124329.GA14118@in.ibm.com>
References: <20080415111459.GB5295@in.ibm.com>
	<20080415112603.GA5770@in.ibm.com>
	<48066EBE.3040608@us.ibm.com>
	<20080421124329.GA14118@in.ibm.com>
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

On Mon, 21 Apr 2008 18:13:29 +0530 K. Prasad wrote:

> This patch introduces two new interfaces called debugfs_printk and 
> debugfs_dump which can be used to print to the debugfs mount directly.
> It uses the 'trace' infrastructure underneath and is a patch over it.
> A sample file is also created to demonstrate its ease of use.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  Documentation/trace.txt        |   21 ++++
>  include/linux/trace.h          |   55 +++++++++++
>  lib/trace.c                    |  196 +++++++++++++++++++++++++++++++++++++++--
>  samples/trace/Makefile         |    2 
>  samples/trace/fork_new_trace.c |   97 ++++++++++++++++++++
>  5 files changed, 365 insertions(+), 6 deletions(-)

> Index: linux-2.6.25-rc8-mm1/lib/trace.c
> ===================================================================
> --- linux-2.6.25-rc8-mm1.orig/lib/trace.c
> +++ linux-2.6.25-rc8-mm1/lib/trace.c
> @@ -561,3 +609,141 @@ void trace_cleanup(struct trace_info *tr
>  	kfree(trace);
>  }
>  EXPORT_SYMBOL_GPL(trace_cleanup);
> +
> +/**
> + *	trace_cleanup_all - Removes all trace_info/directories created under a
> + *			    parent_dir

kernel-doc requires the "function name - description" to be on one line.
You could change the *<tab> to be *<space(s)>.

> + *	@parent_dir: Name of the parent directory
> + */
> +void trace_cleanup_all(const char *parent_dir)
> +{
> +	struct list_head *pos, *pos_temp;
> +	struct trace_dir *temp;
> +
> +	list_for_each_safe(pos, pos_temp, &trace_dirs) {
> +		temp = list_entry(pos, struct trace_dir, trace_dir_list);
> +		if (!strcmp(parent_dir, temp->trace_root->d_iname))
> +			trace_cleanup(temp->ti);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(trace_cleanup_all);
> +
...
> +
> +/*
> + * debugfs_printk - A function to write into the debugfs mount 'directly'
> + * using 'trace' infrastructure
> + * @dpk - Structure containing info such as parent_dir and directory
> + * @format - String containing format string specifiers
> + * @ap - List of arguments

This one isn't quite kernel-doc notation, but it's very close to it,
and it should be kernel-doc since it's an exported symbol.
So it needs the following changes:

- begin with /**
- put function name + short description on one line
- use "@dpk: <description>" for function parameters (not "-")

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

Use kernel-doc notation.  Same comments as above.

> + */
> +int debugfs_dump(struct debugfs_printk_data *dpk, const void *output,
> +							const int output_len)
> +{
> +	struct trace_info *ti;
> +	char *record;
> +
> +	ti = init_trace_interface(dpk);
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

> Index: linux-2.6.25-rc8-mm1/Documentation/trace.txt
> ===================================================================
> --- linux-2.6.25-rc8-mm1.orig/Documentation/trace.txt
> +++ linux-2.6.25-rc8-mm1/Documentation/trace.txt
> @@ -150,6 +150,27 @@ The steps a kernel data provider takes t
>  5) Destroy the trace channel and underlying relay channel -
>     trace_cleanup().
>  
> +Alternatively the user may choose to make use of two new interfaces

                                                    two new interfaces --

> +debugfs_printk() and debugfs_dump() to setup trace interface and

                    and debugfs_dump() -- to setup trace interfaces and

> +trace_cleanup_all() to tear-down the same.
> +
> +Steps to use:


---
~Randy
