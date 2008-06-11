Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYFKSrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYFKSrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbYFKSrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:05 -0400
Received: from gw.goop.org ([64.81.55.164]:54066 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbYFKSrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:03 -0400
Message-ID: <48501D7C.5050600@goop.org>
Date: Wed, 11 Jun 2008 19:46:20 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] mm: vmap rewrite
References: <20080605102015.GA11366@wotan.suse.de> <484AC779.1070803@goop.org> <20080610025312.GC19404@wotan.suse.de>
In-Reply-To: <20080610025312.GC19404@wotan.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> It's harder than that even, because we don't own the page flags, so then
> clearing the PG_kalias bit would require that we make all page flags ops
> atomic in all parts of the kernel. Obviously not going to happen.
>
> The other thing we could do is have vmap layer keep some p->v translations
> around (actually it doesn't even need to go all the way to v, just a single
> bit would suffice) So I guess this would be like another page flag, but
> without the atomicity problem and without me getting angry at using another
> flag ;) Still, I'd rather not do this and slow everything else down.
>   

Yeah.  It's a bit awkward to maintain a secondary structure just to deal 
with the confluence of two edge cases (running Xen + reusing an aliased 
page in a pagetable).

> It could be switched on at runtime if Xen is running perhaps. Or the other
> thing Xen could do is keep a cache of unaliased page table pages. You
> could fill it up N pages at a time, and just do a single unmap_aliases call
> to sanitize them all; also, clean pages returned from pagetables could be
> reused. Like the quicklists things.
>   

Hm, that wouldn't be too bad (so long as it doesn't end up hiding 
gigabytes of memory away from the rest of the system ;).

> Or: doesn't the host have to do its own alias check anyway? In case of an
> AWOL guest? Why not just reuse that and trap back into the guest to fix it
> up?

That's possible, but awkward.  In many cases these updates will be 
batched, so it would become a matter of issuing a batch, then picking 
through the results to see what worked and what failed.  I suppose I 
could just do the simple flush and then if that turns out too expensive, 
do the submit-and-retry approach.

    J
