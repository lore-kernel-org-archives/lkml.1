Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbYKNVcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbYKNVcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYKNVch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:32:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbYKNVcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:32:36 -0500
Date: Fri, 14 Nov 2008 13:32:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: schwidefsky@de.ibm.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Add PR_PREFIX to pr_xyz macros.
Message-Id: <20081114133213.ac98ba0f.akpm@linux-foundation.org>
In-Reply-To: <1226521003.2222.8.camel@localhost>
References: <1226511327.23498.3.camel@localhost>
	<alpine.LFD.2.00.0811121144400.3468@nehalem.linux-foundation.org>
	<1226521003.2222.8.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 21:16:43 +0100
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> Subject: [PATCH] Add PR_PREFIX to pr_xyz macros.
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> A common reason for device drivers to implement their own printk macros
> is the lack of a printk prefix with the standard pr_xyz macros. Introduce
> a pr_fmt macro that is applied for every pr_xyz macro to the format string.
> The most common use of the pr_fmt macro would be to add the name of the
> device driver to all pr_xyz messages in a source file.
> 

Seems sane.  It would be nice to see one such driver converted over (hint;))

> ---
>  include/linux/kernel.h |   42 +++++++++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 19 deletions(-)
> 
> diff -urpN linux-2.6/include/linux/kernel.h linux-2.6-patched/include/linux/kernel.h
> --- linux-2.6/include/linux/kernel.h	2008-11-03 09:40:45.000000000 +0100
> +++ linux-2.6-patched/include/linux/kernel.h	2008-11-12 21:07:21.000000000 +0100
> @@ -318,32 +318,36 @@ static inline char *pack_hex_byte(char *
>  	return buf;
>  }
>  
> -#define pr_emerg(fmt, arg...) \
> -	printk(KERN_EMERG fmt, ##arg)
> -#define pr_alert(fmt, arg...) \
> -	printk(KERN_ALERT fmt, ##arg)
> -#define pr_crit(fmt, arg...) \
> -	printk(KERN_CRIT fmt, ##arg)
> -#define pr_err(fmt, arg...) \
> -	printk(KERN_ERR fmt, ##arg)
> -#define pr_warning(fmt, arg...) \
> -	printk(KERN_WARNING fmt, ##arg)
> -#define pr_notice(fmt, arg...) \
> -	printk(KERN_NOTICE fmt, ##arg)
> -#define pr_info(fmt, arg...) \
> -	printk(KERN_INFO fmt, ##arg)
> +#ifndef pr_fmt
> +#define pr_fmt(fmt) fmt 
> +#endif
> +
> +#define pr_emerg(fmt, ...) \
> +        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_alert(fmt, ...) \
> +        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_crit(fmt, ...) \
> +        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_err(fmt, ...) \
> +        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_warning(fmt, ...) \
> +        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_notice(fmt, ...) \
> +        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_info(fmt, ...) \
> +        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>  
>  /* If you are writing a driver, please use dev_dbg instead */
>  #if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
>  #define pr_debug(fmt, ...) do { \
> -	dynamic_pr_debug(fmt, ##__VA_ARGS__); \
> +	dynamic_pr_debug(pr_fmt(fmt), ##__VA_ARGS__); \
>  	} while (0)
>  #elif defined(DEBUG)
> -#define pr_debug(fmt, arg...) \
> -	printk(KERN_DEBUG fmt, ##arg)
> +#define pr_debug(fmt, ...) \
> +	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>  #else
> -#define pr_debug(fmt, arg...) \
> -	({ if (0) printk(KERN_DEBUG fmt, ##arg); 0; })
> +#define pr_debug(fmt, ...) \
> +	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
>  #endif

gack, what a stupid mess we made with the pr_debug() special-case :(

