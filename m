Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbZHaOjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbZHaOjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbZHaOjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:39:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZHaOjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:39:08 -0400
Date: Mon, 31 Aug 2009 16:38:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] clocksource: Resolve cpu hotplug dead lock
	with TSC unstable
Message-ID: <20090831143849.GA10603@elte.hu>
References: <tip-7285dd7fd375763bfb8ab1ac9cf3f1206f503c16@git.kernel.org> <20090831101928.4c00c797@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831101928.4c00c797@skybase>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Fri, 28 Aug 2009 18:34:00 GMT
> tip-bot for Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Commit-ID:  7285dd7fd375763bfb8ab1ac9cf3f1206f503c16
> > Gitweb:     http://git.kernel.org/tip/7285dd7fd375763bfb8ab1ac9cf3f1206f503c16
> > Author:     Thomas Gleixner <tglx@linutronix.de>
> > AuthorDate: Fri, 28 Aug 2009 20:25:24 +0200
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Fri, 28 Aug 2009 20:25:24 +0200
> > 
> > clocksource: Resolve cpu hotplug dead lock with TSC unstable
> > 
> > Martin Schwidefsky analyzed it:
> > To register a clocksource the clocksource_mutex is acquired and if
> > necessary timekeeping_notify is called to install the clocksource as
> > the timekeeper clock. timekeeping_notify uses stop_machine which needs
> > to take cpu_add_remove_lock mutex.
> > Starting a new cpu is done with the cpu_add_remove_lock mutex held.
> > native_cpu_up checks the tsc of the new cpu and if the tsc is no good
> > clocksource_change_rating is called. Which needs the clocksource_mutex
> > and the deadlock is complete.
> > 
> > The solution is to replace the TSC via the clocksource watchdog
> > mechanism. Mark the TSC as unstable and schedule the watchdog work so
> > it gets removed in the watchdog thread context.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > LKML-Reference: <new-submission>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: John Stultz <johnstul@us.ibm.com>
> 
> Ah, very good. I've been going round in circles to find a solution 
> that allows to downgrade the tsc rating when the second cpu is 
> enabled. Could not find a solution. Your approach changes 
> semantics slightly: the tsc clock will continue with its old 
> rating for a while until the watchdog will do the downgrade. If 
> that is acceptable then this is a good solution.

Latest timers/core also passed thousands of iterations of -tip 
testing so far, so that painful series of locking and stability 
troubles has been solved and the bits look good for v2.6.32.

	Ingo
