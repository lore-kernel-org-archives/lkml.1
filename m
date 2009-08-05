Return-Path: <linux-kernel-owner+w=401wt.eu-S933468AbZHELjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468AbZHELjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933075AbZHELjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:39:22 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:21770 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932657AbZHELjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:39:21 -0400
X-Trace: 238375832/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.96.74/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.96.74
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEALoLeUpQKWBK/2dsb2JhbACBUtM4hBgF
X-IronPort-AV: E=Sophos;i="4.43,328,1246834800"; 
   d="scan'208";a="238375832"
Date: Wed, 5 Aug 2009 12:39:06 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: ieidus@redhat.com, aarcange@redhat.com, riel@redhat.com, chrisw@redhat.com,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/12] ksm: pages_unshared and pages_volatile
In-Reply-To: <20090804144920.bfc6a44f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0908051216020.13195@sister.anvils>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
 <Pine.LNX.4.64.0908031311061.16754@sister.anvils>
 <20090804144920.bfc6a44f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009, Andrew Morton wrote:
> On Mon, 3 Aug 2009 13:11:53 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> 
> > pages_volatile is harder to define.  It includes those pages changing
> > too fast to get into the unstable tree, but also whatever other edge
> > conditions prevent a page getting into the trees: a high value may
> > deserve investigation.  Don't try to calculate it from the various
> > conditions: it's the total of rmap_items less those accounted for.
...
> >  static inline struct rmap_item *alloc_rmap_item(void)
> >  {
> > -	return kmem_cache_zalloc(rmap_item_cache, GFP_KERNEL);
> > +	struct rmap_item *rmap_item;
> > +
> > +	rmap_item = kmem_cache_zalloc(rmap_item_cache, GFP_KERNEL);
> > +	if (rmap_item)
> > +		ksm_rmap_items++;
> > +	return rmap_item;
> >  }
> 
> ksm_rmap_items was already available via /proc/slabinfo.  I guess that
> wasn't a particularly nice user interface ;)

procfs is not a nice interface for sysfs to be reading
when it's asked to show pages_volatile!

And not even always available, I think: SLOB wouldn't be able to report
the number of objects of any particular type, SLUB would need slub_nomerge
(or a debug flag) to keep the kmem_cache separate; and even SLAB would
have to assemble numbers from different cpus and queues, I guess.
Easier and more reliable for KSM to do its own thing here.

I do agree that slabinfo or slqbinfo or /proc/slabinfo is a good enough
interface for checking up on the number of rmap_items in use; it's what
I was using most of the time.  I did once fleetingly wonder whether to
show the count of rmap_items under /sys/kernel/mm/ksm, but rejected it
as not interesting enough to deserve more than what slabinfo tells.

But here the rmap_item count is being used to deduce something more
interesting (though more obscure), and I don't want SL?B divergences
to perturb the resulting number more than it is already.  I did start
out without the rmap_items count, incrementing and decrementing
pages_volatile all over the place; but soon abandoned that in
favour of the difference calculation.

But I think I'm taking you more seriously than you intended,
sorry for my humourlessness!

Hugh
