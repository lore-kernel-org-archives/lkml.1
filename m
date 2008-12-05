Return-Path: <linux-kernel-owner+w=401wt.eu-S1751489AbYLEITO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbYLEITO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYLEIS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:18:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYLEIS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:18:57 -0500
Date: Fri, 5 Dec 2008 09:18:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       arjan@infradead.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205081838.GC2030@elte.hu>
References: <18744.29747.728320.652642@cargo.ozlabs.ibm.com> <20081205063131.GB12785@elte.hu> <20081205070329.GA30874@elte.hu> <20081204.235747.43111785.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204.235747.43111785.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 5 Dec 2008 08:03:29 +0100
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > This can be done in a very natural way with our abstraction, and the 
> > > "hello.c" example happens to do exactly that:
> > 
> > multiple people pointed out that we have not posted hello.c :-/
> 
> Because it's completely not providing the facility.  This is not how
> people want to use the performance counters at all.
> 
> And it doesn't even do what Paulus said is necessary, he said:
> 
> --------------------
> > One thing that this sort of thing can't do is to get values from 
> > multiple counters that correlate with each other.  For instance, we 
> > would often want to count, say, L2 cache misses and instructions 
> > completed at the same time, and be able to read both counters at very 
> > close to the same time, so that we can measure average L2 cache misses 
> > per instruction completed, which is useful.
> --------------------
> 
> And if you read one counter then read the other as seperate operations, 
> you get extra events in there as a side effect of going back into 
> userspace between the two reads.

that's wrong. If you _want_ to measure in a different context, with as 
little measurement impact as possible, you can do it with our code. The 
announcement provides the example for that.

For example, i just started this bash infinite loop:

  $ while :; do :; done &
  [1] 1877

  $ ./monitor -e 1 -c 1000000000 1877
  IP: 0x00000031a2e70d4b
  IP: 0x0000000000455f64
  IP: 0x00000031a2f028a0
  IP: 0x0000000000440692
  IP: 0x0000000000441b8e
  IP: 0x00000031a2e6f630
  IP: 0x0000000000446129
  IP: 0x00000031a2e6edbc
  IP: 0x0000000000443736
  IP: 0x0000000000441c80
  IP: 0x000000000043913a
  ^C

We get IP readouts every 1 billion instructions executed in that shell. 
That shell is never stopped or otherwise intruded - it's kept as an as 
pristine of an execution environment as possible.

Furthermore, the event readouts strictly only include event counts of the 
shell PID, _not_ of the monitor context's read() or other activities.

> Nobody wants that, [...]

Nobody wants that and we dont do it.

Really, you should take a more serious look at our code.

	Ingo
