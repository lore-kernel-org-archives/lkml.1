Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZECJx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZECJx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZECJxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:53:44 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24511 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZECJxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:53:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qvypOFIG3pK8rK8/xc4MfyDL/Yw0AGYOyP/OBMHPO5p0R7J0s4B0AIK7hk3wkkaZw
	zJEp0ucl6lHcDG482GKeA==
Date: Sun, 3 May 2009 02:53:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in
 uv_system_init
In-Reply-To: <20090503093814.GB4615@lenovo>
Message-ID: <alpine.DEB.2.00.0905030242220.18793@chino.kir.corp.google.com>
References: <20090501195638.GC4633@lenovo> <20090501200331.GA2645@elte.hu> <20090501200937.GD4633@lenovo> <20090501202511.GE4633@lenovo> <20090501203123.GA10878@sgi.com> <20090503084847.GA20394@elte.hu> <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com>
 <20090503093814.GB4615@lenovo>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009, Cyrill Gorcunov wrote:

> What if instead of tear thru all these cases we implement
> a special wrapper (say kmalloc_panic)? Almost the same
> are done for bootmem allocator (__alloc_bootmem_nopanic).
> 

This is certainly what would be required to avoid a largely unnecessary 
conditional in a very hot path.  __GFP_PANIC couldn't be implemented any 
lower than the kmalloc() functions if it is to be consistency because this 
is the only point where we decide whether to go through the slab allocator 
or do pass-through to the page allocator (SLUB_MAX_SIZE in slub).  With 
the work currently being done to make the page allocator faster, 
SLUB_MAX_SIZE is bound to be reduced at some point.

> It seems __GFP_PANIC would not be that popular anyway
> and what is more important -- we would add additional
> check the flag somewhere inside mm code (which will
> be not needed most the time).
> 

The advantage of implementing your kmalloc_panic() idea is that it 
provides a centralized place where diagostic information could be emitted 
that shows, for instance, the allocation order and gfp flags for code 
paths where it isn't immediately obvious.  Even with that information, 
however, it doesn't provide any additional insight that could help to fix 
the problem other than insufficient memory of that type and order.

I don't think it's worth implementing the necessary variations just to 
panic on NULL such as kmalloc_node, etc.
