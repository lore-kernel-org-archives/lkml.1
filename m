Return-Path: <linux-kernel-owner+w=401wt.eu-S933771AbXDBGRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbXDBGRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933900AbXDBGRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:17:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46214 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933771AbXDBGRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:17:23 -0400
Date: Mon, 2 Apr 2007 08:16:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070402061612.GA7072@elte.hu>
References: <20070402053457.GA9076@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053457.GA9076@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> Hello Everybody,
> 
> This is another attempt towards process-freezer based cpu-hotplug. 
> This patchset covers just about everything that was discussed on the 
> LKML with respect to the freezer-based cpu-hotplug.

wow - you have made really nice progress!

> I believe that the reasons for freezer failing as N increases are :
> - 'make -jN' keeps forking new tasks every now and then, thereby resulting
>   in a never-ending catching up game in the do_while loop inside
>   try_to_freeze_tasks (kernel/power/process.c)

hm, shouldnt the make be frozen immediately?

doesnt the 'please freeze ASAP' flag get propagated to all tasks, 
immediately? After that point any cloning activity should duplicate that 
flag too, resulting in any new child freezing immediately too.

> Instead of waiting for all the tasks to call try_to_freeze in the 
> above mentioned do_while loop, I wonder if we can put some hooks in 
> sched.c so asto not schedule the task marked PF_FREEZING/PF_FROZEN.

we could definitely do that - but i think it should be unnecessary: if 
we mark all tasks as PF_FREEZING atomically, that should result in 
_every_ task immediately dropping dead (once they get back from 
TASK_UNINTERRUPTIBLE). No excuses. If there's some longer delay then 
that can only be explained by some new cloned task/thread slipping 
through the net somehow. (i.e. the PF_FREEZING flag not being duplicated 
across fork?)

i'm wondering about how TASK_UNINTERRUPTIBLE tasks are handled by the 
freezer: are they assumed frozen immediately, or do we wait until they 
notice their PF_FREEZING and go into try_to_freeze()? I'd expect 
TASK_UNINTERRUPTIBLE to be the largest source of latency. (and hence be 
the primary source for freezing 'failures')

	Ingo
