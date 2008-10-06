Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYJFUpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYJFUpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYJFUpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:45:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbYJFUpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:45:44 -0400
Date: Mon, 6 Oct 2008 16:44:57 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Fix fsync livelock
In-Reply-To: <20081006065024.380d1d00@infradead.org>
Message-ID: <Pine.LNX.4.64.0810061632040.19239@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
 <20080923164623.ce82c1c2.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
 <20081001225404.4e973465.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0810051814060.23248@hs20-bc2-1.build.redhat.com>
 <20081005153306.7e644c9f@infradead.org> <Pine.LNX.4.64.0810051901190.31780@hs20-bc2-1.build.redhat.com>
 <20081005160724.54dd1a27@infradead.org> <Pine.LNX.4.64.0810051910580.663@hs20-bc2-1.build.redhat.com>
 <20081005162847.7bf0ead1@infradead.org> <Pine.LNX.4.64.0810051949290.5798@hs20-bc2-1.build.redhat.com>
 <20081005173019.0a358b09@infradead.org> <Pine.LNX.4.64.0810052320480.3074@hs20-bc2-1.build.redhat.com>
 <20081005212031.63ad246a@infradead.org> <Pine.LNX.4.64.0810060857341.26843@hs20-bc2-1.build.redhat.com>
 <20081006065024.380d1d00@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008, Arjan van de Ven wrote:

> On Mon, 6 Oct 2008 09:00:14 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > On Sun, 5 Oct 2008, Arjan van de Ven wrote:
> > 
> > > On Sun, 5 Oct 2008 23:30:51 -0400 (EDT
> > > > The point is that many fsync()s may run in parallel and you have
> > > > just one inode and just one chain. And if you add two-word
> > > > list_head to a page, to link it on this list, many developers
> > > > will hate it for increasing its size.
> > > 
> > > why to a page?
> > > a list head in the inode and chain up the bios....
> > 
> > And if you want to wait for a bio submitted by a different process? 
> > There's no way you can find the bio from the page.
> 
> the point is that the kernel would always chain it to the inode,
> independent of who or when it is submitted

If you add a list to an inode, you need to protect it with a spinlock. So 
you take one more spinlock for any write bio submitted --- a lot of 
developers would hate it.

Another problem: how do you want to walk all dirty pages and submit bio 
for them?

The act of allocating and submission of bio can block (if you run out of 
some mempool) and in this case it wait until some other bio is finished. 
During this time, more dirty pages can be created.

Also, if you find a page that is both dirty and under writeback, you need 
to wait until a writeback finishes and then initiate another writeback 
(because the old writeback may be writing stale data). You again, block, 
and more dirty pages can appear.

And if you block and more dirty pages appear, you are prone to the 
livelock.

[ In Nick Piggin's patch, it is needed to lock the whole address space, 
mark dirty pages in one non-blocking pass and write marked pages again in 
a blocking pass --- so that if more dirty pages appear while bios are 
submitted, the new pages will be skipped ]

Mikulas
