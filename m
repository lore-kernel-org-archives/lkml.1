Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbZJEHQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbZJEHQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758494AbZJEHQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:16:23 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:58230 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbZJEHQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:16:22 -0400
Date: Mon, 5 Oct 2009 12:45:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: [git pull request] ACPI Processor Aggregator Driver for
 2.6.32-rc1
Message-ID: <20091005071538.GA3036@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain>
 <20091005033256.GA26592@balbir.in.ibm.com>
 <20091005053310.GB14222@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091005053310.GB14222@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidy <svaidy@linux.vnet.ibm.com> [2009-10-05 11:03:10]:

> * Balbir Singh <balbir@linux.vnet.ibm.com> [2009-10-05 09:02:56]:
> 
> > * Len Brown <lenb@kernel.org> [2009-10-03 01:56:32]:
> > 
> > >     This driver does not use the kernel's CPU hot-plug mechanism
> > >     because after the transient emergency is over, the system must
> > >     be returned to its normal state, and hotplug would permanently
> > >     break both cpusets and binding.
> > >     
> > 
> > Why does hotplug break cpusets and binding?
> 
> CPU hotplug will break any cpuset that is setup with that cpu.
> Userspace needs to register for notifications and redo the cpusets to
> get desired behaviour.  Since these emergencies are short durations,
> these may require constant re-creation of cpusets leading to an
> administrative overhead and added complexity.
>
 
My concern is that the alternative is even harsher, you can end up
with starvation, unless we explicitly migrate all tasks away from that
CPU (I need to see the patches again to see if they do that).

> Hence Peter had suggested a transparent method to reduce system
> capacity and not really knock out a single cpu.  The goal is to run
> something like 6 cpus at a time in an 8 cpu system without starving
> any single cpu.  Also real time jobs should still allowed to be run
> since they will generally be very short running.
> 
> In this patch series, the main design issue was about running
> a forced-idle thread that may affect scheduling fairness.
>

Not to mention that they put the scheduler and available CPUs or the
notion of them (out of sync).
 
> > >     So to force idle, the driver creates a power saving thread.
> > >     The scheduler will migrate the thread to the preferred CPU.
> > >     The thread has max priority and has SCHED_RR policy,
> > >     so it can occupy one CPU.  To save power, the thread will
> > >     invoke the deep C-state entry instructions.
> > >     
> > >     To avoid starvation, the thread will sleep 5% of the time
> > >     time for every second (current RT scheduler has threshold
> > >     to avoid starvation, but if other CPUs are idle,
> > >     the CPU can borrow CPU timer from other,
> > >     which makes the mechanism not work here)
> > >     
> > >     Vaidyanathan Srinivasan has proposed scheduler enhancements
> > >     to allow injecting idle time into the system.  This driver doesn't
> > >     depend on those enhancements, but could cut over to them
> > >     when they are available.
> > >     
> > >     Peter Z. does not favor upstreaming this driver until
> > >     the those scheduler enhancements are in place.  However,
> > >     we favor upstreaming this driver now because it is useful
> > >     now, and can be enhanced over time.
> > >     
> > >     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > >     NACKed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >     Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > >     Signed-off-by: Len Brown <len.brown@intel.com>
> > 
> > This is a first a patch with a NACKed-by, could we please have more
> > discussion on the proposed design.
> 
> This is the most recent reference I have:
> http://marc.info/?l=linux-acpi&m=124650086915649&w=2
>

Thanks for the link. 

-- 
	Balbir
