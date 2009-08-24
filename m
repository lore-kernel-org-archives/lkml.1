Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZHXQHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZHXQHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZHXQHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:07:45 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:1305 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbZHXQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:07:45 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counters issue with enable_on_exec
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <7c86c4470908240903m322e2d5ck7d200046b10141a3@mail.gmail.com>
References: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
	 <1251121618.7538.262.camel@twins>
	 <7c86c4470908240844u7450b13eicf4c4a466e29d701@mail.gmail.com>
	 <7c86c4470908240903m322e2d5ck7d200046b10141a3@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 18:06:55 +0200
Message-Id: <1251130015.7538.310.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 18:03 +0200, stephane eranian wrote:

> >>  2) enable_on_exec on !leader counters is undefined
> >
> > then fail it.

Or make it work :-)

> >>  3) there is something fishy non the less
> >>
> > True.
> >
> >>
> >> 1. you fork() then create a counter group in both the parent and the
> >> child without sync, then read the parent group. This obviously doesn't
> >> do what is expected. See attached proglet for a better version.
> >>
> > I have modified the program based on your changes. See new version attached.
> >
> >> 2. enable_on_exec only works on leaders, Paul, was that intended?
> >>
> > All events in a group are scheduled together. If one event is not enabled
> > in a group, then the group is not dispatched. Setting enable_on_exec
> > just on leader makes sense. Then to enable the group on exec, you
> > enabled all events but the leader. The enable_on_exec will enable
> > the leader on exec and the group will be ready for dispatch. That's
> > how it should work in my mind.
> >
> >
> > As you indicated the issue is with the timing information and I think
> > it is not related to enable_on_exec. It is more related to the fact
> > that to enable a group with a single ioctl() you enable ALL BUT the
> > leader. But that means that the time_enabled for the !leader is
> > ticking. Thus scaling won't be as expected yet it is correct
> > given what happens internally.
> >
> > I think there needs to be a distinction between 'enabled immediately
> > but cannot run because group is not totally enabled' and 'cannot run
> > because the group has been multiplexed out yet all could be dispatched
> > because all events were dispatched'. In the former, it seems you don't
> > want time_enabled to tick, while in the latter you do. In other words,
> > time_enabled ticks for each event if the group is 'dispatch-able' (or
> > runnable in your terminology) otherwise it does not. time_enabled reflects
> > the fact that the group could run but did not have access to the PMU
> > resource because of contention with other groups.
> >
> In other words, I think timing_enabled is measuring the wrong thing.
> It should be instead called time_runnable and it should measure the
> time during which the event is runnable, i.e, its group is runnable. That
> means the event (group) could be dispatched if PMU was "free".

I tend to agree with you, but I'm hoping Paul will speak since he wrote
both the time accounting and the enable_on_exec thing.

