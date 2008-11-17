Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYKQR0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYKQR0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYKQR0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:26:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51046 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYKQR0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:26:07 -0500
Date: Mon, 17 Nov 2008 18:25:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20081117172549.GA27974@elte.hu>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera> <20081117090648.GG28786@elte.hu> <20081117.011403.06989342.davem@davemloft.net> <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117170844.GJ12081@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > 4% on my machine, but apparently my machine is sooooo special (see 
> > oprofile thread), so maybe its cpus have a hard time playing with 
> > a contended cache line.
> >
> > It definitly needs more testing on other machines.
> >
> > Maybe you'll discover patch is bad on your machines, this is why 
> > it's in net-next-2.6
> 
> ok, i'll try it on my testbox too, to check whether it has any effect 
> - find below the port to -git.

it gives a small speedup of ~1% on my box:

   before:      Throughput 3437.65 MB/sec 64 procs
   after:       Throughput 3473.99 MB/sec 64 procs

... although that's still a bit close to the natural tbench noise 
range so it's not conclusive and not like a smoking gun IMO.

But i think this change might just be papering over the real 
scalability problem that this workload has in my opinion: that there's 
a single localhost route/dst/device that millions of packets are 
squeezed through every second:

 phoenix:~> ifconfig lo
 lo        Link encap:Local Loopback  
           inet addr:127.0.0.1  Mask:255.0.0.0
           UP LOOPBACK RUNNING  MTU:16436  Metric:1
           RX packets:258001524 errors:0 dropped:0 overruns:0 frame:0
           TX packets:258001524 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:0 
           RX bytes:679809512144 (633.1 GiB)  TX bytes:679809512144 (633.1 GiB)

There does not seem to be any per CPU ness in localhost networking - 
it has a globally single-threaded rx/tx queue AFAICS even if both the 
client and server task is on the same CPU - how is that supposed to 
perform well? (but i might be missing something)

What kind of test-system do you have - one with P4 style Xeon CPUs 
perhaps where dirty-cacheline cachemisses to DRAM were particularly 
expensive?

	Ingo
