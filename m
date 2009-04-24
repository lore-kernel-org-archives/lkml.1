Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbZDXF5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbZDXF5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 01:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZDXF5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 01:57:00 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:52846 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZDXF47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 01:56:59 -0400
Date: Fri, 24 Apr 2009 11:26:37 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090424055637.GA7909@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090417031221.GA4837@in.ibm.com> <Pine.LNX.4.44L0.0904171000470.6220-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904171000470.6220-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 10:37:13AM -0400, Alan Stern wrote:
> On Fri, 17 Apr 2009, K.Prasad wrote:
> 

Hi Alan,
	I have modified the patch by accepting all of your suggestions
excepting one - which I try to explain below.

I will send the patchset containing changes suggested by you and a few
others (have explained that in the changelog).

Kindly review the new code.


> > 
> > > > +	on_each_cpu(arch_update_kernel_hw_breakpoints, NULL, 0);
> > > > +	hbp_kernel_pos++;
> > > 
> > > Don't you want to increment hbp_kernel_pos _before_ calling
> > > on_each_cpu()?  Otherwise you're telling the other CPUs to install an
> > > empty breakpoint.
> > > 
> > 
> > Incrementing hbp_kernel_pos after arch_update_kernel_hw_breakpoints()
> > during unregister_kernel_ is of the following significance:
> > 
> > - The 'pos' numbered debug register is reset to 0 through the code 
> >   "set_debugreg(hbp_kernel[i]->info.address, i)" where 'i' ranges from
> >   hbp_kernel_pos to HB_NUM. This is necessary during unregister operation.
> 
> It _isn't_ necessary.  The contents of that debug register don't matter 
> at all if it isn't enabled.  (And there's nothing special about 0; if 
> the breakpoint were enabled then you would get a breakpoint interrupt 
> whenever something tried to access address 0.)
> 
> Besides, the "set_debugreg" line of code in
> arch_update_kernel_hw_breakpoints doesn't get executed when
> hbp_kernel[i] is NULL.  So this whole point is moot; the debug register
> wouldn't be affected anyway.
> 
> > - The following statements would reset the bits corresponding to
> >   unregistered breakpoint only then.
> > 	kdr7 &= ~kdr7_masks[hbp_kernel_pos];
> > 	dr7 &= ~kdr7_masks[hbp_kernel_pos];
> 
> But if hbp_kernel_pos is wrong (i.e., if it hasn't been incremented)
> then these statements will set kdr7 and dr7 incorrectly.
> 
> > - Helps keep the arch_update_kernel_hw_breakpoints() code generic enough
> >   to be invoked during register and unregister operations.
> 
> This is another moot point.  Your code is _wrong_ -- how generic it is
> doesn't matter.
> 
>

The arch_update_kernel_hw_breakpoints() was designed to work like this -
it updates all registers beginning 'hbp_kernel_pos' to (HB_NUM - 1) with
the values stored in hbp_kernel[] array.

When inserting a new breakpoint, hbp_kernel_pos is decremented *before*
invoking arch_update_kernel_hw_breakpoints() so that the new value is
also written onto the physical debug register.

On removal, 'hbp_kernel_pos' is incremented *after*
arch_update_kernel_hw_breakpoints() so that the physical debug registers
i.e. both DR7 and DR<pos> are updated with the changes post removal and
compaction. I'm ready to make changes but don't see where the code
actually goes wrong. Can you explain that?

Thanks,
K.Prasad

