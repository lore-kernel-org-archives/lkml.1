Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYKNSxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYKNSxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYKNSxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:53:40 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:59220 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYKNSxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:53:40 -0500
Date: Fri, 14 Nov 2008 12:53:13 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Hugh Dickins <hugh@veritas.com>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_OPTIMIZE_INLINING fun
In-Reply-To: <Pine.LNX.4.64.0811141804030.29883@blonde.site>
Message-ID: <Pine.LNX.4.64.0811141244060.29394@quilx.com>
References: <Pine.LNX.4.64.0811141804030.29883@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Hugh Dickins wrote:

> --- 2.6.28-rc4/arch/x86/Kconfig.debug	2008-10-24 09:27:47.000000000 +0100
> +++ linux/arch/x86/Kconfig.debug	2008-11-14 16:26:15.000000000 +0000
> @@ -302,6 +302,7 @@ config CPA_DEBUG
>
>  config OPTIMIZE_INLINING
>  	bool "Allow gcc to uninline functions marked 'inline'"
> +	depends on !CC_OPTIMIZE_FOR_SIZE
>  	help
>  	  This option determines if the kernel forces gcc to inline the functions
>  	  developers have marked 'inline'. Doing so takes away freedom from gcc to
>

Maybe add some text explaining that this is some experimental gcc feature?

> You'll be amused to see the asm for this example from mm/swap_state.c
> (I was intending to downgrade these BUG_ONs to VM_BUG_ONs anyway, but
> this example makes that seem highly desirable):
>
> void __delete_from_swap_cache(struct page *page)
> {
> 	BUG_ON(!PageLocked(page));
> 	BUG_ON(!PageSwapCache(page));
> 	BUG_ON(PageWriteback(page));
> 	BUG_ON(PagePrivate(page));

Maybe checking all the conditionals in one BUG_ON is not such a bad idea
after all? 4 useless branches in a hotpath?

> Here's the nice asm 4.2.1 gives with just CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> (different machine, this one a laptop with CONFIG_VMSPLIT_2G_OPT=y):

Optimize for size is what I also have usually on. Inline "optimization"
never worked as far as I can tell so I usually have that off.

> I do wonder whether there's some tweak we could make to page-flags.h
> which would stop this nonsense.  Change the inline functions back to
> macros?  I suspect that by itself wouldn't work, and my quick attempt
> to try it failed abysmally to compile, I've not the cpp foo needed.

I think we want to get away from macros as much as possible.

> A part of the problem may be that test_bit() etc. are designed for
> arrays of unsigned longs, but page->flags is only the one unsigned long:
> maybe gcc loses track of the optimizations available for that case when
> CONFIG_OPTIMIZE_INLINING=y.
>
> Hah, I've just noticed the defaults in arch/x86/configs -
> you might want to change those...

Argh.. Yes.... CONFIG_OPTIMIZE_INLINING must only be enabled if the
compiler can actually create a benefit from optimizing the
inlining. That could be in gcc 4.5 or so I guess.
