Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZJALUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZJALUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 07:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756379AbZJALUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 07:20:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50704 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370AbZJALUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 07:20:17 -0400
Date: Thu, 1 Oct 2009 13:20:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, ak@suse.de, roland@redhat.com,
       rth@redhat.com, mhiramat@redhat.com
Subject: Re: [PATCH 1/4] jump label - make init_kernel_text() global
Message-ID: <20091001112003.GA2962@elte.hu>
References: <cover.1253831945.git.jbaron@redhat.com> <77d69d0f3c8e1f98a4c2392ea4e4f6c25ed177f4.1253831946.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77d69d0f3c8e1f98a4c2392ea4e4f6c25ed177f4.1253831946.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jason Baron <jbaron@redhat.com> wrote:

> allow usage of init_kernel_text - we need this in jump labeling to 
> avoid attemtpting to patch code that has been freed as in the __init 
> sections

s/attemtpting/attempting

> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  include/linux/kernel.h |    1 +
>  kernel/extable.c       |    2 +-
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index f61039e..9d3419f 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -295,6 +295,7 @@ extern int get_option(char **str, int *pint);
>  extern char *get_options(const char *str, int nints, int *ints);
>  extern unsigned long long memparse(const char *ptr, char **retptr);
>  
> +extern int init_kernel_text(unsigned long addr);
>  extern int core_kernel_text(unsigned long addr);
>  extern int __kernel_text_address(unsigned long addr);
>  extern int kernel_text_address(unsigned long addr);
> diff --git a/kernel/extable.c b/kernel/extable.c
> index 7f8f263..f6893ad 100644
> --- a/kernel/extable.c
> +++ b/kernel/extable.c
> @@ -52,7 +52,7 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
>  	return e;
>  }
>  
> -static inline int init_kernel_text(unsigned long addr)
> +int init_kernel_text(unsigned long addr)
>  {
>  	if (addr >= (unsigned long)_sinittext &&
>  	    addr <= (unsigned long)_einittext)

i'm confused. Later on jump_label_update() does:

+                       if (!(system_state == SYSTEM_RUNNING &&
+                                       (init_kernel_text(iter->code))))
+                               jump_label_transform(iter, type);

which is:

+                       if (system_state != SYSTEM_RUNNING ||
+                                       !init_kernel_text(iter->code)))
+                               jump_label_transform(iter, type);

What is the logic behind that? System going into SYSTEM_RUNNING does not 
coincide with free_initmem() precisely.

Also, do we ever want to patch init-text tracepoints? I think we want to 
stay away from them as much as possible.

It appears to me that what we want here is a straight:

                       if (kernel_text(iter->code))
                               jump_label_transform(iter, type);

Also, maybe a WARN_ONCE(!kernel_text()) - we should never even attempt 
to transform non-patchable code. If yes then we want to know about that 
in a noisy way and not skip it silently.

	Ingo
