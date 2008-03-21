Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYCUN0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYCUN0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYCUN0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:26:04 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:25249 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYCUN0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:26:01 -0400
Date: Fri, 21 Mar 2008 14:25:59 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: tick-common.c hack for s390 needed
Message-ID: <20080321132559.GA4128@osiris.boeblingen.de.ibm.com>
References: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com> <20080319054545.GA18834@infradead.org> <20080321101504.GI20420@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321101504.GI20420@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 11:15:04AM +0100, Ingo Molnar wrote:
> 
> * Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Tue, Mar 18, 2008 at 10:31:19AM +0100, Heiko Carstens wrote:
> > > Hi Thomas, Ingo,
> > > 
> > > I'm converting s390 from s390's NO_IDLE_HZ to GENERIC_CLOCKEVENTS and
> > > therefore to the generic NO_HZ implementation.
> > > One of the problems that need a patch for this is kernel/time/tick-common.c
> > > which relies on the irq stuff present in include/linux/irq.h.
> > > In particular s390 doesn't have something like irq_set_affinity which
> > > causes this build error:
> > 
> > Generic code must never use linux/irq.h - it's more like asm-generic 
> > file predating asm-generic.
> 
> agreed.
> 
> Heiko, if you remove all these:
> 
>  ./time/tick-broadcast.c:#include <linux/irq.h>
>  ./time/tick-oneshot.c:#include <linux/irq.h>
>  ./time/tick-common.c:#include <linux/irq.h>
>  ./hrtimer.c:#include <linux/irq.h>
> 
> from kernel/*, do things improve on s390? If yes then please send a 
> patch for it and i'll check whether there's any include file dependency 
> fallout on x86.

No, tick-common.c has calls to irq_set_affinity and irq_can_set_affinity, for
which the prototypes are in linux/irq.h.
Each and every architecture seems to include linux/irq.h from a different file
in asm-[your-favourite-arch]/*.h. I was able to fix the build breakage on x86
by adding an include <linux/interrupt.h>. But that won't work on other
architectures.
>From a logical point of view I would expect that asm/irq.h is supposed to
include linux/irq.h, no?

The patch below removes at least three of the includes for a beginning.
Still compiles on s390 and x86_64.

Subject: [PATCH] time: remove include/irq.h.

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Generic code is not supposed to include linux/irq.h.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 kernel/hrtimer.c             |    1 -
 kernel/time/tick-broadcast.c |    1 -
 kernel/time/tick-oneshot.c   |    1 -
 3 files changed, 3 deletions(-)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -32,7 +32,6 @@
  */
 
 #include <linux/cpu.h>
-#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/hrtimer.h>
Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -14,7 +14,6 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/hrtimer.h>
-#include <linux/irq.h>
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
Index: linux-2.6/kernel/time/tick-oneshot.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-oneshot.c
+++ linux-2.6/kernel/time/tick-oneshot.c
@@ -14,7 +14,6 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/hrtimer.h>
-#include <linux/irq.h>
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
