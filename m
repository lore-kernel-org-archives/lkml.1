Return-Path: <linux-kernel-owner+w=401wt.eu-S1764456AbYBUErS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764456AbYBUErS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 23:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYBUErI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 23:47:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:55184 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbYBUErF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 23:47:05 -0500
Date: Thu, 21 Feb 2008 05:47:04 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch] my mmu notifiers
Message-ID: <20080221044704.GB15215@wotan.suse.de>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random> <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220010941.GR7128@v2.random>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 02:09:41AM +0100, Andrea Arcangeli wrote:
> On Wed, Feb 20, 2008 at 12:11:57AM +0100, Nick Piggin wrote:
> > Sorry, I realise I still didn't get this through my head yet (and also
> > have not seen your patch recently). So I don't know exactly what you
> > are doing...
> 
> The last version was posted here:
> 
> http://marc.info/?l=kvm-devel&m=120321732521533&w=2
> 
> > But why does _anybody_ (why does Christoph's patches) need to invalidate
> > when they are going to be more permissive? This should be done lazily by
> > the driver, I would have thought.
> 
> This can be done lazily by the driver yes. The place where I've an
> invalidate_pages in mprotect however can also become less permissive.

That's OK, because we have to flush tlbs there too.


> It's simpler to invalidate always and it's not guaranteed the
> secondary mmu page fault is capable of refreshing the spte across a
> writeprotect fault.

I think we just have to make sure that it _can_ do writeprotect
faults. AFAIKS, that will be possible if the driver registers a
.page_mkwrite handler (actually not quite -- page_mkwrite is fairly
crap, so I have a patch to merge it together with .fault so we get
address information as well). Anyway, I really think we should do
it that way.

> In the future this can be changed to
> mprotect_pages though, so no page fault will happen in the secondary
> mmu.

Possibly, but hopefully not needed for performance. Let's wait and
see.
