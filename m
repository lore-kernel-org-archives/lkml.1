Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYE0It2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYE0It2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbYE0ItO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:49:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757500AbYE0ItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:49:12 -0400
Date: Tue, 27 May 2008 01:47:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Andi Kleen <andi@firstfloor.org>, Glauber Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of
 __GFP_NORETRY
Message-Id: <20080527014720.6db68517.akpm@linux-foundation.org>
In-Reply-To: <20080526234940.GA1376@xs4all.net>
References: <20080526234940.GA1376@xs4all.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 01:49:47 +0200 Miquel van Smoorenburg <mikevs@xs4all.net> wrote:

> Please consider the below patch for 2.6.26 (can somebody from the
> x86 team pick this up please? Thank you)
> 
> 
> 
> [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
> 
> arch/x86/kernel/pci-dma.c::dma_alloc_coherent() adds __GFP_NORETRY to
> the gfp flags before calling alloc_pages() to prevent the oom killer
> from running.

Now, why does dma_alloc_coherent() do that?

If __GFP_FS is cleared (most cases) then we won't be calling
out_of_memory() anyway.

If __GFP_FS _is_ set then setting __GFP_NORETRY will do much more than
avoiding oom-killings.  It will prevent the page allocator from
retrying and will cause the problems which one assumes (without
evidence :() you have observed.

So...  why not just remove the setting of __GFP_NORETRY?  Why is it
wrong to oom-kill things in this case?

> This has the expected side effect that that alloc_pages() doesn't
> retry anymore. Not really a problem for dma_alloc_coherent(.. GFP_ATOMIC)
> which is the way most drivers use it (through pci_alloc_consistent())
> but drivers that call dma_alloc_coherent(.. GFP_KERNEL) directly can get
> unexpected failures.
> 
> Until we have the mask allocator, use a new flag __GFP_NO_OOM
> instead of __GFP_NORETRY.
> 

But this change increases the chances of a caller getting stuck in the
page allocator for ever, unable to make progress?

