Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYLDQpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYLDQpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 11:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYLDQpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 11:45:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52429 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbYLDQpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 11:45:21 -0500
Date: Thu, 4 Dec 2008 11:44:40 -0500
From: Jason Baron <jbaron@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg K-H <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make DEBUG take precedence over DYNAMIC_PRINTK_DEBUG
	(v2)
Message-ID: <20081204164440.GB3130@redhat.com>
References: <20081202145251.6555d4cc@gondolin> <20081203201203.GA3128@redhat.com> <20081204134845.6c1df66b@gondolin> <20081204135113.6d91efb3@gondolin> <20081204144256.GA3130@redhat.com> <20081204165547.4787d1e9@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204165547.4787d1e9@gondolin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 04:55:47PM +0100, Cornelia Huck wrote:
> Statically defined DEBUG should take precedence over
> dynamically enabled debugging; otherwise adding DEBUG
> (like, for example, via CONFIG_DEBUG_KOBJECT) does not
> have the expected result of printing pr_debug() and dev_dbg()
> messages unconditionally.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> ---
>  include/linux/device.h |    8 ++++----
>  include/linux/kernel.h |    8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> --- linux-2.6.orig/include/linux/kernel.h
> +++ linux-2.6/include/linux/kernel.h
> @@ -338,13 +338,13 @@ static inline char *pack_hex_byte(char *
>          printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>  
>  /* If you are writing a driver, please use dev_dbg instead */
> -#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
> +#if defined(DEBUG)
> +#define pr_debug(fmt, ...) \
> +	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> +#elif defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
>  #define pr_debug(fmt, ...) do { \
>  	dynamic_pr_debug(pr_fmt(fmt), ##__VA_ARGS__); \
>  	} while (0)
> -#elif defined(DEBUG)
> -#define pr_debug(fmt, ...) \
> -	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>  #else
>  #define pr_debug(fmt, ...) \
>  	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
> --- linux-2.6.orig/include/linux/device.h
> +++ linux-2.6/include/linux/device.h
> @@ -553,13 +553,13 @@ extern const char *dev_driver_string(con
>  #define dev_info(dev, format, arg...)		\
>  	dev_printk(KERN_INFO , dev , format , ## arg)
>  
> -#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
> +#if defined(DEBUG)
> +#define dev_dbg(dev, format, arg...)		\
> +	dev_printk(KERN_DEBUG , dev , format , ## arg)
> +#elif defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
>  #define dev_dbg(dev, format, ...) do { \
>  	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
>  	} while (0)
> -#elif defined(DEBUG)
> -#define dev_dbg(dev, format, arg...)		\
> -	dev_printk(KERN_DEBUG , dev , format , ## arg)
>  #else
>  #define dev_dbg(dev, format, arg...)		\
>  	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })

looks good.

Acked-by: Jason Baron <jbaron@redhat.com>

thanks,

-Jason
