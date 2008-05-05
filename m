Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbYEEMzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbYEEMzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYEEMyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:54:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:34448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYEEMyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:54:51 -0400
Date: Mon, 5 May 2008 14:54:50 +0200
From: Nick Piggin <npiggin@suse.de>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, mk <michael.kerrisk@gmail.com>
Subject: Re: MAP_POPULATE behavior change?
Message-ID: <20080505125450.GB10312@wotan.suse.de>
References: <4815BDF5.9070506@gmail.com> <20080505122316.GE5018@wotan.suse.de> <cfd18e0f0805050542w20bee7f5v8b6125c8b399e63b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0805050542w20bee7f5v8b6125c8b399e63b@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 02:42:44PM +0200, Michael Kerrisk wrote:
> Hi Nick,
> 
> On Mon, May 5, 2008 at 2:23 PM, Nick Piggin <npiggin@suse.de> wrote:
> > On Mon, Apr 28, 2008 at 02:07:17PM +0200, Michael Kerrisk wrote:
> 
> > > In 2.6.23, you had the commit below, which seems to have changed the
> > > kernel-userland API.
> > >
> > > Am I right to understand that with this patch MAP_POPULATE now also works with
> > > MAP_PRIVATE mappings?  (Formerly it only worked with MAP_SHARED mappings, but
> > > some very quick testing suggests that MAP_POPULATE now also has an affect for
> > > MAP_PRIVATE.)
> >
> > Yeah it should also set up anonymous mappings. Very observant :)
> 
> Umm -- did it not work for anonymous *shared* mappings before?  I
> understood that it did.

Oh... yeah it would have. anonymous shared mappings aren't really anonymous
from the POV of most of mm/ :P

 
> > > Also, can you summarize the status of MAP_NONBLOCK?  Is it now a no-op?
> >
> > Yes, it is.
> 
> Hmm -- going back and re-reading the code, there is:
> 
>         if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
>                 make_pages_present(addr, addr + len);
> 
> That means that MAP_NONBLOCK makes *MAP_POPULATE* a no-op.  Was that intended?

Ah, my logic wasn't up to scratch there. Yes of course MAP_NONBLOCK is not
a noop, but it makes MAP_POPULATE into a noop. So it still guarantees
that the call will not block and that the kernel will make some kind of
best effort to populate the mapping... for some values of "some kind of"
(ie. "nothing" ;)).

It's done this way of course so it is still safe to call MAP_NONBLOCK if you
don't want to block, and thus everything stays backwards and forward
compatible.

Thanks,
Nick
