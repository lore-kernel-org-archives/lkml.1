Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbZK3WAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbZK3WAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZK3WAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:00:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZK3WAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:00:12 -0500
Date: Mon, 30 Nov 2009 16:58:18 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, Alan.Brunelle@hp.com
Subject: Re: Block IO Controller V4
Message-ID: <20091130215818.GJ11670@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <4e5e476b0911300734h34a22c88oa5d7d4e5642ead50@mail.gmail.com> <20091130160024.GD11670@redhat.com> <4e5e476b0911301334o2440ea8fi7444aa7d5a688ed1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911301334o2440ea8fi7444aa7d5a688ed1@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 10:34:32PM +0100, Corrado Zoccolo wrote:
> On Mon, Nov 30, 2009 at 5:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, Nov 30, 2009 at 04:34:36PM +0100, Corrado Zoccolo wrote:
> >> Hi Vivek,
> >> On Mon, Nov 30, 2009 at 3:59 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > Hi Jens,
> >> > [snip]
> >> > TODO
> >> > ====
> >> > - Direct random writers seem to be very fickle in terms of workload
> >> >  classification. They seem to be switching between sync-idle and sync-noidle
> >> >  workload type in a little unpredictable manner. Debug and fix it.
> >> >
> >>
> >> Are you still experiencing erratic behaviour after my patches were
> >> integrated in for-2.6.33?
> >
> > Your patches helped with deep seeky queues. But if I am running a random
> > writer with default iodepth of 1 (without libaio), I still see that idle
> > 0/1 flipping happens so frequently during 30 seconds duration of
> > execution.
> Ok. This is probably because the average seek goes below the threshold.
> You can try a larger file, or reducing the threshold.

Yes, sometimes average seek goes below threshold. Default seek mean threshold
is 8K. If I launch a random writer using fio on a 2G file, many a times it
gets classified as sync-idle workload and sometimes as sync-noidle
workload. Looks like write pattern generated is not as random all the time
to cross seek thresold in case of random writes. In case of random reads, I saw
they always got classified as sync-noidle.
 
During one run when I launched two random writers, one process accessed some
really low address sector and then high address sector. Its seek mean got
boosted so much to begin with that it took long time for seek_mean to come
down and till then process was sync-noidle. On the contrast other process
running had seek_mean less than threshold and was classified as sync-idle
process.  As randome writers were coming with rq_noidle=1, we were idling
on one random writer and not other and hence they got different BW. But it
does not happen all the time. 

So it seems to be a combination of multiple things. 

> >
> > As per CFQ classification definition, a seeky random writer with shallow
> > depth should be classified as sync-noidle and stay there until and unless
> > workload changes its nature. But that does not seem to be happening.
> >
> > Just try two fio random writers and monitor the blktrace and see how
> > freqently we enable and disable idle on the queues.
> >
> >>
> >> > - Support async IO control (buffered writes).
> >> I was thinking about this.
> >> Currently, writeback can either be issued by a kernel daemon (when
> >> actual dirty ratio is > background dirty ratio, but < dirty_ratio) or
> >> from various processes, if the actual dirty ratio is > dirty ratio.
> >
> > - If dirty_ratio > background_dirty_ratio, then a process will be
> >  throttled and it can do one of the following actions.
> >
> >        - Pick one inode and start flushing its dirty pages. Now these
> >          pages could have been dirtied by another process in another
> >          group.
> >
> >        - It might just wait for flusher threads to flush some pages and
> >          sleep for that duration.
> >
> >> Could the writeback issued in the context of a process be marked as sync?
> >> In this way:
> >> * normal writeback when system is not under pressure will run in the
> >> root group, without interferring with sync workload
> >> * the writeback issued when we have high dirty ratio will have more
> >> priority, so the system will return in a normal condition quicker.
> >
> > Marking async IO submitted in the context of processes and not kernel
> > threads is interesting. We could try that, but in general the processes
> > that are being throttled are doing buffered writes and generally these
> > are not very latency sensitive.
> If we have too much dirty memory, then allocations could depend on freeing
> some pages, so this would become latency sensitive. In fact, it seems that
> the 2.6.32 low_latency patch is hurting some workloads in low memory scenarios.
> 2.6.33 provides improvements for async writes, but if writeback could
> become sync
> when dirty ratio is too high, we could have a better response to such
> extreme scenarios.

Ok, that makes sense. So we do have a fixed share of async workoad
(proportionate to number of queues). But that does not seem to be enough
when other sync IO is going on and we are low on memory. In that case,
marking async writes submitted by user space processes as sync, should
help. Try it out. The only thing to watch for is that we don't overdo it
and it does not impact sync workload a lot. Only trial and testing will
help. :-) 

> 
> >
> > Group stuff apart, I would rather think of providing consistent share to
> > async workload. So that when there is lots of sync as well async IO is
> > going on in the system, nobody starves and we provide access to disk in
> > a deterministic manner.
> >
> > That's why I do like the idea of fixing a workload share of async
> > workload so that async workload does not starve in the face of lot of sync
> > IO going on. Not sure how effectively it is working though.
> I described how the current patch work in an other mail.

Yep, that point is clear now.

Thanks
Vivek
