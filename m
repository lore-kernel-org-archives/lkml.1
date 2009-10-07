Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbZJGMJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbZJGMJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbZJGMJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:09:06 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:19669 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758841AbZJGMJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:09:05 -0400
X-Trace: 267886270/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.16.54/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.16.54
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAPwhzEpQKRA2/2dsb2JhbACBUdM/hCoEgVQ
X-IronPort-AV: E=Sophos;i="4.44,519,1249254000"; 
   d="scan'208";a="267886270"
Date: Wed, 7 Oct 2009 13:08:17 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Jan Beulich <JBeulich@novell.com>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adjust gfp mask passed on nested vmalloc()  invocation
In-Reply-To: <4ACC62DC0200007800018690@vpn.id2.novell.com>
Message-ID: <Pine.LNX.4.64.0910071300330.28844@sister.anvils>
References: <4AC9E38E0200007800017F57@vpn.id2.novell.com>
 <Pine.LNX.4.64.0910062241500.21409@sister.anvils> <4ACC62DC0200007800018690@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Jan Beulich wrote:
> >>> Hugh Dickins <hugh.dickins@tiscali.co.uk> 06.10.09 23:58 >>>
> >On Mon, 5 Oct 2009, Jan Beulich wrote:
> >
> >> - fix a latent bug resulting from blindly or-ing in __GFP_ZERO, since
> >>   the combination of this and __GFP_HIGHMEM (possibly passed into the
> >>   function) is forbidden in interrupt context
> >> - avoid wasting more precious resources (DMA or DMA32 pools), when
> >>   being called through vmalloc_32{,_user}()
> >> - explicitly allow using high memory here even if the outer allocation
> >>   request doesn't allow it, unless is collides with __GFP_ZERO
> >> 
> >> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> >
> >I thought vmalloc.c was a BUG_ON(in_interrupt()) zone?
> >The locking is all spin_lock stuff, not spin_lock_irq stuff.
> >That's probably why your "bug" has remained "latent".
> 
> Then you probably mean BUG_ON(irqs_disabled()), which would seem
> correct.

I'm relieved you came to see that remark as bogus.

> But if the gfp mask massaging was needed for calling kmalloc(),
> it would seem odd that the same shouldn't be needed for calling
> vmalloc() recursively...
> 
> >Using HIGHMEM for internal arrays looks reasonable to me; but if
> >__GFP_ZERO were a problem, wouldn't it be much cleaner to skip the
> >"unless it collides" and #ifdef CONFIG_HIGHMEM !in_interrupt() stuff,
> >just memset the array returned from __vmalloc_node()?
> 
> The main goal was to change the existing code as little as possible - I
> did consider this alternative, but wasn't sure that would be accepted.
> If you view this as the better alternative, I'll certainly modify the
> patch to do it that way.

Well, now we've accepted that this code cannot be used in_interrupt(),
there's no need for your #ifdef CONFIG_HIGHMEM nor for my memset: just
use __GFP_ZERO as it was before, and your patch would amount to or'ing
__GFP_HIGHMEM into gfp_mask for the __vmalloc_node case - wouldn't it?

Hugh
