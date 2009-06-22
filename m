Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZFVVie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZFVVie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZFVViY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:38:24 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45241 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbZFVViX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:38:23 -0400
Message-ID: <4A3FF9D0.9040607@linux.vnet.ibm.com>
Date: Mon, 22 Jun 2009 14:38:24 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: eranian@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.2 - Grouping
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622115017.GC24366@elte.hu>
In-Reply-To: <20090622115017.GC24366@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
>> 2/ Grouping
>>
>> By design, an event can only be part of one group at a time.
>> Events in a group are guaranteed to be active on the PMU at the
>> same time. That means a group cannot have more events than there
>> are available counters on the PMU. Tools may want to know the
>> number of counters available in order to group their events
>> accordingly, such that reliable ratios could be computed. It seems
>> the only way to know this is by trial and error. This is not
>> practical.
> 
> Groups are there to support heavily constrained PMUs, and for them
> this is the only way, as there is no simple linear expression for
> how many counters one can load on the PMU.
> 
> The ideal model to tooling is relatively independent PMU registers
> (counters) with little constraints - most modern CPUs meet that
> model.
> 
> All the existing tooling (tools/perf/) operates on that model and
> this leads to easy programmability and flexible results. This model
> needs no grouping of counters.
> 
> Could you please cite specific examples in terms of tools/perf/?
> What feature do you think needs to know more about constraints? What
> is the specific win in precision we could achieve via that?


An example of this is that a user wants to monitor 10 events, and we have four 
counters to work with.  Let's assume there is some mapping of events to counters 
where you need only 3 groups to schedule the 10 events onto the PMU.  If you 
leave it to the kernel (and don't group the events from user space), depending 
on the kernel's fast event scheduling algorithm, it may take 6 groups to get all 
of the requested events counted.  This leads to lower counts in the counters, 
and more chance for the counters to miss event bursts, which leads to less 
accurate scaled results.

Currently the PAPI substrate for PCL does do this partitioning using a very dumb 
algorithm.  But it could be improved, particularly if there was some better way 
to get feedback from the kernel other than a "yes, these fit" or "no, these 
don't fit".  I'm not sure what that way would be, though.  Perhaps an ioctl that 
does a some sort of "dry scheduling" of events to groups in an optimal way. 
This call would not need to lock any resources, and just use the kernel's 
algorithm for event constraint checking.

To me, this is not a big issue, but some sort of better mechanism might be 
considered for a future update.

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

