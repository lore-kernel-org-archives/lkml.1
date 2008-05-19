Return-Path: <linux-kernel-owner+w=401wt.eu-S1763734AbYESUIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763734AbYESUIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbYESUIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:08:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:13683 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758900AbYESUII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ibGQ8MZVlIDV8p45nnMMJBtvSyax6iH3YFAY7DrfL5cwNeyzeZqSnerUxPRXM3PXBt2LfWBAUNGwH4lp3ZjY0IeK6NkB0c+KN+3M6rHyjQFqWMyMmCA8lb/MbH5ySoTcpjBp8snuaFk/HoBfMd77h2/0yC9L1VtSvvjZyxYG93w=
Message-ID: <86802c440805191308k5700fbb9x5ed76f7f58d11c69@mail.gmail.com>
Date: Mon, 19 May 2008 13:08:07 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexey Starikovskiy" <astarikovskiy@suse.de>
Subject: Re: [PATCH 5/5] x86: allow MPPARSE to be deselected in SMP configs
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080519154722.15071.91358.stgit@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080519154656.15071.96979.stgit@thinkpad>
	 <20080519154722.15071.91358.stgit@thinkpad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 8:47 AM, Alexey Starikovskiy
<astarikovskiy@suse.de> wrote:
> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
> ---
>
>  arch/x86/Kconfig.debug     |    2 +-
>  arch/x86/kernel/setup.c    |    2 +-
>  arch/x86/kernel/setup_32.c |    2 +-
>  arch/x86/kernel/setup_64.c |    4 ++++
>  4 files changed, 7 insertions(+), 3 deletions(-)
>
>
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 5eb480e..f27de28 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -128,7 +128,7 @@ config 4KSTACKS
>
>  config X86_FIND_SMP_CONFIG
>        def_bool y
> -       depends on X86_LOCAL_APIC || X86_VOYAGER
> +       depends on X86_MPPARSE || X86_VOYAGER || X86_VISWS
>        depends on X86_32
>
>  config X86_MPPARSE
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 089ddfa..c86bda7 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -12,7 +12,7 @@
>  #include <asm/mpspec.h>
>  #include <asm/apicdef.h>
>
> -#ifdef CONFIG_X86_MPPARSE
> +#ifdef CONFIG_X86_LOCAL_APIC
>  unsigned int num_processors;
>  unsigned disabled_cpus __cpuinitdata;
>
> diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
> index 12a31de..9af0d5f 100644
> --- a/arch/x86/kernel/setup_32.c
> +++ b/arch/x86/kernel/setup_32.c
> @@ -846,7 +846,7 @@ void __init setup_arch(char **cmdline_p)
>                        "CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
>  #endif
>  #endif
> -#ifdef CONFIG_X86_LOCAL_APIC
> +#if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
>        if (smp_found_config)
>                get_smp_config();
>  #endif
> diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
> index 9234675..8047db9 100644
> --- a/arch/x86/kernel/setup_64.c
> +++ b/arch/x86/kernel/setup_64.c
> @@ -439,7 +439,9 @@ void __init setup_arch(char **cmdline_p)
>        /*
>        * Find and reserve possible boot-time SMP configuration:
>        */
> +#ifdef CONFIG_X86_MPPARSE
>        find_smp_config();
> +#endif

put the ifdef before the comments?

also if the mptable is not reserved in e820 table (buggy bios), we may
still need to call find_smp_config to reserved the mptable.
otherwise kexec to kernel without acpi support or acpi=off could fail,
because mptable could be damaged already.

>  #ifdef CONFIG_BLK_DEV_INITRD
>        if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
>                unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
> @@ -485,8 +487,10 @@ void __init setup_arch(char **cmdline_p)
>        /*
>         * get boot-time SMP configuration:
>         */
> +#ifdef CONFIG_X86_MPPARSE
>        if (smp_found_config)
>                get_smp_config();
> +#endif

put the ifdef before coments please.

>        init_apic_mappings();
>        ioapic_init_mappings();

YH
