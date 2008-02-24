Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYBXR2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYBXR2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYBXR17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:27:59 -0500
Received: from aun.it.uu.se ([130.238.12.36]:36658 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbYBXR17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:27:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18369.43239.964660.62249@harpo.it.uu.se>
Date: Sun, 24 Feb 2008 18:27:03 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: [BUG] 2.6.25-rc2-git8 fails to boot on 486 due to TSC breakage
In-Reply-To: <18369.35401.678391.183329@harpo.it.uu.se>
References: <200802241107.m1OB7bHb022801@harpo.it.uu.se>
	<20080224135720.GA5323@elte.hu>
	<18369.35401.678391.183329@harpo.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > Ingo Molnar writes:
 >  > 
 >  > * Mikael Pettersson <mikpe@it.uu.se> wrote:
 >  > 
 >  > > The kernel for this 486 has CONFIG_M486=y and CONFIG_M586TSC=n, but 
 >  > > the 2.6.25 kernels still try to access the TSC. Here's the oops from 
 >  > > 2.6.25-rc2-git8:
 >  > 
 >  > hm, could you send me the full .config you used?
 > 
 > I've put it here:
 > <http://user.it.uu.se/~mikpe/linux/tmp/config-2.6.24-git8>
 > 
 > Meanwhile, I've traced the breakage to 2.6.24-git8.
 > 
 > 2.6.24-git8 changed include/asm-x86/tsc.h:get_cycles() to call
 > rdtscll() even if CONFIG_X86_TSC isn't set. The call is protected
 > by a cpu_has_tsc test, but starting with 2.6.24-git8 cpu_has_tsc
 > is non-zero on this machine, which is very very wrong.
 > 
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

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
There's a similar XOR loop in arch/x86/kernel/setup_64.c.
I haven't seen it fail yet, but perhaps it should be changed
too, for robustness and symmetry.

--- linux-2.6.25-rc2-git8/arch/x86/kernel/cpu/common.c.~1~	2008-02-24 17:42:56.000000000 +0100
+++ linux-2.6.25-rc2-git8/arch/x86/kernel/cpu/common.c	2008-02-24 17:44:06.000000000 +0100
@@ -504,7 +504,7 @@ void __cpuinit identify_cpu(struct cpuin
 
 	/* Clear all flags overriden by options */
 	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] ^= cleared_cpu_caps[i];
+		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
