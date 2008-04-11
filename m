Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbYDKRtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbYDKRtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760299AbYDKRto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:49:44 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53536 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760297AbYDKRto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:49:44 -0400
Date: Fri, 11 Apr 2008 19:50:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de
Subject: Re: [PATCH] x86: setup_trampoline() - fix section mismatch warning
Message-ID: <20080411175006.GA31716@uranus.ravnborg.org>
References: <47FE6799.9030606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FE6799.9030606@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek

On Thu, Apr 10, 2008 at 09:16:41PM +0200, Jacek Luczak wrote:
> Hi Ingo,
> 
> this patch fixes section mismatch warnings (on x86_64 host) in setup_trampoline(),
> which was referencing __initdata variables trampoline_data and trampoline_end.
> 
> Patch is against x86/latest.
> 
> Warning messages:
> WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x2b6a): Section mismatch in reference from the function setup_trampoline()
> to the variable .init.data:trampoline_data
> The function __cpuinit setup_trampoline() references
> a variable __initdata trampoline_data.
> If trampoline_data is only used by setup_trampoline then
> annotate trampoline_data with a matching annotation.
> 
> WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x2b71): Section mismatch in reference from the function setup_trampoline()
> to the variable .init.data:trampoline_end
> The function __cpuinit setup_trampoline() references
> a variable __initdata trampoline_end.
> If trampoline_end is only used by setup_trampoline then
> annotate trampoline_end with a matching annotation. 
> 
> -Jacek
> 
> PS: Hope that my email client won't break patch this time. In case it does - patch attached.
> 
> ---
> 
> diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
> index 4aedd0b..2a07e67 100644
> --- a/arch/x86/kernel/trampoline_64.S
> +++ b/arch/x86/kernel/trampoline_64.S
> @@ -32,7 +32,7 @@
>  
>  /* We can free up trampoline after bootup if cpu hotplug is not supported. */
>  #ifndef CONFIG_HOTPLUG_CPU
> -.section .init.data, "aw", @progbits
> +.section .cpuinit.data, "aw", @progbits
>  #else
>  .section .rodata, "a", @progbits
>  #endif

The correct fix would be to drop the
preprocessor directves and use __CPUINITDATA

Like this: (hand edited):

> diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
> index 4aedd0b..2a07e67 100644
> --- a/arch/x86/kernel/trampoline_64.S
> +++ b/arch/x86/kernel/trampoline_64.S
> @@ -32,7 +32,7 @@
>  
>  /* We can free up trampoline after bootup if cpu hotplug is not supported. */
>  #ifndef CONFIG_HOTPLUG_CPU
> -.section .init.data, "aw", @progbits
> -#else
> -.section .rodata, "a", @progbits
> -#endif
> +__CPUINITDATA

If your testing confirms this then please apply similar fix to the _32.S
version of the file too.

Nore that this looses the @progbits annotation but it should be OK to do so.
I may later add it to init.h.

	Sam
