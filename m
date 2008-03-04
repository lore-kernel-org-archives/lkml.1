Return-Path: <linux-kernel-owner+w=401wt.eu-S1763751AbYCDLmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763751AbYCDLmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbYCDLmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:42:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbYCDLmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:42:31 -0500
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
	to 1MB
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1204240609.28798.33.camel@cthulhu.hellion.org.uk>
References: <20080224174605.GA21661@mailshack.com>
	 <47C22568.1010405@zytor.com>
	 <1203958478.20033.1239002461@webmail.messagingengine.com>
	 <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>
	 <20080228131341.GA25213@mailshack.com>
	 <20080228132822.GA25278@mailshack.com>
	 <1204233131.28798.12.camel@cthulhu.hellion.org.uk>
	 <47C72432.3010606@zytor.com>
	 <1204240609.28798.33.camel@cthulhu.hellion.org.uk>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 11:41:46 +0000
Message-Id: <1204630906.16613.4.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-28 at 23:16 +0000, Ian Campbell wrote:
> On Thu, 2008-02-28 at 13:14 -0800, H. Peter Anvin wrote:
> >
> > You need to set up your memory map more sensibly; it's not just the 
> > kernel, user space tries to access these areas too.
> 
> Agreed, I think it's pure luck that Xen kernels have gotten away with it
> in the past.
> 
> The patch below seems like the right thing to do. It certainly boots in
> a domU without the DMI problem (without any of the other related patches
> such as Alexander's).

Yep, this patch on its own fixes 2.6.25-rc3 DomU boot for me here.

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

Seems to me to be the right thing to do ...

Acked-by: Mark McLoughlin <markmc@redhat.com>

Cheers,
Mark.

