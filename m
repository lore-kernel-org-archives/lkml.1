Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZD2JkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZD2JkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZD2JkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:40:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36876 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZD2JkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:40:05 -0400
Date: Wed, 29 Apr 2009 11:39:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stuart Bennett <stuart@freedesktop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 mmiotrace: only register for die notifier when
	tracer active
Message-ID: <20090429093953.GB31185@elte.hu>
References: <1240946271-7083-1-git-send-email-stuart@freedesktop.org> <1240946271-7083-2-git-send-email-stuart@freedesktop.org> <1240946271-7083-3-git-send-email-stuart@freedesktop.org> <1240946271-7083-4-git-send-email-stuart@freedesktop.org> <1240946271-7083-5-git-send-email-stuart@freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240946271-7083-5-git-send-email-stuart@freedesktop.org>
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


* Stuart Bennett <stuart@freedesktop.org> wrote:

> Follow up to afcfe024aebd74b0984a41af9a34e009cf5badaf in Linus' tree
> ("x86: mmiotrace: quieten spurious warning message")
> 
> Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
> Acked-by: Pekka Paalanen <pq@iki.fi>
> ---
>  arch/x86/mm/kmmio.c       |   21 ++++++++++++++++++---
>  arch/x86/mm/mmio-mod.c    |    2 ++
>  include/linux/mmiotrace.h |    2 ++
>  3 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
> index 422f49e..bdbbf0d 100644
> --- a/arch/x86/mm/kmmio.c
> +++ b/arch/x86/mm/kmmio.c
> @@ -311,7 +311,12 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
>  	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
>  
>  	if (!ctx->active) {
> -		pr_debug("kmmio: spurious debug trap on CPU %d.\n",
> +		/*
> +		 * debug traps without an active context are due to either
> +		 * something external causing them (f.e. using a debugger while
> +		 * mmio tracing enabled), or erroneous behaviour
> +		 */
> +		pr_warning("kmmio: unexpected debug trap on CPU %d.\n",
>  							smp_processor_id());
>  		goto out;
>  	}
> @@ -545,11 +550,21 @@ static struct notifier_block nb_die = {
>  	.notifier_call = kmmio_die_notifier
>  };
>  
> -static int __init init_kmmio(void)
> +int kmmio_init(void)
>  {
>  	int i;
>  	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++)
>  		INIT_LIST_HEAD(&kmmio_page_table[i]);
>  	return register_die_notifier(&nb_die);
>  }
> -fs_initcall(init_kmmio); /* should be before device_initcall() */
> +
> +void kmmio_cleanup(void)
> +{
> +	int i;
> +
> +	unregister_die_notifier(&nb_die);
> +	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++)
> +		WARN_ONCE(!list_empty(&kmmio_page_table[i]),
> +			  KERN_ERR "kmmio_page_table not empty at cleanup, "
> +				   "any further tracing will leak memory\n");
> +}

Note, i cleaned this up a bit in the commit i applied - we rather 
let strings become over-long than break them in the middle

	Ingo
