Return-Path: <linux-kernel-owner+w=401wt.eu-S1030626AbXCSVm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030626AbXCSVm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030619AbXCSVlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:41:51 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57900 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965059AbXCSVlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:41:17 -0400
Date: Mon, 19 Mar 2007 14:41:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: mpm@selenic.com, "Christoph Lameter" <clameter@sgi.com>,
       "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-Id: <20070319144100.8a87f288.akpm@linux-foundation.org>
In-Reply-To: <az5Ytbv5.1174339536.7416370.penberg@cs.helsinki.fi>
References: <20070319141038.212d4ac9.akpm@linux-foundation.org>
	<az5Ytbv5.1174339536.7416370.penberg@cs.helsinki.fi>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 23:25:36 +0200 (EET)
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> 
> On 3/19/2007, "Andrew Morton" <akpm@linux-foundation.org> wrote:
> > Would prefer to do:
> > 
> > static inline void kmem_cache_free_if_not_null(struct kmem_cache *cachep,
> > 						void *objp)
> > {
> > 	if (objp)
> > 		kmem_cache_free(cachep, objp);
> > }
> > 
> > so that we don't add extra overhead to all the thousands of existing,
> > well-behaved callsites.
> 
> That bloats kernel text all the same

But only for those callsites which choose to use it!  We avoid adding a
test-and-branch to those thousands of callsite which don't need it.

This is a super-hot path.

> so it's much cleaner to just make
> the callers explicitly check for NULL then. That said, I'm sorry but I
> just don't buy the "overhead" part of your argument since it's one
> branch and no extra data cache pressure especially as we're already
> doing the BUG_ON and page flag checking.

The BUG_ON (at least) should probably be moved into CONFIG_DEBUG_SLAB.

> But, since you're NAKing my patch, we need to get the mempool for from
> the original thread in to fix the oops.

We need to fix scsi rather than working around it in slab or in mempool -
it appears that it's getting its sg lists tangled up, and the problem has
been known since November (at least).
