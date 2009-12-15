Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbZLOVAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbZLOVAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760428AbZLOVA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:00:29 -0500
Received: from smtp-out.google.com ([216.239.33.17]:23580 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760417AbZLOVA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:00:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ASEbyO4Nuiouxh2I5NdbhHh4eHC6PutA+yhmks0RcJ/g+6IZSSmSV8ycXwbjX4wcD
	5Ic4NlVA+L2/ryQJvYO1g==
MIME-Version: 1.0
In-Reply-To: <20091215115052.GB878@dirshya.in.ibm.com>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
	 <20091214161922.6f252492@infradead.org>
	 <4352991a0912141636t35a96c14o5fd4b9e152e6e681@mail.gmail.com>
	 <20091215102909.GA878@dirshya.in.ibm.com>
	 <20091215115052.GB878@dirshya.in.ibm.com>
Date: Tue, 15 Dec 2009 13:00:21 -0800
Message-ID: <4352991a0912151300x142f9233ua75c2264f9e0bc79@mail.gmail.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the 
	Linux Kernel
From: Salman Qazi <sqazi@google.com>
To: svaidy@linux.vnet.ibm.com
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 3:50 AM, Vaidyanathan Srinivasan
<svaidy@linux.vnet.ibm.com> wrote:
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2009-12-15 15:59:09]:
>
>> * Salman Qazi <sqazi@google.com> [2009-12-14 16:36:20]:
>>
>> > On Mon, Dec 14, 2009 at 4:19 PM, Arjan van de Ven <arjan@infradead.org> wrote:
>> > > On Mon, 14 Dec 2009 15:11:47 -0800
>> > > Salman Qazi <sqazi@google.com> wrote:
>> > >
>> > >
>> > > I like the general idea, I have one request (that I didn't see quite in
>> > > your explanation): Please make sure that all cpus in the system do
>> > > their idle injection at the same time, so that memory can go into power
>> > > saving mode as well during this time etc etc...
>> > >
>>
>> The value of the overall idea is well understood but the
>> implementation and benefits in terms of power savings was the major
>> point of discussion earlier.
>>
>> > With the current interface, the forced idle percentages on the CPUs
>> > are controlled independently.  There's a trade-off here.  If we inject
>> > idle cycles on all the CPU at the same time, our machine
>> > responsiveness also degrades: essentially every CPU becomes equally
>> > bad for an interactive task to run on.  Our aim at the moment is to
>> > try to concentrate the idle cycles on a small set of CPUs, to strive
>> > to leave some CPUs where interactive tasks can run unhindered.  But,
>> > given a different workload and goals the correct policy may be
>> > different.
>> >
>> > Simultaneously idling multiple "cores" becomes necessary in the SMT
>> > case: as there is no point in idling a single thread, while the other
>> > thread is running full tilt.  So, in such a case it is necessary to
>> > idle all the threads making up the physical core.  This feature has
>> > not been implemented yet.
>> >
>> > I think the best approach may be to provide a way to specify the
>> > policy from the user space.  Basically let the user decide at what
>> > level of CPU hierarchy the forced idle percentages are specified.
>> > Then, in the levels below, we simply inject at the same time.
>>
>> Synchronising the idle times across multiple cores and also selecting
>> sibling threads belonging to the same core is important.  The current
>> ACPI forced idle driver can inject idle time but not synchronized
>> across multiple cores.
>>
>> Allowing the scheduler load balancer to avoid using a part of the
>> sched domain tree will allow easy grouping of sibling threads and
>> sibling cores if that saves more power.
>>
>> However as Arjan mentioned, new architectures have significant power
>> savings at full system idle where memory power is reduced.  Injecting
>> idle time in any of the core will actually increase the utilisation on
>> the other cores (unless the system is full loaded) and reduce the full
>> system idle time opportunity.  Basically injecting idle time on some
>> of the cores in the system goes against the race-to-idle policy
>> thereby decreasing overall system operating efficiency.
>>
>> Can you please clarify the following questions:
>>
>> * What is the typical duration of idle time injected?
>>         - 10s of milli seconds?  CPUs are expected to goto lowest
>>           power idle state within this time?
>>
>> * You mentioned that natural idle time in the system is taken into
>>   account before injecting forced idle time, which is a good feature
>>   to have.
>>         - In most workloads, as the utilisation drops, all the cpus
>>           have similar idle times.  This is favourable for exploiting
>>           memory power saving.
>>         - Now when more idle time need to be inserted, is it
>>           uniformly spread across all CPUs?
>
> * How is the fairness issue in the scheduler handled?  Inserting idle
>  time may affect interactivity and fairness badly.

As mentioned in the design, we have two features to make this work.
First, we have "Eager Injection" phase, where we do not let any batch
tasks run but permit interactive tasks to run.  This phase lasts until
we are either sure that we have enough idle cycles (in which case
everyone is free to run) or we are sure that we have to spend the rest
of the interval injecting.  This latter scenario is called the lazy
injection phase.

Second, we have "power capping priority", a per-cgroup value which
determines the order in which the "blame" is assigned for the injected
cycles.  For the purposes of scheduling decisions, we pretend that the
lowest power capping priority job was running when we were injecting
idle cycles.  If the lowest priority job did not deserve sufficient
run time in the period in question, then we move to the next higher
priority job and so on.  Thus, we penalize the jobs in the power
capping priority order for the time spent injecting idle cycles.  This
allows us to make sure that important jobs get to use the available
power, and the less important jobs are the first to suffer.

>
> --Vaidy
>
