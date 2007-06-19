Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbXFSEWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbXFSEWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 00:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXFSEWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 00:22:46 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:47437 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbXFSEWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 00:22:45 -0400
Date: Mon, 18 Jun 2007 21:22:02 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Miklos Szeredi <miklos@szeredi.hu>,
       cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org, shai@scalex86.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070619042201.GA13854@localdomain>
References: <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu> <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu> <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu> <20070618081204.GA11153@elte.hu> <20070618012055.81a7c837.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618012055.81a7c837.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 01:20:55AM -0700, Andrew Morton wrote:
> On Mon, 18 Jun 2007 10:12:04 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > ---------------------------------------------------->
> > Subject: [patch] x86: fix spin-loop starvation bug
> > From: Ingo Molnar <mingo@elte.hu>
> > 
> > Miklos Szeredi reported very long pauses (several seconds, sometimes 
> > more) on his T60 (with a Core2Duo) which he managed to track down to 
> > wait_task_inactive()'s open-coded busy-loop. He observed that an 
> > interrupt on one core tries to acquire the runqueue-lock but does not 
> > succeed in doing so for a very long time - while wait_task_inactive() on 
> > the other core loops waiting for the first core to deschedule a task 
> > (which it wont do while spinning in an interrupt handler).
> > 
> > The problem is: both the spin_lock() code and the wait_task_inactive() 
> > loop uses cpu_relax()/rep_nop(), so in theory the CPU should have 
> > guaranteed MESI-fairness to the two cores - but that didnt happen: one 
> > of the cores was able to monopolize the cacheline that holds the 
> > runqueue lock, for extended periods of time.
> > 
> > This patch changes the spin-loop to assert an atomic op after every REP 
> > NOP instance - this will cause the CPU to express its "MESI interest" in 
> > that cacheline after every REP NOP.
> 
> Kiran, if you're still able to reproduce that zone->lru_lock starvation problem,
> this would be a good one to try...

We tried this approach a week back (speak of co-incidences), and it did not
help the problem.  I'd changed calls to the zone->lru_lock spin_lock
to do spin_trylock in a while loop with cpu_relax instead.  It did not help,
This was on top of 2.6.17 kernels.  But the good news is 2.6.21, as
is does not have the starvation issue -- that is, zone->lru_lock does not
seem to get contended that much under the same workload.

However, this was not on the same hardware I reported zone->lru_lock
contention on (8 socket dual core opteron).  I don't have access to it 
anymore :(

Thanks,
Kiran
