Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYAJVO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYAJVO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYAJVOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:14:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35059 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYAJVOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:14:21 -0500
Date: Thu, 10 Jan 2008 22:16:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Message-ID: <20080110211658.GA3145@one.firstfloor.org>
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it is unsafe to access any reserved areas through "WB" not just
> mmio regions. In the above case 0xe0000000-0xf0000000 is one such
> region.

That is 2MB aligned.

> 
> Also, relying on MTRR, is like giving more importance to BIOS writer

Let's call it double checking. 

Besides MTRRs will not go away anyways. The goal is just to not
require _more_ MTRRs in Linux like currently. But using the existing
ones is no problem.

> than required :-). I think the best way to deal with MTRR is just to not
> touch it. Leave it as it is and do not try to assume that they are
> correct, as frequently they will not be.

This means you have to trust the e820 map then. It's really the
same thing.

Anyways if you don't like checking the MTRRs that's fine too, but
then the e820 map has to be trusted. If that works it is great.

If not some double checking will be needed and the MTRRs would
be more convenient for that. The code would be somewhat ugly though.


> 
> >> >> All reserved memory maps to a
> >> >> zero page. 
> >> >
> >> >Why zero page?  Why not unmap.
> >> 
> >> I had it unmapped first. Then thought of zero mapping for dd 
> >of devmem
> >> to continue working. May be there are apps that depend on that?
> >> Also, dd of devmem seems to be already broken with big memory without
> >> any of these changes.
> >
> >Exactly it's already broken.
> >
> >Anyways if someone accesses mmio through /dev/mem I think they 
> >definitely
> >want the real mappings, not a zero page.  And dev/mem should provide.
> >The trick is just to do it without caching attribute violations, 
> >but with mattr it is possible.
> 
> I don't like /dev/mem supporting access to mmio. We do not know what

But it always did that. I'm sure you'll break stuff if you forbid
it suddenly.

> attributes to use for these regions.  We can potentially map all these
> pages uncacheable. 

That is what current /dev/mem does.

> But there may be cases where reading an address can
> block too possibly?

Yes sure, machine may hang, but that was always the case and I don't
think it can be changed.

> 
> >> >Anyways you could make that a zillion times more simple by 
> >> >just rounding
> >> >the e820 areas to 2MB -- for the holes only that should be 
> >ok I think; 
> >> >i would expect them to be near always already suitably aligned.
> >> >
> >> >In short this can be all done much simpler.
> >> 
> >> On systems I tested, ACPI regions are typically not 2MB 
> >aligned. And on
> >
> >ACPI regions don't need to be unmapped.
> >
> >> some systems there are few 4k pages of reserved holes just before
> >
> >reserved shouldn't be unmapped, just holes. Do they have holes
> >there or reserved areas?
> >
> >I still hope 2MB alignment will work out.
> 
> E820 above has a combination of reserved and holes.
> The problem is that we end up depending on specific e820s and paltform
> specific problems/workarounds. This is not a real problem for i386 at

> all, as we map only < 1G memory there. 

First there is the 2GB and in theory 1/3 GB split too which are supported.
And then in theory someone could put mmio in the first 1GB anyways (e.g.
in the 1MB hole) 

I don't think you can ignore i386 here.

-Andi
