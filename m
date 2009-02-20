Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbZBTILa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbZBTILa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZBTILK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:11:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40603 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbZBTILI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:11:08 -0500
Date: Fri, 20 Feb 2009 09:10:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
Message-ID: <20090220081040.GA11490@elte.hu>
References: <20090121185021.GA8852@elte.hu> <499DD4BE.2000704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499DD4BE.2000704@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> Ingo Molnar wrote:
>> We are pleased to announce version 6 of our performance counters 
>> subsystem implementation. The shortlog, diffstat and the combo patch 
>> can be found below. The combo patch against latest -git (2.6.29-rc2) 
>> can be also found at:
>>
> [snip]
>
> Hi Ingo,
>
> As I was starting to put together a simple implementation of 
> PAPI on top of PCL for Power, I noticed that PCL does not seem 
> to have any sort of versioning and way of ascertaining the 
> current capabilities of what is in the kernel.
>
> This information is needed by tools and libraries built on top 
> of PCL so that they can know what is supported and if any bugs 
> need to be worked around.

I'd prefer to use the standard Linux syscall ABI convention 
here:

 - once upstream, existing functionality is compatible forever

 - new functionality is added in a way that it generates a 
   -ENOSYS return from the syscall in an older kernel.

That's why the event structure is sized relatively large for 
example - to make sure we have space to grow into.

So instead of adding versioning information, it would be very 
nice if you could check the ABI details for 'traps' that make 
extensions harder. Try to come up with pie-in-the-sky future 
items you'd like to see in the ABI, and lets see how supportable 
it would be.

Example #1 - made up. Say if we had an ABI detail like this:

  struct perf_counter_hw_event {
          u8                     type;

this would limit us to 256 events - which would be clearly 
stupid as we can easily hit that limit.

Example #2. Not made up:

asmlinkage int
sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr __user,
                      pid_t pid, int cpu, int group_fd)

Those are 5 parameters - we could extend it to 6 and add a 
'flags' value that in the current version will return -ENOSYS if 
the flags value is not zero.

This would add one more dimension of extensibility to the 
interface.

If you could come up with a list of small details like this, 
that would be really helpful. Would this work?

	Ingo
