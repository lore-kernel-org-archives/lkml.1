Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab0CLIyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:54:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:54573 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab0CLIyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:54:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,625,1262592000"; 
   d="scan'208";a="780214128"
Date: Fri, 12 Mar 2010 16:53:21 +0800
From: Qing He <qing.he@intel.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/kvm: Show guest system/user cputime in cpustat
Message-ID: <20100312085321.GA9075@ub-qhe2>
References: <1268292022-31352-1-git-send-email-sheng@linux.intel.com>
 <201003111546.44059.sheng@linux.intel.com>
 <4B98A0DE.1020006@redhat.com>
 <201003111717.26475.sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003111717.26475.sheng@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 17:17 +0800, Sheng Yang wrote:
> On Thursday 11 March 2010 15:50:54 Avi Kivity wrote:
> > On 03/11/2010 09:46 AM, Sheng Yang wrote:
> > > On Thursday 11 March 2010 15:36:01 Avi Kivity wrote:
> > >> On 03/11/2010 09:20 AM, Sheng Yang wrote:
> > >>> Currently we can only get the cpu_stat of whole guest as one. This
> > >>> patch enhanced cpu_stat with more detail, has guest_system and
> > >>> guest_user cpu time statistics with a little overhead.
> > >>>
> > >>> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> > >>> ---
> > >>>
> > >>> This draft patch based on KVM upstream to show the idea. I would split
> > >>> it into more kernel friendly version later.
> > >>>
> > >>> The overhead is, the cost of get_cpl() after each exit from guest.
> > >>
> > >> This can be very expensive in the nested virtualization case, so I
> > >> wouldn't like this to be in normal paths.  I think detailed profiling
> > >> like that can be left to 'perf kvm', which only has overhead if enabled
> > >> at runtime.
> > >
> > > Yes, that's my concern too(though nested vmcs/vmcb read already too
> > > expensive, they should be optimized...).
> > 
> > Any ideas on how to do that?  Perhaps use paravirt_ops to covert the
> > vmread into a memory read?  We store the vmwrites in the vmcs anyway.
> 
> When Qing(CCed) was working on nested VMX in the past, he found PV 
> vmread/vmwrite indeed works well(it would write to the virtual vmcs so vmwrite 
> can also benefit). Though compared to old machine(one our internal patch shows 
> improve more than 5%), NHM get less benefit due to the reduced vmexit cost.
> 

One of the hurdles to PVize vmread/vmwrite is the fact that the memory
layout of physical vmcs remains unknown. Of course it can use the custom
vmcs layout utilized by nested virtualization, but that looks a little weird,
since different nested virtualization implementation may create different
custom layout.

I once used another approach to partially accelerate the vmread/vmwrite
in nested virtualization case, which also gives good performance gain (around
7% on pre-nehalem, based on this, PV vmread/vmwrite had another 7%). That
is to make a shortcut to handle EXIT_REASON_VM{READ,WRITE}, without
even turning on the IF.

Thanks,
Qing
