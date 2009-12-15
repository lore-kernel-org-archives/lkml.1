Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbZLOLun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbZLOLun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759990AbZLOLud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:50:33 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56283 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000AbZLOLub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:50:31 -0500
Date: Tue, 15 Dec 2009 17:20:52 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Salman Qazi <sqazi@google.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the
 Linux Kernel
Message-ID: <20091215115052.GB878@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
 <20091214161922.6f252492@infradead.org>
 <4352991a0912141636t35a96c14o5fd4b9e152e6e681@mail.gmail.com>
 <20091215102909.GA878@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091215102909.GA878@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2009-12-15 15:59:09]:

> * Salman Qazi <sqazi@google.com> [2009-12-14 16:36:20]:
> 
> > On Mon, Dec 14, 2009 at 4:19 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> > > On Mon, 14 Dec 2009 15:11:47 -0800
> > > Salman Qazi <sqazi@google.com> wrote:
> > >
> > >
> > > I like the general idea, I have one request (that I didn't see quite in
> > > your explanation): Please make sure that all cpus in the system do
> > > their idle injection at the same time, so that memory can go into power
> > > saving mode as well during this time etc etc...
> > >
> 
> The value of the overall idea is well understood but the
> implementation and benefits in terms of power savings was the major
> point of discussion earlier. 
> 
> > With the current interface, the forced idle percentages on the CPUs
> > are controlled independently.  There's a trade-off here.  If we inject
> > idle cycles on all the CPU at the same time, our machine
> > responsiveness also degrades: essentially every CPU becomes equally
> > bad for an interactive task to run on.  Our aim at the moment is to
> > try to concentrate the idle cycles on a small set of CPUs, to strive
> > to leave some CPUs where interactive tasks can run unhindered.  But,
> > given a different workload and goals the correct policy may be
> > different.
> > 
> > Simultaneously idling multiple "cores" becomes necessary in the SMT
> > case: as there is no point in idling a single thread, while the other
> > thread is running full tilt.  So, in such a case it is necessary to
> > idle all the threads making up the physical core.  This feature has
> > not been implemented yet.
> > 
> > I think the best approach may be to provide a way to specify the
> > policy from the user space.  Basically let the user decide at what
> > level of CPU hierarchy the forced idle percentages are specified.
> > Then, in the levels below, we simply inject at the same time.
> 
> Synchronising the idle times across multiple cores and also selecting
> sibling threads belonging to the same core is important.  The current
> ACPI forced idle driver can inject idle time but not synchronized
> across multiple cores.
> 
> Allowing the scheduler load balancer to avoid using a part of the
> sched domain tree will allow easy grouping of sibling threads and
> sibling cores if that saves more power.
> 
> However as Arjan mentioned, new architectures have significant power
> savings at full system idle where memory power is reduced.  Injecting
> idle time in any of the core will actually increase the utilisation on
> the other cores (unless the system is full loaded) and reduce the full
> system idle time opportunity.  Basically injecting idle time on some
> of the cores in the system goes against the race-to-idle policy
> thereby decreasing overall system operating efficiency.
> 
> Can you please clarify the following questions:
> 
> * What is the typical duration of idle time injected?
>         - 10s of milli seconds?  CPUs are expected to goto lowest
>           power idle state within this time?
> 
> * You mentioned that natural idle time in the system is taken into
>   account before injecting forced idle time, which is a good feature
>   to have.
>         - In most workloads, as the utilisation drops, all the cpus
>           have similar idle times.  This is favourable for exploiting
>           memory power saving.  
>         - Now when more idle time need to be inserted, is it
>           uniformly spread across all CPUs?

* How is the fairness issue in the scheduler handled?  Inserting idle
  time may affect interactivity and fairness badly.

--Vaidy
