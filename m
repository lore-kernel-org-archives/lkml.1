Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbYGODrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbYGODrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbYGODr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:47:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37198 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYGODr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:47:29 -0400
Date: Mon, 14 Jul 2008 23:47:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <alpine.LFD.1.10.0807142029280.3017@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0807142342450.8137@gandalf.stny.rr.com>
References: <20080712031736.GA3040@damson.getinternet.no> 
 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org> 
 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com> 
 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
 <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>
 <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org>
 <Pine.LNX.4.58.0807142320180.4530@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0807142029280.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Linus Torvalds wrote:
> >
> > On Mon, 14 Jul 2008, Linus Torvalds wrote:
> > > So by doing the test for cpu_active_map not at queuing time, but at the
> > > time when we actually try to do the migration, we can now also make that
> > > cpu_active_map be totally serialized.
> > >
> > > (Of course, anybody who clears the bit does need to take the runqueue lock
> > > of that CPU too, but cpu_down() will have to do that as it does the
> > > "migrate away live tasks" anyway, so that's not a problem)
> >
> > Wouldn't simply doing a synchronize_sched() after clearing the bit also
> > make sure that no new task will be scheduled on that CPU?
>
> My point was that it DOESN'T NEED TO DO ANYTHING AT ALL.
>
> It has to get the runqueue lock in order to move the currently executing
> threads off that CPU anyway. The fact that it can (and actually does)
> synchronize with the scheduler in other ways is totally and utterly
> immaterial.
>
> That's what "robust" means. It means that things just work, and there are
> no subtle interactions.
>
> Sure, you can serialize with something complicated and heavy.
>
> But isn't it nice that the absolutely _least_ complicated and heavy
> operation (ie getting the runqueue lock) also serializes sufficiently?
> Isn't it nice how you have to do that in order to do all those other
> things that you obviously have to do?
>
> Please don't argue about how we can add more subtle rules, or how other
> thigns can serialize this thing as well. Isn't it sufficient that the
> _obvious_ things serialize it?

Oh, I'm not arguing. My mind is going off to an even bigger picture, where
something in the future would need to stop migration to a particular CPU,
and that it could simply clear the bit and call synchronize_sched. The run
queue lock is only visible to the scheduler.  Sorry, I may have been day
dreaming out loud ;-)

But for the case at hand, yes I agree, simply grabbing the run queue lock
is a very elegant and simple solution.

-- Steve

