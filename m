Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXFVKa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXFVKa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 06:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXFVKaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 06:30:19 -0400
Received: from mx2.go2.pl ([193.17.41.42]:58460 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbXFVKaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 06:30:18 -0400
Date: Fri, 22 Jun 2007 12:38:17 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Miklos Szeredi <miklos@szeredi.hu>,
       cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070622103817.GC1778@ff.dom.local>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073800.GA1685@ff.dom.local> <alpine.LFD.0.98.0706210851570.3593@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706210851570.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 09:01:28AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 21 Jun 2007, Jarek Poplawski wrote:
...
> So I don't see how you could possibly having two different CPU's getting 
> into some lock-step in that loop: changing "task_rq()" is a really quite 
> heavy operation (it's about migrating between CPU's), and generally 
> happens at a fairly low frequency (ie "a couple of times a second" kind of 
> thing, not "tight CPU loop").

Yes, I've agreed with Ingo it was only one of my illusions...

> But bugs happen..
> 
> > Another possible problem could be a result of some wrong optimization
> > or wrong propagation of change of this task_rq(p) value.
> 
> I agree, but that kind of bug would likely not cause temporary hangs, but 
> actual "the machine is dead" operations. If you get the totally *wrong* 
> value due to some systematic bug, you'd be waiting forever for it to 
> match, not get into a loop for a half second and then it clearing up..
> 
> But I don't think we can throw the "it's another bug" theory _entirely_ 
> out the window.

Alas, I'm the last here who should talk with you or Ingo about
hardware, but my point is that until it's not 100% proven this
is spinlocks vs. cpu case any nearby possibilities should be
considered. One of them is this loop, which can ... loop. Of
course we can't see any reason for this, but if something is
theoretically allowed it can happen. Here it's enough the
task_rq(p) is for some very unprobable reason (maybe buggy
hardware, code or compiling) cached or read too late, and
maybe it's only on this one only notebook in the world? If
you're sure this is not the case, let's forget about this.
Of course, I don't mean it's a direct optimization. I think
about something that could be triggered by something like this
tested smp_mb() in entirely another place. IMHO, it would be
very interesting to assure if this barrier fixed the spinlock
or maybe some variable.

There is also another interesting question: if it was only about
spinlocks (which may be) why on those watchdog traces there
are mainly two "fighters": wait_task_inactive() and
try_to_wake_up(). It seems there should be seen more clients
of task_rq_lock(). So, my another unlikely idea is: maybe
for some other strange, unprobable but only theoretically
possibility there could be something wrong around this
yield() in wait_task_inactive(). The comment above this
function reads about the task that *will* unschedule.
So, maybe it would be not nice if e.g. during this yield()
something wakes it up?

...
> But it only happens with badly coded software: the rule simply is that you 
> MUST NOT release and immediately re-acquire the same spinlock on the same 
> core, because as far as other cores are concerned, that's basically the 
> same as never releasing it in the first place.

I totally agree! Let's only get certainty there is nothing
more here. BTW, is there any reason not to add some test with
a warning under spinlock debugging against such badly behaving
places?

Regards,
Jarek P.
