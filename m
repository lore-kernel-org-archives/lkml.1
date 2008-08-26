Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbYHZNl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbYHZNl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 09:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbYHZNlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 09:41:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756443AbYHZNlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 09:41:49 -0400
Date: Tue, 26 Aug 2008 09:41:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paul Menage <menage@google.com>
Cc: righi.andrea@gmail.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Steve Olivieri <solivier@redhat.com>
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes
	efficiently in the right cgroup
Message-ID: <20080826134127.GA30312@redhat.com>
References: <20080710104852.797fe79c@cuia.bos.redhat.com> <20080710154035.GA12043@redhat.com> <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com> <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com> <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com> <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com> <20080819125710.GA18972@redhat.com> <6599ad830808251754l146588dax65aeff2cc22ac0c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830808251754l146588dax65aeff2cc22ac0c1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 05:54:39PM -0700, Paul Menage wrote:
> On Tue, Aug 19, 2008 at 5:57 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Same thing will happen if we implement the daemon in user space. A task
> > who does seteuid(), can be swept away to a different cgroup based on
> > rules specified in /etc/cgrules.conf.
> 
> Yes, I'm not so keen on a daemon magically pulling things into a
> cgroup based on uid either, for the same reasons.
> 
> But a user-space based solution can be much more flexible (e.g. easier
> to configure it to only move tasks from certain source cgroups).
> 
> >
> > What do you mean by risk? This is the policy set up by system admin and
> > behaviour would seem consistent as per the policy. If an admin decides
> > that tasks of user "apache" should run into /container/cpu/apache cgroup and
> > if a "root" tasks does seteuid(apache), then it manes sense to move task
> > to /container/cpu/apache.
> 
> The kind of unexpected behaviour I was imagining was when some other
> daemon (e.g. ftpd?) unexpectedly does a setuid to one of the
> magically-controlled users, and results in that daemon being pulled
> into the specified cgroup. For something like cpu maybe that's mostly
> benign (but what moves it back into its original group after it
> switches back to root?)

Once ftpd does seteuid() or setreuid() again to switch effective user to
"root", it will be moved back to original group (root's group).

So basic question is if a program changes its effective user id temporarily
to user B than all the resource consumption should take place from the
resources of user B or should continue to take place from original cgroup.

I would think that we should move the task temporarily to B's cgroup and
bring back again upon identity change.

At the same time I can also understand that this behavior can probably
be considered over-intrusive and some people might want to avoid that.

Two things come to my mind.

- Users who find it too intrusive, can just shut down the rules based
  daemon.

- Or, we can implement selective movement of tasks by daemon as suggested by
  you. This will make system more complex but provides more flexibility
  in the sense users can keep daemon running at the same time control
  movement of certain tasks.

> but for other subsystems it could be more
> painful (memory, device access, etc).
> 


> >
> > Exactly what kind of scenario do you have in mind when you want the policy
> > to be enforced selectively based on task (tid)?
> 
> I was thinking of something like possibly a per-cgroup file (that also
> affected child cgroups) rather than a global file. That would also
> automatically handle multiple hierarchies.
> 

So there can be two kind of controls.

- Create a per cgroup file say "group_pinned", where if 1 is written to
  "group_pinned" that means daemon will not move tasks from this cgroup upon
  effective uid/gid changes.

- Provide more fine grained control where task movement is not controlled
  per cgroup, rather per thread id. In that case every cgroup will contain
  another file "tasks_pinned" which will contain all the tids which cannot
  be moved from this cgroup by daemon. By default this file will be empty
  and all the tids are movable.

I think initially we can keep things simple and implement "group_pinned" 
which provides coarse control on the whole group and pins all the tasks
in that cgroup.

Thoughts?

Thanks
Vivek
