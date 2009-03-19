Return-Path: <linux-kernel-owner+w=401wt.eu-S1761162AbZCSXiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761162AbZCSXiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZCSXiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:38:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755962AbZCSXiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:38:05 -0400
Date: Thu, 19 Mar 2009 16:33:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] vmscan: print shrink_slab symbol name on negative
 shrinker objects
Message-Id: <20090319163314.527687fc.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0903191609040.2457@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903191609040.2457@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009 16:09:33 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> When a shrinker has a negative number of objects to delete, the symbol
> name of the shrinker should be printed, not shrink_slab.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/vmscan.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -40,6 +40,7 @@
>  #include <linux/memcontrol.h>
>  #include <linux/delayacct.h>
>  #include <linux/sysctl.h>
> +#include <linux/kallsyms.h>
>  
>  #include <asm/tlbflush.h>
>  #include <asm/div64.h>
> @@ -214,8 +215,12 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
>  		do_div(delta, lru_pages + 1);
>  		shrinker->nr += delta;
>  		if (shrinker->nr < 0) {
> -			printk(KERN_ERR "%s: nr=%ld\n",
> -					__func__, shrinker->nr);
> +			char symname[KSYM_NAME_LEN];
> +
> +			if (lookup_symbol_name((unsigned long)shrinker->shrink,
> +					       symname) > 0)
> +				printk(KERN_ERR "shrink_slab: %s nr=%ld\n",
> +				       symname, shrinker->nr);
>  			shrinker->nr = max_pass;
>  		}

Can we use the new printk("%pF", ...) here?
