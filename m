Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYLEIY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYLEIY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYLEIYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:24:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59765 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbYLEIYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:24:48 -0500
Date: Fri, 5 Dec 2008 09:24:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, arjan@infradead.org, hpa@zytor.com,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205082431.GD2030@elte.hu>
References: <1228464216.18899.18.camel@twins> <20081205.000716.40104924.davem@davemloft.net> <20081205081137.GB2030@elte.hu> <20081205.001717.216522767.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205.001717.216522767.davem@davemloft.net>
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

> > > These things aren't measuring time, or even just cycles, they are 
> > > measuring things like L2 cache misses, cpu cycles, and other 
> > > similar kinds of events.
> > > 
> > > So these counters are going to measure all of the damn crap 
> > > assosciated with doing the read() call as well as the real work the 
> > > task does.
> > 
> > that's wrong, look at the example we posted - see it pasted below.
> 
> It's still too simple to be useful.
> 
> There are so many aspects other than the immediate PC that monitoring 
> tasks want to inspect when a counter overflows.

fully agreed.

While most of the flat profilers like oprofile will be happy with the PC 
alone, i do think we want a couple of extended notification types.

Right now we begun with the most trivial ones:

  enum perf_record_type {
          PERF_RECORD_SIMPLE,
          PERF_RECORD_IRQ,
  };

... but it would be natural to do a PERF_RECORD_GP_REGISTERS as well. 
Perhaps even a PERF_RECORD_STACKTRACE using the sysprof facilities, to do 
a hierarchic multi-dimension profile that sysprof does so nicely.

Note that the record type is an independent attribute of a counter. It 
can be set regardless of the even type - and it can be set independently 
for each counter. So you can have say 3 'simple' counters with no irqs 
plus one 'all registers' counter which generates an IRQ: and then you can 
read out the simple counters at the same type.

We could also perhaps do a PERF_RECORD_ALL: it represents a snapshot of 
all active counter values in the task. This is _far_ better than forcibly 
scheduling the monitored task.

	Ingo
