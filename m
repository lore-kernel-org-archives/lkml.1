Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYLBCXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYLBCXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 21:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYLBCXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 21:23:00 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:48276 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYLBCXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 21:23:00 -0500
Date: Mon, 1 Dec 2008 20:21:45 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Russ Anderson <rja@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Jones <davej@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/8] badpage: simplify page_alloc flag check+clear
In-Reply-To: <Pine.LNX.4.64.0812012349330.18893@blonde.anvils>
Message-ID: <Pine.LNX.4.64.0812012014150.30344@quilx.com>
References: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
 <Pine.LNX.4.64.0812010038220.11401@blonde.site> <Pine.LNX.4.64.0812010843230.15331@quilx.com>
 <Pine.LNX.4.64.0812012349330.18893@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008, Hugh Dickins wrote:

> > Rename this to PAGE_FLAGS_CLEAR_WHEN_FREE?
>
> No, that's a list of just the ones it's checking at free;
> it then (with this patch) goes on to clear all of them.

But they are always clear on free. The checking is irrelevant.

> One of the problems with PREP is that it's not obvious that it
> means ALLOC: yes, I'd be happier with PAGE_FLAGS_CLEAR_AT_FREE.

Ok.

>
> > This is equal to
> >
> > page->flags &=~PAGE_FLAGS_CHECK_AT_PREP;
> >
> > You can drop the if...
>
> I was intentionally following the existing style of
> 	if (PageDirty(page))
> 		__ClearPageDirty(page);
> 	if (PageSwapBacked(page))
> 		__ClearPageSwapBacked(page);
> which is going out of its way to avoid dirtying a cacheline.
>
> In all the obvious cases, I think the cacheline will already
> be dirty; but I guess there's an important case (high order
> but not compound?) which has a lot of clean cachelines.

Free or alloc dirties the cacheline of the page struct regardless since
the LRU field is always modified.

Well, ok. The not compound high order case may be an exception.

But then lets at least make a single check

If (page->flags & (all the flags including dirty and SwapBacked))
	zap-em.


