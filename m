Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbXJOXLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbXJOXLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXJOXLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:11:35 -0400
Received: from waste.org ([66.93.16.53]:34300 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbXJOXLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:11:34 -0400
Date: Mon, 15 Oct 2007 18:11:06 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 10/11] maps3: add /proc/kpagecount and /proc/kpageflags interfaces
Message-ID: <20071015231106.GX19691@waste.org>
References: <11.290135367@selenic.com> <1192488513.6118.98.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192488513.6118.98.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 03:48:33PM -0700, Dave Hansen wrote:
> On Mon, 2007-10-15 at 17:26 -0500, Matt Mackall wrote:
> > From: Matt Mackall <mpm@selenic.com>
> > 
> > This makes physical page map counts available to userspace. Together
> > with /proc/pid/pagemap and /proc/pid/clear_refs, this can be used to
> > monitor memory usage on a per-page basis.
> ...
> > +       while (count > 0) {
> > +               ppage = pfn_to_page(pfn++);
> > +               if (!ppage)
> > +                       pflags = 0;
> > +               else
> > +                       pflags = ppage->flags;
> > +
> 
> This one makes me worry a little bit.  Are we sure that this won't
> expose a wee bit too much to userspace?
> 
> I can see it making sense to clear the page refs, then inspect whether
> the page has been referenced again.  But, I worry that people are going
> to start doing things like read NUMA, SPARSEMEM, or other internal
> information out of these.

Hmm, I would have thought you'd find the NUMA bits especially interesting.
Being able to, say, colorize a process' memory map by what nodes its
pages land on could be very telling.

> I've seen quite a few patches lately that do creative things with these
> *cough*clameter*cough*, and I worry that they're too fluid to get
> exposed to userspace.

That is a concern. In general, I think getting too cute with page
flags and struct page in general is a bad idea because the rules here
are already so complex/fragile/confusing/underdocumented, but there's
definitely a lot of pressure in that direction.
 
> Could we just have /proc/kpagereferenced?  Is there a legitimate need
> for other flags to be visible?

Referenced, dirty, uptodate, lru, active, slab, writeback, reclaim,
and buddy all look like they might be interesting to me from the point
of view of watching what's happening in the VM graphically in
real-time.

For instance, watching the slab bit I can watch a 'find /' fill up
huge swaths of contiguous dcache memory, then get fragmented to hell
and never recover when I do a large userspace malloc. In other words,
this thing actually lets you see all the crap that happens in the VM
that we usually handwave about.

-- 
Mathematics is the supreme nostalgia of our time.
