Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZCTI2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZCTI2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZCTI2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:28:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41634 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853AbZCTI22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:28:28 -0400
Date: Fri, 20 Mar 2009 09:27:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] vmscan: print shrink_slab symbol name on negative
	shrinker objects
Message-ID: <20090320082712.GB31137@elte.hu>
References: <alpine.DEB.2.00.0903191609040.2457@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903191609040.2457@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

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

Please dont open-code lookup_symbol_name() for function pointers - 
we have %pF for such purposes.

Btw., probably all existing print_symbol() uses in mm/*.c should be 
converted to %pF:

mm/memory.c:		print_symbol(KERN_ALERT "vma->vm_ops->fault: %s\n",
mm/memory.c:		print_symbol(KERN_ALERT "vma->vm_file->f_op->mmap: %s\n",
mm/slab.c:		print_symbol("(%s)",
mm/slub.c:			len += sprint_symbol(buf + len, (unsigned long)l->addr);
mm/slub.c:		int n = sprint_symbol(buf, (unsigned long)s->ctor);
mm/vmalloc.c:		sprint_symbol(buff, (unsigned long)v->caller);

[ Except the second slub.c one which should be %pS ]

	Ingo
