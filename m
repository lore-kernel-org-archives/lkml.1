Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXF2EjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXF2EjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 00:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXF2EjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 00:39:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41129 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914AbXF2EjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 00:39:04 -0400
Date: Thu, 28 Jun 2007 21:39:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: hugh@veritas.com, James.Bottomley@steeleye.com, rmk+lkml@arm.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
In-Reply-To: <20070628.212825.78710369.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706282047160.10035@schroedinger.engr.sgi.com>
 <20070628.211013.74747656.davem@davemloft.net>
 <Pine.LNX.4.64.0706282119330.11676@schroedinger.engr.sgi.com>
 <20070628.212825.78710369.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, David Miller wrote:

> > You can get such a reference and then the slab page will be in limbo if 
> > all objects are freed until that reference is given up. The reference 
> > method is also use by kmem_cache_vacate() (but that is slab internal).
> 
> What about if someone kfree()'s that object meanwhile?

If that is the last object in the slab then the page is deslabified and 
it will stick around as a regular page until its refcount reaches zero.

There is slab functionality in SLUB that uses this trick to insure that 
the slab does not go away.

> Can we bump the SLAB object count just like we can a page?

You can bump the slab page count. But you have to use virt_to_head_page() 
instead of virt_to_page() since slab pages may be compound pages (in both 
SLAB and SLUB). Incrementing the refcount of a tail page will cause an oops on
free.

> That's basically what's happening in the stuff Jens is
> working on, he needs to grab a reference to a SLAB
> object just like one can a page.  Even if there is an
> intervening kfree (like a put_page()) the SLAB object is
> still live until all the references are put, and thus it
> can't get reallocated and given to another client by SLAB.

If you kfree the object then all slab allocators will feel free to 
immediately alloc the object for other purposes.

If you want to prohibit further allocations from a slab then I can likely 
give you a function call that removes a slab from the partial lists so 
that the slab will not be allocated from. But this will only work with 
SLUB.

At some point the slab will then need to be returned to the partial slab 
lists.

Hmmmm... Maybe we are creating more of a mess with this. Isnt there some 
other way to handle these object.



