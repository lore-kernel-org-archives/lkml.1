Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZBXE2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZBXE2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 23:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZBXE2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 23:28:40 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:58755 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbZBXE2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 23:28:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SHIMDwBkMkqiIS+6m1pQDG8KHpWCodMtyeTloK62ybgfkN2g9OOxbN2jybLlzX6oDY
         rFr7Bx95ILW806Wyg7pJrKHZTmZd7Eofdy7tLoDY8kTSLnXP/YNBQQrBhsyHQCLucY6c
         v4yMenNmhuFKiSYD8fT4oqGgW8ZOk84L/HWxo=
Date: Tue, 24 Feb 2009 07:35:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 4/4] mqueue namespace: adapt sysctl
Message-ID: <20090224043512.GA3202@x200.localdomain>
References: <20090224030347.GA10913@us.ibm.com> <20090224030933.GC11441@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224030933.GC11441@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 09:09:33PM -0600, Serge E. Hallyn wrote:
> +#ifdef CONFIG_PROC_FS
> +static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
> +	void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table mq_table;
> +	memcpy(&mq_table, table, sizeof(mq_table));
> +	mq_table.data = get_mq(table);
> +
> +	return proc_dointvec(&mq_table, write, filp, buffer, lenp, ppos);
> +}
> +
> +static int proc_mq_dointvec_minmax(ctl_table *table, int write,
> +	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table mq_table;
> +	memcpy(&mq_table, table, sizeof(mq_table));
> +	mq_table.data = get_mq(table);
> +
> +	return proc_dointvec_minmax(&mq_table, write, filp, buffer,
> +					lenp, ppos);
> +}
> +#else /* CONFIG_PROC_FS */
> +static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
> +	void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	return -ENOSYS;
> +}
> +
> +static int proc_mq_dointvec_minmax(ctl_table *table, int write,
> +	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	return -ENOSYS;
> +}
> +#endif /* CONFIG_PROC_FS */

These should be under CONFIG_PROC_SYSCTL and one should define them to
NULL otherwise.

> +static ctl_table mq_sysctls[] = {
> +	{
> +		.procname	= "queues_max",
> +		.data		= &init_ipc_ns.mq_queues_max,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_mq_dointvec,
				  ^
No &, please. I'm removing them.

> +	},
> +	{
> +		.procname	= "msg_max",
> +		.data		= &init_ipc_ns.mq_msg_max,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_mq_dointvec_minmax,
> +		.extra1		= &msg_max_limit_min,
> +		.extra2		= &msg_max_limit_max,
> +	},
> +	{
> +		.procname	= "msgsize_max",
> +		.data		= &init_ipc_ns.mq_msgsize_max,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_mq_dointvec_minmax,
> +		.extra1		= &msg_maxsize_limit_min,
> +		.extra2		= &msg_maxsize_limit_max,
> +	},
