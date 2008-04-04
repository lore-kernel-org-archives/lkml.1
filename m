Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYDDMT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYDDMT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbYDDMTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:19:18 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:39584
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162AbYDDMTR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:19:17 -0400
Message-Id: <47F638FD.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 04 Apr 2008 13:19:41 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <hpa@kernel.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: additional fix for making ioremap() accept
	64-bit addresses
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent change to __ioremap()'s first parameter's type didn't yield
the intended effect as the first conditional inside the function would
still have filtered out any addresses with bits [63:32] set. Correct
last_addr's type and at once also add a check that the address range
doesn't extend into space hardware cannot support even theoretically.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: H. Peter Anvin <hpa@kernel.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/mm/ioremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.25-rc8/arch/x86/mm/ioremap.c	2008-04-02 16:21:19.000000000 +0200
+++ 2.6.25-rc8-i386-ioremap-64bit/arch/x86/mm/ioremap.c	2008-04-02 15:21:42.000000000 +0200
@@ -109,13 +109,14 @@ static int ioremap_change_attr(unsigned 
 static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
 			       enum ioremap_mode mode)
 {
-	unsigned long pfn, offset, last_addr, vaddr;
+	unsigned long pfn, offset, vaddr;
+	resource_size_t last_addr;
 	struct vm_struct *area;
 	pgprot_t prot;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
-	if (!size || last_addr < phys_addr)
+	if (!size || last_addr < phys_addr || last_addr > __PHYSICAL_MASK)
 		return NULL;
 
 	/*



