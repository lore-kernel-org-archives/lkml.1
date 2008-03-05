Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbYCEQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbYCEQCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbYCEQCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:02:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247AbYCEQCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:02:31 -0500
Date: Wed, 5 Mar 2008 12:59:31 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
	to 1MB
Message-ID: <20080305155930.GI20230@blackpad>
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <20080228132822.GA25278@mailshack.com> <1204233131.28798.12.camel@cthulhu.hellion.org.uk> <47C72432.3010606@zytor.com> <1204240609.28798.33.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204240609.28798.33.camel@cthulhu.hellion.org.uk>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 11:16:49PM +0000, Ian Campbell wrote:
> 
> The patch below seems like the right thing to do. It certainly boots in
> a domU without the DMI problem (without any of the other related patches
> such as Alexander's).
> 
> However ddcprobe hangs when run -- need to investigate some more, vm86
> in general works ok (i.e. my vm86 test code passes).
> 
> BTW Jeremy, the kernel doesn't use XENMEM_memory_map -- any reason other
> than it not being useful at the time? These days the tools can push an
> arbitrary e820 down for a guest which might be useful to support,
> although nothing interesting is done with it today.
> 
> Ian.
> 
> x86/xen: Construct e820 map with a hole between 640K-1M.
> 
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> ---
>  arch/x86/xen/setup.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 3bad477..2341492 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -38,7 +38,8 @@ char * __init xen_memory_setup(void)
>  	unsigned long max_pfn = xen_start_info->nr_pages;
>  
>  	e820.nr_map = 0;
> -	add_memory_region(0, PFN_PHYS(max_pfn), E820_RAM);
> +	add_memory_region(0, LOWMEMSIZE(), E820_RAM);
> +	add_memory_region(HIGH_MEMORY, PFN_PHYS(max_pfn)-HIGH_MEMORY, E820_RAM);

Won't this waste 300+ KB of Perfectly Good RAM? Or I understood it
incorrectly?

I am aware that it would take more work to tell all kernel code that it
shouldn't look for BIOS data on this region when running as a domU guest,
but it seems that it would be a better solution.

-- 
Eduardo
