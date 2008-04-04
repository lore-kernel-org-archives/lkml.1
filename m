Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbYDDDDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbYDDDDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 23:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYDDDDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 23:03:08 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57136 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYDDDDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 23:03:05 -0400
Subject: Re: [Devel] [RFC PATCH 0/4] Container Freezer: Reuse Suspend
	Freezer
From: Matt Helsley <matthltc@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <6599ad830804031649p6bbc60f3s59fb7c25a7260505@mail.gmail.com>
References: <20080403210316.397506379@us.ibm.com>
	 <6599ad830804031649p6bbc60f3s59fb7c25a7260505@mail.gmail.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 03 Apr 2008 20:03:00 -0700
Message-Id: <1207278180.30178.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-03 at 16:49 -0700, Paul Menage wrote:
> On Thu, Apr 3, 2008 at 2:03 PM,  <matthltc@us.ibm.com> wrote:
> >
> >    * "freezer.kill"
> >
> >      writing <n> will send signal number <n> to all tasks
> >
> 
> My first thought (not having looked at the code yet) is that sending a
> signal doesn't really have anything to do with freezing, so it
> shouldn't be in the same subsystem. Maybe a separate subsystem called
> "signal"?
>
> And more than that, it's not something that requires any particular
> per-process state, so there's no reason that the subsystem that
> provides the "kill" functionality shouldn't be able to be mounted in
> multiple hierarchies.
> 
> How about if I added support for stateless subsystems, that could
> potentially be mounted in multiple hierarchies at once? They wouldn't
> need an entry in the css set, since they have no state.

	This seems reasonable to me. A quick look at Cedric's patches suggests
there's no need for such cgroup subsystems to be tied together -- the
signalling is all done internally to the freeze_task(), refrigerator(),
and thaw_process() functions from what I recall.

> >  * Usage :
> >
> >    # mkdir /containers/freezer
> >    # mount -t container -ofreezer freezer  /containers/freezer
> >    # mkdir /containers/freezer/0
> >    # echo $some_pid > /containers/freezer/0/tasks
> >
> >  to get status of the freezer subsystem :
> >
> >    # cat /containers/freezer/0/freezer.freeze
> >    RUNNING
> >
> >  to freeze all tasks in the container :
> >
> >    # echo 1 > /containers/freezer/0/freezer.freeze
> >    # cat /containers/freezer/0/freezer.freeze
> >    FREEZING
> >    # cat /containers/freezer/0/freezer.freeze
> >    FROZEN
> 
> Could we separate this out into two files? One called "freeze" that's
> a 0/1 for whether we're intending to freeze the subsystem, and one
> called "frozen" that indicates whether it is frozen? And maybe a
> "state" file to report the RUNNING/FREEZING/FROZEN distinction in a
> human-readable way?

3 files seems like overkill. I think making them human-readable is good
and can be done with two files: "state" (read-only) and
"state-next" (read/write). Transitions between RUNNING and FROZEN are
obvious when state-next != state. I think the advantages are it's pretty
human-readable, you don't need separate strings and files for the
transitions, it's clear what's about to happen (IMHO), and it only
requires 2 files. Some examples:

To initiate freezing:

# cat /containers/freezer/0/freezer.state
RUNNING
# echo "FROZEN" > /containers/freezer/0/freezer.state-next
# cat /containers/freezer/0/freezer.state
RUNNING
# cat /containers/freezer/0/freezer.state-next
FROZEN
# sleep N
# cat /containers/freezer/0/freezer.state
FROZEN
# cat /containers/freezer/0/freezer.state-next
FROZEN

So to cancel freezing you might see something like:

# cat /containers/freezer/0/freezer.state
RUNNING
# cat /containers/freezer/0/freezer.state-next
FROZEN
# echo "RUNNING" > /containers/freezer/0/freezer.state-next
# cat /containers/freezer/0/freezer.state-next
RUNNING

If you wanted to know if a group was transitioning:

# diff /containers/freezer/0/freezer.state /containers/freezer/0/freezer.state-next

Or:
# current=`cat /containers/freezer/0/freezer.state`
# next=`cat /containers/freezer/0/freezer.state-next`
# [ "$current" != "$next" ] && echo "Transitioning"
# [ "$current" == "RUNNING" -a "$next" == "FROZEN" ] && echo "Freezing"
# [ "$current" == "FROZEN" -a "$next" == "RUNNING" ] && echo "Thawing"
# [ "$current" == "RUNNING" -a "$next" == "RUNNING" ] && echo "No-op"
# [ "$current" == "FROZEN" -a "$next" == "FROZEN" ] && echo "No-op"

etc.

Cheers,
	-Matt Helsley

