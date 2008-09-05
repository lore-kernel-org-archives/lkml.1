Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYIERp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYIERp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYIERpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:45:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56817 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbYIERpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:45:18 -0400
Date: Fri, 5 Sep 2008 19:44:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gary Hade <garyhade@us.ibm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Message-ID: <20080905174449.GC27395@elte.hu>
References: <20080905172132.GA11692@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905172132.GA11692@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gary Hade <garyhade@us.ibm.com> wrote:

> Add memory hotremove config option to x86_64
> 
> Memory hotremove functionality can currently be configured into the 
> ia64, powerpc, and s390 kernels.  This patch makes it possible to 
> configure the memory hotremove functionality into the x86_64 kernel as 
> well.

hm, why is it for 64-bit only?

> +++ linux-2.6.27-rc5/arch/x86/Kconfig	2008-09-03 13:34:55.000000000 -0700
> @@ -1384,6 +1384,9 @@
>  	def_bool y
>  	depends on X86_64 || (X86_32 && HIGHMEM)
> 
> +config ARCH_ENABLE_MEMORY_HOTREMOVE
> +	def_bool y

so this will break the build on 32-bit, if CONFIG_MEMORY_HOTREMOVE=y? 
mm/memory_hotplug.c assumes that remove_memory() is provided by the 
architecture.

> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +int remove_memory(u64 start, u64 size)
> +{
> +	unsigned long start_pfn, end_pfn;
> +	unsigned long timeout = 120 * HZ;
> +	int ret;
> +	start_pfn = start >> PAGE_SHIFT;
> +	end_pfn = start_pfn + (size >> PAGE_SHIFT);
> +	ret = offline_pages(start_pfn, end_pfn, timeout);
> +	if (ret)
> +		goto out;
> +	/* Arch-specific calls go here */
> +out:
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(remove_memory);
> +#endif /* CONFIG_MEMORY_HOTREMOVE */

hm, nothing appears to be arch-specific about this trivial wrapper 
around offline_pages().

Shouldnt this be moved to the CONFIG_MEMORY_HOTREMOVE portion of 
mm/memory_hotplug.c instead, as a weak function? That way architectures 
only have to enable ARCH_ENABLE_MEMORY_HOTREMOVE - and architectures 
with different/special needs can override it.

	Ingo
