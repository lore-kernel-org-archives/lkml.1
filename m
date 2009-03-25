Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbZCYLxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbZCYLxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759051AbZCYLw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:52:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760818AbZCYLwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:52:55 -0400
Date: Wed, 25 Mar 2009 12:52:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: allow and require one-page mmap on
	counting counters
Message-ID: <20090325115240.GA11571@elte.hu>
References: <18889.59409.260586.87939@cargo.ozlabs.ibm.com> <1237981712.7972.812.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237981712.7972.812.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-03-25 at 19:15 +1100, Paul Mackerras wrote:
> > Impact: bug fix
> > 
> > Currently the mmap code requires that the length of the mmap be at least
> > two pages.  That is fine for sampling counters, but for counting
> > counters the second and subsequent pages are just wasted, since counting
> > counters don't generate events.
> > 
> > This changes the code to require that the mmap be one page in length
> > for counting counters, and applies the existing check to sampling
> > counters.
> 
> Does the below work for you Paul?
> 
> ---
> Subject: perf_counter: allow one-page mmap on counters
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Mar 25 12:44:16 CET 2009
> 
> A brainfart stopped single page mmap()s working. The rest of the code
> should be perfectly fine with not having any data pages.
> 
> Reported-by: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/perf_counter.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/perf_counter.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_counter.c
> +++ linux-2.6/kernel/perf_counter.c
> @@ -1369,7 +1369,11 @@ static int perf_mmap(struct file *file, 
>  	vma_size = vma->vm_end - vma->vm_start;
>  	nr_pages = (vma_size / PAGE_SIZE) - 1;
>  
> -	if (nr_pages == 0 || !is_power_of_2(nr_pages))
> +	/*
> +	 * If we have data pages ensure they're a power-of-two number, so we
> +	 * can do bitmasks instead of modulo.
> +	 */
> +	if (nr_pages != 0 && !is_power_of_2(nr_pages))
>  		return -EINVAL;

Yeah - this is cleaner.

	Ingo
