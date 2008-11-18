Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbYKRXk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbYKRXk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 18:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYKRXku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 18:40:50 -0500
Received: from ms01.sssup.it ([193.205.80.99]:42486 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751737AbYKRXkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:40:49 -0500
Date: Wed, 19 Nov 2008 00:44:04 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Nauman Rafique <nauman@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
       Divyesh Shah <dpshah@google.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com,
       akpm@linux-foundation.org, menage@google.com, ngupta@google.com,
       riel@redhat.com, jmoyer@redhat.com, peterz@infradead.org,
       paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081118234404.GI15268@gandalf.sssup.it>
References: <af41c7c40811131041t1b8491b6la5574ebe75f89000@mail.gmail.com> <20081113214642.GG7542@redhat.com> <af41c7c40811131457w472e4a86tb5344cc1d3d366fb@mail.gmail.com> <20081114160525.GE24624@redhat.com> <e98e18940811141444u5947b806v27fac453ed1e8a5@mail.gmail.com> <20081117142309.GA15564@redhat.com> <4922224A.5030502@cn.fujitsu.com> <e98e18940811172101na345b6bh5c73f9e657aac5a7@mail.gmail.com> <20081118120508.GD15268@gandalf.sssup.it> <e98e18940811181433o4bb5a147i1e0b9c1baf495ae2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e98e18940811181433o4bb5a147i1e0b9c1baf495ae2@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nauman Rafique <nauman@google.com>
> Date: Tue, Nov 18, 2008 02:33:19PM -0800
>
> On Tue, Nov 18, 2008 at 4:05 AM, Fabio Checconi <fchecconi@gmail.com> wrote:
...
> >  it should be possible without altering the code.  The slices can be
> > assigned in the time domain using big values for max_budget.  The logic
> > is: each process is assigned a budget (in the range [max_budget/2, max_budget],
> > choosen from the feedback mechanism, driven in __bfq_bfqq_recalc_budget()),
> > and if it does not complete it in timeout_sync milliseconds, it is
> > charged a fixed amount of sectors of service.
> >
> > Using big values for max_budget (where big means greater than two
> > times the number of sectors the hard drive can transfer in timeout_sync
> > milliseconds) makes the budgets always to time out, so the disk time
> > is scheduled in slices of timeout_sync.
> >
> > However this is just a temporary workaround to do some basic testing.
> >
> > Modifying the scheduler to support time slices instead of sector
> > budgets would indeed simplify the code; I think that the drawback
> > would be being too unfair in the service domain.  Of course we
> > have to consider how much is important to be fair in the service
> > domain, and how much added complexity/new code can we accept for it.
> >
> > [ Better service domain fairness is one of the main reasons why
> >  we started working on bfq, so, talking for me and Paolo it _is_
> >  important :) ]
> >
> > I have to think a little bit on how it would be possible to support
> > an option for time-only budgets, coexisting with the current behavior,
> > but I think it can be done.
> 
> I think "time only budget" vs "sector budget" is dependent on the
> definition of fairness: do you want to be fair in the time that is
> given to each cgroup or fair in total number of sectors transferred.
> And the appropriate definition of fairness depends on how/where the IO
> scheduler is used.  Do you think the work-around that you mentioned
> would have a significant performance difference compared to direct
> built-in support?
> 

In terms of throughput, it should not have any influence, since tasks
would always receive a full timeslice.  In terms of latency it would
bypass completely the feedback mechanism, and that would have a
negative impact (basically the scheduler would not be able to
differentiate between tasks with the same weight but with different
interactivity needs).

In terms of service fairness it is a little bit hard to say, but I
would not expect anything near to what can be done with a service domain
approach, independently from the scheduler used.
