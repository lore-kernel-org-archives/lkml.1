Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbZENUqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbZENUqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZENUpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:45:50 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56714 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbZENUpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:45:50 -0400
Date: Fri, 15 May 2009 02:15:17 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 00/12] Hardware Breakpoint interfaces
Message-ID: <20090514204517.GA8079@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090513161201.GA13911@in.ibm.com> <Pine.LNX.4.44L0.0905141555310.4344-100000@iolanthe.rowland.org> <20090514200829.GE30963@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514200829.GE30963@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 01:38:29AM +0530, K.Prasad wrote:
> On Thu, May 14, 2009 at 04:02:16PM -0400, Alan Stern wrote:
> > On Wed, 13 May 2009, K.Prasad wrote:
> > 
> > > Hi Alan,
> > > 	Please find a new set of patches with the following changes.
> > > I am eager to know if you think that they are ready for submission towards
> > > upstream acceptance.
> > 
> > This is looking pretty good.  Only one thing caught my eye: 
> > switch_to_thread_hw_breakpoint and switch_to_none_hw_breakpoint do 
> > nothing but call the corresponding arch-specific routines.  You might 
> > as well eliminate them and have the callers invoke the arch-specific 
> > routines instead.
> > 
> > Alan Stern
> >
> 
> Sure. I will eliminate the above two functions and also remove the msleep()
> call in ftrace startup selftest code path.
> 
> With these two changes I plan to submit the code for -tip acceptance
> directly.
>

There is another change that I wanted to make in arch_store_info()
[which I realised while responding to comments on another list]. I think
it will be much safer to add a check to see if symbol_name is passed
when user-space breakpoints are requested and return -EINVAL if done so.

This will help avoid any confusion at the user, who can assume that
symbol names can be resolved, and specifying address is not required.

Here's how the modified arch_store_info() would look like:

/*
 * Store a breakpoint's encoded address, length, and type.
 */
static int arch_store_info(struct hw_breakpoint *bp, struct task_struct *tsk)
{
	/*
	 * User-space requests will always have the address field populated.
	 * Symbol names from user-space are rejected
	 */
	if (tsk && bp->info.name)
		return -EINVAL;
	/*
	 * For kernel-addresses, either the address or symbol name can be
	 * specified.
	 */
	if (bp->info.name)
		bp->info.address = (unsigned long)
					kallsyms_lookup_name(bp->info.name);
	if (bp->info.address)
		return 0;
	return -EINVAL;
}

Thanks,
K.Prasad
 
