Return-Path: <linux-kernel-owner+w=401wt.eu-S1752148AbZGROLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbZGROLn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZGROLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:11:41 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:58300 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZGROLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:11:40 -0400
Date: Sat, 18 Jul 2009 23:11:37 +0900 (JST)
Message-Id: <20090718.231137.187581409.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, fweisbec@gmail.com, linux@brodo.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding transition of CPU frequency counting
 support to perfcounters
From: mitake@dcl.info.waseda.ac.jp
In-Reply-To: <20090718093115.GB9142@elte.hu>
References: <20090716.110834.886429911292889318.mitake@dcl.info.waseda.ac.jp>
	<20090718093115.GB9142@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC] Adding transition of CPU frequency counting support to perfcounters
Date: Sat, 18 Jul 2009 11:31:15 +0200

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > Hi,
> > 
> > I'm trying to add transition of CPU frequency counting support to perfcounters.
> > If perf can count freq transition, this will be more useful
> > because frequencies of CPUs are dynamic things today.
> > And there's no way to count freq transitions per process level.
> > 
> > But I have a question.
> > I copied the way of sw-events already exist such as migration or page-fault.
> > But like this,
> > 
> > % perf stat emacs
> > 
> >  Performance counter stats for 'emacs':
> > 
> >     1324.294227  task-clock-msecs         #      0.704 CPUs
> >            1980  context-switches         #      0.001 M/sec
> >              30  CPU-migrations           #      0.000 M/sec
> >           42986  page-faults              #      0.032 M/sec
> >               0  cpufreq-up               #      0.000 M/sec
> >                  ^^^^^^^^^^
> >               0  cpufreq-down             #      0.000 M/sec
> >                  ^^^^^^^^^^^^      
> >      4057387374  cycles                   #   3063.811 M/sec
> >      4767004447  instructions             #      1.175 IPC
> >        20687483  cache-references         #     15.622 M/sec
> >         5103528  cache-misses             #      3.854 M/sec
> > 
> >     1.880587959  seconds time elapsed
> > 
> > perf said there's no freq transition.
> > But I checked there are some transitions with cpufreq-info.
> > 
> > Can you find something bad in this patch?
> > I'll continue to try implementing.
> > If you find some bad points, I'd like to hear..
> 
> > +		if (freqs->new > freqs->old)
> > +			perf_swcounter_event(PERF_COUNT_SW_CPUFREQ_UP,
> > +					     1, 0, NULL, 0);
> > +		else
> > +			perf_swcounter_event(PERF_COUNT_SW_CPUFREQ_DOWN,
> > +					     1, 0, NULL, 0);
> 
> Could you try:
> 
> 	perf stat -a sleep 60
> 
> while you do your emacs run that toggles cpufreq events? This makes 
> sure all transitions are counted, regardless of which context 
> triggers it. Do you still get zero counts this way?

Oh, my perf could count cpufreq events!
Thanks for your nice advice!

% perf stat -a sleep 60

 Performance counter stats for 'sleep 60':

  479088.075595  task-clock-msecs         #      7.984 CPUs
         199080  context-switches         #      0.000 M/sec
          19584  CPU-migrations           #      0.000 M/sec
         322978  page-faults              #      0.001 M/sec
             29  cpufreq-up               #      0.000 M/sec
             42  cpufreq-down             #      0.000 M/sec
    73703367828  cycles                   #    153.841 M/sec
    52005203450  instructions             #      0.706 IPC
      209762467  cache-references         #      0.438 M/sec
       84916856  cache-misses             #      0.177 M/sec

   60.009508200  seconds time elapsed

And I'm using ondemand governor now,
so kernel thread [kondemand] context causes freq transition.
I didn't notice that...

Could you merge this patch?
Can I send this patch with descriptions and Signed-off-by?
