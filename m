Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbXEMUDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbXEMUDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbXEMUDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:03:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38811 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbXEMUDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:03:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFD] Freezing of kernel threads
Date: Sun, 13 May 2007 22:08:22 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Paul E McKenney <paulmck@us.ibm.com>
References: <200705122017.32792.rjw@sisk.pl> <20070513083357.GA12985@in.ibm.com> <alpine.LFD.0.98.0705130925290.6739@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705130925290.6739@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705132208.23254.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 May 2007 18:33, Linus Torvalds wrote:
> 
> On Sun, 13 May 2007, Gautham R Shenoy wrote:
> > 
> > RFC #1: Use get_hot_cpus()- put_hot_cpus() , which follow the
> > well known refcounting model.
> 
> Yes. And usign the "preempt count" as a refcount is fairly natural, no? 
> We do already depend on that in many code-paths.
> 
> It also has the advantage since it's not a *blocking* lock, it's fairly 
> easy to code around (ie since it nests, it avoids the kinds of nasty 
> deadlocks we had with cpufreq that had totally insane calling semantics 
> and different people all wanted the lock).
> 
> Of course, a real nesting lock could be used to the same effect.
> 
> > RFC #1 and #2 DO work. But, the discussions in the thread
> > http://lkml.org/lkml/2007/1/26/282 gave me the impression
> > that we would be better off without any code audits to
> > make the code paths cpu-hotplug safe. I would leave it for others
> > to shed more light here.
> 
> Well, I hope that _this_ discussion about the freezer has convinced you 
> that there are no more fundamntal problems with #1/#2 than with using the 
> freezer.
> 
> The freezer really needs even *more* code auditing, since it's almost 
> impossible to see which thread depends on some other thread. There's a 
> real reason why most kernel threads disable freezing.

Well, for the current -git we have:

rafael@albercik:~/src/linux-2.6> grep -r -I -l try_to_freeze * \
	| grep -v signal.c | grep -v freezer.h | grep -v process.c | wc
     45      45    1186

Most of these are calls from kernel threads.

At the same time we have:

rafael@albercik:~/src/linux-2.6> grep -r -I -l PF_NOFREEZE * \
	| grep -v sched.h | grep -v process.c | grep -v freezer.h | wc
     23      23     559

I wouldn't call that a majority.  Moreover:

rafael@albercik:~/src/linux-2.6> grep -r -I -l PF_NOFREEZE drivers/* | wc
      9       9     238
rafael@albercik:~/src/linux-2.6> grep -r -I -l try_to_freeze drivers/* | wc
     27      27     790

That, BTW, is why I was (and I still am) afraid to stop freezing kernel threads
just like that.

Of course it's possible to look at these 45 files and see if the kernel threads
in there really need to be freezable and I'm going to do this, but this is a
different thing.

Besides, the problems with interdependencies that we've had recently are
related specifically to the CPU hotplug.  To be precise, they are related to the
CPU hotplug notifiers that try to stop kernel threads which may be frozen.
The other interdependencies don't lead to freezer-related problems.

Greetings,
Rafael
