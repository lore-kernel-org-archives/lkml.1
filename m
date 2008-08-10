Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbYHJHhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbYHJHhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYHJHhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:37:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbYHJHhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:37:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Eyun3KwSTeN6XE/WGjtKJH0oPasjqLUbmQqdU/KYqGpDlxSYIL8IZ6JAKroqbXdJTA
         OKx7Zy0NfZ57J04gbM3UHILhp7cTAgpViCYK5qzh7+xMrmQUUnTvIDI/tO7MDeTNTm/p
         yBPB+EGQOrdw9fnZasQstoL6Ycai3/js3vyP4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 01/43] x86_64: Restore the proper NR_IRQS define so larger systems work.
Date: Sun, 10 Aug 2008 00:35:50 -0700
Message-Id: <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

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
index 646d59f..3f4b1b6 100644
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
+#  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
+# endif
+# define NR_IRQ_VECTORS NR_IRQS
+
+#elif !defined(CONFIG_X86_VOYAGER)
 
 # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
 
-- 
1.5.4.5

