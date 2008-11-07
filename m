Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbYKGLEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbYKGLEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbYKGLE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:04:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60472 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbYKGLEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:04:24 -0500
Date: Fri, 7 Nov 2008 09:06:13 -0200
From: Glauber Costa <glommer@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] restart search at beggining of vmalloc address
Message-ID: <20081107110613.GA15827@poweredge.glommer>
References: <1226005106-4974-1-git-send-email-glommer@redhat.com> <20081107002742.GA12135@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107002742.GA12135@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 01:27:42AM +0100, Nick Piggin wrote:
> Excellent, thank you! Good catch
> 
> If you agree my previous patch was also good in combination with this one,
> then I'll send them all to be merged.
I'll test it with conjunction with my patch to be sure it does not retrigger
the bug I had. But I'm sure it won't (famous last words)

I also had two more patches that I wrote that aided me in debugging this, that
I'd like to see included:
 * the first shows the size of the failing allocation: We can see current allocations
   with /proc/vmallocinfo, but it's hard to get a grasp at what's the size of the allocation
   that just failed, because it is not registered.
 * the second, shows the real name of the callers in vmallocinfo, instead of things like
   "vmalloc_32", which is just an intermediate.

My plan was to send them today, after getting comments from you on this one.
If you think they are all reasonable, maybe we can send them all as a series.

> 
> Thanks,
> Nick
> 
> On Thu, Nov 06, 2008 at 06:58:26PM -0200, Glauber Costa wrote:
> > Current vmalloc restart search for a free area in case we
> > can't find one. The reason is there are areas which are lazily
> > freed, and could be possibly freed now. However, current implementation
> > start searching the tree from the last failing address, which is
> > pretty much by definition at the end of address space. So, we fail.
> > 
> > The proposal of this patch is to restart the search from the beginning
> > of the requested vstart address. This fixes the regression in running
> > KVM virtual machines for me, described in
> > http://lkml.org/lkml/2008/10/28/349, caused by commit
> > db64fe02258f1507e13fe5212a989922323685ce.
> > 
> > Signed-off-by: Glauber Costa <glommer@redhat.com>
> > CC: Nick Piggin <npiggin@suse.de>
> > ---
> >  mm/vmalloc.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 7db493d..6fe2003 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -378,6 +378,7 @@ found:
> >  		if (!purged) {
> >  			purge_vmap_area_lazy();
> >  			purged = 1;
> > +			addr = ALIGN(vstart, align);
> >  			goto retry;
> >  		}
> >  		if (printk_ratelimit())
> > -- 
> > 1.5.6.5
