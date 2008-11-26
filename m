Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYKZLzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYKZLzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYKZLzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:55:08 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:47283 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYKZLzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:55:06 -0500
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, menage@google.com,
       ngupta@google.com, riel@redhat.com, jmoyer@redhat.com,
       peterz@infradead.org, fchecconi@gmail.com, paolo.valente@unimore.it
In-Reply-To: <20081125162720.GH341@redhat.com>
References: <20081113221304.GH7542@redhat.com>
	 <20081120.182053.220301508585579959.ryov@valinux.co.jp>
	 <20081120134701.GB29306@redhat.com>
	 <20081125.113359.623571555980951312.ryov@valinux.co.jp>
	 <20081125162720.GH341@redhat.com>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Wed, 26 Nov 2008 20:55:04 +0900
Message-Id: <1227700504.12997.398.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 11:27 -0500, Vivek Goyal wrote:
> On Tue, Nov 25, 2008 at 11:33:59AM +0900, Ryo Tsuruta wrote:
> > Hi Vivek,
> > 
> > > > > Ryo, do you still want to stick to two level scheduling? Given the problem
> > > > > of it breaking down underlying scheduler's assumptions, probably it makes
> > > > > more sense to the IO control at each individual IO scheduler.
> > > > 
> > > > I don't want to stick to it. I'm considering implementing dm-ioband's
> > > > algorithm into the block I/O layer experimentally.
> > > 
> > > Thanks Ryo. Implementing a control at block layer sounds like another
> > > 2 level scheduling. We will still have the issue of breaking underlying
> > > CFQ and other schedulers. How to plan to resolve that conflict.
> > 
> > I think there is no conflict against I/O schedulers.
> > Could you expain to me about the conflict?
> 
> Because we do the buffering at higher level scheduler and mostly release
> the buffered bios in the FIFO order, it might break the underlying IO
> schedulers. Generally it is the decision of IO scheduler to determine in
> what order to release buffered bios.

It could be argued that the IO scheduler's primary goal is to maximize
usage of the underlying device according to its physical
characteristics. For hard disks this may imply minimizing time wasted by
seeks; other types of devices, such as SSDs, may impose different
requirements. This is something that clearly belongs in the elevator. On
the other hand, it could be argued that other non-hardware-related
scheduling disciplines would fit better in higher layers.

That said, as you pointed out such separation could impact performance,
so we will probably need to implement a feedback mechanism between the
elevator, which could collect statistics and provide hints, and the
upper layers. The elevator API looks like a good candidate for this,
though new functions might be needed.

> For example, If there is one task of io priority 0 in a cgroup and rest of
> the tasks are of io prio 7. All the tasks belong to best effort class. If
> tasks of lower priority (7) do lot of IO, then due to buffering there is
> a chance that IO from lower prio tasks is seen by CFQ first and io from
> higher prio task is not seen by cfq for quite some time hence that task
> not getting it fair share with in the cgroup. Similiar situations can
> arise with RT tasks also.

Well, this issue is not intrinsic to dm-band and similar solutions. In
the scenario you point out the problem is that the elevator and the IO
controller are not cooperating. The same could happen even if we
implemented everything at the elevator layer (or a little above): get
hierarchical scheduling wrong and you are likely to have a rough ride.

BFQ deals with hierarchical scheduling at just one layer which makes
things easier. BFQ chose the elevator layer, but a similar scheduling
discipline could be implemented higher in the block layer too. The HW
specific-bits we cannot take out the elevator, but when it comes to
task/cgroup based scheduling there are more possibilities, which
includes the middle-way approach we are discussing: two level
scheduling.

The two level model is not bad per se, we just need to get the two
levels to work in unison and for that we will certainly need to make
changes to the existing elevators.

> > > What do you think about the solution at IO scheduler level (like BFQ) or
> > > may be little above that where one can try some code sharing among IO
> > > schedulers? 
> > 
> > I would like to support any type of block device even if I/Os issued
> > to the underlying device doesn't go through IO scheduler. Dm-ioband
> > can be made use of for the devices such as loop device.
> 
> What do you mean by that IO issued to underlying device does not go
> through IO scheduler? loop device will be associated with a file and
> IO will ultimately go to the IO scheduler which is serving those file
> blocks?

I think that Tsuruta-san's point is that the loop device driver uses its
own make_request_fn which means that bios entering a loop device do not
necessarily go through a IO scheduler after that.

We will always find ourselves in this situation when trying to manage
devices that provide their own make_request_fn, the reason being that
its behavior is driver and configuration dependent: in the loop device
case whether we go through a IO scheduler or not depends on what has
been attached to it; in stacking device configurations the effect that
the IO scheduling at one of the devices that constitute the multi-device
will have in the aggregate throughput depends on the topology.

The only way I can think of to address all cases in a sane way is
controlling the entry point to the block layer, which is precisely what
dm-band does.

The problem with dm-band is that it relies on the dm infrastructure. In
my opinion, if we could remove that dependency it would be a huge step
in the right direction.

> What's the use case scenario of doing IO control at loop device?

My guess is virtualized machines using images exported as loop devices à
la Xen's blktap (blktap's implementation is quite different from Linux'
loop device, though).

Thanks,

Fernando

