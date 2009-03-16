Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbZCPXuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbZCPXuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 19:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZCPXuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 19:50:00 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:40429 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727AbZCPXuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 19:50:00 -0400
Subject: Re: VMI broken on tip/master...
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49BED8A2.9010603@goop.org>
References: <1236966968.14680.15.camel@alok-dev1>
	 <49BC4196.3070204@goop.org> <1237243324.5906.13.camel@alok-dev1>
	 <49BED8A2.9010603@goop.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 16 Mar 2009 16:49:58 -0700
Message-Id: <1237247398.5906.20.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 15:54 -0700, Jeremy Fitzhardinge wrote:
> > I don't understand why is this not printing anything at this early fault
> > though, the system just enters the hlt_loop and stays there.
> >   
> 
> It should drop something onto the vga console (and/or serial port?).
Surprisingly it doesn't, but anyways...

> 
> >> Doing what?  It's a bit hard to tell what you're actually seeing.
> >>     
> > I did some more debugging and I think i know what the problem is 
> > The objdump for trace_clock_local looks like this
> >
> > c1070c24 <trace_clock_local>:
> > c1070c24:       55                      push   %ebp
> > c1070c25:       89 e5                   mov    %esp,%ebp
> > c1070c27:       53                      push   %ebx
> > c1070c28:       83 ec 08                sub    $0x8,%esp
> > c1070c2b:       ff 15 5c 87 3d c1       call   *0xc13d875c
> > c1070c31:       ba 64 87 3d c1          mov    $0xc13d8764,%edx
> > c1070c36:       89 45 f4                mov    %eax,0xfffffff4(%ebp)
> > c1070c39:       ff 12                   call   *(%edx)		<<=====*
> > c1070c3b:       e8 cd 68 f9 ff          call   c100750d <sched_clock>
> > c1070c40:       89 c1                   mov    %eax,%ecx
> > c1070c42:       8b 45 f4                mov    0xfffffff4(%ebp),%eax
> > c1070c45:       ff 15 60 87 3d c1       call   *0xc13d8760
> >
> > Notice instruction on c1070c39 we have "call *(edx)",
> > edx was just loaded with the address for the paravirt call.
> > when we try to replace that to a call to vmi specific function, maybe we
> > hit a BUG_ON(len < 5) in vmi's patch_internal code, because now the
> > instruction length is less than 5.
> >
> > Is there is a way to get GCC to not do such fancy tricks, and instead do
> > a direct "call 0xc13d8764"  ?
> Well, indirect "call *0xc13d875c".   But yes, its hard to see what gcc 
> thinks its getting out of doing the indirect call via %edx.  We 
> definitely don't want gcc doing such things, even if it does make sense 
> (such as calling an op multiple times, and CSEing the pointer); given 
> that we generate all this in asm anyway, we could force it.  Does this help?

Yes, This does the trick 
The disassembly for trace_clock_local is now correct, and this boots
too.

c107105c <trace_clock_local>:
c107105c:       55                      push   %ebp
c107105d:       89 e5                   mov    %esp,%ebp
c107105f:       53                      push   %ebx
c1071060:       83 ec 08                sub    $0x8,%esp
c1071063:       ff 15 7c 07 3e c1       call   *0xc13e077c
c1071069:       89 45 f4                mov    %eax,0xfffffff4(%ebp)
c107106c:       ff 15 84 07 3e c1       call   *0xc13e0784
c1071072:       e8 36 65 f9 ff          call   c10075ad <sched_clock>
c1071077:       89 c1                   mov    %eax,%ecx
c1071079:       8b 45 f4                mov    0xfffffff4(%ebp),%eax
c107107c:       ff 15 80 07 3e c1       call   *0xc13e0780

Thanks,
Alok

> 
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index d4fec1f..62dfc51 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -395,7 +395,7 @@ extern struct pv_lock_ops pv_lock_ops;
>  
>  #define paravirt_type(op)				\
>  	[paravirt_typenum] "i" (PARAVIRT_PATCH(op)),	\
> -	[paravirt_opptr] "m" (op)
> +	[paravirt_opptr] "i" (&(op))
>  #define paravirt_clobber(clobber)		\
>  	[paravirt_clobber] "i" (clobber)
>  
> @@ -449,7 +449,7 @@ int paravirt_disable_iospace(void);
>   * offset into the paravirt_patch_template structure, and can therefore be
>   * freely converted back into a structure offset.
>   */
> -#define PARAVIRT_CALL	"call *%[paravirt_opptr];"
> +#define PARAVIRT_CALL	"call *%c[paravirt_opptr];"
>  
>  /*
>   * These macros are intended to wrap calls through one of the paravirt
> 
> 



