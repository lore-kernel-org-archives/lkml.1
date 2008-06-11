Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbYFKGGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbYFKGGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 02:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYFKGGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 02:06:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbYFKGGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:06:34 -0400
Date: Tue, 10 Jun 2008 23:06:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [patch 7/7] powerpc: lockless get_user_pages_fast
Message-Id: <20080610230622.abed7b55.akpm@linux-foundation.org>
In-Reply-To: <20080611044902.GB11545@wotan.suse.de>
References: <20080605094300.295184000@nick.local0.net>
	<20080605094826.128415000@nick.local0.net>
	<Pine.LNX.4.64.0806101159110.17798@schroedinger.engr.sgi.com>
	<20080611031822.GA8228@wotan.suse.de>
	<Pine.LNX.4.64.0806102138380.19967@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0806102141010.19967@schroedinger.engr.sgi.com>
	<20080611044902.GB11545@wotan.suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 06:49:02 +0200 Nick Piggin <npiggin@suse.de> wrote:

> On Tue, Jun 10, 2008 at 09:41:33PM -0700, Christoph Lameter wrote:
> > And yes slab defrag is part of linux-next. So it would break.

No, slab defreg[*] isn't in linux-next.

y:/usr/src/25> diffstat patches/linux-next.patch| grep mm/slub.c
 mm/slub.c                                                    |    4 

That's two spelling fixes in comments.

I have git-pekka in -mm too.  Here it is:

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2765,6 +2765,7 @@ void kfree(const void *x)
 
 	page = virt_to_head_page(x);
 	if (unlikely(!PageSlab(page))) {
+		BUG_ON(!PageCompound(page));
 		put_page(page);
 		return;
 	}


> Can memory management patches go though mm/? I dislike the cowboy
> method of merging things that some other subsystems have adopted :)

I think I'd prefer that.  I may be a bit slow, but we're shoving at
least 100 MM patches through each kernel release and I think I review
things more closely than others choose to.  At least, I find problems
and I've seen some pretty wild acked-bys...


[*] It _isn't_ "slab defrag".  Or at least, it wasn't last time I saw
it.  It's "slub defrag".  And IMO it is bad to be adding slub-only
features because afaik slub still isn't as fast as slab on some things
and so some people might want to run slab rather than slub.  And
because if this the decision whether to retain slab or slub STILL
hasn't been made.  Carrying both versions was supposed to be a
short-term transitional thing :(
