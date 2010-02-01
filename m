Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0BAWzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:55:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39568 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab0BAWzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:55:20 -0500
Message-ID: <4B675BBB.20303@zytor.com>
Date: Mon, 01 Feb 2010 14:54:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: enlightenment for ticket spinlocks - remove
  NOPs from unlock path
References: <4B62A40B020000780002CA99@vpn.id2.novell.com>
In-Reply-To: <4B62A40B020000780002CA99@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2010 12:02 AM, Jan Beulich wrote:
> Under the assumption that the nop-s added by the base ticket spinlock
> enlightenment patch might be considered undesirable (or worse), here
> is an optional patch to eliminate these nop-s again. This is done
> through extending the memory operands of the inc instructions used for
> unlocking ticket locks to the necessary size, using assembler and
> linker features.

> --- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/include/asm/alternative-asm.h
> +++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/alternative-asm.h
> @@ -1,3 +1,7 @@
> +#if 0 /* Hide this from compiler. */
> +	.if 0 # Hide assembly source stuff when assembling compiler output.
> +#endif
> +
>  #ifdef __ASSEMBLY__
>  
>  #include <asm/asm.h>
> @@ -16,3 +20,58 @@
>  #endif
>  
>  #endif  /*  __ASSEMBLY__  */
> +
> +#if 0 /* Hide this from compiler. */
> +	.else # Code to be used in compiler output:
> +
> +	.weak _$.zero
> +
> +	.macro unary opc arg1 arg2 arg3
> +	 .Lempty=2
> +	 .irpc c,"\arg2"
> +	  .Lempty=3
> +	 .endr
> +	 .irpc c,"\arg3"
> +	  .Lempty=0
> +	 .endr
> +	 .Lsym=1
> +	 .Lnum=0
> +	 .irpc c,"\arg1"
> +	  .irpc m,"(123456789-0"
> +	   .ifeqs "\c","\m"
> +	    .Lsym=0
> +	    .exitm
> +	   .endif
> +	   .Lnum=1
> +	  .endr
> +	  .exitm
> +	 .endr
> +	 .if .Lempty == 2
> +	  .if .Lsym
> +	   \opc \arg1
> +	  .elseif .Lnum
> +	   \opc _$.zero+\arg1
> +	  .else
> +	   \opc _$.zero\arg1
> +	  .endif
> +	 .elseif .Lempty == 3
> +	  .if .Lsym
> +	   \opc \arg1,\arg2
> +	  .elseif .Lnum
> +	   \opc _$.zero+\arg1,\arg2
> +	  .else
> +	   \opc _$.zero\arg1,\arg2
> +	  .endif
> +	 .else
> +	  .if .Lsym
> +	   \opc \arg1,\arg2,\arg3
> +	  .elseif .Lnum
> +	   \opc _$.zero+\arg1,\arg2,\arg3
> +	  .else
> +	   \opc _$.zero\arg1,\arg2,\arg3
> +	  .endif
> +	 .endif
> +	.endm
> +
> +	.endif
> +#endif

Okay, I have absolutely no idea what this macro either *does* or what
it's *supposed to do* nor if it matches... you kind of forgot to
describe that.  The other bit is that this whole handling with .if and
#if is just too ugly to live.  Create two include files at the very minimum.

I'd like to figure out if there isn't a better idea to do what you're
trying to do here, though...
	
	-hpa
