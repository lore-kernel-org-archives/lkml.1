Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYKFVsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYKFVsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYKFVs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:48:27 -0500
Received: from gw.goop.org ([64.81.55.164]:33211 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbYKFVs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:48:26 -0500
Message-ID: <49136628.1020000@goop.org>
Date: Thu, 06 Nov 2008 13:48:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
       "Christopher S. Aker" <caker@theshore.net>,
       xen devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] 2.6.27 - SMP enabled, but only 1 CPU
References: <48F3BC99.5040409@theshore.net> <490F5F50.7020704@theshore.net> <4910AD00.7040605@theshore.net> <4911BC52.7040905@theshore.net> <1225994697.12607.837.camel@zakaz.uk.xensource.com> <49134257.4000404@goop.org> <20081106211639.GA24579@elte.hu> <49136168.3040604@goop.org> <20081106213344.GF24579@elte.hu>
In-Reply-To: <20081106213344.GF24579@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> where exactly is that use? My grep didnt show any users of pud_page(). 
> pud_page() was changed in an incompatible way, all users of it must be 
> updated.
>   

pgd_page() uses it in pgtable-nopud.h, so any users of pgd_page() also 
need to be looked at.  It so happens the only user is 
arch/x86/xen/mmu.c, which expects it to return the vaddr.  Fixed below.

    J

Subject: xen: fix use of pgd_page now that it really does return a page

On 32-bit PAE, pud_page, for no good reason, didn't really return a
struct page *.  Since Jan Beulich's fix "i386/PAE: fix pud_page()",
pud_page does return a struct page *.

Because PAE has 3 pagetable levels, the pud level is folded into the
pgd level, so pgd_page() is the same as pud_page(), and now returns
a struct page *.  Update the xen/mmu.c code which uses pgd_page()
accordingly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -877,7 +877,7 @@
 #else /* CONFIG_X86_32 */
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is pinnable */
-	xen_pin_page(mm, virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])),
+	xen_pin_page(mm, pgd_page(pgd[pgd_index(TASK_SIZE)]),
 		     PT_PMD);
 #endif
 	xen_do_pin(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(pgd)));
@@ -994,7 +994,7 @@
 
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is unpinned */
-	xen_unpin_page(mm, virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])),
+	xen_unpin_page(mm, pgd_page(pgd[pgd_index(TASK_SIZE)]),
 		       PT_PMD);
 #endif
 


