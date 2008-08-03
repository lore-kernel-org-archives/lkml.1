Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYHCFdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYHCFdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 01:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYHCFdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 01:33:06 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39142 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYHCFdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 01:33:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>
Date: Sat, 02 Aug 2008 22:26:25 -0700
In-Reply-To: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>
	(Yinghai Lu's message of "Fri, 1 Aug 2008 19:02:55 -0700")
Message-ID: <m18wveacu6.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2596]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] x86_64: Restore the proper NR_IRQS define so larger systems work.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As pointed out and tracked by Yinghai Lu <yhlu.kernel@gmail.com>:

Dhaval Giani got:
kernel BUG at arch/x86/kernel/io_apic_64.c:357!
invalid opcode: 0000 [1] SMP
CPU 24
...

his system (x3950) has 8 ioapic, irq > 256

This was caused by:
        commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
        Author: Thomas Gleixner <tglx@linutronix.de>
        Date:   Fri May 2 20:10:09 2008 +0200

           x86: unify interrupt vector defines

           The interrupt vector defines are copied 4 times around with minimal
           differences. Move them all into asm-x86/irq_vectors.h

It appears that Thomas did not notice that x86_64 does something
completely different when he merge irq_vectors.h

We can solve this for 2.6.27 by simply reintroducing the old heuristic
for setting NR_IRQS on x86_64 to a usable value, which trivially removes
the regression.

Long term it would be nice to harmonize the handling of ioapic interrupts
of x86_32 and x86_64 so we don't have this kind of confusion.

Dhaval Giani <dhaval@linux.vnet.ibm.com> tested an earlier version of
this patch by YH which confirms simply increasing NR_IRQS fixes the
problem.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/asm-x86/irq_vectors.h |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
index 90b1d1f..a13eb6c 100644
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -109,7 +109,15 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
-#if !defined(CONFIG_X86_VOYAGER)
+#ifdef CONFIG_X86_64
+# if NR_CPUS < MAX_IO_APICS
+#  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
+# else
+#  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS ))
+# endif
+# define NR_IRQ_VECTORS NR_IRQS
+
+#elif !defined(CONFIG_X86_VOYAGER)
 
 # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
 
-- 
1.5.3.rc6.17.g1911
