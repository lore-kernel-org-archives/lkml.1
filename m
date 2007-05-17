Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbXEQNGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbXEQNGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 09:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbXEQNGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 09:06:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38845 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838AbXEQNGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 09:06:04 -0400
Date: Thu, 17 May 2007 18:35:27 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: Morton Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7-mm2 "irqpoll" seems to be broken
Message-ID: <20070517130527.GF28280@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070426093620.GB2626@in.ibm.com> <20070426082405.67a0fdd2.akpm@linux-foundation.org> <20070430084833.GA16173@in.ibm.com> <20070502221932.GA488@suse.de> <20070508171841.GA29733@in.ibm.com> <20070514140513.GD29616@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514140513.GD29616@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 04:05:15PM +0200, Bernhard Walle wrote:
> * Vivek Goyal <vgoyal@in.ibm.com> [2007-05-08 19:18]:
> > On Thu, May 03, 2007 at 12:19:32AM +0200, Bernhard Walle wrote:
> > > * Vivek Goyal <vgoyal@in.ibm.com> [2007-04-30 10:48]:
> > > > 
> > > > handle_edge_irq() already makes sure that desc->action is not null, still
> > > > note_interrupt() is receiving desc->action as null, that's strange. On my 
> > > > system this is happening for irq 4 and /proc/interrupt shows that it is
> > > > coming from "serial".
> > > 
> > > Unfortunately, I couldn't reproduce this here. Vivek, do you have time
> > > to take a look at this at your site? For the meanwhile, should I
> > > create a patch that checks for desc->action in note_interrupt(), too?
> > 
> > I can reproduce this problem only on one machine. I think there is some
> > race condition and your code somehow just exposes it.
> 
> thanks for finding that out. Could you try/review out the patch below?
> As the lock is only aquired when irqfixup == 2 it shouldn't impact
> performance of a 'normal' system.
> 

Hi Bernhard,

It does fix up my problem. I have modified your patch a bit. I think
new version is little more clear. What do you think?

Thanks
Vivek




o System crashes if booted with irqpoll command line option.

o Problem happens because Inside note_interrupt() we are accessing
  desc->action->flag without taking the desc->lock. While accessing it
  somebody goes ahead and unregisters the irq handler hence desc->action
  is NULL. By the time note_interrupt() checks it, it crashes.

o In my system it is irq 4 seriving to serial driver.

o Take the desc->lock before accessing desc->action->flag.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 linux-2.6.21-git12-root/kernel/irq/spurious.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff -puN kernel/irq/spurious.c~fix-irqpoll-crash kernel/irq/spurious.c
--- linux-2.6.21-git12/kernel/irq/spurious.c~fix-irqpoll-crash	2007-05-17 17:36:50.000000000 +0530
+++ linux-2.6.21-git12-root/kernel/irq/spurious.c	2007-05-17 17:53:52.000000000 +0530
@@ -138,6 +138,8 @@ report_bad_irq(unsigned int irq, struct 
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
+	int call_misrouted_irq = 0;
+
 	if (unlikely(action_ret != IRQ_HANDLED)) {
 		desc->irqs_unhandled++;
 		if (unlikely(action_ret != IRQ_NONE))
@@ -146,9 +148,24 @@ void note_interrupt(unsigned int irq, st
 
 	if (unlikely(irqfixup)) {
 		/* Don't punish working computers */
-		if ((irqfixup == 2 && ((irq == 0) ||
-				(desc->action->flags & IRQF_IRQPOLL))) ||
-				action_ret == IRQ_NONE) {
+		if (action_ret == IRQ_NONE)
+			/* Nobody handled irq. Possibly a misrouted one. */
+			call_misrouted_irq = 1;
+		else if (irqfixup == 2) {
+			/* irqpoll is enabled. Is this the irq driving
+			 * polling.
+			 */
+			if (irq == 0)
+				call_misrouted_irq = 1;
+			else {
+				spin_lock(&desc->lock);
+				if (desc->action &&
+					(desc->action->flags & IRQF_IRQPOLL))
+					call_misrouted_irq = 1;
+				spin_unlock(&desc->lock);
+			}
+		}
+		if (call_misrouted_irq) {
 			int ok = misrouted_irq(irq);
 			if (action_ret == IRQ_NONE)
 				desc->irqs_unhandled -= ok;
_
