Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZGOWeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZGOWeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZGOWeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:34:06 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:5737 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755945AbZGOWeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:34:04 -0400
Date: Wed, 15 Jul 2009 18:34:00 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: "James H. Anderson" <anderson@cs.unc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090715223400.GF14993@cs.fsu.edu>
References: <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com> <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu> <1247589099.7500.191.camel@twins> <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu> <20090715205503.GA14993@cs.fsu.edu> <4A5E4FDD.7090307@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4A5E4FDD.7090307@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 03:53:33PM -0600, Chris Friesen wrote:

> >From an API standpoint, the "group scheduling" functionality in linux
> allows for the creation of an arbitrary hierarchy of groups, each of
> which may contain zero or more tasks.  (Each task is associated with
> exactly one group.)
> 
> There is a distinction between groups containing realtime tasks, and
> groups containing non-realtime tasks.  For realtime groups, each group
> is allocated a specific amount of cpu time.  For non-realtime groups,
> each group is allocated a specific weight.
> 
> A realtime group may use up to its specified amount of cpu time.  Any
> cpu time not used by a realtime group is distributed to the non-realtime
> groups according to their relative weights.
> 
> This does add a whole different API to the mix, but allows for controls
> to be set by the administrator on existing POSIX apps without needing to
> recompile them.

This is in the right direction, but there is a lot about Linux groups
that I either do not understand or which falls short of what is needed.
Perhaps you can point me to an up to date detailed explanation of
how they work?

>From what I've been able to infer from my brief foray into that
part of the kernel code (a year ago), there seemed to be several
aspects of the group scheduling that did not seem to admit
schedulability analysis.  (I admit that I may have read it wrong,
and these statements are false.)

1) The priority of a group seemed to be defined by the priority of
the highest-priority thread in the group's run-queue, which means
it varies dynamically according to which threads in the group are
contending.

2) Budget enforcement seemed to only occur at system tick
boundaries, which means precision can only be achieved at the cost
of frequent clock interrupts.

3) It seemed that a thread could belong to more than one group, 
and so distributed charges arbitrarily between groups.
If so, budget allocation would seem very difficult.

4) On an SMP, more than one thread could be running against
the same budget at the same time, resulting in budget over-charges.

I am particularly concerned about the latter.  The published
analyses of hierarchical generalizations of bandwidth
limiting/guaranteeing aperiodic server scheduling algorithms I
have seen so far all seem to require allocating bandwidth/budget
to groups on a per-processor basis, so as to void concurrent
charges to the same budget.

Ted

