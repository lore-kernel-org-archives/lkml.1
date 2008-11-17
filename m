Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbYKQIZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbYKQIZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYKQIZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:25:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33266 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYKQIZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:25:33 -0500
Date: Mon, 17 Nov 2008 09:25:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc5: unused variable in pagetable_init
Message-ID: <20081117082526.GA28786@elte.hu>
References: <200811170653.16528.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200811170653.16528.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrey Borzenkov <arvidjaar@mail.ru> wrote:

>   CC      arch/x86/mm/init_32.o
> /home/bor/src/linux-git/arch/x86/mm/init_32.c: In function ‘pagetable_init’:
> /home/bor/src/linux-git/arch/x86/mm/init_32.c:515: warning: unused variable ‘pgd_base’
> 
> Well, pagetable_init is noop unless HIGHMEM is defined so it could 
> be as simple as that.
> 
> Or is something else expected to go into pagetable_init for more 
> general case?
> 
> --- arch/x86/mm/init_32.c       2008-11-10 06:19:14.000000000 +0300
> +++ /tmp/init_32.c      2008-11-17 06:52:21.383685722 +0300
> @@ -435,9 +435,17 @@ static void __init set_highmem_pages_ini
>  }
>  #endif /* !CONFIG_NUMA */
> 
> +static void __init pagetable_init(void)
> +{
> +       pgd_t *pgd_base = swapper_pg_dir;
> +
> +       permanent_kmaps_init(pgd_base);
> +}
> +
>  #else
>  # define permanent_kmaps_init(pgd_base)                do { } while (0)
>  # define set_highmem_pages_init()      do { } while (0)
> +# define pagetable_init()      do { } while (0)
>  #endif /* CONFIG_HIGHMEM */
> 
>  void __init native_pagetable_setup_start(pgd_t *base)
> @@ -510,13 +518,6 @@ static void __init early_ioremap_page_ta
>         early_ioremap_reset();
>  }
> 
> -static void __init pagetable_init(void)
> -{
> -       pgd_t *pgd_base = swapper_pg_dir;
> -
> -       permanent_kmaps_init(pgd_base);
> -}
> -
>  #ifdef CONFIG_ACPI_SLEEP

The better fix would be to convert permanent_kmaps_init() from a macro 
to an (empty) inline. That way CPP does not eat away the code and GCC 
will known that the variable is indeed used.

	Ingo
