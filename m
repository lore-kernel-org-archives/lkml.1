Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYGHT5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYGHT5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYGHT5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:57:38 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49536 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYGHT5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:57:37 -0400
Subject: Re: [PATCH 0/4] Container Freezer: Reuse Suspend Freezer
From: Matt Helsley <matthltc@us.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Cedric Le Goater <clg@fr.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
In-Reply-To: <20080708123150.3034d83f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080707225823.502032693@us.ibm.com>
	 <20080708123150.3034d83f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 08 Jul 2008 12:39:14 -0700
Message-Id: <1215545954.9023.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cedric was accidentally not Cc'd on the introduction (PATCH 0). Adding
him.

On Tue, 2008-07-08 at 12:31 +0900, KAMEZAWA Hiroyuki wrote:
> Hi, could I make brief questions ?
> 
> On Mon, 07 Jul 2008 15:58:23 -0700
> Matt Helsley <matthltc@us.ibm.com> wrote:
> > to get status of the freezer subsystem :
> > 
> >    # cat /containers/0/freezer.state
> >    RUNNING
> > 
> > to freeze all tasks in the container :
> > 
> >    # echo FROZEN > /containers/0/freezer.state
> >    # cat /containers/0/freezer.state
> >    FREEZING
> >    # cat /containers/0/freezer.state
> >    FROZEN
> > 
> I'm just curious.
> 
> 1. When we see FREEZING and have to retry ?

One example is when some processes are in the a specific portion of
vfork() you might see FREEZING and have to retry.

>    While there are some threads which wait for some event ?

Depending on which kind of "wait" they are performing, yes. If it's
uninterruptible sleep and the PF_FROZEN flag is not set then you might
see FREEZING.

> 2. What happens when FROZEN threads are moved to other group ?
>    Can we move them ?

If the destination cgroup is not FROZEN, yes.

If the destination cgroup is FREEZING this works as expected.

If the destination cgroup is RUNNING you'd have a problem unfreezing the
task. This happends because the cgroup has a state inconsistent with the
task's state. To unfreeze the task you'd have to try to freeze and then
unfreeze the destination cgroup. 

There are several ways I could change this.

One is to try and disallow users from moving frozen tasks. That doesn't
seem like a good approach since it would require a new cgroups interface
"can_detach()". 

However we can prevent attach so I could add checks that look at the
attaching tasks's state and refuse the attach when the task's state
(unfrozen, frozen) is inconsistent with the cgroup state (RUNNING,
FREEZING, FROZEN). I'll send a fifth patch on top of this series showing
this idea.

Rather than refuse to allow attach we could change the destination
cgroup's state during attach so that the two states are consistent.
However, this introduces more ugly cases for userspace to be aware of.

>    Can we wake them up (if it can be moved) ?

You can't wake them until you've unfrozen them.

>    What operations are allowed to frozen threads ?

Any operation that doesn't require the threads to run.

Cheers,
	-Matt Helsley

