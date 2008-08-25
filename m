Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbYHYUUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbYHYUUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYHYUTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:19:54 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:48090 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbYHYUTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:19:52 -0400
Message-ID: <48B313E0.1000501@hp.com>
Date: Mon, 25 Aug 2008 16:19:44 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com> <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 25 Aug 2008, Linus Torvalds wrote:
>> Could you make your kernel image available somewhere, and we can take a 
>> look at it? Some versions of gcc are total pigs when it comes to stack 
>> usage, and your exact configuration matters too.  But yes, module loading 
>> is a bad case, for me "sys_init_module()" contains
>>
>> 	subq    $392, %rsp      #,
>>
>> which is probably mostly because of the insane inlining gcc does (ie it 
>> will likely have inlined every single function in that file that is only 
>> called once, and then it will make all local variables of all those 
>> functions alive over the whole function and allocate stack-space for them 
>> ALL AT THE SAME TIME).

Mine has:

Dump of assembler code for function sys_init_module:
0xffffffff802688c0 <sys_init_module+0>:	push   %rbp
0xffffffff802688c1 <sys_init_module+1>:	mov    %rsp,%rbp
0xffffffff802688c4 <sys_init_module+4>:	sub    $0x1c0,%rsp
0xffffffff802688cb <sys_init_module+11>:	mov    %r12,-0x20(%rbp)
0xffffffff802688cf <sys_init_module+15>:	mov    %rdi,%r12

so 448 bytes.

The kernel is up at: http://free.linux.hp.com/~adb/bug.11342/vmlinux (if
you would let me know when you are through with it so I can free up some
space there I'd appreciate it...)

By doing the patch you provided, sys_init_module now looks like:

Dump of assembler code for function sys_init_module:
0xffffffff8026aa20 <sys_init_module+0>:	push   %rbp
0xffffffff8026aa21 <sys_init_module+1>:	mov    %rsp,%rbp
0xffffffff8026aa24 <sys_init_module+4>:	sub    $0x20,%rsp
0xffffffff8026aa28 <sys_init_module+8>:	mov    %r14,0x18(%rsp)
0xffffffff8026aa2d <sys_init_module+13>:	mov    %rdi,%r14


So only 32 bytes. (But of course, load_module() exists, and now has
0x1d0 (464) bytes...)

With the patch you provide, I /was/ able to repeatedly boot OK (latest
tree, and I also ran the patch against the 26.27.rc3-based kernel I was
having problems with initially, and that booted OK as well).

Alan

> 
> I bet this one-liner will probably make your kernel work. It's not a full 
> solution, but it will make the module-loading path lose _all_ of the above 
> stack slots by just not inlining "load_module()" - the stack slots will 
> still be used when the module is _loaded_, but by the time we actually 
> callt he ->init function they will have been released since it's not all 
> in the same crazy function any more.
> 
> I _seriously_ believe that we were better off back when gcc only inlined 
> what we told it to inline, and never inlined on its own. The gcc inlining 
> logic is pure and utter sh*t in an environment like the kernel where stack 
> space is a valuable resource.
> 
> Anyway, Alan, even if this solves your particular problem, I'd still like 
> to see your kernel image, so that I can hunt for other problems like 
> this..
> 
> 			Linus
> 
> ---
>  kernel/module.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 08864d2..9db1191 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1799,7 +1799,7 @@ static void *module_alloc_update_bounds(unsigned long size)
>  
>  /* Allocate and load the module: note that size of section 0 is always
>     zero, and we rely on this for optional sections. */
> -static struct module *load_module(void __user *umod,
> +static noinline struct module *load_module(void __user *umod,
>  				  unsigned long len,
>  				  const char __user *uargs)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

