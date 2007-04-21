Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXDUQyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXDUQyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXDUQyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:54:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55636 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbXDUQyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:54:38 -0400
Date: Sat, 21 Apr 2007 18:53:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070421165347.GA26903@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <20070421154614.GA26169@elte.hu> <20070421161818.GC7840@1wt.eu> <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> It would be even better to simply have the rule:
>  - child gets almost no points at startup
>  - but when a parent does a "waitpid()" call and blocks, it will spread 
>    out its points to the childred (the "vfork()" blocking is another case 
>    that is really the same).
> 
> This is a very special kind of "priority inversion" logic: you give 
> higher priority to the things you wait for. Not because of holding any 
> locks, but simply because a blockign waitpid really is a damn big hint 
> that "ok, the child now works for the parent".

yeah. One problem i can see with the implementation of this though is 
that shells typically do nonspecific waits - for example bash does this 
on a simple 'ls' command:

  21310 clone(child_stack=0,  ...) = 21399
  ...
  21399 execve("/bin/ls", 
  ...
  21310 waitpid(-1, <unfinished ...>

the PID is -1 so we dont actually know which task we are waiting for. We 
could use the first entry from the p->children list, but that looks too 
specific of a hack to me. It should catch most of the 
synchronous-helper-task cases though.

	Ingo
