Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbXF2E2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbXF2E2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 00:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbXF2E2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 00:28:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38221
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbXF2E2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 00:28:05 -0400
Date: Thu, 28 Jun 2007 21:28:25 -0700 (PDT)
Message-Id: <20070628.212825.78710369.davem@davemloft.net>
To: clameter@sgi.com
Cc: hugh@veritas.com, James.Bottomley@steeleye.com, rmk+lkml@arm.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter
 gather lists
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0706282119330.11676@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706282047160.10035@schroedinger.engr.sgi.com>
	<20070628.211013.74747656.davem@davemloft.net>
	<Pine.LNX.4.64.0706282119330.11676@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 28 Jun 2007 21:22:22 -0700 (PDT)

> On Thu, 28 Jun 2007, David Miller wrote:
> 
> > > Still a better solution would be to not use the slab allocator at all for 
> > > the objects that are used to send commands to the devices. These are not 
> > > permanent and grabbing a page from the pcp lists and putting it back is 
> > > likely as fast as performing a kmalloc.
> > 
> > Jens Axboe wants to get references to the page structs behind
> > kmalloc() allocated pages in his networking splice work.
> 
> You can get such a reference and then the slab page will be in limbo if 
> all objects are freed until that reference is given up. The reference 
> method is also use by kmem_cache_vacate() (but that is slab internal).

What about if someone kfree()'s that object meanwhile?

Can we bump the SLAB object count just like we can a page?
That's basically what's happening in the stuff Jens is
working on, he needs to grab a reference to a SLAB
object just like one can a page.  Even if there is an
intervening kfree (like a put_page()) the SLAB object is
still live until all the references are put, and thus it
can't get reallocated and given to another client by SLAB.
