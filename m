Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbYCUSNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbYCUSNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYCUSN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:13:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756191AbYCUSN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:13:27 -0400
Date: Fri, 21 Mar 2008 11:12:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Timur Tabi <timur@freescale.com>
Cc: York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v2] Driver for Freescale 8610 and 5121 DIU
Message-Id: <20080321111228.95a7d9ab.akpm@linux-foundation.org>
In-Reply-To: <47E3DE6E.2050801@freescale.com>
References: <12059526271941-git-send-email-yorksun@freescale.com>
	<12059526274026-git-send-email-yorksun@freescale.com>
	<20080320152708.23c6c734.akpm@linux-foundation.org>
	<47E3DE6E.2050801@freescale.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 11:12:30 -0500 Timur Tabi <timur@freescale.com> wrote:

> Andrew Morton wrote:
> 
> >> +static struct diu_hw dr = {
> >> +	.mode = MFB_MODE1,
> >> +	.reg_lock = __SPIN_LOCK_UNLOCKED(old_style_spin_init),
> >> +};
> > 
> > I'm not clear on what's supposed to happen with __SPIN_LOCK_UNLOCKED().  I
> > do know that its documentation is crap.
> 
> Yes, "__SPIN_LOCK_UNLOCKED(old_style_spin_init)" is wrong.  We'll fix it.
> 
> >  static struct diu_hw dr = {
> >  	.mode = MFB_MODE1,
> > -	.reg_lock = __SPIN_LOCK_UNLOCKED(old_style_spin_init),
> > +	.reg_lock = __SPIN_LOCK_UNLOCKED(diu_hw.reg_lock),
> >  };
> 
> Yes, this is better.  Did you already make this change when you applied it to
> your -mm repo?

I did:

--- a/drivers/video/fsl-diu-fb.c~fbdev-driver-for-freescale-8610-and-5121-diu-fix
+++ a/drivers/video/fsl-diu-fb.c
@@ -274,7 +274,7 @@ static struct mfb_info mfb_template[] = 
 
 static struct diu_hw dr = {
 	.mode = MFB_MODE1,
-	.reg_lock = __SPIN_LOCK_UNLOCKED(old_style_spin_init),
+	.reg_lock = __SPIN_LOCK_UNLOCKED(dr.reg_lock),
 };
 
 static struct diu_pool pool;

> > GFP_DMA implies GFP_ATOMIC, but it's appropriate for documentation purposes.
> 
> So does that mean that "GFP_DMA | GFP_KERNEL" is always wrong?

No, that's OK too.  It's just that GFP_DMA|GFP_ATOMIC is a bit redundant
and misleading.  GFP_DMA is already atomic; the only effect of adding
GFP_ATOMIC to GFP_DMA is to add __GFP_HIGH.

Don't wory about it ;)

>  If so, this
> combination is used a lot in the kernel today.
> 
> >> +	if (virt) {
> >> +		*phys = virt_to_phys(virt);
> >> +		pr_debug("virt %p, phys=%llx\n", virt, (uint64_t) *phys);
> >> +		memset(virt, 0, size);
> > 
> > Could have used __GFP_ZERO, I guess.
> 
> I had completely forgotten about __GFP_ZERO.  Thanks.
> 
> >> +	virt = (void *) rh_alloc(&diu_ops.diu_rh_info, size, "DIU");
> > 
> > hm, I'd have expected checkpatch to whine about the space after the cast
> > there.  Whatever.
> 
> I thought a space after a cast is the right thing to do?

Last time I grepped, no-space is a lot more common.

> > please take a look, and please use checkpatch on all future patches.
> 
> Sorry, we forgot to run it again after our second version of the patch.
> 
> >> +static void free_irq_local(int irq)
> >> +{
> >> +	struct diu *hw = dr.diu_reg;
> >> +
> >> +	/* Disable all LCDC interrupt */
> >> +	out_be32(&(hw->int_mask), 0x1f);
> >> +
> >> +	free_irq(irq, 0);
> >> +}
> > 
> > and the free_irq() will go splat?
> 
> Sorry, but I don't understand what's wrong with this code.

You snipped a bit.  Earlier, request_irq() failures were ignored.  So I
think there's a code path where free_irq_local() can free an IRQ which this
driver never owned.

> We'll make the other changes you've suggested and repost.

