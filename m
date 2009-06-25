Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbZFYSv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbZFYSv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZFYSvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:51:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10403 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZFYSvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:51:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=c+Ajde5Gd84Vyqs8zv9iRMhAK6n1N1b5ImwVc4ndS9+pZMQrnC3sF1s7QXC0zykKp
	kP0aAYEy0UEL4Q2QxR/3Q==
Date: Thu, 25 Jun 2009 11:51:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090625132544.GB9995@mit.edu>
Message-ID: <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
References: <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain>
 <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain>
 <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Theodore Tso wrote:

> On Wed, Jun 24, 2009 at 03:07:14PM -0700, Andrew Morton wrote:
> > 
> > fs/jbd/journal.c:       new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
> > 
> > But that isn't :(
> 
> Well, we could recode it to do what journal_alloc_head() does, which
> is call the allocator in a loop:
> 
> 	ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
> 	if (ret == NULL) {
> 		jbd_debug(1, "out of memory for journal_head\n");
> 		if (time_after(jiffies, last_warning + 5*HZ)) {
> 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
> 			       __func__);
> 			last_warning = jiffies;
> 		}
> 		while (ret == NULL) {
> 			yield();
> 			ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
> 		}
> 	}
> 
> Like journal_write_metadata_buffer(), which you quoted, it's called
> out of the commit code, where about the only choice we have other than
> looping or using GFP_NOFAIL is to abort the filesystem and remount it
> read-only or panic.  It's not at all clear to me that looping
> repeatedly is helpful; for example, the allocator doesn't know that it
> should try really hard, and perhaps fall back to an order 0 allocation
> of an order 1 allocation won't work.
> 

Since it's using kmem_cache_alloc(), the order fallback is the 
responsibility of the slab allocator when a new slab allocation fails and 
a single object could fit in an order 0 page, so it's not a concern for 
this particular allocation.

There's no way to indicate that the page allocator should "try really 
hard" because the VM implementation should already do that for every 
allocation before failure.  A subsequent attempt after the first failure 
could try GFP_ATOMIC, though, which allows allocation beyond the minimum 
watermark and is more likely to succeed than GFP_NOFS.  Such an 
allocation should be short-lived and not rely on additional memory to free 
to avoid depleting most of the memory reserves available to atomic 
allocations, direct reclaim, and oom killed tasks.

> Hmm.... it may be possible to do the memory allocation in advance,
> before we get to the commit, and make it be easier to fail and return
> ENOMEM to userspace --- which I bet most applications won't handle
> gracefully, either (a) not checking error codes and losing data, or
> (b) dieing on the spot, so it would be effectively be an OOM kill.

If this would still be a GFP_NOFS allocation, the oom killer will not be 
triggered (it only gets called when __GFP_FS is set to avoid killing tasks 
when reclaim was not possible).
