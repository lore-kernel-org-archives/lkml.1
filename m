Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYJEXSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYJEXSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 19:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbYJEXSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 19:18:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbYJEXSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 19:18:37 -0400
Date: Sun, 5 Oct 2008 19:18:22 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Fix fsync livelock
In-Reply-To: <20081005160724.54dd1a27@infradead.org>
Message-ID: <Pine.LNX.4.64.0810051910580.663@hs20-bc2-1.build.redhat.com>
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
 <20081005160724.54dd1a27@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008, Arjan van de Ven wrote:

> On Sun, 5 Oct 2008 19:02:57 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > > are you sure?
> > > isn't the right fix to just walk the file pages only once?
> > 
> > It walks the pages only once --- and waits on each on them. But
> > because new pages are contantly appearing under it, that "walk only
> > once" becomes infinite loop (well, finite, until the whole disk is
> > written).
> 
> well. fsync() promises that everything that's dirty at the time of the
> call will hit the disk. That is not something you can compromise.
> The only way out would be is to not allow new dirty during an fsync()...
> which is imo even worse.
> 
> Submit them all in one go, then wait, should not be TOO bad. Unless a
> lot was dirty already, but then you go back to "but it has to go to
> disk".

The problem here is that you have two processes --- one is writing, the 
other is simultaneously syncing. The syncing process can't distinguish the 
pages that were created before fsync() was invoked (it has to wait on 
them) and the pages that were created while fsync() was running (it 
doesn't have to wait on them) --- so it waits on them all. The result is 
livelock, it waits indefinitely, because more and more pages are being 
created.

The patch changes it so that if it waits long enough, it stops the other 
writers creating dirty pages.

Or, how otherwise would you implement "Submit them all in one go, then 
wait"? The current code is:
you grab page 0, see it is under writeback, wait on it
you grab page 1, see it is under writeback, wait on it
you grab page 2, see it is under writeback, wait on it
you grab page 3, see it is under writeback, wait on it
...
--- and the other process is just making more and more writeback pages 
while your waiting routine run. So the waiting is indefinite.

Mikulas
