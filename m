Return-Path: <linux-kernel-owner+w=401wt.eu-S937873AbXFGWmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937873AbXFGWmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937204AbXFGWmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:42:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33664 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765977AbXFGWmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:42:04 -0400
Date: Thu, 7 Jun 2007 15:41:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: masouds@google.com (Masoud Asgharifard Sharbiani)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make i386 kernel show the segfaults in kernel dmesg,
 like x86_64.
Message-Id: <20070607154121.2ecd1212.akpm@linux-foundation.org>
In-Reply-To: <20070605215242.GA16967@google.com>
References: <20070605215242.GA16967@google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007 14:52:44 -0700
masouds@google.com (Masoud Asgharifard Sharbiani) wrote:

> Hello,
> This patch makes the i386 behave the same way that x86_64 does when a
> segfault happens. A line gets printed to the kernel log so that tools
> that need to check for failures can behave more uniformly between
> different kernels. Like x86_64, it can be disabled by setting
> debug.exception-trace sysctl variable to 0 (or by doing
> echo 0 > /proc/sys/debug/exception-trace)
> 
> Same behaviour can be extended to other architectures, if needed.
> cheers,
> Masoud.
> 
>  
> +#ifdef CONFIG_SYSCTL
> +#include <linux/sysctl.h>
> +
> +extern int exception_trace;
> +
> +static ctl_table debug_table2[] = {
> +	{
> +		.ctl_name	= 99,
> +		.procname	= "exception-trace",
> +		.data		= &exception_trace,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec
> +	},
> +	{}
> +}; 
> +
> +static ctl_table debug_root_table2[] = { 
> +	{
> +		.ctl_name = CTL_DEBUG,
> +		.procname = "debug",
> +		.mode = 0555,
> +		.child = debug_table2
> +	},
> +	{}
> +}; 
> +
> +static __init int i386_sysctl_init(void)
> +{ 
> +	register_sysctl_table(debug_root_table2);
> +	return 0;
> +}
> +__initcall(i386_sysctl_init);
> +#endif

There's still quite a bit of duplication here.

Perhaps we could move this sysctl stuff into kernel/sysctl.c (under a new
CONFIG_EXCEPTION_TRACE (which seems a poor name - maybe
CONFIG_REPORT_UNHANDLED_SIGNALS?))



akpm:/usr/src/25> grep -r exception_trace Documentation 
akpm:/usr/src/25> 

ho hum.
