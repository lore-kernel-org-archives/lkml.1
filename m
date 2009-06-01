Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZFAQj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZFAQj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZFAQjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:39:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38353 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbZFAQjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:39:21 -0400
Date: Mon, 1 Jun 2009 12:39:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Jones <davej@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: fishy code in arch/x86/kernel/tsc.c:time_cpufreq_notifier()
Message-ID: <20090601163914.GA6098@infradead.org>
References: <20090601142104.GA15907@infradead.org> <20090601162955.GA15237@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601162955.GA15237@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 12:29:55PM -0400, Dave Jones wrote:
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index d57de05..78c54ea 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -631,17 +631,15 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
>  				void *data)
>  {
>  	struct cpufreq_freqs *freq = data;
> -	unsigned long *lpj, dummy;
> +	unsigned long *lpj;
>  
>  	if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
>  		return 0;
>  
> -	lpj = &dummy;
> -	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> +	lpj = &boot_cpu_data.loops_per_jiffy;
>  #ifdef CONFIG_SMP
> +	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
>  		lpj = &cpu_data(freq->cpu).loops_per_jiffy;
> -#else
> -	lpj = &boot_cpu_data.loops_per_jiffy;
>  #endif

This makes the code look a lot more sane and should fix the potential
issue.

