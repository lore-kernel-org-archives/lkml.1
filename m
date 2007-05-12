Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbXELT6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbXELT6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbXELT6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:58:33 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbXELT6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:58:32 -0400
Date: Sat, 12 May 2007 12:57:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Gautham R Shenoy <ego@in.ibm.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] Freezing of kernel threads
In-Reply-To: <20070512193609.GA31426@in.ibm.com>
Message-ID: <alpine.LFD.0.98.0705121241300.3986@woody.linux-foundation.org>
References: <200705122017.32792.rjw@sisk.pl>
 <20070512193609.GA31426@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 May 2007, Gautham R Shenoy wrote:
> 
> With the "freeze-limited-kernel-threads" scheme, we would still need
> to perform this audit, since we now have to freeze only those kernel
> threads which *may* end up calling foo().

What the *heck* is wrong with just adding proper locking or other 
synchronization?

Why the hell do people think that they don't need locking for things?

In other words, you're just adding crap to make up for other crap. That's 
*not* how we do kernel develpment. I would seriously suggest people like 
that approach MS for a position on _their_ kernel team.

The fact is, if you want to avoid problems, you do so by having clear and 
clean approaches. THAT is how you avoid bugs. Not by adding crap.

I've several times suggested that if you actually want to stop the 
machine, you can do so at the scheduler level.

So stop talking about freezing when you're talkign abotu CPU hotplug. The 
two have _nothing_ to do with each other, and if there is something this 
whole discussion has absolutely convinced me about, it's that they will 
never have anything to do with each other.

If you worry about people doing 

	for_each_online_cpu()

in the presense of hotplug, here's a couple of simple solutions:

 - Just teach for_each_online_cpu() about locking. It's not a new concept. 
   We have it all over the kernel. 

   Maybe the macro itself can take whatever locks it needs, and maybe it's 
   as simple as a rule saying that: "you must hold spinlock XYZ when you 
   do that". But it has _nothing_ to do with freezing all threads.

 - make the rule be that you cannot sleep in the above macro, and make the 
   rule be that CPU hotplug uses the same mechanisms that module unload 
   already does!

In other words, we already have *better* mechanisms for cpu hotplug than 
the freezer. We have mechanisms that there is absolutely zero controversy 
about.

IOW, have you actually looked at "stop_machine_run()", which people use 
much more than the freezer, and which has never really caused any issues, 
and didn't result in us adding *crap* to every single kernel thread?

Really. The arguments for the freezer are CRAP. Why cannot people just 
admit it? We have *better* things available, that don't *need* any of this 
crap. The "stop_machine()" stuff literally ends up just running a 
high-priority thread on each CPU, and doesn't need any special support 
anywhere.

AND IT JUST WORKS. 

(Btw, I'm pretty sure it could be used for hibernation too: just stop the 
IO at a higher level first, sync, then stop_machine_run() etc. But I don't 
care. What I care about is that the freezer() insanity doesn't _spread_).

		Linus
