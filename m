Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXDOSGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXDOSGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 14:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXDOSGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 14:06:36 -0400
Received: from 1wt.eu ([62.212.114.60]:1940 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbXDOSGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 14:06:35 -0400
Date: Sun, 15 Apr 2007 20:06:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415180604.GA550@1wt.eu>
References: <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070414132732.GA22103@1wt.eu> <20070414161927.GD3099@elte.hu> <m1abxanahn.fsf@ebiederm.dsl.xmission.com> <20070414172920.GA2433@1wt.eu> <m1647yn956.fsf@ebiederm.dsl.xmission.com> <20070414175433.GA17527@elte.hu> <20070414181854.GA5826@1wt.eu> <20070415175555.GA28524@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415175555.GA28524@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sun, Apr 15, 2007 at 07:55:55PM +0200, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > Well, since I merged the fair-fork patch, I cannot reproduce (in fact, 
> > bash forks 1000 processes, then progressively execs scheddos, but it 
> > takes some time). So I'm rebuilding right now. But I think that Linus 
> > has an interesting clue about GPM and notification before switching 
> > the terminal. I think it was enabled in console mode. I don't know how 
> > that translates to frozen xterms, but let's attack the problems one at 
> > a time.
> 
> to debug this, could you try to apply this add-on as well:
> 
>   http://redhat.com/~mingo/cfs-scheduler/sched-fair-print.patch
> 
> with this patch applied you should have a /proc/sched_debug file that 
> prints all runnable tasks and other interesting info from the runqueue. 

I don't know if you have seen my mail from yesterday evening (here). I
found that changing keventd prio fixed the problem. You may be interested
in the description. I sent it at 21:01 (+200).

> [ i've refreshed all the patches on the CFS webpage, so if this doesnt 
>   apply cleanly to your current tree then you'll probably have to 
>   refresh one of the patches.]

Fine, I'll have a look. I already had to rediff the sched-fair-fork
patch last time.

> The output should look like this:
> 
>  Sched Debug Version: v0.01
>  now at 226761724575 nsecs
> 
>  cpu: 0
>    .nr_running            : 3
>    .raw_weighted_load     : 384
>    .nr_switches           : 13666
>    .nr_uninterruptible    : 0
>    .next_balance          : 4294947416
>    .curr->pid             : 2179
>    .rq_clock              : 241337421233
>    .fair_clock            : 7503791206
>    .wait_runtime          : 2269918379
> 
>  runnable tasks:
>             task | PID | tree-key |   -delta |  waiting | switches
>  -----------------------------------------------------------------
>  +            cat  2179 7501930066   -1861140    1861140         2
>       loop_silent  2149 7503010354    -780852          0       911
>       loop_silent  2148 7503510048    -281158     280753       918

Nice.

> now for your workload the list should be considerably larger. If there's 
> starvation going on then the 'switches' field (number of context 
> switches) of one of the tasks would never increase while you have this 
> 'cannot switch consoles' problem.
> 
> maybe you'll have to unapply the fair-fork patch to make it trigger 
> again. (fair-fork does not fix anything, so it probably just hides a 
> real bug.)
> 
> (i'm meanwhile busy running your scheddos utilities to reproduce it 
> locally as well :)

I discovered I had the frame-buffer enabled (I did not notice it first
because I do not have the logo and the resolution is the same as text).
It's matroxfb with a G400, if that can help. It may be possible that
it needs some CPU that it cannot get to clear the display before
switching, I don't know.

However I won't try this right now, I'm deep in userland at the moment.

Regards,
Willy

