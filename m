Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbZJIDv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbZJIDv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 23:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbZJIDv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 23:51:56 -0400
Received: from smtp-out-068.synserver.de ([212.40.180.68]:1063 "HELO
	smtp-out-068.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751904AbZJIDvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 23:51:55 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 12329
Date: Fri, 9 Oct 2009 05:51:17 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Frans Pop <elendil@planet.nl>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
Message-ID: <20091009035117.GB1985@phenom2.trippelsdorf.de>
References: <200910051500.55875.elendil@planet.nl>
 <1254974743.7797.21.camel@marge.simson.net>
 <20091008064041.67219b13@infradead.org>
 <200910081655.37485.elendil@planet.nl>
 <1255026217.6643.12.camel@marge.simson.net>
 <20091008203426.GA1946@phenom2.trippelsdorf.de>
 <1255059318.7236.13.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255059318.7236.13.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 05:35:18AM +0200, Mike Galbraith wrote:
> On Thu, 2009-10-08 at 22:34 +0200, Markus Trippelsdorf wrote:
> > On Thu, Oct 08, 2009 at 08:23:37PM +0200, Mike Galbraith wrote:
> > > On Thu, 2009-10-08 at 16:55 +0200, Frans Pop wrote:
> > > > On Thursday 08 October 2009, Arjan van de Ven wrote:
> > > > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > > > Date: Thu, 24 Sep 2009 13:24:16 +0200
> > > > > Subject: [PATCH] x86, timers: check for pending timers after (device)
> > > > > interrupts
> > > > >
> > > > > Now that range timers and deferred timers are common, I found a
> > > > > problem with these using the "perf timechart" tool.
> > > > >
> > > > > It turns out that on x86, these two 'opportunistic' timers only
> > > > > get checked when another "real" timer happens.
> > > > > These opportunistic timers have the objective to save power by
> > > > > hitchhiking on other wakeups, as to avoid CPU wakeups by themselves
> > > > > as much as possible.
> > > > 
> > > > This patch makes quite a difference for me. iwlagn and phy0 now 
> > > > consistently show at ~10 ms or lower.
> > > > 
> > > > I do still get occasional high latencies, but those are for things like
> > > > "[rpc_wait_bit_killable]" or "Writing a page to disk", where I guess you'd 
> > > > expect them. Those high latencies are mostly only listed for "Global" and 
> > > > don't translate to individual processes.
> > > 
> > > I still see very high latencies coming out of idle (last noted was >
> > > 300ms, NO_HZ) with this patch, and wonder if the hunk below makes any
> > > difference whatsoever for you.  Here, it definitely does. (shouldn't)
> > 
> > I'm also seeing these strange, very high latencies here. Your patch
> > didn't help unfortunately.
> > 
> > This is from an otherwise idle NO_NZ system:
> > 
> > # ./perf sched latency
> > 
> >  -----------------------------------------------------------------------------------------
> >   Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |
> >  -----------------------------------------------------------------------------------------
> >   ksoftirqd/0:4         |      2.216 ms |      170 | avg:   24.235 ms | max:  808.356 ms |
> >   ksoftirqd/1:6         |      2.611 ms |      205 | avg:    4.334 ms | max:  165.553 ms |
> >   migration/2:7         |      0.000 ms |        1 | avg:    3.060 ms | max:    3.060 ms |
> > 
> > With latencytop the ksoftirqd latency is over 1 sec frequently. (Could be
> > ondemand CPUfreq governor related?)
> 
> That's a separate issue, which Arjan was nice enough to fix for me.  He
> even wrote the changelog, and used my mouse to do so ;-)
> 
> 
> Repeatable.  Apply patchlet, and the numbers below become repeatable.
> 
> perf_counter tools: make perf sched pass -F 0 to record
> 
> Commit 42e59d7d19dc4b4 introduced a sample frequency framework..
> .. however it unfortunately changed how perf events get recorded,
> and caused sched to miss events.
> 
> This patch causes the sched code to use -F 0 to not use the
> new framework when recording sched data.

Yes, your're right. With this patch applied perf sched latency is back
to normal.

-- 
Markus
