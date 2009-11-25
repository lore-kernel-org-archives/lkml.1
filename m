Return-Path: <linux-kernel-owner+w=401wt.eu-S934401AbZKYJ6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401AbZKYJ6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758400AbZKYJ6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:58:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbZKYJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:58:29 -0500
Subject: Re: [RFC][PATCH 0/7] perf trace: general-purpose scripting
 support, v2
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20091125094338.GA21220@elte.hu>
References: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
	 <1259137695.4027.45.camel@laptop> <1259141891.4027.199.camel@laptop>
	 <20091125094338.GA21220@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 10:58:29 +0100
Message-ID: <1259143109.4027.241.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 10:43 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2009-11-25 at 09:28 +0100, Peter Zijlstra wrote:
> > > On Wed, 2009-11-25 at 01:15 -0600, Tom Zanussi wrote:
> > > > sched::sched_wakeup      0 01238.657997033     6183 firefox              comm=firefox, pid=6199, prio=120, success=1, target_cpu=1
> > > > sched::sched_switch      1 01238.657991740     7140 firefox              prev_comm=firefox, prev_pid=7140, prev_prio=120, prev_state=S, next_comm=firefox, next_pid=6199, next_prio=120
> > > > 
> > > > min_wakeup_latency: -5293 
> > > 
> > > Looks like we missed a clock update on the cross cpu wakeup, Mike was
> > > busy plugging those holes -- I've been starting at a patch that might
> > > cure this (amongst other things).
> > 
> > Hmm, current -tip should have that cured as per:
> 
> well, but timestamp inconsistencies are still possible fundamentally, as 
> cpu_clock() is not globally serialized.

No, but the cross-cpu update should have pulled 1 to the same time as 0.

So what we see here is that at wakeup time, cpu0 has 01238.657997033, if
it at that time does a cross-cpu clock update, sched_clock_remote()
should pull cpu1's time to that same time (unless cpu1 is ahead, but
given the situation that's clearly not the case).

The clock update on cpu1's schedule() would then either find a negative
increment, not further updating the time, but refreshing the raw tsc
stamp so that future updates appear monotonic, or find a positive stamp,
resulting in fwd time movement.

In any case, the wakeup latency should appear >= 0.

