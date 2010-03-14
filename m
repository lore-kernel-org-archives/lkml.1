Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0CNRd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 13:33:27 -0400
Received: from bar.sig21.net ([80.81.252.164]:43653 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab0CNRdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 13:33:25 -0400
Date: Sun, 14 Mar 2010 18:34:59 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@ozlabs.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [Lguest] 2.6.33 guest crash (was: Re: 2.6.32-rc5 guest crash)
Message-ID: <20100314173459.GA919@sig21.net>
References: <20091025175521.GA13300@sig21.net>
 <200910261426.05769.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910261426.05769.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.790,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 02:26:04PM +1030, Rusty Russell wrote:
> On Mon, 26 Oct 2009 04:25:21 am Johannes Stezenbach wrote:
> > 
> > I'm using linux-2.6.32-rc5-81-g964fe08 as both host and guest,
> > and the guest crashes on boot:
> > 
> > Calibrating delay loop... 
> > general protection fault: 0000 [#1] PREEMPT SMP 
> > last sysfs file: 
> > Modules linked in:
> > 
> > Pid: 0, comm: swapper Not tainted (2.6.32-rc5 #1) 
> > EIP: 0061:[<c11f915d>] EFLAGS: 00010046 CPU: 0
> > EIP is at cmpxchg8b_emu+0x1/0x12

I recently installed 2.6.33 and now the error which was
fixed in 2.6.32 is back since the fix got reverted in
db677ffa5f5a4f15b9dad4d132b3477b80766d82

What now?

Am I correct to assume that I can avoid the issue
by switching to a 64bit kernel (on host + guest)?


> OK, it's the non-paravirt "cli" we're breaking on (the pushfl is bad too).
> 
> This is because alternatives haven't been subbed yet.  The Right Thing is to
> make this asm code paravirt aware.  The Easy Thing is to fix this code to
> only get included when we're actually compiling for a 386 or 486 (this was
> introduced with the original pentium AFAICT).
> 
> How's this Ingo, Arjan?
> 
> Subject: x86: sidestep lguest problem by only building cmpxchg8b_emu for pre-Pentium
> 
> Arjen's 79e1dd05d1a22 "x86: Provide an alternative() based cmpxchg64()" broke
> lguest, even on systems which have cmpxchg8b support.  The emulation code
> gets used until alternatives get run, but it contains native instructions,
> not their paravirt alternatives.
> 
> The simplest fix is to turn this code off except for 386 and 486 builds.
> 
> Reported-by: Johannes Stezenbach <js@sig21.net>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> --- a/arch/x86/Kconfig.cpu
> +++ b/arch/x86/Kconfig.cpu
> @@ -400,7 +400,7 @@ config X86_TSC
>  
>  config X86_CMPXCHG64
>  	def_bool y
> -	depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
> +	depends on !M386 && !M486
>  
>  # this should be set for all -march=.. options where the compiler
>  # generates cmov.
> 
> 
> 
> 

Thanks
Johannes
