Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYJTUu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYJTUu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYJTUut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:50:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44096 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbYJTUus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:50:48 -0400
To: cl@linux-foundation.org
CC: miklos@szeredi.hu, penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <48FCE1C4.20807@linux-foundation.org> (message from Christoph
	Lameter on Mon, 20 Oct 2008 14:53:40 -0500)
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop> <1223883164.31587.16.camel@penberg-laptop> <Pine.LNX.4.64.0810131227120.20511@blonde.site> <200810132354.30789.nickpiggin@yahoo.com.au> <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu> <E1KpOOL-0003Vf-9y@pomaz-ex.szeredi.hu> <48F378C6.7030206@linux-foundation.org> <E1KpOjX-0003dt-AY@pomaz-ex.szeredi.hu> <48FC9CCC.3040006@linux-foundation.org> <E1Krz4o-0002Fi-Pu@pomaz-ex.szeredi.hu> <48FCCC72.5020202@linux-foundation.org> <E1KrzgK-0002QS-Os@pomaz-ex.szeredi.hu> <48FCD7CB.4060505@linux-foundation.org> <E1Ks0QX-0002aC-SQ@pomaz-ex.szeredi.hu> <48FCE1C4.20807@linux-foundation.org>
Message-Id: <E1Ks1hu-0002nN-9f@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 20 Oct 2008 22:50:30 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, Christoph Lameter wrote:
> Miklos Szeredi wrote:
> > So, isn't it possible to do without get_dentries()?  What's the
> > fundamental difference between this and regular cache shrinking?
> 
> The fundamental difference is that slab defrag operates on sparsely
> populated dentries. It comes into effect when the density of
> dentries per page is low and lots of memory is wasted. It
> defragments by kicking out dentries in low density pages. These can
> then be reclaimed.

OK, but why can't this be done in just one stage?

AFAICS the problem is exactly the same as generic shrinking, except it
wants to evict dentries selectively: only ones which are in very
sparse slabs.

So is the problem selecting these dentries?  Would it be too expensive
to do it the same as normal cache shrinking and walk the lru, but only
evict the ones which are tagged as being in a sparse page?

> The dentries that we get a ref on are candidates for removal. Their
> lifetime is limited. Unmounting while we are trying to remove
> dentries/inodes results in two mechanisms removing dentries/inodes.
> 
> If we have obtained a reference then invalidate_list() will return
> the number of busy inodes which would trigger the printk in
> generic_shutdown_super(). But these are inodes currently being
> reclaimed by slab defrag. Just waiting a bit would remedy the
> situation.

I guess so, but that's just a hack to work around the problem, and
creates more interdependencies between VFS and the allocator with
unforseeable consequences.

Miklos
