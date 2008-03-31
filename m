Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbYCaLge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbYCaLge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 07:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYCaLgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 07:36:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYCaLgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 07:36:23 -0400
Date: Mon, 31 Mar 2008 13:36:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: poor network loopback performance and scalability (was: Re:
	[RFC,PATCH] loopback: calls netif_receive_skb() instead of
	netif_rx())
Message-ID: <20080331113602.GA13526@elte.hu>
References: <20080331094823.GA11651@elte.hu> <20080331.030848.175668431.davem@davemloft.net> <20080331104403.GA12681@elte.hu> <20080331.040242.214941948.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331.040242.214941948.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 31 Mar 2008 12:44:03 +0200
> 
> > and it's not just about scalability, the plain algorithmic overhead is 
> > way too high as well:
> > 
> >  $ taskset 1 ./bw_tcp -s
> >  $ taskset 1 ./bw_tcp localhost
> >  Socket bandwidth using localhost: 2607.09 MB/sec
> >  $ taskset 1 ./bw_pipe
> >  Pipe bandwidth: 3680.44 MB/sec
> 
> Set your loopback MTU to some larger value if this result and the 
> locking overhead upsets you.

yes, of course it "upsets me" - it shows up in macrobenchmarks as well 
(not just lmbench) - wouldnt (and shouldnt) that upset you?

And even with a ridiculously high MTU of 1048576 there's only a 13% 
improvement:

   # ifconfig lo mtu 1048576
   # taskset 1 ./bw_tcp -s
   # taskset 1 ./bw_tcp localhost
   Socket bandwidth using localhost: 2951.51 MB/sec

pipes are still another ~25% faster:

   # taskset 1 ./bw_pipe
   Pipe bandwidth: 3657.40 MB/sec

> > i dont think this is acceptable. Either we should fix loopback TCP 
> > performance or we should transparently switch to VFS pipes as a 
> > transport method when an app establishes a plain loopback connection 
> > (as long as there are no frills like content-modifying component in 
> > the delivery path of packets after a connection has been established 
> > - which covers 99.9% of the real-life loopback cases).
> >
> > I'm not suggesting we shouldnt use TCP for connection establishing - 
> > but if the TCP loopback packet transport is too slow we should use 
> > the VFS transport which is both more scalable, less cache-intense 
> > and has lower straight overhead as well.
[...]

> Also, woe be to the application that wants fast local interprocess 
> communication and doesn't use IPC_SHM, MAP_SHARED, pipes, or AF_UNIX 
> sockets.  (there's not just one better facility, there are _four_!)
> 
> From this perspective, people way-overemphasize loopback performance, 
> and 999 times out of 1000 they prove their points using synthetic 
> benchmarks.
> 
> And don't give me this garbage about the application wanting to be 
> generic and therefore use IP sockets for everything.  Either they want 
> to be generic, or they want the absolute best performance.  Trying to 
> get an "or" and have both at the same time will result in ludicrious 
> hacks ending up in the kernel.

i talked about the localhost data transport only (in the portion you 
dropped from your quotes), not about the connection API or the overall 
management of such sockets. There's absolutely no good technical reason 
i can see why plain loopback sockets should be forced to go over a 
global lock, or why apps should be forced to change to another API when 
the real problem is that kernel developers are lazy or incompetent to 
fix their code.

And i'm still trying to establish whether we have common ground for 
discussion: do you accept my numbers that TCP loopback transport 
performs badly when compared to pipes (i think you accepted that 
implicitly, but i dont want to put anything into your mouth).

Having agreed on that, do you share my view that it should be and could 
be fixed? Or do you claim that it cannot be fixed and wont ever be 
fixed?

	Ingo
