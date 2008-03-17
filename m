Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYCQKQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYCQKQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 06:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYCQKQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 06:16:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60183 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbYCQKQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 06:16:28 -0400
Date: Mon, 17 Mar 2008 11:16:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Willy Tarreau <w@1wt.eu>,
       Ray Lee <ray-lk@madrabbit.org>, "LKML," <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Message-ID: <20080317101612.GA23575@elte.hu>
References: <200803111749.29143.nickpiggin@yahoo.com.au> <200803171819.38892.nickpiggin@yahoo.com.au> <20080317082638.GB18229@1wt.eu> <200803171954.01315.nickpiggin@yahoo.com.au> <1205746084.8514.301.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205746084.8514.301.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> The latest sched code contains a few patches in this direction 
> (.25-rc6), and they seem to have the desired effect on 1 socket single 
> and dual core and 8 socket single core and dual core. On quad core we 
> seem to have some load balance problems that destroy the workload in 
> other interresting ways - looking into that now.

here's a performance comparison between 2.6.21 and -rc6, on a 
8-socket/16-core system:

   http://redhat.com/~mingo/misc/sysbench-rc6.jpg

                      [transactions/sec, higher is better]

              2.6.21         2.6.25-rc5         2.6.25-rc6
   -------------------------------------------------------
      1:      383.26             270.47             269.69
      2:      741.02             527.67             560.52
      4:     1880.79            1049.59            1184.44
      8:     3815.59            2901.07            3881.78
     16:     8944.81            8993.24            9000.81
     32:     8647.19            8568.66            8638.64
     64:     8058.10            7624.46            8212.92
    128:     6500.06            5804.75            8182.71
    256:     5625.27            3656.52            7661.02

  [ Postgresql 8.3, default scheduler parameters, sysbench parameters: 
    --test=oltp --db-driver=psql --max-time=60 --max-requests=0 
    --oltp-read-only=on. Ask if you need more info about the test. ]

as you can see near and after the saturation point .25 not only has 
fixed any regression but rules the picture and is 35%+ faster at 256 
clients and shows no breakdown at all at high client counts.

( i also have to observe that while running with 256 clients overload, 
  the 2.6.25 system was totally serviceable, while 2.6.21 showed bad 
  lags. )

The "early rampup" phase [less than 25% utilized] is still not as good 
as we'd like it to be - our idle balancing force is still a tad too 
strong for this workload. (But that is relatively easy to solve in 
general and we are working on those bits.)

in any case, we welcome any help from you with these tuning efforts. 
It's certainly fun :)

	Ingo
