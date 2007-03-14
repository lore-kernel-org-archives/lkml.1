Return-Path: <linux-kernel-owner+w=401wt.eu-S1161274AbXCNOOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161274AbXCNOOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161282AbXCNOOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:14:09 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59592 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161274AbXCNOOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:14:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelianov <xemul@sw.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [RFC] kernel/pid.c pid allocation wierdness
References: <45F7A4B3.5040005@sw.ru>
Date: Wed, 14 Mar 2007 08:12:35 -0600
In-Reply-To: <45F7A4B3.5040005@sw.ru> (Pavel Emelianov's message of "Wed, 14
	Mar 2007 10:30:59 +0300")
Message-ID: <m16493rk18.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov <xemul@sw.ru> writes:

> Hi.
>
> I'm looking at how alloc_pid() works and can't understand
> one (simple/stupid) thing.
>
> It first kmem_cache_alloc()-s a strct pid, then calls
> alloc_pidmap() and at the end it taks a global pidmap_lock()
> to add new pid to hash.
>
> The question is - why does alloc_pidmap() use at least
> two atomic ops and potentially loop to find a zero bit
> in pidmap? Why not call alloc_pidmap() under pidmap_lock
> and find zero pid in pidmap w/o any loops and atomics?
>
> The same is for free_pid(). Do I miss something?

Well as far as I can tell that is just the way the code
evolved.

Looking at the history.  At the time I started messing with it
alloc_pidmap was the function and it behaved pretty much as it
does today with locking (except it didn't disable irqs).

To add the allocation of struct pid.  I added alloc_pid
as a wrapper.  Left alloc_pidmap alone, and added the hash
table manipulation code.  I know this results is fairly
short hold times which is moderately important for a global lock.

We loop in alloc_pidnmap because of what we are trying to do.  Simply
returning the first free pid number would have bad effects on user
space, so we have the simple requirement that we don't reuse pid
numbers for as long as is practical.  We achieve that doing full walks
through the pid space before we consider a pid again.  So we have to
start from the last place we looked.  In addition  we may have
multiple pages of bitmap to traverse (when our pid limit is high) and
those pages are not physically contiguous.

So while I wouldn't call alloc_pidmap perfect it does seem to be
reasonable.

>From what I can tell for the low number of pids that we usually have
the pid hash table seems near optimal.

If we do dig into this more we need to consider a radix_tree to hold
the pid values.  That could replace both the pid map and the hash
table, gracefully handle but large and small pid counts, might
be a smidgin simpler, possibly be more space efficient, and it would
more easily handle multiple pid namespaces.   The downside to using a
radix tree is that is looks like it will have more cache misses for
the normal pid map size, and it is yet another change that we would
need to validate.

Eric
