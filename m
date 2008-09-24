Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYIXSvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYIXSvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYIXSvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:51:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbYIXSvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:51:07 -0400
Date: Wed, 24 Sep 2008 14:50:23 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org, agk@redhat.com,
       mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
In-Reply-To: <20080923164623.ce82c1c2.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0809241439580.17357@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
 <20080923164623.ce82c1c2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > yup, that's pretty much unfixable, really, unless new locks are added
> > > which block threads which are writing to unrelated sections of the
> > > file, and that could hurt some workloads quite a lot, I expect.
> > 
> > It is fixable with the patch I sent --- it doesn't take any locks unless 
> > the starvation happens. Then, you don't have to use .nr_to_write for 
> > fsync anymore.
> 
> I agree that the patch is low-impact and relatively straightforward. 
> The main problem is making the address_space larger - there can (and
> often are) millions and millions of these things in memory.  Making it
> larger is a big deal.  We should work hard to seek an alternative and
> afacit that isn't happening here.
> 
> We already have existing code and design which attempts to avoid
> livelock without adding stuff to the address_space.  Can it be modified
> so as to patch up this quite obscure and rarely-occuring problem?

I reworked my patch to use a bit in address_space->flags and hashes wait 
queues, so it doesn't take any extra memory. I'm sending it in three 
parts.
1 - make generic function wait_action_schedule
2 - fix the livelock, the logic is exactly the same as in my previous 
patch, wait_on_bit_lock is used instead of mutexes
3 - remove that nr_pages * 2 limit, because it causes misbehavior and 
possible data loss.

Mikulas
