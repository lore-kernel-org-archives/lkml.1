Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbYBGT2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbYBGT2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758460AbYBGT2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:28:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44185 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709AbYBGT2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:28:07 -0500
Date: Thu, 7 Feb 2008 21:03:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, davej@codemonkey.org.uk,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Use global TLB flushes in MTRR code
Message-ID: <20080207200308.GA26555@one.firstfloor.org>
References: <20080207190241.GA9449@basil.nowhere.org> <20080207191337.GA13111@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207191337.GA13111@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 08:13:37PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > [probably stable material too]
> > 
> > Use global TLB flushes in MTRR code
> > 
> > Obviously kernel mappings should be flushed here too.
> 
> no, your patch is not needed:

Yes you're right.  Thanks makes more sense.  The weird style
fooled me.

It seems to come from the pseudo code in the Intel manual,
but I think it would be still cleaner/more idiomatic to use two
__flush_tlb_all() and remove the explicit code. The only drawback would 
be some more cr4 accesses, which does not seem like a big issue.

Updated patch follows.

-Andi

---

Use standard global TLB flushes in MTRR code

This is more idiomatic and it does not really make sense for this 
code to implement a own TLB flushing variant.

The control registers will be read/written a few times more, but 
that should not really matter for this code.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux/arch/x86/kernel/cpu/mtrr/generic.c
@@ -349,14 +349,8 @@ static void prepare_set(void) __acquires
 	write_cr0(cr0);
 	wbinvd();
 
-	/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
-	if ( cpu_has_pge ) {
-		cr4 = read_cr4();
-		write_cr4(cr4 & ~X86_CR4_PGE);
-	}
-
-	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
-	__flush_tlb();
+	/* Flush all TLBs */
+	__flush_tlb_all();
 
 	/*  Save MTRR state */
 	rdmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
@@ -368,7 +362,7 @@ static void prepare_set(void) __acquires
 static void post_set(void) __releases(set_atomicity_lock)
 {
 	/*  Flush TLBs (no need to flush caches - they are disabled)  */
-	__flush_tlb();
+	__flush_tlb_all();
 
 	/* Intel (P6) standard MTRRs */
 	mtrr_wrmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
@@ -376,9 +370,9 @@ static void post_set(void) __releases(se
 	/*  Enable caches  */
 	write_cr0(read_cr0() & 0xbfffffff);
 
-	/*  Restore value of CR4  */
-	if ( cpu_has_pge )
-		write_cr4(cr4);
+	/* Flush TLBs again to handle prefetches etc. */
+	__flush_tlb_all();
+
 	spin_unlock(&set_atomicity_lock);
 }
 
