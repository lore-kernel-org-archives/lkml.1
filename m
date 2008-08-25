Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYHYUn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYHYUn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYHYUnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:43:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920AbYHYUnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:43:16 -0400
Date: Mon, 25 Aug 2008 13:43:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <48B313E0.1000501@hp.com>
Message-ID: <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com>
 <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org> <48B313E0.1000501@hp.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 25 Aug 2008, Alan D. Brunelle wrote:
> 
> Mine has:
> 
> Dump of assembler code for function sys_init_module:
> 0xffffffff802688c4 <sys_init_module+4>:	sub    $0x1c0,%rsp
> 
> so 448 bytes.

Yeah, your build seems to have consistently bigger stack usage, and that 
may be due to some config option, but most likely it's a compiler version 
issue.

But I think part of the reason is that you have frame pointers enabled: 
that makes the stack frames bigger not only because of the frame pointer 
save/restore, but also because you have more register pressure and thus 
spills.

> The kernel is up at: http://free.linux.hp.com/~adb/bug.11342/vmlinux (if
> you would let me know when you are through with it so I can free up some
> space there I'd appreciate it...)

I'm downloading it now, I'll probably be done by the time you get this 
email.

[ Update. Done. You can remove it ]

> By doing the patch you provided, sys_init_module now looks like:
> 
> Dump of assembler code for function sys_init_module:
> 0xffffffff8026aa24 <sys_init_module+4>:	sub    $0x20,%rsp
> 
> So only 32 bytes. (But of course, load_module() exists, and now has
> 0x1d0 (464) bytes...)

Right - the stack usage didn't go away, but the _lifetimes_ changed.

So now load_module() will still use almost 500 bytes of stack, and it will 
call other routines that use stack too, but the lifetime of that stack 
usage is no longer over the whole module loading and initialization part, 
it's purely over just the loading thing.

And since the deep callchain came much later (in the actual ->init 
routines), by the time we do that, we no longer now have the load_module 
stack usage active any more.

> With the patch you provide, I /was/ able to repeatedly boot OK (latest
> tree, and I also ran the patch against the 26.27.rc3-based kernel I was
> having problems with initially, and that booted OK as well).

I had actually already committed it, because it was correct regardless 
(and gcc really is a total ass for doing that inlining to begin with), but 
it's good to have verification that the behaviour you saw was literally 
about this thing.

I'll look at your vmlinux binary to see what else sucks from a stack depth 
standpoint, but one of the problems in this whole thing is that the 
stack usage is obviously both a static thing (with some functions using 
_way_ too much stack!) _and_ a dynamic thing (with the total stack use 
being not about any individual function, but the whole chain).

My patch obviously doesn't change the static stack usage, it just moves it 
around a bit so that it's no longer on that same deep path, so the dynamic 
stack usage is much less.

But I'll look at your vmlinux, see what stands out.

		Linus
