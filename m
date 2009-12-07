Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbZLGBL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbZLGBL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 20:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758325AbZLGBL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 20:11:58 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:32650 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758302AbZLGBL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 20:11:57 -0500
X-Trace: 302593096/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhsBAHvkG0tQKW/F/2dsb2JhbAAI1S2EMwSBZw
X-IronPort-AV: E=Sophos;i="4.47,351,1257120000"; 
   d="scan'208";a="302593096"
Date: Mon, 7 Dec 2009 01:11:55 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Soeren Sandmann Pedersen <sandmann@redhat.com>, a.p.zijlstra@chello.nl,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [022/119] highmem: Fix debug_kmap_atomic() to also handle
 KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE
In-Reply-To: <20091207000643.892734717@mini.kroah.org>
Message-ID: <Pine.LNX.4.64.0912070105370.2642@sister.anvils>
References: <20091206235936.208334321@mini.kroah.org> <20091207000643.892734717@mini.kroah.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009, Greg KH wrote:

> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Soeren Sandmann <sandmann@daimi.au.dk>
> 
> commit d4515646699b6ad7b1a98ceb871296b957f3ef47 upstream.
> 
> Previously calling debug_kmap_atomic() with these types would
> cause spurious warnings.
> 
> (triggered by SysProf using perf events)
> 
> Signed-off-by: Soeren Sandmann Pedersen <sandmann@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: a.p.zijlstra@chello.nl
> LKML-Reference: <ye8vdhz8krw.fsf@camel23.daimi.au.dk>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

IIRC, this patch caused build failures in a number of architectures,
those which didn't already define KM_NMI, KM_NMI_PTE or KM_IRQ_PTE
e.g. compare the 2.6.32 arch/arm/include/asm/kmap_types.h against
its 2.6.31 version.

Should be fixable if you include the extras necessary, but I'm
ashamed to say I've left that as an exercise for the reader ;)

Hugh

> 
> ---
>  mm/highmem.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -432,10 +432,15 @@ void debug_kmap_atomic(enum km_type type
>  		return;
>  
>  	if (unlikely(in_interrupt())) {
> -		if (in_irq()) {
> +		if (in_nmi()) {
> +			if (type != KM_NMI && type != KM_NMI_PTE) {
> +				WARN_ON(1);
> +				warn_count--;
> +			}
> +		} else if (in_irq()) {
>  			if (type != KM_IRQ0 && type != KM_IRQ1 &&
>  			    type != KM_BIO_SRC_IRQ && type != KM_BIO_DST_IRQ &&
> -			    type != KM_BOUNCE_READ) {
> +			    type != KM_BOUNCE_READ && type != KM_IRQ_PTE) {
>  				WARN_ON(1);
>  				warn_count--;
>  			}
> @@ -452,7 +457,9 @@ void debug_kmap_atomic(enum km_type type
>  	}
>  
>  	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
> -			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ) {
> +			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ ||
> +			type == KM_IRQ_PTE || type == KM_NMI ||
> +			type == KM_NMI_PTE ) {
>  		if (!irqs_disabled()) {
>  			WARN_ON(1);
>  			warn_count--;
> 
> 
> --
