Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZEUQRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZEUQRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbZEUQQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:16:48 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:20555 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969AbZEUQQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:16:47 -0400
Message-ID: <4A157E66.4040805@caviumnetworks.com>
Date: Thu, 21 May 2009 09:16:38 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [Patch 01/12] Prepare the code for Hardware Breakpoint interfaces
References: <20090521095613.834622717@prasadkr_t60p.in.ibm.com> <20090521140033.GB13849@in.ibm.com>
In-Reply-To: <20090521140033.GB13849@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2009 16:16:38.0684 (UTC) FILETIME=[8505D5C0:01C9DA2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K.Prasad wrote:
[...]
> +/**
> + * struct hw_breakpoint - unified kernel/user-space hardware breakpoint
> + * @triggered: callback invoked after target address access
> + * @info: arch-specific breakpoint info (address, length, and type)
> + *
> + * %hw_breakpoint structures are the kernel's way of representing
> + * hardware breakpoints.  These are data breakpoints
> + * (also known as "watchpoints", triggered on data access), and the breakpoint's
> + * target address can be located in either kernel space or user space.
> + *
> + * The breakpoint's address, length, and type are highly
> + * architecture-specific.  The values are encoded in the @info field; you
> + * specify them when registering the breakpoint.  To examine the encoded
> + * values use hw_breakpoint_get_{kaddress,uaddress,len,type}(), declared
> + * below.
> + *
> + * The address is specified as a regular kernel pointer (for kernel-space
> + * breakponts) or as an %__user pointer (for user-space breakpoints).
> + * With register_user_hw_breakpoint(), the address must refer to a
> + * location in user space.  The breakpoint will be active only while the
> + * requested task is running.  Conversely with
> + * register_kernel_hw_breakpoint(), the address must refer to a location
> + * in kernel space, and the breakpoint will be active on all CPUs
> + * regardless of the current task.
> + *
> + * The length is the breakpoint's extent in bytes, which is subject to
> + * certain limitations.  include/asm/hw_breakpoint.h contains macros
> + * defining the available lengths for a specific architecture.  Note that
> + * the address's alignment must match the length.  The breakpoint will
> + * catch accesses to any byte in the range from address to address +
> + * (length - 1).
> + *
> + * The breakpoint's type indicates the sort of access that will cause it
> + * to trigger.  Possible values may include:
> + *
> + * 	%HW_BREAKPOINT_RW (triggered on read or write access),
> + * 	%HW_BREAKPOINT_WRITE (triggered on write access), and
> + * 	%HW_BREAKPOINT_READ (triggered on read access).
> + *
> + * Appropriate macros are defined in include/asm/hw_breakpoint.h; not all
> + * possibilities are available on all architectures.  Execute breakpoints
> + * must have length equal to the special value %HW_BREAKPOINT_LEN_EXECUTE.
> + *
> + * When a breakpoint gets hit, the @triggered callback is
> + * invoked in_interrupt with a pointer to the %hw_breakpoint structure and the
> + * processor registers.
> + * Data breakpoints occur after the memory access has taken place.
> + * Breakpoints are disabled during execution @triggered, to avoid
> + * recursive traps and allow unhindered access to breakpointed memory.
> + *
> + * This sample code sets a breakpoint on pid_max and registers a callback
> + * function for writes to that variable.  Note that it is not portable
> + * as written, because not all architectures support HW_BREAKPOINT_LEN_4.
> + *
> + * ----------------------------------------------------------------------
> + *
> + * #include <asm/hw_breakpoint.h>
> + *
> + * struct hw_breakpoint my_bp;
> + *
> + * static void my_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
> + * {
> + * 	printk(KERN_DEBUG "Inside triggered routine of breakpoint exception\n");
> + * 	dump_stack();
> + *  	.......<more debugging output>........
> + * }
> + *
> + * static struct hw_breakpoint my_bp;
> + *
> + * static int init_module(void)
> + * {
> + *	..........<do anything>............
> + *	my_bp.info.type = HW_BREAKPOINT_WRITE;
> + *	my_bp.info.len = HW_BREAKPOINT_LEN_4;
> + *
> + *	my_bp.installed = (void *)my_bp_installed;
> + *
> + *	rc = register_kernel_hw_breakpoint(&my_bp);
> + *	..........<do anything>............
> + * }
> + *
> + * static void cleanup_module(void)
> + * {
> + *	..........<do anything>............
> + *	unregister_kernel_hw_breakpoint(&my_bp);
> + *	..........<do anything>............
> + * }
> + *
> + * ----------------------------------------------------------------------
> + */
> +struct hw_breakpoint {
> +	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
> +	struct arch_hw_breakpoint info;
> +};
> +/*
> + * len and type values are defined in include/asm/hw_breakpoint.h.
> + * Available values vary according to the architecture.  On i386 the
> + * possibilities are:
> + *
> + *	HW_BREAKPOINT_LEN_1
> + *	HW_BREAKPOINT_LEN_2
> + *	HW_BREAKPOINT_LEN_4
> + *	HW_BREAKPOINT_RW
> + *	HW_BREAKPOINT_READ
> + *
> + * On other architectures HW_BREAKPOINT_LEN_8 may be available, and the
> + * 1-, 2-, and 4-byte lengths may be unavailable.  There also may be
> + * HW_BREAKPOINT_WRITE.  You can use #ifdef to check at compile time.
> + */
> +

I question weather having all these symbols for lengths is the proper 
approach.

On mips we would currently have:

HW_BREAKPOINT_LEN_8
HW_BREAKPOINT_LEN_16
HW_BREAKPOINT_LEN_32
HW_BREAKPOINT_LEN_64
HW_BREAKPOINT_LEN_128
HW_BREAKPOINT_LEN_256
HW_BREAKPOINT_LEN_512
HW_BREAKPOINT_LEN_1024
HW_BREAKPOINT_LEN_2048

If we were to use a debug agent hooked into the MIPS EJTAG debugger
support registers, 63 different even powers of 2 are valid lengths.

Determining the range of allowed breakpoint lengths, converting back
and forth between numeric values that are likely to be used in a
debugger, and these symbolic values that the proposed kernel interface
would use, could be a little ugly.

Have you thought about passing just the raw length?  And perhaps
having:

HW_BREAKPOINT_LEN_MASK that would have a bit set for each log2 of a
legal length?

Or perhaps add a function to the interface that would validate the
length?

David Daney
