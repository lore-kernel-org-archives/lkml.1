Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbYHYSKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbYHYSKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbYHYSJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:09:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562AbYHYSJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:09:57 -0400
Date: Mon, 25 Aug 2008 11:09:36 -0700 (PDT)
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
In-Reply-To: <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com>
 <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Aug 2008, Linus Torvalds wrote:
> 
> Could you make your kernel image available somewhere, and we can take a 
> look at it? Some versions of gcc are total pigs when it comes to stack 
> usage, and your exact configuration matters too.  But yes, module loading 
> is a bad case, for me "sys_init_module()" contains
> 
> 	subq    $392, %rsp      #,
> 
> which is probably mostly because of the insane inlining gcc does (ie it 
> will likely have inlined every single function in that file that is only 
> called once, and then it will make all local variables of all those 
> functions alive over the whole function and allocate stack-space for them 
> ALL AT THE SAME TIME).

I bet this one-liner will probably make your kernel work. It's not a full 
solution, but it will make the module-loading path lose _all_ of the above 
stack slots by just not inlining "load_module()" - the stack slots will 
still be used when the module is _loaded_, but by the time we actually 
callt he ->init function they will have been released since it's not all 
in the same crazy function any more.

I _seriously_ believe that we were better off back when gcc only inlined 
what we told it to inline, and never inlined on its own. The gcc inlining 
logic is pure and utter sh*t in an environment like the kernel where stack 
space is a valuable resource.

Anyway, Alan, even if this solves your particular problem, I'd still like 
to see your kernel image, so that I can hunt for other problems like 
this..

			Linus

---
 kernel/module.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 08864d2..9db1191 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1799,7 +1799,7 @@ static void *module_alloc_update_bounds(unsigned long size)
 
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
-static struct module *load_module(void __user *umod,
+static noinline struct module *load_module(void __user *umod,
 				  unsigned long len,
 				  const char __user *uargs)
 {
