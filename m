Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbYGODh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbYGODh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYGODhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:37:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752981AbYGODhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:37:13 -0400
Date: Mon, 14 Jul 2008 20:36:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <Pine.LNX.4.58.0807142320180.4530@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0807142029280.3017@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>  <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>  <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com> <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org> <Pine.LNX.4.58.0807142320180.4530@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Steven Rostedt wrote:

> 
> On Mon, 14 Jul 2008, Linus Torvalds wrote:
> > So by doing the test for cpu_active_map not at queuing time, but at the
> > time when we actually try to do the migration, we can now also make that
> > cpu_active_map be totally serialized.
> >
> > (Of course, anybody who clears the bit does need to take the runqueue lock
> > of that CPU too, but cpu_down() will have to do that as it does the
> > "migrate away live tasks" anyway, so that's not a problem)
> 
> Wouldn't simply doing a synchronize_sched() after clearing the bit also
> make sure that no new task will be scheduled on that CPU?

My point was that it DOESN'T NEED TO DO ANYTHING AT ALL.

It has to get the runqueue lock in order to move the currently executing 
threads off that CPU anyway. The fact that it can (and actually does) 
synchronize with the scheduler in other ways is totally and utterly 
immaterial.

That's what "robust" means. It means that things just work, and there are 
no subtle interactions.

Sure, you can serialize with something complicated and heavy. 

But isn't it nice that the absolutely _least_ complicated and heavy 
operation (ie getting the runqueue lock) also serializes sufficiently? 
Isn't it nice how you have to do that in order to do all those other 
things that you obviously have to do?

Please don't argue about how we can add more subtle rules, or how other 
thigns can serialize this thing as well. Isn't it sufficient that the 
_obvious_ things serialize it?

		Linus
