Return-Path: <linux-kernel-owner+w=401wt.eu-S940069AbXHIMxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940069AbXHIMxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763610AbXHIMxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:53:11 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:34738
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756385AbXHIMxJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:53:09 -0400
Message-Id: <46BB2AA3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 09 Aug 2007 13:54:27 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [patches] [PATCH] [4/12] x86_64: Disable CLFLUSH support
	again
References: <20070809241.425881000@suse.de>
 <20070809124131.B6E6114F3B@wotan.suse.de>
In-Reply-To: <20070809124131.B6E6114F3B@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The 64-bit conditional seems wrong to me, I'd assume you mean

	if (1 || !cpu_has_clflush)

Jan

>>> Andi Kleen <ak@suse.de> 09.08.07 14:41 >>>

It turns out CLFLUSH support is still not complete; we
flush the wrong pages.  Again disable it for the release.
Noticed by Jan Beulich.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/pageattr.c   |    2 +-
 arch/x86_64/mm/pageattr.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/i386/mm/pageattr.c
===================================================================
--- linux.orig/arch/i386/mm/pageattr.c
+++ linux/arch/i386/mm/pageattr.c
@@ -82,7 +82,7 @@ static void flush_kernel_map(void *arg)
 	struct page *p;
 
 	/* High level code is not ready for clflush yet */
-	if (cpu_has_clflush) {
+	if (0 && cpu_has_clflush) {
 		list_for_each_entry (p, lh, lru)
 			cache_flush_page(p);
 	} else if (boot_cpu_data.x86_model >= 4)
Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -75,7 +75,8 @@ static void flush_kernel_map(void *arg)
 
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
-	if (!cpu_has_clflush)
+	/* clflush is still broken. Disable for now. */
+	if (0 && !cpu_has_clflush)
 		asm volatile("wbinvd" ::: "memory");
 	else list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
_______________________________________________
patches mailing list
patches@x86-64.org 
https://www.x86-64.org/mailman/listinfo/patches

