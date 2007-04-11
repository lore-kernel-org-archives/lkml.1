Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXDKQkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXDKQkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXDKQkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:40:02 -0400
Received: from are.twiddle.net ([64.81.246.98]:50865 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbXDKQkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:40:00 -0400
Date: Wed, 11 Apr 2007 08:55:01 -0700
From: Richard Henderson <rth@twiddle.net>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] ALPHA: build fixes - force architecture, eliminate wastage
Message-ID: <20070411155501.GA12573@twiddle.net>
Mail-Followup-To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
References: <20070411122841.C17547@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411122841.C17547@jurassic.park.msu.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 12:28:41PM +0400, Ivan Kokshaysky wrote:
> -		__asm__("ctlz %1, %0" : "=r"(vector) : "r"(mask));
> +		__asm__(".arch ev67; ctlz %1, %0" : "=r"(vector) : "r"(mask));

This should use __kernel_ctlz, and we should use 

#ifdef __alpha_cix__
# if __GNUC__ == 3 && __GNUC_MINOR__ >= 4 || __GNUC__ > 3
#  define __kernel_cttz(x)		__builtin_ctzl(x)
# else
#  define __kernel_cttz(x)                                              \
  ({ unsigned long __kir;                                               \
     __asm__("cttz %1,%0" : "=r"(__kir) : "r"(x));                      \
     __kir; })
# endif
#else
# define __kernel_cttz(x)                                               \
  ({ unsigned long __kir;                                               \
     __asm__(".arch ev67; cttz %1,%0" : "=r"(__kir) : "r"(x));          \
     __kir; })
#endif

etc, for the other __kernel_ctlz and __kernel_ctpop definitions.

> -asm(".section .got,\"aws\",@progbits; .align 3; .previous");
> +asm(".section .got,\"aw\",@progbits; .align 3; .previous");

Are you absolutely certain that the got gets put into the correct
spot when you do this?  It really ought to have the SHF_ALPHA_GPREL
bit set, so that the ARCH_SHF_SMALL checks in kernel/module.c do
the correct thing.

I NAK this chunk without further proof.  Anyway, the *proper* fix
is in the assembler; it shouldn't be complaining.


r~
