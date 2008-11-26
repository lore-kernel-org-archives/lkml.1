Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYKZGkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYKZGkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 01:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbYKZGkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 01:40:25 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:38137 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYKZGkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 01:40:24 -0500
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Nauman Rafique <nauman@google.com>,
       Fabio Checconi <fchecconi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, taka@valinux.co.jp,
       righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, menage@google.com,
       ngupta@google.com, riel@redhat.com, jmoyer@redhat.com,
       peterz@infradead.org, paolo.valente@unimore.it
In-Reply-To: <20081120134058.GA29306@redhat.com>
References: <4922224A.5030502@cn.fujitsu.com>
	 <e98e18940811172101na345b6bh5c73f9e657aac5a7@mail.gmail.com>
	 <20081118120508.GD15268@gandalf.sssup.it>
	 <20081118140751.GA4283@redhat.com>
	 <20081118144139.GE15268@gandalf.sssup.it>
	 <20081118191208.GJ26308@kernel.dk>
	 <e98e18940811181507t6b1473act2efa23df21dab270@mail.gmail.com>
	 <20081119142446.GH26308@kernel.dk>
	 <af41c7c40811191612v5db13ae7n3cfe537beb6a157c@mail.gmail.com>
	 <20081120081640.GE26308@kernel.dk>  <20081120134058.GA29306@redhat.com>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 26 Nov 2008 15:40:18 +0900
Message-Id: <1227681618.12997.163.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 08:40 -0500, Vivek Goyal wrote:
> > The dm approach has some merrits, the major one being that it'll fit
> > directly into existing setups that use dm and can be controlled with
> > familiar tools. That is a bonus. The draw back is partially the same -
> > it'll require dm. So it's still not a fit-all approach, unfortunately.
> > 
> > So I'd prefer an approach that doesn't force you to use dm.
> 
> Hi Jens,
> 
> My patches met the goal of not using the dm for every device one wants
> to control.
> 
> Having said that, few things come to mind.
> 
> - In what cases do we need to control the higher level logical devices
>   like dm. It looks like real contention for resources is at leaf nodes.
>   Hence any kind of resource management/fair queueing should probably be
>   done at leaf nodes and not at higher level logical nodes.

The problem with stacking devices is that we do not know how the IO
going through the leaf nodes contributes to the aggregate throughput
seen by the application/cgroup that generated it, which is what end
users care about.

The block device could be a plain old sata device, a loop device, a
stacking device, a SSD, you name it, but their topologies and the fact
that some of them do not even use an elevator should be transparent to
the user.

If you wanted to do resource management at the leaf nodes some kind of
topology information should be passed down to the elevators controlling
the underlying devices, which in turn would need to work cooperatively.

>   If that makes sense, then probably we don't need to control dm device
>   and we don't need such higher level solutions.

For the reasons stated above the two level scheduling approach seems
cleaner to me.

> - Any kind of 2 level scheduler solution has the potential to break the
>   underlying IO scheduler. Higher level solution requires buffering of
>   bios and controlled release of bios to lower layers. This control breaks
>   the assumptions of lower layer IO scheduler which knows in what order
>   bios should be dispatched to device to meet the semantics exported by
>   the IO scheduler.

Please notice that the such an IO controller would only get in the way
of the elevator in case of contention for the device. What is more,
depending on the workload it turns out that buffering at higher layers
in a per-cgroup or per-task basis, like dm-band does, may actually
increase the aggregate throughput (I think that the dm-band team
observed this behavior too). The reason seems to be that bios buffered
in such way tend to be highly correlated and thus very likely to get
merged when released to the elevator.

> - 2nd level scheduler does not keep track of tasks but task groups lets
>   every group dispatch fair share. This has got little semantic problem in
>   the sense that tasks and groups in root cgroup will not be considered at
>   same level. "root" will be considered one group at same level with all
>   child group hence competing with them for resources.
> 
>   This looks little odd. Considering tasks and groups same level kind of
>   makes more sense. cpu scheduler also consideres tasks and groups at same
>   level and deviation from that probably is not very good.
> 
>   Considering tasks and groups at same level will matter only if IO
>   scheduler maintains separate queue for the task, like CFQ. Because
>   in that case IO scheduler tries to provide fairness among various task
>   queues. Some schedulers like noop don't have any notion of separate
>   task queues and fairness among them. In that case probably we don't
>   have a choice but to assume root group competing with child groups.

If deemed necessary this case could be handled too, but it does not look
like a show-stopper.

> Keeping above points in mind, probably two level scheduling is not a
> very good idea. If putting the code in a particular IO scheduler is a
> concern we can probably explore ways regarding how we can maximize the
> sharing of cgroup code among IO schedulers.

As discussed above, I still think that the two level scheduling approach
makes more sense. Regarding the sharing of cgroup code among IO
schedulers I am all for it. If we consider that elevators should only
care about maximizing usage of the underlying devices, implementing
other non-hardware-dependent scheduling disciplines (that prioritize
according to the task or cgroup that generated the IO, for example) at
higher layers so that we can reuse code makes a lot of sense.

Thanks,

Fernando

