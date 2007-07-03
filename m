Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbXGCT0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbXGCT0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbXGCT0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:26:43 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:58260 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbXGCT0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=XcRoE0jwMQBMOX3BpRCEX7zw6fEF2moyXs1cHgJ/hPHGmAvrhKo+/kHAzftPLmVjexwqMnA8bJgdp/7l3uZOZ1IEU/vFU/MSB+ikZUmGyTnsw7W4qEFjnM//gcEGny4P5vBm5aGFus+CV71u9JkvCaqN/ZDFNaMGCwD8s608/lE=
Date: Tue, 3 Jul 2007 21:20:04 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] i386 CPA fix - do not free reserved pages
Message-ID: <20070703191305.GB31909@slug>
References: <20070703150656.4f618dd5@the-village.bc.nu> <20070703153747.GA28808@Krystal> <20070703162640.GA31909@slug> <20070703173324.GA1461@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703173324.GA1461@Krystal>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 01:33:24PM -0400, Mathieu Desnoyers wrote:
> Right, there is a test missing, can you try this fix on top of my
> x86_64 mm cpa cache flush fix ?
No warning with both patches applied, thanks Mathieu.

Frederik
> 
> 
> i386 CPA fix - do not free reserved pages
> 
> We have to use the same conditions found in change_page_attr in
> global_tlb_flush regarding the conditions that leads to free the page.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  arch/i386/mm/pageattr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/arch/i386/mm/pageattr.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/i386/mm/pageattr.c	2007-07-03 13:25:48.000000000 -0400
> +++ linux-2.6-lttng/arch/i386/mm/pageattr.c	2007-07-03 13:28:34.000000000 -0400
> @@ -247,7 +247,7 @@
>  	list_for_each_entry_safe(pg, next, &l, lru) {
>  		clear_bit(PG_arch_1, &pg->flags);
>  		list_del(&pg->lru);
> -		if (page_private(pg) != 0)
> +		if (PageReserved(pg) || !cpu_has_pse || page_private(pg) != 0)
>  			continue;
>  		ClearPagePrivate(pg);
>  		__free_page(pg);
> 
> 
> * Frederik Deweerdt (deweerdt@free.fr) wrote:
> > On Tue, Jul 03, 2007 at 11:37:47AM -0400, Mathieu Desnoyers wrote:
> > > Hi Alan,
> > > 
> > > I already sent a fix to Andrew and Andi for this (hrm, forget to CC
> > > lkml on the original message):
> > > 
> > > 
> > > x86_64 mm cpa cache flush fix
> > > 
> > > X86_64 and i386 cpa cache flush fix:
> > > 
> > > list_del the deferred list entries to poison their pointers.
> > > clear the flag for every page put in the list.
> > > 
> > Hi Mathieu,
> > 
> > I've tried the patch on rc6-mm1, but it doesn't seem to fix the
> > problem. From what I understood, the bad_page() is called on PG_reserved
> > being set (flags:0x00000400), not the lru pointer being not NULL or
> > PG_arch_1 being set.
> > 
> > Regards,
> > Frederik
> > 
> > > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > CC: Andi Kleen <ak@suse.de>
> > [...]
> > >  	flush_map(&l);
> > >  	list_for_each_entry_safe(pg, next, &l, lru) {
> > > +		clear_bit(PG_arch_1, &pg->flags);
> > > +		list_del(&pg->lru);
> > >  		if (page_private(pg) != 0)
> > >  			continue;
> > >  		ClearPagePrivate(pg);
> > > -		clear_bit(PG_arch_1, &pg->flags);
> > >  		__free_page(pg);
> > >  	}
> > >  }
> > [...]
> > > * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > > > X86 32bit with lots of debug turned on I get this:
> > [...]
> > > > Bad page state in process 'swapper'
> > > > page:c10000c0 flags:0x00000400 mapping:00000000 mapcount:0 count:0
> > > > Trying to fix it up, but a reboot is needed
> > > > Backtrace:
> > > >  [<c024589c>] bad_page+0x6c/0x100
> > > >  [<c024648d>] free_hot_cold_page+0x5d/0x140
> > > >  [<c02116c2>] global_flush_tlb+0x112/0x130
> > > >  [<c020102d>] init_post+0xd/0xe0
> > > >  [<c047c876>] kernel_init+0x216/0x220
> > > >  [<c0214c50>] schedule_tail+0x0/0xe0
> > > >  [<c047c660>] kernel_init+0x0/0x220
> > > >  [<c047c660>] kernel_init+0x0/0x220
> > > >  [<c0204227>] kernel_thread_helper+0x7/0x10
> > > >  =======================
> > > > Hexdump:
> > > > 000: 00 06 00 00 01 00 00 00 ff ff ff ff 0f 00 00 00
> > > > 010: 00 00 00 00 00 00 00 00 78 00 00 c1 b8 00 00 c1
> > > > 020: 00 06 00 00 01 00 00 00 ff ff ff ff a7 03 00 00
> > > > 030: 00 00 00 00 00 00 00 00 98 00 00 c1 d8 00 00 c1
> > > > 040: 00 04 00 00 00 00 00 00 ff ff ff ff 00 00 00 00
> > > > 050: 00 00 00 00 00 00 00 00 b8 00 00 c1 f8 00 00 c1
> > > > 060: 00 06 00 00 01 00 00 00 ff ff ff ff 00 04 00 00
> > > > 070: 00 00 00 00 00 00 00 00 d8 00 00 c1 18 01 00 c1
> > > > 080: 00 06 00 00 01 00 00 00 ff ff ff ff 9c 03 00 00
> > > > 090: 00 00 00 00 00 00 00 00 f8 00 00 c1 38 01 00 c1
> > > > 0a0: 00 06 00 00 01 00 00 00 ff ff ff ff 00 04 00 00
> > > > 0b0: 00 00 00 00 00 00 00 00 18 01 00 c1 58 01 00 c1
> > > > -
> > > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > Please read the FAQ at  http://www.tux.org/lkml/
> > > > 
> > > 
> > > -- 
> > > Mathieu Desnoyers
> > > Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > > 
> > 
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
