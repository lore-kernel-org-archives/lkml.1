Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYCRJbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYCRJbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 05:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYCRJbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 05:31:24 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:8848 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYCRJbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 05:31:23 -0400
Date: Tue, 18 Mar 2008 10:31:19 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: tick-common.c hack for s390 needed
Message-ID: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Ingo,

I'm converting s390 from s390's NO_IDLE_HZ to GENERIC_CLOCKEVENTS and
therefore to the generic NO_HZ implementation.
One of the problems that need a patch for this is kernel/time/tick-common.c
which relies on the irq stuff present in include/linux/irq.h.
In particular s390 doesn't have something like irq_set_affinity which
causes this build error:

  CC      kernel/time/tick-common.o
kernel/time/tick-common.c: In function 'tick_periodic':
kernel/time/tick-common.c:70: error: implicit declaration of function 'get_irq_regs'
kernel/time/tick-common.c:70: error: invalid type argument of '->' (have 'int')
kernel/time/tick-common.c: In function 'tick_setup_device':
kernel/time/tick-common.c:171: error: implicit declaration of function 'irq_set_affinity'
kernel/time/tick-common.c: In function 'tick_check_new_device':
kernel/time/tick-common.c:216: error: implicit declaration of function 'irq_can_set_affinity'

Actually there's a huge #ifndef CONFIG_S390 in linux/irq.h ;)

To make the code work the patch below is necessary. It's ok since all
clock event devices on s390 are per cpu. However I think this patch is
ugly at best. Any ideas how to fix this in a better and more generic way?

---
 kernel/time/tick-common.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/time/tick-common.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-common.c
+++ linux-2.6/kernel/time/tick-common.c
@@ -19,6 +19,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/tick.h>
+#include <asm/irq_regs.h>
 
 #include "tick-internal.h"
 
@@ -167,9 +168,10 @@ static void tick_setup_device(struct tic
 	 * When the device is not per cpu, pin the interrupt to the
 	 * current cpu:
 	 */
+#ifndef CONFIG_S390
 	if (!cpus_equal(newdev->cpumask, cpumask))
 		irq_set_affinity(newdev->irq, cpumask);
-
+#endif
 	/*
 	 * When global broadcasting is active, check if the current
 	 * device is registered as a placeholder for broadcast mode.
@@ -213,9 +215,10 @@ static int tick_check_new_device(struct 
 		 * If the cpu affinity of the device interrupt can not
 		 * be set, ignore it.
 		 */
+#ifndef CONFIG_S390
 		if (!irq_can_set_affinity(newdev->irq))
 			goto out_bc;
-
+#endif
 		/*
 		 * If we have a cpu local device already, do not replace it
 		 * by a non cpu local device
