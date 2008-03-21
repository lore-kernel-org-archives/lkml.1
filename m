Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYCUQNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYCUQNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYCUQNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:13:36 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:64246 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYCUQNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:13:35 -0400
Message-ID: <47E3DE6E.2050801@freescale.com>
Date: Fri, 21 Mar 2008 11:12:30 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v2] Driver for Freescale 8610 and 5121 DIU
References: <12059526271941-git-send-email-yorksun@freescale.com>	<12059526274026-git-send-email-yorksun@freescale.com> <20080320152708.23c6c734.akpm@linux-foundation.org>
In-Reply-To: <20080320152708.23c6c734.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>> +static struct diu_hw dr = {
>> +	.mode = MFB_MODE1,
>> +	.reg_lock = __SPIN_LOCK_UNLOCKED(old_style_spin_init),
>> +};
> 
> I'm not clear on what's supposed to happen with __SPIN_LOCK_UNLOCKED().  I
> do know that its documentation is crap.

Yes, "__SPIN_LOCK_UNLOCKED(old_style_spin_init)" is wrong.  We'll fix it.

>  static struct diu_hw dr = {
>  	.mode = MFB_MODE1,
> -	.reg_lock = __SPIN_LOCK_UNLOCKED(old_style_spin_init),
> +	.reg_lock = __SPIN_LOCK_UNLOCKED(diu_hw.reg_lock),
>  };

Yes, this is better.  Did you already make this change when you applied it to
your -mm repo?

> GFP_DMA implies GFP_ATOMIC, but it's appropriate for documentation purposes.

So does that mean that "GFP_DMA | GFP_KERNEL" is always wrong?  If so, this
combination is used a lot in the kernel today.

>> +	if (virt) {
>> +		*phys = virt_to_phys(virt);
>> +		pr_debug("virt %p, phys=%llx\n", virt, (uint64_t) *phys);
>> +		memset(virt, 0, size);
> 
> Could have used __GFP_ZERO, I guess.

I had completely forgotten about __GFP_ZERO.  Thanks.

>> +	virt = (void *) rh_alloc(&diu_ops.diu_rh_info, size, "DIU");
> 
> hm, I'd have expected checkpatch to whine about the space after the cast
> there.  Whatever.

I thought a space after a cast is the right thing to do?

> please take a look, and please use checkpatch on all future patches.

Sorry, we forgot to run it again after our second version of the patch.

>> +static void free_irq_local(int irq)
>> +{
>> +	struct diu *hw = dr.diu_reg;
>> +
>> +	/* Disable all LCDC interrupt */
>> +	out_be32(&(hw->int_mask), 0x1f);
>> +
>> +	free_irq(irq, 0);
>> +}
> 
> and the free_irq() will go splat?

Sorry, but I don't understand what's wrong with this code.

We'll make the other changes you've suggested and repost.

-- 
Timur Tabi
Linux kernel developer at Freescale
