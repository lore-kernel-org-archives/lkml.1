Return-Path: <linux-kernel-owner+w=401wt.eu-S1767012AbXDSUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767012AbXDSUKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767018AbXDSUKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:10:39 -0400
Received: from waste.org ([66.93.16.53]:39322 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767012AbXDSUKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:10:38 -0400
Date: Thu, 19 Apr 2007 14:58:06 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] maps#2: Add /proc/pid/pagemap interface
Message-ID: <20070419195806.GE11115@waste.org>
References: <13.469046093@selenic.com> <1177009949.12599.154.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177009949.12599.154.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 12:12:29PM -0700, Dave Hansen wrote:
> On Fri, 2007-04-06 at 17:03 -0500, Matt Mackall wrote:
> > 
> > +static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned
> > long end,
> > +                            void *private)
> > +{
> > +       struct pagemapread *pm = private;
> > +       pte_t *pte;
> > +       int err;
> > +
> > +       pte = pte_offset_map(pmd, addr);
> > +       for (; addr != end; pte++, addr += PAGE_SIZE) {
> > +               if (addr < pm->next)
> > +                       continue;
> > +               if (!pte_present(*pte))
> > +                       err = add_to_pagemap(addr, -1, pm);
> > +               else
> > +                       err = add_to_pagemap(addr, pte_pfn(*pte), pm);
> > +               if (err)
> > +                       return err;
> > +       }
> > +       pte_unmap(pte - 1);
> > +       return 0;
> > +} 
> 
> Sorry for the horribly late reply. ;)
> 
> Would you have any problems with this being extended for the !
> pte_present() case to show pages that happen to be in swap?
> 
> I'm playing with some process checkpoint/restart code, and using the
> existing swap mechanisms to get the current memory contents out of the
> process.  I've also created a hackish syscall to make a pretty raw dump
> of pte contents.
> 
> Perhaps we could steal the high bits of the pfn and have its presence in
> swap, plus some handle to which swapfile it is in.  Or, would you rather
> I just create a new /proc file that utilizes most of the code you
> already put in place, and _just_ deals with swap?

It seems reasonable to deal with swap here in some fashion. It's just
a matter of how. Current swap entries aren't terribly portable.

I'm planning on using a couple high bits for exposing active/dirty.
Adding present should be fine as well.

-- 
Mathematics is the supreme nostalgia of our time.
