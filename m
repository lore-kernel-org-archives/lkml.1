Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZJHGYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZJHGYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZJHGYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:24:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:35590 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751056AbZJHGYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:24:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+s7iwxoL6sFmuc4rX2ohJajVr/vZSYu7aoOjj4EF
	kDoZAC9jOssBWf
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <1254974743.7797.21.camel@marge.simson.net>
References: <200910051500.55875.elendil@planet.nl>
	 <200910061749.02805.elendil@planet.nl>
	 <200910071910.53907.elendil@planet.nl>
	 <200910072034.57511.elendil@planet.nl>
	 <1254974743.7797.21.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 08:23:23 +0200
Message-Id: <1254983003.14810.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 06:05 +0200, Mike Galbraith wrote:
> On Wed, 2009-10-07 at 20:34 +0200, Frans Pop wrote:
> > On Wednesday 07 October 2009, Frans Pop wrote:
> > > On Tuesday 06 October 2009, Frans Pop wrote:
> > > > I've checked for 2.6.31.1 now and iwlagn is listed high there too when
> > > > the system is idle, but with normal values of 60-100 ms. And phy0 has
> > > > normal values of below 10 ms.
> > > > I've now rebooted with today's mainline git; phy0 now frequently shows
> > > > with values of around 100 ms too (i.e. higher than last time).
> > >
> > > Mike privately sent me a script to try to capture the latencies with
> > > perf, but the perf output does not show any high latencies at all. It
> > > looks as if we may have found a bug in latencytop here instead.
> > 
> > Not sure if it's relevant nor what it means, but I frequently see two lines 
> > for iwlagn, e.g:
> > 
> >     Scheduler: waiting for cpu              102.4 msec         99.7 %
> >     .                                         3.3 msec          0.3 %
> > 
> > I get the same results with both latencytop 0.4 and 0.5.
> 
> OK, I see latencytop spikes here on an idle box too, to the tune of up
> to a _second_.  Booting with nohz=off seems to have cured it.
> 
> I wanted to see if that's also the perf sched record -C N trouble I
> warned you not to try when recording with script, but unfortunately,
> after pulling this morning...
> 
> marge:/root/tmp # perf sched lat --sort=max
> Segmentation fault
> 
> ...perf sched got busted.  Seems likely to be same thing for both
> though, as magnitude/frequency of bogons is very similar.

Reverting problematic commit showed that nohz isn't the source of perf
sched record -C N oddity.

However, aside from latencytop seemingly having trouble with nohz, there
appears to be a problem with perf sched record -a as well, the same one
Arjan just fixed for perf timechart.

In thread - [PATCH] perf timechart: Work around commit 42e59d7d19dc4b4,
Arjan said..
<quote>
Commit 42e59d7d19dc4b4 introduced a sample frequency framework..
.. however it unfortunately changed how perf events get recorded,..
</quote>

Monkey see monkey (eep) do, and record mostly idle box, only amarok
doing it's thing...

Before:
marge:/root/tmp # perf sched record sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.279 MB perf.data (~12208 samples) ]

After:
marge:/root/tmp # perf sched record sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.649 MB perf.data (~28349 samples) ]


perf_counter tools: make perf sched pass -F 0 to record

Commit 42e59d7d19dc4b4 introduced a sample frequency framework..
.. however it unfortunately changed how perf events get recorded,
and caused sched to miss events.

This patch causes the sched code to use -F 0 to not use the
new framework when recording sched data.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 tools/perf/builtin-sched.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/tools/perf/builtin-sched.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-sched.c
+++ linux-2.6/tools/perf/builtin-sched.c
@@ -1902,6 +1902,7 @@ static const char *record_args[] = {
 	"-f",
 	"-m", "1024",
 	"-c", "1",
+	"-F", "0",
 	"-e", "sched:sched_switch:r",
 	"-e", "sched:sched_stat_wait:r",
 	"-e", "sched:sched_stat_sleep:r",



