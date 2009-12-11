Return-Path: <linux-kernel-owner+w=401wt.eu-S1761121AbZLKLA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121AbZLKLA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760481AbZLKLA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:00:26 -0500
Received: from mail2.picochip.com ([82.111.145.34]:60115 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760928AbZLKLAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:00:25 -0500
Date: Fri, 11 Dec 2009 11:01:11 +0000
From: Jamie Iles <jamie.iles@picochip.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jamie Iles <jamie.iles@picochip.com>, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
Message-ID: <20091211110111.GD4164@wear.picochip.com>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com> <20091211102316.GB16882@elte.hu> <20091211103030.GC4164@wear.picochip.com> <20091211103848.GA9947@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211103848.GA9947@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Fri, 11 Dec 2009 10:59:58 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 11:38:48AM +0100, Ingo Molnar wrote:
> 
> * Jamie Iles <jamie.iles@picochip.com> wrote:
> 
> > On Fri, Dec 11, 2009 at 11:23:16AM +0100, Ingo Molnar wrote:
> > > cpu_relax() looks fine, but rmb() seems not to match the one that can be 
> > > found in arch/arm/:
> > > 
> > > arch/arm/include/asm/system.h:#define rmb()		dmb()
> > > arch/arm/include/asm/system.h:#define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
> > > arch/arm/include/asm/system.h:#define smp_rmb()	rmb()
> > > 
> > > arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("dmb" : : : "memory")
> > > arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 5" \
> > > arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("" : : : "memory")
> > > arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("" : : : "memory")
> >
> > The implementation of the barriers depend on the CPU arch revision 
> > which is defined in the kernel config. As the perf tools don't use the 
> > kernel config, we don't know here what arch revision we're building 
> > for. Perhaps we need a LINUX_ARM_ARCH parameter when building for ARM 
> > so we can pick the correct one.
> 
> rmb() is used in two places in perf:
> 
>  tools/perf/builtin-record.c:    rmb();
>  tools/perf/builtin-top.c:       rmb();
> 
> to interact with the shared kernel/user ring-buffer. Getting a barrier 
> wrong there may cause hickups in recording.
> 
> Could you tell me a bit more about this ARM instruction - is the 'DMB' 
> instruction used on all SMP ARM cores? Can it be used unconditionally, 
> or is the instruction undefined on certain versions? To get the ball 
> rolling we could use it unconditionally in the initial patch, but this 
> needs to be solved i suspect.
There are a few cases we need to deal with:
	- v7 SMP: DMB instruction
	- v6 SMP: MCR coprocessor instruction
	- v5 and earlier no instructions for barriers.

Looking at the TRM for a v7 core (cortex A9) the MCR instruction that v6 uses
is deprecated but still present. I suspect we could use this to cover the v6
and v7 cores but we wouldn't be able to do soft perf events on v5 or earlier
(which don't have hardware counters).

Jamie
