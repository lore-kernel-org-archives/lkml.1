Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYBXWzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYBXWzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 17:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYBXWyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 17:54:55 -0500
Received: from namei.org ([69.55.235.186]:54847 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753818AbYBXWyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 17:54:54 -0500
Date: Mon, 25 Feb 2008 09:53:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Ingo Molnar <mingo@elte.hu>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression [Was: Boot hang with stack protector on x86_64]
In-Reply-To: <20080223073746.GA28310@elte.hu>
Message-ID: <Xine.LNX.4.64.0802250952570.846@us.intercode.com.au>
References: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au>
 <20080222075950.GB2660@uranus.ravnborg.org> <20080222093621.GG327@elte.hu>
 <Xine.LNX.4.64.0802222133150.6937@us.intercode.com.au> <20080222121751.GA17889@elte.hu>
 <Xine.LNX.4.64.0802230000470.14729@us.intercode.com.au> <20080223061856.GA26185@elte.hu>
 <20080223073746.GA28310@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008, Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > could you try the fix below ontop of x86.git#testing, does it solve 
> > your boot hang?
> 
> find below another fix that is somewhat better as it does not affect the 
> native kernel and !PARAVIRT.

This works.

> 
> btw., this also explains why this bug wasnt reported sooner against 
> x86.git#testing: people done normally use PARAVIRT on 64-bit yet.
> (there is no 64-bit host support)
> 
> 	Ingo
> 
> ---------------->
> Subject: x86: stackprotector & PARAVIRT fix
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat Feb 23 07:06:55 CET 2008
> 
> on paravirt enabled 64-bit kernels the paravirt ops do function
> calls themselves - which is bad with the stackprotector - for
> example pda_init() loads 0 into %gs and then does MSR_GS_BASE
> write (which modifies gs.base) - but that MSR write is a function
> call on paravirt, which with stackprotector tries to read the
> stack canary from the PDA ... crashing the bootup.
> 
> the solution was suggested by Arjan van de Ven: to exclude paravirt.c
> from stackprotector, too many lowlevel functionality is in it. It's
> not like we'll have paravirt functions with character arrays on
> their stack anyway...
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/Makefile |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-x86.q/arch/x86/kernel/Makefile
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/Makefile
> +++ linux-x86.q/arch/x86/kernel/Makefile
> @@ -15,6 +15,7 @@ nostackp := $(call cc-option, -fno-stack
>  CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
>  CFLAGS_hpet.o		:= $(nostackp)
>  CFLAGS_tsc_64.o		:= $(nostackp)
> +CFLAGS_paravirt.o	:= $(nostackp)
>  
>  obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
>  obj-y			+= traps_$(BITS).o irq_$(BITS).o
> 

-- 
James Morris
<jmorris@namei.org>
