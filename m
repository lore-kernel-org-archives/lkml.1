Return-Path: <linux-kernel-owner+w=401wt.eu-S1764867AbXGUUQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764867AbXGUUQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 16:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761113AbXGUUQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 16:16:44 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:30091 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483AbXGUUQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 16:16:43 -0400
Date: Sat, 21 Jul 2007 23:16:34 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
Message-ID: <20070721201634.GF1193@rhun.ibm.com>
References: <1184885740.16311.19.camel@t60> <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org> <20070721181137.GH4152@rhun.haifa.ibm.com> <46A263FA.70501@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A263FA.70501@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 12:52:26PM -0700, H. Peter Anvin wrote:
> Muli Ben-Yehuda wrote:
> >
> > Mostly looks good, but see below.
> >
> >> diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
> >> index df8da72..41f46df 100644
> >> --- a/drivers/char/agp/efficeon-agp.c
> >> +++ b/drivers/char/agp/efficeon-agp.c
> >> @@ -221,7 +221,7 @@ static int efficeon_create_gatt_table(struct agp_bridge_data *bridge)
> >>  		SetPageReserved(virt_to_page((char *)page));
> >>
> >>  		for (offset = 0; offset < PAGE_SIZE; offset += clflush_chunk)
> >> -			asm volatile("clflush %0" : : "m" (*(char *)(page+offset)));
> >> +			clflush((char *)page+offset);
> >
> > The original code flushes (*(page+offset)) whereas the new code
> > flushes (pagee+offset). Assuming this is a bug-fix, it should go as a
> > separate patch.
>
> No, it doesn't.  There is a * in the inline, as there should be.

I guess I don't follow. Compare:

diff --git a/arch/i386/mm/pageattr.c b/arch/i386/mm/pageattr.c
index 37992ff..cb4ded4 100644
--- a/arch/i386/mm/pageattr.c
+++ b/arch/i386/mm/pageattr.c
@@ -70,10 +70,10 @@ static struct page *split_large_page(unsigned long
address, pgprot_t prot,

 static void cache_flush_page(struct page *p)
 {
-       unsigned long adr = (unsigned long)page_address(p);
+       void *adr = page_address(p);
        int i;
        for (i = 0; i < PAGE_SIZE; i +=
        boot_cpu_data.x86_clflush_size)
-               asm volatile("clflush (%0)" :: "r" (adr + i));
+               clflush(adr+i);
 }

Original code: clflush (adr + i).
New code: clflush (adr + i)

diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index df8da72..41f46df 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -221,7 +221,7 @@ static int efficeon_create_gatt_table(struct agp_bridge_data *bridge)
 		SetPageReserved(virt_to_page((char *)page));

 		for (offset = 0; offset < PAGE_SIZE; offset += clflush_chunk)
-			asm volatile("clflush %0" : : "m" (*(char *)(page+offset)));
+			clflush((char *)page+offset);

Original code: clflush *(page + offset)
                       ^
New code: clflush (page + offset)

So it looks like we have a purely syntactic patch that does something
different than the original code in one of the above places. What am I
missing?

Cheers,
Muli
