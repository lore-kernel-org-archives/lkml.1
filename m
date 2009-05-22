Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbZEVUfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbZEVUfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbZEVUfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:35:24 -0400
Received: from www.tglx.de ([62.245.132.106]:57218 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259AbZEVUfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:35:23 -0400
Date: Fri, 22 May 2009 22:33:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rakib Mullick <rakib.mullick@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@openvz.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,APIC: Detect lapic_is_integrated() once - use on
 and on.
In-Reply-To: <b9df5fa10905220631y7b1a094dn9a6e13de1b9c43af@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0905222227250.3570@localhost.localdomain>
References: <b9df5fa10905220631y7b1a094dn9a6e13de1b9c43af@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Rakib Mullick wrote:
>   Impact: Reduce text space through efficient coding
> 
>  Determine apic is integrated or not - by calling
> lapic_is_integrated() once from APIC_init_uniprocessor() and keep it
> in a variable integrated_lapic. Thus we can determine apic is
> integrated or not, by checking the variable instead of calling
> lapic_is_integrated() on and on. Marking lapic_is_integrated() as
> __init, which reduces some text space. Also allows us to get away from
> messy #ifdef and inline.
> 
> ---
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linus/arch/x86/kernel/apic/apic.c	2009-05-21 22:22:15.000000000 +0600
> +++ rakib/arch/x86/kernel/apic/apic.c	2009-05-21 23:27:26.000000000 +0600
> @@ -127,6 +127,9 @@ early_param("nox2apic", setup_nox2apic);
> 
>  unsigned long mp_lapic_addr;
>  int disable_apic;
> +
> +static int integrated_lapic;
> +
>  /* Disable local APIC timer from the kernel commandline or via dmi quirk */
>  static int disable_apic_timer __cpuinitdata;
>  /* Local APIC timer works in C2 */
> @@ -188,13 +191,12 @@ static inline int lapic_get_version(void
>  /*
>   * Check, if the APIC is integrated or a separate chip
>   */
> -static inline int lapic_is_integrated(void)
> +void __init lapic_is_integrated(void)
>  {
> -#ifdef CONFIG_X86_64
> -	return 1;
> -#else
> -	return APIC_INTEGRATED(lapic_get_version());
> -#endif
> +	if (APIC_INTEGRATED(lapic_get_version()))
> +		integrated_lapic = 1;
> +	else
> +		integrated_lapic = 0;
>  }

I agree in general, but the patch is flawed as it prevents the
compiler to optimize the X86_64 case out.

What you really want is:

#ifdef CONFIG_X86_64
# define integrated_lapic (1)
#else
static int integrated_lapic __read_mostly;
#endif

static inline void lapic_is_integrated(void)
{
#ifdef CONFIG_X86_32
	integrate_lapic = APIC_INTEGRATED(lapic_get_version());
#endif
}

So that way the check is only done for 32bit systems and the compiler
will optimize out the code which depends on !integrated_lapic.

Thanks,

	tglx
