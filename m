Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZHKQ4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZHKQ4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZHKQ43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:56:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45361 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbZHKQ43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:56:29 -0400
Date: Tue, 11 Aug 2009 18:56:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] cache-miss and cache-refs events on P6-mobile CPUs
Message-ID: <20090811165614.GA7529@elte.hu>
References: <20090810123228.GD6838@basil.fritz.box> <20090810125651.GB6082@sig21.net> <20090810132923.GA4418@elte.hu> <20090810192658.GA15513@sig21.net> <20090810201406.GA6961@elte.hu> <20090810203706.GA17338@sig21.net> <20090810213133.GB16944@elte.hu> <20090810221307.GA19236@sig21.net> <20090811093405.GA13004@elte.hu> <20090811155052.GB5315@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811155052.GB5315@sig21.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Stezenbach <js@sig21.net> wrote:

> On Tue, Aug 11, 2009 at 11:34:05AM +0200, Ingo Molnar wrote:
> > 
> > Could you try the patch below, does it do the trick? Note, since 
> > there's just two generic counters and perf stat uses four counters, 
> > you'll need to run longer commands than 'true' or something like:
> > 
> >   perf stat -a sleep 1
> > 
> > or:
> > 
> >   perf stat --repeat 10 /bin/ls -R /usr/bin >/dev/null
> > 
> > to get all counters excercised and time-shared on your CPU.
> 
> OK, here are the results:
> 
> # ./perf stat -a true
> 
>  Performance counter stats for 'true':
> 
>        1.332145  task-clock-msecs         #      1.057 CPUs 
>               4  context-switches         #      0.003 M/sec
>               0  CPU-migrations           #      0.000 M/sec
>             121  page-faults              #      0.091 M/sec
>          788333  cycles                   #    591.777 M/sec
>          610408  instructions             #      0.774 IPC  
>   <not counted>  cache-references        
>   <not counted>  cache-misses            
> 
>     0.001260775  seconds time elapsed
> 
> # ./perf stat -a sleep 1
> 
>  Performance counter stats for 'sleep 1':
> 
>     1001.358010  task-clock-msecs         #      1.000 CPUs 
>             253  context-switches         #      0.000 M/sec
>               0  CPU-migrations           #      0.000 M/sec
>             145  page-faults              #      0.000 M/sec
>         8841883  cycles                   #      8.830 M/sec  (scaled from 85.04%)
>         6361047  instructions             #      0.719 IPC    (scaled from 78.03%)
>          801847  cache-references         #      0.801 M/sec  (scaled from 14.96%)
>           16925  cache-misses             #      0.017 M/sec  (scaled from 21.97%)
> 
>     1.001540692  seconds time elapsed
> 
> # ./perf stat --repeat 10 /bin/ls -R /usr/bin >/dev/null
> 
>  Performance counter stats for '/bin/ls -R /usr/bin' (10 runs):
> 
>        8.642859  task-clock-msecs         #      0.939 CPUs    ( +-   2.382% )
>               1  context-switches         #      0.000 M/sec   ( +-   0.000% )
>               0  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
>             375  page-faults              #      0.043 M/sec   ( +-   0.000% )
>        14796621  cycles                   #   1712.005 M/sec   ( +-   0.306% )
>        15526008  instructions             #      1.049 IPC     ( +-   0.020% )
>   <not counted>  cache-references        
>   <not counted>  cache-misses            
> 
>     0.009207932  seconds time elapsed   ( +-   4.020% )
> 
> # ./perf stat --repeat 10 /bin/ls -lR /usr/bin >/dev/null
> 
>  Performance counter stats for '/bin/ls -lR /usr/bin' (10 runs):
> 
>       49.894190  task-clock-msecs         #      0.762 CPUs    ( +-   8.231% )
>              45  context-switches         #      0.001 M/sec   ( +-  52.174% )
>               0  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
>             476  page-faults              #      0.010 M/sec   ( +-   0.000% )
>        81036819  cycles                   #   1624.173 M/sec   ( +-   3.166% )  (scaled from 96.03%)
>        88822455  instructions             #      1.096 IPC     ( +-   2.108% )  (scaled from 96.42%)
>          573228  cache-references         #     11.489 M/sec   ( +-  37.947% )
>   <not counted>  cache-misses            
> 
>     0.065464625  seconds time elapsed   ( +-  19.349% )
> 
> # ./perf stat --repeat 10 /bin/ls -R /usr/lib >/dev/null
> 
>  Performance counter stats for '/bin/ls -R /usr/lib' (10 runs):
> 
>      136.771643  task-clock-msecs         #      0.075 CPUs    ( +-  19.292% )
>             757  context-switches         #      0.006 M/sec   ( +-  56.332% )
>               0  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
>             343  page-faults              #      0.003 M/sec   ( +-   0.000% )
>       173125500  cycles                   #   1265.800 M/sec   ( +-   5.034% )  (scaled from 78.21%)
>       174597635  instructions             #      1.009 IPC     ( +-   1.829% )  (scaled from 78.34%)
>         2441413  cache-references         #     17.850 M/sec   ( +-  18.289% )  (scaled from 21.79%)
>           21112  cache-misses             #      0.154 M/sec   ( +-  11.183% )  (scaled from 21.66%)
> 
>     1.824204481  seconds time elapsed   ( +-  29.781% )

Ok, this all looks pretty good!

	Ingo
