Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZGNOsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZGNOsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZGNOsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:48:40 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:39055 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbZGNOsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:48:39 -0400
Message-ID: <4A5C9ABA.9070909@nortel.com>
Date: Tue, 14 Jul 2009 08:48:26 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
References: <200907102350.47124.henrik@austad.us>	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>	 <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
In-Reply-To: <1247568455.9086.115.camel@Palantir>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 14:48:29.0187 (UTC) FILETIME=[268B2530:01CA0492]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raistlin wrote:

> Now, all the above is true on UP setups. Extending to SMP (m CPUs) and
> considering the first part of my draft proposal, i.e., having the
> proxying tasks busy waiting (would say "spinning", but that busy wait is
> interruptible, preemptable, etc.) on some CPU while their proxy is being
> scheduled, we are back to the case of having the m highest entity
> running... And thus we are happy!


> Well, so and so. I fact, if you want (and we want! :-D) to go a step
> further, and consider how to remove the --possibly quite log on Linux as
> Peter said-- wasting of CPU time due to busy waiting, what you can do is
> to actually block a proxying task, instead of having it "spinning", so
> that some other task in some other group, which may not be one of the m
> highest prio ones, can reclaim that bandwidth... But... Ladies and
> gentlemen, here it is: BLOCKING. Again!! :-(

Let's call the highest priority task A, while the task holding the lock
(that A wants) is called B.  Suppose we're on an dual-cpu system.

According to your proposal above we would have A busy-waiting while B
runs with A's priority.  When B gives up the lock it gets downgraded and
A acquires it and continues to run.

Alternately, we could have A blocked waiting for the lock, a separate
task C running, and B runs with A's priority on the other cpu.  When B
gives up the lock it gets downgraded and A acquires it and continues to run.

>From an overall system perspective we allowed C to make additional
forward progress, increasing the throughput.  On the other hand, there
is a small window where A isn't running and it theoretically should be.
  If we can bound it, would this window really cause so much difficulty
to the schedulability analysis?

Chris
