Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZECJi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZECJi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZECJiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:38:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:56479 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZECJiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SfWO+8ZsKLjg2ae0E8dW2fd++zkeM8/JTU15/XtbjEAE760IZJrAw7TsDXffkEmmeY
         sTfDSWzHHjWagPVcp+KZFP6oZdpuSiFCAg3BzjDPqyVB4X5HU6mZHfZ0c7gRIHgKmdJO
         lZiOa6hqMseUZ81XgtFm8T+fKh7oPpBSIlQpc=
Date: Sun, 3 May 2009 13:38:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in
	uv_system_init
Message-ID: <20090503093814.GB4615@lenovo>
References: <20090501195638.GC4633@lenovo> <20090501200331.GA2645@elte.hu> <20090501200937.GD4633@lenovo> <20090501202511.GE4633@lenovo> <20090501203123.GA10878@sgi.com> <20090503084847.GA20394@elte.hu> <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Rientjes - Sun, May 03, 2009 at 02:09:50AM -0700]
| On Sun, 3 May 2009, Ingo Molnar wrote:
| 
| > Hm, would be nice if we had a __GFP_PANIC variant in kmalloc that 
| > would just panic straight in the allocator, when allocation failure 
| > is not acceptable. (Andrew Cc:-ed)
| > 
| > It does not increase the priority of the allocation nor does it 
| > trigger any 'dont fail' logic - it is simply the central expression 
| > of 'this should not have failed, panic'.
| > 
| 
| SLUB stores two new slab allocation orders: the cache's adjustable order 
| which is calculated at kmem_cache_create(), and the smallest order that 
| can accommodate at least one object allocation.  The latter is used as a 
| fallback when the former fails in the page allocator.
| 
| So for __GFP_PANIC to work in this case, it could not be implemented in 
| the page allocator (SLUB also passes __GFP_NORETRY for new slabs) but 
| rather above it in allocate_slab().  It would then be a no-op for 
| alloc_pages().
| 

What if instead of tear thru all these cases we implement
a special wrapper (say kmalloc_panic)? Almost the same
are done for bootmem allocator (__alloc_bootmem_nopanic).

It seems __GFP_PANIC would not be that popular anyway
and what is more important -- we would add additional
check the flag somewhere inside mm code (which will
be not needed most the time).

	-- Cyrill
