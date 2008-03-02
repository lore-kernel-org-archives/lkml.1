Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbYCBUmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbYCBUmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYCBUmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:42:13 -0500
Received: from postfix1-g20.free.fr ([212.27.60.42]:35452 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbYCBUmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:42:13 -0500
Message-ID: <47CB10AD.3000701@free.fr>
Date: Sun, 02 Mar 2008 21:40:13 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com> <47C0DB7D.70407@linux.intel.com> <47C2ED51.4000105@googlemail.com> <47C344E5.5050205@linux.intel.com> <20080302155348.GA74305@gandalf.sssup.it>
In-Reply-To: <20080302155348.GA74305@gandalf.sssup.it>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02.03.2008 16:53, Fabio Checconi a écrit :
> 
> __ioremap() emits a warning if the pfn after the last one it's going
> to map is of normal ram.  Correct this and emit the warning (once)
> only if one of the asked pages is.
> 
> Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>

Tested-by: Laurent Riffard <laurent.riffard@free.fr>

With this patch, the WARNING at arch/x86/mm/ioremap.c does not occur anymore.

thanks
~~
laurent

> ---
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index ac3c959..6f7b158 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -109,7 +109,7 @@ static int ioremap_change_attr(unsigned long vaddr, unsigned long size,
>  static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
>  			       enum ioremap_mode mode)
>  {
> -	unsigned long pfn, offset, last_addr, vaddr;
> +	unsigned long pfn, offset, last_addr, vaddr, is_ram = 0;
>  	struct vm_struct *area;
>  	pgprot_t prot;
>  
> @@ -132,9 +132,10 @@ static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
>  		if (page_is_ram(pfn) && pfn_valid(pfn) &&
>  		    !PageReserved(pfn_to_page(pfn)))
>  			return NULL;
> +		is_ram |= page_is_ram(pfn);
>  	}
>  
> -	WARN_ON_ONCE(page_is_ram(pfn));
> +	WARN_ON_ONCE(is_ram);
>  
>  	switch (mode) {
>  	case IOR_MODE_UNCACHED:
> 
