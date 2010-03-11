Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab0CKIVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:21:53 -0500
Received: from mga07.intel.com ([143.182.124.22]:39327 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754431Ab0CKIVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:21:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,619,1262592000"; 
   d="scan'208";a="253409018"
Subject: Re: [PATCH] x86/kvm: Show guest system/user cputime in cpustat
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Sheng Yang <sheng@linux.intel.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, "Zhang, Yanmin" <yanmin.zhang@intel.com>
In-Reply-To: <4B98A0DE.1020006@redhat.com>
References: <1268292022-31352-1-git-send-email-sheng@linux.intel.com>
	 <4B989D61.70906@redhat.com> <201003111546.44059.sheng@linux.intel.com>
	 <4B98A0DE.1020006@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 11 Mar 2010 16:21:32 +0800
Message-Id: <1268295692.1726.250.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 09:50 +0200, Avi Kivity wrote:
> On 03/11/2010 09:46 AM, Sheng Yang wrote:
> > On Thursday 11 March 2010 15:36:01 Avi Kivity wrote:
> >    
> >> On 03/11/2010 09:20 AM, Sheng Yang wrote:
> >>  

>     
> >>> Currently we can only get the cpu_stat of whole guest as one. This patch
> >>> enhanced cpu_stat with more detail, has guest_system and guest_user cpu
> >>> time statistics with a little overhead.
> >>>
> >>> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
It seems per-process guest cpu utilization is more useful than per-cpu's.


> >>> ---
> >>>
> >>> This draft patch based on KVM upstream to show the idea. I would split it
> >>> into more kernel friendly version later.
> >>>
> >>> The overhead is, the cost of get_cpl() after each exit from guest.
> >>>        
> >> This can be very expensive in the nested virtualization case, so I
> >> wouldn't like this to be in normal paths.  I think detailed profiling
> >> like that can be left to 'perf kvm', which only has overhead if enabled
> >> at runtime.
> >>      
> > Yes, that's my concern too(though nested vmcs/vmcb read already too expensive,
> > they should be optimized...).
> 
> Any ideas on how to do that?  Perhaps use paravirt_ops to covert the 
> vmread into a memory read?  We store the vmwrites in the vmcs anyway.
Another method is to add sysctl entry, such like /proc/sys/kernel/collect_guest_utilization,
and we can set it off by default. Or add a /sys/kernel/debug/kvm/collect_guest_utilization.

> 
> > The other concern is, perf alike mechanism would
> > bring a lot more overhead compared to this.
> >    
> 
> Ordinarily users won't care if time is spent in guest kernel mode or 
> guest user mode.  They want to see which guest is imposing a load on a 
> system.  I consider a user profiling a guest from the host an advanced 
> and rarer use case, so it's okay to require tools and additional 
> overhead for this.
Here is the story why Sheng worked out the patch. Some guys work on
KVM performance. They want us to extend top to show guest utilization
info, such like guest kernel and guest userspace cpu utilization. With
the new tool, they could find which VM (mapping with qemu process id)
consumes too much cpu time in host space (including kernel and userspace),
and compare them with guest kernel/userspace. That information could provide
a first-hand high-level overview about all VMs running in the system
and help admin quickly find what the worst VM instance is.

So we need per-process (guest) cpu utilization than per-cpu guest utilization.

> 
> >> For example you can put the code to note the cpl in a tracepoint which
> >> is enabled dynamically.
> >>      
> > Yanmin have already implement "perf kvm" to support this. We are just arguing
> > if a normal top-alike mechanism is necessary.
perf kvm mostly is used to find hot functions which might cause more overhead.
Sheng's patch has less overhead.


> >
> > I am also considering to make it a feature that can be disabled. But seems it
> > make things complicate and result in uncertain cpustat output.
> >    
> 
> I'm not even sure that guest time was a good idea.


