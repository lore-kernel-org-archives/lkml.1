Return-Path: <linux-kernel-owner+w=401wt.eu-S1761103AbYCGKvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103AbYCGKvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbYCGKvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:51:43 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:50668 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbYCGKvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:51:41 -0500
Date: Fri, 7 Mar 2008 16:21:38 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Yi Yang <yi.y.yang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
Message-ID: <20080307105138.GA10576@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com> <20080303153154.GA11288@in.ibm.com> <1204555505.3842.4.camel@yangyi-dev.bj.intel.com> <20080304052613.GA28632@in.ibm.com> <20080304150107.GA564@tv-sign.ru> <20080306134400.GA1915@in.ibm.com> <20080307025451.GA201@tv-sign.ru> <20080307091049.GA8827@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307091049.GA8827@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 02:40:49PM +0530, Gautham R Shenoy wrote:
> 
> > 
> > Just to be sure, there were no "bad ->cpu..." messages, yes?
> 
> Hopefully should be able to catch them now. If yes, it's a problem in
> the way we do migration after cpu-hotplug as Yi suggested in an earlier
> mail.
> 
> http://lkml.org/lkml/2008/3/6/437
> 
> This mail from akpm says the same thing.

Yup! There are a quite a few "bad->cpu" messages.
All of them only for watchdog/1.

What surprises me is the fact that the first of  task-hung messages come
after 136 successful cpu-hotplug attempts.

To answer Andrew's question, migration_call() *should* ideally be the
first notifier called, because it's registered with the priority 10.

Unless there's some change that has recently gone in the
notifier_call_chain subsystem that doesn't honour the registration priority
anymore, migration_call() will be called first,
which means the task affinity for watchdog thread is broken and hence
we shouldn't see the message below.

I'll probe to see if there's a change in the call order that's causing
this hang.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
INFO: task watchdog/1:10958 can't get CPU for more than 120 seconds.
bad ->cpu
       f524ffac 00000046 c011befc f5276aa0 f5276bd8 c443db80 00000001 f6130b80 
       f524ff94 00000246 c07130f4 03d28000 00000000 f524ff9c c01438ad f524ffac 
       00000001 c0143a1f 00000000 f524ffd0 c0143a66 00000001 c0119fea 00000000 
Call Trace:
 [<c011befc>] ? cpu_clock+0x4e/0x59
 [<c01438ad>] ? get_timestamp+0x8/0x11
 [<c0143a1f>] ? watchdog+0x0/0x239
 [<c0143a66>] watchdog+0x47/0x239
 [<c0119fea>] ? complete+0x34/0x3e
 [<c0143a1f>] ? watchdog+0x0/0x239
 [<c012f797>] kthread+0x3b/0x64
 [<c012f75c>] ? kthread+0x0/0x64
 [<c01056eb>] kernel_thread_helper+0x7/0x10
 =======================
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



>
> >
> > Oleg.
> 
> -- 
> Thanks and Regards
> gautham

-- 
Thanks and Regards
gautham
