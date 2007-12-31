Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbXLaR3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbXLaR3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 12:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbXLaR3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 12:29:38 -0500
Received: from hs-out-0708.google.com ([64.233.178.244]:49573 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750789AbXLaR3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 12:29:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cp/Tk5RgqOUSfByUwQ4GquQR2njA/XPIALnAk13YZ4D5sxWCmaFZulXYsVqMKixNW1yCJb8i0X03eiJaKgg0UnSXsl7V0cX3enfRauVbLEsacWkg6G3XrlijL4U2OFMeiXdM2glw+jTJgYbJLiodi9X9+/Gm3W0EOGbLeogiHq0=
Message-ID: <b70efdcb0712310929y1bf871eah2adb531a7ed89673@mail.gmail.com>
Date: Mon, 31 Dec 2007 11:29:35 -0600
From: "Quentin Barnes" <qbarnes@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [CFT] Code clarification patch to Kprobes arch code
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since people are discussing some x86 Kprobes code cleanup, I thought
I would contribute a small change as well.  When developing the
Kprobes arch code for ARM, I ran across some code found in x86 and
s390 Kprobes arch code which I didn't consider as good as it could
be.

Once I figured out what the code was doing, I changed the code
for ARM Kprobes to work the way I felt was more appropriate.
I've tested the code this way in ARM for about a year and would
like to push the same change to the other affected architectures.

The code in question is in kprobe_exceptions_notify() which
does:
====
          /* kprobe_running() needs smp_processor_id() */
          preempt_disable();
          if (kprobe_running() &&
              kprobe_fault_handler(args->regs, args->trapnr))
                  ret = NOTIFY_STOP;
          preempt_enable();
====

For the moment, ignore the code having the preempt_disable()/
preempt_enable() pair in it.

The problem is that kprobe_running() needs to call smp_processor_id()
which will assert if preemption is enabled.  That sanity check by
smp_processor_id() makes perfect sense since calling it with preemption
enabled would return an unreliable result.

But the function kprobe_exceptions_notify() can be called from a
context where preemption could be enabled.  If that happens, the
assertion in smp_processor_id() happens and we're dead.  So what
the original author did (speculation on my part!) is put in the
preempt_disable()/preempt_enable() pair to simply defeat the check.

Once I figured out what was going on, I considered this an
inappropriate approach.  If kprobe_exceptions_notify() is called
from a preemptible context, we can't be in a kprobe processing
context at that time anyways since kprobes requires preemption to
already be disabled, so just check for preemption enabled, and if
so, blow out before ever calling kprobe_running().  I wrote the ARM
kprobe code like this:
====
          /* To be potentially processing a kprobe fault and to
           * trust the result from kprobe_running(), we have
           * be non-preemptible. */
          if (!preemptible() && kprobe_running() &&
              kprobe_fault_handler(args->regs, args->trapnr))
                  ret = NOTIFY_STOP;
====

The above code has been working fine for ARM Kprobes for a year.
So I changed the x86 code (2.6.24-rc6) to be the same way and ran
the Systemtap tests on that kernel.  As on ARM, Systemtap on x86
comes up with the same test results either way, so it's a neutral
external functional change (as expected).

This issue has been discussed previously on linux-arm-kernel and the
Systemtap mailing lists.  Pointers to the by base for the two
discussions:
http://lists.arm.linux.org.uk/lurker/message/20071219.223225.1f5c2a5e.en.html
http://sourceware.org/ml/systemtap/2007-q1/msg00251.html

I felt it was time to push it out and also get testing feedback from
the affected architectures (s390/x86_{32|64}).

Thoughts?  Comments?

Quentin


Patch for the suggested change to 2.6.24-rc6.
Signed-off-by: Quentin Barnes <qbarnes@gmail.com>

diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index c5549a2..53b167f 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -22,6 +22,7 @@

 #include <linux/kprobes.h>
 #include <linux/ptrace.h>
+#include <linux/hardirq.h>
 #include <linux/preempt.h>
 #include <linux/stop_machine.h>
 #include <linux/kdebug.h>
@@ -595,12 +596,12 @@ int __kprobes kprobe_exceptions_notify(struct
notifier_block *self,
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_TRAP:
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() &&
+		/* To be potentially processing a kprobe fault and to
+		 * trust the result from kprobe_running(), we have
+		 * be non-preemptible. */
+		if (!preemptible() && kprobe_running() &&
 		    kprobe_fault_handler(args->regs, args->trapnr))
 			ret = NOTIFY_STOP;
-		preempt_enable();
 		break;
 	default:
 		break;
diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 3a020f7..007fbdf 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -29,6 +29,7 @@

 #include <linux/kprobes.h>
 #include <linux/ptrace.h>
+#include <linux/hardirq.h>
 #include <linux/preempt.h>
 #include <linux/kdebug.h>
 #include <asm/cacheflush.h>
@@ -668,12 +669,12 @@ int __kprobes kprobe_exceptions_notify(struct
notifier_block *self,
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_GPF:
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() &&
+		/* To be potentially processing a kprobe fault and to
+		 * trust the result from kprobe_running(), we have
+		 * be non-preemptible. */
+		if (!preemptible() && kprobe_running() &&
 		    kprobe_fault_handler(args->regs, args->trapnr))
 			ret = NOTIFY_STOP;
-		preempt_enable();
 		break;
 	default:
 		break;
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 5df19a9..447cbdc 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -34,6 +34,7 @@
 #include <linux/ptrace.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/hardirq.h>
 #include <linux/preempt.h>
 #include <linux/module.h>
 #include <linux/kdebug.h>
@@ -654,12 +655,12 @@ int __kprobes kprobe_exceptions_notify(struct
notifier_block *self,
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_GPF:
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() &&
+		/* To be potentially processing a kprobe fault and to
+		 * trust the result from kprobe_running(), we have
+		 * be non-preemptible. */
+		if (!preemptible() && kprobe_running() &&
 		    kprobe_fault_handler(args->regs, args->trapnr))
 			ret = NOTIFY_STOP;
-		preempt_enable();
 		break;
 	default:
 		break;
