Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZFURNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZFURNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 13:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbZFURNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 13:13:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752435AbZFURNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 13:13:36 -0400
Date: Sun, 21 Jun 2009 10:13:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@linux.ie>
cc: Andy Lutomirski <luto@mit.edu>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm: previous pull req + 1.
In-Reply-To: <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie> <4A3DABE1.50309@mit.edu> <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie> <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Jun 2009, Linus Torvalds wrote:
> 
> Dave - no amount of userspace differences make a corrupted page table 
> acceptable. 
> 
> This needs to be fixed. No excuses. Kernel crashes are never an issue of 
> "you used the wrong user space".

So "corrupted page table" means that one of the reserved bits was set, and 
we get a page fault with the PF_RSVD bit on in the error code.

Looking at the debug output, it says

	PGD        12148a067
	PUD        12148b067
	PMD        121496067
	PTE ffffc90011780237

where the top-level entries look fine, but the PTE is total crap. It looks 
like it has filled in the page frame number with a virtual address rather 
than with an actual page

The PTE _should_ look like this:

 - bit 63: NX
 - bits 62-52: zero (available to sw, but I don't think we use them)
 - bits 51-47: zero (reserved)
 - bits 46-12: page frame
 - bits 11-0: protection and PAT bits etc (bits 8-7 are also reserved)

and that PTE clearly does not match.

Strictly speaking, that "47-bit" physical address is purely theoretical. I 
think existing CPU's are limited to 40 bits or so, so there are even more 
reserved bits. 

Anyway, here's a totally UNTESTED patch that hopefully gives a warning on 
where exactly we set the invalid bits. Andy, mind trying it out? You 
should get the warnign much earlier, and it should have a much more useful 
back-trace.

(But this is _untested_, so maybe I screwed up and it doesn't compile or 
work. The BAD_PTE_BITS mask could also be improved upon, but that mask 
should be "good enough" - it doesn't include _all_ the bits it could, 
but it certainly has enough bits set to trigger that obviously bad case).

			Linus

---
 arch/x86/include/asm/pgtable_64.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index c57a301..b95828e 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -49,8 +49,11 @@ static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr,
 	*ptep = native_make_pte(0);
 }
 
+#define BAD_PTE_BITS (_PAGE_NX - (1ul << __PHYSICAL_MASK_SHIFT))
+
 static inline void native_set_pte(pte_t *ptep, pte_t pte)
 {
+	WARN_ON_ONCE(pte.pte & BAD_PTE_BITS);
 	*ptep = pte;
 }
 
