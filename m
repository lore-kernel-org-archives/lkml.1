Return-Path: <linux-kernel-owner+w=401wt.eu-S936763AbYEUUiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936763AbYEUUiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937436AbYEUUhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:37:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33195 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937431AbYEUUhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:37:39 -0400
Date: Wed, 21 May 2008 13:35:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jason Baron <jbaron@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] dynamic_printk: core
Message-Id: <20080521133519.0a262954.randy.dunlap@oracle.com>
In-Reply-To: <20080429184143.GB8717@redhat.com>
References: <20080429184143.GB8717@redhat.com>
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

On Tue, 29 Apr 2008 14:41:43 -0400 Jason Baron wrote:

> 
> Add the ability to dynamically enable/disable pr_debug()/dev_dbg() in the
> kernel. Yes, these calls could be converted to printk(KERN_DEBUG), but there
> are enough to cause overhead. Additionally, the logs become difficult to read.
> Here, one can turn these messages on/off per module via:
> 
> echo "add module_name" >  <debugfs>/dynamic_printk/modules
> echo "remove module_name" >  <debugfs>/dynamic_printk/modules
> 
> There is also a special 'all' value that turns on all the debugging messages.
> ---

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 623ef24..63e5229 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -632,6 +632,46 @@ config FIREWIRE_OHCI_REMOTE_DMA
>  
>  	  If unsure, say N.
>  
> +config DYNAMIC_PRINTK
> +	bool "Enable dynamic printk() call support"
> +	default n
> +	depends on PRINTK

and	depends on DEBUG_FS ??

We shouldn't advertise this option unless the kernel can actually
enable those pr_debug/dev_dbg calls...


> +	help
> +	  
> +	  Allows pr_debug() and dev_dbg() calls to be dynamically enabled based
> +	  upon their source module. Traditionally, these calls are only
> +	  enabled if one set #define DEBUG and recompiled the kernel. This
> +	  option obviates time consuming re-compiles.
> +
> +	  The impact of this compile option is a larger kerenl text size ~1%.
> +	  However, if CONFIG_IMMEDIATE is set, the run-time impact is 
> +	  negligible. Without CONFIG_IMMEDIATE set, a global variable is
> +	  referenced for each pr_debug() and dev_dbg() calls.
> +
> +	  Usage:
> +
> +	  The printing of pr_debug() and dev_dbg() is controlled by the
> +	  debugfs file, dynamic_printk/modules. This file contains a list of
> +	  the active modules. To add and remove modules:
> +
> +		echo "add <module_name>" > dynamic_printk/modules
> +		echo "remove <module_name>" > dynamic_printk/modules
> +
> +	  For example:
> +
> +		 echo "add kobject" > dynamic_printk/modules
> +		 /sbin/modprobe <module>
> +	
> +	  This will cause kobject debug messages to spew out. Also, a special 
> +	  "all" value will print all pr_debug() and dev_dbg() calls. I.e.:
> +
> +		echo "add all" > dynamic_printk/modules
> +		echo "remove all" > dynamic_printk/modules
> +
> +	  Finally, passing "dynamic_printk" at the command line enables all
> +	  pr_debug() and dev_dbg() call to come out (same as "all"). This mode
> +	  can be disabled via a "remove all".
> +	
>  source "samples/Kconfig"
>  
>  source "lib/Kconfig.kgdb"


---
~Randy
