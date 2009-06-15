Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbZFOPbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbZFOPbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZFOPbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:31:46 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:17992 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbZFOPbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:31:45 -0400
X-Trace: 215178253/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.41.232/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.41.232
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnECAIsGNkpQKSno/2dsb2JhbAAI1VuEDQU
X-IronPort-AV: E=Sophos;i="4.42,223,1243810800"; 
   d="scan'208";a="215178253"
Date: Mon, 15 Jun 2009 16:30:51 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, efault@gmx.de, npiggin@suse.de,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
In-Reply-To: <1245077165.6800.497.camel@laptop>
Message-ID: <Pine.LNX.4.64.0906151623570.5225@sister.anvils>
References: <tip-3ff0141aa3a03ca3388b40b36167d0a37919f3fd@git.kernel.org>
 <1245077165.6800.497.camel@laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Peter Zijlstra wrote:
> 
> The below would fix it, but that's getting rather ugly :-/,
> alternatively I would have to introduce something like
> pte_offset_map_irq() which would make the irq/nmi detection and leave
> the regular code paths alone, however that would mean either duplicating
> the gup_fast() pagewalk or passing down a pte function pointer, which
> would only duplicate the gup_pte_range() bit, neither is really
> attractive...

> Index: linux-2.6/arch/x86/include/asm/pgtable_32.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/pgtable_32.h
> +++ linux-2.6/arch/x86/include/asm/pgtable_32.h
> @@ -49,7 +49,10 @@ extern void set_pmd_pfn(unsigned long, u
>  #endif
>  
>  #if defined(CONFIG_HIGHPTE)
> -#define __KM_PTE	(in_nmi() ? KM_NMI_PTE : KM_PTE0)
> +#define __KM_PTE			\
> +	(in_nmi() ? KM_NMI_PTE : 	\
> +	 in_irq() ? KM_IRQ_PTE :	\
> +	 KM_PTE0)
>  #define pte_offset_map(dir, address)					\
>  	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), __KM_PTE) +		\
>  	 pte_index((address)))

Yes, that does look ugly!

I've not been following the background to this, but I've often
wondered if a kmap_push() and kmap_pop() could be useful,
allowing you to reuse the slot in between - any use here?

Hugh
