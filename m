Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbZDXOQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbZDXOQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbZDXOQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:16:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45776 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754741AbZDXOQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:16:07 -0400
Date: Fri, 24 Apr 2009 10:16:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, <maneesh@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 00/11] Hardware Breakpoint interfaces
In-Reply-To: <20090424055637.GA7909@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0904240959460.2894-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, K.Prasad wrote:

> The arch_update_kernel_hw_breakpoints() was designed to work like this -
> it updates all registers beginning 'hbp_kernel_pos' to (HB_NUM - 1) with
> the values stored in hbp_kernel[] array.
> 
> When inserting a new breakpoint, hbp_kernel_pos is decremented *before*
> invoking arch_update_kernel_hw_breakpoints() so that the new value is
> also written onto the physical debug register.
> 
> On removal, 'hbp_kernel_pos' is incremented *after*
> arch_update_kernel_hw_breakpoints() so that the physical debug registers
> i.e. both DR7 and DR<pos> are updated with the changes post removal and
> compaction. I'm ready to make changes but don't see where the code
> actually goes wrong. Can you explain that?

I'm sorry; I misread the code in arch_update_kernel_hw_breakpoints().  
It isn't actually wrong, and you are correct to increment
hbp_kernel_pos where you do.  Your code is different from my original
version, which would update all the debug registers at once instead of
doing the kernel and userspace breakpoints separately -- that's what 
confused me.

There is one change you could make to improve the routine, however.  In 
arch_update_kernel_hw_breakpoints(), the line

	kdr7 &= ~kdr7_masks[hbp_kernel_pos];

really should be

	kdr7 = 0;

since kdr7 never contains anything other than kernel breakpoint
settings.  (You could update the comment in the preceding line as
well.)

Alan Stern

