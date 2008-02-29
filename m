Return-Path: <linux-kernel-owner+w=401wt.eu-S933594AbYB2WFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbYB2WFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYB2WFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:05:02 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:1317 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbYB2WE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:04:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uQBj5Gx86rbXyPewlUB4nlAkS9xiwtNpqEnI9krHfKoXhsilHMBnzUBA1L2OJiIBC1gz9/+w1tTXKrhMpulihX0PUHXCydZ6wp5av67BqSJi5xF9Dz8wShv8JuLfQnkRxBd+a+wbhQFhUd+AU/AabhsswKjK3DSY2bmyZAZWr+4=
Message-ID: <6101e8c40802291404u49037ad9u4347f552ce72bf28@mail.gmail.com>
Date: Fri, 29 Feb 2008 23:04:58 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86: potential ioremap() issues
Cc: "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20080228132404.GB18551@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
References: <47C6BE37.76E4.0078.0@novell.com> <20080228132404.GB18551@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m1TM5Lnq002736

Hi Ingo!
this patch is needed for 2.6.22 kernel? I see, this code inarch/x86_64/mm/ioremap.c
/* a kérdés az, hogy ezt a patchet backportoljam 2.6.22 alá vagy ne?x86_64 alatt megtaláltam a cserélendõ kódrészt... * köszönöm a választ */On 2/28/08, Ingo Molnar <mingo@elte.hu> wrote:>> * Jan Beulich <jbeulich@novell.com> wrote:>> > Ingo,> >> > with the new ioremap() implementation I see a couple of (potential)> > issues:> > - When ioremap_page_range() fails, remove_vm_area() is used rather> > than vunmap() - I think this will cause a 'struct vm_struct' leak.>> indeed, good catch - could you check whether the patch below fixes this?> I also pushed this out into x86.git#testing, which you can pick up via:>> http://people.redhat.com/mingo/x86.git/README>> > - While ioremap() continues to happily map RAM pages (with a bogus> > [see below] WARN_ON_ONCE()), cacheability of the memory is not> > being restored in iounmap().>> correct - these are never supposed to be 'true', generally allocated RAM> pages - or like we do with AGP where the pages are exclusively owned we> restore their cacheability explicitly.>> > - The check for RAM pages (except for the WARN_ON_ONCE())> > continues to be applied only to lowmem pages.>> yes, the biggest constraint from ioremap comes when it applies to pages> that are mapped by the kernel. But i guess we could extend this to all> things RAM ... the second patch below does this. What do you think? I've> queued this up in x86.git#testing as well.>> > - The WARN_ON_ONCE() itself is applied to the pfn after the> > preceding loop finished, i.e. to a pfn that doesn't actually participate> > in the operation. Shouldn't it be moved inside the loop?>> i removed the WARN_ON_ONCE() from x86.git a few days ago, it's lined up> for the next push.>> Ingo>> --------------------->> Subject: x86: fix leak un ioremap_page_range() failure> From: Ingo Molnar <mingo@elte.hu>> Date: Thu Feb 28 14:02:08 CET 2008>> Jan Beulich noticed that if a driver's ioremap() fails (say due to -ENOMEM)> then we might leak the struct vm_area - free it properly.>> Signed-off-by: Ingo Molnar <mingo@elte.hu>> ---> arch/x86/mm/ioremap.c | 2 +-> 1 file changed, 1 insertion(+), 1 deletion(-)>> Index: linux-x86.q/arch/x86/mm/ioremap.c> ===================================================================> --- linux-x86.q.orig/arch/x86/mm/ioremap.c> +++ linux-x86.q/arch/x86/mm/ioremap.c> @@ -179,7 +179,7 @@ static void __iomem *__ioremap(unsigned> area->phys_addr = phys_addr;> vaddr = (unsigned long) area->addr;> if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {> -	remove_vm_area((void *)(vaddr & PAGE_MASK));> +	free_vm_area(area);> return NULL;> }>> ------------------->> Subject: x86: ioremap(), extend check to all RAM pages> From: Ingo Molnar <mingo@elte.hu>> Date: Thu Feb 28 14:10:49 CET 2008>> Signed-off-by: Ingo Molnar <mingo@elte.hu>> ---> arch/x86/mm/ioremap.c | 5 +++--> 1 file changed, 3 insertions(+), 2 deletions(-)>> Index: linux-x86.q/arch/x86/mm/ioremap.c> ===================================================================> --- linux-x86.q.orig/arch/x86/mm/ioremap.c> +++ linux-x86.q/arch/x86/mm/ioremap.c> @@ -146,8 +146,9 @@ static void __iomem *__ioremap(unsigned> /*> * Don't allow anybody to remap normal RAM that we're using..> */> -	for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&> -	(pfn << PAGE_SHIFT) < last_addr; pfn++) {> +	for (pfn = phys_addr >> PAGE_SHIFT;> +	(pfn << PAGE_SHIFT) < last_addr; pfn++) {> +> if (page_is_ram(pfn) && pfn_valid(pfn) &&> !PageReserved(pfn_to_page(pfn)))> return NULL;> --> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at http://vger.kernel.org/majordomo-info.html> Please read the FAQ at http://www.tux.org/lkml/>--Thanks,Oliverÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
