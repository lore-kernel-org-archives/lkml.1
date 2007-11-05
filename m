Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbXKEBaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbXKEBaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 20:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbXKEBas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 20:30:48 -0500
Received: from mga10.intel.com ([192.55.52.92]:49667 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753168AbXKEBar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 20:30:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,369,1188802800"; 
   d="scan'208";a="369327749"
Subject: Re: aim7 -30% regression in 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Cyrus Massoumi <cyrusm@gmx.net>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4729A453.4080803@gmx.net>
References: <1193391787.3019.174.camel@ymzhang>
	 <20071026112307.GA30406@elte.hu> <1193624538.3019.189.camel@ymzhang>
	 <1193650626.3019.198.camel@ymzhang> <1193710325.3019.203.camel@ymzhang>
	 <20071030072658.GB20372@elte.hu>  <1193733390.3019.210.camel@ymzhang>
	 <1193824668.3019.236.camel@ymzhang> <1193909669.3019.246.camel@ymzhang>
	 <4729A453.4080803@gmx.net>
Content-Type: text/plain; charset=utf-8
Date: Mon, 05 Nov 2007 09:24:24 +0800
Message-Id: <1194225864.3019.254.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 11:02 +0100, Cyrus Massoumi wrote:
> Zhang, Yanmin wrote:
> > On Wed, 2007-10-31 at 17:57 +0800, Zhang, Yanmin wrote:
> >> On Tue, 2007-10-30 at 16:36 +0800, Zhang, Yanmin wrote:
> >>> On Tue, 2007-10-30 at 08:26 +0100, Ingo Molnar wrote:
> >>>> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> >>>>
> >>>>> sub-bisecting captured patch 
> >>>>> 38ad464d410dadceda1563f36bdb0be7fe4c8938(sched: uniform tunings) 
> >>>>> caused 20% regression of aim7.
> >>>>>
> >>>>> The last 10% should be also related to sched parameters, such like 
> >>>>> sysctl_sched_min_granularity.
> >>>> ah, interesting. Since you have CONFIG_SCHED_DEBUG enabled, could you 
> >>>> please try to figure out what the best value for 
> >>>> /proc/sys/kernel_sched_latency, /proc/sys/kernel_sched_nr_latency and 
> >>>> /proc/sys/kernel_sched_min_granularity is?
> >>>>
> >>>> there's a tuning constraint for kernel_sched_nr_latency: 
> >>>>
> >>>> - kernel_sched_nr_latency should always be set to 
> >>>>   kernel_sched_latency/kernel_sched_min_granularity. (it's not a free 
> >>>>   tunable)
> >>>>
> >>>> i suspect a good approach would be to double the value of 
> >>>> kernel_sched_latency and kernel_sched_nr_latency in each tuning 
> >>>> iteration, while keeping kernel_sched_min_granularity unchanged. That 
> >>>> will excercise the tuning values of the 2.6.23 kernel as well.
> >>> I followed your idea to test 2.6.24-rc1. The improvement is slow.
> >>> When sched_nr_latency=2560 and sched_latency_ns=640000000, the performance
> >>> is still about 15% less than 2.6.23.
> >> I got the aim7 30% regression on my new upgraded stoakley machine. I found
> >> this mahcine is slower than the old one. Maybe BIOS has issues, or memeory(Might not
> >> be dual-channel?) is slow. So I retested it on the old machine and found on the old
> >> stoakley machine, the regression is about 6%, quite similiar to the regression on tigerton
> >> machine.
> >>
> >> By sched_nr_latency=640 and sched_latency_ns=640000000 on the old stoakley machine,
> >> the regression becomes about 2%. Other latency has more regression.
> >>
> >> On my tulsa machine, by sched_nr_latency=640 and sched_latency_ns=640000000,
> >> the regression becomes less than 1% (The original regression is about 20%).
> > I rerun SPECjbb by ched_nr_latency=640 and sched_latency_ns=640000000. On tigerton,
> > the regression is still more than 40%. On stoakley machine, it becomes worse (26%,
> > original is 9%). I will do more investigation to make sure SPECjbb regression is
> > also casued by the bad default values.
> > 
> > We need a smarter method to calculate the best default values for the key tuning
> > parameters.
> > 
> > One interesting is sysbench+mysql(readonly) got the same result like 2.6.22 (no
> > regression). Good job!
> 
> Do you mean you couldn't reproduce the regression which was reported 
> with 2.6.23 (http://lkml.org/lkml/2007/10/30/53) with 2.6.24-rc1?
It looks like you missed my emails.

Firstly, I reproduced (or just find the same myself :) ) the issue with kernel 2.6.22,
2.6.23-rc and 2.6.23.

Ingo wrote a big patch to fix it and the new patch is in 2.6.24-rc1 now.

Then I retested it with 2.6.24-rc1 on a couple of x86_64 machines. The issue
disappeared. You could test it with 2.6.24-rc1.

>  It 
> would be nice if you could provide some numbers for 2.6.22, 2.6.23 and 
> 2.6.24-rc1.
Sorry. Intel policy doesn't allow me to publish the numbers because only
specific departments in Intel could do that. But I could talk the regression
percentage.

-yanmin
