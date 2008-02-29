Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYB2JfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYB2JfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 04:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYB2Je6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 04:34:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39334 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbYB2Je4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 04:34:56 -0500
Subject: Re: A strange behavior of sched_fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       vatsa <vatsa@linux.vnet.ibm.com>
In-Reply-To: <47C5E977.2010401@jp.fujitsu.com>
References: <47C5E977.2010401@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 10:34:45 +0100
Message-Id: <1204277686.6243.52.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 17:51 -0500, Kei Tokunaga wrote:
> Hi Ingo,
> 
> I am playing around with sched_fair and cgroup, and it seems like
> I hit a possible bug.  Could you also check if that is a bug?
> 
> Description of behavior:
>    Start a cpu-bound task (t1), attach it to a cgroup (cgA), and let the
>    task to run for a while (e.g. several tens of seconds or a couple of
>    minutes would be adequate.)  Then, start another cpu-bound task (t2)
>    and attach it to cgA in the way described in "Steps to Reproduce" section.
>    You will see t1 does not get run for a while.
>    (The tasks may not have to be cpu-bound, but it is easier to see the
>     behavior using cpu-bound tasks.)
> 
> How reproducible:
>    Always.
> 
> Environments where I saw the behavior:
>    2.6.25-rc3 with resource management functions enabled on ia64 box.
> 
> Steps to Reproduce:
>    # mkdir /dev/cgroup
>    # mount -t cgroup -ocpuset,cpu cpu /dev/cgroup
>    # mkdir /dev/cgroup/{a,b}
>    # echo 0 > /dev/cgroup/a/cpuset.cpus
>    # echo 0 > /dev/cgroup/b/cpuset.cpus
>    # echo 1 > /dev/cgroup/a/cpuset.mems
>    # echo 1 > /dev/cgroup/b/cpuset.mems
>    # echo $$ > /dev/cgroup/b/tasks
>    # ./a.out & echo $! > /dev/cgroup/a/tasks (a.out is just a for-loop program)
>      [Wait for several tens of seconds or a couple of minutes.]
>    # ./a.out2 & echo $! > /dev/cgroup/a/tasks (a.out2 is just a for-loop program)
>      [You will see a.out does not get run for a while by running top command.]
> 
> Additional Info:
>    a.out2 needs to be started from the shell of cgroup-b in order to
>    reproduce the problem (, unless the system is UP.)  Starting a.out2
>    in the manner, se->vruntime (or something to create the se->vruntime)
>    of a.out2 seems to be initialized to a small value, compared to the
>    value of a.out.  And the fair scheduler only runs a.out2 until the
>    se->vruntime catches up with the se->vruntime of a.out.

Seems the vruntime doesn't get re-set if you move tasks between groups.
sched_move_task() should call place_entity() in the context of the new
cfs_rq.

