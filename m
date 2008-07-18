Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbYGRUVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbYGRUVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYGRUUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:20:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbYGRUUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:20:54 -0400
Date: Fri, 18 Jul 2008 16:12:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       "'David Collier-Brown'" <davecb@sun.com>,
       "'Peter Zijlstra'" <pzijlstr@redhat.com>,
       "'Rik van Riel'" <riel@redhat.com>, "'Thomas Graf'" <tgraf@redhat.com>,
       "'linux kernel mailing list'" <linux-kernel@vger.kernel.org>,
       "'Ulrich Drepper'" <drepper@redhat.com>,
       "'Libcg Devel Mailing List'" <libcg-devel@lists.sourceforge.net>,
       "'Morton Andrew Morton'" <akpm@linux-foundation.org>,
       "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Libcg-devel] [RFC] How to handle the rules engine for cgroups
Message-ID: <20080718201225.GM11492@redhat.com>
References: <20080710104852.797fe79c@cuia.bos.redhat.com> <20080710154035.GA12043@redhat.com> <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com> <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com> <20080714152142.GJ16673@redhat.com> <004201c8e7db$783480e0$cc7d220a@kid0000> <20080717134736.GA11420@redhat.com> <20080717170717.GA3718@linux.vnet.ibm.com> <20080718081253.GD16453@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718081253.GD16453@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 01:42:53PM +0530, Dhaval Giani wrote:

[..]
> > > > I think a wrapper (move to right group and calls exec) will run by user, not by admin.
> > > > In explicit placement, user knows what a type of application he/she launch.
> > > > 
> > > >  		/mnt/cgroup
> > > > 		|	|
> > > > 		gid1	gid2
> > > > 		|  |	|  |
> > > > 	      uid1 uid2	uid3 uid4
> > > > 	     |  |
> > > > 	 proj1  proj2
> > > > 
> > > 
> > > This is the easy to handle situation and I am hoping it will work in many
> > > of the cases.
> > 
> > This solution seems ok but this looks only one part of the storey. Here
> > the top level hierarchy is again user based(gid/uid). What if admin
> > wants to manage the system resources per application basis? Say a big
> > server in a university is being shared by everyone in the university for
> > only 3 application
> > 1. http server
> > 2. browsing
> > 3. computing
> > In case the admin wants the system to be always available for computing,
> > how should he utilize cgroups for managing the server resources among
> > these applications ?
> > Isn't such scenarios on the priority now?
> 
> We only have FS permissions to play around with. Therefore any hierarchy
> we come up with will be uid/gid based. Such scenarios will be handled by
> the administrator by ensuring the correct permissions are set for the
> cgroup.
> 
> > 
> > > 
> > > Currently I am writting a patch for libcg which allows querying the
> > > destination cgroup based on uid/gid and libcg will also migrate the
> > > application there. I am also writing a pam plugin which will move
> > > all the login sessions to respective cgroup (as mentioned by rule file).
> > > Will also modify "init" so that all the system services to into cgroup
> > > belonging to root.
> > > 
> > > Once user is logged in and running into his resource group, he can manage
> > > further subgroups at his own based on his application requirements (as you
> > > mentioned proj1 and proj2 here).
> > > 
> > > > [uid1/gid1]% newtask.sh proj1app
> > > > ... proj1app run under /mnt/cgroup/gid1/uid1
> > > > 
> > > 
> > > Yes, so if a user does not specifically launch an application targetted
> > > for a particular cgroup, then it will run into default group for that
> > > user (as specified by rule file). In this case under /mnt/cgroup/gid1/uid1.
> > So in this user based approach if admin wants to run 4 major
> > applications each one requiring say 15% cpu he needs to create 4
> > different gids? Creation of a user account just for running an
> > application does not look very flexible to me.
> > 
> 
> A lot of daemons run as specific users. Also its not a good idea to run
> daemons/servers as root users. They should run as users who have limited
> privileges. With such a model in place, Vivek's comments make sense and
> might be the right way to go ahead. 
> 

Even if admin is launching the applications/daemons and he wants to have
some control on the resources allocated on these daemons individually,
then he needs to just create four cgroups under his account and launch four
daemons in those four cgroups and control the resources.

				/mnt/cgroup
				|	  |
		        usergroup	  admingroup
		        |       |	  |   |    |
	              uid1    uid2	ser1 ser2  ser3	

Here all the "root" tasks go under /mnt/cgrop/admingroup. Now admin
has created three cgroups "ser1" "ser2" and "ser3". Now admin needs
to explicitly launch applications in right cgroup. Something like.

# newtask.sh -cg /mnt/cgroup/admingroup/ser1	appl1
# newtask.sh -cg /mnt/cgroup/admingroup/ser2	appl2
# newtask.sh -cg /mnt/cgroup/admingroup/ser3	appl3

So admin need not to create separate accounts if services have been
launched by admin. He just needs to launch the services in right cgroup
by using the command line utility, specifying destination cgroup.
(To be written).

Thanks
Vivek
