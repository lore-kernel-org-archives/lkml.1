Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZBLAyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZBLAyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 19:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZBLAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 19:54:42 -0500
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:25358 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751160AbZBLAyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:54:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bOZr5vX5n334qKNSjKEKnAekDDxqCsNXFbFeL6dd7pQIIwDeuuQSGEk/gM7okZTYioC5tRN1rSQK9lLqy51W/bWeG+0koi/Fvo5Gi+2cR4JJiwPXC593B0WJWPAkwgDhljUv3z/HZHhjr57fEl0aReoEG/YobQ//985t3dgzaQE=  ;
X-YMail-OSG: dHRys_UVM1nsvSeXHdV5v5KpdilOYn97wEXN9kPZyEZmANHHUohFfkwC5y7rmXiFv6zEIpvoQcrb1rLVhHSDeKuA24UcOFC0K3XN3MAGKtvm4DSUDOHADHGKj7a.Eiy1KFh0eqMtQIVp8uPrYPNyNnEEfvw4y4sYHkWIDieq457W.fs3i9OxwJVwFMynT4VgHEpxZ78_aWF2NFm.nPnUbPS0ApVN7kFP1zk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Menage <menage@google.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the unallowed node when memory spread is set
Date: Thu, 12 Feb 2009 11:54:02 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: miaox@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, cl@linux-foundation.org
References: <4976D77C.3020107@cn.fujitsu.com> <200902091502.27056.nickpiggin@yahoo.com.au> <6599ad830902100337mbde885fr89e5942f1016a1c@mail.gmail.com>
In-Reply-To: <6599ad830902100337mbde885fr89e5942f1016a1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902121154.02868.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009 22:37:28 Paul Menage wrote:
> On Sun, Feb 8, 2009 at 8:02 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Is it a problem if mems_allowed can get sampled in an unsafe way?
>
> It could cause an OOM to be incorrectly triggered if the task didn't
> see all the mems that it was meant to have access to. (In the extreme
> case, it could see no mems at all).

You can't be overly worried about concurrency cases. We're talking about
two threads here, one chancing mems_allowed, and the other performing
an allocation.

It would be possible, depending on timing, for the allocating thread to
see either pre or post mems_allowed even if access was fully locked.

The only difference is that a partially changed mems_allowed could be
seen. But what does this really mean? Some combination of the new and
the old nodes. I don't think this is too much of a problem.


> > It will happen only quite rarely. This code seems to be far simpler
> > and more robust than the current fragile scheme, so it would be
> > nice to use it.
>
> Agreed, the existing task->mems_allowed / cpuset_update_memory_state()
> code is a bit unwieldy. It's pretty much all inherited from the
> original cpusets code.
>
> A nicer way to do it might be:
>
> - get rid of task->mems_allowed entirely
>
> - have cpuset->mems_allowed be a pointer to an immutable RCU-protected
> nodemask (so updating the nodemask for a cpuset would always replace
> it with a fresh one and RCU-free the old one)
>
> - make cpuset_zone_allowed_*() use rcu_read_lock() and just check
> *(task_cs(current)->mems_allowed) rather than current->mems_allowed
>
> - ensure that get_page_from_freelist() is also RCU-safe (right now I
> think it's not since cpuset_zone_allowed_softwall() can sleep, but I
> think cgroups/cpusets is sufficiently RCU-safe now that we could quite
> likely remove the mutex lock from cpuset_zone_allowed_*()
>
> - add an rcu_read_lock() in hugetlb.c:cpuset_mems_nr()

This could work if we *really* need an atomic snapshot of mems_allowed.
seqcount synchronisation would be an alternative too that could allow
sleeping more easily than SRCU (OTOH if you don't need sleeping, then
RCU should be faster than seqcount).

But I'm not convinced we do need this to be atomic.


> - figure out where the mempolicy updates currently done in
> cpuset_update_task_memory_state() need to occur - this is part of the
> code that I'm pretty fuzzy on. (Maybe we can just copy the bits from
> Miao's patch for this?)

Basically we want to push all that into the sites where the memory policy
is actually changed. So yes they should all go away.

