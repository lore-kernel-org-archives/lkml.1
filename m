Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXDLMdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXDLMdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 08:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXDLMdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 08:33:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:37947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbXDLMdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 08:33:13 -0400
To: Buytaert_Steven@emc.com
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield proposals/rationale
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Apr 2007 15:31:31 +0200
In-Reply-To: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com>
Message-ID: <p737ish90ss.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Buytaert_Steven@emc.com writes:

> Since the new 2.6.x O(1) scheduler I'm having latency problems. Probably due
> to excessive use of sched_yield in code in components I don't have control
> over. This 'problem'/behavioral change has been reported also by other
> applications (e.g. OpenLDAP, Gnome netmeeting, Postgress, e.google...)

On the other hand when they fix their code to not rely on sched_yield
but use some more directed wakeup method they will end up with a much
more robust configuration. sched_yield always assumes the rest of the system
is idle, which is just wrong.

But yes the new sched_yield semantics seem to be definitely unexpected
for a lot of people.

The only way I could think of to make sched_yield work the way they 
expect would be to define some way of gang scheduling and give
sched_yield semantics that it preferably yields to other members
of the gang.

But it would be still hard to get these semantics (how to define
the gangs) into your uncontrollable broken applications and also
it has the risk of either unfairness or not full utilization of the 
machine. Getting it to scale well on MP systems would be also likely 
a challenge.

> I have analysed the sched_yield code in kernel/sched.c (2.6.16 SLES10) and have 3 questions/proposals:
> 
> 1) Would it be beneficial to give each task one try to be enqueued on the
> end of the active queue (by means of a boolean flag, reset each time the
> time slices reach 0 and it is put in the expired list by scheduler_tick)?

That would still not unbreak most applications I would suspect -- they
will likely try to yield multiple times before using up a full time slice
unless their event handlers are very compute intensive.

In general other subsystems (e.g. VM) had had quite bad experiences
with similar "one more try" hacks -- they tend to be not robust and
actually penalize some loads.

> 2) When a task is eventually put in the expired list in sched_yield, give it
> back the full time slices round (as done in scheduler_tick), not with the
> remaining slices as is done now?

That would likely be unfair and exploitable.

> 3) Put the task in the expired list at a random position, not at the end as
> is done now?

Sounds like an interesting approach, but to do it in O(1) you would
need a new data structure with possibly much larger constant overhead.

-Andi
