Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbYBSGzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbYBSGzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 01:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYBSGyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 01:54:54 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:1524 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbYBSGy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 01:54:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uaLw3YOlcad5pHJZvplqhSOdj3Ptv2Y4j8Ore5rzA/zc1idwk3lG7WzpqitfGudGiogeM4Gx6XXomwm4GI7Acyn056aw9fcML6bdKoPo65PsiGi2S4D7fcs3EsOwlmeKfLcOriUVZVVoE6BowxepNP5mVtjhdshOtyupjkXqcPw=
Message-ID: <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
Date: Tue, 19 Feb 2008 07:54:24 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Linux 2.6.25-rc2
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080219061107.GA23229@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
	 <20080219061107.GA23229@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 7:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> > On Feb 15, 2008 10:23 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > >
> > > Ok,
> > >  this kernel is a winner.
> >
> > Sadly not for me:
> > [ 5282.056415] ------------[ cut here ]------------
> > [ 5282.059757] kernel BUG at lib/list_debug.c:33!
> > [ 5282.062055] invalid opcode: 0000 [1] SMP
> > [ 5282.062055] CPU 3
>
> hm. Your crashes do seem to span multiple subsystems, but it always
> seems to be around the SLUB code. Could you try the patch below? The
> SLUB code has a new optimization and i'm not 100% sure about it. [the
> hack below switches the SLUB optimization off by disabling the CPU
> feature it relies on.]
>
>         Ingo
>
> ------------->
>  arch/x86/Kconfig |    4 ----
>  1 file changed, 4 deletions(-)
>
> Index: linux/arch/x86/Kconfig
> ===================================================================
> --- linux.orig/arch/x86/Kconfig
> +++ linux/arch/x86/Kconfig
> @@ -59,10 +59,6 @@ config HAVE_LATENCYTOP_SUPPORT
>  config SEMAPHORE_SLEEPERS
>         def_bool y
>
> -config FAST_CMPXCHG_LOCAL
> -       bool
> -       default y
> -
>  config MMU
>         def_bool y
>

$ grep FAST_CMPXCHG_LOCAL */.config
linux-2.6.24-rc2-mm1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
linux-2.6.24-rc3-mm1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
linux-2.6.24-rc3-mm2/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
linux-2.6.24-rc6-mm1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
linux-2.6.24-rc8-mm1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
linux-2.6.25-rc1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
linux-2.6.25-rc2-mm1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
linux-2.6.25-rc2/.config:CONFIG_FAST_CMPXCHG_LOCAL=y

-rc2-mm1 still worked for me.

Did you mean the new SLUB_FASTPATH?
$ grep "define SLUB_FASTPATH" */mm/slub.c
linux-2.6.25-rc1/mm/slub.c:#define SLUB_FASTPATH
linux-2.6.25-rc2-mm1/mm/slub.c:#define SLUB_FASTPATH
linux-2.6.25-rc2/mm/slub.c:#define SLUB_FASTPATH

The 2.6.24-rc3+ mm-kernels did crash for me, but don't seem to contain this...

On the other hand:
>From the crash in 2.6.25-rc2-mm1:
[59987.116182] RIP  [<ffffffff8029f83d>] kmem_cache_alloc_node+0x6d/0xa0

(gdb) list *0xffffffff8029f83d
0xffffffff8029f83d is in kmem_cache_alloc_node (mm/slub.c:1646).
1641                    if (unlikely(is_end(object) || !node_match(c, node))) {
1642                            object = __slab_alloc(s, gfpflags,
node, addr, c);
1643                            break;
1644                    }
1645                    stat(c, ALLOC_FASTPATH);
1646            } while (cmpxchg_local(&c->freelist, object, object[c->offset])
1647
 != object);
1648    #else
1649            unsigned long flags;
1650

That code is part for SLUB_FASTPATH.

I'm willing to test the patch, but don't know how fast I can find the
time to do it, so my answer if your patch helps might be delayed until
the weekend.

Torsten
