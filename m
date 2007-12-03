Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXLCLEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXLCLEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 06:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXLCLEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 06:04:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48829 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbXLCLEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 06:04:14 -0500
Date: Mon, 3 Dec 2007 12:04:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203110412.GD28560@one.firstfloor.org>
References: <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202144331.6abf1289@laptopd505.fenrus.org> <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org> <20071203102715.GC28560@one.firstfloor.org> <20071203103815.GA2707@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203103815.GA2707@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 11:38:15AM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > Kernel waiting 2 minutes on TASK_UNINTERRUPTIBLE is certainly broken.
> > 
> > What should it do when the NFS server doesn't answer anymore or when 
> > the network to the SAN RAID array located a few hundred KM away 
> > develops some hickup?  [...]
> 
> maybe: if the user does a Ctrl-C (or a kill -9), the kernel should try 

You mean NFS intr should be default? Traditionally that was not done,
although that decision dates back to long before Linux to original SunOS. 

I was not there but I suspect it was because it is hard to distingush 
between "abort IO" and "abort program". With aborted IO you tend to end up 
with a page in page cache that is marked as IO error and will affect
other programs too.

Perhaps that can be cleanly solved -- personally I'm not sure -- but
it is likely not easy otherwise people would have done that a long
time ago.

> to honor it, instead of staying there stuck for a very long time 
> (possibly forever)?

Sure everybody hates that (it is like trying to argue against
free video games @), but fixing it properly is quite hard. 
I just think it's a bad idea to outlaw it before even attempting
to fix it.

If you consider any of the arguments in the following
paragraph "not rational" please state your objection precisely.
Thanks.

Consider the block case: First a lot of block
IO runs over networks too these days (iSCSI, drbd, nbd, SANs etc.) 
so the same considerations as for other network file systems
apply.  Networks can have hickups and might take long to recover.
Now implementing TASK_KILLABLE in all block IO paths
there properly is equivalent to implementing EIOCBRETRY aio because
it has to error out in near the same ways in all the same
places.  While I would like to see that (and it would probably make syslets
obsolete too ;-) it has been rejected as too difficult in the past.

> I think you are somehow confusing two issues: this patch in no way 
> declares that "long waits are bad" - if the user _choses_ to wait for 

Throwing a backtrace is the kernel's way to declare something as bad.
The only more clear ways to that I know of would be BUG or panic().

> way to stop_ are quite likely bad".

The user will just see the backtraces and think the kernel
has crashed.

-Andi

