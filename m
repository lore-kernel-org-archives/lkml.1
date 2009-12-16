Return-Path: <linux-kernel-owner+w=401wt.eu-S964803AbZLPW4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964803AbZLPW4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763327AbZLPWzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:55:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763209AbZLPWzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:55:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [RFC] CFQ group scheduling structure organization
Date: Wed, 16 Dec 2009 17:52:56 -0500
Message-Id: <1261003980-10115-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

With some basic group scheduling support in CFQ, there are few questions
regarding how group structure should look like in CFQ.

Currently, grouping looks as follows. A, and B are two cgroups created by
user.

Proposal 1:
=========
			grp-service-tree
			/      |     \
		    root       A     B

One issue with this structure is that RT tasks are not system wide. So an
RT tasks inside root group has RT priority only with-in root group. So a
BE task inside A will get it fair share despite the fact that root has got
RT tasks.


Proposal 2:
==========
One proposal to solve this issue is that make RT and IDLE tasks system
wide and provide weight based service differentiation only for BE class
tasks. So RT or IDLE tasks running in any of the groups will automatically
move to one global RT group maintained by CFQ internally. Same is true for
IDLE tasks. But BE class tasks will honor the cgroup limitations and will
get differentiated service according to weight.

Internal structure will look as follows.

     grp-RT-service-tree  grp-BE-service-tree   grp-IDLE-service-tree 
             |		      /  \                      |
	all_RT_task_group    A   B               all_idle_tasks_grp
		

Here A and B are two cgroups and some BE tasks might be running inside 
those groups. systemwide RT tasks will move under all_RT_task_group and
all idle tasks will move under all_idle_tasks_grp.

So one will notice service differentiation only for BE tasks.


Proposal 3:
===========

One can argue that we need group service differentiation for RT class
tasks also and don't move tasks automatically across groups. That means
we need to support "group class" type also. Probably we can support
three classes of cgroups RT, BE and IDLE and CFQ will use that data to
put cgroups in respective tree. 

Things should look as follows.

     grp-RT-service-tree  grp-BE-service-tree   grp-IDLE-service-tree 
             / \		      /  \             /   \  
	    C  D                     A   B            E    F


Here A and B are BE type groups created by user.
C and D are RT type cgroups created by user.
E and F are IDLE type cgroups created by user.

Now in this scheme of things, by default root will be of type BE. Any task
RT task under "root" group will not be system wide RT task. It will be RT
only with-in root group. To make it system wide idle, admin shall have to
create a new cgroup, say C, of type RT and move task in that cgroup.
Because RT group C is system wide, now that task becomes system wide RT.

So this scheme might throw some surprise to existing users. They might
create a new group and not realize that their RT tasks are no more system
wide RT tasks and they need to specifically create one RT cgroup and move
all RT tasks in that cgroup.

Practically I am not sure how many people are looking for group service
differentiation for RT and IDLE class tasks also.

Proposal 4:
==========
Treat task and group at same level. Currently groups are at top level and
at second level are tasks. View the whole hierarchy as follows.


			service-tree
			/   |  \  \
		       T1   T2  G1 G2

Here T1 and T2 are two tasks in root group and G1 and G2 are two cgroups
created under root.

In this kind of scheme, any RT task in root group will still be system
wide RT even if we create groups G1 and G2.

So what are the issues?

- I talked to few folks and everybody found this scheme not so intutive.
  Their argument was that once I create a cgroup, say A,  under root, then
  bandwidth should be divided between "root" and "A" proportionate to
  the weight.

  It is not very intutive that group is competing with all the tasks 
  running in root group. And disk share of newly created group will change
  if more tasks fork in root group. So it is highly dynamic and not
  static hence un-intutive.

  To emulate the behavior of previous proposals, root shall have to create
  a new group and move all root tasks there. But admin shall have to still 
  keep RT tasks in root group so that they still remain system-wide.

			service-tree
			/   |    \  \
		       T1  root  G1 G2
			    |
			    T2

  Now admin has specifically created a group "root" along side G1 and G2
  and moved T2 under root. T1 is still left in top level group as it might
  be an RT task and we want it to remain RT task systemwide.

  So to some people this scheme is un-intutive and requires more work in
  user space to achive desired behavior. I am kind of 50:50 between two
  kind of arrangements.


I am looking for some feedback on what makes most sense.

For the time being, I am little inclined towards proposal 2 and I have
implemented a proof of concept version on top of for-2.6.33 branch in block
tree.  These patches are compile and boot tested only and I have yet to do
testing.

Thanks
Vivek

