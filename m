Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZBJLhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZBJLhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZBJLhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:37:33 -0500
Received: from smtp-out.google.com ([216.239.45.13]:4085 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZBJLhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:37:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=SBB3WCDOK88tUjnZNf5041pzm58uq/+Dp+JOzekpubS0ORBDg9kSpCD/DhcP7NbfY
	VSHPR4rL5CLttC579XhiA==
MIME-Version: 1.0
In-Reply-To: <200902091502.27056.nickpiggin@yahoo.com.au>
References: <4976D77C.3020107@cn.fujitsu.com> <4989606F.9030804@cn.fujitsu.com>
	 <6599ad830902061119t2d82c782pb6442f9a35fbb01c@mail.gmail.com>
	 <200902091502.27056.nickpiggin@yahoo.com.au>
Date: Tue, 10 Feb 2009 03:37:28 -0800
Message-ID: <6599ad830902100337mbde885fr89e5942f1016a1c@mail.gmail.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the 
	unallowed node when memory spread is set
From: Paul Menage <menage@google.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: miaox@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, cl@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 8, 2009 at 8:02 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>
> Is it a problem if mems_allowed can get sampled in an unsafe way?

It could cause an OOM to be incorrectly triggered if the task didn't
see all the mems that it was meant to have access to. (In the extreme
case, it could see no mems at all).

> It will happen only quite rarely. This code seems to be far simpler
> and more robust than the current fragile scheme, so it would be
> nice to use it.

Agreed, the existing task->mems_allowed / cpuset_update_memory_state()
code is a bit unwieldy. It's pretty much all inherited from the
original cpusets code.

A nicer way to do it might be:

- get rid of task->mems_allowed entirely

- have cpuset->mems_allowed be a pointer to an immutable RCU-protected
nodemask (so updating the nodemask for a cpuset would always replace
it with a fresh one and RCU-free the old one)

- make cpuset_zone_allowed_*() use rcu_read_lock() and just check
*(task_cs(current)->mems_allowed) rather than current->mems_allowed

- ensure that get_page_from_freelist() is also RCU-safe (right now I
think it's not since cpuset_zone_allowed_softwall() can sleep, but I
think cgroups/cpusets is sufficiently RCU-safe now that we could quite
likely remove the mutex lock from cpuset_zone_allowed_*()

- add an rcu_read_lock() in hugetlb.c:cpuset_mems_nr()

- figure out where the mempolicy updates currently done in
cpuset_update_task_memory_state() need to occur - this is part of the
code that I'm pretty fuzzy on. (Maybe we can just copy the bits from
Miao's patch for this?)

Anything else?

Paul
