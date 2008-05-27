Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbYE0Jgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbYE0Jgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 05:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbYE0JgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 05:36:09 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1234 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328AbYE0JgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 05:36:06 -0400
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of
	__GFP_NORETRY
From: Miquel van Smoorenburg <mikevs@xs4all.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Glauber Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080527014720.6db68517.akpm@linux-foundation.org>
References: <20080526234940.GA1376@xs4all.net>
	 <20080527014720.6db68517.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 27 May 2008 11:35:06 +0200
Message-Id: <1211880906.23541.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 01:47 -0700, Andrew Morton wrote:
> On Tue, 27 May 2008 01:49:47 +0200 Miquel van Smoorenburg <mikevs@xs4all.net> wrote:
> 
> > Please consider the below patch for 2.6.26 (can somebody from the
> > x86 team pick this up please? Thank you)
> > 
> > 
> > 
> > [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
> > 
> > arch/x86/kernel/pci-dma.c::dma_alloc_coherent() adds __GFP_NORETRY to
> > the gfp flags before calling alloc_pages() to prevent the oom killer
> > from running.
> 
> Now, why does dma_alloc_coherent() do that?
> 
> If __GFP_FS is cleared (most cases) then we won't be calling
> out_of_memory() anyway.
> 
> If __GFP_FS _is_ set then setting __GFP_NORETRY will do much more than
> avoiding oom-killings.  It will prevent the page allocator from
> retrying and will cause the problems which one assumes (without
> evidence :() you have observed.

Ah right, this was discussed in a different thread on linux-kernel /
linux-mm. Message id <20080521113028.GA24632@xs4all.net>  or see
http://lkml.org/lkml/2008/5/21/131

> So...  why not just remove the setting of __GFP_NORETRY?  Why is it
> wrong to oom-kill things in this case?

This was the first thing I proposed, since it was already that way in
pci-dma_32.c, the __GFP_NORETRY was only added in pci-dma_64.c . Hence I
found out about this when moving boxes to a 64 bit kernel. But in
2.6.26, those two were merged.

> 
> > This has the expected side effect that that alloc_pages() doesn't
> > retry anymore. Not really a problem for dma_alloc_coherent(.. GFP_ATOMIC)
> > which is the way most drivers use it (through pci_alloc_consistent())
> > but drivers that call dma_alloc_coherent(.. GFP_KERNEL) directly can get
> > unexpected failures.
> > 
> > Until we have the mask allocator, use a new flag __GFP_NO_OOM
> > instead of __GFP_NORETRY.
> > 
> 
> But this change increases the chances of a caller getting stuck in the
> page allocator for ever, unable to make progress?

Another bandaid fix I proposed was this:

diff -ruN linux-2.6.26-rc3.orig/arch/x86/kernel/pci-dma.c linux-2.6.26-rc3/arch/x86/kernel/pci-dma.c
--- linux-2.6.26-rc3.orig/arch/x86/kernel/pci-dma.c	2008-05-18 23:36:41.000000000 +0200
+++ linux-2.6.26-rc3/arch/x86/kernel/pci-dma.c	2008-05-22 21:21:37.000000000 +0200
@@ -398,7 +398,8 @@
 		return NULL;
 
 	/* Don't invoke OOM killer */
-	gfp |= __GFP_NORETRY;
+	if (!(gfp & __GFP_WAIT))
+		gfp |= __GFP_NORETRY;
 
 #ifdef CONFIG_X86_64
 	/* Why <=? Even when the mask is smaller than 4GB it is often

This will at least make sure that when called with GFP_KERNEL, __GFP_NORETRY
is not set, while it will be set with GFP_ATOMIC.

But I concluded from the earlier discussion that there was consensus about
__GFP_NO_OOM , so I sent this patch. Now I'm most definitely not an
expert, in fact pretty ignorant really, so if there are serious objections
or a better solution, please drop this patch.

I do think the issue should still be fixed.

The minimum would be to surround the gfp |= __GFP_NORETRY with
#ifdef CONFIG_X86_64 so that at least 32 bit doesn't regress
in 2.6.26

However as dpt_i2o in 2.6.26 works on 64 bit systems now and
it calls dma_alloc_coherent(.. GFP_KERNEL) I'm afraid it might
cause instability with that driver on x86_64 (that's my main
worry. tw_cli crashing is merely inconvenient).

Mike.

