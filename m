Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbYCVUci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbYCVUci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 16:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYCVUc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 16:32:28 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:46899 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYCVUc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 16:32:27 -0400
Date: Sat, 22 Mar 2008 21:32:23 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, paulus@samba.org,
       ralf@linux-mips.org, rmk@arm.linux.org.uk, davem@davemloft.net,
       lethal@linux-sh.org, jdike@addtoit.com
Subject: Re: tick-common.c hack for s390 needed
Message-ID: <20080322203223.GA31521@osiris.boeblingen.de.ibm.com>
References: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com> <20080319054545.GA18834@infradead.org> <20080321101504.GI20420@elte.hu> <20080321132559.GA4128@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0803211545160.3781@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803211545160.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 03:45:52PM +0100, Thomas Gleixner wrote:
> On Fri, 21 Mar 2008, Heiko Carstens wrote:
> > 
> > The patch below removes at least three of the includes for a beginning.
> > Still compiles on s390 and x86_64.
> > 
> > Subject: [PATCH] time: remove include/irq.h.
> > 
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > Generic code is not supposed to include linux/irq.h.
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Applied, thanks,

And here comes the second part...

Subject: [PATCH] time: remove include/irq.h from tick-common.c

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Generic code is not supposed to include irq.h. Replace this include
by linux/hardirq.h instead and add/replace an include of linux/irq.h
in asm header files where necessary.
This change should only matter for architectures that make use of
GENERIC_CLOCKEVENTS.
Architectures in question are mips, x86, arm, sh, powerpc, uml and sparc64.

I did some cross compile tests for mips, x86_64, arm, powerpc and sparc64.
This patch fixes also build breakages caused by the include replacement in
tick-common.h.

I didn't test uml and sh.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/asm-arm/hardirq.h     |    2 +-
 include/asm-powerpc/hardirq.h |    2 +-
 include/asm-sparc64/hardirq.h |    1 +
 include/asm-sparc64/irq.h     |    1 -
 kernel/time/tick-common.c     |    2 +-
 5 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/include/asm-arm/hardirq.h
===================================================================
--- linux-2.6.orig/include/asm-arm/hardirq.h
+++ linux-2.6/include/asm-arm/hardirq.h
@@ -3,7 +3,7 @@
 
 #include <linux/cache.h>
 #include <linux/threads.h>
-#include <asm/irq.h>
+#include <linux/irq.h>
 
 typedef struct {
 	unsigned int __softirq_pending;
Index: linux-2.6/include/asm-powerpc/hardirq.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/hardirq.h
+++ linux-2.6/include/asm-powerpc/hardirq.h
@@ -2,7 +2,7 @@
 #define _ASM_POWERPC_HARDIRQ_H
 #ifdef __KERNEL__
 
-#include <asm/irq.h>
+#include <linux/irq.h>
 #include <asm/bug.h>
 
 /* The __last_jiffy_stamp field is needed to ensure that no decrementer
Index: linux-2.6/include/asm-sparc64/hardirq.h
===================================================================
--- linux-2.6.orig/include/asm-sparc64/hardirq.h
+++ linux-2.6/include/asm-sparc64/hardirq.h
@@ -6,6 +6,7 @@
 #ifndef __SPARC64_HARDIRQ_H
 #define __SPARC64_HARDIRQ_H
 
+#include <linux/irq.h>
 #include <asm/cpudata.h>
 
 #define __ARCH_IRQ_STAT
Index: linux-2.6/kernel/time/tick-common.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-common.c
+++ linux-2.6/kernel/time/tick-common.c
@@ -14,7 +14,7 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/hrtimer.h>
-#include <linux/irq.h>
+#include <linux/hardirq.h>
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
Index: linux-2.6/include/asm-sparc64/irq.h
===================================================================
--- linux-2.6.orig/include/asm-sparc64/irq.h
+++ linux-2.6/include/asm-sparc64/irq.h
@@ -10,7 +10,6 @@
 #include <linux/linkage.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/interrupt.h>
 #include <asm/pil.h>
 #include <asm/ptrace.h>
 
