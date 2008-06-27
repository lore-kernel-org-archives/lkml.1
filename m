Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbYF0Fvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbYF0Fvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYF0Fv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:51:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:13098 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYF0Fv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:51:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=J+nRxEvE3btb6vsbn4bGRda1lr6puGthdp+RQNBjlewo6utku6MtduVmLgVw7pKt0
	tCG2RJdrMcL11Ny/xnQmA==
Message-ID: <6599ad830806262251x3a0747b9q6f143cc2fcd0aa57@mail.gmail.com>
Date: Thu, 26 Jun 2008 22:51:17 -0700
From: "Paul Menage" <menage@google.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [RFC][PATCH] CPUSets: Move most calls to rebuild_sched_domains() to the workqueue
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>, "Paul Jackson" <pj@sgi.com>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       "Gautham shenoy" <ego@in.ibm.com>
In-Reply-To: <48647652.5050001@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48634BC1.8@google.com>
	 <19f34abd0806260234y7616bab2k54bc019dfb0c6305@mail.gmail.com>
	 <6599ad830806260250m39d700a5haf0f32d999cd2129@mail.gmail.com>
	 <4863E4C8.9050705@qualcomm.com>
	 <6599ad830806261334y6def5f7an57ac8f071a08eb4b@mail.gmail.com>
	 <6599ad830806261417u3015a9b2i6318841de866d768@mail.gmail.com>
	 <48647652.5050001@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:10 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>
> Instead of changing cpu_hotplug locking should we maybe try to avoid using
> cgroup_lock in rebuild_sched_domains() ?

Yes, that would be good too.

> There is a comment in cpuset.c that says
>  * If a task is only holding callback_mutex, then it has read-only
>  * access to cpusets.
>
> I'm not sure if it's still valid. rebuild_sched_domains() only needs read only
> access, it does not really modify any cpuset structures.

The comment is still valid, if you interpret it narrowly enough.
Holding callback_mutex gives you read-only access to structures that
are under the control of cpusets. But rebuild_sched_domains() needs to
traverse the hierarchy of cpusets, and that hierarchy is controlled by
cgroups. Currently the only synchronization primitives exposed by
cgroups are:

- cgroup_lock()/cgroup_unlock() to prevent all cgroup modifications
(also used as the main synchronization primitive by some subsystems,
i.e. it's in danger of becoming the cgroups equivalent of the BKL).

- task_lock()/task_unlock() to prevent a specific task from changing cgroups

Possible options for richer locking support include:

- lock/unlock a hierarchy, to prevent creation/deletion of cgroups in
that hierarchy

- lock/unlock a cgroup to prevent deletion of that cgroup

- lock/unlock a cgroup to prevent task movement in/out of that cgroup

For the case of rebuild_sched_domains, we need the first of these
options. This lock would be taken in cgroup.c at the points where it
attached and removed cgroups from a cgroup tree, and could be taken by
something like cpusets that needed to keep the hierarchy stable while
scanning it. I think it would be fine to make it a mutex rather than a
spinlock.

cpu_hotplug.lock has to nest outside this hierarchy lock due to it
being taken at the root of the hotplug/unplug path. So as long as we
can ensure that we can always nest the hierarchy lock inside any
get_online_cpus()/put_online_cpus() pairs, we should be OK.

Paul
