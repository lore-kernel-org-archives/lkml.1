Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbXIULCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbXIULCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 07:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbXIULBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 07:01:42 -0400
Received: from mx10.go2.pl ([193.17.41.74]:36607 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755850AbXIULBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 07:01:40 -0400
Date: Fri, 21 Sep 2007 13:03:47 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070921110347.GB1758@ff.dom.local>
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net> <20070920072821.GA2065@ff.dom.local> <46F234DB.7030403@bull.net> <46F270DA.5030101@bull.net> <20070921084453.GA1758@ff.dom.local> <46F398C3.3000804@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F398C3.3000804@bull.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 12:11:15PM +0200, Nadia Derbey wrote:
> Jarek Poplawski wrote:
...
> >2. I'm not sure this refcounting with ipc_rcu_getref/putref is SMP
> >safe (memory barriers): it's not atomic, so locking is needed, but
> >e.g. in do_msgsnd() kern_ipc_perm lock is used for this, while
> >freeque() calls ipc_rcu_putref() with ipc_ids mutex only.
> 
> OK, but freeque() freeary() and shm_destroy() are special cases:
> we have the following path:
> 
> mutex_lock(ipc_ids.mutex)
> ...
> ipc_lock(ipcp)
> ... do whatever cleaning is needed ...
> ipc_rmid(ipcp)
> ipc_unlock(ipcp)
> ....
> ipc_rcu_putref(ipcp)
> 
> Once the rmid has been done the ipc structure is considered as not 
> visible anymore from the user side ==> any syscall called with the 
> corresponding id will return invalid.
> The only thing that could happen is that this structure be reused for a 
> newly allocated ipc structure. But this too cannot happen since we are 
> under the ipc_ids mutex lock.
> 
> Am I wrong?

I hope not! But, then it would be probably another logical trick:
ipc_rcu_getref/putref() seems to prevent kfreeing of a structure, so
if it's used in do_msgsnd() there should be a risk something can do
this kfree at this moment, and it seems freeque() is the only one,
which both: can do this and cares for this refcount. Then, e.g., if
any of them does ipc_rcu_getref() a bit later and sees old (cached)
value - kfree can be skipped forever. On the other hand, if there is
no such possibility because of other reasons, this all refcounting
looks like a code beautifier only...

Thanks,
Jarek P.


