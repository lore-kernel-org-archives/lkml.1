Return-Path: <linux-kernel-owner+w=401wt.eu-S934181AbZKYJnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181AbZKYJnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbZKYJnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:43:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60383 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758477AbZKYJnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:43:50 -0500
Date: Wed, 25 Nov 2009 10:43:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 0/7] perf trace: general-purpose scripting support,
 v2
Message-ID: <20091125094338.GA21220@elte.hu>
References: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
 <1259137695.4027.45.camel@laptop>
 <1259141891.4027.199.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259141891.4027.199.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-11-25 at 09:28 +0100, Peter Zijlstra wrote:
> > On Wed, 2009-11-25 at 01:15 -0600, Tom Zanussi wrote:
> > > sched::sched_wakeup      0 01238.657997033     6183 firefox              comm=firefox, pid=6199, prio=120, success=1, target_cpu=1
> > > sched::sched_switch      1 01238.657991740     7140 firefox              prev_comm=firefox, prev_pid=7140, prev_prio=120, prev_state=S, next_comm=firefox, next_pid=6199, next_prio=120
> > > 
> > > min_wakeup_latency: -5293 
> > 
> > Looks like we missed a clock update on the cross cpu wakeup, Mike was
> > busy plugging those holes -- I've been starting at a patch that might
> > cure this (amongst other things).
> 
> Hmm, current -tip should have that cured as per:

well, but timestamp inconsistencies are still possible fundamentally, as 
cpu_clock() is not globally serialized.

If so then the (hack only) patch below would cure those timestamp 
inconsistencies?

	Ingo

Not-Signed-off-by-me

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 35df94e..4f36b47 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -248,7 +248,7 @@ static void perf_unpin_context(struct perf_event_context *ctx)
 
 static inline u64 perf_clock(void)
 {
-	return cpu_clock(smp_processor_id());
+	return trace_clock_global();
 }
 
 /*
