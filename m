Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbYCCLAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbYCCLAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYCCLAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:00:00 -0500
Received: from smtp2.sssup.it ([193.205.80.100]:42513 "EHLO smpt2.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753951AbYCCK77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:59:59 -0500
Date: Mon, 3 Mar 2008 11:21:56 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
Message-ID: <20080303102156.GA79304@gandalf.sssup.it>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Gabriel C <nix.or.die@googlemail.com>,
	Laurent Riffard <laurent.riffard@free.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Stuart Bennett <sb476@cam.ac.uk>,
	Len Brown <lenb@kernel.org>, tglx@linutronix.de, mingo@redhat.com
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com> <47C0DB7D.70407@linux.intel.com> <47C2ED51.4000105@googlemail.com> <47C344E5.5050205@linux.intel.com> <20080302155348.GA74305@gandalf.sssup.it> <47CADC9D.9090403@linux.intel.com> <20080303084611.GA15943@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303084611.GA15943@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, Mar 03, 2008 09:46:11AM +0100
>
...
> Subject: x86: warn about RAM pages in ioremap()
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon Mar 03 09:37:41 CET 2008
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mm/ioremap.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-x86.q/arch/x86/mm/ioremap.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/mm/ioremap.c
> +++ linux-x86.q/arch/x86/mm/ioremap.c
> @@ -149,9 +149,11 @@ static void __iomem *__ioremap(unsigned 
>  	for (pfn = phys_addr >> PAGE_SHIFT;
>  				(pfn << PAGE_SHIFT) < last_addr; pfn++) {
>  
> -		if (page_is_ram(pfn) && pfn_valid(pfn) &&
> -		    !PageReserved(pfn_to_page(pfn)))
> +		int is_ram = page_is_ram(pfn);
> +
> +		if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
>  			return NULL;
> +		WARN_ON_ONCE(is_ram);
>  	}
>  
>  	switch (mode) {

In this way we can emit the warning even for pages that will not
be mapped, if asked for more than one page (e.g., one page triggers
the warning, one of the following triggers the return NULL condition,)
I don't think that would be useful, as the caller will notice the
error anyway.

I don't know if it's so important, but while we're at it, please
consider that, if last_addr % PAGE_SIZE == 0 the for loop exits
without checking the last pfn, that will be mapped.

