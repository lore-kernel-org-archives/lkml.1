Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0CKMhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 07:37:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:44824 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0CKMhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 07:37:53 -0500
Subject: Re: [PATCH] perf_events: fix X86 bogus counts when multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com, robert.richter@amd.com, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <1268296361.5279.901.camel@twins>
References: <1268288259-4011-1-git-send-email-eranian@google.com>
	 <1268296361.5279.901.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 13:37:49 +0100
Message-ID: <1268311069.5037.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 09:32 +0100, Peter Zijlstra wrote:
> On Wed, 2010-03-10 at 22:17 -0800, eranian@google.com wrote:
> > This patch fixes a bug in 2.6.33 X86 event scheduling whereby
> > all counts are bogus as soon as events need to be multiplexed
> > because the PMU is overcommitted.
> > 
> > The code in hw_perf_enable() was causing multiplexed events
> > to accumulate collected counts twice causing bogus results.
> > 
> > This is demonstrated on AMD Barcelona with the example
> > below. First run, no conflict, you obtain the actual counts.
> > Second run, PMU overcommitted, multiplexing, all events are
> > over-counted. Third run, patch applied, you obtain the correct
> > count through scaling.
> > 
> 
> I'm a bit puzzled by this one, if we, during scheduling move an event
> from idx 1 to idx 2, we need to stop it on 1 and start if on 2,
> otherwise we do not properly transfer its count, right?
> 
> With the below patch it does no such thing.
> 
> I did fix some funnies I observed with hw_perf_enable() while doing the
> PEBS stuff, and -tip does it wrong differently from what you illustrate,
> so while there defenately is something to fix, I doubt the below is
> correct.

OK, so what happens is that we schedule badly like:

<...>-1987  [019]   280.252808: x86_pmu_start: event-46/1300c0: idx: 0
<...>-1987  [019]   280.252811: x86_pmu_start: event-47/1300c0: idx: 1
<...>-1987  [019]   280.252812: x86_pmu_start: event-48/1300c0: idx: 2
<...>-1987  [019]   280.252813: x86_pmu_start: event-49/1300c0: idx: 3
<...>-1987  [019]   280.252814: x86_pmu_start: event-50/1300c0: idx: 32
<...>-1987  [019]   280.252825: x86_pmu_stop: event-46/1300c0: idx: 0
<...>-1987  [019]   280.252826: x86_pmu_stop: event-47/1300c0: idx: 1
<...>-1987  [019]   280.252827: x86_pmu_stop: event-48/1300c0: idx: 2
<...>-1987  [019]   280.252828: x86_pmu_stop: event-49/1300c0: idx: 3
<...>-1987  [019]   280.252829: x86_pmu_stop: event-50/1300c0: idx: 32
<...>-1987  [019]   280.252834: x86_pmu_start: event-47/1300c0: idx: 1
<...>-1987  [019]   280.252834: x86_pmu_start: event-48/1300c0: idx: 2
<...>-1987  [019]   280.252835: x86_pmu_start: event-49/1300c0: idx: 3
<...>-1987  [019]   280.252836: x86_pmu_start: event-50/1300c0: idx: 32
<...>-1987  [019]   280.252837: x86_pmu_start: event-51/1300c0: idx: 32 *FAIL*

This happens because we only iterate the n_running events in the first
pass, and reset their index to -1 if they don't match to force a
re-assignment.

Now, in our RR example, n_running == 0 because we fully unscheduled, so
event-50 will retain its idx==32, even though in scheduling it will have
gotten idx=0, and we don't trigger the re-assign path.

The easiest way to fix this is the below patch, which simply validates
the full assignment in the second pass.

---
 arch/x86/kernel/cpu/perf_event.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4a0514d..a3aff76 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -787,7 +787,6 @@ void hw_perf_enable(void)
 		 * step2: reprogram moved events into new counters
 		 */
 		for (i = 0; i < n_running; i++) {
-
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
@@ -802,21 +801,16 @@ void hw_perf_enable(void)
 				continue;
 
 			x86_pmu_stop(event);
-
-			hwc->idx = -1;
 		}
 
 		for (i = 0; i < cpuc->n_events; i++) {
-
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
-			if (i < n_running &&
-			    match_prev_assignment(hwc, cpuc, i))
-				continue;
-
-			if (hwc->idx == -1)
+			if (!match_prev_assignment(hwc, cpuc, i))
 				x86_assign_hw_event(event, cpuc, i);
+			else if (i < n_running)
+				continue;
 
 			x86_pmu_start(event);
 		}


