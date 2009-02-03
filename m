Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZBCQef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZBCQef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZBCQe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:34:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:52079 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZBCQe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:34:27 -0500
Date: Tue, 3 Feb 2009 07:19:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Negative values in /proc/latency_stats
Message-ID: <20090203071927.266e83a5@infradead.org>
In-Reply-To: <20090202205545.4e1a32ea.akpm@linux-foundation.org>
References: <4e5e476b0901310542n796dafbem5c656da07a2f8a56@mail.gmail.com>
	<20090202205545.4e1a32ea.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009 20:55:45 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

[ I'm on a plane and writing a patch to fix some of the issues you
mention; I need to be tethered to test before sending]
> 
> - It implements an up-to-1536-loops loop followed by an
>   up-to-384-loops loop on a scheduler hotpath.
> 
>   All under spin_lock_irqsave()!

while you mention the theoretical worst case scenario numbers, the
reality isn't this bleak. it's a linear array that stores a chain, and
yes, the chain is searched lazy. but... the chain is stored "most
unique -> least unique", so typical complexity is a lot lower than what
you mention. And it is also only on when you are actually actively
tracing.

> 
> - store_stacktrace() unnecessarily initalises trace.skip.

fixed in patch

> 
> - account_scheduler_latency() should be an inline:
> 
> 	if (unlikely(latencytop_enabled))
> 		__account_scheduler_latency(...);

borderline but fair; function calls are cheap (or even free in some
cases) but this one is in such a hotpath that this optimization makes
some sense.
> 
> - ditto clear_all_latency_tracing()

this one is only called in slowpaths, so I wouldn't think this makes
sense.
>
> - it's schizophrenic in its placement of spaces around semicolons in
>   `for' statements.

fixed in patch

> 
> - it seems to only be implemented if CONFIG_FAIR_GROUP_SCHED=y.

this is a misunderstanding; sched_fair.c is not related to the fair
GROUP scheduler. It is the normal scheduler policy.

> 
> - lstats_fops should be const.

fixed
 
> And it emits negative numbers too ;)

the problem with this one is that the numbers probably really ARE
negative... (but i need to test some more)
If time goes backwards during idle, the sleep time is considered
negative.... which I can understand will confuse humans.
The alternative possibility would be that we had a several-minutes
latency, which I consider unlikely.... the worst latency I've seen
under normal load is in the 10 second range, not the
hundreds-of-seconds or thousands-of-seconds range. And you'd think
people would notice such latencies and complain.

I'll see if I can just discard the "time goes backwards" cases rather
than propagating the insanity to userspace.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
