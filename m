Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbXJCVbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbXJCVbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbXJCVba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:31:30 -0400
Received: from waste.org ([66.93.16.53]:34082 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbXJCVb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:31:29 -0400
Date: Wed, 3 Oct 2007 16:31:12 -0500
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pgd_none_or_clear_bad strangeness?
Message-ID: <20071003213112.GV19691@waste.org>
References: <20071002222003.GL19691@waste.org> <20071003112527.GA10437@wotan.suse.de> <Pine.LNX.4.64.0710031910080.9414@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710031910080.9414@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 07:18:23PM +0100, Hugh Dickins wrote:
> On Wed, 3 Oct 2007, Nick Piggin wrote:
> > On Tue, Oct 02, 2007 at 05:20:03PM -0500, Matt Mackall wrote:
> > > In lib/pagewalk.c, I've been using the various forms of
> > > {pgd,pud,pmd}_none_or_clear_bad while walking page tables as that
> > > seemed the canonical way to do things. Lately (eg with -rc7-mm1),
> > > these have been triggering messages like "bad pgd 0x01e3" and causing
> > > nasty double faults. It appears this is actually triggered at the pmd
> > > level (mm/memory.c:116), though it appears to produce the wrong
> > > message.
> 
> I guess the "wrong message" is an artifact of pud/pmd folding;
> but I get too confused by the different levels myself to want to
> think more about it - I'll just assume it's "right" somehow ;)
> 
> > > 
> > > Has something changed here? I'm pretty sure this used to work! Is this
> 
> I don't know of anything changing here, sorry.
> 
> > > not a kosher thing to do? Does it make any sense I'd repeatedly run
> > > into a bad pmd in the middle of bash's page table right after boot?
> > > The simple _none variant seems to work, but I worry that it's papering
> > > over a real problem.
> > 
> > No, I think that should be the right thing to do for userspace pages.
> > You're not walking into a hugetlb area or a kernel mapping are you?
> > (the bad pgd: line could be important... 0x01e3 would be a linear kernel
> > mapping I think?).
> 
> I should have spent more time reading Nick's reply and less time trying
> to work it out for myself!  Yes, that's the conclusion I came to, for
> some reason you're now going beyond the user vmas and walking into the
> linear kernel mapping, which has _PAGE_GLOBAL and _PAGE_PSE bits set.

Indeed, that's precisely what's happening. I'm walking one page past
the end of userspace. 

And the reason is I changed my walker from using for loops to do/while
loops at Nick's insistance, so start==end no longer gets noticed
immediately. This also explains why the bug doesn't manifest in
lguest: no PSE mappings.

Thanks, guys!

-- 
Mathematics is the supreme nostalgia of our time.
