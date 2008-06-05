Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbYFEMjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbYFEMjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYFEMjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:39:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37527 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755864AbYFEMjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:39:16 -0400
Date: Thu, 5 Jun 2008 07:39:10 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix compile warning in io_apic_{32,64}.c
Message-ID: <20080605123910.GA5938@sgi.com>
References: <20080605120557.GB14755@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605120557.GB14755@alberich.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 02:05:57PM +0200, Andreas Herrmann wrote:
> Commit 05f2d12c3563dea8c81b301f9f3cf7919af23b13
> (x86: change GET_APIC_ID() from an inline function to an out-of-line function)
> 
> introduced a compile warning
> 
> arch/x86/kernel/io_apic_64.c: In function 'print_local_APIC':
> arch/x86/kernel/io_apic_64.c:1152: warning: 'v' is used uninitialized in this function
> 
> in some debug code -- which is not enabled by default.
> This patch reverts the code changes in print_local_APIC.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> --
> diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
> index a40d54f..9a3446f 100644
> --- a/arch/x86/kernel/io_apic_32.c
> +++ b/arch/x86/kernel/io_apic_32.c
> @@ -1489,8 +1489,8 @@ void /*__init*/ print_local_APIC(void * dummy)
>  
>  	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
>  		smp_processor_id(), hard_smp_processor_id());
> -	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v,
> -			GET_APIC_ID(read_apic_id()));
> +	v = apic_read(APIC_ID);
> +	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, GET_APIC_ID(v));
>  	v = apic_read(APIC_LVR);
>  	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
>  	ver = GET_APIC_VERSION(v);
> diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
> index ef1a8df..59ed52c 100644
> --- a/arch/x86/kernel/io_apic_64.c
> +++ b/arch/x86/kernel/io_apic_64.c
> @@ -1077,7 +1077,8 @@ void __apicdebuginit print_local_APIC(void * dummy)
>  
>  	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
>  		smp_processor_id(), hard_smp_processor_id());
> -	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, GET_APIC_ID(read_apic_id()));
> +	v = apic_read(APIC_ID);

I don't think this work on UV systems. Because of processor limitations, not
all of the APICID bits are contained in the hardware APIC_ID register. See
read_apic_id() in arch/x86/kernel/genapic_64.c.

I have not seen the compiler warning. What tree/options cause the error???


> +	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, GET_APIC_ID(v));
>  	v = apic_read(APIC_LVR);
>  	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
>  	ver = GET_APIC_VERSION(v);
> 
> 
> 

--- jack
