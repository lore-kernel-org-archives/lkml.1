Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762Ab0ATQ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0ATQ1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635Ab0ATQ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:27:11 -0500
Received: from mail2.shareable.org ([80.68.89.115]:35461 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0ATQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:27:10 -0500
Date: Wed, 20 Jan 2010 16:26:47 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, jpihet@mvista.com,
       p.osciak@samsung.com, Jamie Iles <jamie.iles@picochip.com>,
       will.deacon@arm.com,
       =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com, mingo@elte.hu,
       Tomasz Fujak <t.fujak@samsung.com>,
       linux-arm-kernel@lists.infradead.org, m.szyprowski@samsung.com
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event description in sysfs
Message-ID: <20100120162647.GB7348@shareable.org>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com> <1263978999.4283.823.camel@laptop> <op.u6tslipz7p4s8u@pikus> <20100120133145.GE4089@wear.picochip.com> <1263994779.4283.1057.camel@laptop> <20100120135553.GA22897@n2100.arm.linux.org.uk> <1263996080.4283.1064.camel@laptop> <20100120144140.GB22897@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120144140.GB22897@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Wed, Jan 20, 2010 at 03:01:20PM +0100, Peter Zijlstra wrote:
> > On Wed, 2010-01-20 at 13:55 +0000, Russell King - ARM Linux wrote:
> > > 
> > > Unfortunately, it isn't.  CPU identification has become a fairly murky
> > > business on ARM that the information exported from /proc/cpuinfo can
> > > no longer precisely identify the CPU itself.
> > > 
> > > For example, we just treat Cortex A8 and A9 as "ARMv7" because from the
> > > kernel's point of view, they're the same. 
> > 
> > Would it make sense to extend arm's cpuinfo to include enough
> > information so that userspace can indeed do this?
> 
> The idea that "I'm running on a Cortex A9" is no longer provided by the
> new CPU ID scheme.  Instead, what's now provided is a set of registers
> which describe various individual features of the CPU:
> 
> - ThumbEE ISA level, Jazelle ISA level, Thumb ISA level, ARM ISA level.
> - Programmer model (not much here that userspace would be interested in)
> - Debug model (memory mapped/co-processor, v6 debug architecture, v7 debug
>   architecture.)
> - Four 32-bit registers describing the memory model.
> 
> Note that pre-ARMv6k does not provide this information.  Plus, the
> interpretation of these registers change between ARMv6k and ARMv7 -
> and I wouldn't be surprised if the interpretation changes in the
> future - just like the 'cache type' register completely changed format
> on ARMv7.
> 
> > It seems to me userspace might care about the exact platform they're
> > running on.
> 
> It may wanted to care at one time, but as time goes on, knowing what
> the high-level chip is will be come irrelevent, and is actually the
> wrong question.
> 
> The real questions that userspace needs to ask are the specific ones,
> such as "what ARM ISA level is supported?  what Thumb ISA level is
> supported?  what debug model is implemented?"
> 
> Given that history has shown that identification schemes on ARM change
> in extremely annoying ways, I don't think decoding these registers to
> some kind of textual representation for /proc/cpuinfo is the right
> approach.  It might instead make more sense to just export the entire
> set of CPU ID registers to userspace, and let userspace grapple with
> the complexities of decoding the information it wants from them.

In practice, the list of capabilities works well on x86 in /proc/cpuinfo:

    flags : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr pdcm

They are based on the feature bits from the CPU's cpuid instruction,
but the kernel does things like apply errata quirks to remove bits
that don't work on a particular implementation and show the lowest common
denominator when there are multiple CPUs.

Userspace tends to look for features it cares about (e.g. sse means
sse instructions are available), and doesn't need to know anything
about murky details of different CPUs.

Many of the features aren't relevant to userspace; the rest tend to
indicate the presence of particular instructions.

On ARM, it would be great to have a simple set of features in
/proc/cpuinfo indicating which instruction sets are available (and
reliable).

-- Jamie
