Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZJBBXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZJBBXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbZJBBXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:23:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbZJBBXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:23:35 -0400
Date: Thu, 1 Oct 2009 18:21:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ondrej Zary <linux@rainbow-software.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: T400 suspend/resume regression -- bisected to a mystery merge
 commit
In-Reply-To: <20091002005907.GA7490@mit.edu>
Message-ID: <alpine.LFD.2.01.0910011817120.6996@localhost.localdomain>
References: <E1MrRDa-0002WF-LO@closure.thunk.org> <200909271813.42829.rjw@sisk.pl> <20090928135109.GB17514@mit.edu> <200909282322.57824.rjw@sisk.pl> <20091002005907.GA7490@mit.edu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Oct 2009, Theodore Tso wrote:
> 
> commit 8c3ee48dabee782d470cc4c7048ea64bb8b7d1cb
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu Oct 1 20:39:03 2009 -0400
> 
>     Revert "timekeeping: Update clocksource with stop_machine"
>     
>     This reverts commit 75c5158f70c065b9704b924503d96e8297838f79.

Hmm. Looks good. But you didn't cc most of the people actually involved 
with that commit (Martin who is the author, and John who acked it).

I think the revert is the right thing to do, especially as that 
'clocksource_mutex' looks totally bogus. Either the thing is protected by 
'stop_machine' or it's not. In neither case does it seem to make any sense 
to replace a spinlock with a mutex. 

And resuming anything with a big mutex is crazy anyway. 

That said, I do wonder if this is already fixed. See commit 
89133f93508137231251543d1732da638e6022e1:

    clocksource: Resume clocksource without taking the clocksource mutex

which already undid the part that probably mattered for you. That said, I 
still do think that that mutex is dubious, so maybe we should undo it all.

		Linus
