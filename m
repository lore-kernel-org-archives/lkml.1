Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbXDBL2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbXDBL2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbXDBL2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:28:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbXDBL23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:28:29 -0400
Date: Mon, 2 Apr 2007 13:27:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070402112745.GB27891@elte.hu>
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu> <20070402111900.GA30946@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402111900.GA30946@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> From what I can make out, we fail to freeze if we have some task in 
> the TASK_UNINTERRUPTIBLE state for more than the timeout period.

> Question is can we have some task in TASK_UNINTERRUPTIBLE state for 
> such a long duration (20sec) ??

yes, easily so - just have a really long disk queue. Or really heavy 
mutex contention.

i really think we should add a freezing hook to schedule too (no need to 
change anything else - just add a PF_FREEZE check into the schedule() 
function) - and add a wakeup method that moves TASK_UNINTERRUPTIBLE 
tasks to the runqueue but does not touch their task->state.

( the copy_process() handling is still needed, so that no new tasks
  without PF_FREEZE get created that could slip out of control. )

Such a wakeup will cause them to execute again but without disturbing 
their task->state value, at which point a second hook in schedule() 
could catch and freeze them. (and can restart the sleep afterwards, if 
the task is still TASK_UNINTERRUPTIBLE)

i.e. two easy hooks in schedule() plus a try_to_wake_up() variant that 
does not touch p->state. In fact the second hook could be used instead 
of the first one so one might be enough. (I can code up the scheduler 
bits for you if that would be helpful.)

	Ingo
