Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0BABjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 20:39:20 -0500
Received: from ozlabs.org ([203.10.76.45]:33765 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab0BABjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 20:39:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Subject: Re: [PATCH v8] RO/NX protection for loadable kernel modules
Date: Mon, 1 Feb 2010 12:09:13 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Dave Jones <davej@redhat.com>
References: <817ecb6f1001311522q52bf4eebmb748c486dcd5ad35@mail.gmail.com>
In-Reply-To: <817ecb6f1001311522q52bf4eebmb748c486dcd5ad35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002011209.13540.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010 09:52:35 am Siarhei Liakh wrote:
> +/*
> + * Given BASE and SIZE this macro calculates the number of pages the
> + * memory regions occupies
> + */
> +#define NUMBER_OF_PAGES(BASE, SIZE) ((SIZE > 0) ?		\
> +		(PFN_DOWN((unsigned long)BASE + SIZE - 1) -	\
> +			 PFN_DOWN((unsigned long)BASE) + 1)	\
> +		: (0UL))

Needs more brackets around arguments, otherwise someone calling it with
a complex expression will get very upset.

Or just replace with a static inline function?

> +		if ((mod->module_core) && (mod->core_text_size > 0)) {

The core_text_size test should be enough here.

> +			begin_pfn = PFN_DOWN((unsigned long)mod->module_core);
> +			end_pfn = PFN_DOWN((unsigned long)mod->module_core +
> +						mod->core_text_size);
> +			if (end_pfn > begin_pfn)
> +				set_memory_rw(begin_pfn << PAGE_SHIFT,
> +							end_pfn - begin_pfn);

Much of this code might be neater if you created a helper:

	void set_page_attributes(void *start, void *end,
				 void (*set)(unsigned long start, unsigned long num_pages))
	{
		unsigned long begin_pfn = PFN_DOWN((unsigned long)start);
		unsigned long end_pfn = PFN_DOWN((unsigned long)end);
		if (end_pfn > begin_pfn)
			set(begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
	}

But these are minor: patch looks good!

Thanks,
Rusty.
