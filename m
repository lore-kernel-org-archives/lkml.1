Return-Path: <linux-kernel-owner+w=401wt.eu-S932709AbXG3Pgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbXG3Pgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 11:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbXG3Pga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 11:36:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:48644 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755758AbXG3Pg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 11:36:29 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18jeVle1lsjmW5fDysMCWzxpJ4wZxro2+yoOuI/A8
	YaCWnTMMDB1NNN
Date: Mon, 30 Jul 2007 17:37:34 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix msr register allocation
Message-ID: <20070730153734.GA6921@atjola.homenet>
References: <1185809155.4347.20.camel@t60>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1185809155.4347.20.camel@t60>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.07.30 12:25:54 -0300, Glauber de Oliveira Costa wrote:
> Since the value in ret will go through a return statement,
                     ^^^
You mean "err" I guess?

> it does not need to be put in eax register directly. Instead,
> we let the compiler do his job and choose what to do with it,
> potentially getting a better register allocation.
>     
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> 
> diff --git a/include/asm-i386/msr.h b/include/asm-i386/msr.h
> index df21ea0..cc4263c 100644
> --- a/include/asm-i386/msr.h
> +++ b/include/asm-i386/msr.h
> @@ -54,7 +54,7 @@ static inline int native_write_msr_safe(unsigned int msr,
>  		     "   .align 4\n\t"
>  		     "   .long 	2b,3b\n\t"
>  		     ".previous"
> -		     : "=a" (err)
> +		     : "=r" (err)
>  		     : "c" (msr), "0" ((u32)val), "d" ((u32)(val>>32)),
>  		       "i" (-EFAULT));
>  	return err;

Note that the EAX output constraint is re-used in the input section for
(u32)val, i.e. the lower half of the value to be written. And "wrmsr"
needs that in EAX, so you cannot change the output constraint without
touching the input constraint.

Also, I do not see how the compiler could do any better than having the
return value already in EAX, but that doesn't really mean anything ;-)

Björn
