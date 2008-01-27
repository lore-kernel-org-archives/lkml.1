Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbYA0V74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbYA0V74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYA0V7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:59:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49270 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbYA0V7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:59:36 -0500
Date: Sun, 27 Jan 2008 22:59:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during
	suspend/hibernation on x86-64 (bisected)
Message-ID: <20080127215904.GB2686@elte.hu>
References: <200801272229.48955.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801272229.48955.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Hi,
> 
> 2.6.24-git3 adds a 5 - 10 sec delay to the suspend and hibernation 
> code paths (probably related to the disabling of nonboot CPUs), which 
> is !@#$%^&*() annoying.
> 
> It's 100% reproducible on my HP nx6325 and bisection idendified the 
> following commit as the first bad one:
> 
> commit 764a9d6fe4b52995c8aba277e3634385699354f4
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Fri Jan 25 21:08:04 2008 +0100
> 
>     sched: track highest prio task queued

hm, this patch is a NOP, so it's weird that it has an effect.

Do you have serial logging enabled perhaps? If the following WARN_ON() 
triggers:

+               WARN_ON(p->prio < rq->rt.highest_prio);

then perhaps that can cause a 5-10 seconds delay. (that's how much time 
it takes to printk a warning on the slowest serial settings)

but if you use suspend, then any such printks would be preserved in the 
dmesg, right? If the WARN_ON() triggers, and if you remove it, do things 
get faster?

this does have the feel of being scheduling related, but are you 
absolutely sure about the precise identity of the patch? It's not the 
next patch or the preceding patch by any chance? (which would also be 
scheduler patches)

	Ingo
