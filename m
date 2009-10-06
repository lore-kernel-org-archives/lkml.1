Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZJFHSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZJFHSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbZJFHSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:18:23 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:36686 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbZJFHSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:18:22 -0400
Date: Tue, 06 Oct 2009 16:17:44 +0900 (JST)
Message-Id: <20091006.161744.189719641.ryov@valinux.co.jp>
To: nauman@google.com
Cc: vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, agk@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com,
       yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: IO scheduler based IO controller V10
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <e98e18940910051111r110dc776l5105bf931761b842@mail.gmail.com>
References: <20091005.235535.193690928.ryov@valinux.co.jp>
	<20091005171023.GG22143@redhat.com>
	<e98e18940910051111r110dc776l5105bf931761b842@mail.gmail.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek and Nauman,

Nauman Rafique <nauman@google.com> wrote:
> >> > > How about adding a callback function to the higher level controller?
> >> > > CFQ calls it when the active queue runs out of time, then the higer
> >> > > level controller use it as a trigger or a hint to move IO group, so
> >> > > I think a time-based controller could be implemented at higher level.
> >> > >
> >> >
> >> > Adding a call back should not be a big issue. But that means you are
> >> > planning to run only one group at higher layer at one time and I think
> >> > that's the problem because than we are introducing serialization at higher
> >> > layer. So any higher level device mapper target which has multiple
> >> > physical disks under it, we might be underutilizing these even more and
> >> > take a big hit on overall throughput.
> >> >
> >> > The whole design of doing proportional weight at lower layer is optimial
> >> > usage of system.
> >>
> >> But I think that the higher level approch makes easy to configure
> >> against striped software raid devices.
> >
> > How does it make easier to configure in case of higher level controller?
> >
> > In case of lower level design, one just have to create cgroups and assign
> > weights to cgroups. This mininum step will be required in higher level
> > controller also. (Even if you get rid of dm-ioband device setup step).

In the case of lower level controller, if we need to assign weights on
a per device basis, we have to assign weights to all devices of which
a raid device consists, but in the case of higher level controller, 
we just assign weights to the raid device only.

> >> If one would like to
> >> combine some physical disks into one logical device like a dm-linear,
> >> I think one should map the IO controller on each physical device and
> >> combine them into one logical device.
> >>
> >
> > In fact this sounds like a more complicated step where one has to setup
> > one dm-ioband device on top of each physical device. But I am assuming
> > that this will go away once you move to per reuqest queue like implementation.

I don't understand why the per request queue implementation makes it
go away. If dm-ioband is integrated into the LVM tools, it could allow
users to skip the complicated steps to configure dm-linear devices.

> > I think it should be same in principal as my initial implementation of IO
> > controller on request queue and I stopped development on it because of FIFO
> > dispatch.

I think that FIFO dispatch seldom lead to prioviry inversion, because
holding period for throttling is not too long to break the IO priority.
I did some tests to see whether priority inversion is happened.

The first test ran fio sequential readers on the same group. The BE0
reader got the highest throughput as I expected.

nr_threads      16      |      16    |     1
ionice          BE7     |     BE7    |    BE0
------------------------+------------+-------------
vanilla     10,076KiB/s | 9,779KiB/s | 32,775KiB/s
ioband       9,576KiB/s | 9,367KiB/s | 34,154KiB/s

The second test ran fio sequential readers on two different groups and
give weights of 20 and 10 to each group respectively. The bandwidth
was distributed according to their weights and the BE0 reader got
higher throughput than the BE7 readers in the same group. IO priority
was preserved within the IO group.

group         group1    |         group2
weight          20      |           10    
------------------------+--------------------------
nr_threads      16      |      16    |     1
ionice          BE7     |     BE7    |    BE0
------------------------+--------------------------
ioband      27,513KiB/s | 3,524KiB/s | 10,248KiB/s
                        |     Total = 13,772KiB/s

Here is my test script.
-------------------------------------------------------------------------
arg="--time_base --rw=read --runtime=30 --directory=/mnt1 --size=1024M \
     --group_reporting"

sync
echo 3 > /proc/sys/vm/drop_caches

echo $$ > /cgroup/1/tasks
ionice -c 2 -n 0 fio $arg --name=read1 --output=read1.log --numjobs=16 &
echo $$ > /cgroup/2/tasks
ionice -c 2 -n 0 fio $arg --name=read2 --output=read2.log --numjobs=16 &
ionice -c 1 -n 0 fio $arg --name=read3 --output=read3.log --numjobs=1 &
echo $$ > /cgroup/tasks
wait
-------------------------------------------------------------------------

Be that as it way, I think that if every bio can point the iocontext
of the process, then it makes it possible to handle IO priority in the
higher level controller. A patchse has already posted by Takhashi-san.
What do you think about this idea?

  Date Tue, 22 Apr 2008 22:51:31 +0900 (JST)
  Subject [RFC][PATCH 1/10] I/O context inheritance
  From Hirokazu Takahashi <>
  http://lkml.org/lkml/2008/4/22/195

> > So you seem to be suggesting that you will move dm-ioband to request queue
> > so that setting up additional device setup is gone. You will also enable
> > it to do time based groups policy, so that we don't run into issues on
> > seeky media. Will also enable dispatch from one group only at a time so
> > that we don't run into isolation issues and can do time accounting
> > accruately.
> 
> Will that approach solve the problem of doing bandwidth control on
> logical devices? What would be the advantages compared to Vivek's
> current patches?

I will only move the point where dm-ioband grabs bios, other
dm-ioband's mechanism and functionality will stll be the same.
The advantages against to scheduler based controllers are:
 - can work with any type of block devices
 - can work with any type of IO scheduler and no need a big change.

> > If yes, then that has the potential to solve the issue. At higher layer one
> > can think of enabling size of IO/number of IO policy both for proportional
> > BW and max BW type of control. At lower level one can enable pure time
> > based control on seeky media.
> >
> > I think this will still left with the issue of prio with-in group as group
> > control is separate and you will not be maintatinig separate queues for
> > each process. Similarly you will also have isseus with read vs write
> > ratios as IO schedulers underneath change.
> >
> > So I will be curious to see that implementation.
> >
> >> > > My requirements for IO controller are:
> >> > > - Implement s a higher level controller, which is located at block
> >> > >   layer and bio is grabbed in generic_make_request().
> >> >
> >> > How are you planning to handle the issue of buffered writes Andrew raised?
> >>
> >> I think that it would be better to use the higher-level controller
> >> along with the memory controller and have limits memory usage for each
> >> cgroup. And as Kamezawa-san said, having limits of dirty pages would
> >> be better, too.
> >>
> >
> > Ok. So if we plan to co-mount memory controller with per memory group
> > dirty_ratio implemented, that can work with both higher level as well as
> > low level controller. Not sure if we also require some kind of a per
> > memory group flusher thread infrastructure also to make sure higher weight
> > group gets more job done.

I'm not sure either that a per memory group flusher is necessary.
An we have to consider not only pdflush but also other threads which 
issue IOs from multiple groups.

> >> > > - Can work with any type of IO scheduler.
> >> > > - Can work with any type of block devices.
> >> > > - Support multiple policies, proportional wegiht, max rate, time
> >> > >   based, ans so on.
> >> > >
> >> > > The IO controller mini-summit will be held in next week, and I'm
> >> > > looking forard to meet you all and discuss about IO controller.
> >> > > https://sourceforge.net/apps/trac/ioband/wiki/iosummit
> >> >
> >> > Is there a new version of dm-ioband now where you have solved the issue of
> >> > sync/async dispatch with-in group? Before meeting at mini-summit, I am
> >> > trying to run some tests and come up with numbers so that we have more
> >> > clear picture of pros/cons.
> >>
> >> Yes, I've released new versions of dm-ioband and blkio-cgroup. The new
> >> dm-ioband handles sync/async IO requests separately and
> >> the write-starve-read issue you pointed out is fixed. I would
> >> appreciate it if you would try them.
> >> http://sourceforge.net/projects/ioband/files/
> >
> > Cool. Will get to testing it.

Thanks for your help in advance.

Thanks,
Ryo Tsuruta
