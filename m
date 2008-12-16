Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYLPSsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYLPSsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYLPSsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:48:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53041 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYLPSsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:48:03 -0500
Date: Tue, 16 Dec 2008 19:47:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Martin Steigerwald <ms@teamix.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: physical memory limit of 64-bit linux
Message-ID: <20081216184742.GL11683@elte.hu>
References: <200812161556.25518.ms@teamix.de> <200812161654.17291.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161654.17291.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Tuesday, 16 of December 2008, Martin Steigerwald wrote:
> > 
> > Hi!
> > 
> > What is the physical memory limit for 64-bit Linux? I read about 40 
> > bit address bus for AMD Athlon X2 (1 TB) and 48 bit for Barcelona X4 
> > (256 TB).
> > 
> > Is 64-bit linux able to use that amount - provided that one would 
> > manage to build it into a machine? Or does it have a lower limit?
> > 
> > Looking into the Google crystal ball gives unclear pictures... I tend 
> > to assume that Linux would handle it, but I am not sure.
> 
> IIRC, the current maximal virtual memory space size of the kernel on 
> x86_64 is 2^46.

Almost: the real current upstream kernel hard memory limit on x86-64 is 44 
bits, i.e. 16 TB.

There's a couple of limits to consider here.

Firstly, there's the architectural limit imposed by the CPU - that is 48 
bits, 256 TB. That is the full virtual memory range that x86-64 CPUs are 
able to address: non-canonical addresses outside that range create an 
exception.

I.e. valid addresses on x86-64 are in the range of:

        [ 0xffff800000000000...0x00007fffffffffff ]

Which is minus 128 TB to plus 128 TB.

Traditionally (and because it's practical) that max range is split in two: 
negative addresses to kernel-space-only addresses [the same on all tasks], 
positive addresses to user-space addresses [unique to each process MM].

The kernel starts at minus 122 TB, far far down, to take maximum advantage 
of the negative range:

  arch/x86/include/asm/page_64.h:
  #define __PAGE_OFFSET           _AC(0xffff880000000000, UL)

(and we start with an 8 TB empty-mapped hole range. )

That is where all physical memory is mapped to, linearly. Then we have a 
64 TB limit imposed on the maximum size of this linear kernel memory 
range:

  #define MAXMEM           _AC(0x00003fffffffffff, UL)

that is sized a bit optimistically - it ends at ffffc7ffffffffff, which 
overlaps by 2TB into the vmalloc area, which starts at:

  #define VMALLOC_START    _AC(0xffffc20000000000, UL)

We want to set MAXMEM to VMALLOC_START-hole instead, where the hole is say 
0x20000000000. (2 TB)

This problem is academic because there are no such systems in existence, 
and because we have another limit on the size of physical memory:

  arch/x86/include/asm/sparsemem.h:
  # define MAX_PHYSMEM_BITS	44

So in reality MAXMEM should be limited to the max sparsemem-covered 
physical memory range, via the patch below.

In terms of future extensibility:

phase 1)  We could go to 45 bits (32 TB) via a twoliner patch,
          should the need arise

phase 2)  We can then go to 46 bits (64 TB) with small changes too - by 
          moving the vmalloc area up a notch and moving the followon 
          dynamic kernel mappings areas too.

phase 3)  We could also go close to 47 bits: with various more invasive
          movings of VMALLOC and rest upwards, and other considerations
          such as the elimination of the generous start of 8 TB hole at
          __PAGE_OFFSET - i.e. moving __PAGE_OFFSET straight down to
          minus 128 TB. 120 TB would be doable.

phase 4)  If the 48 bits limit is ever lifted on the CPU side, we can move
          __PAGE_OFFSET down. This is actually less invasive than phase 
          3), because moving __PAGE_OFFSET is relatively easy. The far
          more invasive change would be the necessary changes to the
          virtual memory code: the current 4-level paging has a 256 TB 
          limit which comes from the 512*512*512*512*4K split of 
          pgd/pud/pmd/pte entries. Either PGDIR_SHIFT would have to be 
          increased, moving the root pgtable's size from 4K to 8K or more, 
          or another pgdir level would have to be introduced (which is 
          even more intrusive and much less likely to be implemented by hw
          makers).

	Ingo

-------------------->
>From b6fd6f26733e864fba2ea3eb1d716e23d2e66f3a Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 16 Dec 2008 19:23:36 +0100
Subject: [PATCH] x86, mm: limit MAXMEM on 64-bit

on 64-bit x86 the physical memory limit is controlled by the sparsemem
bits - which are 44 bits right now. But MAXMEM (the max pfn number
e820 parsing will allow to enter our sizing routines) is set to
0x00003fffffffffff, i.e. 46 bits - that's too large because it overlaps
into the vmalloc range.

So couple MAXMEM to MAX_PHYSMEM_BITS, and add a comment that the
maximum of MAX_PHYSMEM_BITS is 45 bits.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/pgtable_64.h |    2 +-
 arch/x86/include/asm/sparsemem.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 65b6be6..c54ba69 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -146,7 +146,7 @@ static inline void native_pgd_clear(pgd_t *pgd)
 #define PGDIR_MASK	(~(PGDIR_SIZE - 1))
 
 
-#define MAXMEM		 _AC(0x00003fffffffffff, UL)
+#define MAXMEM		 _AC(__AC(1, UL) << MAX_PHYSMEM_BITS, UL)
 #define VMALLOC_START    _AC(0xffffc20000000000, UL)
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
diff --git a/arch/x86/include/asm/sparsemem.h b/arch/x86/include/asm/sparsemem.h
index be44f7d..e3cc3c0 100644
--- a/arch/x86/include/asm/sparsemem.h
+++ b/arch/x86/include/asm/sparsemem.h
@@ -27,7 +27,7 @@
 #else /* CONFIG_X86_32 */
 # define SECTION_SIZE_BITS	27 /* matt - 128 is convenient right now */
 # define MAX_PHYSADDR_BITS	44
-# define MAX_PHYSMEM_BITS	44
+# define MAX_PHYSMEM_BITS	44 /* Can be max 45 bits */
 #endif
 
 #endif /* CONFIG_SPARSEMEM */
