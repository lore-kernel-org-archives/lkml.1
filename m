Return-Path: <linux-kernel-owner+w=401wt.eu-S934204AbXGZSQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204AbXGZSQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932611AbXGZSQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:16:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60847 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932567AbXGZSQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:16:35 -0400
Date: Thu, 26 Jul 2007 11:16:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       David Gibson <david@gibson.dropbear.id.au>,
       Ken Chen <kenchen@google.com>, Bill Irwin <wli@holomorphy.com>
Subject: Re: [PATCH] Check for compound pages in set_page_dirty()
In-Reply-To: <Pine.LNX.4.64.0707261855290.13876@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0707261110500.2970@schroedinger.engr.sgi.com>
References: <20070718141533.GA11657@kernel.dk>
 <Pine.LNX.4.64.0707181619200.23261@blonde.wat.veritas.com>
 <20070718182456.GE11657@kernel.dk> <20070718184006.GF11657@kernel.dk>
 <Pine.LNX.4.64.0707182052220.18926@blonde.wat.veritas.com>
 <20070719062934.GT11657@kernel.dk> <Pine.LNX.4.64.0707191720300.10512@blonde.wat.veritas.com>
 <20070723135416.44edc896@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0707261834200.592@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0707261042390.2335@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0707261855290.13876@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Hugh Dickins wrote:

> > We would need to redirect all of the page state determinations and changes 
> > to the head page anyways. So the memory.c code would have to deal with two 
> > struct page pointers: One to the head where the state is kept and one to 
> > the tail page that contains the actual chunk of data we are interested in. 
> > The tail page pointer is only used for address determinations.
> > 
> > VM functions that manipulate the state of a page (like set_page_dirty) 
> > could rely on only getting page heads.
> 
> Maybe.  Sounds ugly.  "would": so your patches remain just an RFC?

The large blocksize patch currently does not support mmap. I just have 
some patches here that implement some of that using the approach that I 
described.

And without mmap support we never have to use references to tail pages 
anyways. 

We could avoid references to tail pages if we would not allow the mapping 
of 4k subsections of larger pages but instead require that a compound page 
always be mapped in its entirety. That would keep the necessary changes to 
memory.c minimal but would cause trouble for applications that expect to 
be able to map 4k chunks.

If we want to support transparent use of 2M pages then we need to do this 
anyways but at that point we can still have a single large "pte" (well 
really a pmd that we treat as a pte).

If we f.e. require an order 3 page to be mapped in one go then we would 
have to install 8 ptes at once. If we allow mapping of 4k sections that we 
can have mm/memory.c deal with one pte at a time.




