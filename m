Return-Path: <linux-kernel-owner+w=401wt.eu-S934700AbXEMQfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934700AbXEMQfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759095AbXEMQfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:35:10 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758519AbXEMQfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:35:08 -0400
Date: Sun, 13 May 2007 09:33:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Gautham R Shenoy <ego@in.ibm.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFD] Freezing of kernel threads
In-Reply-To: <20070513083357.GA12985@in.ibm.com>
Message-ID: <alpine.LFD.0.98.0705130925290.6739@woody.linux-foundation.org>
References: <200705122017.32792.rjw@sisk.pl> <20070512193609.GA31426@in.ibm.com>
 <alpine.LFD.0.98.0705121241300.3986@woody.linux-foundation.org>
 <20070513083357.GA12985@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 May 2007, Gautham R Shenoy wrote:
> 
> RFC #1: Use get_hot_cpus()- put_hot_cpus() , which follow the
> well known refcounting model.

Yes. And usign the "preempt count" as a refcount is fairly natural, no? 
We do already depend on that in many code-paths.

It also has the advantage since it's not a *blocking* lock, it's fairly 
easy to code around (ie since it nests, it avoids the kinds of nasty 
deadlocks we had with cpufreq that had totally insane calling semantics 
and different people all wanted the lock).

Of course, a real nesting lock could be used to the same effect.

> RFC #1 and #2 DO work. But, the discussions in the thread
> http://lkml.org/lkml/2007/1/26/282 gave me the impression
> that we would be better off without any code audits to
> make the code paths cpu-hotplug safe. I would leave it for others
> to shed more light here.

Well, I hope that _this_ discussion about the freezer has convinced you 
that there are no more fundamntal problems with #1/#2 than with using the 
freezer.

The freezer really needs even *more* code auditing, since it's almost 
impossible to see which thread depends on some other thread. There's a 
real reason why most kernel threads disable freezing.

At least with locking, the code-paths you require to audit are all 
actually relevant to cpu hotplug, and you can easily add dynamic 
_automated_ tests like "if you use online_cpu_map, you'd better hold the 
preempt lock".

For example, since all users of cpu_online_map should be pure *readers* 
(apart from a couple of cases that actually bring up a CPU), you can do 
things like

	#define cpu_online_map check_cpu_online_map()

	static inline cpumask_t check_cpu_online_map(void)
	{
		WARN_ON(!preempt_safe()); /* or whatever lock we decide on */
		return __real_cpu_online_map;
	}

and it will nicely catch things like that.

		Linus
