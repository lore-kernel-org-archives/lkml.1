Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbZJIDgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbZJIDgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 23:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758834AbZJIDgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 23:36:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:41951 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758384AbZJIDgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 23:36:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+RqwIWi0qRAws2BANR8G54DTjXUNsBw0TPCJCZMG
	bvkq+EIojJTEqi
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Frans Pop <elendil@planet.nl>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20091008203426.GA1946@phenom2.trippelsdorf.de>
References: <200910051500.55875.elendil@planet.nl>
	 <1254974743.7797.21.camel@marge.simson.net>
	 <20091008064041.67219b13@infradead.org>
	 <200910081655.37485.elendil@planet.nl>
	 <1255026217.6643.12.camel@marge.simson.net>
	 <20091008203426.GA1946@phenom2.trippelsdorf.de>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 05:35:18 +0200
Message-Id: <1255059318.7236.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 22:34 +0200, Markus Trippelsdorf wrote:
> On Thu, Oct 08, 2009 at 08:23:37PM +0200, Mike Galbraith wrote:
> > On Thu, 2009-10-08 at 16:55 +0200, Frans Pop wrote:
> > > On Thursday 08 October 2009, Arjan van de Ven wrote:
> > > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > > Date: Thu, 24 Sep 2009 13:24:16 +0200
> > > > Subject: [PATCH] x86, timers: check for pending timers after (device)
> > > > interrupts
> > > >
> > > > Now that range timers and deferred timers are common, I found a
> > > > problem with these using the "perf timechart" tool.
> > > >
> > > > It turns out that on x86, these two 'opportunistic' timers only
> > > > get checked when another "real" timer happens.
> > > > These opportunistic timers have the objective to save power by
> > > > hitchhiking on other wakeups, as to avoid CPU wakeups by themselves
> > > > as much as possible.
> > > 
> > > This patch makes quite a difference for me. iwlagn and phy0 now 
> > > consistently show at ~10 ms or lower.
> > > 
> > > I do still get occasional high latencies, but those are for things like
> > > "[rpc_wait_bit_killable]" or "Writing a page to disk", where I guess you'd 
> > > expect them. Those high latencies are mostly only listed for "Global" and 
> > > don't translate to individual processes.
> > 
> > I still see very high latencies coming out of idle (last noted was >
> > 300ms, NO_HZ) with this patch, and wonder if the hunk below makes any
> > difference whatsoever for you.  Here, it definitely does. (shouldn't)
> 
> I'm also seeing these strange, very high latencies here. Your patch
> didn't help unfortunately.
> 
> This is from an otherwise idle NO_NZ system:
> 
> # ./perf sched latency
> 
>  -----------------------------------------------------------------------------------------
>   Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |
>  -----------------------------------------------------------------------------------------
>   ksoftirqd/0:4         |      2.216 ms |      170 | avg:   24.235 ms | max:  808.356 ms |
>   ksoftirqd/1:6         |      2.611 ms |      205 | avg:    4.334 ms | max:  165.553 ms |
>   migration/2:7         |      0.000 ms |        1 | avg:    3.060 ms | max:    3.060 ms |
> 
> With latencytop the ksoftirqd latency is over 1 sec frequently. (Could be
> ondemand CPUfreq governor related?)

That's a separate issue, which Arjan was nice enough to fix for me.  He
even wrote the changelog, and used my mouse to do so ;-)

Watch.

Virgin tip pulled this morning, perf sched record sleep 1 on idle box.

 -----------------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |
 -----------------------------------------------------------------------------------------
  kicker:5845           |      0.000 ms |        1 | avg:  999.406 ms | max:  999.406 ms |
  rt2870TimerQHan:4952  |      0.008 ms |        3 | avg:    0.087 ms | max:    0.131 ms |
  Xorg:4913             |      0.099 ms |        2 | avg:    0.027 ms | max:    0.044 ms |
  kondemand/3:3106      |      0.014 ms |        2 | avg:    0.013 ms | max:    0.018 ms |
  perf:7229             |      3.986 ms |        1 | avg:    0.017 ms | max:    0.017 ms |
  events/3:14           |      0.038 ms |        1 | avg:    0.017 ms | max:    0.017 ms |
  kondemand/2:3105      |      0.017 ms |        1 | avg:    0.008 ms | max:    0.008 ms |
  kondemand/1:3104      |      0.041 ms |        1 | avg:    0.007 ms | max:    0.007 ms |
  konsole:5855          |      0.362 ms |        3 | avg:    0.004 ms | max:    0.006 ms |
  kondemand/0:3103      |      0.000 ms |        1 | avg:    0.000 ms | max:    0.000 ms |
 -----------------------------------------------------------------------------------------
  TOTAL:                |      4.565 ms |       16 |
 ---------------------------------------------------
  INFO: 40.741% state machine bugs (11 out of 27)
  INFO: 51.852% context switch bugs (14 out of 27)

Repeatable.  Apply patchlet, and the numbers below become repeatable.

perf_counter tools: make perf sched pass -F 0 to record

Commit 42e59d7d19dc4b4 introduced a sample frequency framework..
.. however it unfortunately changed how perf events get recorded,
and caused sched to miss events.

This patch causes the sched code to use -F 0 to not use the
new framework when recording sched data.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan The Wise <arjan@linux.intel.com>
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


 
 -----------------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |
 -----------------------------------------------------------------------------------------
  Xorg:4913             |      2.296 ms |       43 | avg:    0.075 ms | max:    0.686 ms |
  kicker:5845           |      3.106 ms |       28 | avg:    0.017 ms | max:    0.307 ms |
  perf:7419             |    147.147 ms |       16 | avg:    0.028 ms | max:    0.261 ms |
  klipper:6404          |      0.035 ms |        1 | avg:    0.256 ms | max:    0.256 ms |
  kondemand/3:3106      |      0.139 ms |       18 | avg:    0.039 ms | max:    0.192 ms |
  rt2870TimerQHan:4952  |      0.726 ms |      107 | avg:    0.010 ms | max:    0.165 ms |
  konsole:5856          |      0.180 ms |        2 | avg:    0.050 ms | max:    0.094 ms |
  kded:5831             |      0.044 ms |        1 | avg:    0.055 ms | max:    0.055 ms |
  events/3:14           |      0.066 ms |        3 | avg:    0.018 ms | max:    0.031 ms |
  kondemand/2:3105      |      0.015 ms |        2 | avg:    0.020 ms | max:    0.029 ms |
  ksoftirqd/3:10        |      0.326 ms |        3 | avg:    0.018 ms | max:    0.027 ms |
  kondemand/1:3104      |      0.142 ms |       24 | avg:    0.008 ms | max:    0.023 ms |
  rt2870MlmeThrea:4950  |      0.095 ms |       13 | avg:    0.012 ms | max:    0.022 ms |
  kondemand/0:3103      |      0.259 ms |       36 | avg:    0.013 ms | max:    0.020 ms |
  kwin:5841             |      0.038 ms |        1 | avg:    0.018 ms | max:    0.018 ms |
  sync_supers:92        |      0.008 ms |        1 | avg:    0.018 ms | max:    0.018 ms |
  events/0:11           |      0.005 ms |        1 | avg:    0.015 ms | max:    0.015 ms |
  konsole:5855          |      0.709 ms |       10 | avg:    0.007 ms | max:    0.013 ms |
  events/2:13           |      0.009 ms |        1 | avg:    0.011 ms | max:    0.011 ms |
  events/1:12           |      0.006 ms |        1 | avg:    0.010 ms | max:    0.010 ms |
  mysqld:5030           |      0.185 ms |        1 | avg:    0.009 ms | max:    0.009 ms |
  hald-addon-inpu:3191  |      0.006 ms |        1 | avg:    0.006 ms | max:    0.006 ms |
  mono:6472             |      0.144 ms |       11 | avg:    0.005 ms | max:    0.006 ms |
  ntpd:6020             |      0.030 ms |        1 | avg:    0.005 ms | max:    0.005 ms |
  gpg-agent:5783        |      0.047 ms |        1 | avg:    0.005 ms | max:    0.005 ms |
  sleep:7420            |      0.973 ms |        2 | avg:    0.003 ms | max:    0.005 ms |
  httpd2-prefork:6416   |      0.013 ms |        1 | avg:    0.005 ms | max:    0.005 ms |
  mysqld:5031           |      0.172 ms |        1 | avg:    0.005 ms | max:    0.005 ms |
  kwrapper:5838         |      0.010 ms |        1 | avg:    0.005 ms | max:    0.005 ms |
 -----------------------------------------------------------------------------------------
  TOTAL:                |    156.930 ms |      332 |
 ---------------------------------------------------




