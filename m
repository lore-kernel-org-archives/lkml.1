Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbYE3VoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbYE3VoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 17:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbYE3VoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 17:44:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754871AbYE3Vn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 17:43:57 -0400
Date: Fri, 30 May 2008 14:43:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
In-Reply-To: <Pine.LNX.4.64.0805302017580.16427@blonde.site>
Message-ID: <alpine.LFD.1.10.0805301403540.3141@woody.linux-foundation.org>
References: <48402DAA.60202@linux.intel.com> <Pine.LNX.4.64.0805302017580.16427@blonde.site>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Hugh Dickins wrote:
>
> On Fri, 30 May 2008, Arjan van de Ven wrote:
> > 
> > Rank 7: set_page_address (oops)
> > 	Reported 53 times (65 total reports)
> > 	crash coming from flush_all_zero_pkmaps; was this fixed by Hugh the
> > 	other day?
> 
> No, not at all.  But I'll have a little ponder over it.

It's a BUG_ON(), but sadly the oops gatherer doesn't seem to gather that 
part. You can see it from the code portion: the "<0f> 0b" gives it away 
(that's the ud2 opcode).

There's two BUG_ON()'s in that function, and I think it's the second one, 
based on at least the code generation that my particular compiler version 
gets. IOW, it would be the

	BUG_ON(list_empty(&page_address_pool));

thing.

Why would we run out of the page-address pool? Or perhaps the right 
question is what actually protects us from _not_ running out? 

We seem to depend on the page_address_pool always being in sync with the 
pkmap_count[] array, but the fact is, they are not protected by the same 
locks. The array is protected by kmap_lock, and the page_address_pool is 
protected by the "pool_lock".

And even if they were to nest properly (I don't think they do), we 
actually do the list_empty(&page_address_pool) outside the pool lock, 
so...

I dunno. That code is really messy. Why does it have two locks for the 
data structures when it then seems to absolutely require that they are 
always coherent? And if we want to have separate locks, we cannot require 
that they are in lock-step, perhaps we should have more pages in the 
page_address_pool than strictly required since they may not be 1:1?

I do hate that mm/highmem.c mess, but I also wonder what made it start to 
trigger if it's a bug there. That code hasn't changed in ages, afaik.

I don't think this is Hugh's fault, but on the other hand I think it would 
be great if Hugh looked at it. I think most of that code predates even the 
BK repo - because I'm not finding any history for it even in the 
historical archives. Who dares look at it?

			Linus
