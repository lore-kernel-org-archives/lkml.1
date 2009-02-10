Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbZBJByR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbZBJByR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZBJByE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:54:04 -0500
Received: from ozlabs.org ([203.10.76.45]:45870 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbZBJByD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:54:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: The mysterious case of struct irqaction's mask field.
Date: Tue, 10 Feb 2009 12:23:46 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902101223.47313.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

   As part of the cpumask conversion, I came across struct irqaction:

	struct irqaction {
		irq_handler_t handler;
		unsigned long flags;
		cpumask_t mask;
		...
	};

Most people have been setting 'mask' to CPU_MASK_NONE, and I wondered if that
really meant that they never want this action performed on any CPU.

But I couldn't find anyone who actually *reads* the 'mask' field.  Tracing
back, it was converted from an unsigned long to a cpumask_t by wli around
2.6.7 ("as it was intended to be").  But that conversion didn't reveal anyone
actually using the field either.

At one point, sparc64 seems to have overloaded it for some kind of irq bucket
scheme.

Finally, I tracked it back to the creation of (then per-arch) struct irqaction
in 1.1.82, and this hunk from linux/arch/i386/kernel/irq.c:

@@ -12,14 +12,7 @@

 /*
  * IRQ's are in fact implemented a bit like signal handlers for the kernel.
- * The same sigaction struct is used, and with similar semantics (ie there
- * is a SA_INTERRUPT flag etc). Naturally it's not a 1:1 relation, but there
- * are similarities.
- *
- * sa_handler(int irq_NR) is the default function called (0 if no).
- * sa_mask is horribly ugly (I won't even mention it)
- * sa_flags contains various info: SA_INTERRUPT etc
- * sa_restorer is the unused
+ * Naturally it's not a 1:1 relation, but there are similarities.
  */

 #include <linux/ptrace.h>

So, it was never a cpumask at all; just a remanent of the use of sigaction for
interrupt handlers.  We've been happily setting it throughout the kernel since
1995.

On the assumption that it has failed to coerce the spirits of our ancestors to
land among us, I'll create a patch to remove it.

Cheers!
Rusty.
