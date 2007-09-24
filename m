Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbXIXIbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbXIXIbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbXIXIa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:30:59 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:7294
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754745AbXIXIa6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:30:58 -0400
Message-Id: <46F79221.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 24 Sep 2007 09:32:01 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [patches] [PATCH] [15/50] x86_64: Return EINVAL for
	unknown addressin change_page_attr
References: <200709221231.836138000@suse.de>
 <20070921223213.D92CC13DCD@wotan.suse.de>
In-Reply-To: <20070921223213.D92CC13DCD@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This should be accompanied by

 			addr2 = __START_KERNEL_map + __pa(address);
 			/* Make sure the kernel mappings stay executable */
 			prot2 = pte_pgprot(pte_mkexec(pfn_pte(0, prot)));
-			err = __change_page_attr(addr2, pfn, prot2,
+			(void)__change_page_attr(addr2, pfn, prot2,
 						 kref_prot(addr2));
 		} 
 	} 	

as otherwise it is non-obvious why there's no check of err (which so far really
was missing). The reason this must be tolerated here is free_init_pages()/
free_initmem() removing the translation for the affected kernel image pages
altogether.

Jan

>>> Andi Kleen <ak@suse.de> 22.09.07 00:32 >>>

Matches what i386 does and makes more sense.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/mm/pageattr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -151,7 +151,9 @@ __change_page_attr(unsigned long address
 	pgprot_t ref_prot2;
 
 	kpte = lookup_address(address);
-	if (!kpte) return 0;
+	if (!kpte)
+		return -EINVAL;
+
 	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
 	BUG_ON(PageCompound(kpte_page));
 	BUG_ON(PageLRU(kpte_page));
_______________________________________________
patches mailing list
patches@x86-64.org 
https://www.x86-64.org/mailman/listinfo/patches

