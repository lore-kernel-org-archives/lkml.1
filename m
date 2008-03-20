Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYCTXCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYCTXCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYCTXCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:02:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41596 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbYCTXCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:02:42 -0400
Subject: Re: [PATCH 1/2 v2] Driver for Freescale 8610 and 5121 DIU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       linux-fbdev-devel@lists.sourceforge.net, timur@freescale.com,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080320152708.23c6c734.akpm@linux-foundation.org>
References: <12059526271941-git-send-email-yorksun@freescale.com>
	 <12059526274026-git-send-email-yorksun@freescale.com>
	 <20080320152708.23c6c734.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 00:02:16 +0100
Message-Id: <1206054136.6437.67.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 15:27 -0700, Andrew Morton wrote:

> >
> > +static struct diu_hw dr = {
> > +	.mode = MFB_MODE1,
> > +	.reg_lock = __SPIN_LOCK_UNLOCKED(old_style_spin_init),
> > +};
> 
> I'm not clear on what's supposed to happen with __SPIN_LOCK_UNLOCKED().  I
> do know that its documentation is crap.
> 
> I guess you should have used SPIN_LOCK_UNLOCKED there rather than
> open-coding its equivalent.  And SPIN_LOCK_UNLOCKED _is_ documented.  It
> says "don't use this".
> 
> Now, s/documentation/guesswork-and-grep/ says that you're supposed to pick
> a tree-wide-unique string here as your lockdep key.
> 
> So I did this:
> 
> --- a/drivers/video/fsl-diu-fb.c~fbdev-driver-for-freescale-8610-and-5121-diu-fix
> +++ a/drivers/video/fsl-diu-fb.c
> @@ -274,7 +274,7 @@ static struct mfb_info mfb_template[] = 
>  
>  static struct diu_hw dr = {
>  	.mode = MFB_MODE1,
> -	.reg_lock = __SPIN_LOCK_UNLOCKED(old_style_spin_init),
> +	.reg_lock = __SPIN_LOCK_UNLOCKED(diu_hw.reg_lock),
>  };

#define __SPIN_LOCK_UNLOCKED(lockname)

seems pretty suggestive to me, also DEFINE_SPINLOCK(x) shows the proper
usage; the right thing would have been:

static struct diu_hw dr = {
 	.mode = MFB_MODE1,
-	.reg_lock = __SPIN_LOCK_UNLOCKED(old_style_spin_init),
+	.reg_lock = __SPIN_LOCK_UNLOCKED(dr.reg_lock),
};

Where 'dr.reg_lock' is the expression to locate the actual object.

Does something like this make sense to you:

---
Subject: lockdep: document __SPIN_LOCK_UNLOCKED() usage

Small comment clarifying the intended usage of __SPIN_LOCK_UNLOCKED()

[ for the observant readers; yes this prescribes a usage that is more
  than strictly needed, it does however enable interesting future uses ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
index 68d88f7..4278558 100644
--- a/include/linux/spinlock_types.h
+++ b/include/linux/spinlock_types.h
@@ -63,6 +63,10 @@ typedef struct {
 # define RW_DEP_MAP_INIT(lockname)
 #endif
 
+/*
+ * __*_LOCK_UNLOCKED(lockname), where 'lockname' is a valid C expression
+ * that evaluates to the actual object being initialized.
+ */
 #ifdef CONFIG_DEBUG_SPINLOCK
 # define __SPIN_LOCK_UNLOCKED(lockname)					\
 	(spinlock_t)	{	.raw_lock = __RAW_SPIN_LOCK_UNLOCKED,	\
---

Perhaps I should make the macros do something like:

  typecheck(spinlock_t, lockname)

And sweep the tree to make it compile again.

>  static struct diu_pool pool;
> 
> > +static struct diu_pool pool;
> > +
> > +/*	To allocate memory for framebuffer. First try __get_free_pages(). If it
> > + *	fails, try rh_alloc. The reason is __get_free_pages() cannot allocate
> > + *	very large memory (more than 4MB). We don't want to allocate all memory
> > + *	in rheap since small memory allocation/deallocation will fragment the
> > + *	rheap and make the furture large allocation fail.
> > + */
> > +
> > +void *fsl_diu_alloc(unsigned long size, phys_addr_t *phys)
> > +{
> > +	void *virt;
> > +
> > +	pr_debug("size=%lu\n", size);
> > +
> > +	virt = (void *)__get_free_pages(GFP_DMA | GFP_ATOMIC, get_order(size));
> 
> GFP_DMA implies GFP_ATOMIC, but it's appropriate for documentation purposes.

FWIW, I prefer the form: GFP_type | __GFP_modifiers

For instance: 'GFP_KERNEL | __GFP_DMA | __GFP_ZERO'



