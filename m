Return-Path: <linux-kernel-owner+w=401wt.eu-S1763699AbYBUJwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763699AbYBUJwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYBUJw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:52:28 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:47555 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbYBUJw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:52:27 -0500
Date: Thu, 21 Feb 2008 10:52:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ian Campbell <ijc@hellion.org.uk>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86 : add init BSS sections
Message-ID: <20080221095237.GA26714@uranus.ravnborg.org>
References: <1203581721.4707.19.camel@caritas-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203581721.4707.19.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang.

A few comments..

> Init BSS sections are added for uninitialized init DATA sections to
> reduce kernel image size.

- If this is relevant for more than just x86 then the definition
  of the section should be in include/asm-generic/vmlinux.lds.h

- Please add a comment along the definitions in the .lds file
  explaning the use of the section.
- Same goes for init.h

- Is this concept restricted to __init or is it
  relevant for __devinit etc (I hope we can avoid that)

- Can we do any kind of build time check to catch
  accidental misuse?

	Sam



> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  arch/x86/kernel/head64.c         |    2 ++
>  arch/x86/kernel/head_32.S        |    5 +++++
>  arch/x86/kernel/vmlinux_32.lds.S |    9 +++++++--
>  arch/x86/kernel/vmlinux_64.lds.S |   24 ++++++++++++++----------
>  include/asm-generic/sections.h   |    1 +
>  include/linux/init.h             |    1 +
>  6 files changed, 30 insertions(+), 12 deletions(-)
> 
> --- a/arch/x86/kernel/vmlinux_32.lds.S
> +++ b/arch/x86/kernel/vmlinux_32.lds.S
> @@ -189,10 +189,15 @@ SECTIONS
>  	__per_cpu_end = .;
>    }
>    . = ALIGN(PAGE_SIZE);
Do we really need to aling this to PAGE_SIZE - I
assume we free everything in one go - or?

> -  /* freed after init ends here */
>  
>    .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
> -	__init_end = .;
> +	__init_bss_start = .;
> +	*(.bss.init.page_aligned)
I do not see this section used anywhere. At least init.h does not
define it.


> +	*(.bss.init)
> +	. = ALIGN(4);
> +	__init_bss_stop = .;
> +	. = ALIGN(PAGE_SIZE);

Why do we have these two ALIGN() following each other?
The latter should be enough.

> +	__init_end = .;			/* freed after init ends here */
>  	__bss_start = .;		/* BSS */
>  	*(.bss.page_aligned)
>  	*(.bss)
> --- a/arch/x86/kernel/vmlinux_64.lds.S
> +++ b/arch/x86/kernel/vmlinux_64.lds.S
> @@ -150,6 +150,12 @@ SECTIONS
>    . = ALIGN(PAGE_SIZE);
>    __smp_alt_end = .;
>  
> +  . = ALIGN(PAGE_SIZE);
> +  __nosave_begin = .;
> +  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data.nosave) }
> +  . = ALIGN(PAGE_SIZE);
> +  __nosave_end = .;
> +
This change looks unrelated - it is not in the changelog.
Or is it just diff that fools me?

>    . = ALIGN(PAGE_SIZE);		/* Init code and data */
>    __init_begin = .;
>    .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
> @@ -219,17 +225,15 @@ SECTIONS
>  
>    PERCPU(PAGE_SIZE)
>  
> -  . = ALIGN(PAGE_SIZE);
> -  __init_end = .;
> -
> -  . = ALIGN(PAGE_SIZE);
> -  __nosave_begin = .;
> -  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data.nosave) }
> -  . = ALIGN(PAGE_SIZE);
> -  __nosave_end = .;
> -
> -  __bss_start = .;		/* BSS */
> +  . = ALIGN(PAGE_SIZE);		/* BSS */
>    .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
> +	__init_bss_start = .;
> +	*(.bss.init.page_aligned)
> +	*(.bss.init)
> +	__init_bss_stop = .;
> +	. = ALIGN(PAGE_SIZE);
> +	__init_end = .;
> +	__bss_start = .;
>  	*(.bss.page_aligned)
>  	*(.bss)
>  	}
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -105,6 +105,11 @@ ENTRY(startup_32)
>   */
>  	cld
>  	xorl %eax,%eax
> +	movl $pa(__init_bss_start),%edi
> +	movl $pa(__init_bss_stop), %ecx
> +	subl %edi,%ecx
> +	shrl $2,%ecx
> +	rep ; stosl
>  	movl $pa(__bss_start),%edi
>  	movl $pa(__bss_stop),%ecx
>  	subl %edi,%ecx

How about introducing head32.c and do this in a similar
way that 64 bit does?
Then we could later move more stuff to said file.


	Sam
