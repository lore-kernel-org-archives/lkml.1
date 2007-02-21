Return-Path: <linux-kernel-owner+w=401wt.eu-S1751351AbXBUXmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbXBUXmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXBUXmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:42:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57836 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbXBUXmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:42:06 -0500
Date: Wed, 21 Feb 2007 15:41:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Petr =?ISO-8859-1?Q?Tesa=5F=5F=EDk?= <ptesarik@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] free pages in remove_arg_zero()
Message-Id: <20070221154159.d316d526.akpm@linux-foundation.org>
In-Reply-To: <1171978145.22720.21.camel@golias.tesarici.cz>
References: <1171978145.22720.21.camel@golias.tesarici.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 14:29:04 +0100
Petr Tesa____k <ptesarik@suse.cz> wrote:

> I've found a bug when executing scripts:

You've found more than that.

> When a script is loaded, load_script() replaces argv[0] with the
> name of the interpreter and the filename passed to the exec syscall.
> However, there is no guarantee that the length of the interpreter
> name plus the length of the filename is greater than the length of
> the original argv[0]. If the difference happens to cross a page boundary,
> setup_arg_pages() will call install_arg_page() with an address outside
> the VMA.
> 
> Therefore, remove_arg_zero() must free all pages which would be unused
> after the argument is removed.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> 
> --- linux-sles9.orig/fs/exec.c
> +++ linux-sles9/fs/exec.c
> @@ -1000,6 +1000,8 @@ void remove_arg_zero(struct linux_binprm
>  				continue;
>  			offset = 0;
>  			kunmap_atomic(kaddr, KM_USER0);
> +			__free_page(page);
> +			bprm->page[bprm->p/PAGE_SIZE - 1] = NULL;
>  inside:
>  			page = bprm->page[bprm->p/PAGE_SIZE];
>  			kaddr = kmap_atomic(page, KM_USER0);

I am not surprised that remove_arg_zero() is buggy.  Let us look at the
stupid thing:

void remove_arg_zero(struct linux_binprm *bprm)
{
	if (bprm->argc) {
		unsigned long offset;
		char * kaddr;
		struct page *page;

		offset = bprm->p % PAGE_SIZE;
		goto inside;

		while (bprm->p++, *(kaddr+offset++)) {
			if (offset != PAGE_SIZE)
				continue;
			offset = 0;
			kunmap_atomic(kaddr, KM_USER0);
inside:
			page = bprm->page[bprm->p/PAGE_SIZE];
			kaddr = kmap_atomic(page, KM_USER0);
		}
		kunmap_atomic(kaddr, KM_USER0);
		bprm->argc--;
	}
}

I mean.... what the hell?

As you appear to have managed to work out what the sorry thing is trying to
do, would you have time to simply rip it out and completely rewrite it,
including a nice comment telling the world what this function's function is?

Because what we have there is beyond repairing.

Thanks.
