Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbZLRROm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbZLRROm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZLRROl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:14:41 -0500
Received: from www.tglx.de ([62.245.132.106]:57694 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbZLRROl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:14:41 -0500
Date: Fri, 18 Dec 2009 18:14:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Miquel van Smoorenburg <miquels@cistron.nl>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: spinlock which can morph into a mutex
In-Reply-To: <20091218143032.GA16595@xs4all.net>
Message-ID: <alpine.LFD.2.00.0912181804360.2755@localhost.localdomain>
References: <20091218143032.GA16595@xs4all.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009, Miquel van Smoorenburg wrote:

> I'm trying to implement a dynamically resizable hashtable, and
> I have found that after resizing the table I need to call
> synchronize_rcu() and finish up before letting other writers
> (inserts, deletes) access the table.
> 
> Ofcourse during the hashtable update a spinlock is held to
> exclude the other writers. But I cannot hold this spinlock over
> synchronize_rcu(), yet the other writers still need to be excluded.
> 
> So I probably need a mutex instead of a spinlock, but I want to
> keep minimal overhead for the common case (when no resizing is in
> progress).  I think I need a spinlock that can morph into a mutex ..

Is the writer frequency and the possible contention so high that you
need a spinlock at all ?
 
> I was thinking about using something like the code below.
> It is sortof like a spinlock, but it's ofcourse less fair
> than actual ticketed spinlocks.
> 
> I'm working off 2.6.27 at the moment, but I noticed that in
> 2.6.28 adaptive spinning was introduced for mutexes. Is the
> approach below still worth it with adaptive spinning or could
> I just convert the spinlocks to mutexes with minimal extra overhead ?

Test it :)

If the mutex is still to heavy weight for you, then you can solve it
without implementing another weird concurrency control:

writer side:

       spin_lock(&hash_lock);

       if (unlikely(hash_update_active)) {
       	  spin_unlock(&hash_lock);
       	  wait_event_(un)interruptible(&hash_wq, !hash_update_active);
	  spin_lock(&hash_lock);
       }

resize side:

       spin_lock(&hash_lock);
       hash_update_active = 1;
       ....
       spin_unlock(&hash_lock);
       synchronize_rcu();
       hash_update_active = 0;
       wake_up(&hash_wq);

Thanks,

	tglx
