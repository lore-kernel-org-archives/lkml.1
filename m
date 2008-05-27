Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbYE0Vml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbYE0Vml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759919AbYE0Vmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:42:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760099AbYE0VmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:42:25 -0400
Date: Tue, 27 May 2008 14:40:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: joe@perches.com, greg@kroah.com, nick@nick-andrew.net,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] debug printk infrastructure -implement level
 controls
Message-Id: <20080527144016.bd2d1f90.akpm@linux-foundation.org>
In-Reply-To: <20080522211551.GC28070@redhat.com>
References: <20080522211551.GC28070@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 17:15:51 -0400
Jason Baron <jbaron@redhat.com> wrote:

> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  include/linux/device.h         |   16 ++++++++
>  include/linux/dynamic_printk.h |    9 +++++
>  lib/dynamic_printk.c           |   78 +++++++++++++++++++++++++++++++++++++--
>  3 files changed, 99 insertions(+), 4 deletions(-)

no changelog...

> diff --git a/include/linux/device.h b/include/linux/device.h
> index 8f3ca1f..b1aae4d 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -616,6 +616,22 @@ extern const char *dev_driver_string(struct device *dev);
>  	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })
>  #endif
>  
> +#ifdef CONFIG_PRINTK_DEBUG
> +#define register_dev_dbg_handler(parent, type, max, init) \
> +	__register_dev_dbg_handler(KBUILD_MODNAME, parent, type, max, init)
> +#define dev_dbg_level(value, dev, format, ...) \
> +	__dev_dbg_level(KBUILD_MODNAME, value, dev, format, ##__VA_ARGS__)
> +#define dev_dbg_enabled(value) \
> +	__dev_dbg_enabled(KBUILD_MODNAME, value)
> +#else
> +#define register_dev_dbg_handler(parent, type, max, init) \
> +	({ if (0) __register_dev_dbg_handler(KBUILD_MODNAME, parent, type, max, init); 0; })
> +#define dev_dbg_level(value, dev, format, ...) \
> +	({ if (0) __dev_dbg_level(KBUILD_MODNAME, value, dev, format, ##__VA_ARGS__); 0; })
> +#define dev_dbg_enabled(value) \
> +	({ if (0) __dev_dbg_enabled(KBUILD_MODNAME, value); 0; })
> +#endif

A major interface which we expect/hope thousands of developers will
use.  It will need documentation eventually, and we might as well add
that now, to make review easier and more effective.

>  #ifdef VERBOSE_DEBUG
>  #define dev_vdbg	dev_dbg
>  #else
> diff --git a/include/linux/dynamic_printk.h b/include/linux/dynamic_printk.h
> index b1afef3..bb366b4 100644
> --- a/include/linux/dynamic_printk.h
> +++ b/include/linux/dynamic_printk.h
> @@ -7,6 +7,10 @@
>  
>  #define DYNAMIC_HASH_BITS 5
>  #define FILE_TABLE_SIZE (1 << DYNAMIC_HASH_BITS)
> +#define TYPE_LEVEL 1
> +#define TYPE_FLAG 2
> +
> +struct device;
>  
>  struct mod_debug {
>  	char *modname;
>
> ...
>
> @@ -230,6 +292,14 @@ static ssize_t pr_debug_write(struct file *file, const char __user *buf,
>  			}
>  			err = 0;
>  		}
> +	} else if (!strncmp("set level=", buffer, 10)) {
> +		s = buffer + 10;
> +		level = strsep(&s, " ");
> +		s = strstrip(s);
> +		if (elem = find_debug_file(s)) {
> +			elem->level = simple_strtol(level, NULL, 10);
> +			err = 0;
> +		}

The first thing we zoom in on with any patch is "what is the
user<->kernel interface".  Once that is settled, understood and agreed
on then we can get into the implementation details.  Please do prepare
a writeup of that.  It could go in [patch 0/n] or into a Documentation/
file.

>  	}
>  	if (!err)
>  		err = length;
> @@ -268,8 +338,8 @@ static int pr_debug_seq_show(struct seq_file *s, void *v)
>  	rcu_read_lock();
>  	head = &module_table[i];
>  	hlist_for_each_entry_rcu(element, node, head, hlist)
> -		seq_printf(s, "%s %d %d\n", element->name, element->enable,
> -				 element->num_uses);
> +		seq_printf(s, "%s %d %d %d\n", element->name, element->enable,
> +				 element->level, element->num_uses);
>  	rcu_read_unlock();
>  	return 0;
>  }
> -- 
> 1.5.4.5
