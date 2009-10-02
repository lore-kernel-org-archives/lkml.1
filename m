Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbZJBEmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbZJBEmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 00:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZJBEmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 00:42:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:51475 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZJBEmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 00:42:22 -0400
From: Neil Brown <neilb@suse.de>
To: David Rientjes <rientjes@google.com>
Date: Fri, 2 Oct 2009 14:43:34 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19141.34038.274185.392663@notabene.brown>
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 04/31] mm: tag reseve pages
In-Reply-To: message from David Rientjes on Thursday October 1
References: <1254405917-15796-1-git-send-email-sjayaraman@suse.de>
	<alpine.DEB.1.00.0910011407390.32006@chino.kir.corp.google.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday October 1, rientjes@google.com wrote:
> On Thu, 1 Oct 2009, Suresh Jayaraman wrote:
> 
> > Index: mmotm/mm/page_alloc.c
> > ===================================================================
> > --- mmotm.orig/mm/page_alloc.c
> > +++ mmotm/mm/page_alloc.c
> > @@ -1501,8 +1501,10 @@ zonelist_scan:
> >  try_this_zone:
> >  		page = buffered_rmqueue(preferred_zone, zone, order,
> >  						gfp_mask, migratetype);
> > -		if (page)
> > +		if (page) {
> > +			page->reserve = !!(alloc_flags & ALLOC_NO_WATERMARKS);
> >  			break;
> > +		}
> >  this_zone_full:
> >  		if (NUMA_BUILD)
> >  			zlc_mark_zone_full(zonelist, z);
> 
> page->reserve won't necessary indicate that access to reserves was 
> _necessary_ for the allocation to succeed, though.  This will mark any 
> page being allocated under PF_MEMALLOC as reserve when all zones may be 
> well above their min watermarks.

Normally if zones are above their watermarks, page->reserve will not
be set.
This is because __alloc_page_nodemask (which seems to be the main
non-inline entrypoint) first calls get_page_from_freelist with
alloc_flags set to ALLOC_WMARK_LOW|ALLOC_CPUSET.
Only if this fails does __alloc_page_nodemask call
__alloc_pages_slowpath which potentially sets ALLOC_NO_WATERMARKS in
alloc_flags.

So page->reserved being set actually tells us:
  PF_MEMALLOC or GFP_MEMALLOC were used, and
  a WMARK_LOW allocation attempt failed very recently

which is close enough to "the emergency reserves were used" I think.

Thanks,
NeilBrown
