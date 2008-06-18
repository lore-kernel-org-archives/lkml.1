Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYFRQLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYFRQLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYFRQLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:11:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYFRQLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:11:36 -0400
Date: Wed, 18 Jun 2008 09:08:12 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, joe@perches.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/8] dynamic debug - core infrastructure
Message-ID: <20080618160812.GB9453@kroah.com>
References: <20080613190039.GC8813@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613190039.GC8813@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 03:00:39PM -0400, Jason Baron wrote:
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -595,6 +595,22 @@ extern const char *dev_driver_string(struct device *dev);
>  #ifdef DEBUG
>  #define dev_dbg(dev, format, arg...)		\
>  	dev_printk(KERN_DEBUG , dev , format , ## arg)
> +#elif defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
> +#define dev_dbg(dev, format, ...) do {				    	     \
> +	static char mod_name[]						     \
> +	__attribute__((section("__verbose_strings")))			     \
> +	 = KBUILD_MODNAME;						     \
> +	static struct mod_debug foobar					     \
> +	__used								     \
> +	__attribute__((section("__verbose"), aligned(8))) =		     \
> +	{ mod_name, mod_name, "0", "0", NULL };				     \

Does the compiler merge all of these variables together into one within
the same file?

If not, should we have a new macro, one per file, for this information?

> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -14,6 +14,7 @@
>  #include <linux/compiler.h>
>  #include <linux/bitops.h>
>  #include <linux/log2.h>
> +#include <linux/dynamic_printk.h>
>  #include <asm/byteorder.h>
>  #include <asm/bug.h>
>  
> @@ -288,15 +289,86 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
>  #define pr_info(fmt, arg...) \
>  	printk(KERN_INFO fmt, ##arg)
>  
> -#ifdef DEBUG
> -/* If you are writing a driver, please use dev_dbg instead */

Hm, this comment is still correct, please don't delete it :)

Other than those minor nits, and the fact that your patch has a lot of
trailing whitespace, it's looking very good so far.

thanks,

greg k-h
