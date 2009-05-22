Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbZEVGSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbZEVGSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZEVGSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:18:40 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52809 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZEVGSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:18:39 -0400
Date: Fri, 22 May 2009 11:48:27 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [Patch 01/12] Prepare the code for Hardware Breakpoint
	interfaces
Message-ID: <20090522061827.GA9611@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090521095613.834622717@prasadkr_t60p.in.ibm.com> <20090521140033.GB13849@in.ibm.com> <4A157E66.4040805@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A157E66.4040805@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 09:16:38AM -0700, David Daney wrote:
> K.Prasad wrote:
> [...]
>> +struct hw_breakpoint {
>> +	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
>> +	struct arch_hw_breakpoint info;
>> +};
>> +/*
>> + * len and type values are defined in include/asm/hw_breakpoint.h.
>> + * Available values vary according to the architecture.  On i386 the
>> + * possibilities are:
>> + *
>> + *	HW_BREAKPOINT_LEN_1
>> + *	HW_BREAKPOINT_LEN_2
>> + *	HW_BREAKPOINT_LEN_4
>> + *	HW_BREAKPOINT_RW
>> + *	HW_BREAKPOINT_READ
>> + *
>> + * On other architectures HW_BREAKPOINT_LEN_8 may be available, and the
>> + * 1-, 2-, and 4-byte lengths may be unavailable.  There also may be
>> + * HW_BREAKPOINT_WRITE.  You can use #ifdef to check at compile time.
>> + */
>> +
>
> I question weather having all these symbols for lengths is the proper  
> approach.
>
> On mips we would currently have:
>
> HW_BREAKPOINT_LEN_8
> HW_BREAKPOINT_LEN_16
> HW_BREAKPOINT_LEN_32
> HW_BREAKPOINT_LEN_64
> HW_BREAKPOINT_LEN_128
> HW_BREAKPOINT_LEN_256
> HW_BREAKPOINT_LEN_512
> HW_BREAKPOINT_LEN_1024
> HW_BREAKPOINT_LEN_2048
>
> If we were to use a debug agent hooked into the MIPS EJTAG debugger
> support registers, 63 different even powers of 2 are valid lengths.
>
> Determining the range of allowed breakpoint lengths, converting back
> and forth between numeric values that are likely to be used in a
> debugger, and these symbolic values that the proposed kernel interface
> would use, could be a little ugly.
>
> Have you thought about passing just the raw length?  And perhaps
> having:
>
> HW_BREAKPOINT_LEN_MASK that would have a bit set for each log2 of a
> legal length?
>

As explained to you here: http://lkml.org/lkml/2008/12/16/553/, defining
every possible length of the HW Breakpoint works for x86, but may not be
suitable for MIPS.

As you might have seen, the HW_BREAKPOINT_LEN_* values are defined in
x86-specific files and will be compared against 'len' field in
arch-specific 'struct arch_hw_breakpoint', for the reason that these
attributes are not valid for all architectures and have to be defined
for each processor in their own way.

Defining a HW_BREAKPOINT_LEN_MASK mask and validation of the input
length to check if it is a valid power of 2 can still be done for MIPS
in the arch-specific files and I don't see any part of the generic
interface being a hurdle during its implementation. Let me know if you
think there's any.

> Or perhaps add a function to the interface that would validate the
> length?
> 

arch_validate_hwbkpt_settings() invoked during
register_<kernel>/<user>_hw_breakpoint() is that function which
validates the length.

> David Daney

Thanks,
K.Prasad

