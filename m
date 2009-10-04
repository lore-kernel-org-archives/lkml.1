Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZJDMM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZJDMM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 08:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZJDMM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 08:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZJDMM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 08:12:57 -0400
Date: Sun, 4 Oct 2009 08:11:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, Mike Galbraith <efault@gmx.de>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: Do we support ioprio on SSDs with NCQ (Was: Re: IO scheduler
	based IO controller V10)
Message-ID: <20091004121122.GB18778@redhat.com>
References: <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com> <1254497520.10392.11.camel@marge.simson.net> <20091002154020.GC4494@redhat.com> <12774.1254502217@turing-police.cc.vt.edu> <20091002195815.GE4494@redhat.com> <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com> <20091002222756.GG4494@redhat.com> <4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com> <20091003133810.GC12925@redhat.com> <4e5e476b0910040215m35af5c99pf2c3a463a5cb61dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0910040215m35af5c99pf2c3a463a5cb61dd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 11:15:24AM +0200, Corrado Zoccolo wrote:
> Hi Vivek,
> On Sat, Oct 3, 2009 at 3:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Sat, Oct 03, 2009 at 02:43:14PM +0200, Corrado Zoccolo wrote:
> >> On Sat, Oct 3, 2009 at 12:27 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Sat, Oct 03, 2009 at 12:14:28AM +0200, Corrado Zoccolo wrote:
> >> >> In fact I think that the 'rotating' flag name is misleading.
> >> >> All the checks we are doing are actually checking if the device truly
> >> >> supports multiple parallel operations, and this feature is shared by
> >> >> hardware raids and NCQ enabled SSDs, but not by cheap SSDs or single
> >> >> NCQ-enabled SATA disk.
> >> >>
> >> >
> >> > While we are at it, what happens to notion of priority of tasks on SSDs?
> >> This is not changed by proposed patch w.r.t. current CFQ.
> >
> > This is a general question irrespective of current patch. Want to know
> > what is our statement w.r.t ioprio and what it means for user? When do
> > we support it and when do we not.
> >
> >> > Without idling there is not continuous time slice and there is no
> >> > fairness. So ioprio is out of the window for SSDs?
> >> I haven't NCQ enabled SSDs here, so I can't test it, but it seems to
> >> me that the way in which queues are sorted in the rr tree may still
> >> provide some sort of fairness and service differentiation for
> >> priorities, in terms of number of IOs.
> >
> > I have a NCQ enabled SSD. Sometimes I see the difference sometimes I do
> > not. I guess this happens because sometimes idling is enabled and sometmes
> > not because of dyanamic nature of hw_tag.
> >
> My guess is that the formula that is used to handle this case is not
> very stable.

In general I agree that formula to calculate the slice offset is very 
puzzling as busy_queues varies and that changes the position of the task
sometimes.

> The culprit code is (in cfq_service_tree_add):
>         } else if (!add_front) {
>                 rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
>                 rb_key += cfqq->slice_resid;
>                 cfqq->slice_resid = 0;
>         } else
> 
> cfq_slice_offset is defined as:
> 
> static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
>                                       struct cfq_queue *cfqq)
> {
>         /*
>          * just an approximation, should be ok.
>          */
> 	return (cfqd->busy_queues - 1) * (cfq_prio_slice(cfqd, 1, 0) -
>                        cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
> }
> 
> Can you try changing the latter to a simpler (we already observed that
> busy_queues is unstable, and I think that here it is not needed at
> all):
> 	return -cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
> and remove the 'rb_key += cfqq->slice_resid; ' from the former.
> 
> This should give a higher probability of being first on the queue to
> larger slice tasks, so it will work if we don't idle, but it needs
> some adjustment if we idle.

I am not sure what's the intent here by removing busy_queues stuff. I have
got two questions though.

- Why don't we keep it simple round robin where a task is simply placed at
  the end of service tree.

- Secondly, CFQ provides full slice length to queues only which are
  idling (in case of sequenatial reader). If we do not enable idling, as
  in case of NCQ enabled SSDs, then CFQ will expire the queue almost 
  immediately and put the queue at the end of service tree (almost).

So if we don't enable idling, at max we can provide fairness, we
esseitially just let every queue dispatch one request and put  at the end
of the end of service tree. Hence no fairness....

Thanks
Vivek

> 
> > I ran three fio reads for 10 seconds. First job is prio0, second prio4 and
> > third prio7.
> >
> > (prio 0) read : io=978MiB, bw=100MiB/s, iops=25,023, runt= 10005msec
> > (prio 4) read : io=953MiB, bw=99,950KiB/s, iops=24,401, runt= 10003msec
> > (prio 7) read : io=74,228KiB, bw=7,594KiB/s, iops=1,854, runt= 10009msec
> >
> > Note there is almost no difference between prio 0 and prio 4 job and prio7
> > job has been penalized heavily (gets less than 10% BW of prio 4 job).
> >
> >> Non-NCQ SSDs, instead, will still have the idle window enabled, so it
> >> is not an issue for them.
> >
> > Agree.
> >
> >> >
> >> > On SSDs, will it make more sense to provide fairness in terms of number or
> >> > IO or size of IO and not in terms of time slices.
> >> Not on all SSDs. There are still ones that have a non-negligible
> >> penalty on non-sequential access pattern (hopefully the ones without
> >> NCQ, but if we find otherwise, then we will have to benchmark access
> >> time in I/O scheduler to select the best policy). For those, time
> >> based may still be needed.
> >
> > Ok.
> >
> > So on better SSDs out there with NCQ, we probably don't support the notion of
> > ioprio? Or, I am missing something.
> 
> I think we try, but the current formula is simply not good enough.
> 
> Thanks,
> Corrado
> 
> >
> > Thanks
> > Vivek
> >
> 
> 
> 
> -- 
> __________________________________________________________________________
> 
> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
> PhD - Department of Computer Science - University of Pisa, Italy
> --------------------------------------------------------------------------
> The self-confidence of a warrior is not the self-confidence of the average
> man. The average man seeks certainty in the eyes of the onlooker and calls
> that self-confidence. The warrior seeks impeccability in his own eyes and
> calls that humbleness.
>                                Tales of Power - C. Castaneda
