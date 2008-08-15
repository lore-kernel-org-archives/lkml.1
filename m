Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYHOJIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYHOJIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYHOJIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:08:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59219 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbYHOJIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:08:00 -0400
Date: Fri, 15 Aug 2008 11:07:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Witbrodt <dawitbro@sbcglobal.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- retried 2.6.27-rc3
	patch (and patch method)
Message-ID: <20080815090733.GA22209@elte.hu>
References: <110640.60391.qm@web82108.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <110640.60391.qm@web82108.mail.mud.yahoo.com>
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


* David Witbrodt <dawitbro@sbcglobal.net> wrote:

> I found something very interesting about the commit that first causes 
> the lockup (3def3d6d...), and the very next commit (1e934dda...) -- if 
> I checkout 1e94... and try to revert the changes made in 3def..., the 
> kernel freezes in spite of the revert.
> 
> Because of this, I would conclude that your patch for 2.6.27-rc3 was 
> doomed before you began, and we should look more carefully at the 
> commits from February instead of trying to revert at the 2.6.27 HEAD.

i'm still wondering whether we could try to figure out something about 
the nature of the hard lockup itself.

Have you tried to activate the NMI watchdog? It _usually_ works fine if 
you use a boot option along the lines of:

   "lapic nmi_watchdog=2 idle=poll"

The best test would be to first boot the broken kernel with also 
hpet=disable and the above options, and check in /proc/interrupts 
whether the NMI count is increasing. If the NMI watchdog is working, you 
should see a steady trickle of NMI irqs:

 rhea:~> while sleep 1; do grep NMI /proc/interrupts ; done
 NMI:       4395   Non-maskable interrupts
 NMI:       4396   Non-maskable interrupts
 NMI:       4397   Non-maskable interrupts
 NMI:       4398   Non-maskable interrupts
 ^C

if it does not work, you'll see:

 pluto:~> while sleep 1; do grep NMI /proc/interrupts ; done
 NMI:          0   Non-maskable interrupts
 NMI:          0   Non-maskable interrupts
 NMI:          0   Non-maskable interrupts
 NMI:          0   Non-maskable interrupts
 ^C

NOTE: the NMI watchdog disables high-res timers so it might change your 
test enough to make the lockup go away. Hopefully it wont :-)

So, in the ideal situation, your test of the NMI watchdog will show a 
steady trickle of watchdog NMI. Then i'd suggest to remove the 
hpet=disable, to provoke the lockup. Hopefully it occurs, _and_ after 
the hard lockup has happened, you should see a nice stack backtrace 
printed out by the NMI watchdog. That gives us the exact location of 
lockup.

One theory is that the changed resource allocations are buggy in certain 
circumstances and cause us to stomp over key kernel data structures. We 
could for example overwrite a networking lock - that's why you lock up 
in the networking code. hpet=disable deactivates those resource 
allocations and works around the symptoms of the bug.

	Ingo
