Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYH0OtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYH0OtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYH0Os6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:48:58 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35871 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753678AbYH0Os6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:48:58 -0400
Message-ID: <48B56957.8070909@sgi.com>
Date: Wed, 27 Aug 2008 07:48:55 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: nickpiggin@yahoo.com.au, davej@redhat.com, torvalds@linux-foundation.org,
       Alan.Brunelle@hp.com, mingo@elte.hu, tglx@linutronix.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, tony.luck@intel.com, steiner@sgi.com,
       cl@linux-foundation.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <200808271654.32721.nickpiggin@yahoo.com.au>	<20080827.000506.177643294.davem@davemloft.net>	<200808271747.14690.nickpiggin@yahoo.com.au> <20080827.014457.140528687.davem@davemloft.net>
In-Reply-To: <20080827.014457.140528687.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Nick Piggin <nickpiggin@yahoo.com.au>
> Date: Wed, 27 Aug 2008 17:47:14 +1000
> 
>> Yeah, I see. That's stupid isn't it? (Well, I guess it was completely
>> sane when cpumasks were word sized ;))
>>
>> Hopefully that accounts for a significant chunk...
> 
> There is a lot of indirect costs that are hard to see as well.
> 
> Two things a lot of these cross-call dispatch paths do is:
> 
> 1) Clear self-cpu
> 
> 2) AND with cpus_online
> 
> #1 can normally be a simple bit clear, but some places can also
> implement this with something like "cpus_andn(X, cpumask_of_cpu(cpu))"
> 
> It's simply easier to move those two things down to the bottom of
> the APIC programming code, they just loop over the cpumask doing
> an expensive APIC I/O operation anyways, might as well overlap it
> with these "skip self-cpu" and "skip not-online cpus" checks.
> 
> And oh yeah we get the stack wastage fixed too, isn't what what we
> were talking about? :-)

Yes, the most time consuming part was determining whether a kmalloc
could safely be used in the context of the function, and what to
do about the out-of-memory problem.  Pushing that down to something
like:  for_each_cpu_thats_online(cpu, *maskptr) would remove the need for
many of the temp masks.  A simple if (cpu != me) would take care of
excluding self.  It might have better interaction with cpu hotplug
as well, since the online map would be checked just before the call
to that cpu is made.

Thanks,
Mike
