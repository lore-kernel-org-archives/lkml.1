Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbYDDW1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbYDDW1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 18:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYDDW1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 18:27:45 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45627 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbYDDW1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 18:27:44 -0400
Subject: Re: [Devel] [RFC PATCH 0/4] Container Freezer: Reuse Suspend
	Freezer
From: Matt Helsley <matthltc@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <47F64FBB.2080207@cs.columbia.edu>
References: <20080403210316.397506379@us.ibm.com>
	 <6599ad830804031649p6bbc60f3s59fb7c25a7260505@mail.gmail.com>
	 <1207278180.30178.94.camel@localhost.localdomain>
	 <47F64FBB.2080207@cs.columbia.edu>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 04 Apr 2008 15:27:40 -0700
Message-Id: <1207348060.30178.166.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-04 at 11:56 -0400, Oren Laadan wrote:
> 
> Matt Helsley wrote:
> > On Thu, 2008-04-03 at 16:49 -0700, Paul Menage wrote:
> >> On Thu, Apr 3, 2008 at 2:03 PM,  <matthltc@us.ibm.com> wrote:
> >>>    * "freezer.kill"
> >>>
> >>>      writing <n> will send signal number <n> to all tasks
> >>>
> >> My first thought (not having looked at the code yet) is that sending a
> >> signal doesn't really have anything to do with freezing, so it
> >> shouldn't be in the same subsystem. Maybe a separate subsystem called
> >> "signal"?
> >>
> >> And more than that, it's not something that requires any particular
> >> per-process state, so there's no reason that the subsystem that
> >> provides the "kill" functionality shouldn't be able to be mounted in
> >> multiple hierarchies.
> >>
> >> How about if I added support for stateless subsystems, that could
> >> potentially be mounted in multiple hierarchies at once? They wouldn't
> >> need an entry in the css set, since they have no state.
> > 
> > 	This seems reasonable to me. A quick look at Cedric's patches suggests
> > there's no need for such cgroup subsystems to be tied together -- the
> > signalling is all done internally to the freeze_task(), refrigerator(),
> > and thaw_process() functions from what I recall.
> > 
> >>>  * Usage :
> >>>
> >>>    # mkdir /containers/freezer
> >>>    # mount -t container -ofreezer freezer  /containers/freezer
> >>>    # mkdir /containers/freezer/0
> >>>    # echo $some_pid > /containers/freezer/0/tasks
> >>>
> >>>  to get status of the freezer subsystem :
> >>>
> >>>    # cat /containers/freezer/0/freezer.freeze
> >>>    RUNNING
> >>>
> >>>  to freeze all tasks in the container :
> >>>
> >>>    # echo 1 > /containers/freezer/0/freezer.freeze
> >>>    # cat /containers/freezer/0/freezer.freeze
> >>>    FREEZING
> >>>    # cat /containers/freezer/0/freezer.freeze
> >>>    FROZEN
> >> Could we separate this out into two files? One called "freeze" that's
> >> a 0/1 for whether we're intending to freeze the subsystem, and one
> >> called "frozen" that indicates whether it is frozen? And maybe a
> >> "state" file to report the RUNNING/FREEZING/FROZEN distinction in a
> >> human-readable way?
> > 
> > 3 files seems like overkill. I think making them human-readable is good
> > and can be done with two files: "state" (read-only) and
> > "state-next" (read/write). Transitions between RUNNING and FROZEN are
> > obvious when state-next != state. I think the advantages are it's pretty
> > human-readable, you don't need separate strings and files for the
> > transitions, it's clear what's about to happen (IMHO), and it only
> > requires 2 files. Some examples:
> > 
> > To initiate freezing:
> > 
> > # cat /containers/freezer/0/freezer.state
> > RUNNING
> > # echo "FROZEN" > /containers/freezer/0/freezer.state-next
> > # cat /containers/freezer/0/freezer.state
> > RUNNING
> > # cat /containers/freezer/0/freezer.state-next
> > FROZEN
> > # sleep N
> > # cat /containers/freezer/0/freezer.state
> > FROZEN
> > # cat /containers/freezer/0/freezer.state-next
> > FROZEN
> > 
> > So to cancel freezing you might see something like:
> > 
> > # cat /containers/freezer/0/freezer.state
> > RUNNING
> > # cat /containers/freezer/0/freezer.state-next
> > FROZEN
> > # echo "RUNNING" > /containers/freezer/0/freezer.state-next
> > # cat /containers/freezer/0/freezer.state-next
> > RUNNING
> > 
> > If you wanted to know if a group was transitioning:
> > 
> > # diff /containers/freezer/0/freezer.state /containers/freezer/0/freezer.state-next
> > 
> > Or:
> > # current=`cat /containers/freezer/0/freezer.state`
> > # next=`cat /containers/freezer/0/freezer.state-next`
> > # [ "$current" != "$next" ] && echo "Transitioning"
> > # [ "$current" == "RUNNING" -a "$next" == "FROZEN" ] && echo "Freezing"
> > # [ "$current" == "FROZEN" -a "$next" == "RUNNING" ] && echo "Thawing"
> > # [ "$current" == "RUNNING" -a "$next" == "RUNNING" ] && echo "No-op"
> > # [ "$current" == "FROZEN" -a "$next" == "FROZEN" ] && echo "No-op"
> 
> First, I totally agree with Serge's comment (oh well, it's about my
> own suggestion, so I must) - for checkpoint/restart we'll need more
> states if we are to use the same subsystem.

	I don't have an upper limit on how many more states we will need and I
think that number impacts the interface significantly. Can you give us
an estimate?

> Second, my gut feeling is that a single, atomic operation to get the
> status is preferred over multiple (non-atomic) operations. In other
> words, I suggest a single state file instead of two. You can encode
> every possible transition in a single state. It's not that the kernel

	If the transitions are to be human-readable and there are more than a
small number of states it may not be desirable to encode transitions as
states. Paul's reason for suggesting the additional file(s), as best I
could tell, was to keep the interface human-readable.

Cheers,
	-Matt Helsley


