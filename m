Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbXJXE1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbXJXE1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXJXE1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:27:17 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51288 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbXJXE1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:27:16 -0400
Date: Wed, 24 Oct 2007 10:09:16 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: containers@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Message-ID: <20071024043916.GA5357@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <471D4523.4040509@google.com> <20071023164704.GE4667@linux.vnet.ibm.com> <6599ad830710230941y5d175688ob3a4d9ac42ba8c8f@mail.gmail.com> <20071023173837.GG4667@linux.vnet.ibm.com> <6599ad830710231928n65a80021w582a07b5993377f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830710231928n65a80021w582a07b5993377f8@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 07:28:22PM -0700, Paul Menage wrote:
> > Good point. I think we need to subtract out the time it was waiting on runqueue
> > when calculating idle time.
> >
> >         |------- . . . . . . ---------zzzzzzzzzzzz.......-----------|
> >         t0     t1            t2       t3         t4     t5          t6
> >
> >
> >         ----    -> Running time
> >         ....    -> Waiting time (to get on the cpu)
> >         zzzz    -> Sleeping time (when it didnt want to run because of
> >                    lack of tasks)
> >
> > So, in this case,
> >
> >         idle time = (t4 - t3) / [ (t6 - t1) - (t2-t1) - (t5-t4)
> >
> 
> Do you mean (t6 - t0) where you have (t6 - t1)?

Ah ..yes.

> > ?
> >
> > This idle time will be a per-cpu stat for every cgroup and needs to be
> > consolidated across cpus into a single idle-stat number, just like how
> > top does it.
> 
> This would be an idle fraction, not an idle time. (seconds divided by seconds)

agreed, we need to be reporting idle time in (milli)seconds, although
the requirement we had was to report it back in percentage. I guess the
percentage figure can be derived from the raw idle time number.

How about:

	idle time = t4-t3 (effectively sleep time)

in the above example?

> It doesn't seem quite right to me that a cgroup's idle time metric be
> affected by the activity of other cgroups on the machine,

I don't see how the idle time metric defined above (t4-t3) can be
affected by other cgroup activity, unless the execution pattern of one
cgroup is dependent on the others.

However the minute you tranlsate this idle time into a percentage wrt
wall-clock time, then yes a cgroup's idle percentage can be affected by
others. For idle percentage to be meaningfull, I would imagine that
user-space tools will need to calculate it after discarding a group's
wait time.

> but it's
> hard to come up with a way of measuring it that doesn't have this
> behaviour - which is why, in the absence of hard CPU partitioning,
> it's not clear to me how much use this would be.
> 
> What would people be planning to use it for?

I think primarily for systems management tools to report back various
statistics about a OpenVZ/VServer-like container (just like top reports stats 
for a OS currently). Let me check if there are other uses envisoned for
it.

-- 
Regards,
vatsa
