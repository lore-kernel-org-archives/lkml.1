Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbZJBIC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbZJBIC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 04:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbZJBIC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 04:02:28 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:33086 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbZJBICZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 04:02:25 -0400
Date: Fri, 2 Oct 2009 10:02:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, John Stultz <johnstul@us.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ondrej Zary <linux@rainbow-software.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: T400 suspend/resume regression -- bisected to a mystery merge
 commit
Message-ID: <20091002100218.7c4eb8b8@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LFD.2.01.0910011817120.6996@localhost.localdomain>
References: <E1MrRDa-0002WF-LO@closure.thunk.org>
	<200909271813.42829.rjw@sisk.pl>
	<20090928135109.GB17514@mit.edu>
	<200909282322.57824.rjw@sisk.pl>
	<20091002005907.GA7490@mit.edu>
	<alpine.LFD.2.01.0910011817120.6996@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009 18:21:50 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 1 Oct 2009, Theodore Tso wrote:
> > 
> > commit 8c3ee48dabee782d470cc4c7048ea64bb8b7d1cb
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date:   Thu Oct 1 20:39:03 2009 -0400
> > 
> >     Revert "timekeeping: Update clocksource with stop_machine"
> >     
> >     This reverts commit 75c5158f70c065b9704b924503d96e8297838f79.
> 
> Hmm. Looks good. But you didn't cc most of the people actually involved 
> with that commit (Martin who is the author, and John who acked it).
> 
> I think the revert is the right thing to do, especially as that 
> 'clocksource_mutex' looks totally bogus. Either the thing is protected by 
> 'stop_machine' or it's not. In neither case does it seem to make any sense 
> to replace a spinlock with a mutex. 
> 
> And resuming anything with a big mutex is crazy anyway. 
> 
> That said, I do wonder if this is already fixed. See commit 
> 89133f93508137231251543d1732da638e6022e1:
> 
>     clocksource: Resume clocksource without taking the clocksource mutex
> 
> which already undid the part that probably mattered for you. That said, I 
> still do think that that mutex is dubious, so maybe we should undo it all.

It whole clocksource rework started with the wish to get rid of the
change_clocksource call in update_wall_time. That call is unnecessary
in 99.9% of all cases as the clocksource does not change all the time.
In order to do that the new clocksource is activated with stop_machine.
Now if you use stop_machine you can not hold any spinlock which made
it necessary to convert the clocksource spinlock to a mutex. And we
need something to protect against concurrent clocksource changes, e.g.
one clocksource_register vs a clocksource_change_rating triggered by
the watchdog. The only other solution would be to split the clocksource
change, part 1) detection that a clocksource change is needed, part 2)
stop_machine does the clocksource selection. Right now the clocksource
to use is identified prior to the stop_machine call.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

