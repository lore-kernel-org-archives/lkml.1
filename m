Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbZESNh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbZESNh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbZESNhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:37:50 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:42228 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbZESNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:37:49 -0400
Date: Tue, 19 May 2009 19:07:25 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "menage@google.com" <menage@google.com>
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
Message-ID: <20090519133725.GA16709@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090519073942.GA10864@sli10-desk.sh.intel.com> <1242722454.26820.461.camel@twins> <20090519084852.GA13682@sli10-desk.sh.intel.com> <1242723364.26820.466.camel@twins> <1242729538.26820.497.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1242729538.26820.497.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2009-05-19 12:38:58]:

> On Tue, 2009-05-19 at 10:56 +0200, Peter Zijlstra wrote:
> > On Tue, 2009-05-19 at 16:48 +0800, Shaohua Li wrote:
> > > On Tue, May 19, 2009 at 04:40:54PM +0800, Peter Zijlstra wrote:
> > > > On Tue, 2009-05-19 at 15:39 +0800, Shaohua Li wrote:
> > > > > ACPI 4.0 defines processor aggregator device. The device can notify OS to idle
> > > > > some CPUs to save power. This isn't to hot remove cpus, but just makes cpus
> > > > > idle.
> > > > > 
> > > > > This patch adds one API to change cpuset top group's cpus. If we want to
> > > > > make one cpu idle, simply remove the cpu from cpuset top group's cpu list,
> > > > > then all tasks will be migrate to other cpus, and other tasks will not be
> > > > > migrated to this cpu again. No functional changes.
> > > > > 
> > > > > We will use this API in new ACPI processor aggregator device driver later.
> > > > 
> > > > I don't think so. There really is a lot more to do than move processes
> > > > about.
> > > no processor running is good enough for us, we don't care about interrupts/softirq/
> > > timers so far.
> > 
> > Well, I don't care for this interface.
> > 
> > > > Furthermore, I object to being able to remove online cpus from the top
> > > > cpuset, that just doesn't make sense.
> > > > 
> > > > I'd suggest using hotplug for this.
> > 
> > > cpu hotplug involves too much things, and we are afraid it's not reliable.
> > 
> > Then make it more reliable instead of providing ugly ass shit like this.
> 
> OK, so perhaps I should have use different words. But the point is, we
> don't need a new interface to force a cpu idle. Hotplug does that.

We tried similar approaches to create idle time for power savings, but
cpu hotplug interface seem to be a clean choice.  There could be
issues with the interface, we should fix it.  Is there any other
reason why cpuhotplug is 'ugly' other than its performance (speed)?

I have tried few load balancer hacks to evacuate cores but not a solid
design yet.  It has its advantages but still needs more work.

http://lkml.org/lkml/2009/5/13/173

> Furthermore, we should not want anything outside of that, either the cpu
> is there available for work, or its not -- halfway measures don't make
> sense.
> 
> Furthermore, we already have power aware scheduling which tries to
> aggregate idle time on cpu/core/packages so as to maximize the idle time
> power savings. Use it there.

Power aware scheduling can optimally accumulate idle times.  Framework
to create idle time to force idle cores is good and useful for power
savings.  Other than the speed of online/offline I do not know of any
other major issue for using cpu hotplug for this purpose.
 
> > > Besides, a hot removed cpu will do a dead loop halt, which isn't power saving
> > > efficient. To make hot removed cpu enters deep C-state is in whish list for a
> > > long time, but still not available. The acpi_processor_idle is a module, and
> > > cpuidle governor potentially can't handle offline cpu.
> > 
> > Then fix that hot-unplug idle loop. I agree that the hlt thing is silly,
> > and I've no idea why its still there, seems like a much better candidate
> > for your efforts than this.

I agree with Peter.  We need to make cpu hotplug save power first and
later improve upon its performance.

--Vaidy
