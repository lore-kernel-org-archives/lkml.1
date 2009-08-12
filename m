Return-Path: <linux-kernel-owner+w=401wt.eu-S1751216AbZHLEIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbZHLEIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 00:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbZHLEIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 00:08:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZHLEIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 00:08:04 -0400
Date: Wed, 12 Aug 2009 06:07:56 +0200
From: Nick Piggin <npiggin@suse.de>
To: Zach Brown <zach.brown@oracle.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] ipc: sem optimise simple operations
Message-ID: <20090812040756.GA5330@wotan.suse.de>
References: <20090811110902.255877673@suse.de> <20090811111607.310739140@suse.de> <4A81B646.5060301@colorfullife.com> <4A81B728.7040200@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A81B728.7040200@oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 11:23:36AM -0700, Zach Brown wrote:
> Manfred Spraul wrote:
> > On 08/11/2009 01:09 PM, npiggin@suse.de wrote:
> >> Index: linux-2.6/include/linux/sem.h
> >> ===================================================================
> >> --- linux-2.6.orig/include/linux/sem.h
> >> +++ linux-2.6/include/linux/sem.h
> >> @@ -86,6 +86,8 @@ struct task_struct;
> >>   struct sem {
> >>       int    semval;        /* current value */
> >>       int    sempid;        /* pid of last operation */
> >> +    struct list_head    negv_pending;
> >> +    struct list_head    zero_pending;
> >>   };
> >>    
> > struct sem is increased from 8 to 24 bytes.
> 
> And larger still with 64bit pointers.

Yes it is a significant growth. To answer Manfed's question, I don't
know if there are applications using large numbers of semaphores per
set. Google search for increase SEMMSL results in mostly Oracle,
which says to use 250 (which is our current default).

A semaphore set with 250 will use 2K before, and 10K afterward. I
don't know that it is a huge amount really, given that they also
have to presumably be *protecting* stuff.

We can convert them to hlists (I was going to send a patch to do
everything in hlists, but hlists are missing some _rcu variants...
maybe I should just convert the pending lists to start with).

 
> If it's a problem, this can be scaled back.  You can have pointers to
> lists and you can have fewer lists.
> 
> Hopefully it won't be a problem, though.  We can close our eyes and
> pretend that the size of the semaphore sets scale with the size of the
> system and that it's such a relatively small consumer of memory that no
> one will notice :).

The other thing is that using semaphores as sets really won't scale
well at all. It will scale better now that there are per-sem lists,
but there is still a per-set lock. They really should be discouraged.

It's not trivial to remove shared cachelines completely. Possible I
think, but I think it would further increase complexity without a
proven need at this point.

