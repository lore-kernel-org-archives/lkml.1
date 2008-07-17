Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYGQHKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYGQHKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbYGQHKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:10:11 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:46443 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbYGQHKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:10:07 -0400
From: "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>
To: "'Vivek Goyal'" <vgoyal@redhat.com>,
       "'David Collier-Brown'" <davecb@sun.com>
Cc: "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
       "'Rik van Riel'" <riel@redhat.com>, "'Paul Menage'" <menage@google.com>,
       "'linux kernel mailing list'" <linux-kernel@vger.kernel.org>,
       "'Libcg Devel Mailing List'" <libcg-devel@lists.sourceforge.net>,
       "'Balbir Singh'" <balbir@linux.vnet.ibm.com>,
       "'Dhaval Giani'" <dhaval@linux.vnet.ibm.com>,
       "'Peter Zijlstra'" <pzijlstr@redhat.com>,
       "'Morton Andrew Morton'" <akpm@linux-foundation.org>,
       "'Thomas Graf'" <tgraf@redhat.com>,
       "'Ulrich Drepper'" <drepper@redhat.com>
References: <20080701191126.GA17376@redhat.com> <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com> <20080703155446.GB9275@redhat.com> <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com> <20080710104852.797fe79c@cuia.bos.redhat.com> <20080710154035.GA12043@redhat.com> <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com> <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com> <20080714152142.GJ16673@redhat.com>
Subject: RE: [RFC] How to handle the rules engine for cgroups
Date: Thu, 17 Jul 2008 16:05:17 +0900
Message-Id: <004201c8e7db$783480e0$cc7d220a@kid0000>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20080714152142.GJ16673@redhat.com>
Thread-Index: AcjlxVlT67m6eC1pTqmPaqhnEjUDAgCFEkOw
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Jul 14, 2008 at 10:44:43AM -0400, David Collier-Brown wrote:
> > Vivek Goyal wrote:
> >> If admin has decided to group applications and has written the rules for
> >> it then applications should not know anything about grouping. So I think
> >> application writing an script for being placed into the right group should
> >> be out of question. Now how does an admin write a wrapper around existing
> >> application without breaking anything else.
> >
> > In the Solaris world, processes are placed into cgroups (projects) by
> > one of two mechanisms:
> >
> > 1) inheritance, with everything I create in my existing project.
> >   To get this started, there is a mechanism under login/getty/whatever
> > reading the /etc/projects file and, for example, tossing user davecb
> > into a "user.davecb" project.
> >
> 
> Placing the login sessions in right cgroup based on uid/gid rules is
> probably easy as check needs to be placed only on system entry upon login
> (Pam plugin should do).  And after that any job started by the user
> will automatically start in the same cgroup.
> 
> > 2) explicit placement with newtask, which starts a program or moves
> >   a process into a project/cgroup
> >
> 
> explicit placement of task based on application type will be tricky.
> 
> > I have a "bg" project which I use for limiting resource consumption of
> > background jobs, and a background command which either starts or moves
> > jobs, thusly:
> >
> > case "$1" in
> > [0-9]*) # It's a pid
> >         newtask -p bg -c $1
> 
> Ok, this is moving of tasks from one cgroup to other based on pid. This
> is really easy to do through cgroup file system. Just a matter of writing
> to task file.
> 
> >         ;;
> >  *) # It's a command-line
> >         newtask -p bg "$@" &
> >         ;;
> 
> So here a user explicitly invokes the wrapper passing it the targeted
> cgroup and the application to be launched in that cgroup. This should work
> if there is a facility if user has created its own cgroups (lets say
> under user controlled cgroup dir in the hierarchy) and user explicitly
> wants to control the resources of applications under its dir. For example,
> 
>  		/mnt/cgroup
> 		|	|
> 		gid1	gid2
> 		|  |	|  |
> 	      uid1 uid2	uid3 uid4
> 	     |  |
> 	 proj1  proj2
> 
> Here probably admin can write the rules for how users are allocated the
> resources and give ability to users to create subdirs under their cgroups
> where users can create more cgroups and can do their own resource
> management based on application tasks and place applications in the right
> cgroup by writing wrappers as mentioned by you "newtask".
> 
> But here there is no discrimination of application type by admin. Admin
> controls resource divisions only based on uid/gid. And users can manage
> applications within their user groups. In fact I am having hard time thinking
> in what kind of scenarios, there is a need for an admin to control
> resource based on application type? Do we really need setups like, on
> a system databases should get network bandwidth of 30%. If yes, then
> it becomes tricky where admin need to write a wrapper to place the task
> in right cgroup without application/user knowing it.

I think a wrapper (move to right group and calls exec) will run by user, not by admin.
In explicit placement, user knows what a type of application he/she launch.

 		/mnt/cgroup
		|	|
		gid1	gid2
		|  |	|  |
	      uid1 uid2	uid3 uid4
	     |  |
	 proj1  proj2

[uid1/gid1]% newtask.sh proj1app
... proj1app run under /mnt/cgroup/gid1/uid1

[uid1/gid1]% newtask.sh --type proj1type proj1app
... proj1app run under /mnt/cgroup/gid1/uid1/proj1
 
In this case, admin sets up limitation of proj1type.
Also I guess proj1type has ownership (ex: proj1type allows gid1).
Isn't this enough?

Thanks,
Kazunaga Ikeno

