Return-Path: <linux-kernel-owner+w=401wt.eu-S2992647AbXCBRVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992647AbXCBRVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992645AbXCBRVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:21:46 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41424 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992647AbXCBRVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:21:45 -0500
Subject: Re: [patch -mm] x86_64: fake numa cmdline flag fix
From: Badari Pulavarty <pbadari@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703020901510.14893@chino.kir.corp.google.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	 <1172853148.9213.15.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0703020901510.14893@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 09:21:29 -0800
Message-Id: <1172856089.9213.27.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 09:03 -0800, David Rientjes wrote:
> Make sure we only reference 'cmdline' on CONFIG_NUMA_EMU.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Fixes the compile problem.

So does the moving 

char *cmdline __initdata;

out of CONFIG_NUMA_EMU. But I guess your is a cleaner fix.

Thanks,
Badari

> ---
>  arch/x86_64/mm/numa.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
> --- a/arch/x86_64/mm/numa.c
> +++ b/arch/x86_64/mm/numa.c
> @@ -524,22 +524,28 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
>  { 
>  	unsigned long start_addr = start_pfn << PAGE_SHIFT;
>  	unsigned long end_addr = end_pfn << PAGE_SHIFT;
> +	int numa_fake = 0;
>  	int i;
>  
> +#ifdef CONFIG_NUMA_EMU
> +	/* Determine if we have a numa=fake command line */
> +	if (cmdline != 0)
> +		numa_fake = 1;
> +#endif
> +
>  #ifdef CONFIG_ACPI_NUMA
> -	if (!numa_off && !cmdline && !acpi_scan_nodes(start_addr, end_addr))
> +	if (!numa_off && !numa_fake && !acpi_scan_nodes(start_addr, end_addr))
>   		return;
>  #endif
>  
>  #ifdef CONFIG_K8_NUMA
> -	if (!numa_off && !k8_scan_nodes(start_addr, end_addr, cmdline != 0))
> -		if (cmdline == 0)
> +	if (!numa_off && !k8_scan_nodes(start_addr, end_addr, numa_fake))
> +		if (!numa_fake)
>  			return;
>  #endif
>  
>  #ifdef CONFIG_NUMA_EMU
> -	if (cmdline)
> -	{
> +	if (numa_fake) {
>  		numa_emu = !numa_emulation(start_pfn, end_pfn);
>  		if (numa_emu)
>  			return;

