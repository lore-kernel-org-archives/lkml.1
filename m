Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYFZHZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYFZHZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYFZHZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:25:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:52443 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYFZHZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:25:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CqNEZ+bpXeGwiN2gtr1+KQMCkHLAyikddCPCMri5k2xPMkVhU1SYDLLOIJ7AI3cLaU
         GPc+xCXS4iDT3H6ORGueMcAm7CkaEVhkBCnEeoMSL/SgsyB43H01NEhmv45/n02ENkJ/
         R0eqNkODFR/qTpdU8rLHKORX5i08FEdO3gaRo=
Message-ID: <86802c440806260025v3fc1970aq682b568cccba4b4e@mail.gmail.com>
Date: Thu, 26 Jun 2008 00:25:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1214461978.10809.6.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214461978.10809.6.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 11:32 PM, Huang, Ying <ying.huang@intel.com> wrote:
> This patch add a new type to E820 table named E820_RESVD_KERN, which
> is used for memory area reserved for kernel itself instead of BIOS.
>
> This patch is based on latest x86/master branch of git-x86 tree and
> has been tested on i386 and x86_64 platform.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
> ---
>  arch/x86/kernel/e820.c |    6 ++++--
>  include/asm-x86/e820.h |    3 +++
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> --- a/include/asm-x86/e820.h
> +++ b/include/asm-x86/e820.h
> @@ -44,6 +44,9 @@
>  #define E820_ACPI      3
>  #define E820_NVS       4
>
> +/* reserved RAM used by kernel itself */
> +#define E820_RESVD_KERN        128
> +
>  #ifndef __ASSEMBLY__
>  struct e820entry {
>        __u64 addr;     /* start of memory segment */
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -120,6 +120,7 @@ void __init e820_print_map(char *who)
>                       (e820.map[i].addr + e820.map[i].size));
>                switch (e820.map[i].type) {
>                case E820_RAM:
> +               case E820_RESVD_KERN:
>                        printk(KERN_CONT "(usable)\n");
>                        break;
>                case E820_RESERVED:
> @@ -611,7 +612,7 @@ void __init e820_mark_nosave_regions(uns
>                        register_nosave_region(pfn, PFN_UP(ei->addr));
>
>                pfn = PFN_DOWN(ei->addr + ei->size);
> -               if (ei->type != E820_RAM)
> +               if (ei->type != E820_RAM && ei->type != E820_RESVD_KERN)
>                        register_nosave_region(PFN_UP(ei->addr), pfn);
>
>                if (pfn >= limit_pfn)
> @@ -977,7 +978,7 @@ u64 __init early_reserve_e820(u64 startt
>                return 0;
>
>        addr = round_down(start + size - sizet, align);
> -       e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);
> +       e820_update_range(addr, sizet, E820_RAM, E820_RESVD_KERN);

this line is not needed.

>        printk(KERN_INFO "update e820 for early_reserve_e820\n");
>        update_e820();
>
> @@ -1191,6 +1192,7 @@ void __init e820_reserve_resources(void)
>        res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
>        for (i = 0; i < e820.nr_map; i++) {
>                switch (e820.map[i].type) {
> +               case E820_RESVD_KERN:
>                case E820_RAM:  res->name = "System RAM"; break;
>                case E820_ACPI: res->name = "ACPI Tables"; break;
>                case E820_NVS:  res->name = "ACPI Non-volatile Storage"; break;
>
> --

please  move reserve_setup_data() from head.c/head64.c to setup32/64.c
or merged setup.c
also need to change reserve_early in reserve_setup_data to
e820_update_range(,,E820_RAM, E820_RESEVED_EXTRA).
calling reserve_setup_data() should around early_reserve_e820_mpc_new.

we don't need early_res_to_e820.

YH
