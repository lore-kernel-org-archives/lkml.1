Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZKLTvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZKLTvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 14:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZKLTvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 14:51:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:41249 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZKLTvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 14:51:18 -0500
Message-ID: <4AFC6711.1090405@windriver.com>
Date: Thu, 12 Nov 2009 14:50:41 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>
CC: linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
In-Reply-To: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Nov 2009 19:50:49.0732 (UTC) FILETIME=[6F226440:01CA63D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn wrote:
> Allows annotation of panics to include platform information. It's no big
> deal to collect information, but way helpful when you are collecting
> failure reports from a eventual base of millions of systems deployed in
> other people's homes.
> 
> One of the biggest reasons this is an RFC is that I'm uncomfortable with
> putting the pseudo-file that holds the annotation information in /proc.
> Different layers of the software stack may drop dynamic information, such
> as DHCP-supplied IP addresses, in here as they come up. This means it's
> necessary to be able to append to the end of the annotation, so this looks
> much more like a real file than a sysctl file.  It also has multiple lines,
> which doesn't look a sysctl file. Annotation can be viewed as a debug thing,
> so maybe it belongs in debugfs, but people seem to be doing somewhat different
> things with that filesystem.
> 
> So, suggestions on this issue, and any others are most welcome. If there a
> better way to do this, I'll be happy to use it.
> 
> Signed-off-by: David VomLehn <dvomlehn@cisco.com>
> ---

> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -70,6 +70,7 @@ NORET_TYPE void panic(const char * fmt, ...)
>  	vsnprintf(buf, sizeof(buf), fmt, args);
>  	va_end(args);
>  	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
> +	panic_note_print();
>  #ifdef CONFIG_DEBUG_BUGVERBOSE
>  	dump_stack();
>  #endif


Why hook into panic() directly like this, vs. using the panic
notifier list? If you use that, and then put the data handling
magic that you need into your own kernel module that knows how
to interface with the reporting apps that you have, you can
do the whole thing without having to alter existing code, I think.

Paul.

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 30df586..bade7a1 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1045,6 +1045,14 @@ config DMA_API_DEBUG
>  	  This option causes a performance degredation.  Use only if you want
>  	  to debug device drivers. If unsure, say N.
>  
> +config PANIC_NOTE
> +	bool "Create file for user space data to be reported at panic time"
> +	default n
> +	help
> +	  This creates a pseudo-file, named /proc/panic_note, into which
> +	  user space data can be written. If a panic occurs, the contents
> +	  of the file will be included in the failure report.
> +
>  source "samples/Kconfig"
>  
>  source "lib/Kconfig.kgdb"

