Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbYHRMgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbYHRMgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYHRMgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:36:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbYHRMgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:36:22 -0400
Date: Mon, 18 Aug 2008 08:35:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Steve Olivieri <solivier@redhat.com>, Rik Van Riel <riel@redhat.com>
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes
	efficiently in the right cgroup
Message-ID: <20080818123526.GA30953@redhat.com>
References: <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com> <20080703155446.GB9275@redhat.com> <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com> <20080710104852.797fe79c@cuia.bos.redhat.com> <20080710154035.GA12043@redhat.com> <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com> <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com> <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A7FE7B.3060309@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 12:33:31PM +0200, Andrea Righi wrote:
> The problem of placing tasks in respective cgroups seems to be correctly
> addressed by userspace lib wrappers or classifier daemons [1].
> 
> However, this is an attempt to implement an in-kernel classifier.
> 
> [ I wrote this patch for a "special purpose" environment, where a lot of
> short-lived processes belonging to different users are spawned by
> different daemons, so the main goal here would be to remove the dealy
> needed by userspace classification and place the tasks in the right
> cgroup at the time they're created. This is just an ugly hack for now
> and it works only for uid-based rules, gid-based rules could be
> implemented in a similar way. ]
> 

Hi  Andrea,

Recently I introduced the infrastructure in libcgroup to handle
the task placement issue based on uid and gid rules. This is what I did.

- Introduced two new APIs in libcgroup to place the task in right cgroup.
	- cgroup_change_cgroup_uid_gid
		Pleces the task in destination cgroup based on uid/gid
		rules specified in /etc/cgrules.conf
	- cgroup_change_cgroup_path
		Puts the task into the cgroup specified by caller

- Provided two command line tools (cgexec and cgclassify) to perform
  various process placement related tasks.
	- cgexec
		A tool to launch a task in user specfied cgroup
	- cgclassify
		A tool to re-classify already running tasks.

- Wrote a pam plugin so that tasks are placed in right user groups upon
  login or reception of other services which take pam's help.

- Currently work is in progress for a user space daemon which will 
  automatically place the tasks based on notifications.

For your environment, where delay is unbearable, I think you can modify
the daemon to use libcgroup to place the forked task in right cgroup
before actually executing it. Once the task has been placed in right
cgroup, exec() will be called.

We have been doing all the user space development on following mailing
list.

https://lists.sourceforge.net/lists/listinfo/libcg-devel

Latest patches which got merged in libcgroup, are here.

http://sourceforge.net/mailarchive/forum.php?thread_name=20080813171720.108005557%40redhat.com&forum_name=libcg-devel

It is accompanied with a decent README file for design details and for
how to use it.

I think modifying the daemon to make use of libcgroup is the right way
to handle this issue than duplicating the infrastructure in user space
as well as kernel space.

Thanks
Vivek
