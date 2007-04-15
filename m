Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbXDOR4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbXDOR4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 13:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXDOR4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 13:56:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39952 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbXDOR4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 13:56:21 -0400
Date: Sun, 15 Apr 2007 19:55:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415175555.GA28524@elte.hu>
References: <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070414132732.GA22103@1wt.eu> <20070414161927.GD3099@elte.hu> <m1abxanahn.fsf@ebiederm.dsl.xmission.com> <20070414172920.GA2433@1wt.eu> <m1647yn956.fsf@ebiederm.dsl.xmission.com> <20070414175433.GA17527@elte.hu> <20070414181854.GA5826@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414181854.GA5826@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> Well, since I merged the fair-fork patch, I cannot reproduce (in fact, 
> bash forks 1000 processes, then progressively execs scheddos, but it 
> takes some time). So I'm rebuilding right now. But I think that Linus 
> has an interesting clue about GPM and notification before switching 
> the terminal. I think it was enabled in console mode. I don't know how 
> that translates to frozen xterms, but let's attack the problems one at 
> a time.

to debug this, could you try to apply this add-on as well:

  http://redhat.com/~mingo/cfs-scheduler/sched-fair-print.patch

with this patch applied you should have a /proc/sched_debug file that 
prints all runnable tasks and other interesting info from the runqueue. 

[ i've refreshed all the patches on the CFS webpage, so if this doesnt 
  apply cleanly to your current tree then you'll probably have to 
  refresh one of the patches.]

The output should look like this:

 Sched Debug Version: v0.01
 now at 226761724575 nsecs

 cpu: 0
   .nr_running            : 3
   .raw_weighted_load     : 384
   .nr_switches           : 13666
   .nr_uninterruptible    : 0
   .next_balance          : 4294947416
   .curr->pid             : 2179
   .rq_clock              : 241337421233
   .fair_clock            : 7503791206
   .wait_runtime          : 2269918379

 runnable tasks:
            task | PID | tree-key |   -delta |  waiting | switches
 -----------------------------------------------------------------
 +            cat  2179 7501930066   -1861140    1861140         2
      loop_silent  2149 7503010354    -780852          0       911
      loop_silent  2148 7503510048    -281158     280753       918

now for your workload the list should be considerably larger. If there's 
starvation going on then the 'switches' field (number of context 
switches) of one of the tasks would never increase while you have this 
'cannot switch consoles' problem.

maybe you'll have to unapply the fair-fork patch to make it trigger 
again. (fair-fork does not fix anything, so it probably just hides a 
real bug.)

(i'm meanwhile busy running your scheddos utilities to reproduce it 
locally as well :)

	Ingo
