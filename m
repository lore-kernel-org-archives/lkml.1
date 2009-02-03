Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZBCSdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZBCSdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZBCSdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:33:23 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:34166 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbZBCSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:33:22 -0500
Message-ID: <49888DD3.6000903@oracle.com>
Date: Tue, 03 Feb 2009 10:32:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [tip:x86/asm] x86: document 64-bit and 32-bit function call	convention
 ABI
References: <20090203182256.GA1061@elte.hu>
In-Reply-To: <20090203182256.GA1061@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49888DD4.0063:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> - also clean up the calling.h file a tiny bit
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/include/asm/calling.h |   56 +++++++++++++++++++++++++++++++++++++--
>  1 files changed, 53 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
> index 2bc162e..2d36d42 100644
> --- a/arch/x86/include/asm/calling.h
> +++ b/arch/x86/include/asm/calling.h
> @@ -1,5 +1,55 @@
>  /*
> - * Some macros to handle stack frames in assembly.
> +
> + x86 function call convention, 64-bit:
> + -------------------------------------
> +  arguments           |  callee-saved      | extra caller-saved | return
> + [callee-clobbered]   |                    | [callee-clobbered] |
> + ---------------------------------------------------------------------------
> + rdi rsi rdx rcx r8-9 | rbx rbp [*] r12-15 | r10-11             | rax, rdx [**]
> +
> + ( rsp is obviously invariant across normal function calls. (gcc can 'merge'
> +   functions when it sees tail-call optimization possibilities) rflags is
> +   clobbered. Leftover arguments are passed over the stack frame.)
> +
> + [*]  In the frame-pointers case ebp is fixed to the stack frame.

                                    ebp or rbp ?

> +
> + [**] for struct return values wider than 64 bits the return convention is a
> +      bit more complex: up to 128 bits width we return small structures
> +      straight in rax, rdx. For structures larger than that (3 words or

	What size does "word" mean here?
	and is it rdx:rax (high:low)?  Can it be so written?
	or at least say which of rax, rdx is high (most significant) and
	which is low (least significant).

> +      larger) the caller puts a pointer to an on-stack return struct
> +      [allocated in the caller's stack frame] into the first argument - i.e.
> +      into rdi. All other arguments shift up by one in this case.
> +      Fortunately this case is rare in the kernel.
> +
> +For 32-bit we have the following conventions - kernel is build with

                                                            built

> +-mregparm=3 and -freg-struct-return:
> +
> + x86 function calling convention, 32-bit:
> + ----------------------------------------
> +  arguments         | callee-saved        | extra caller-saved | return
> + [callee-clobbered] |                     | [callee-clobbered] |
> + -------------------------------------------------------------------------
> + eax edx ecx        | ebx edi esi ebp [*] | <none>             | eax, edx [**]
> +
> + ( here too esp is obviously invariant across normal function calls. eflags
> +   is clobbered. Leftover arguments are passed over the stack frame. )
> +
> + [*]  In the frame-pointers case ebp is fixed to the stack frame.
> +
> + [**] We build with -freg-struct-return, which on 32-bit means similar
> +      semantics as on 64-bit: edx can be used for a second return value
> +      (i.e. covering integer and structure sizes up to 64 bits) - after that
> +      it gets more complex and more expensive: 3-word or larger struct returns
> +      get done in the caller's frame and the pointer to the return struct goes
> +      into regparm0, i.e. eax - the other arguments shift up and the
> +      function's register parameters degenerate to regparm=2 in essence.
> +

	Same high:low comments here.

> +*/
> +
> +
> +/*
> + * 64-bit system call stack frame layout defines and helpers,
> + * for assembly code:
>   */
>  
>  #define R15		  0
> @@ -9,7 +59,7 @@
>  #define RBP		 32
>  #define RBX		 40
>  
> -/* arguments: interrupts/non tracing syscalls only save upto here*/
> +/* arguments: interrupts/non tracing syscalls only save upto here: */

                                                           up to

>  #define R11		 48
>  #define R10		 56
>  #define R9		 64

Thanks,
-- 
~Randy
