Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbXITH05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbXITH05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759822AbXITH0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:26:19 -0400
Received: from mx10.go2.pl ([193.17.41.74]:49405 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758073AbXITH0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:26:16 -0400
Date: Thu, 20 Sep 2007 09:28:21 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070920072821.GA2065@ff.dom.local>
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F2123A.9070201@bull.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 08:24:58AM +0200, Nadia Derbey wrote:
> Jarek Poplawski wrote:
> >On 18-09-2007 16:55, Nadia Derbey wrote:
> >...
> >
> >>Well, reviewing the code I found another place where the 
> >>rcu_read_unlock() was missing.
> >>I'm so sorry for the inconvenience. It's true that I should have tested 
> >>with CONFIG_PREEMPT=y :-(
> >>Now, the ltp tests pass even with this option set...
> >>
> >>In attachment you'll find a patch thhat
> >>1) adds the missing rcu_read_unlock()
> >>2) replaces Andrew's fix with a new one: the rcu_read_lock() is now 
> >>taken in ipc_lock() / ipc_lock_by_ptr() and released in ipc_unlock(), 
> >>exactly as it was done in the ref code.
> >
> >
> >BTW, probably I miss something, but I wonder, how this RCU is working
> >here. E.g. in msg.c do_msgsnd() there is:
> >
> >msq = msg_lock_check(ns, msqid);
> >...
> >
> >msg_unlock(msq);
> >schedule();
> >
> >ipc_lock_by_ptr(&msq->q_perm);
> >
> >Since msq_lock_check() gets msq with ipc_lock_check() under
> >rcu_read_lock(), and then goes msg_unlock(msq) (i.e. ipc_unlock())
> >with rcu_read_unlock(), is it valid to use this with
> >ipc_lock_by_ptr() yet?
> 
> Before Calling msg_unlock() they call ipc_rcu_getref() that increments a 
> refcount in the rcu header for the msg structure. This guarantees that 
> the the structure won't be freed before they relock it. Once the 
> structure is relocked by ipc_lock_by_ptr(), they do the symmetric 
> operation i.e. ipc_rcu_putref().

Yes, I've found this later too - sorry for bothering. I was mislead
by the code like this:

struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
{
        struct kern_ipc_perm *out;
        int lid = ipcid_to_idx(id);

        rcu_read_lock();
        out = idr_find(&ids->ipcs_idr, lid);
        if (out == NULL) {
                rcu_read_unlock();
                return ERR_PTR(-EINVAL);
        }

which seems to suggest "out" is an RCU protected pointer, so, I
thought these refcounts were for something else. But, after looking
at how it's used it turns out to be ~90% wrong: probably 9 out of 10
places use refcouning around this, so, these rcu_read_locks() don't
work here at all. So, probably I miss something again, but IMHO,
these rcu_read_locks/unlocks could be removed here or in
ipc_lock_by_ptr() and it should be enough to use them directly, where
really needed, e.g., in msg.c do_msgrcv().

BTW, I've found this comment, which, at least for me, explains very
good, what's going on here:

/* Lockless receive, part 3:
 * Acquire the queue spinlock.
 */
 ipc_lock_by_ptr(&msq->q_perm);

Thanks,
Jarek P.
