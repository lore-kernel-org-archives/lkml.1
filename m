Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbYGRINl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbYGRINl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYGRINZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:13:25 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:60987 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752805AbYGRINW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:13:22 -0400
Date: Fri, 18 Jul 2008 13:42:53 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       "'David Collier-Brown'" <davecb@sun.com>,
       "'Peter Zijlstra'" <pzijlstr@redhat.com>,
       "'Rik van Riel'" <riel@redhat.com>, "'Thomas Graf'" <tgraf@redhat.com>,
       "'linux kernel mailing list'" <linux-kernel@vger.kernel.org>,
       "'Ulrich Drepper'" <drepper@redhat.com>,
       "'Libcg Devel Mailing List'" <libcg-devel@lists.sourceforge.net>,
       "'Morton Andrew Morton'" <akpm@linux-foundation.org>,
       "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Libcg-devel] [RFC] How to handle the rules engine for cgroups
Message-ID: <20080718081253.GD16453@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com> <20080710104852.797fe79c@cuia.bos.redhat.com> <20080710154035.GA12043@redhat.com> <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com> <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com> <20080714152142.GJ16673@redhat.com> <004201c8e7db$783480e0$cc7d220a@kid0000> <20080717134736.GA11420@redhat.com> <20080717170717.GA3718@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717170717.GA3718@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 10:37:17PM +0530, Sudhir Kumar wrote:
> On Thu, Jul 17, 2008 at 09:47:36AM -0400, Vivek Goyal wrote:
> > On Thu, Jul 17, 2008 at 04:05:17PM +0900, Kazunaga Ikeno wrote:
> > > Vivek Goyal wrote:
> > > > On Mon, Jul 14, 2008 at 10:44:43AM -0400, David Collier-Brown wrote:
> > > > > Vivek Goyal wrote:
> > > > >> If admin has decided to group applications and has written the rules for
> > > > >> it then applications should not know anything about grouping. So I think
> > > > >> application writing an script for being placed into the right group should
> > > > >> be out of question. Now how does an admin write a wrapper around existing
> > > > >> application without breaking anything else.
> > > > >
> > > > > In the Solaris world, processes are placed into cgroups (projects) by
> > > > > one of two mechanisms:
> > > > >
> > > > > 1) inheritance, with everything I create in my existing project.
> > > > >   To get this started, there is a mechanism under login/getty/whatever
> > > > > reading the /etc/projects file and, for example, tossing user davecb
> > > > > into a "user.davecb" project.
> > > > >
> > > > 
> > > > Placing the login sessions in right cgroup based on uid/gid rules is
> > > > probably easy as check needs to be placed only on system entry upon login
> > > > (Pam plugin should do).  And after that any job started by the user
> > > > will automatically start in the same cgroup.
> > > > 
> > > > > 2) explicit placement with newtask, which starts a program or moves
> > > > >   a process into a project/cgroup
> > > > >
> > > > 
> > > > explicit placement of task based on application type will be tricky.
> > > > 
> > > > > I have a "bg" project which I use for limiting resource consumption of
> > > > > background jobs, and a background command which either starts or moves
> > > > > jobs, thusly:
> > > > >
> > > > > case "$1" in
> > > > > [0-9]*) # It's a pid
> > > > >         newtask -p bg -c $1
> > > > 
> > > > Ok, this is moving of tasks from one cgroup to other based on pid. This
> > > > is really easy to do through cgroup file system. Just a matter of writing
> > > > to task file.
> > > > 
> > > > >         ;;
> > > > >  *) # It's a command-line
> > > > >         newtask -p bg "$@" &
> > > > >         ;;
> > > > 
> > > > So here a user explicitly invokes the wrapper passing it the targeted
> > > > cgroup and the application to be launched in that cgroup. This should work
> > > > if there is a facility if user has created its own cgroups (lets say
> > > > under user controlled cgroup dir in the hierarchy) and user explicitly
> > > > wants to control the resources of applications under its dir. For example,
> > > > 
> > > >  		/mnt/cgroup
> > > > 		|	|
> > > > 		gid1	gid2
> > > > 		|  |	|  |
> > > > 	      uid1 uid2	uid3 uid4
> > > > 	     |  |
> > > > 	 proj1  proj2
> > > > 
> > > > Here probably admin can write the rules for how users are allocated the
> > > > resources and give ability to users to create subdirs under their cgroups
> > > > where users can create more cgroups and can do their own resource
> > > > management based on application tasks and place applications in the right
> > > > cgroup by writing wrappers as mentioned by you "newtask".
> > > > 
> > > > But here there is no discrimination of application type by admin. Admin
> > > > controls resource divisions only based on uid/gid. And users can manage
> > > > applications within their user groups. In fact I am having hard time thinking
> > > > in what kind of scenarios, there is a need for an admin to control
> > > > resource based on application type? Do we really need setups like, on
> > > > a system databases should get network bandwidth of 30%. If yes, then
> > > > it becomes tricky where admin need to write a wrapper to place the task
> > > > in right cgroup without application/user knowing it.
> > > 
> > > I think a wrapper (move to right group and calls exec) will run by user, not by admin.
> > > In explicit placement, user knows what a type of application he/she launch.
> > > 
> > >  		/mnt/cgroup
> > > 		|	|
> > > 		gid1	gid2
> > > 		|  |	|  |
> > > 	      uid1 uid2	uid3 uid4
> > > 	     |  |
> > > 	 proj1  proj2
> > > 
> > 
> > This is the easy to handle situation and I am hoping it will work in many
> > of the cases.
> 
> This solution seems ok but this looks only one part of the storey. Here
> the top level hierarchy is again user based(gid/uid). What if admin
> wants to manage the system resources per application basis? Say a big
> server in a university is being shared by everyone in the university for
> only 3 application
> 1. http server
> 2. browsing
> 3. computing
> In case the admin wants the system to be always available for computing,
> how should he utilize cgroups for managing the server resources among
> these applications ?
> Isn't such scenarios on the priority now?

We only have FS permissions to play around with. Therefore any hierarchy
we come up with will be uid/gid based. Such scenarios will be handled by
the administrator by ensuring the correct permissions are set for the
cgroup.

> 
> > 
> > Currently I am writting a patch for libcg which allows querying the
> > destination cgroup based on uid/gid and libcg will also migrate the
> > application there. I am also writing a pam plugin which will move
> > all the login sessions to respective cgroup (as mentioned by rule file).
> > Will also modify "init" so that all the system services to into cgroup
> > belonging to root.
> > 
> > Once user is logged in and running into his resource group, he can manage
> > further subgroups at his own based on his application requirements (as you
> > mentioned proj1 and proj2 here).
> > 
> > > [uid1/gid1]% newtask.sh proj1app
> > > ... proj1app run under /mnt/cgroup/gid1/uid1
> > > 
> > 
> > Yes, so if a user does not specifically launch an application targetted
> > for a particular cgroup, then it will run into default group for that
> > user (as specified by rule file). In this case under /mnt/cgroup/gid1/uid1.
> So in this user based approach if admin wants to run 4 major
> applications each one requiring say 15% cpu he needs to create 4
> different gids? Creation of a user account just for running an
> application does not look very flexible to me.
> 

A lot of daemons run as specific users. Also its not a good idea to run
daemons/servers as root users. They should run as users who have limited
privileges. With such a model in place, Vivek's comments make sense and
might be the right way to go ahead. 

Thanks,
-- 
regards,
Dhaval
