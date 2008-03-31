Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbYCaKo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbYCaKo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYCaKoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:44:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60398 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbYCaKoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:44:17 -0400
Date: Mon, 31 Mar 2008 12:44:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [RFC,PATCH] loopback: calls netif_receive_skb() instead of
	netif_rx()
Message-ID: <20080331104403.GA12681@elte.hu>
References: <20080323.032949.194309002.davem@davemloft.net> <47E6A5FD.6060407@cosmosbay.com> <20080331094823.GA11651@elte.hu> <20080331.030848.175668431.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331.030848.175668431.davem@davemloft.net>
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

> I don't think it's safe.
> 
> Every packet you receive can result in a sent packet, which in turn 
> can result in a full packet receive path being taken, and yet again 
> another sent packet.
> 
> And so on and so forth.
> 
> Some cases like this would be stack bugs, but wouldn't you like that 
> bug to be a very busy cpu instead of a crash from overrunning the 
> current stack?

sure.

But the core problem remains: our loopback networking scalability is 
poor. For plain localhost<->localhost connected sockets we hit the 
loopback device lock for every packet, and this very much shows up on 
real workloads on a quad already: the lock instruction in netif_rx is 
the most expensive instruction in a sysbench DB workload.

and it's not just about scalability, the plain algorithmic overhead is 
way too high as well:

 $ taskset 1 ./bw_tcp -s
 $ taskset 1 ./bw_tcp localhost
 Socket bandwidth using localhost: 2607.09 MB/sec
 $ taskset 1 ./bw_pipe
 Pipe bandwidth: 3680.44 MB/sec

i dont think this is acceptable. Either we should fix loopback TCP 
performance or we should transparently switch to VFS pipes as a 
transport method when an app establishes a plain loopback connection (as 
long as there are no frills like content-modifying component in the 
delivery path of packets after a connection has been established - which 
covers 99.9% of the real-life loopback cases).

I'm not suggesting we shouldnt use TCP for connection establishing - but 
if the TCP loopback packet transport is too slow we should use the VFS 
transport which is both more scalable, less cache-intense and has lower 
straight overhead as well.

	Ingo
