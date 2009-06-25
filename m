Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZFYN0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZFYN0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZFYN03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:26:29 -0400
Received: from THUNK.ORG ([69.25.196.29]:57597 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbZFYN02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:26:28 -0400
Date: Thu, 25 Jun 2009 09:25:44 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090625132544.GB9995@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	penberg@cs.helsinki.fi, arjan@infradead.org,
	linux-kernel@vger.kernel.org, cl@linux-foundation.org,
	npiggin@suse.de
References: <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624150714.c7264768.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 03:07:14PM -0700, Andrew Morton wrote:
> 
> fs/jbd/journal.c:       new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
> 
> But that isn't :(

Well, we could recode it to do what journal_alloc_head() does, which
is call the allocator in a loop:

	ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
	if (ret == NULL) {
		jbd_debug(1, "out of memory for journal_head\n");
		if (time_after(jiffies, last_warning + 5*HZ)) {
			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
			       __func__);
			last_warning = jiffies;
		}
		while (ret == NULL) {
			yield();
			ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
		}
	}

Like journal_write_metadata_buffer(), which you quoted, it's called
out of the commit code, where about the only choice we have other than
looping or using GFP_NOFAIL is to abort the filesystem and remount it
read-only or panic.  It's not at all clear to me that looping
repeatedly is helpful; for example, the allocator doesn't know that it
should try really hard, and perhaps fall back to an order 0 allocation
of an order 1 allocation won't work.

Hmm.... it may be possible to do the memory allocation in advance,
before we get to the commit, and make it be easier to fail and return
ENOMEM to userspace --- which I bet most applications won't handle
gracefully, either (a) not checking error codes and losing data, or
(b) dieing on the spot, so it would be effectively be an OOM kill.
And in some cases, we're calling journal_get_write_access() out of a
kernel daemon like pdflush, where the error recovery paths may get
rather interesting.

The question then is what is the right strategy?  Use GFP_NOFAIL, and
let the memory allocator loop; let the allocating kernel code loop;
remount filesystems read/only and/or panic; pass a "try _really_ hard"
flag to the allocator and fall back to a ro-remount/panic if the
allocator still wasn't successful?  None of the alternatives seem
particularly appealing to me....

							- Ted
