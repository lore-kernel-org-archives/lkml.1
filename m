Return-Path: <linux-kernel-owner+w=401wt.eu-S1760420AbXJXSLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760420AbXJXSLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbXJXSLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:11:07 -0400
Received: from xenotime.net ([66.160.160.81]:54565 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756724AbXJXSLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:11:03 -0400
Date: Wed, 24 Oct 2007 11:11:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 2/2] implement new notifier function to
 panic_notifier_list ,take2
Message-Id: <20071024111100.0f5d8b58.rdunlap@xenotime.net>
In-Reply-To: <47171EEF.7030109@ah.jp.nec.com>
References: <4716FFDB.7090502@ah.jp.nec.com>
	<47171EEF.7030109@ah.jp.nec.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 17:53:03 +0900 Takenori Nagano wrote:

> This patch implements new notifier function to panic_notifier_list. We can
> change the list of order by debugfs.

Should be sysfs IMO.  debugfs isn't (should not be) required.

> Thanks,
> 
> ---
> 
> Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>
> 
> ---
> diff -uprN linux-2.6.23.orig/arch/alpha/kernel/setup.c linux-2.6.23/arch/alpha/kernel/setup.c
> --- linux-2.6.23.orig/arch/alpha/kernel/setup.c	2007-10-10 05:31:38.000000000 +0900
> +++ linux-2.6.23/arch/alpha/kernel/setup.c	2007-10-18 08:56:53.928000000 +0900
> @@ -45,14 +45,22 @@
>  #include <asm/io.h>
>  #include <linux/log2.h>
>  
> -extern struct atomic_notifier_head panic_notifier_list;
> +extern struct tunable_atomic_notifier_head panic_notifier_list;
>  static int alpha_panic_event(struct notifier_block *, unsigned long, void *);
> -static struct notifier_block alpha_panic_block = {
> +static struct notifier_block alpha_panic_block_base = {
>  	alpha_panic_event,
>          NULL,
>          INT_MAX /* try to do it first */
>  };
>  
> +static struct tunable_atomic_notifier_block alpha_panic_block = {
> +	&alpha_panic_block_base,

Use C99-style initializer.  and NULLs aren't needed.

> +	NULL,
> +	NULL,
> +	NULL,
> +	NULL
> +};
> +
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
>  #include <asm/system.h>

> diff -uprN linux-2.6.23.orig/arch/arm/mach-omap1/board-voiceblue.c linux-2.6.23/arch/arm/mach-omap1/board-voiceblue.c
> --- linux-2.6.23.orig/arch/arm/mach-omap1/board-voiceblue.c	2007-10-10 05:31:38.000000000 +0900
> +++ linux-2.6.23/arch/arm/mach-omap1/board-voiceblue.c	2007-10-18 09:00:35.900000000 +0900
> @@ -228,14 +228,23 @@ static int panic_event(struct notifier_b
>  	return NOTIFY_DONE;
>  }
>  
> -static struct notifier_block panic_block = {
> +static struct notifier_block panic_block_base = {
>  	.notifier_call	= panic_event,
>  };
>  
> +static struct tunable_atomic_notifier_block panic_block = {
> +	.nb		= &panic_block_base,
> +	.head		= NULL,
> +	.dir		= NULL,
> +	.pri_dentry	= NULL,
> +	.desc_dentry	= NULL

Drop the NULLs.

> +};
> +
>  static int __init voiceblue_setup(void)
>  {
>  	/* Setup panic notifier */
> -	notifier_chain_register(&panic_notifier_list, &panic_block);
> +	tunable_atomic_notifier_chain_register(&panic_notifier_list,
> +					       &panic_block, "VoiceBlue", NULL);
>  
>  	return 0;
>  }
> diff -uprN linux-2.6.23.orig/arch/mips/sgi-ip22/ip22-reset.c linux-2.6.23/arch/mips/sgi-ip22/ip22-reset.c
> --- linux-2.6.23.orig/arch/mips/sgi-ip22/ip22-reset.c	2007-10-10 05:31:38.000000000 +0900
> +++ linux-2.6.23/arch/mips/sgi-ip22/ip22-reset.c	2007-10-18 09:01:33.408000000 +0900
> @@ -226,10 +226,18 @@ static int panic_event(struct notifier_b
>  	return NOTIFY_DONE;
>  }
>  
> -static struct notifier_block panic_block = {
> +static struct notifier_block panic_block_base = {
>  	.notifier_call	= panic_event,
>  };
>  
> +static struct tunable_atomic_notifier_block panic_block = {
> +	.nb		= &panic_block_base,
> +	.head		= NULL,
> +	.dir		= NULL,
> +	.pri_dentry	= NULL,
> +	.desc_dentry	= NULL

Ditto.

> +};
> +
>  static int __init reboot_setup(void)
>  {
>  	_machine_restart = sgi_machine_restart;

> diff -uprN linux-2.6.23.orig/arch/mips/sgi-ip32/ip32-reset.c linux-2.6.23/arch/mips/sgi-ip32/ip32-reset.c
> --- linux-2.6.23.orig/arch/mips/sgi-ip32/ip32-reset.c	2007-10-10 05:31:38.000000000 +0900
> +++ linux-2.6.23/arch/mips/sgi-ip32/ip32-reset.c	2007-10-18 09:02:20.496000000 +0900
> @@ -175,10 +175,18 @@ static int panic_event(struct notifier_b
>  	return NOTIFY_DONE;
>  }
>  
> -static struct notifier_block panic_block = {
> +static struct notifier_block panic_block_base = {
>  	.notifier_call = panic_event,
>  };
>  
> +static struct tunable_atomic_notifier_block panic_block = {
> +	.nb		= &panic_block_base,
> +	.head		= NULL,
> +	.dir		= NULL,
> +	.pri_dentry	= NULL,
> +	.desc_dentry	= NULL

Ditto.

> +};
> +
>  static __init int ip32_reboot_setup(void)
>  {
>  	/* turn on the green led only */

> diff -uprN linux-2.6.23.orig/arch/parisc/kernel/pdc_chassis.c linux-2.6.23/arch/parisc/kernel/pdc_chassis.c
> --- linux-2.6.23.orig/arch/parisc/kernel/pdc_chassis.c	2007-10-10 05:31:38.000000000 +0900
> +++ linux-2.6.23/arch/parisc/kernel/pdc_chassis.c	2007-10-18 08:56:54.052000000 +0900
> @@ -101,11 +101,18 @@ static int pdc_chassis_panic_event(struc
>  }   
>  
>  
> -static struct notifier_block pdc_chassis_panic_block = {
> +static struct notifier_block pdc_chassis_panic_block_base = {
>  	.notifier_call = pdc_chassis_panic_event,
>  	.priority = INT_MAX,
>  };
>  
> +static struct tunable_atomic_notifier_block pdc_chassis_panic_block = {
> +	.nb		= &pdc_chassis_panic_block_base,
> +	.head		= NULL,
> +	.dir		= NULL,
> +	.pri_dentry	= NULL,
> +	.desc_dentry	= NULL

Ditto... (I'll skip mentioning the rest of these.)

> +};
>  
>  /**
>   * parisc_reboot_event() - Called by the reboot handler.


---
~Randy
