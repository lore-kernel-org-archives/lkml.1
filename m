Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbYDVQmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbYDVQmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYDVQmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:42:24 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57144 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753907AbYDVQmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:42:23 -0400
Message-ID: <480E156D.4090100@sgi.com>
Date: Tue, 22 Apr 2008 09:42:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] sched: Remove fixed NR_CPUS sized arrays in kernel_sched_c
 v2
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>	 <20080405011101.534396000@polaris-admin.engr.sgi.com> <12c511ca0804220916i5c181202pecf8fee7153e54fc@mail.gmail.com>
In-Reply-To: <12c511ca0804220916i5c181202pecf8fee7153e54fc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
> On Fri, Apr 4, 2008 at 6:11 PM, Mike Travis <travis@sgi.com> wrote:
>>  @@ -7297,6 +7287,11 @@ void __init sched_init_smp(void)
>>   #else
>>   void __init sched_init_smp(void)
>>   {
>>  +#if defined(CONFIG_NUMA)
>>  +       sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
>>  +                                                               GFP_KERNEL);
>>  +       BUG_ON(sched_group_nodes_bycpu == NULL);
>>  +#endif
>>         sched_init_granularity();
>>   }
>>   #endif /* CONFIG_SMP */
> 
> This hunk is causing problems with one of my builds (generic,
> uniprocessor). Note
> that the #else at the start of this hunk is from a #ifdef CONFIG_SMP ... so I'm
> wondering why we need #if defined(CONFIG_NUMA) inside uniprocessor code :-)
> How can you have NUMA issues with only one cpu!!!
> 
> [I'm also wondering why the config that has the compile problem has CONFIG_SMP=n
> and CONFIG_NUMA=y ... but that weirdness exposed this silliness, so
> perhaps it isn't
> all bad]
> 
> Error message is:
> kernel/sched.c: In function `sched_init_smp':
> kernel/sched.c:7994: error: `sched_group_nodes_bycpu' undeclared
> (first use in this function)
> kernel/sched.c:7994: error: (Each undeclared identifier is reported only once
> kernel/sched.c:7994: error: for each function it appears in.)
> 
> -Tony

Hi Tony,

Hmm, yes, good point.  I guess you might have it when there's a single
processor under a guest OS that's not on node 0, but I suspect there's
plenty of other problems with that scenario.

We could make CONFIG_NUMA dependent on CONFIG_SMP?  Or define
sched_group_nodes_bycpu for the non-SMP case?

[I'll have to go back to that patch and research why I added this.]

Thanks,
Mike
