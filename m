Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbXLST5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbXLST5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbXLST5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:57:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:4379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbXLST5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:57:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,185,1196668800"; 
   d="scan'208";a="246504496"
Date: Wed, 19 Dec 2007 11:56:21 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
Message-ID: <20071219195620.GA13605@linux-os.sc.intel.com>
References: <20071219183443.GA547@linux-os.sc.intel.com> <20071219193255.GA2158@elte.hu> <476972A0.3050105@zytor.com> <20071219194032.GA8849@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219194032.GA8849@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 08:40:32PM +0100, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Ingo Molnar wrote:
> >> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> >>
> >>> Aviod TLB flush IPIs during C3 states by voluntary leave_mm() before 
> >>> entering C3.
> >>>
> >>> The performance impact of TLB flush on C3 should not be significant with 
> >>> respect to C3 wakeup latency. Also, CPUs tend to flush TLB in hardware 
> >>> while in C3 anyways.
> >>>
> >
> > Are there any CPUs around which *don't* flush the TLB across C3?  (I 
> > guess it's not guaranteed by the spec, though, and as TLBs grow larger 
> > there might be incentive to keep them online.)
> 
> i dont think it's required for C3 to even turn off any portion of the 
> CPU - if an interrupt arrives after the C3 sequence is initiated but 
> just before dirty cachelines have been flushed then the CPU can just 
> return without touching anything (such as the TLB) - right? So i dont 
> think there's any implicit guarantee of TLB flushing (nor should there 
> be), but in practice, a good C3 sequence would (statistically) turn off 
> large portions of the CPU and hence the TLB as well.
> 

Yes. There are cases where hardware/BIOS can do C-state changes behind OS, with
things like be in C1 for a while and then go to C2/C3 after a while etc. In
such cases, there will be times when TLBs are not really flushed in hardware.
But ideally, if C3 results in deep idle TLBs would be turned off. And in cases
where we wake up earlier than expected, C-state policy should identify that
and choose a lower C-state next time around.

I also tried one variation of this, where in I only do flush if there are more
than one CPU sharing the mm. But, that did not help the test case I was using
(which is probably the worst case). What I would see is:
Process runs on CPU x and mm is not shared
Goes idle (C3) waiting on something
Wakes up on CPU y which will now start sharing mm
and would send flush IPI anyway

Thanks,
Venki

