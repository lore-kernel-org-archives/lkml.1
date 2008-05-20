Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYETCfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYETCfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbYETCet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:34:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757089AbYETCes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:34:48 -0400
Date: Mon, 19 May 2008 19:33:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
 onX61s laptop
In-Reply-To: <alpine.LFD.1.10.0805191528550.32253@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805191928490.32253@woody.linux-foundation.org>
References: <E1JxGth-0001te-S4@closure.thunk.org> <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com> <20080517154131.GA7651@mit.edu> <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com> <1211047916.27447.314.camel@koto.keithp.com>
 <482F24C6.2050705@frugalware.org> <20080517184626.GA16496@mit.edu> <Pine.LNX.4.64.0805192217430.15410@blonde.site> <alpine.LFD.1.10.0805191528550.32253@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 May 2008, Linus Torvalds wrote:
> 
> IOE, PTE_MASK should be a "pteval_t". And it should have absolutely 
> *nothing* to do with PAGE_MASK. EVER.
> 
> IOW, maybe something like this?

.. and in addition to that, perhaps something like this too?

Making the actual _PAGE_XYZ bits be of the proper type makes using bitops 
and negation on them automatically DTRT, so that we don't need those 
insane casts in pte_mkclean() and friends.

Again, totally untested, but we really should just get the types right, 
instead of getting them wrogn and then messing around with various silly 
and incorrect work-arounds for the fact that we got them wrong.

And while it's untested - if this cleanup is buggy (or even generates 
different code), then we're doing something really wrong somewhere.

		Linus

---
 include/asm-x86/pgtable.h |   49 +++++++++++++++++++++++----------------------
 1 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 55c3a0e..b38b540 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -21,27 +21,28 @@
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
 /*
- * Note: we use _AC(1, L) instead of _AC(1, UL) so that we get a
- * sign-extended value on 32-bit with all 1's in the upper word,
- * which preserves the upper pte values on 64-bit ptes:
+ * Note: we use _AT(pteval_t,1) so that we get the right type
+ * even when we're using PAE and everything is 64-bit with a
+ " 32-bit word-size. That's important for various bit masks.
  */
-#define _PAGE_PRESENT	(_AC(1, L)<<_PAGE_BIT_PRESENT)
-#define _PAGE_RW	(_AC(1, L)<<_PAGE_BIT_RW)
-#define _PAGE_USER	(_AC(1, L)<<_PAGE_BIT_USER)
-#define _PAGE_PWT	(_AC(1, L)<<_PAGE_BIT_PWT)
-#define _PAGE_PCD	(_AC(1, L)<<_PAGE_BIT_PCD)
-#define _PAGE_ACCESSED	(_AC(1, L)<<_PAGE_BIT_ACCESSED)
-#define _PAGE_DIRTY	(_AC(1, L)<<_PAGE_BIT_DIRTY)
-#define _PAGE_PSE	(_AC(1, L)<<_PAGE_BIT_PSE)	/* 2MB page */
-#define _PAGE_GLOBAL	(_AC(1, L)<<_PAGE_BIT_GLOBAL)	/* Global TLB entry */
-#define _PAGE_UNUSED1	(_AC(1, L)<<_PAGE_BIT_UNUSED1)
-#define _PAGE_UNUSED2	(_AC(1, L)<<_PAGE_BIT_UNUSED2)
-#define _PAGE_UNUSED3	(_AC(1, L)<<_PAGE_BIT_UNUSED3)
-#define _PAGE_PAT	(_AC(1, L)<<_PAGE_BIT_PAT)
-#define _PAGE_PAT_LARGE (_AC(1, L)<<_PAGE_BIT_PAT_LARGE)
+#define _PAGE_BIT(x)	(_AT(pteval_t,1) << (x))
+#define _PAGE_PRESENT	_PAGE_BIT(_PAGE_BIT_PRESENT)
+#define _PAGE_RW	_PAGE_BIT(_PAGE_BIT_RW)
+#define _PAGE_USER	_PAGE_BIT(_PAGE_BIT_USER)
+#define _PAGE_PWT	_PAGE_BIT(_PAGE_BIT_PWT)
+#define _PAGE_PCD	_PAGE_BIT(_PAGE_BIT_PCD)
+#define _PAGE_ACCESSED	_PAGE_BIT(_PAGE_BIT_ACCESSED)
+#define _PAGE_DIRTY	_PAGE_BIT(_PAGE_BIT_DIRTY)
+#define _PAGE_PSE	_PAGE_BIT(_PAGE_BIT_PSE)	/* 2MB page */
+#define _PAGE_GLOBAL	_PAGE_BIT(_PAGE_BIT_GLOBAL)	/* Global TLB entry */
+#define _PAGE_UNUSED1	_PAGE_BIT(_PAGE_BIT_UNUSED1)
+#define _PAGE_UNUSED2	_PAGE_BIT(_PAGE_BIT_UNUSED2)
+#define _PAGE_UNUSED3	_PAGE_BIT(_PAGE_BIT_UNUSED3)
+#define _PAGE_PAT	_PAGE_BIT(_PAGE_BIT_PAT)
+#define _PAGE_PAT_LARGE _PAGE_BIT(_PAGE_BIT_PAT_LARGE)
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
-#define _PAGE_NX	(_AC(1, ULL) << _PAGE_BIT_NX)
+#define _PAGE_NX	_PAGE_BIT(_PAGE_BIT_NX)
 #else
 #define _PAGE_NX	0
 #endif
@@ -209,22 +210,22 @@ static inline int pmd_large(pmd_t pte)
 
 static inline pte_t pte_mkclean(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_DIRTY);
+	return __pte(pte_val(pte) & ~_PAGE_DIRTY);
 }
 
 static inline pte_t pte_mkold(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_ACCESSED);
+	return __pte(pte_val(pte) & ~_PAGE_ACCESSED);
 }
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_RW);
+	return __pte(pte_val(pte) & ~_PAGE_RW);
 }
 
 static inline pte_t pte_mkexec(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_NX);
+	return __pte(pte_val(pte) & ~_PAGE_NX);
 }
 
 static inline pte_t pte_mkdirty(pte_t pte)
@@ -249,7 +250,7 @@ static inline pte_t pte_mkhuge(pte_t pte)
 
 static inline pte_t pte_clrhuge(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_PSE);
+	return __pte(pte_val(pte) & ~_PAGE_PSE);
 }
 
 static inline pte_t pte_mkglobal(pte_t pte)
@@ -259,7 +260,7 @@ static inline pte_t pte_mkglobal(pte_t pte)
 
 static inline pte_t pte_clrglobal(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_GLOBAL);
+	return __pte(pte_val(pte) & ~_PAGE_GLOBAL);
 }
 
 static inline pte_t pte_mkspecial(pte_t pte)
