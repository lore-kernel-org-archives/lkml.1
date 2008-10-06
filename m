Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYJFDbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYJFDbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 23:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbYJFDbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 23:31:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYJFDbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 23:31:37 -0400
Date: Sun, 5 Oct 2008 23:30:51 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Fix fsync livelock
In-Reply-To: <20081005173019.0a358b09@infradead.org>
Message-ID: <Pine.LNX.4.64.0810052320480.3074@hs20-bc2-1.build.redhat.com>
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
 <20081005162847.7bf0ead1@infradead.org> <Pine.LNX.4.64.0810051949290.5798@hs20-bc2-1.build.redhat.com>
 <20081005173019.0a358b09@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Oct 2008, Arjan van de Ven wrote:

> On Sun, 5 Oct 2008 20:01:46 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > I assume that if very few people complained about the livelock till
> > now, very few people will see degraded write performance. My patch
> > blocks the writes only if the livelock happens, so if the livelock
> > doesn't happen in unpatched kernel for most people, the patch won't
> > make it worse.
> 
> I object to calling this a livelock. It's not. 

It unlocks itself when the whole disk is written, and it can be several 
hours (or days, if you have many-terabyte array). So formally it is not 
livelock, from the user experience it is --- he sees unkillable process in 
'D' state for many hours.

> And yes, fsync is slow and lots of people are seeing that.
> It's not helped by how ext3 is implemented (where fsync is effectively
> equivalent of a sync for many cases).
> But again, moving the latency to "innocent" parties is not acceptable.
> 
> > 
> > > If the fsync() implementation isn't smart enough, sure, lets improve
> > > it. But not by shifting latency around... lets make it more
> > > efficient at submitting IO.
> > > If we need to invent something like "chained IO" where if you wait
> > > on the last of the chain, you wait on the entirely chain, so be it.
> > 
> > This looks madly complicated. And ineffective, because if some page
> > was submitted before fsync() was invoked, and is under writeback
> > while fsync() is called, fsync() still has to wait on it.
> 
> so?
> just make a chain per inode always...

The point is that many fsync()s may run in parallel and you have just one 
inode and just one chain. And if you add two-word list_head to a page, to 
link it on this list, many developers will hate it for increasing its 
size.

See the work dobe by Nick Piggin somewhere in this thread. He uses just 
one bit in radix tree to mark pages to process. But he needs to serialize 
all syncs on a given file, they no longer run in parallel.

Mikulas
