Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbXIUImy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbXIUImy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbXIUImr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:42:47 -0400
Received: from mx10.go2.pl ([193.17.41.74]:49581 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750722AbXIUImq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:42:46 -0400
Date: Fri, 21 Sep 2007 10:44:53 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070921084453.GA1758@ff.dom.local>
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net> <20070920072821.GA2065@ff.dom.local> <46F234DB.7030403@bull.net> <46F270DA.5030101@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F270DA.5030101@bull.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 03:08:42PM +0200, Nadia Derbey wrote:
> Nadia Derbey wrote:
> >Jarek Poplawski wrote:
> >
> >>On Thu, Sep 20, 2007 at 08:24:58AM +0200, Nadia Derbey wrote:
...
> >Actually, ipc_lock() is called most of the time without the 
> >ipc_ids.mutex held and without refcounting (maybe you didn't look for 
> >the msg_lock() sem_lock() and shm_lock() too).
> >So I think disabling preemption is needed, isn't it?
> >
> >>so, these rcu_read_locks() don't
> >>work here at all. So, probably I miss something again, but IMHO,
> >>these rcu_read_locks/unlocks could be removed here or in
> >>ipc_lock_by_ptr() and it should be enough to use them directly, where
> >>really needed, e.g., in msg.c do_msgrcv().
> >>
> >
> >I have to check for the ipc_lock_by_ptr(): may be you're right!
> >
> 
> So, here is the ipc_lock_by_ptr() status:
> 1) do_msgsnd(), semctl_main(GETALL), semctl_main(SETALL) and find_undo() 
> call it inside a refcounting.
>   ==> no rcu read section needed.
> 
> 2) *_exit_ns(), ipc_findkey() and sysvipc_find_ipc() call it under the 
> ipc_ids mutex lock.
>   ==> no rcu read section needed.
> 
> 3) do_msgrcv() is the only path where ipc_lock_by_ptr() is not called 
> under refcounting
>   ==> rcu read section + some more checks needed once the spnlock is
>       taken.
> 
> So I completely agree with you: we might remove the rcu_read_lock() from 
> the ipc_lock_by_ptr() and explicitley  call it when needed (actually, it 
> is already explicitly called in do_msgrcv()).

Yes, IMHO, it should be at least more readable when we can see where
this RCU is really needed.

But, after 3-rd look, I have a few more doubts (btw., 3 looks are
still not enough for me with this code, so I cerainly can miss many
things here, and, alas, I manged to see util and msg code only):

1. ipc_lock() and ipc_lock_check() are used without ipc_ids.mutex,
but it's probably wrong: they call idr_find() with ipc_ids pointer
which needs this mutex, just like in similar code in: ipc_findkey(),
ipc_get_maxid() or sysvipc_find_ipc().

2. I'm not sure this refcounting with ipc_rcu_getref/putref is SMP
safe (memory barriers): it's not atomic, so locking is needed, but
e.g. in do_msgsnd() kern_ipc_perm lock is used for this, while
freeque() calls ipc_rcu_putref() with ipc_ids mutex only.

3. Probably similar problem is possible with msr_d.r_msg which is
read in do_msgrcv() under rcu_read_lock() only.

Regards,
Jarek P.
