Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbYGDRKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbYGDRKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYGDRJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:09:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653AbYGDRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:09:49 -0400
Date: Fri, 4 Jul 2008 10:09:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [git patches] libata fixes for .26
In-Reply-To: <20080704131005.GA30768@havoc.gtf.org>
Message-ID: <alpine.LFD.1.10.0807040955100.2815@woody.linux-foundation.org>
References: <20080704131005.GA30768@havoc.gtf.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jul 2008, Jeff Garzik wrote:
> 
> The libata-sff change is longer than I'd like for 2.6.26-rc, but it's
> all printk changes/additions.  No behavior changes, just improved
> diagnostics upon error, something we really need in that area.

Hmm.. 

Looking at the AHCI change, I think it's still potentially buggy.

I think it is potentially buggy for two separate reasons:

 - if the interrupt happens because of some port that we don't handle, we 
   should still ACK it, in order to get rid of it. I don't think Tejun's 
   patch fixed anything at all, since it still did a binary 'and' with 
   hpriv->port_map on the bits, so it would never ACK anything that didn't 
   have a bit set, and the (bogus) interrupt would keep screaming.

 - I also wonder if / suspect that the IRQ ACK should happen _before_ we 
   handle the source of the interrupt, because otherwise if one port ends 
   up having two events in close succession (can this happen? I think so), 
   then we end up perhaps getting the irq for the first one, and handle 
   that first event, but then the second event happens immediately 
   afterwards, and before we do the writel() to ACK it, so now the 
   _hardware_ thinks we have handled both of them, even though we never 
   actually reacted to the second event.

So I think the appended (TOTALLY UNTESTED!) patch - based on top of the 
pull that I already did - might be a good idea.

NOTE! I _really_ didn't test it. I do not know how AHCI works at a low 
level, and maybe there is some reason why the IRQ ACK writel() actually 
has to happen after you've handled the event (to avoid getting a new 
interrupt immediately. But based on other controllers I've worked with, 
this is the correct way to not lose irq events.

[ And yes, the race for the irq ack issue is small. And yes, the 
  likelihood of a bogus interrupt triggering is probably small too. And 
  see above about my lack of specific knowledge about AHCI.

  So I'm sure as heck not going to commit this patch, I'm just sending it 
  out as a "Are you sure you shouldn't do it like this?" RFC patch.. ]

Hmm?

			Linus
---
 drivers/ata/ahci.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 061817a..5cfee74 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1786,12 +1786,17 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 	/* sigh.  0xffffffff is a valid return from h/w */
 	irq_stat = readl(mmio + HOST_IRQ_STAT);
-	irq_stat &= hpriv->port_map;
 	if (!irq_stat)
 		return IRQ_NONE;
 
 	spin_lock(&host->lock);
 
+	/* Ack _all_ sources of interrupts.. */
+	writel(irq_stat, mmio + HOST_IRQ_STAT);
+
+	/* ..but only care (and report as handled) about the ones we can handle */
+	irq_stat &= hpriv->port_map;
+
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap;
 
@@ -1811,9 +1816,6 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 		handled = 1;
 	}
-
-	writel(irq_stat, mmio + HOST_IRQ_STAT);
-
 	spin_unlock(&host->lock);
 
 	VPRINTK("EXIT\n");
