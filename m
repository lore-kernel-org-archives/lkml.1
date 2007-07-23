Return-Path: <linux-kernel-owner+w=401wt.eu-S1765171AbXGWQIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765171AbXGWQIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763520AbXGWQE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:04:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760587AbXGWQE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:04:57 -0400
Date: Mon, 23 Jul 2007 18:04:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-rt-users@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
Message-ID: <20070723160442.GA7995@elte.hu>
References: <469600F7.3060603@free.fr> <20070723095357.GA886@elte.hu> <46A4B7C2.1070304@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A4B7C2.1070304@free.fr>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* John Sigler <linux.kernel@free.fr> wrote:

> > ./trace-it 1 > trace.txt
> >
> > does it produce lots of trace entries? If not then 
> > CONFIG_FUNCTION_TRACING is not enabled. Once you see lots of output 
> > in the file, the tracer is up and running and you can start tracing 
> > the latency in your app.
> 
> # ./trace-it 1 >/tmp/trace.txt
> # wc /tmp/trace.txt
>   65555  393277 4096317 /tmp/trace.txt
> 
> preemption latency trace v1.1.5 on 2.6.20.7-rt8

>    <...>-939   0D...    0us : read_tsc (get_monotonic_cycles)

add 'notrace' to the definition of read_tsc in arch/i386/kernel/tsc.c. 
(check recent -rt's read_tsc() definition) (or do echo 1 > 
/proc/sys/kernel/trace_use_raw_cycles - if you are using recent enough 
-rt)

> >To track it down, use the method that trace-it.c uses to start/stop 
> >tracing, i.e. put the prctl(0,1); / prctl(0,0); calls into your app 
> >to start/stop tracing and the kernel will do the rest once you've set 
> >/proc/sys/kernel/preempt_max_latency back to 0: /proc/latency_trace 
> >will always contain the longest latency that your app triggered, of 
> >the critical path you programmed into it.
> 
> Here's what I came up with:
> http://linux.kernel.free.fr/latency/check_dektec_input3.cxx
> (I enable tracing only 1% of the time.)
> 
> The output looks very much like the one I got when I ran trace-it

> 1. Again, shouldn't there be other functions in the output?

there should be, once you fix read_tsc().

> 2. How much overhead do the prctl calls incur? Is it possible that 
> they are somehow masking my problem? (I'll let the program run all 
> night to maximize the chances of capturing the anomalous latency.)

it's not the prctl calls that matter but the fact that every kernel 
function will be traced if you have FUNCTION_TRACING on. It mask any 
races - but latencies are usually not masked (they are enlarged).

	Ingo
