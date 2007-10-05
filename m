Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbXJEFtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbXJEFtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXJEFtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:49:41 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50113 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbXJEFtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:49:41 -0400
Date: Fri, 5 Oct 2007 11:19:52 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>, Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 2/2] implement new notifier function to panic_notifier_list
Message-ID: <20071005054952.GC4893@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <4704D0CA.4080001@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4704D0CA.4080001@ah.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 08:38:50PM +0900, Takenori Nagano wrote:
> This patch implements new notifier function to panic_notifier_list. We can
> change the list of order by debugfs.
> 
> Thanks,
> 
> ---
> 
> Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>
> 
> ---
> diff -uprN linux-2.6.23-rc9.orig/arch/alpha/kernel/setup.c
> linux-2.6.23-rc9/arch/alpha/kernel/setup.c
> --- linux-2.6.23-rc9.orig/arch/alpha/kernel/setup.c	2007-10-02
> 12:24:52.000000000 +0900
> +++ linux-2.6.23-rc9/arch/alpha/kernel/setup.c	2007-10-04 09:49:34.440000000 +0900
> @@ -45,14 +45,22 @@
>  #include <asm/io.h>
>  #include <linux/log2.h>
> 
> -extern struct atomic_notifier_head panic_notifier_list;
> +extern struct tunable_notifier_head panic_notifier_list;
>  static int alpha_panic_event(struct notifier_block *, unsigned long, void *);
> -static struct notifier_block alpha_panic_block = {
> +static struct notifier_block alpha_panic_block_base = {
>  	alpha_panic_event,
>          NULL,
>          INT_MAX /* try to do it first */
>  };
> 
> +static struct tunable_notifier_block alpha_panic_block = {
> +	&alpha_panic_block_base,
> +	NULL,
> +	NULL,
> +	NULL,
> +	NULL
> +};
> +
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
>  #include <asm/system.h>
> @@ -522,8 +530,8 @@ setup_arch(char **cmdline_p)
>  	}
> 
>  	/* Register a call for panic conditions. */
> -	atomic_notifier_chain_register(&panic_notifier_list,
> -			&alpha_panic_block);
> +	tunable_notifier_chain_register(&panic_notifier_list,
> +			&alpha_panic_block, "alpha_panic", NULL);
> 

I think it might be good idea to somehow create provisions for another a
help string. This help string will inform admin that what a registered
user does? Ideally this should be visible in /sys/kernel/debug/<user module>/description file.

This kind of description can help admin to decide the priority among various
registered users withoug having to look at the source code.

Thanks
Vivek
