Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYIISGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYIISGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbYIISF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:05:56 -0400
Received: from gw.goop.org ([64.81.55.164]:55901 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689AbYIISFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:05:54 -0400
Message-ID: <48C6BB00.9040607@goop.org>
Date: Tue, 09 Sep 2008 11:05:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Xen: Fix pte unpin BUG when !CONFIG_SMP
References: <> <1220959508-13806-1-git-send-email-alex.nixon@citrix.com>
In-Reply-To: <1220959508-13806-1-git-send-email-alex.nixon@citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
> We still need to pin PTEs, even if there are no PTE locks.  Otherwise we'll BUG whenever there aren't PTE locks (i.e. whenever NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS), as we try to unpin PTEs which were never pinned in the first place.
>   

Where does the unpin happen?  xen_unpin_page() also checks to see if it
took the lock before trying to unpin, symmetric with xen_pin_page().

    J
> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/xen/mmu.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index f5af913..1239bda 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -819,9 +819,10 @@ static int xen_pin_page(struct page *page, enum pt_level level)
>  					pfn_pte(pfn, PAGE_KERNEL_RO),
>  					level == PT_PGD ? UVMF_TLB_FLUSH : 0);
>  
> -		if (ptl) {
> +		if (level == PT_PTE)
>  			xen_do_pin(MMUEXT_PIN_L1_TABLE, pfn);
>  
> +		if (ptl) {
>  			/* Queue a deferred unlock for when this batch
>  			   is completed. */
>  			xen_mc_callback(xen_pte_unlock, ptl);
> @@ -924,9 +925,7 @@ static int xen_unpin_page(struct page *page, enum pt_level level)
>  		 */
>  		if (level == PT_PTE) {
>  			ptl = xen_pte_lock(page);
> -
> -			if (ptl)
> -				xen_do_pin(MMUEXT_UNPIN_TABLE, pfn);
> +			xen_do_pin(MMUEXT_UNPIN_TABLE, pfn);
>  		}
>  
>  		mcs = __xen_mc_entry(0);
>   

