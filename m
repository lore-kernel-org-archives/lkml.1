Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZCAD7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZCAD7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 22:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZCAD6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 22:58:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57085 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbZCAD6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 22:58:50 -0500
Message-ID: <49AA07DD.1030303@redhat.com>
Date: Sat, 28 Feb 2009 22:58:21 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix DMI for EFI
References: <49A9F597.4010601@redhat.com>	 <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com>	 <49A9FCEB.9090504@redhat.com> <86802c440902281925m6eb68456vc3886252619b6743@mail.gmail.com>
In-Reply-To: <86802c440902281925m6eb68456vc3886252619b6743@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. At this point maybe its easier just to move efi_init instead. 
Ill re-work, test and post a followup...

Brian


Yinghai Lu wrote:
> please use git log -p arch/x86/kernel/setup.c to check the history...
>
> YH
>
>
> commit 2216d199b1430d1c0affb1498a9ebdbd9c0de439
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Mon Sep 22 02:52:26 2008 -0700
>
>     x86: fix CONFIG_X86_RESERVE_LOW_64K=y
>
>     The bad_bios_dmi_table() quirk never triggered because we do DMI setup
>     too late. Move it a bit earlier.
>
>     Also change the CONFIG_X86_RESERVE_LOW_64K quirk to operate on the e820
>     table directly instead of messing with early reservations - this handles
>     overlaps (which do occur in this low range of RAM) more gracefully.
>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 161f1b3..d29951c 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -735,7 +735,8 @@ static int __init dmi_low_memory_corruption(const
> struct dmi_system_id *d)
>                 "%s detected: BIOS may corrupt low RAM, working it around.\n",
>                 d->ident);
>
> -       reserve_early_overlap_ok(0x0, 0x10000, "BIOS quirk");
> +       e820_update_range(0, 0x10000, E820_RAM, E820_RESERVED);
> +       sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
>
>         return 0;
>  }
> @@ -784,8 +785,6 @@ void __init setup_arch(char **cmdline_p)
>         printk(KERN_INFO "Command line: %s\n", boot_command_line);
>  #endif
>
> -       dmi_check_system(bad_bios_dmi_table);
> -
>         early_cpu_init();
>         early_ioremap_init();
>
> @@ -880,6 +879,10 @@ void __init setup_arch(char **cmdline_p)
>
>         finish_e820_parsing();
>
> +       dmi_scan_machine();
> +
> +       dmi_check_system(bad_bios_dmi_table);
> +
>  #ifdef CONFIG_X86_32
>         probe_roms();
>  #endif
> @@ -967,8 +970,6 @@ void __init setup_arch(char **cmdline_p)
>         vsmp_init();
>  #endif
>
> -       dmi_scan_machine();
> -
>         io_delay_init();
>   

