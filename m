Return-Path: <linux-kernel-owner+w=401wt.eu-S1751089AbXBFH5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089AbXBFH5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 02:57:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXBFH5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 02:57:02 -0500
Received: from cantor.suse.de ([195.135.220.2]:56352 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbXBFH5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 02:57:00 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Missing critical phys_to_virt in lib/swiotlb.c
Date: Tue, 6 Feb 2007 08:56:45 +0100
User-Agent: KMail/1.9.5
Cc: David Moore <dcm@mit.edu>, linux-kernel <linux-kernel@vger.kernel.org>,
       discuss@x86-64.org,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Jan Beulich <jbeulich@novell.com>
References: <1170614380.26464.52.camel@PISCES.MIT.EDU> <20070205133556.9b290d0a.akpm@linux-foundation.org>
In-Reply-To: <20070205133556.9b290d0a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702060856.45473.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 22:35, Andrew Morton wrote:
> On Sun, 04 Feb 2007 13:39:40 -0500
> David Moore <dcm@MIT.EDU> wrote:
> 
> > From: David Moore <dcm@acm.org>
> > 
> > Adds missing call to phys_to_virt() in the
> > lib/swiotlb.c:swiotlb_sync_sg() function.  Without this change, a kernel
> > panic will always occur whenever a SWIOTLB bounce buffer from a
> > scatter-gather list gets synced.
> > 
> > Signed-off-by: David Moore <dcm@acm.org>
> > ---
> > 
> > This change was originally part of a larger patch by Jan Beulich, which
> > was more extensive and doesn't look destined to make it into 2.6.20:
> > http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/ia64-swiotlb-bug-fixes.patch
> > 
> > However, considering the severity of this one-liner bug, I would like to
> > request that this simplified patch make it into 2.6.20, despite how
> > close we are to the final cut.  It fixes real crashes:
> > http://lists.opensuse.org/opensuse-bugs/2006-12/msg02943.html
> > http://qa.mandriva.com/show_bug.cgi?id=28224
> > http://www.pchdtv.com/forum/viewtopic.php?t=2063&sid=a959a14a4c2db0eebaab7b0df56103ce
> > 
> > --- linux-2.6.19.x86_64/lib/swiotlb.c.orig	2007-02-04 13:18:41.000000000 -0500
> > +++ linux-2.6.19.x86_64/lib/swiotlb.c	2007-02-04 13:19:43.000000000 -0500
> > @@ -750,7 +750,7 @@ swiotlb_sync_sg(struct device *hwdev, st
> >  
> >  	for (i = 0; i < nelems; i++, sg++)
> >  		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
> > -			sync_single(hwdev, (void *) sg->dma_address,
> > +			sync_single(hwdev, phys_to_virt(sg->dma_address),
> >  				    sg->dma_length, dir, target);
> >  }
> >  
> 
> argh.  I didn't know that Jan's patches fixed crashes.  I thought they were
> ia64-only things.

Sounds weird. If this really didn't work much more should be broken
(e.g. no cdroms/sound on Intel x86-64 boxes with >4GB) 
I'm a little sceptical. Perhaps the TV driver is doing something bogus
here? 

Also I haven't heard of this problem before at all and I'm sure I would
have if sounds/cdroms were broken.

Shouldn't be applied without further analysis.

> Who maintains the swiotlb code?

Nobody. But I hacked last on it.

-Andi
