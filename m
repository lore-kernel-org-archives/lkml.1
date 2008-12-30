Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbYL3EBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbYL3EBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 23:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYL3EBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 23:01:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:40287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbYL3EBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 23:01:21 -0500
Date: Tue, 30 Dec 2008 05:01:18 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu, ijc@hellion.org.uk
Subject: Re: early fixmap causes kmap breakage
Message-ID: <20081230040118.GA27679@wotan.suse.de>
References: <20081218211543.GB10681@wotan.suse.de> <20081229151731.2a2c5a02.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229151731.2a2c5a02.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 03:17:31PM -0800, Andrew Morton wrote:
> On Thu, 18 Dec 2008 22:15:43 +0100
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > Hi,
> > 
> > I've debugged a problem where i386+pae systems with more than a few CPUs
> > blow up at boot in the kmap_atomic code.
> 
> ping?

No further progress here, I'm waiting on input for how to fix this
"nicely". Meantime, clearing the early fixmap pte I guess works, but
you lose a page... is it possible to put it into .initdata or is
there some issue with that? (I guess on a PAE kernel, 4K isn't a
big deal).

 
> > The problem is that the kmap_atomic pte pages all need to be contiguous
> > memory because the pte is calculated via the first kmap pte page + an
> > offset (so as not to have to walk the page tables every time).
> > 
> > The fixmap setup code crudely allocates contiguous pte pages, which is fine,
> > but if it finds an already populated pmd entry, then it will not switch it
> > to a new, contiguous pte page. So the early fixmap introduces a discontig
> > page table right in the middle of the kmap atomic fixmaps.
> > 
> > Commenting out the eaarly fixmap setup in head_32.S gets everything working
> > properly. What would be the best way to fix this? Could we put the early
> > fixmap page table in initdata, and then have the fixmap setup proper first
> > clear its corresponding pmd entry?
> 
> How come users/testers aren't reporting this?

Because apparently nobody tests 32-bit PAE systems with more than a couple
of CPUs anymore. This bug comes from HW vendor doing testing of SLES11.


