Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbYGIMfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbYGIMfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYGIMfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:35:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45112 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYGIMf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:35:29 -0400
Date: Wed, 9 Jul 2008 14:35:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>, Avi Kivity <avi@qumranet.com>
Subject: [patch] x86: paravirt spinlocks, !CONFIG_SMP build fixes (was: Re:
	[PATCH RFC 0/4] Paravirtual spinlocks)
Message-ID: <20080709123503.GA13610@elte.hu>
References: <20080707190749.299430659@goop.org> <20080709122852.GA30579@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709122852.GA30579@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> as there were no fundamental objections in this thread i've created a 
> tip/x86/paravirt-spinlocks topic branch for these patches and started 
> testing them.

small UP build fixes below.

	Ingo

----------------->
commit c77bc635bb0486b0ddbe03012a8662b399ae9cdb
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 9 14:33:33 2008 +0200

    x86: paravirt spinlocks, !CONFIG_SMP build fixes
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index bba4041..6aa8aed 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -270,11 +270,13 @@ enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 
 void __init paravirt_use_bytelocks(void)
 {
+#ifdef CONFIG_SMP
 	pv_lock_ops.spin_is_locked = __byte_spin_is_locked;
 	pv_lock_ops.spin_is_contended = __byte_spin_is_contended;
 	pv_lock_ops.spin_lock = __byte_spin_lock;
 	pv_lock_ops.spin_trylock = __byte_spin_trylock;
 	pv_lock_ops.spin_unlock = __byte_spin_unlock;
+#endif
 }
 
 struct pv_info pv_info = {
@@ -461,12 +463,14 @@ struct pv_mmu_ops pv_mmu_ops = {
 };
 
 struct pv_lock_ops pv_lock_ops = {
+#ifdef CONFIG_SMP
 	.spin_is_locked = __ticket_spin_is_locked,
 	.spin_is_contended = __ticket_spin_is_contended,
 
 	.spin_lock = __ticket_spin_lock,
 	.spin_trylock = __ticket_spin_trylock,
 	.spin_unlock = __ticket_spin_unlock,
+#endif
 };
 
 EXPORT_SYMBOL_GPL(pv_time_ops);
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 65ed02c..b2aba8f 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -1387,6 +1387,8 @@ void _paravirt_nop(void);
 
 void paravirt_use_bytelocks(void);
 
+#ifdef CONFIG_SMP
+
 static inline int __raw_spin_is_locked(struct raw_spinlock *lock)
 {
 	return PVOP_CALL1(int, pv_lock_ops.spin_is_locked, lock);
@@ -1412,6 +1414,8 @@ static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
 	return PVOP_VCALL1(pv_lock_ops.spin_unlock, lock);
 }
 
+#endif
+
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch_site {
 	u8 *instr; 		/* original instructions */

