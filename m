Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZEQOHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZEQOHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 10:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZEQOHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 10:07:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:33085 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZEQOHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 10:07:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,208,1241420400"; 
   d="scan'208";a="143744588"
Date: Sun, 17 May 2009 22:07:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 6/6] PM/Hibernate: Do not try to allocate too much
	memory too hard
Message-ID: <20090517140712.GE3254@localhost>
References: <200905070040.08561.rjw@sisk.pl> <200905131042.18137.rjw@sisk.pl> <20090517120613.GB3254@localhost> <200905171455.06120.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905171455.06120.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 08:55:05PM +0800, Rafael J. Wysocki wrote:
> On Sunday 17 May 2009, Wu Fengguang wrote:

> > > +static unsigned long minimum_image_size(unsigned long saveable)
> > > +{
> > > +	unsigned long size;
> > > +
> > > +	/* Compute the number of saveable pages we can free. */
> > > +	size = global_page_state(NR_SLAB_RECLAIMABLE)
> > > +		+ global_page_state(NR_ACTIVE_ANON)
> > > +		+ global_page_state(NR_INACTIVE_ANON)
> > > +		+ global_page_state(NR_ACTIVE_FILE)
> > > +		+ global_page_state(NR_INACTIVE_FILE);
> > 
> > For example, we could drop the 1.25 ratio and calculate the above
> > reclaimable size with more meaningful constraints:
> > 
> >         /* slabs are not easy to reclaim */
> > 	size = global_page_state(NR_SLAB_RECLAIMABLE) / 2;
> 
> Why 1/2?

Also a very coarse value:
- we don't want to stress icache/dcache too much
  (unless they grow too large)
- my experience was that the icache/dcache are scanned in a slower
  pace than lru pages.
- most importantly, inside the NR_SLAB_RECLAIMABLE pages, maybe half
  of the pages are actually *in use* and cannot be freed:
        % cat /proc/sys/fs/inode-nr     
        30450   16605
        % cat /proc/sys/fs/dentry-state 
        41598   35731   45      0       0       0
  See? More than half entries are in-use. Sure many of them will actually
  become unused when dentries are freed, but in the mean time the internal
  fragmentations in the slabs can go up.

> >         /* keep NR_ACTIVE_ANON */
> > 	size += global_page_state(NR_INACTIVE_ANON);
> 
> Why exactly did you omit ACTIVE_ANON?

To keep the "core working set" :)
  	
> >         /* keep mapped files */
> > 	size += global_page_state(NR_ACTIVE_FILE);
> > 	size += global_page_state(NR_INACTIVE_FILE);
> >         size -= global_page_state(NR_FILE_MAPPED);
> > 
> > That restores the hard core working set logic in the reverse way ;)
> 
> I think the 1/2 factor for NR_SLAB_RECLAIMABLE may be too high in some cases,
> but I'm going to check that.

Yes, after updatedb. In that case simple magics numbers may not help.
In that case we should really first call shrink_slab() in a loop to
cut down the slab pages to a sane number.

Thanks,
Fengguang
