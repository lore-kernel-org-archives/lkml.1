Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbZK3QCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbZK3QCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZK3QCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:02:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZK3QCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:02:15 -0500
Date: Mon, 30 Nov 2009 11:00:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, Alan.Brunelle@hp.com
Subject: Re: Block IO Controller V4
Message-ID: <20091130160024.GD11670@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <4e5e476b0911300734h34a22c88oa5d7d4e5642ead50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911300734h34a22c88oa5d7d4e5642ead50@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 04:34:36PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Mon, Nov 30, 2009 at 3:59 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi Jens,
> > [snip]
> > TODO
> > ====
> > - Direct random writers seem to be very fickle in terms of workload
> >  classification. They seem to be switching between sync-idle and sync-noidle
> >  workload type in a little unpredictable manner. Debug and fix it.
> >
> 
> Are you still experiencing erratic behaviour after my patches were
> integrated in for-2.6.33?

Your patches helped with deep seeky queues. But if I am running a random
writer with default iodepth of 1 (without libaio), I still see that idle
0/1 flipping happens so frequently during 30 seconds duration of
execution. 

As per CFQ classification definition, a seeky random writer with shallow
depth should be classified as sync-noidle and stay there until and unless
workload changes its nature. But that does not seem to be happening.

Just try two fio random writers and monitor the blktrace and see how
freqently we enable and disable idle on the queues.

> 
> > - Support async IO control (buffered writes).
> I was thinking about this.
> Currently, writeback can either be issued by a kernel daemon (when
> actual dirty ratio is > background dirty ratio, but < dirty_ratio) or
> from various processes, if the actual dirty ratio is > dirty ratio.

- If dirty_ratio > background_dirty_ratio, then a process will be
  throttled and it can do one of the following actions.

	- Pick one inode and start flushing its dirty pages. Now these
	  pages could have been dirtied by another process in another
	  group.

	- It might just wait for flusher threads to flush some pages and
	  sleep for that duration.

> Could the writeback issued in the context of a process be marked as sync?
> In this way:
> * normal writeback when system is not under pressure will run in the
> root group, without interferring with sync workload
> * the writeback issued when we have high dirty ratio will have more
> priority, so the system will return in a normal condition quicker.

Marking async IO submitted in the context of processes and not kernel
threads is interesting. We could try that, but in general the processes
that are being throttled are doing buffered writes and generally these
are not very latency sensitive.

Group stuff apart, I would rather think of providing consistent share to
async workload. So that when there is lots of sync as well async IO is
going on in the system, nobody starves and we provide access to disk in
a deterministic manner.

That's why I do like the idea of fixing a workload share of async
workload so that async workload does not starve in the face of lot of sync
IO going on. Not sure how effectively it is working though.

Thanks
Vivek


> * your code will work out of the box, in fact processes with lower
> weight will complete less I/O, therefore they will be slowed down more
> than higher weight ones.
> 
> >
> >  Buffered writes is a beast and requires changes at many a places to solve the
> >  problem and patchset becomes huge. Hence first we plan to support only sync
> >  IO in control then work on async IO too.
> >
> >  Some of the work items identified are.
> >
> >        - Per memory cgroup dirty ratio
> >        - Possibly modification of writeback to force writeback from a
> >          particular cgroup.
> >        - Implement IO tracking support so that a bio can be mapped to a cgroup.
> >        - Per group request descriptor infrastructure in block layer.
> >        - At CFQ level, implement per cfq_group async queues.
> >
> >  In this patchset, all the async IO goes in system wide queues and there are
> >  no per group async queues. That means we will see service differentiation
> >  only for sync IO only. Async IO willl be handled later.
> >
> > - Support for higher level policies like max BW controller.
> > - Support groups of RT class also.
> 
> Thanks,
> Corrado
