Return-Path: <linux-kernel-owner+w=401wt.eu-S2992818AbXDRVsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992818AbXDRVsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992796AbXDRVsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:48:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46761 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992818AbXDRVsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:48:42 -0400
Date: Wed, 18 Apr 2007 23:48:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418214816.GA10902@elte.hu>
References: <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org> <20070418174945.GA7930@elte.hu> <20070418175936.GA11980@elte.hu> <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org> <Pine.LNX.4.64.0704181304250.25880@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704181304250.25880@alien.or.mcafeemobile.com>
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


* Davide Libenzi <davidel@xmailserver.org> wrote:

> I think Ingo's idea of a new sched_group to contain the generic 
> parameters needed for the "key" calculation, works better than adding 
> more fields to existing strctures (that would, of course, host 
> pointers to it). Otherwise I can already the the struct_signal being 
> the target for other unrelated fields :)

yeah. Another detail is that for global containers like uids, the 
statistics will have to be percpu_alloc()-ed, both for correctness 
(runqueues are per CPU) and for performance.

That's one reason why i dont think it's necessarily a good idea to 
group-schedule threads, we dont really want to do a per thread group 
percpu_alloc().

In fact for threads the _reverse_ problem exists, threaded apps tend to 
_strive_ for more performance - hence their desperation of using the 
threaded programming model to begin with ;) (just think of media 
playback apps which are typically multithreaded)

I dont think threads are all that different. Also, the 
resource-conserving act of using CLONE_VM to share the VM (and to use a 
different programming environment like Java) should not be 'punished' by 
forcing the thread group to be accounted as a single, shared entity 
against other 'fat' tasks.

so my current impression is that we want per UID accounting to solve the 
X problem, the kernel threads problem and the many-users problem, but 
i'd not want to do it for threads just yet because for them there's not 
really any apparent problem to be solved.

	Ingo
