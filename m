Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYFSJaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYFSJaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYFSJaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:30:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51464 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYFSJaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:30:06 -0400
Date: Thu, 19 Jun 2008 11:29:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, josh@freedesktop.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH] Make rcutorture more vicious: reinstate boot-time
	testing
Message-ID: <20080619092914.GB15228@elte.hu>
References: <20080618122144.GA27143@linux.vnet.ibm.com> <20080618162649.GA18326@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618162649.GA18326@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello again!
> 
> This patch re-institutes the ability to build rcutorture directly into 
> the Linux kernel.  The reason that this capability was removed was 
> that this could result in your kernel being pretty much useless, as 
> rcutorture would be running starting from early boot.  This problem 
> has been avoided by (1) making rcutorture run only three seconds of 
> every six by default, (2) adding a CONFIG_RCU_TORTURE_TEST_RUNNABLE 
> that permits rcutorture to be quiesced at boot time, and (3) adding a 
> sysctl in /proc named /proc/sys/kernel/rcutorture_runnable that 
> permits rcutorture to be quiesced and unquiesced when built into the 
> kernel.
> 
> Please note that this /proc file is -not- available when rcutorture is 
> built as a module.  Please also note that to get the earlier 
> take-no-prisoners behavior, you must use the boot command line to set 
> rcutorture's "stutter" parameter to zero.
> 
> The rcutorture quiescing mechanism is currently quite crude: loops in 
> each rcutorture process that poll a global variable once per tick. 
> Suggestions for improvement are welcome.  The default action will be 
> to reduce the polling rate to a few times per second.

applied to tip/core/rcu - thanks Paul!

FYI, yesterday's rcutorture-stutter feature survived a few hundred 
random bootup tests in -tip testing already.

a possible area for enhancement would be the following code:

static void
rcu_stutter_wait(void)
{
        while (stutter_pause_test || !rcutorture_runnable)
                schedule_timeout_interruptible(1);
}

will cause HZ number of IRQs on nohz systems, even if rcutorture is 
disabled. While it's fine to poll if rcutorture_runnable==1, the sleep 
should be at least 1 second when !rcutorture_runnable.

[ Or it might even make sense to completely stop the threads from a 
  sysctl handler - to make it event-driven and to cause no extra IRQs at 
  all when rcutorture is disabled via /proc. ]

	Ingo
