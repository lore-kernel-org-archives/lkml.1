Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZGTKij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZGTKij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 06:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZGTKih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 06:38:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbZGTKig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 06:38:36 -0400
Date: Mon, 20 Jul 2009 12:38:35 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>
Subject: Re: [RFC/PATCH] mm: Pass virtual address to [__]p{te,ud,md}_free_tlb()
Message-ID: <20090720103835.GB7070@wotan.suse.de>
References: <20090715074952.A36C7DDDB2@ozlabs.org> <20090715135620.GD7298@wotan.suse.de> <1247709255.27937.5.camel@pasglop> <20090720081054.GH7298@wotan.suse.de> <1248084041.30899.7.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248084041.30899.7.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 08:00:41PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-07-20 at 10:10 +0200, Nick Piggin wrote:
> > 
> > Maybe I don't understand your description correctly. The TLB contains
> > PMDs, but you say the HW still logically performs another translation
> > step using entries in the PMD pages? If I understand that correctly,
> > then generic mm does not actually care and would logically fit better
> > if those entries were "linux ptes". 
> 
> They are :-)
> 
> > The pte invalidation routines
> > give the virtual address, which you could use to invalidate the TLB.
> 
> For PTEs, yes, but not for those PMD entries. IE. I need the virtual
> address when destroying PMDs so that I can invalidate those "indirect"
> pages. PTEs are already taken care of by existing mechanisms.

Hmm, so even after having invalidated all the pte translations
then you still need to invalidate the empty indirect page? (or
maybe you don't even invalidate the ptes if they're not cached
in a TLB).

I believe x86 is also allowed to cache higher level page tables
in non-cache coherent storage, and I think it just avoids this
issue by flushing the entire TLB when potentially tearing down
upper levels. So in theory I think your patch could allow x86 to
use invlpg more often as well (in practice the flush-all case
and TLB refills are so fast in comparison with invlpg that it
probably doesn't gain much especially when talking about
invalidating upper levels). So making the generic VM more
flexible like that is no problem for me.

