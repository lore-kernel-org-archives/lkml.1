Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZFYUTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZFYUTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZFYUTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:19:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22868 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZFYUTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:19:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Vzn+/7fRgdY2QX3hUpWhNan3qgxdFce9Bd2jXSQluxO7JsQviatJpNOX9u7bSmWec
	JVf07E/kHIeqsuPOI6jnA==
Date: Thu, 25 Jun 2009 13:18:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090625194423.GB6472@mit.edu>
Message-ID: <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
 <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Theodore Tso wrote:

> On Thu, Jun 25, 2009 at 03:38:06PM -0400, Theodore Tso wrote:
> > Hmm, is there a reason to avoid using GFP_ATOMIC on the first
> > allocation, and only adding GFP_ATOMIC after the first failure?
> 
> Never mind, stupid question; I hit the send button before thinking
> about this enough.  Obviously we should try without GFP_ATOMIC so the
> allocator can try to release some memory.

The allocator can't actually release much memory itself, it must rely on 
pdflush to do writeback and the slab shrinkers are mostly all no-ops for 
~__GFP_FS.  The success of pdflush's freeing will depend on the caller's 
context.

> So maybe the answer for
> filesystem code where the alternative to allocator failure is
> remounting the root filesystem read-only or panic(), should be:
> 
> 1)  Try to do the allocation GFP_NOFS.
> 
> 2)  Then try GFP_ATOMIC
> 
> 3) Then retry the allocator with GFP_NOFS in a loop (possibly with a
> timeout than then panic's the system and allows the system to reboot,
> although arguably a watchdot timer should really perform that
> function).
> 

This is similar to how __getblk() will repeatedly loop until it gets 
sufficient memory to create buffers for the block page, which also relies 
heavily on pdflush.  If the GFP_ATOMIC allocation failed, then it's 
unlikely that the subsequent GFP_NOFS allocation will succeed any time 
soon without the oom killer, which we're not allowed to call, so it would 
probably be better to loop in step #2 with congestion_wait().

> Obviously if we can rework the filesystem code to avoid this as much
> as possible, this would be desirable, but if there are some cases left
> over where we really have no choice, that's probably what we should
> do.
> 

Isn't there also a problem in jbd2_journal_write_metadata_buffer(), 
though?

		char *tmp;

		jbd_unlock_bh_state(bh_in);
		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
		jbd_lock_bh_state(bh_in);
		if (jh_in->b_frozen_data) {
			jbd2_free(tmp, bh_in->b_size);
			goto repeat;
		}

		jh_in->b_frozen_data = tmp;
		mapped_data = kmap_atomic(new_page, KM_USER0);
		memcpy(tmp, mapped_data + new_offset, jh2bh(jh_in)->b_size);

jbd2_alloc() is just a wrapper to __get_free_pages() and if it fails, it 
appears as though the memcpy() would cause a NULL pointer.
