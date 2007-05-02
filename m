Return-Path: <linux-kernel-owner+w=401wt.eu-S1766814AbXEBRIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766814AbXEBRIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766815AbXEBRIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:08:54 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:46200 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766814AbXEBRIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:08:53 -0400
Date: Wed, 2 May 2007 19:08:37 +0200 (CEST)
From: Bernhard Kaindl <bk@suse.de>
To: randy.dunlap@oracle.com, Andi Kleen <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/34] i386: fix mtrr sections
In-Reply-To: <20070430154948.B6DDF151CA@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0705021559160.32650@jbgna.fhfr.qr>
References: <20070430549.617098000@suse.de> <20070430154948.B6DDF151CA@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Andi Kleen wrote:

> Subject: [PATCH] [16/34] i386: fix mtrr sections

NACK - obsolete, replaced by:
Jeremy Fitzhardinge - "x86: clean up identify_cpu"
http://lkml.org/lkml/2007/4/7/113 [it's also patch 11/26 in this thread]

It's a leftover of "__init to __cpuinit in mtrr code" (Prarit Bhargava):
http://lkml.org/lkml/2007/2/28/198 - (acked by Bhavana Nagendra) which
itself is rejected from Andrews tree already.

Description:
------------

This function tree (as of 2.6.21) here explains it all:

__cpuinit       identify_cpu()
    -> if BSP is inited, so only at __init time, these functions are called:
         __init     mtrr_bp_init()
            __init      get_mtrr_state()
               __initdata   show_mtrr;
               __init       print_fixed()

The above works just fine in practice, but of course it's ugly.

Prarit Bhargava's approach was to silence the warnings was to change
mtrr_bp_init() and everything it uses (which is quite a lot) to __cpuinit,
but this prevents a lot of code to be freed on kernels which support CPU
hotplug.

He also forgot to change the last two references in the tree above
(show_mtrr and print_fixed) to __cpuinit, which is what this patch
here from Randy does.

-----> Thank God, Jeremy Fitzhardinge cleaned up identify_cpu:

"x86: clean up identify_cpu" - http://lkml.org/lkml/2007/4/7/113

It replaces this rather ugly code

        if (c == &boot_cpu_data)
--------------> sysenter_setup();
        enable_sep_cpu();

        if (c == &boot_cpu_data)
--------------> mtrr_bp_init();
        else
                mtrr_ap_init();

and by moving these calls into separate __cpuinit and __init functions.

That means that quite some of stuff (the init code for all the various MTRR
implementations on Intel, AMD, Cyrix and Centar CPUs) can be kept in __init
and Prarit Bhargava's and Randy Dunlap's MTRR warning changes are obsolete.

You posted Jeremy Fitzhardinge's patch as part of this patchset for review:

Subject: [PATCH] [11/26] i386: clean up identify_cpu

The i386 label above is actally wrong, it should be "x86".

Concusion:
----------

The above "clean up identify_cpu" by Jeremy Fitzhardinge properly fixes

WARNING: vmlinux - Section mismatch: reference to .init.text:sysenter_setup from .text between 'identify_cpu' (at offset 0xc010a1e8) and 'display_cacheinfo'
WARNING: vmlinux - Section mismatch: reference to .init.text:mtrr_bp_init from .text between 'identify_cpu' (at offset 0xc010a1f2) and 'display_cacheinfo'

and this patch should be rejected because it's only cured symptoms
caused by a patch which was already rejected by Andrew in favour of
"clean up identify_cpu". This patch only was a leftover.

Best Regards,
Bernhard

PS: I reviewed the MTRR __init labels myself while working on MTRR debugging
so I know these functions from the top of my head and I verified what I
state with the patches sent by you for review by checking the MODPOST
with CONFIG_RELOCATABLE=y with/out the patches mentioned.

PPS: Hint for people which want to verfiy what I state:

Note that "clean up identify_cpu" needs the cleanup of bugs.h (also included
in the patches which you posted for review) and it needs
"Change sysenter_setup to __cpuinit", which is partly (for the
__cpuinit sysenter change) again wrong (also by Prarit Bhargava) but
that is fixed back to init by "clean up identify_cpu"...

> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix section mismatch warnings in mtrr code.
> Fix line length on one source line.

PPS: While it's bad that the line is long, it can be kept as is.
The MTTR code has a lot of CodingStyle fixes to go (e.g. lots of
missing function headers which describe what the functions do).

It's on my TODO list to make the MTRR code comforming to CodingStyle.

> WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x103)
> WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x180)
> WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x199)
> WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x1c1)
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Andi Kleen <ak@suse.de>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/i386/kernel/cpu/mtrr/generic.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> Index: linux/arch/i386/kernel/cpu/mtrr/generic.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/cpu/mtrr/generic.c
> +++ linux/arch/i386/kernel/cpu/mtrr/generic.c
> @@ -38,7 +38,7 @@ static struct mtrr_state mtrr_state = {}
>  #undef MODULE_PARAM_PREFIX
>  #define MODULE_PARAM_PREFIX "mtrr."
>
> -static __initdata int mtrr_show;
> +static int mtrr_show;
>  module_param_named(show, mtrr_show, bool, 0);
>
>  /*  Get the MSR pair relating to a var range  */
> @@ -68,12 +68,13 @@ void mtrr_save_fixed_ranges(void *info)
>  	get_fixed_ranges(mtrr_state.fixed_ranges);
>  }
>
> -static void __init print_fixed(unsigned base, unsigned step, const mtrr_type*types)
> +static void __cpuinit print_fixed(unsigned base, unsigned step, const mtrr_type*types)
