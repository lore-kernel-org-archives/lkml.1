Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYIOOz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYIOOz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 10:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbYIOOzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 10:55:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22901 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYIOOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 10:55:11 -0400
Date: Mon, 15 Sep 2008 07:54:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce boot_printk()
Message-Id: <20080915075416.c810a79b.randy.dunlap@oracle.com>
In-Reply-To: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

On Mon, 15 Sep 2008 01:05:16 -0700 Yinghai Lu wrote:

> could be enabled via "boot=verbose" to get more debug info
> 
> will use it to convert some printk(KERN_DEBUG ...)
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  include/linux/kernel.h |   19 +++++++++++++++++++
>  kernel/printk.c        |   21 +++++++++++++++++++++
>  2 files changed, 40 insertions(+)
> 
> Index: linux-2.6/include/linux/kernel.h
> ===================================================================
> --- linux-2.6.orig/include/linux/kernel.h
> +++ linux-2.6/include/linux/kernel.h
> @@ -344,6 +344,25 @@ static inline char *pack_hex_byte(char *
>  #endif
>  
>  /*
> + * Debugging macros
> + */
> +#define BOOT_QUIET   0
> +#define BOOT_VERBOSE 1
> +#define BOOT_SPEW    2
> +
> +extern int boot_verbosity;
> +/*
> + * Define the default level of output to be very little
> + * This can be turned up by using boot=verbose for more
> + * information and boot=spew for _lots_ of information.
> + * boot_verbosity is defined in printk.c
> + */
> +#define boot_printk(v, s, a...) do {        \
> +		if ((v) <= boot_verbosity)  \
> +			printk(s, ##a);    \
> +	} while (0)
> +
> +/*
>   *      Display an IP address in readable format.
>   */
>  
> Index: linux-2.6/kernel/printk.c
> ===================================================================
> --- linux-2.6.orig/kernel/printk.c
> +++ linux-2.6/kernel/printk.c
> @@ -604,6 +604,27 @@ asmlinkage int printk(const char *fmt, .
>  	return r;
>  }
>  
> +int boot_verbosity;
> +
> +static int __init boot_set_verbosity(char *arg)
> +{
> +	if (!arg)
> +		return -EINVAL;
> +
> +	if (strcmp("spew", arg) == 0)
> +		boot_verbosity = BOOT_SPEW;
> +	else if (strcmp("verbose", arg) == 0)
> +		boot_verbosity = BOOT_VERBOSE;
> +	else {
> +		printk(KERN_WARNING "boot Verbosity level %s not recognised"

		                                                       ised; "

and please add an entry to Documentation/kernel-parameters.txt for this.


> +			" use boot=verbose or boot=spew\n", arg);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +early_param("boot", boot_set_verbosity);
> +
>  /* cpu currently holding logbuf_lock */
>  static volatile unsigned int printk_cpu = UINT_MAX;


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
