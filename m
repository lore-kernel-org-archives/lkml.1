Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbXITNRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbXITNRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbXITNQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:16:56 -0400
Received: from mx12.go2.pl ([193.17.41.142]:45217 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753969AbXITNQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:16:55 -0400
Date: Thu, 20 Sep 2007 15:19:00 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070920131900.GB2796@ff.dom.local>
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net> <20070920072821.GA2065@ff.dom.local> <46F234DB.7030403@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F234DB.7030403@bull.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 10:52:43AM +0200, Nadia Derbey wrote:
> Jarek Poplawski wrote:
...
> >which seems to suggest "out" is an RCU protected pointer, so, I
> >thought these refcounts were for something else. But, after looking
> >at how it's used it turns out to be ~90% wrong: probably 9 out of 10
> >places use refcouning around this,
> 
> Actually, ipc_lock() is called most of the time without the 
> ipc_ids.mutex held and without refcounting (maybe you didn't look for 
> the msg_lock() sem_lock() and shm_lock() too).

Yes, you are 100% right and I'm 90% lier, 10% blind (maybe backward
too).

> So I think disabling preemption is needed, isn't it?

Do I've to tell the truth...?

> 
> >so, these rcu_read_locks() don't
> >work here at all. So, probably I miss something again, but IMHO,
> >these rcu_read_locks/unlocks could be removed here or in
> >ipc_lock_by_ptr() and it should be enough to use them directly, where
> >really needed, e.g., in msg.c do_msgrcv().
> >
> 
> I have to check for the ipc_lock_by_ptr(): may be you're right!

Since this whole locking scheme is really quite a puzzle, and needs
more than one or two looks to figure it out, I'd better try stop to
discredit myself more.

Anyway it looks to me like the most sophisticated way of achieving
locklessness I've seen so far. I hope, there is still some gain after
this RCU + refcounting vs. simple locking. (It seems somebody had
similar doubts writing the "Lockless receive, part 1:" comment in
do_msgrcv(); and probably again I'm very wrong, but this checking of
validity of RCU protected structure with an r_msg value, which is
done to avoid refcounting, looks like not very different and has
some cost too).

Regards,
Jarek P.
