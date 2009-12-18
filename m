Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZLRPvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZLRPvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZLRPvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:51:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbZLRPvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:51:08 -0500
Date: Fri, 18 Dec 2009 10:49:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       m-ikeda@ds.jp.nec.com, Alan.Brunelle@hp.com,
       Peter Zijlstra <pzijlstr@redhat.com>
Subject: Re: [RFC] CFQ group scheduling structure organization
Message-ID: <20091218154912.GD3123@redhat.com>
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com> <4e5e476b0912170341h7ba632akddb921c996a36f73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0912170341h7ba632akddb921c996a36f73@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 12:41:32PM +0100, Corrado Zoccolo wrote:
> Hi,
> On Wed, Dec 16, 2009 at 11:52 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi All,
> >
> > With some basic group scheduling support in CFQ, there are few questions
> > regarding how group structure should look like in CFQ.
> >
> > Currently, grouping looks as follows. A, and B are two cgroups created by
> > user.
> >
> > [snip]
> >
> > Proposal 4:
> > ==========
> > Treat task and group at same level. Currently groups are at top level and
> > at second level are tasks. View the whole hierarchy as follows.
> >
> >
> >                        service-tree
> >                        /   |  \  \
> >                       T1   T2  G1 G2
> >
> > Here T1 and T2 are two tasks in root group and G1 and G2 are two cgroups
> > created under root.
> >
> > In this kind of scheme, any RT task in root group will still be system
> > wide RT even if we create groups G1 and G2.
> >
> > So what are the issues?
> >
> > - I talked to few folks and everybody found this scheme not so intutive.
> >  Their argument was that once I create a cgroup, say A,  under root, then
> >  bandwidth should be divided between "root" and "A" proportionate to
> >  the weight.
> >
> >  It is not very intutive that group is competing with all the tasks
> >  running in root group. And disk share of newly created group will change
> >  if more tasks fork in root group. So it is highly dynamic and not
> >  static hence un-intutive.
> >
> >  To emulate the behavior of previous proposals, root shall have to create
> >  a new group and move all root tasks there. But admin shall have to still
> >  keep RT tasks in root group so that they still remain system-wide.
> >
> >                        service-tree
> >                        /   |    \  \
> >                       T1  root  G1 G2
> >                            |
> >                            T2
> >
> >  Now admin has specifically created a group "root" along side G1 and G2
> >  and moved T2 under root. T1 is still left in top level group as it might
> >  be an RT task and we want it to remain RT task systemwide.
> >
> >  So to some people this scheme is un-intutive and requires more work in
> >  user space to achive desired behavior. I am kind of 50:50 between two
> >  kind of arrangements.
> >
> This is the one I prefer: it is the most natural one if you see that
> groups are scheduling entities like any other task.

This is the approach I had implemented in my earlier postings. I had
the notion of io_entity which was embedded in both cfq_queue and
cfq_groups. So cfq core scheduler had to worry about scheduling entities
and these entities could be either queues or groups. Something picked from
BFQ and CFS implementation.

> I think it becomes intuitive with an analogy with a qemu (e.g. kvm)
> virtual machine model. If you think a group like a virtual machine, it
> is clear that for the normal system, the whole virtual machine is a
> single scheduling entity, and that it has to compete with other
> virtual machines (as other single entities) and every process in the
> real system (those are inherently more important, since without the
> real system, the VMs cannot simply exist).
> Having a designated root group, instead, resembles the xen VM model,
> where you have a separated domain for each VM and for the real system.
> 
> I think the implementation of this approach can make the code simpler
> and modular (CFQ could be abstracted to deal with scheduling entities,
> and each scheduling entity could be defined in a separate file).
> Within each group, you will now have the choice of how to schedule its
> queues. This means that you could possibly have different I/O
> schedulers within each group, and even have sub-groups within groups.

Abstracting in terms of scheduling entities and allowing tasks and groups
to be at same level definitely helps in terms of extending implementation
to hierarchical mode (sub groups with-in groups).  My initial posting was
also hierarchical. I cut down later on functionality to reduce patch size.

At the same time it also imposes the restriction that we use the same
schedling algorithm for queues as well as groups. In current
implementation, I am using a vtime based algorithm for groups and we
continue to use original cfq logic (cfq_slice_offset()) for cfqq
scheduling.

Now I shall have to merge these two. The advantage of group scheduling
algorithm is that it can provide you accurate disk time distribution
accoriding to weight (as long as groups are continuously backlogged and
not deleted from service tree). Because it keeps track of vtime, it does
not enforce that group's entitled share needs to be consumed in one go (as
opposed to cfq queue scheduling algorithm). One can expire a queue and
select a different group for dispatch and still original group will not
loose the share.

Migrating cfq's queue scheduling algorithm to use group algorithm should
not be a problem, except the fact that I am not very sure about honoring
the task prio on NCQ SSDs. Currently in group scheduling algorithm we a
group is not continuously backlogged, it is deleted from service tree and
when it comes back, it is put at the end of queue hence it looses share.
In case of NCQ SSDs, we will not idle, and we will loose ioprio
differentiation between various cfqq on NCQ SSDs. In fact I am not even
sure how well cfq approximation is working on NCQ SSD when it comes to
service differentation between various prio queues.

I had tried putting deleted queues not at the end but with lower vtime
based on weight. But then it introduces inaccuracy w.r.t continuously
baklogged groups. So entities which get deleted gain share and
continuously backlogged one gain share. 

> >
> > I am looking for some feedback on what makes most sense.
> I think that regardless of our preference, we should coordinate with
> how the CPU scheduler works, since I think the users will be more
> surprised to see cgroups behaving different w.r.t. CPU and disk, than
> if the RT task behaviour changes when cgroups are introduced.

True. AFAIK, cpu scheduler treats tasks and groups at same level. I think
initially they had also started with treating root group at the same level
as other groups in root group but later switched to task and groups at
same level.

CCing Peter Zijlstra. He might have thoughts why treating task and groups at
same level was considered a better approach as compared to treating root
group at same level with other groups in root group.

Thanks
Vivek
