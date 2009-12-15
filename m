Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZLOAwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZLOAwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbZLOAw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:52:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616AbZLOAw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:52:28 -0500
Date: Mon, 14 Dec 2009 19:52:19 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [PATCH] cfq: Take whether cfq group is changed into account
	when choosing service tree
Message-ID: <20091215005219.GA2725@redhat.com>
References: <4B21D252.1060902@cn.fujitsu.com> <20091211150727.GB2756@redhat.com> <4e5e476b0912111001h3c0b9798u2a2b25c9fcc39504@mail.gmail.com> <20091211184630.GA7066@redhat.com> <4B25A4F0.60407@cn.fujitsu.com> <4e5e476b0912140039s2f802786t84f53ee62b87c04e@mail.gmail.com> <4B260B72.9020204@cn.fujitsu.com> <4e5e476b0912140301x398ac2b7k5ab7fc5698b9675e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0912140301x398ac2b7k5ab7fc5698b9675e@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 12:01:14PM +0100, Corrado Zoccolo wrote:
> Hi Gui,
> On Mon, Dec 14, 2009 at 10:54 AM, Gui Jianfeng
> <guijianfeng@cn.fujitsu.com> wrote:
> > Corrado Zoccolo wrote:
> >> Hi,
> > Currently, IIUC, only the workload that didn't use up its slice will be saved, and only
> > such workloads are restoring when a group is resumed. So sometimes, we'll still get the
> > previous serving_type and workload_expires. Am i missing something?
> You are right. cfq_choose_cfqg should set the workload as expired if
> !cfqg->saved_workload_slice (just set cfqd->workload_expires = jiffies
> - 1), so the workload will be chosen again as the lowest keyed one.
> Can you send a patch to fix this?
> >

I agree too. This is a bug and needs to be fixed. Declaring workload
expired if we did not save a state, sounds good. We will be forced to
choose workload with-in group again and that is the right thing to do.

Gui, the point about prio_changed across group also will be solved by
above fix. We do save/restore the state of prio being served with-in
group. The only case missed out was, what if workload slice has expired
at the time of group expiry. So above patch should fix that too.

> >
> >>
> >> I have one more concern, though.
> >> RT priority has now changed meaning. Before, an RT task would always
> >> have priority access to the disk. Now, a BE task in a different group,
> >> with lower weight, can steal the disk from the RT task.
> >> A way to preserve the old meaning is to consider wheter a group has RT
> >> tasks inside when sorting groups tree, and putting those groups at the
> >> front.
> >> Usually, RT tasks will be put in the root group, and this (if
> >> group_isolation=0) will automatically make sure that also the noidle
> >> workload gets serviced quickly after RT tasks release the disk. We
> >> could even enforce that, with group_isolation=0, all RT tasks are put
> >> in the root group.
> >>
> >> The rationale behind this suggestion is that groups are for user
> >> processes, while RT is system wide, since it is only root that can
> >> grant it.

This sounds reasonable. I was also thinking of having a separate group
service tree for RT groups. That will allow root to create RT groups
of different weights and achieve proportionate share between RT groups.
But I am not sure how useful that actually is.

So to preserve the meaning of original RT tasks systemwide, a simple 
solution is to determine if a group as RT tasks and if answer is yes, then
put it at the front of service tree or at the back of currently backlogged
RT groups.

I will play a bit with this and come up with a patch.

> >
> >  I agree, and one more thing, currently we can't see fairness between different
> >  idle tasks in different groups. Because we only allow idle cfqq dispatch one request
> >  for its dispatch round even if it's the only task in the cgroup, group always loose it
> >  share. So whether we can rely on group_isolation, when group_isolation == 1 we provide
> >  isolation for idle tasks.
> Agreed.

What's the practical usage of this? In theory it sounds fine that groups
should provide isolation for idle task also. But what's the use case for
this. In the first phase, the way RT class is system wide, why idle class
can't be more or less system wide.

So I don't mind putting a patch in for making sure idle class task in a
group does not loose share. But I would rather put that patch once
somebody really needs it. Are you being impacted with this in your
workflow? If yes, please do post a patch to fix it.

Thanks
Vivek
