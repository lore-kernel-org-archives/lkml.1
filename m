Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbXEWGbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbXEWGbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756285AbXEWGbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:31:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50590 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120AbXEWGbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:31:09 -0400
Date: Wed, 23 May 2007 08:30:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070523063052.GB26814@elte.hu>
References: <20070517174533.GA538@elte.hu> <200705221147.56571.kernel@prachanda.hub> <20070522062233.GA20002@elte.hu> <200705231110.44526.kernel@prachanda.hub>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705231110.44526.kernel@prachanda.hub>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,INFO_TLD autolearn=no SpamAssassin version=3.1.7
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Anant Nitya <kernel@prachanda.info> wrote:

> > could you also apply the fix for the softirq problem below, to make 
> > sure it does not interact?

> Above patch does solve __ soft_irq_pending __ problem. I am running 
> this patch with kernel 2.6.21.1 since last day doing all kinda things 
> but haven't encountered any __ NOHZ: local_softirq_pending __. But 
> network lag that I am seeing since 2.6.22-rc1 is still there even with 
> this patch applied. If you need any more information please do ask. 
> Meanwhile I will do gitbisect as suggested by linus to find out the 
> specific commit that introduced this problem and will inform once I 
> find it. Its good to see system running without any __ 
> local_softirq_problem __ :)

thanks.

if you feel inclined to try the git-bisection then by all means please 
do it (it will certainly be helpful and educative), but it's optional: i 
dont think you should 'need' to go through extra debugging chores, my 
analysis based on the excellent trace you provided still holds and 
whoever modified htb_dequeue()'s logic recently ought to be able to 
figure that out (or send you a debug patch to further narrow the problem 
down).

The trace shows a _clearly_ anomalous loop: for example there's 56396 
(!) calls to rb_first() in htb_dequeue() [without the kernel ever 
exiting that function]:

  earth4:~/s> grep rb_first trace-to-ingo.txt  | wc -l
  56396

and the set of rules you are using are alot simpler and the networking 
load you are using is not large by any means. Here's the trace analysis 
below again.

	Ingo

----------------------->

> http://cybertek.info/taitai/trace-to-ingo.txt.bz2

This trace indeed includes the smoking gun, htb_dequeue() and 
__qdisc_run():

   privoxy-12926 1.Ns1 1597us : rb_first (htb_dequeue)

this goes on, non-preemptible, for 160 milliseconds (!):

 privoxy-12926 1.Ns1 161568us : rb_first (htb_dequeue)
 privoxy-12926 1.Ns1 161568us : qdisc_watchdog_schedule (htb_dequeue)

and finally manages to escape the loop:

 privoxy-12926 1.Ns1 161597us : rb_first (htb_dequeue)
 privoxy-12926 1.Ns1 161597us : rb_first (htb_dequeue)
 privoxy-12926 1.Ns1 161599us : htb_safe_rb_erase (htb_dequeue)
 privoxy-12926 1.Ns1 161599us : rb_erase (htb_safe_rb_erase)
 privoxy-12926 1.Ns1 161600us : htb_change_class_mode (htb_dequeue)
 privoxy-12926 1.Ns1 161601us : htb_activate_prios (htb_change_class_mode)

and the system recovers.

