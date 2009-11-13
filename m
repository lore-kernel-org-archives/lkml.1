Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZKMWED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZKMWED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZKMWD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:03:58 -0500
Received: from www.tglx.de ([62.245.132.106]:59340 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbZKMWD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:03:57 -0500
Date: Fri, 13 Nov 2009 23:03:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jean Delvare <khali@linux-fr.org>
cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
In-Reply-To: <20091112211255.09cd884a@hyperion.delvare>
Message-ID: <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com> <20091107210147.3e754278@hyperion.delvare> <4AF7148C.9090706@thebigcorporation.com> <20091112211255.09cd884a@hyperion.delvare>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean,

On Thu, 12 Nov 2009, Jean Delvare wrote:
> As far as I can see, yield() doesn't have clear semantics attached.
> It's more of a utility function everyone could use as they see fit. In
> that respect, I understand your concerns about the coders' expectations
> and how they could be dismissed by RT. OTOH, I don't think that asking
> all developers to get rid of yield() because it _may not be_
> RT-compliant will lead you anywhere.
>
> In the 3 occurrences I've looked at, yield() is used as a way to
> busy-wait in a multitask-friendly way. What other use cases do you
> expect? I've never seen yield() used as a way to avoid deadlocks, which
> seems to be what you fear. I guess it could statistically be used that
> way, but obviously I wouldn't recommend it. Anything else?
> 
> I would recommend that you audit the various use cases of yield(), and
> then offer replacements for the cases which are RT-unfriendly, leaving
> the rest alone and possibly clarifying the intended use of yield() to
> avoid future problems.
> 
> In the i2c-algo-bit case, which started this thread, I can't really see
> what "something more explicit of an implementation" would be. yield()
> is as optimum as you can get, only delaying the processing if other
> tasks want to run. A sleep or a delay would delay the processing
> unconditionally, for an arbitrary amount of time, with no good reason.
> Removing yield() would increase the latency. This particular feature of
> i2c-algo-bit isn't necessarily terribly useful, but the code does the
> right thing, regardless of RT, so I just can't see any reason to change
> it.

The problem with yield() is not RT specific. Let's just look at the
yield semantics in mainline:

>From kernel/sched_fair.c

     unsigned int __read_mostly sysctl_sched_compat_yield;
     ...
     static void yield_task_fair(struct rq *rq)
     {
	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
     	   ...
	   return;
	}
     }

So even in mainline yield() is doing nothing vs. latencies and is not
multitask friendly by default. It's just not complaining about it.

yield itself is a design failure in almost all of its aspects. It's
the poor mans replacement for proper async notification.

Q: Why put people yield() into their code ?
A: Because:
   - it is less nasty than busy waiting for a long time
   - it works better
   - it solves the hang
   - it happened to be in the driver they copied
   - ....

At least 90% of the in kernel users of yield() are either a bug or a
design problem or lack of understanding or all of those.

I can see the idea of using yield() to let other tasks making progress
in situations where the hardware is a design failure as well,
e.g. bitbang devices. But if we have to deal with hardware which is
crap by design yield() is the worst of all answers simply due to its
horrible semantics.

Let's look at the code in question:

	for (i = 0; i <= retries; i++) {
		ret = i2c_outb(i2c_adap, addr);
		if (ret == 1 || i == retries)
			break;
		bit_dbg(3, &i2c_adap->dev, "emitting stop condition\n");
		i2c_stop(adap);
		udelay(adap->udelay);
		yield();

We are in the error path as we failed to communicate with the device
in the first place. So there a two scenarios:

   1) the device is essential for the boot process:

        you have hit a problem anyway

   2) this is just some random device probing:

        who cares ?

So in both cases the following change is a noop vs. latency and
whatever your concerns are:

-		udelay(adap->udelay);
-		yield();
+		msleep(1);

Thanks,

	tglx
