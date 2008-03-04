Return-Path: <linux-kernel-owner+w=401wt.eu-S1764446AbYCDMz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764446AbYCDMz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbYCDMzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:55:50 -0500
Received: from ozlabs.org ([203.10.76.45]:59923 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbYCDMzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:55:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [BUG + PATCH/Bugfix] x86/lguest: fix pgdir pmd index calculation
Date: Tue, 4 Mar 2008 23:55:10 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       lguest@ozlabs.org, akpm <akpm@linux-foundation.org>
References: <20080224155515.GA24831@ubuntu>
In-Reply-To: <20080224155515.GA24831@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803042355.10960.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008 02:55:15 Ahmed S. Darwish wrote:
> Hi all,
>
> Beginning from commits close to v2.6.25-rc2, running lguest always oopses
> the host kernel. Oops is at [1].

OK, whatever the guest does should not break the host.  So your patch can't be
the whole solution.

> static void lguest_set_pmd(pmd_t *pmdp, pmd_t pmdval)
> {
> 	*pmdp = pmdval;
> 	lazy_hcall(LHCALL_SET_PMD, __pa(pmdp)&PAGE_MASK,
> 		   (__pa(pmdp)&(PAGE_SIZE-1))/4, 0);
> }
>
> The first hcall parameter is global pgdir which looks fine. The second
> parameter is the pmd index in the pgdir which is suspectful.
>
> AFAIK, calculating the index of pmd does not need a divisoin over four.
> Removing the division made lguest work fine again . Patch is at [2].

Each pmd is 4 bytes long, so the divide by 4 gives the index into the (top
level) page. ie. a number in the range 0 to 1023.

Indeed, here's the correct fix.  Does it work for you?

==
Revert 1ce70c4fac3c3954bd48c035f448793867592bc0, fix real problem.

Ahmed managed to crash the Host in release_pgd(), which cannot be a Guest
bug, and indeed it wasn't.

The bug was that handing a 0 as the address of the toplevel page table
being manipulated can cause the lookup code in find_pgdir() to return
an uninitialized cache entry (we shadow up to 4 top level page tables
for each Guest).

Commit 37cc8d7f963ba2deec29c9b68716944516a3244f introduced this
behaviour in the Guest, uncovering the bug.

The patch which he submitted (which removed the /4 from the index
calculation) simply ensured that these high-indexed entries hit the
early exit path of guest_set_pmd().  But you get lots of segfaults in
guest userspace as the PMDs aren't being updated.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 26838579cab1 arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c	Tue Mar 04 22:55:11 2008 +1100
+++ b/arch/x86/lguest/boot.c	Tue Mar 04 23:43:10 2008 +1100
@@ -480,7 +480,7 @@ static void lguest_set_pmd(pmd_t *pmdp, 
 {
 	*pmdp = pmdval;
 	lazy_hcall(LHCALL_SET_PMD, __pa(pmdp)&PAGE_MASK,
-		   (__pa(pmdp)&(PAGE_SIZE-1)), 0);
+		   (__pa(pmdp)&(PAGE_SIZE-1))/4, 0);
 }
 
 /* There are a couple of legacy places where the kernel sets a PTE, but we
diff -r 26838579cab1 drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c	Tue Mar 04 22:55:11 2008 +1100
+++ b/drivers/lguest/page_tables.c	Tue Mar 04 23:43:10 2008 +1100
@@ -391,7 +391,7 @@ static unsigned int find_pgdir(struct lg
 {
 	unsigned int i;
 	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
-		if (lg->pgdirs[i].gpgdir == pgtable)
+		if (lg->pgdirs[i].pgdir && lg->pgdirs[i].gpgdir == pgtable)
 			break;
 	return i;
 }
