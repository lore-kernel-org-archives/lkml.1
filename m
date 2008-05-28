Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbYE1Icp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbYE1Icp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 04:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYE1Ich
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 04:32:37 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2269 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYE1Icg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 04:32:36 -0400
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of
	__GFP_NORETRY
From: Miquel van Smoorenburg <mikevs@xs4all.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>, mikevs@xs4all.net
In-Reply-To: <20080528024727.GB20824@one.firstfloor.org>
References: <20080526234940.GA1376@xs4all.net>
	 <20080527014720.6db68517.akpm@linux-foundation.org>
	 <20080528024727.GB20824@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 28 May 2008 10:31:25 +0200
Message-Id: <1211963485.28138.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-28 at 04:47 +0200, Andi Kleen wrote:
> > So...  why not just remove the setting of __GFP_NORETRY?  Why is it
> > wrong to oom-kill things in this case?
> 
> When the 16MB zone overflows (which can be common in some workloads)
> calling the OOM killer is pretty useless because it has barely any 
> real user data [only exception would be the "only 16MB" case Alan
> mentioned]. Killing random processes in this case is bad. 
> 
> I think for 16MB __GFP_NORETRY is ok because there should be 
> nothing freeable in there so looping is useless. Only exception would be the 
> "only 16MB total" case again but I'm not sure 2.6 supports that at all
> on x86.
> 
> On the other hand d_a_c() does more allocations than just 16MB, especially
> on 64bit and the other zones need different strategies.

Okay, so how about this then ?

--- linux-2.6.26-rc4.orig/arch/x86/kernel/pci-dma.c	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4/arch/x86/kernel/pci-dma.c	2008-05-28 10:27:41.000000000 +0200
@@ -397,9 +397,6 @@
 	if (dev->dma_mask == NULL)
 		return NULL;
 
-	/* Don't invoke OOM killer */
-	gfp |= __GFP_NORETRY;
-
 #ifdef CONFIG_X86_64
 	/* Why <=? Even when the mask is smaller than 4GB it is often
 	   larger than 16MB and in this case we have a chance of
@@ -410,7 +407,9 @@
 #endif
 
  again:
-	page = dma_alloc_pages(dev, gfp, get_order(size));
+	/* Don't invoke OOM killer or retry in lower 16MB DMA zone */
+	page = dma_alloc_pages(dev,
+		(gfp & GFP_DMA) ? gfp | __GFP_NORETRY : gfp, get_order(size));
 	if (page == NULL)
 		return NULL;
 

Mike.

