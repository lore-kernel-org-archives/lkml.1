Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYCCRyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYCCRyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbYCCRxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:53:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38254 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759851AbYCCRxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:53:52 -0500
Date: Mon, 3 Mar 2008 18:53:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080303175328.GC25496@elte.hu>
References: <20080228192404.GH17932@hjernemadsen.org> <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <47CC310B.8000305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CC310B.8000305@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

>> It is strange indeed... Should it be traced as an regression?
>
> I'd like to understand what the heck happened, but as far as we can 
> observe right now, it's a *progression*, not a regression, since 
> executing out of a non-PROT_EXEC area isn't *supposed* to work...

if s2ram worked before, and breaks with v2.6.25 then it's a regression. 
It doesnt really matter that this segfault is the right thing to do ...

what would be _really_ nice to know how this all links up to the PCD -> 
PCD|PWT commit. I.e. how did the commit below suddenly _trigger_ this 
segfault? Are we absolutely sure that the bisection is correct, that 
it's this commit which broke things? [i.e. if this commit is unapplied, 
does s2ram work?]

there are a few "nearby" commits in the bisection tree:

 commit 6c3866558213ff706d8331053386915371ad63ec
 Author: Jeremy Fitzhardinge <jeremy@goop.org>
 Date:   Wed Jan 30 13:32:55 2008 +0100

     x86: move all asm/pgtable constants into one place

 commit 61f38226def55d972cfd0e789971e952525ff8e5
 Author: Ingo Molnar <mingo@elte.hu>
 Date:   Wed Jan 30 13:32:55 2008 +0100

     x86/pgtable: fix constant sign extension problem

 commit dcbae6b377d78190954055ef2d8909ae83ff57de
 Author: Ingo Molnar <mingo@elte.hu>
 Date:   Wed Jan 30 13:32:55 2008 +0100

     x86/pgtable: unify pagetable accessors, #1

which are far more likely candidates IMO of causing this NX related 
segfault than the PCD->PCD|PWT change that was bisected originally.

	Ingo

---------->
commit 82bc03fc158e28c90d7ed9919410776039cb4e14
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jan 30 13:32:54 2008 +0100

    x86: add PWT to NOCACHE flags
    
    add PWT bit to NOCACHE flags. No real difference to CPUs, but needed
    later for PAT.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index a8be1ee..16da5d5 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -156,7 +156,7 @@ void paging_init(void);
 extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
-#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD)
+#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 3f28010..9c9cddf 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -189,13 +189,13 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long
 #define __PAGE_KERNEL_EXEC \
 	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
 #define __PAGE_KERNEL_NOCACHE \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_PCD | _PAGE_ACCESSED | _PAGE_NX)
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_PCD | _PAGE_PWT | _PAGE_ACCESSED | _PAGE_NX)
 #define __PAGE_KERNEL_RO \
 	(_PAGE_PRESENT | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_NX)
 #define __PAGE_KERNEL_VSYSCALL \
 	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
 #define __PAGE_KERNEL_VSYSCALL_NOCACHE \
-	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_PCD)
+	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE \
 	(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC \
