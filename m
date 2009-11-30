Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbZK3Pwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbZK3Pwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbZK3Pwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:52:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbZK3Pwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:52:30 -0500
Date: Mon, 30 Nov 2009 07:52:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
In-Reply-To: <20091130100041.GA29610@infradead.org>
Message-ID: <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost> <20091130100041.GA29610@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Nov 2009, Christoph Hellwig wrote:
> 
> How long will this use be around?  I've seen some slow progress toward
> replacing most read side uses of the task list lock with RCU.  While we
> still have lots of read side users now I wonder when they'll go away.

tasklist_lock is pretty nasty. I threw out "replace it with RCU" because 
it would be nice, but the data structures used are not just simple linked 
lists that we have RCU helpers for traversing.

There are various real exclusion rules about things like 'tsk->exit_state' 
etc, which do not translate directly to RCU usage. Of course, _maybe_ all 
the places that care already take the thing for writing and would just 
automatically have exclusion anyway.

So I'd love to see somebody try to do the conversion. To a first 
approximation, you probably could do

 - turn tasklist_lock into a spinlock

 - sed 's/write_lock_irq(&tasklist_lock)/spin_lock(&tasklist_lock)/g'
   sed 's/write_unlock_irq(&tasklist_lock)/spin_unlock(&tasklist_lock)/g'

 - sed 's/read_lock(&tasklist_lock)/rcu_read_lock()/g'
   sed 's/read_unlock(&tasklist_lock)/rcu_read_unlock()/g'

 - make all the task lists use the RCU versions of the list routines

 - free the task structure using RCU

and you'd be _pretty_ close to a working system.

But I'd worry about current read-lockers that depend on things like that 
tsk->exit_state thing being stable from just read-locking (since only 
write-lockers should change it). So you can _probably_ do 99% of it fairly 
mindlessly, but the remaining 1% is the subtle stuff.

Maybe it's easier than I think. Or maybe I've totally ignored something, 
and there are much much worse issues than the occasional exit_state thing.
(Things like 'tsk->mm' are already protected by per-task locks, but there 
may be other things that depend on holding tasklist lock for exclusion).

			Linus
