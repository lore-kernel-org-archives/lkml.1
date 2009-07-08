Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbZGHQPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbZGHQPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZGHQO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:14:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbZGHQOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:14:55 -0400
Date: Wed, 8 Jul 2009 09:12:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Oleg Nesterov <oleg@redhat.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] sched: Remove SYSTEM_RUNNING checks from
 cond_resched*()
In-Reply-To: <1247034263.9777.24.camel@twins>
Message-ID: <alpine.LFD.2.01.0907080907210.3210@localhost.localdomain>
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru>  <20090708005000.GA12380@redhat.com> <1247034263.9777.24.camel@twins>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 8 Jul 2009, Peter Zijlstra wrote:

> On Wed, 2009-07-08 at 02:50 +0200, Oleg Nesterov wrote:
> 
> > 	/*
> > 	 * It is valid to assume CPU-locality during early bootup:
> > 	 */
> > 	if (system_state != SYSTEM_RUNNING)
> > 		goto out;
> > 
> > this doesn't look right, smp_init() is called before we set
> > SYSTEM_RUNNING.
> 
> The thing is, there's also ton's of code that might end up calling
> cond_resched() and co before the scheduler is fully initialized. Doing
> so would indeed mess things up.

I forget what triggered me to add some of them, but we definitely had bugs 
with the scheduler being called early, and having some really nasty oopses 
happen early in the boot (and that early, they don't get saved, so the 
reporting percentage goes down to something very low).

So I think that the patch Anton posted is probably the RightThing(tm) to 
do, and in that sense I like it - but they make me very nervous. There's a 
lot of "cond_resched()"s sprinkled about in helper routines, and if they 
are ever called early, you're basically screwed.

> Also, by definition we'd have to call smp_init() before SYSTEM_RUNNING,
> because you simply cannot declare a system up and running when your core
> functionality isn't initialized.

Now, that part I'm not sure about.

We can consider a UP system to be running, and brining up the other CPU's 
to be a matter of CPU hotplug. 

It's not what we do _now_, of course. We don't force hotplug support on 
people just because they want SMP, and we don't want to go through the 
whole "rewrite locks" things twice etc.

> So I'd really rather preserve these checks -- I can even remember
> running into some of these things a while back, but memory isn't
> providing specific cases.

Yes. I get nervous too about the patch.

That said, I do agree that maybe SYSTEM_RUNNING isn't the right check. 
Testing that the scheduler is initialized may be the more correct one. I 
think the SYSTEM_RUNNING one just comes from that being used for other 
debug issues.

		Linus
