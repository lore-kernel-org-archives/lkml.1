Return-Path: <linux-kernel-owner+w=401wt.eu-S1761689AbZCQA7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761689AbZCQA7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZCQA7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:59:36 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:44998 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbZCQA7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:59:36 -0400
Subject: Re: [PATCH] x86-paravirt: prevent gcc from generating the wrong
	addressing mode
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <49BEEDC2.2070809@goop.org>
References: <49BEEDC2.2070809@goop.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 16 Mar 2009 17:59:34 -0700
Message-Id: <1237251574.5906.24.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jeremy.

Acked-by: Alok N Kataria <akataria@vmware.com>

On Mon, 2009-03-16 at 17:24 -0700, Jeremy Fitzhardinge wrote:
> When we generate a call sequence for calling a paravirtualized
> function, we presume that the generated code is "call *0xXXXXX",
> which is a 6 byte opcode; this is larger than a normal
> direct call, and so we can patch a direct call over it.
> 
> At the moment, however we give gcc enough rope to hang us by
> putting the address in a register and generating a two byte
> indirect-via-register call.  Prevent this by explicitly
> dereferencing the function pointer and passing it into the
> asm as a constant.
> 
> This prevents crashes in VMI, as it cannot handle unpatchable
> callsites.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Alok Kataria <akataria@vmware.com>
> 
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index d4fec1f..6922d16 100644
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

