Return-Path: <linux-kernel-owner+w=401wt.eu-S1761074AbXJDRJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761074AbXJDRJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757930AbXJDRIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:08:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50159 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723AbXJDRIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:08:53 -0400
Date: Thu, 4 Oct 2007 22:50:05 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH -v2] Add sysfs control to modify a user's cpu share
Message-ID: <20071004172005.GA5519@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu> <20071003171029.GA5423@linux.vnet.ibm.com> <20071004075750.GD9176@elte.hu> <20071004085451.GA8108@osiris.boeblingen.de.ibm.com> <47050E79.6020100@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47050E79.6020100@tmr.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 12:02:01PM -0400, Bill Davidsen wrote:
> >>i'm wondering about the following: could not (yet) existing UIDs be made 
> >>configurable too? I.e. if i do this in a bootup script:
> >>
> >>  echo 2048 > /sys/kernel/uids/500/cpu_share
> >>
> >>this should just work too, regardless of there not being any UID 500 
> >>tasks yet. Likewise, once configured, the /sys/kernel/uids/* directories 
> >>(with the settings in them) should probably not go away either.
> >
> >Shouldn't that be done via uevents? E.g. UID x gets added to the sysfs 
> >tree,
> >generates a uevent and a script then figures out the cpu_share and sets it.
> >That way you also don't need to keep the directories. No?
> 
> That sounds complex administratively. It means that instead of setting a 
> higher or lower than default once and having it persist until reboot I 
> have to create a script, which *will* in some cases be left in place 
> even after the need has gone.
> 
> I agree with Ingo, once it's done it should be persistent.
> And as another administrative convenience I can look at that set of 
> values and see what shares are being used, even when the user is not 
> currently active.

Although the need seems very real, I am thinking about the implementation 
aspect of this in the kernel i.e how will this be implementable?

1. The current patch proposes a sysfs based interface, where a new
   directory is created for every new user created who logs into the 
   system. To meet the requirement Ingo suggested, it would require the
   ability to create directories in sysfs in advance of (user_struct) objects 
   that aren't yet there - which is not possible to implement in sysfs
   afaik

2. configfs seems to allow creation of directories (i.e kernel objects) from 
   userland. Every new directory created should translate to a
   user_struct object being created in the kernel (and inserted in
   uid_hash table). Would this be acceptable?

Also, IMHO, CONFIG_FAIR_USER_SCHED is there only as a toy, to test fair group 
scheduling and I expect distros to support CONFIG_FAIR_CGROUP_SCHED instead 
which allows "control group" (or process containers) based fair group 
scheduling.

Using CONFIG_FAIR_CGROUP_SCHED it is still possible to provide user-id based 
fair group scheduling, in two ways:

	1. Have a daemon which listens for UID change events
	   (PROC_EVENT_UID) and move the task to appropriate "control
	   groups" and set the "control group" shares
	2. Implement a "user" subsystem registered with "cgroup" core,
  	   which automatically creates new "control groups" whenever
 	   a new user is being added to the system. This is very similar
	   to "ns" subsystem (kernel/ns_cgroup.c in -mm tree).
 	   Thus in order to provide fair user scheduling with this option,
	   distro needs to modify initrd to:

		# mkdir /dev/usercpucontrol
		# mount -t cgroup -ouser,cpu none /dev/usercpucontrol

Using a combination of these two options and a /etc configuration file
which specifies the cpu shares to be given to a user, it should be
possible for distro to give a good fair-user based scheduler.

> Final question, how do setuid processes map into this implementation?

We seem to be going by the real uid of a task (which is what tsk->user
points at) to decide its CPU bandwidth. Is that a cause of concern?

-- 
Regards,
vatsa
