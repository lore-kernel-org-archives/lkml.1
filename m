Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0CKJP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:15:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:25281 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab0CKJP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:15:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,619,1262592000"; 
   d="scan'208";a="499756322"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>, Qing He <qing.he@intel.com>
Subject: Re: [PATCH] x86/kvm: Show guest system/user cputime in cpustat
Date: Thu, 11 Mar 2010 17:17:26 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1268292022-31352-1-git-send-email-sheng@linux.intel.com> <201003111546.44059.sheng@linux.intel.com> <4B98A0DE.1020006@redhat.com>
In-Reply-To: <4B98A0DE.1020006@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003111717.26475.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010 15:50:54 Avi Kivity wrote:
> On 03/11/2010 09:46 AM, Sheng Yang wrote:
> > On Thursday 11 March 2010 15:36:01 Avi Kivity wrote:
> >> On 03/11/2010 09:20 AM, Sheng Yang wrote:
> >>> Currently we can only get the cpu_stat of whole guest as one. This
> >>> patch enhanced cpu_stat with more detail, has guest_system and
> >>> guest_user cpu time statistics with a little overhead.
> >>>
> >>> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> >>> ---
> >>>
> >>> This draft patch based on KVM upstream to show the idea. I would split
> >>> it into more kernel friendly version later.
> >>>
> >>> The overhead is, the cost of get_cpl() after each exit from guest.
> >>
> >> This can be very expensive in the nested virtualization case, so I
> >> wouldn't like this to be in normal paths.  I think detailed profiling
> >> like that can be left to 'perf kvm', which only has overhead if enabled
> >> at runtime.
> >
> > Yes, that's my concern too(though nested vmcs/vmcb read already too
> > expensive, they should be optimized...).
> 
> Any ideas on how to do that?  Perhaps use paravirt_ops to covert the
> vmread into a memory read?  We store the vmwrites in the vmcs anyway.

When Qing(CCed) was working on nested VMX in the past, he found PV 
vmread/vmwrite indeed works well(it would write to the virtual vmcs so vmwrite 
can also benefit). Though compared to old machine(one our internal patch shows 
improve more than 5%), NHM get less benefit due to the reduced vmexit cost.

-- 
regards
Yang, Sheng

> 
> > The other concern is, perf alike mechanism would
> > bring a lot more overhead compared to this.
> 
> Ordinarily users won't care if time is spent in guest kernel mode or
> guest user mode.  They want to see which guest is imposing a load on a
> system.  I consider a user profiling a guest from the host an advanced
> and rarer use case, so it's okay to require tools and additional
> overhead for this.
> 
> >> For example you can put the code to note the cpl in a tracepoint which
> >> is enabled dynamically.
> >
> > Yanmin have already implement "perf kvm" to support this. We are just
> > arguing if a normal top-alike mechanism is necessary.
> >
> > I am also considering to make it a feature that can be disabled. But
> > seems it make things complicate and result in uncertain cpustat output.
> 
> I'm not even sure that guest time was a good idea.
> 
