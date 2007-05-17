Return-Path: <linux-kernel-owner+w=401wt.eu-S1762811AbXEQG1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762811AbXEQG1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbXEQG1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:27:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:60917 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbXEQG1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:27:39 -0400
Date: Thu, 17 May 2007 08:27:30 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] optimise unlock_page
Message-ID: <20070517062729.GA14350@wotan.suse.de>
References: <Pine.LNX.4.64.0705101935590.18496@blonde.wat.veritas.com> <20070511085424.GA15352@wotan.suse.de> <Pine.LNX.4.64.0705111357120.3350@blonde.wat.veritas.com> <20070513033210.GA3667@wotan.suse.de> <Pine.LNX.4.64.0705130535410.3015@blonde.wat.veritas.com> <20070513065246.GA15071@wotan.suse.de> <Pine.LNX.4.64.0705161838080.16762@blonde.wat.veritas.com> <20070516181847.GD5883@wotan.suse.de> <Pine.LNX.4.64.0705161946170.28185@blonde.wat.veritas.com> <alpine.LFD.0.98.0705161242520.3890@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705161242520.3890@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 12:47:54PM -0700, Linus Torvalds wrote:
> 
> On Wed, 16 May 2007, Hugh Dickins wrote:
> 
> > > The other option of moving the bit into ->mapping hopefully avoids all
> > > the issues, and would probably be a little faster again on the P4, at the
> > > expense of being a more intrusive (but it doesn't look too bad, at first
> > > glance)...
> > 
> > Hmm, I'm so happy with PG_swapcache in there, that I'm reluctant to
> > cede it to your PG_locked, though I can't deny your use should take
> > precedence.  Perhaps we could enforce 8-byte alignment of struct
> > address_space and struct anon_vma to make both bits available
> > (along with the anon bit).
> 
> We probably could. It should be easy enough to mark "struct address_space" 
> to be 8-byte aligned.

Yeah, it might be worthwhile, because I agree that PG_swapcache would
work nicely there too.


> > But I think you may not be appreciating how intrusive PG_locked
> > will be.  There are many references to page->mapping (often ->host)
> > throughout fs/ : when we keep anon/swap flags in page->mapping, we
> > know the filesystems will never see those bits set in their pages,
> > so no page_mapping-like conversion is needed; just a few places in
> > common code need to adapt.
> 
> You're right, it could be really painful. We'd have to rename the field, 
> and use some inline function to access it (which masks off the low bits).

Yeah, I realise that the change is intrusive in terms of lines touched,
but AFAIKS, it should not be much more complex than a search/replace...

As far as deprecating things goes... I don't think we have to wait too
long, its more for features, drivers, or more fundamental APIs isn't it?
If we just point out that one must use set_page_mapping/page_mapping
rather than page->mapping, it is trivial to fix any out of tree breakage.

