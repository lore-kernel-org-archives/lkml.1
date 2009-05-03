Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbZECJKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbZECJKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZECJKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:10:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61897 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbZECJJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:09:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MnaS2wO5kiq2NqYRO8Hdr2p2Ic6sObQ56HRATTtJ0uv7G4YeFhhWtvw2ChInvCRRB
	W5oXuh2jRIFRWCYFkH/wA==
Date: Sun, 3 May 2009 02:09:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Jack Steiner <steiner@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in
 uv_system_init
In-Reply-To: <20090503084847.GA20394@elte.hu>
Message-ID: <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com>
References: <20090501195638.GC4633@lenovo> <20090501200331.GA2645@elte.hu> <20090501200937.GD4633@lenovo> <20090501202511.GE4633@lenovo> <20090501203123.GA10878@sgi.com> <20090503084847.GA20394@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009, Ingo Molnar wrote:

> Hm, would be nice if we had a __GFP_PANIC variant in kmalloc that 
> would just panic straight in the allocator, when allocation failure 
> is not acceptable. (Andrew Cc:-ed)
> 
> It does not increase the priority of the allocation nor does it 
> trigger any 'dont fail' logic - it is simply the central expression 
> of 'this should not have failed, panic'.
> 

SLUB stores two new slab allocation orders: the cache's adjustable order 
which is calculated at kmem_cache_create(), and the smallest order that 
can accommodate at least one object allocation.  The latter is used as a 
fallback when the former fails in the page allocator.

So for __GFP_PANIC to work in this case, it could not be implemented in 
the page allocator (SLUB also passes __GFP_NORETRY for new slabs) but 
rather above it in allocate_slab().  It would then be a no-op for 
alloc_pages().
