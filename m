Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbXLCPIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbXLCPIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbXLCPIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:08:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54464 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750703AbXLCPIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:08:45 -0500
Date: Mon, 3 Dec 2007 10:08:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jarek Poplawski <jarkao2@o2.pl>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Need lockdep help
In-Reply-To: <20071203103630.GB2429@ff.dom.local>
Message-ID: <Pine.LNX.4.44L0.0712031000480.3630-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007, Jarek Poplawski wrote:

> > System sleep start:
> > 		down_read(notifier-chain rwsem);
> > 		call the notifier routine
> > 			down_write(&system_sleep_in_progress_rwsem);
> > 		up_read(notifier-chain rwsem);
> > 
> > System sleep end:
> > 		down_read(notifier-chain rwsem);
> > 		call the notifier routine
> > 			up_write(&system_sleep_in_progress_rwsem);
> > 		up_read(notifier-chain rwsem);
> > 
> > This creates a lockdep violation; each rwsem in turn is locked while 
> > the other is being held.  However the only way this could lead to 
> > deadlock would be if there was already a bug in the system Power 
> > Management code (overlapping notifications).
> 
> Actually, IMHO, there is no reason for any lockdep violation:
> 
> thread #1: has down_read(A); waits for #2 to down_write(B)
> thread #2: has down_write(B); never waits for #1 to down_read(A)
> 
> So, deadlock isn't possible here. If lockdep reports something else it
> should be fixed (and you'd be right to omit lockdep until this is
> done).

I think the reasoning goes the way Arjan described.  Suppose in between
#1 and #2 there is thread #3 trying to do down_write(A) and waiting for
#1.  Then thread #2 doesn't have to wait for #1 directly, but it would
have to wait for #3.

In my case the simplest answer appears to be the replace the rwsem
with something slightly more complicated (a mutex plus a boolean flag 
-- the loss of concurrency won't matter much since it isn't on a hot 
path).

Thanks for the comment.

Alan Stern

