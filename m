Return-Path: <linux-kernel-owner+w=401wt.eu-S1763488AbYENSci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763488AbYENSci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757416AbYENSc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:32:29 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:31636 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbYENSc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:32:28 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
From: Andi Kleen <andi@firstfloor.org>
References: <20080514174955.GA515@elte.hu>
Date: Wed, 14 May 2008 20:30:29 +0200
In-Reply-To: <20080514174955.GA515@elte.hu> (Ingo Molnar's message of "Wed, 14 May 2008 19:49:55 +0200")
Message-ID: <87fxsk7n7e.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 May 2008 18:23:28.0970 (UTC) FILETIME=[9B7052A0:01C8B5EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> As some of the latency junkies on lkml already know it, commit 8e3e076 
> ("BKL: revert back to the old spinlock implementation") in v2.6.26-rc2 
> removed the preemptible BKL feature and made the Big Kernel Lock a 
> spinlock and thus turned it into non-preemptible code again. This commit 
> returned the BKL code to the 2.6.7 state of affairs in essence.

It's a reasonable start, but have you considered doing this work
in tree instead? As in just add all the warnings, but don't actually
change the semantics yet.  I suspect you would get far more users
this way and the work would go faster. 

It would be reasonable to enable this in -mm if it the warnings are
not too intrusive (self disable itself etc.)

Also for fixing the ioctls I'm not sure that dynamic instrumentation
will really work because it would be tough to execute them all.

I suspect some variant of static code analysis would make sense
for the ioctls. 

I used to do some auditing with cflow. That won't
catch indirect function calls unfortunately, but if there's 
some way to find those and bail out one could do an automated
tool that flags all the ioctls that don't sleep for example
(don't have any sleeping functions in the call chain -- this
might need some manual annotation, but hopefully not much)

Then it would be possible to safely switch those over to a blocking
mutex variant of BKL. 

Now there could be some more automated analysis here: for example the 
main other user of BKL is character open. I suspect to really
make progress here you would also need a open_unlocked() and
do the same for all the open functions etc.

> According to my quick & dirty git-log analysis, at the current pace of 
> BKL removal we'd have to wait more than 10 years to remove most BKL 
> critical sections from the kernel and to get acceptable latencies again.

Hmm, is BKL really that common still that it's a latency problem?
The few VFS cases like locks can be fixed without extreme measures.

Most of the legacy users are unlikely to be latency problems,
simply because only very few people (or nobody) still has that hardware
and the code will never run.

Also I wouldn't lose sleep over e.g. let ISDN continue using BKL forever.

-Andi
