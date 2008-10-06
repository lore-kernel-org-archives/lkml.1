Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbYJFACQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbYJFACQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 20:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYJFACA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 20:02:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYJFACA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 20:02:00 -0400
Date: Sun, 5 Oct 2008 20:01:46 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Fix fsync livelock
In-Reply-To: <20081005162847.7bf0ead1@infradead.org>
Message-ID: <Pine.LNX.4.64.0810051949290.5798@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
 <20080923164623.ce82c1c2.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
 <20081001225404.4e973465.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0810051814060.23248@hs20-bc2-1.build.redhat.com>
 <20081005153306.7e644c9f@infradead.org> <Pine.LNX.4.64.0810051901190.31780@hs20-bc2-1.build.redhat.com>
 <20081005160724.54dd1a27@infradead.org> <Pine.LNX.4.64.0810051910580.663@hs20-bc2-1.build.redhat.com>
 <20081005162847.7bf0ead1@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Oct 2008, Arjan van de Ven wrote:

> On Sun, 5 Oct 2008 19:18:22 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > On Sun, 5 Oct 2008, Arjan van de Ven wrote:
> > 
> > 
> > The problem here is that you have two processes --- one is writing,
> > the other is simultaneously syncing. The syncing process can't
> > distinguish the pages that were created before fsync() was invoked
> > (it has to wait on them) and the pages that were created while
> > fsync() was running (it doesn't have to wait on them) --- so it waits
> > on them all.
> 
> for pages it already passed that's not true.
> but yes while you walk, you may find new ones. tough luck.
> > 
> > Or, how otherwise would you implement "Submit them all in one go,
> > then wait"? The current code is:
> > you grab page 0, see it is under writeback, wait on it
> > you grab page 1, see it is under writeback, wait on it
> > you grab page 2, see it is under writeback, wait on it
> > you grab page 3, see it is under writeback, wait on it
> 
> it shouldn't be doing this. It should be "submit the lot"
> "wait on the lot that got submitted".

And how do you want to implement that "wait on the lot that got 
submitted". Note that you can't allocate an array or linked list that 
holds pointers to all submitted pages. And if you add anything to the page 
structure or radix tree, you have to serialize concurrent sync,fsync 
calls, otherwise they'd fight over these bits.

> keeping away new writers is just shifting the latency to an innocent
> party (since the fsync() is just bloody expensive, the person doing it
> should be paying the price, not the rest of the system), and a grave
> mistake.

I assume that if very few people complained about the livelock till now, 
very few people will see degraded write performance. My patch blocks the 
writes only if the livelock happens, so if the livelock doesn't happen in 
unpatched kernel for most people, the patch won't make it worse.

> If the fsync() implementation isn't smart enough, sure, lets improve
> it. But not by shifting latency around... lets make it more efficient
> at submitting IO.
> If we need to invent something like "chained IO" where if you wait on
> the last of the chain, you wait on the entirely chain, so be it.

This looks madly complicated. And ineffective, because if some page was 
submitted before fsync() was invoked, and is under writeback while fsync() 
is called, fsync() still has to wait on it.

Mikulas
