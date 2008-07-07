Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYGGSZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYGGSZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYGGSZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:25:24 -0400
Received: from waste.org ([66.93.16.53]:60616 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbYGGSZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:25:24 -0400
Subject: Re: *sigh* /proc/*/pagemap
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linuxfoundation.org,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.1.10.0807051036000.2815@woody.linux-foundation.org>
References: <b6fcc0a0807041807p24cce461m419d7b54fce72d34@mail.gmail.com>
	 <20080704185312.052e7145.akpm@linux-foundation.org>
	 <alpine.LFD.1.10.0807051036000.2815@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 13:23:17 -0500
Message-Id: <1215454997.11311.165.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-07-05 at 10:40 -0700, Linus Torvalds wrote:
> 
> On Fri, 4 Jul 2008, Andrew Morton wrote:
> >  	int pagecount;
> >  	int ret = -ESRCH;
> > +	static struct mm_walk pagemap_walk;
> >  
> ...
> >  
> > +	pagemap_walk.pmd_entry = pagemap_pte_range;
> > +	pagemap_walk.pte_hole = pagemap_pte_hole;
> > +	pagemap_walk.mm = mm;
> > +	pagemap_walk.private = &pm;
> > +
> 
> No can do. You have one single pagemap_walk, but perhaps multiple users, 
> who all disagree about what it should contain.

[Sorry, been out of town for a few days.]

This bug got introduced a couple weeks ago when we revamped things to
deal with hugepages not being marked in pagetables on non-x86 despite
the existence of the relevant helper functions.

> Quite frankly, I think we should just remove the whole f*cking crap. I 
> think it's also potentially a security hole to give physical page 
> information and swap info - even if it's just your own pages.

It does expose information that can be used to advantage, sure. But it's
not a hole in the sense that it can be exploited on its own. If you can
read or write directly to/from physical pages or swap, you already own
the box and this just makes your job easier.

> Matt, can you explain what the point was of this whole thing? I'm really 
> _this_ close to just removing the POS right now. It's been a big source of 
> bugs, and it looks entirely pointless.

It exists to make the VM stop being a big black box. Before now the VM
exposed little beyond statistics, many of which are basically
meaningless (RSS?). With pagemap, you can actually see precisely where
things are getting allocated, how they're getting shared, etc. Think
NUMA, think cell phones.

Here's an example: for most of time, the page allocators have handed
back pages in reverse order. So a series of sequential pages in a
mapping would show up in pessimal order in terms of I/O coalescing (it
was basically never happening). This was discovered a few years ago with
painstaking debugging (why was coalescing so rare?), fixed, and then
promptly broken again.

When I first got pagemap working, I immediately spotted the regression
with hexdump without even looking for it: all the PFNs were counting
backwards. No statistic is ever going to give you that level of detail.

-- 
Mathematics is the supreme nostalgia of our time.

