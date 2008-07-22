Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYGVLWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYGVLWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYGVLVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:21:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYGVLVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:21:52 -0400
Date: Tue, 22 Jul 2008 13:21:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [TCP bug] stuck distcc connections in latest -git
Message-ID: <20080722112133.GA6575@elte.hu>
References: <20080720.104411.81744468.davem@davemloft.net> <20080721133059.GA30637@elte.hu> <20080721134506.GA27598@elte.hu> <20080721182318.GA20940@elte.hu> <alpine.LFD.1.10.0807211131390.31863@woody.linux-foundation.org> <20080721184616.GA8442@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721184616.GA8442@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> ok, have updated the testboxes to your latest push.
> 
> Btw., otherwise the big networking pull held up pretty well on a 
> healthy range of testboxes i have, [...]

hm, the distcc TCP hangs are back:

Distcc client box (quad, 10.0.1.16) running v2.6.24:

 dione:~> netstat -nt | grep -vw TIME_WAIT | grep 3632
 tcp        0 250455 10.0.1.16:55559             10.0.1.19:3632              ESTABLISHED
 tcp        0 254743 10.0.1.16:56096             10.0.1.19:3632              ESTABLISHED
 tcp        0 219617 10.0.1.16:55674             10.0.1.19:3632              ESTABLISHED

              [ ^--- note the stuck send-queue ]

Distcc server box (16-way, 10.0.1.19) running very-latest:

 phoenix:~> netstat -nt | grep 10.0.1.16 | grep 3632 

 tcp        0      0 10.0.1.19:3632              10.0.1.16:55559             ESTABLISHED 
 tcp        0      0 10.0.1.19:3632              10.0.1.16:56096             ESTABLISHED 
 tcp        0      0 10.0.1.19:3632              10.0.1.16:55674             ESTABLISHED 

 tcp        0      0 10.0.1.19:3632              10.0.1.16:34411             ESTABLISHED 
 tcp        0      0 10.0.1.19:3632              10.0.1.16:51094             ESTABLISHED 
 tcp        0      0 10.0.1.19:3632              10.0.1.16:60787             ESTABLISHED 
 tcp        0      0 10.0.1.19:3632              10.0.1.16:50874             ESTABLISHED 

I.e. the client side send-queue is stuck in established state, server 
side thinks it's a proper established connection. Nobody makes any 
progress.

Also note the final 4 connections on the server side - those are not 
present on the client box.

The hung condition seemed permanent (i waited a couple of minutes).

Then i shut down the distccd on the server side, which propagated to the 
client:

 distcc[18496] (dcc_pump_sendfile) ERROR: sendfile failed: Broken pipe
 distcc[18496] (dcc_readx) ERROR: unexpected eof on fd4
 distcc[18496] (dcc_r_token_int) ERROR: read failed while waiting for token "DONE"
 distcc[18496] Warning: failed to distribute kernel/futex.c to ph/20, running locally instead

Server side lingered in FIN_WAIT2 a bit:

Proto Recv-Q Send-Q Local Address               Foreign Address             State
tcp        0      0 10.0.1.19:3632              10.0.1.16:56096             FIN_WAIT2
tcp        0      0 10.0.1.19:3632              10.0.1.16:55559             FIN_WAIT2

I retried the same build 10 times and it would not reproduce - so this 
again is a hard to reproduce condition. (and there's no chance to get a 
proper tcpdump either, at these traffic levels)

	Ingo
