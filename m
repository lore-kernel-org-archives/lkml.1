Return-Path: <linux-kernel-owner+w=401wt.eu-S1030202AbXDMWah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbXDMWah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030863AbXDMWah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:30:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40947 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030202AbXDMWag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:30:36 -0400
Date: Sat, 14 Apr 2007 00:30:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413223017.GA8961@elte.hu>
References: <20070413202100.GA9957@elte.hu> <1176502546.3129.79.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176502546.3129.79.camel@imap.mvista.com>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> I'm not in love with the current or other schedulers, so I'm 
> indifferent to this change. However, I was reviewing your release 
> notes and the patch and found myself wonder what the logarithmic 
> complexity of this new scheduler is .. I assumed it would also be 
> constant time , but the __enqueue_task_fair doesn't appear to be 
> constant time (rbtree insert complexity).. [...]

i've been worried about that myself and i've done extensive measurements 
before choosing this implementation. The rbtree turned out to be a quite 
compact data structure: we get it quite cheaply as part of the task 
structure cachemisses - which have to be touched anyway. For 1000 tasks 
it's a loop of ~10 - that's still very fast and bound in practice.

here's a test i did under CFS. Lets take some ridiculous load: 1000 
infinite loop tasks running at SCHED_BATCH on a single CPU (all inserted 
into the same rbtree), and lets run lat_ctx:

  neptune:~/l> uptime
  22:51:23 up 8 min,  2 users,  load average: 713.06, 254.64, 91.51

  neptune:~/l> ./lat_ctx -s 0 2
  "size=0k ovr=1.61
  2 1.41

lets stop the 1000 tasks and only have ~2 tasks in the runqueue:

  neptune:~/l> ./lat_ctx -s 0 2

  "size=0k ovr=1.70
  2 1.16

so the overhead is 0.25 usecs. Considering the load (1000 tasks trash 
the cache like crazy already), this is more than acceptable.

	Ingo
