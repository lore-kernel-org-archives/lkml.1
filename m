Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZJ1O7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZJ1O7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbZJ1O7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:59:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55499 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbZJ1O7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:59:04 -0400
Subject: Re: [PATCH][RE-SUBMIT] Default setting of the ARM_UNWIND option
From: Catalin Marinas <catalin.marinas@arm.com>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
       akpm@linux-foundation.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4AE82D17.6040900@evidence.eu.com>
References: <4AD73DA4.4050006@evidence.eu.com>
	 <1255620333.10164.77.camel@pc1117.cambridge.arm.com>
	 <4AE55D83.7080608@evidence.eu.com>
	 <1256555452.5282.21.camel@pc1117.cambridge.arm.com>
	 <4AE82D17.6040900@evidence.eu.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 28 Oct 2009 14:58:22 +0000
Message-Id: <1256741902.27121.29.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2009 14:58:23.0560 (UTC) FILETIME=[189AC480:01CA57DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 12:37 +0100, Claudio Scordino wrote:
> Catalin Marinas ha scritto:
> > On Mon, 2009-10-26 at 09:27 +0100, Claudio Scordino wrote:
> >   
> >> My ARM board hanged at the initial "Calibrating delay loop" message.
> >>
> >> After some inspection, I found out the problem to be with commit
> >> adf8b37bafc1495393201a2ae4235846371870d0. This commit introduces stack
> >> unwinding for ARM, and set it enabled by default. However, it seems to
> >> not work with buggy or not-EABI compilers.
> >>
> >> My suggestion is to keep the feature (which is fine) but change the
> >> default setting of the option (see the attached patch).
> >
> > The option still depends on EXPERIMENTAL, so you get ARM_UNWIND on when
> > enabling that.
> >
> > I'm more in favour of a #warning on #error in the unwind.c file based on
> > the compiler version rather than not having it on by default. The reason
> > is that people reported performance improvements when compiling the
> > kernel without frame pointers.
> 
> [Sorry, I sent the wrong patch... This is the new one.]

and the wrong ARM kernel list (I changed the Cc line).

> This solution is fine too (even if I still think that changing the
> default setting is better).
> 
> Please, consider the patch in attachment: is it like you would have it ?

You can just send it to Russell's patch system once there are no more
comments on it.

See below for my comments.

> BTW, do we have any list of buggy or not-EABI versions of the gcc
> compiler ?

No, but for non-EABI compilers I think the __ARM_EABI__ check is enough.

> From: Claudio Scordino <claudio@evidence.eu.com>
> Date: Mon, 26 Oct 2009 17:13:18 +0100
> Subject: [PATCH 1/1] Some warnings when compiling ARM unwind support with a buggy or not-EABI compiler.
> 
> ARM unwind support is known to build only with EABI and not-buggy compilers.
> Now we check the compiler and raise a #warning in case of wrong compiler.

Maybe you can clarify a bit that the problem is not unwinding
information but the -fno-frame-pointer option added as a result of 
!CONFIG_FRAME_POINTER.

> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
> ---
>  arch/arm/kernel/unwind.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
> index 39baf11..47345c1 100644
> --- a/arch/arm/kernel/unwind.c
> +++ b/arch/arm/kernel/unwind.c
> @@ -26,6 +26,15 @@
>   * http://infocenter.arm.com/help/topic/com.arm.doc.subset.swdev.abi/index.html
>   */
>  
> +#if !defined (__ARM_EABI__)
> +#warning Your compiler does not have EABI support.
> +#warning    ARM unwind support it is known to compile only on EABI compilers.

Maybe "ARM unwind is known ... only with ..." (though English is not my
first language).

> +#warning    Change compiler or disable ARM_UNWIND option.
> +#elif (__GNUC__ == 4 && __GNUC_MINOR__ == 2)

Could we assume this for (__GNUC_MINOR__ <= 2)?

> +#warning Your compiler is too buggy; it is known to not compile ARM unwind support.
> +#warning    Change compiler or disable ARM_UNWIND option.
> +#endif
> +
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/module.h>

-- 
Catalin

