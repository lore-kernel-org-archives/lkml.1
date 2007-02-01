Return-Path: <linux-kernel-owner+w=401wt.eu-S1161092AbXBACMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161092AbXBACMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 21:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161249AbXBACMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 21:12:23 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:54660 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161092AbXBACMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 21:12:22 -0500
Subject: Re: [RFC PATCH -rt 2/2] RCU priority boosting additions to
	rcutorture
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, josh@freedesktop.org,
       billh@gnuppy.monkey.org, nielsen.esben@googlemail.com, corbet@lwn.net
In-Reply-To: <20070201012653.GB22922@linux.vnet.ibm.com>
References: <20070201012136.GA21770@linux.vnet.ibm.com>
	 <20070201012653.GB22922@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 13:12:16 +1100
Message-Id: <1170295936.32500.1.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul.

On Wed, 2007-01-31 at 17:26 -0800, Paul E. McKenney wrote:
> This patch adds an optional preemption kernel thread to the rcutorture
> tests.  This thread sets itself to a low RT priority and chews up CPU
> in 10-second bursts, verifying that grace periods progress during this
> 10-second interval.  Passes RCU torture testing on a 4-CPU (a pair of
> 2-CPU dies) 64-bit Xeon system.

[...]

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> +static int rcu_torture_preempt(void *arg)
> +{
> +	int completedstart;
> +	int err;
> +	time_t gcstart;
> +	struct sched_param sp;
> +
> +	sp.sched_priority = MAX_RT_PRIO - 1;
> +	err = sched_setscheduler(current, SCHED_RR, &sp);
> +	if (err != 0)
> +		printk(KERN_ALERT "rcu_torture_preempt() priority err: %d\n",
> +		       err);
> +	current->flags |= PF_NOFREEZE;
> +
> +	do {
> +		completedstart = rcu_torture_completed();
> +		gcstart = xtime.tv_sec;
> +		while ((xtime.tv_sec - gcstart < 10) &&
> +		       (rcu_torture_completed() == completedstart))
> +			cond_resched();
> +		if (rcu_torture_completed() == completedstart)
> +			rcu_torture_preempt_errors++;
> +		schedule_timeout_interruptible(HZ);
> +	} while (!kthread_should_stop());
> +	return 0;
> +}

Does it need to be NOFREEZE? I would think that it should be frozen
during a suspend/hibernate.

Regards,

Nigel

