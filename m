Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbZJCNjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbZJCNjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932124AbZJCNjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:39:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336AbZJCNjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:39:02 -0400
Date: Sat, 3 Oct 2009 09:38:10 -0400
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
Subject: Do we support ioprio on SSDs with NCQ (Was: Re: IO scheduler based
	IO controller V10)
Message-ID: <20091003133810.GC12925@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com> <20091002124921.GA4494@redhat.com> <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com> <1254497520.10392.11.camel@marge.simson.net> <20091002154020.GC4494@redhat.com> <12774.1254502217@turing-police.cc.vt.edu> <20091002195815.GE4494@redhat.com> <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com> <20091002222756.GG4494@redhat.com> <4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 02:43:14PM +0200, Corrado Zoccolo wrote:
> On Sat, Oct 3, 2009 at 12:27 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Sat, Oct 03, 2009 at 12:14:28AM +0200, Corrado Zoccolo wrote:
> >> In fact I think that the 'rotating' flag name is misleading.
> >> All the checks we are doing are actually checking if the device truly
> >> supports multiple parallel operations, and this feature is shared by
> >> hardware raids and NCQ enabled SSDs, but not by cheap SSDs or single
> >> NCQ-enabled SATA disk.
> >>
> >
> > While we are at it, what happens to notion of priority of tasks on SSDs?
> This is not changed by proposed patch w.r.t. current CFQ.

This is a general question irrespective of current patch. Want to know
what is our statement w.r.t ioprio and what it means for user? When do
we support it and when do we not.

> > Without idling there is not continuous time slice and there is no
> > fairness. So ioprio is out of the window for SSDs?
> I haven't NCQ enabled SSDs here, so I can't test it, but it seems to
> me that the way in which queues are sorted in the rr tree may still
> provide some sort of fairness and service differentiation for
> priorities, in terms of number of IOs.

I have a NCQ enabled SSD. Sometimes I see the difference sometimes I do
not. I guess this happens because sometimes idling is enabled and sometmes
not because of dyanamic nature of hw_tag.

I ran three fio reads for 10 seconds. First job is prio0, second prio4 and
third prio7.

(prio 0) read : io=978MiB, bw=100MiB/s, iops=25,023, runt= 10005msec
(prio 4) read : io=953MiB, bw=99,950KiB/s, iops=24,401, runt= 10003msec
(prio 7) read : io=74,228KiB, bw=7,594KiB/s, iops=1,854, runt= 10009msec

Note there is almost no difference between prio 0 and prio 4 job and prio7
job has been penalized heavily (gets less than 10% BW of prio 4 job).

> Non-NCQ SSDs, instead, will still have the idle window enabled, so it
> is not an issue for them.

Agree.

> >
> > On SSDs, will it make more sense to provide fairness in terms of number or
> > IO or size of IO and not in terms of time slices.
> Not on all SSDs. There are still ones that have a non-negligible
> penalty on non-sequential access pattern (hopefully the ones without
> NCQ, but if we find otherwise, then we will have to benchmark access
> time in I/O scheduler to select the best policy). For those, time
> based may still be needed.

Ok.

So on better SSDs out there with NCQ, we probably don't support the notion of
ioprio? Or, I am missing something.

Thanks
Vivek
