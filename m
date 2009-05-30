Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbZE3PEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbZE3PEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 11:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbZE3PEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 11:04:38 -0400
Received: from bene2.itea.ntnu.no ([129.241.56.57]:35734 "EHLO
	bene2.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907AbZE3PEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 11:04:37 -0400
X-Greylist: delayed 5395 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 May 2009 11:04:37 EDT
Date: Sat, 30 May 2009 17:04:38 +0200
From: Henrik Austad <henrik@austad.us>
To: GeunSik Lim <leemgs1@gmail.com>
Cc: finarfin@dreamos.org, linux-kernel@vger.kernel.org
Subject: Re: SCHED_EDF infos
Message-ID: <20090530150438.GB11337@alecto.austad.us>
References: <164c92d827cbee86ba2c5621716309e6@localhost> <200904300939.31754.henrik@austad.us> <49b7c2350905071935kbd2aa22v9d39cf41c537c24b@mail.gmail.com> <20090508091052.GA10429@januz.myftp.org> <49b7c2350905300438n6195de93la53bee3a309f71d@mail.gmail.com> <20090530133441.GA11337@alecto.austad.us> <49b7c2350905300746v38d6597eu82b7fcc99813080f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49b7c2350905300746v38d6597eu82b7fcc99813080f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 11:46:43PM +0900, GeunSik Lim wrote:
> On Sat, May 30, 2009 at 10:34 PM, Henrik Austad <henrik@austad.us> wrote:
> >> Can you share EDF that you implemented with P-fair for Multicore environments?
> >> Especially, I wonder How do you keep posix compatibility with EDF scheduler.
> >
> > Well, what exactly do you mean by posix compatibility? What I'm doing, is adding

> This means that We can use  realtime programming for EDF effectiveness with
> current system call interface without new system call interface.

Well, as I said, at the moment I'm at the 'making it work'-stage, so adding 
features to the existing syscalls is not really something I'm prepared to do :-)

> > another scheduling class on top of sched_rt so that sched_pfair will be polled
> > before any other class. I was not aware that POSIX had an EDF standard?

> POSIX describes common real-time specification  without EDF, RMS ,
> Resource Reservation, etc.
> Belows is the Linux Standard Base (LSB) specifications for Linux Distributions.
> http://www.linuxfoundation.org/en/Specifications

Hoh, that was a lot of 'requried reading' :-s I'll try to have a look at it 
soon.

> >> For example,
> >> sched_setscheduler(2), sched_getscheduler(2),
> >> sched_get_priority_max(2), sched_get_priority_min(2),
> >> sched_getaffinity(2), sched_setaffinity(2),
> >> sched_getparam(2), sched_setparam(2),
> >> setpriority(2), getpriority(2),
> >> sched_yield(2), sched_rr_get_interval(2)
> >
> > I introduce 3 new syscalls for modifying the tasks.
> >
> >  sched_pfair_update()
> >  - change an existing task into a pfair task, set attributes, calculate subjob
> >   values etc
> >
> >  sched_pfair_release()
> >  - release the task, i.e. enable it to run on a CPU.
> >
> >  sched_pfair_reweigh()
> >  - change the attributes of the task. In a lot of ways, this is very similar to
> >   pfair_update, but it introduces some problems when trying to reweigh a task
> >   that is running, or if the new values lead to over-utilization of the system.

> When we try to userspace realtime programming, How can we insert  systemcall api
> with posix compatibility.

At the moment, I've created a new sched-param struct:

struct sched_pfair_params {
        u64 period_ns;
        u64 wcet_ns;
        u64 deadline_ns;
        u64 release_ns;
        u8 periodic:1;
};

so I can add this via a single variable to the syscalls.

> Um... In general, we use
> sched_setscheduler    (struct task_struct *p, int policy,  struct
> sched_param *param) api.

yes, I know, but I *really* didn't want to meddle with the exisint interface, so 
atm, I've just added my own syscalls.

> If we will make  EDF related u/s rt programming, How do we have to
> insert deadline of tasks
> for EDF performance?
> sched_setscheduler_EDF(struct task_struct *p, int policy, period-time
> , runtime)
> or
> 
> struct sched_param {
>        int sched_priority;
>       <timespec edf-period-time>;
>       <timespec edf-runtiome>;
> };

Could be, I guess this is up for debate. Having a dedicated structure for this 
is not good, but I hope my reason above can explain why it is like this at the 
moment.


henrik
