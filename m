Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYHTUMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYHTUMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbYHTULz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:11:55 -0400
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:56010 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbYHTULy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:11:54 -0400
Message-ID: <48AC7A85.40803@numericable.fr>
Date: Wed, 20 Aug 2008 22:11:49 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008081609)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re:[PATCH] x86: silence section mismatch warning - uv_cpu_init
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> WARNING: vmlinux.o(.cpuinit.text+0x3cc4): Section mismatch in reference from the function uv_cpu_init() to the function .init.text:uv_system_init()
> The function __cpuinit uv_cpu_init() references
> a function __init uv_system_init().
> If uv_system_init is only used by uv_cpu_init then
> annotate uv_system_init with a matching annotation.
>
> uv_system_init was ment to be called only once, so make explicit
> by creating properly-named function and annotate it as __ref.
>
> Old code relied on uv_node_to_blade being initialized to 0,
> but it'a not initialized from anywhere and it's not static either.
>
> Signed-off-by: Marcin Slusarz<marcin.slusarz@gmail.com>
> Cc: Ingo Molnar<mingo@elte.hu>
> Cc: Jack Steiner<steiner@sgi.com>
> ---
>   arch/x86/kernel/genx2apic_uv_x.c |   14 ++++++++++++--
>   1 files changed, 12 insertions(+), 2 deletions(-)
> diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
> index 2d7e307..ecbfefa 100644
> --- a/arch/x86/kernel/genx2apic_uv_x.c
> +++ b/arch/x86/kernel/genx2apic_uv_x.c
> @@ -385,14 +385,24 @@ static __init void uv_system_init(void)
>   	map_mmioh_high(max_pnode);
>   }
>
> +/* Wrapper for uv_system_init which calls it only once. */
> +static void __ref uv_system_init_once(void)
> +{
> +	static bool uv_system_inited = false;
> +
> +	if (!uv_system_inited) {
> +		uv_system_init();
> +		uv_system_inited = true;
> +	}
> +}
> +
>   /*
>    * Called on each cpu to initialize the per_cpu UV data area.
>    * 	ZZZ hotplug not supported yet
>    */
>   void __cpuinit uv_cpu_init(void)
>   {
> -	if (!uv_node_to_blade)
> -		uv_system_init();
> +	uv_system_init_once();
>
>   	uv_blade_info[uv_numa_blade_id()].nr_online_cpus++;
>
> -- 
> 1.5.4.5
>
>    
Hi Marcin,

Your patch works fine on my box and section mismatch desappears.

Thanks.

Regards.

P.S. : 3 section mimsatches are remaining unsolved at this time on my 
config :

WARNING: vmlinux.o(.meminit.text+0x2f2): Section mismatch in reference 
from the function alloc_low_page() to the function 
.init.text:early_ioremap()
The function __meminit alloc_low_page() references
a function __init early_ioremap().
If early_ioremap is only used by alloc_low_page then
annotate early_ioremap with a matching annotation.

WARNING: vmlinux.o(.meminit.text+0x608): Section mismatch in reference 
from the function phys_pmd_init() to the function .init.text:early_iounmap()
The function __meminit phys_pmd_init() references
a function __init early_iounmap().
If early_iounmap is only used by phys_pmd_init then
annotate early_iounmap with a matching annotation.

WARNING: vmlinux.o(.meminit.text+0x861): Section mismatch in reference 
from the function phys_pud_init() to the function .init.text:early_iounmap()
The function __meminit phys_pud_init() references
a function __init early_iounmap().
If early_iounmap is only used by phys_pud_init then
annotate early_iounmap with a matching annotation.


