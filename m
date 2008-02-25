Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYBYJUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYBYJUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 04:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbYBYJUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 04:20:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYBYJUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 04:20:08 -0500
Date: Mon, 25 Feb 2008 10:19:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: [BUG] 2.6.25-rc2-git8 fails to boot on 486 due to TSC breakage
Message-ID: <20080225091955.GA22758@elte.hu>
References: <200802241107.m1OB7bHb022801@harpo.it.uu.se> <20080224135720.GA5323@elte.hu> <18369.35401.678391.183329@harpo.it.uu.se> <18369.43239.964660.62249@harpo.it.uu.se> <47C21284.7040607@zytor.com> <20080225082634.GB12715@elte.hu> <18370.34734.3562.258384@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18370.34734.3562.258384@harpo.it.uu.se>
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


* Mikael Pettersson <mikpe@it.uu.se> wrote:

>  > yes, i already fixed that when i added Mikael's patch and it's all 
>  > queued up.
> 
> Ok. For reference and for LKML viewers, this is what the final patch 
> should be:

below is the full commit - will send it to Linus later today.

	Ingo

--------------->
Subject: x86: fix boot failure on 486 due to TSC breakage
From: Mikael Pettersson <mikpe@it.uu.se>
Date: Sun, 24 Feb 2008 18:27:03 +0100

 > Diffing dmesg between git7 and git8 doesn't sched any light since
 > git8 also removed the printouts of the x86 caps as they were being
 > initialised and updated. I'm currently adding those printouts back
 > in the hope of seeing where and when the caps get broken.

That turned out to be very illuminating:

 --- dmesg-2.6.24-git7	2008-02-24 18:01:25.295851000 +0100
 +++ dmesg-2.6.24-git8	2008-02-24 18:01:25.530358000 +0100
 ...
 CPU: After generic identify, caps: 00000003 00000000 00000000 00000000 00000000 00000000 00000000 00000000

 CPU: After all inits, caps: 00000003 00000000 00000000 00000000 00000000 00000000 00000000 00000000
+CPU: After applying cleared_cpu_caps, caps: 00000013 00000000 00000000 00000000 00000000 00000000 00000000 00000000

Notice how the TSC cap bit goes from Off to On.

(The first two lines are printout loops from -git7 forward-ported
to -git8, the third line is the same printout loop added just after
the xor-with-cleared_cpu_caps[] loop.)

Here's how the breakage occurs:
1. arch/x86/kernel/tsc_32.c:tsc_init() sees !cpu_has_tsc,
   so bails and calls setup_clear_cpu_cap(X86_FEATURE_TSC).
2. include/asm-x86/cpufeature.h:setup_clear_cpu_cap(bit) clears
   the bit in boot_cpu_data and sets it in cleared_cpu_caps
3. arch/x86/kernel/cpu/common.c:identify_cpu() XORs all caps
   in with cleared_cpu_caps
   HOWEVER, at this point c->x86_capability correctly has TSC
   Off, cleared_cpu_caps has TSC On, so the XOR incorrectly
   sets TSC to On in c->x86_capability, with disastrous results.

The real bug is that clearing bits with XOR only works if the
bits are known to be 1 prior to the XOR, and that's not true here.

A simple fix is to convert the XOR to AND-NOT instead. The following
patch does that, and allows my 486 to boot 2.6.25-rc kernels again.

[ mingo@elte.hu: fixed a similar bug in setup_64.c as well. ]

The breakage was introduced via commit 7d851c8d3db0.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/setup_64.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/cpu/common.c
+++ linux-x86.q/arch/x86/kernel/cpu/common.c
@@ -504,7 +504,7 @@ void __cpuinit identify_cpu(struct cpuin
 
 	/* Clear all flags overriden by options */
 	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] ^= cleared_cpu_caps[i];
+		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
Index: linux-x86.q/arch/x86/kernel/setup_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/setup_64.c
+++ linux-x86.q/arch/x86/kernel/setup_64.c
@@ -1021,7 +1021,7 @@ void __cpuinit identify_cpu(struct cpuin
 
 	/* Clear all flags overriden by options */
 	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] ^= cleared_cpu_caps[i];
+		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 
 #ifdef CONFIG_X86_MCE
 	mcheck_init(c);
