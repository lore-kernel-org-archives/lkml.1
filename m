Return-Path: <linux-kernel-owner+w=401wt.eu-S966084AbZLHUsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966084AbZLHUsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966075AbZLHUsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:48:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966011AbZLHUsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:48:38 -0500
Date: Tue, 8 Dec 2009 12:48:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <Pine.LNX.4.44L0.0912081412450.3046-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912081242550.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912081412450.3046-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Dec 2009, Alan Stern wrote:
> 
> >   You also need a smp_mb() in the wait_for_lock(), not a smp_rmb(). Can't 
> >   allow writes to migrate up either.  'atomic_read()' does not imply any
> >   barriers.
> 
> No, that's not needed.  Unlike reads, writes can't move in front of
> data or control dependencies.  Or so I've been lead to believe...

Sure they can. Control dependencies are trivial - it's called "branch 
prediction", and everybody does it, and data dependencies don't exist on 
many CPU architectures (even to the point of reading through a pointer 
that you loaded).

But yes, on x86, stores only move down. But that's an x86-specific thing.

[ Not that it's also not very common - write buffering is easy and matters 
  for performance, so any in-order implementation will generally do it. In 
  contrast, writes moving up doesn't really help peformance and is harder 
  to do, but can happen with a weakly ordered memory subsystem especially 
  if you have multi-way caches where some ways are busy and end up being 
  congested.

  So the _common_ case is definitely about delaying writes and doing reads 
  early if possible. But it's not necessarily at all guaranteed in 
  general. ]

> > That "wait_for_lock()" is equivalent to a 'read_lock()+read_unlock()'.
> 
> Not really.  It also corresponds to a 'write_lock()+write_unlock()' (in
> the suspend routine).  Are you claiming these two compound operations
> are equivalent?

They have separate semantics, and you just want to pick the one that suits 
you. Your counting lock doesn't have the "read_lock+read_unlock" version, 
it only has the write_lock/unlock one (ie it requires totally unlocked 
thing).

The point being, rwsem's can do everything your counting lock does. And 
they already exist. And they already know about all the subtleties of 
architecture-specific memory ordering etc.

				Linus
