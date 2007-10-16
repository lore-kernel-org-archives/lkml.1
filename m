Return-Path: <linux-kernel-owner+w=401wt.eu-S934329AbXJPRuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329AbXJPRuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXJPRuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:50:04 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:35243 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbXJPRuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:50:01 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] misc-phantom-improved-data-passing-fix
Message-id: <303243223348502.gep@pripojeni.net>
In-reply-to: <20071015163134.3ed17496.akpm@linux-foundation.org>
References: <3012721321185026886@pripojeni.net>
	<2571023650266415239@pripojeni.net>
	<20071015163134.3ed17496.akpm@linux-foundation.org>
Date: Tue, 16 Oct 2007 13:50:01 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 15 Oct 2007 09:33:49 -0700
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > phantom, improved data passing
> > 
> > this new version guarantees amb_bit switch in small enough intervals, so
> > that the device won't stop working in the middle of a movement anymore.
> > However it preserves old (openhaptics) functionality.
> > 
> > ...
> >
> > +
> > +		/* preserve amp bit (don't allow to change it when in NOT_OH) */
> > +		if (r.reg == PHN_CONTROL && (dev->status & PHB_NOT_OH))
> > +			dev->ctl_reg = r.value = (r.value & ~PHN_CTL_AMP) |
> > +				(dev->ctl_reg & PHN_CTL_AMP);
> 
> hm, is that coded as clearly and as simply as possible?  Don't think so :(

Changed below.

> >  static irqreturn_t phantom_isr(int irq, void *data)
> >  {
> >  	struct phantom_device *dev = data;
> > +	unsigned int i;
> > +	u32 ctl;
> >  
> > -	if (!(ioread32(dev->iaddr + PHN_CONTROL) & PHN_CTL_IRQ))
> > +	spin_lock(&dev->regs_lock);
> > +	ctl = ioread32(dev->iaddr + PHN_CONTROL);
> > +	if (!(ctl & PHN_CTL_IRQ)) {
> > +		spin_unlock(&dev->regs_lock);
> >  		return IRQ_NONE;
> > +	}
> >  
> >  	iowrite32(0, dev->iaddr);
> >  	iowrite32(0xc0, dev->iaddr);
> > +
> > +	if (dev->status & PHB_NOT_OH)
> > +		for (i = 0; i < min(dev->oregs.count, 8U); i++)
> 
> But this is the interrupt handler, and there's a pointer chase as well as
> the min() each time around the loop (I assume).  I doubt if the world will
> end, but it seems a bit lazy?

Hmm, the compiler isn't as smart as I though. The fix follows, thanks.

--

misc-phantom-improved-data-passing-fix

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit d1d9a974c008af6e7ad0347df7f9ca372da1bb4c
tree 9c9cda79e150a752f052831ea18f35f31c8f9a5f
parent 228d539e706cd42c2950aa26ac01590e413d8f51
author Jiri Slaby <jirislaby@gmail.com> Tue, 16 Oct 2007 16:46:28 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 16 Oct 2007 16:46:28 +0200

 drivers/misc/phantom.c |   37 ++++++++++++++++++++++++-------------
 1 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 4a610cc..cd221fd 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -113,9 +113,11 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 		pr_debug("phantom: writing %x to %u\n", r.value, r.reg);
 
 		/* preserve amp bit (don't allow to change it when in NOT_OH) */
-		if (r.reg == PHN_CONTROL && (dev->status & PHB_NOT_OH))
-			dev->ctl_reg = r.value = (r.value & ~PHN_CTL_AMP) |
-				(dev->ctl_reg & PHN_CTL_AMP);
+		if (r.reg == PHN_CONTROL && (dev->status & PHB_NOT_OH)) {
+			r.value &= ~PHN_CTL_AMP;
+			r.value |= dev->ctl_reg & PHN_CTL_AMP;
+			dev->ctl_reg = r.value;
+		}
 
 		iowrite32(r.value, dev->iaddr + r.reg);
 		ioread32(dev->iaddr); /* PCI posting */
@@ -133,7 +135,8 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 		if (dev->status & PHB_NOT_OH)
 			memcpy(&dev->oregs, &rs, sizeof(rs));
 		else {
-			for (i = 0; i < min(rs.count, 8U); i++)
+			u32 m = min(rs.count, 8U);
+			for (i = 0; i < m; i++)
 				if (rs.mask & BIT(i))
 					iowrite32(rs.values[i], dev->oaddr + i);
 			ioread32(dev->iaddr); /* PCI posting */
@@ -152,13 +155,17 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 		if (copy_to_user(argp, &r, sizeof(r)))
 			return -EFAULT;
 		break;
-	case PHN_GET_REGS:
+	case PHN_GET_REGS: {
+		u32 m;
+
 		if (copy_from_user(&rs, argp, sizeof(rs)))
 			return -EFAULT;
 
+		m = min(rs.count, 8U);
+
 		pr_debug("phantom: GRS %u regs %x\n", rs.count, rs.mask);
 		spin_lock_irqsave(&dev->regs_lock, flags);
-		for (i = 0; i < min(rs.count, 8U); i++)
+		for (i = 0; i < m; i++)
 			if (rs.mask & BIT(i))
 				rs.values[i] = ioread32(dev->iaddr + i);
 		spin_unlock_irqrestore(&dev->regs_lock, flags);
@@ -166,7 +173,7 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 		if (copy_to_user(argp, &rs, sizeof(rs)))
 			return -EFAULT;
 		break;
-	case PHN_NOT_OH:
+	} case PHN_NOT_OH:
 		spin_lock_irqsave(&dev->regs_lock, flags);
 		if (dev->status & PHB_RUNNING) {
 			printk(KERN_ERR "phantom: you need to set NOT_OH "
@@ -265,13 +272,17 @@ static irqreturn_t phantom_isr(int irq, void *data)
 	iowrite32(0, dev->iaddr);
 	iowrite32(0xc0, dev->iaddr);
 
-	if (dev->status & PHB_NOT_OH)
-		for (i = 0; i < min(dev->oregs.count, 8U); i++)
-			if (dev->oregs.mask & BIT(i))
-				iowrite32(dev->oregs.values[i], dev->oaddr + i);
+	if (dev->status & PHB_NOT_OH) {
+		struct phm_regs *r = &dev->oregs;
+		u32 m = min(r->count, 8U);
 
-	dev->ctl_reg ^= PHN_CTL_AMP;
-	iowrite32(dev->ctl_reg, dev->iaddr + PHN_CONTROL);
+		for (i = 0; i < m; i++)
+			if (r->mask & BIT(i))
+				iowrite32(r->values[i], dev->oaddr + i);
+
+		dev->ctl_reg ^= PHN_CTL_AMP;
+		iowrite32(dev->ctl_reg, dev->iaddr + PHN_CONTROL);
+	}
 	spin_unlock(&dev->regs_lock);
 
 	ioread32(dev->iaddr); /* PCI posting */
