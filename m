Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbYE0OEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbYE0OEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbYE0OD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:03:56 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:45996 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbYE0ODz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:03:55 -0400
Date: Tue, 27 May 2008 19:34:40 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, Michael Neuling <mikey@neuling.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080527140440.GD5181@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
	Michael Neuling <mikey@neuling.org>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080526085000.33787eac@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@infradead.org> [2008-05-26 08:50:00]:

> On Mon, 26 May 2008 20:01:33 +0530
> Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > The following RFC patch tries to implement scaled CPU utilisation
> > statistics using APERF and MPERF MSR registers in an x86 platform.
> > 
> > The CPU capacity is significantly changed when the CPU's frequency is
> > reduced for the purpose of power savings.  The applications that run
> > at such lower CPU frequencies are also accounted for real CPU time by
> > default.  If the applications have been run at full CPU frequency,
> > they would have finished the work faster and not get charged for
> > excessive CPU time.
> > 
> > One of the solution to this problem it so scale the utime and stime
> > entitlement for the process as per the current CPU frequency.  This
> > technique is used in powerpc architecture with the help of hardware
> > registers that accurately capture the entitlement.
> > 
> 
> there are some issues with this unfortunately, and these make it
> a very complex thing to do. 
> Just to mention a few:
> 1) What if the BIOS no longer allows us to go to the max frequency for
> a period (for example as a result of overheating); with the approach
> above, the admin would THINK he can go faster, but he cannot in reality,
> so there's misleading information (the system looks half busy, while in
> reality it's actually the opposite, it's overloaded). Management tools
> will take the wrong decisions (such as moving MORE work to the box, not
> less)
> 2) On systems with Intel Dynamic Acceleration technology, you can get
> over 100% of cycles this way. (For those who don't know what IDA is;
> IDA is basically a case where if your Penryn based dual core laptop is
> only using 1 core, the other core can go faster than 100% as long as
> thermals etc allow it). How do you want to deal with this?

Hi Arjan,

Thanks you for the inputs.  The above issues are very valid and our
solution should be able to react appropriately to the above situation.

What we are proposing is a scaled time value that is scaled to the
current CPU capacity.  If the scaled utilisation is 50% when the CPU
is at 100% capacity, it is expected to remain at 50% even if the CPU's
capacity is dropped to 50%, while the traditional utilisation value
will be 100%.

The problem in the above two cases is that we had assumed that the
maximum CPU capacity is 100% at normal capacity (without IDA).

If the CPU is at half the maximum frequency, then scaled stats should
show 50%.  

Now in case 1, the CPU's capacity cannot be increased further and you
expect to have shown 100% in scaled stats as well.  If the process ran
for 10s, then the scaled time should be 10s since we cannot make the
process run faster.

In case 2, the CPU's capacity increases beyond assumed 100% and now
the tasks will have excess of 100% utilisation.  If the real run time
is 5s, then scaled runtime will be more than 5s say 7s.  This
essentially says that the process has done work worth of 7s of CPU
time when it was at 100% capacity.

The point I am trying to make is whether scaling should be done
relative to CPUs designed maximum capacity or maximum capacity under
current constraints is to be discussed.

Case A:
------

Scaled stats is stats relative to maximum designed capacity including
IDA

In this case nominal utilisation will always be less than 100%, but
the higher level software need to know the environment and interpret
the values so as to determine the remaining capacity.

Example: Assume IDA provides a 20% boost

We know that normal capacity will be 83%, with a 20% boosting in case
of IDA, we can reach 100%.

If there was a P-State constraint due to power/thermal envelop, the we
know that the maximum capacity will be reduced to say 40%.

Remaining cap = Available cap - Current Cap

Available capacity is a dynamically varying quantity but still the
stats are useful and interpretable.

Case B:
------

Scaled stats is stats relative to current available capacity.

In this case we assume 100% means current available capacity and hence
any scaled utilisation less than 100% can be counted as spare capacity.

If we are constrained to half frequency, and we are running at 1/4th
freq, then our scaled stats will be 50%, implying that we can still
double our capacity by switching to next higher frequency.

This is not very elegant statistics, because the scaled 'time' value
will not make sense after a long runtime over various transitions
through the constraints and acceleration.

In this case the OS needs to know about the constraint. The higher
level management software will not be able to interpret the scaled
stats at the moment when the constraint has changed.  They need to
know about the constraints and changes as well.

I will prefer metric as in case A.  I assume even in case of IDA, we
will know the CPU's maximum capacity with acceleration, and its
nominal capacity. APERF/MPERF ratio can be interpreted correctly even
if it exceeds 1.

Please let us know if we can improve the framework to include both the
power constraint case and acceleration case.

Thanks,
Vaidy

