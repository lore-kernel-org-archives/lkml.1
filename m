Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbXJIPAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbXJIPAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXJIPA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:00:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55175 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbXJIPA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:00:27 -0400
Date: Tue, 9 Oct 2007 20:42:01 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: [PATCH sched-devel] Generate uevents for user creation/destruction
Message-ID: <20071009151201.GK3707@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu> <20071003171029.GA5423@linux.vnet.ibm.com> <20071004075750.GD9176@elte.hu> <20071004085451.GA8108@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20071004085451.GA8108@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 04, 2007 at 10:54:51AM +0200, Heiko Carstens wrote:
> > i'm wondering about the following: could not (yet) existing UIDs be made 
> > configurable too? I.e. if i do this in a bootup script:
> > 
> >   echo 2048 > /sys/kernel/uids/500/cpu_share
> > 
> > this should just work too, regardless of there not being any UID 500 
> > tasks yet. Likewise, once configured, the /sys/kernel/uids/* directories 
> > (with the settings in them) should probably not go away either.
> 
> Shouldn't that be done via uevents? E.g. UID x gets added to the sysfs tree,
> generates a uevent and a script then figures out the cpu_share and sets it.
> That way you also don't need to keep the directories. No?

Heiko,
	Thanks for the hint. Here's a patch to enable generation of
uevents for user creation/deletion. These uevents can be handled in
userspace to configure a new user's cpu share.

Note : After bootup I could test that new user's cpu share is configured
as per a configuration file (/etc/user_cpu_share.conf). However this
mechanism didnt work for root user. Perhaps uevent for root user is
generated way too early?

A HOWTO text file is also attached explaining how to make use of these
uevents in userspace.

Ingo,
	This patch applies on top of latest sched-devel tree. Pls review
and apply ..


---

Generate uevents when a user is being created/destroyed. These events
could be used to configure cpu share of a new user.

Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by : Dhaval Giani <dhaval@linux.vnet.ibm.com>


---
 kernel/user.c |    4 ++++
 1 files changed, 4 insertions(+)

Index: current/kernel/user.c
===================================================================
--- current.orig/kernel/user.c
+++ current/kernel/user.c
@@ -174,6 +174,8 @@ static int user_kobject_create(struct us
 	if (error)
 		kobject_del(kobj);
 
+	kobject_uevent(kobj, KOBJ_ADD);
+
 done:
 	return error;
 }
@@ -189,6 +191,7 @@ int __init uids_kobject_init(void)
 
 	/* create under /sys/kernel dir */
 	uids_kobject.parent = &kernel_subsys.kobj;
+	uids_kobject.kset = &kernel_subsys;
 	kobject_set_name(&uids_kobject, "uids");
 	kobject_init(&uids_kobject);
 
@@ -228,6 +231,7 @@ static void remove_user_sysfs_dir(struct
 		goto done;
 
 	sysfs_remove_file(kobj, &up->user_attr.attr);
+	kobject_uevent(kobj, KOBJ_REMOVE);
 	kobject_del(kobj);
 
 	sched_destroy_user(up);



-- 
Regards,
vatsa

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=HOWTO

This HOWTO explains the steps required to configure a user's cpu share 
automatically when he/she logs in. This has been verified to work on
a Redhat distribution.

Note : This HOWTO is a *hack* to get things working quickly. In particular it 
doesn't follow standards like LSB.

1. Create a file /etc/user_cpu_share.conf with this format:

	[uid]	[cpu_share]

   Ex:

	512	1024	#user vatsa
	514	512	#user guest


2. Create a script, named "kernel.agent" in /etc/hotplug directory 
   as follows. Make that script executable and owned by root.

#!/bin/sh
#
# kernel hotplug agent for 2.6 kernels
#
#       ACTION=add
#       DEVPATH=/kernel/uids/[uid]
#

cd /etc/hotplug
. ./hotplug.functions

case $ACTION in

add)
	uid=${DEVPATH##*/}
	line=`grep -w $uid /etc/user_cpu_share.conf`
	if [ $? -eq 0 ]
	then
		cpu_share=`echo $line | awk '{print $2}'`
		echo $cpu_share > /sys/$DEVPATH/cpu_share
	fi
	;;

*)
	;;
esac


	



--G4iJoqBmSsgzjUCe--
