Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYKYQ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYKYQ3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYKYQ3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:29:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43189 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYKYQ3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:29:10 -0500
Date: Tue, 25 Nov 2008 11:27:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com,
       akpm@linux-foundation.org, menage@google.com, ngupta@google.com,
       riel@redhat.com, jmoyer@redhat.com, peterz@infradead.org,
       fchecconi@gmail.com, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081125162720.GH341@redhat.com>
References: <20081113221304.GH7542@redhat.com> <20081120.182053.220301508585579959.ryov@valinux.co.jp> <20081120134701.GB29306@redhat.com> <20081125.113359.623571555980951312.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125.113359.623571555980951312.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 11:33:59AM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> > > > Ryo, do you still want to stick to two level scheduling? Given the problem
> > > > of it breaking down underlying scheduler's assumptions, probably it makes
> > > > more sense to the IO control at each individual IO scheduler.
> > > 
> > > I don't want to stick to it. I'm considering implementing dm-ioband's
> > > algorithm into the block I/O layer experimentally.
> > 
> > Thanks Ryo. Implementing a control at block layer sounds like another
> > 2 level scheduling. We will still have the issue of breaking underlying
> > CFQ and other schedulers. How to plan to resolve that conflict.
> 
> I think there is no conflict against I/O schedulers.
> Could you expain to me about the conflict?

Because we do the buffering at higher level scheduler and mostly release
the buffered bios in the FIFO order, it might break the underlying IO
schedulers. Generally it is the decision of IO scheduler to determine in
what order to release buffered bios.

For example, If there is one task of io priority 0 in a cgroup and rest of
the tasks are of io prio 7. All the tasks belong to best effort class. If
tasks of lower priority (7) do lot of IO, then due to buffering there is
a chance that IO from lower prio tasks is seen by CFQ first and io from
higher prio task is not seen by cfq for quite some time hence that task
not getting it fair share with in the cgroup. Similiar situations can
arise with RT tasks also.

> 
> > What do you think about the solution at IO scheduler level (like BFQ) or
> > may be little above that where one can try some code sharing among IO
> > schedulers? 
> 
> I would like to support any type of block device even if I/Os issued
> to the underlying device doesn't go through IO scheduler. Dm-ioband
> can be made use of for the devices such as loop device.
> 

What do you mean by that IO issued to underlying device does not go
through IO scheduler? loop device will be associated with a file and
IO will ultimately go to the IO scheduler which is serving those file
blocks?

What's the use case scenario of doing IO control at loop device?
Ultimately the resource contention will take place on actual underlying
physical device where the file blocks are. Will doing the resource control
there not solve the issue for you?

Thanks
Vivek
