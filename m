Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbXIYLo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbXIYLo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbXIYLov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:44:51 -0400
Received: from mx12.go2.pl ([193.17.41.142]:37510 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752221AbXIYLot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:44:49 -0400
Date: Tue, 25 Sep 2007 13:47:05 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070925114705.GA3148@ff.dom.local>
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net> <20070920072821.GA2065@ff.dom.local> <46F234DB.7030403@bull.net> <46F270DA.5030101@bull.net> <20070921084453.GA1758@ff.dom.local> <46F7885F.4080906@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F7885F.4080906@bull.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 11:50:23AM +0200, Nadia Derbey wrote:
> Jarek Poplawski wrote:
...
> >2. I'm not sure this refcounting with ipc_rcu_getref/putref is SMP
> >safe (memory barriers): it's not atomic, so locking is needed, but
> >e.g. in do_msgsnd() kern_ipc_perm lock is used for this, while
> >freeque() calls ipc_rcu_putref() with ipc_ids mutex only.
> >
> >3. Probably similar problem is possible with msr_d.r_msg which is
> >read in do_msgrcv() under rcu_read_lock() only.
> >
> 
> In think here they have avoided refcoutning by using r_msg:
> r_msg is initialzed to -EAGAIN before releasing the msq lock. if 
> freequeue() is called it sets r_msg to EIDRM (see expunge_all(-EIDRM)).
> Setting r_msg is always done under the msq lock (expunge_all() / 
> pipelined_Sned()).
>  Since rcu_read_lock is called right after schedule, they are sure the 
> msq pointer is still valid when they re-lock it once a msg is present in 
> the receive queue.
> 
> Please tell me if I'm not clear ;-)

All clear!

Except... this r_msg is still unclear to me. Since it's read without
msq lock I doubt this first check after schedule() is of any value. A
comment: "Lockless receive, part 2" tells about some safety against a
race with pipeline_send() and expunge_all() when in wake_up_process(),
but how can we be sure this r_msg is not just to be changed and this
wake_up_process() is running while "while" check still sees
ERR_PTR(-EAGAIN) instead of NULL?

Thanks & sorry for delay,
Jarek P.
