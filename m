Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZFCJQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZFCJQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZFCJP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:15:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36922 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbZFCJP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:15:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13306] hibernate slow on _second_ run
Date: Wed, 3 Jun 2009 11:16:04 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <200906012248.49304.rjw@sisk.pl> <1244018021.10665.4.camel@johannes.local>
In-Reply-To: <1244018021.10665.4.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906031116.05114.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 June 2009, Johannes Berg wrote:
> On Mon, 2009-06-01 at 22:48 +0200, Rafael J. Wysocki wrote:
> > > No, it's now hanging 20 seconds much later, after returning to
> > > userspace :( But the dmesg log still has a hang of ~20.5 seconds just
> > > like before, between two kernel messages...
> > 
> > Hmm.  Can you try to comment out suspend_device_irqs() and resume_device_irqs()
> > in drivers/base/power/main.c and see what happens?
> 
> Oddly, that does seem to help. I'm sure it can't be a solution though :)

Not really. ;-)

Still, something like the (untested) patch below can be.  Can you please give
it a try?

Rafael

---
 kernel/irq/manage.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -187,9 +187,9 @@ static inline int setup_affinity(unsigne
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 {
 	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_TIMER))
-			return;
-		desc->status |= IRQ_SUSPENDED;
+		if (desc->action && !(desc->action->flags & IRQF_TIMER))
+			desc->status |= IRQ_SUSPENDED | IRQ_DISABLED;
+		return;
 	}
 
 	if (!desc->depth++) {
@@ -250,8 +250,12 @@ EXPORT_SYMBOL(disable_irq);
 
 void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
-	if (resume)
+	if (resume) {
 		desc->status &= ~IRQ_SUSPENDED;
+		if (!desc->depth)
+			desc->status &= ~IRQ_DISABLED;
+		return;
+	}
 
 	switch (desc->depth) {
 	case 0:
