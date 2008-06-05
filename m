Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbYFEQUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbYFEQUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYFEQUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:20:45 -0400
Received: from waste.org ([66.93.16.53]:39448 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbYFEQUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:20:44 -0400
Subject: Re: [PATCH 1/5] pagemap: Modify add_to_pagemap to use copy_to_user
	instead of put_user.
From: Matt Mackall <mpm@selenic.com>
To: Thomas Tuttle <ttuttle@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ca0a85e0806050901q52deba94r3056fdb0e7d46c8c@mail.gmail.com>
References: <4ca0a85e0806050804q4c164105uc386dcae2ccd21d@mail.gmail.com>
	 <1212681477.3953.154.camel@calx>
	 <4ca0a85e0806050901q52deba94r3056fdb0e7d46c8c@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 05 Jun 2008 11:20:10 -0500
Message-Id: <1212682810.3953.180.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 12:01 -0400, Thomas Tuttle wrote:
> On Thu, Jun 5, 2008 at 11:57 AM, Matt Mackall <mpm@selenic.com> wrote:
> >
> > On Thu, 2008-06-05 at 11:04 -0400, Thomas Tuttle wrote:
> >> While fiddling with pagemap, I discovered a bug in add_to_pagemap.
> >> When it is copying an entry that is not at the end of the buffer, it
> >> uses put_user to copy a u64 into a char* buffer.  The problem is that
> >> put_user determines how much to copy based on the size of the
> >> *destination*, not the source, so it only copied one byte.  To fix
> >> this, I replaced the call to put_user with a call to copy_to_user, as
> >> is used when copying the last (possibly partial) PFN into the buffer.0
> >
> > This looks fine to me, so:
> >
> > Acked-by: Matt Mackall <mpm@selenic.com>
> >
> > But your 3/5 undoes this, right? So we should just take one or the other
> > route. While I like going the simplifying route, it's not very pretty
> > from the user interface point of view. But it does have plenty of
> > precedent in direct-I/O-like things.
> 
> No, my 3/5 further keeps the use of copy_to_user instead of put_user,
> but eliminates entirely the code for partial reads.  3/5 depends on
> 1/5.

Hmm, I read this backwards the first time through then. Rather than
finding a small bug at the end of the buffer, you've found a REALLY BIG
WEAR-A-BROWN-PAPER-BAG-ON-MY-HEAD BUG.

Sigh. ﻿Some clever person (me?) probably removed a cast or changed a
pointer type somewhere along the way and didn't notice the fallout
because the MSBs still came through.

I'm pretty sure we want to do the put_user because it's faster. On a
64-bit system, it boils down to a simple assignment. If we commit
ourselves to the alignment thing, then we should probably just change
all the relevant pointers to u64, and then it will just do the right
thing.

ps: perhaps put_user can be made to compare the src and dst sizes at
compile time?

-- 
Mathematics is the supreme nostalgia of our time.

