Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZBSTAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZBSTAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZBSS7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:59:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37528 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207AbZBSS7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:59:51 -0500
Date: Thu, 19 Feb 2009 19:59:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove unneeded endless loop in BUG()
Message-ID: <20090219185935.GA21820@elte.hu>
References: <1235068713.15053.99.camel@nathan.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235068713.15053.99.camel@nathan.suse.cz>
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


* Petr Tesarik <ptesarik@suse.cz> wrote:

> Since __builtin_trap() will always generate an illegal 
> instruction, we can replace the explicit asm("ud2") with it.
> 
> This way gcc will understand that the function never returns, 
> plus it won't emit any extra instructions.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

> +#define DO_BUG()						\
> +do {								\
> +	__builtin_trap();					\
> +	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
> +	panic("BUG!");						\
> +} while(0)
> +
>  #ifdef CONFIG_DEBUG_BUGVERBOSE
>  
>  #ifdef CONFIG_X86_32
> @@ -14,7 +21,7 @@
>  
>  #define BUG()							\
>  do {								\
> -	asm volatile("1:\tud2\n"				\
> +	asm volatile("1:\n"					\
>  		     ".pushsection __bug_table,\"a\"\n"		\
>  		     __BUG_C0					\
>  		     "\t.word %c1, 0\n"				\
> @@ -22,15 +29,11 @@ do {								\
>  		     ".popsection"				\
>  		     : : "i" (__FILE__), "i" (__LINE__),	\
>  		     "i" (sizeof(struct bug_entry)));		\
> -	for (;;) ;						\
> +	DO_BUG();					\

the problem is that the DO_BUG() will generate the u2d 
instruction into a random place where GCC puts it. It certainly 
wont be in the place where the __bug_table logic above expects 
it.

The result will be cryptic crashes instead of a clean BUG 
message assert.

	Ingo
