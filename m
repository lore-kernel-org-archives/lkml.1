Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYHKN32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYHKN32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYHKN3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:29:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51687 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbYHKN3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:29:20 -0400
Date: Mon, 11 Aug 2008 15:29:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [revert] mysql+oltp regression
Message-ID: <20080811132902.GB14474@elte.hu>
References: <1218454322.25098.24.camel@marge.simson.net> <20080811114324.GA23529@elte.hu> <48A03049.202@novell.com> <20080811124857.GD10082@elte.hu> <48A038A6.4010104@novell.com> <20080811131400.GA909@elte.hu> <48A03C6E.60303@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A03C6E.60303@novell.com>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

>> ok, thanks. I'm curious, what are those ripple effects? Stability or 
>> performance?
>
> Performance.  I found it while working on my pi series (which fyi I 
> should have a v2 refresh for soon, probably today...i am hoping to get 
> some review feedback from you on that as well, time permitting of 
> course ;).
>
> Basically the behavior I was observing was that kernel builds via 
> distcc would cluster all the cc1 jobs on a single core.  At first I 
> thought my pi-series was screwed up, but then I realized I had applied 
> the patch referenced above earlier in my development tree, and 
> removing it allowed pi to work fine.
>
> I found the problem with in once boot cycle with ftrace (thanks 
> Steve!).  Basically newidle balancing was always returning "no 
> imbalance" even though I had 32 cc1 threads on 1 core, and 3 idle 
> cores.  Clearly not correct!  So I think that by adjusting the load 
> up, we throw off the hysteresis built into the load averages and cause 
> the system to incorrectly think it's balanced. TBD.

ok. If you touch that area i'd suggest to also test Mike's 
mysql+sysbench workload (all CPU bound, not IO bound) - it is rather 
sensitive to many aspects of load-balancing. Mysqld also has scalability 
limits due to user-space locking with increasing number of cores, so it 
will show wakeup and buddy balancing artifacts very quickly.

(With postgresql you'll need to go to 32 cores to see it scale badly 
under Linux due to user-space locking.)

	Ingo
