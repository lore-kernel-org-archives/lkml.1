Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYF2G4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYF2G4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 02:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYF2G4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 02:56:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58584 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbYF2G4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 02:56:13 -0400
Date: Sun, 29 Jun 2008 08:55:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] CFS vs cpu hotplug
Message-ID: <20080629065556.GA20398@elte.hu>
References: <20080619161949.GA11062@osiris.ibm.com> <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com> <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> Hello,
> 
> it seems to be related to migrate_dead_tasks().
> 
> Firstly I added traces to see all tasks being migrated with 
> migrate_live_tasks() and migrate_dead_tasks(). On my setup the problem 
> pops up (the one with "se == NULL" in the loop of 
> pick_next_task_fair()) shortly after the traces indicate that some has 
> been migrated with migrate_dead_tasks()). btw., I can reproduce it 
> much faster now with just a plain cpu down/up loop.
> 
> [disclaimer] Well, unless I'm really missing something important in 
> this late hour [/desclaimer] pick_next_task() is not something 
> appropriate for migrate_dead_tasks() :-)
> 
> the following change seems to eliminate the problem on my setup 
> (although, I kept it running only for a few minutes to get a few 
> messages indicating migrate_dead_tasks() does move tasks and the 
> system is still ok)
> 
> [ quick hack ]
> 
> @@ -5887,6 +5907,7 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
>                 next = pick_next_task(rq, rq->curr);
>                 if (!next)
>                         break;
> +               next->sched_class->put_prev_task(rq, next);
>                 migrate_dead(dead_cpu, next);
> 

thanks Dmitry - i've applied this chunk to tip/master and 
tip/sched/urgent, for more testing.

if this turns out to be the final and full fix today, would you mind to 
submit the rest of your checks as well? It seems like a rather sensible 
set of sanity checks. Put under CONFIG_SCHED_DEBUG or a new 
(default-off) config option.

it would also be _very_ nice to have a built-in cpu hotplug tester in 
the kernel, a'ka CONFIG_RCU_TORTURE_TEST=y. There's already sample code 
in kernel/tracing/ of how to initiate hotplug events from within the 
kernel.

	Ingo
