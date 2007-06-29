Return-Path: <linux-kernel-owner+w=401wt.eu-S933676AbXF2OP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbXF2OP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933500AbXF2OPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:15:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40602 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933622AbXF2OPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:15:43 -0400
Date: Fri, 29 Jun 2007 07:15:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>,
       Russell King <rmk+lkml@arm.linux.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
In-Reply-To: <Pine.LNX.4.64.0706291339160.10769@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706290706320.14268@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706282047160.10035@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706291339160.10769@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007, Hugh Dickins wrote:

> I stand by my page_mapping patch, and the remark I made before,
> that page_mapping(page) is the correct place to check this.  What is
> page_mapping(page) for?  Precisely to return the struct address_space*
> from page->mapping when that's what's in there, and not when that field
> has been reused for something else.
> 
> So lines like
> > +	mapping = PageSlab(page) ? NULL : page_mapping(page);
> seem to miss the point.

They certainly point out to the reader that one can expect a slab page 
here where one may not expect one since flush_dcache_page is a page
cache function.

> I agree that the only clash found yet has been in flush_dcache_page,
> so some bytes and branches can indeed be saved by just doing the
> test in there.  Oh, but your VM_BUG_ON cancels out that saving.
> And if we were to try to save bytes and branches there, it's the
> synthetic swapper_space business (only required in a couple of
> places) I'd be wanting to cut out.

VM_BUG_ON is different from BUG_ON. BUG_ON is always checked. VM_BUG_ON 
depends on a debug config option.

> To me this all seems like a big fuss to excuse your surprise:

I am weirded out by the use of terms like "accusations" and "excuses" in 
these discussions. But if it makes you feel better....

Others seemed to have encountered the same surprises before me. So it is 
better to point out these issues in the sources. There is the danger of 
other pagecache functions getting called for slab pages in the I/O 
layer and the check in page_mapping provides some protection from such 
changes. The checks/comments in the functions where we allow slab page use 
help the ones enhancing the code to keep these issues in mind and help 
them to not be surprised in turn.
