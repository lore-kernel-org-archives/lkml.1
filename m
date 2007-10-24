Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbXJXMh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbXJXMh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXJXMhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:37:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59261 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172AbXJXMhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:37:15 -0400
Date: Wed, 24 Oct 2007 14:36:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] kvm: fix !SMP build error
Message-ID: <20071024123650.GA31562@elte.hu>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223640.EADF31F81AC@havoc.gtf.org> <20071023224455.GY30533@stusta.de> <471E79E2.2090204@garzik.org> <471F03F5.7090608@qumranet.com> <20071024123258.GA28653@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024123258.GA28653@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> i have triggered this and fixed it the right way - see the patch 
> below. This fixes the 2.6.24-rc1 build error.

and this followup patch is needed too if my patch is applied.

	Ingo

------------------->
Subject: x86: fix build error in arch/x86/kernel/cpu/mtrr/main.c
From: Ingo Molnar <mingo@elte.hu>

ipi_handler() must be available on !SMP too.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mtrr/main.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux/arch/x86/kernel/cpu/mtrr/main.c
@@ -139,13 +139,12 @@ struct set_mtrr_data {
 	mtrr_type	smp_type;
 };
 
-#ifdef CONFIG_SMP
-
 static void ipi_handler(void *info)
 /*  [SUMMARY] Synchronisation handler. Executed by "other" CPUs.
     [RETURNS] Nothing.
 */
 {
+#ifdef CONFIG_SMP
 	struct set_mtrr_data *data = info;
 	unsigned long flags;
 
@@ -168,9 +167,8 @@ static void ipi_handler(void *info)
 
 	atomic_dec(&data->count);
 	local_irq_restore(flags);
-}
-
 #endif
+}
 
 static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
 	return type1 == MTRR_TYPE_UNCACHABLE ||
