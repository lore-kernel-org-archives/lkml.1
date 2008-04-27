Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbYD0NLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbYD0NLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 09:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbYD0NLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 09:11:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46590 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbYD0NLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 09:11:30 -0400
Date: Sun, 27 Apr 2008 15:11:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: x86 pat.c:phys_mem_access_prot_allowed() bogosity
Message-ID: <20080427131111.GA2569@elte.hu>
References: <20080427123120.GZ2252@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427123120.GZ2252@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Adrian Bunk <bunk@kernel.org> wrote:

> Commit e7f260a276f2c9184fe753732d834b1f6fbe9f17
> (x86: PAT use reserve free memtype in mmap of /dev/mem)
> added the following gem to arch/x86/mm/pat.c:
> 
> <--  snip  -->
> 
> ...
> int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
>                                 unsigned long size, pgprot_t *vma_prot)
> {
>         u64 offset = ((u64) pfn) << PAGE_SHIFT;
>         unsigned long flags = _PAGE_CACHE_UC_MINUS;
>         unsigned long ret_flags;
> ...
> ...  (nothing that touches ret_flags)
> ...
>         if (flags != _PAGE_CACHE_UC_MINUS) {
>                 retval = reserve_memtype(offset, offset + size, flags, NULL);
>         } else {
>                 retval = reserve_memtype(offset, offset + size, -1, &ret_flags);
>         }
> 
>         if (retval < 0)
>                 return 0;
> 
>         flags = ret_flags;
> 
>         if (pfn <= max_pfn_mapped &&
>             ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
>                 free_memtype(offset, offset + size);
>                 printk(KERN_INFO
>                 "%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
>                         current->comm, current->pid,
>                         cattr_name(flags),
>                         offset, offset + size);
>                 return 0;
>         }
> 
>         *vma_prot = __pgprot((pgprot_val(*vma_prot) & ~_PAGE_CACHE_MASK) |
>                              flags);
>         return 1;
> }
> 
> <--  snip  -->
> 
> If (flags != _PAGE_CACHE_UC_MINUS) we pass garbage from the stack to 
> ioremap_change_attr() and/or __pgprot().
> 
> Spotted by the Coverity checker.

thanks Adrian - i've queued up the fix below.

Venkatesh, the code flow in reserve_memtype() is still as simple as it 
could be i believe - and the code flow complication directly resulted in 
this bug.

For example we should never pass in a NULL flags pointer - that way we 
could get rid of the NULL pointer checking - just fill in the return 
value unconditionally and just dont use it in the return site if not 
needed.

Another area to improve would be to merge the return code and the flags 
value - i.e. to not pass in a return value pointer at all. All 
_PAGE_CACHE_* flags are positive integers, so using negatives as a 
failure condition would still be OK. The special '-1 == wildcard' 
meaning for flags could still be kept. Hm?

	Ingo

-------------------->
Subject: x86: PAT fix
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Mar 21 15:42:28 CET 2008

Adrian Bunk noticed the following Coverity report:

> Commit e7f260a276f2c9184fe753732d834b1f6fbe9f17
> (x86: PAT use reserve free memtype in mmap of /dev/mem)
> added the following gem to arch/x86/mm/pat.c:
>
> <--  snip  -->
>
> ...
> int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
>                                 unsigned long size, pgprot_t *vma_prot)
> {
>         u64 offset = ((u64) pfn) << PAGE_SHIFT;
>         unsigned long flags = _PAGE_CACHE_UC_MINUS;
>         unsigned long ret_flags;
> ...
> ...  (nothing that touches ret_flags)
> ...
>         if (flags != _PAGE_CACHE_UC_MINUS) {
>                 retval = reserve_memtype(offset, offset + size, flags, NULL);
>         } else {
>                 retval = reserve_memtype(offset, offset + size, -1, &ret_flags);
>         }
>
>         if (retval < 0)
>                 return 0;
>
>         flags = ret_flags;
>
>         if (pfn <= max_pfn_mapped &&
>             ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
>                 free_memtype(offset, offset + size);
>                 printk(KERN_INFO
>                 "%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
>                         current->comm, current->pid,
>                         cattr_name(flags),
>                         offset, offset + size);
>                 return 0;
>         }
>
>         *vma_prot = __pgprot((pgprot_val(*vma_prot) & ~_PAGE_CACHE_MASK) |
>                              flags);
>         return 1;
> }
>
> <--  snip  -->
>
> If (flags != _PAGE_CACHE_UC_MINUS) we pass garbage from the stack to
> ioremap_change_attr() and/or __pgprot().
>
> Spotted by the Coverity checker.

the fix simplifies the code as we get rid of the 'ret_flags'
complication.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pat.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-x86.q/arch/x86/mm/pat.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/pat.c
+++ linux-x86.q/arch/x86/mm/pat.c
@@ -510,7 +510,6 @@ int phys_mem_access_prot_allowed(struct 
 {
 	u64 offset = ((u64) pfn) << PAGE_SHIFT;
 	unsigned long flags = _PAGE_CACHE_UC_MINUS;
-	unsigned long ret_flags;
 	int retval;
 
 	if (!range_is_allowed(pfn, size))
@@ -549,14 +548,12 @@ int phys_mem_access_prot_allowed(struct 
 	if (flags != _PAGE_CACHE_UC_MINUS) {
 		retval = reserve_memtype(offset, offset + size, flags, NULL);
 	} else {
-		retval = reserve_memtype(offset, offset + size, -1, &ret_flags);
+		retval = reserve_memtype(offset, offset + size, -1, &flags);
 	}
 
 	if (retval < 0)
 		return 0;
 
-	flags = ret_flags;
-
 	if (pfn <= max_pfn_mapped &&
             ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
 		free_memtype(offset, offset + size);
