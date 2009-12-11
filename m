Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbZLKKiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbZLKKiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbZLKKiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:38:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56628 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714AbZLKKiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:38:50 -0500
Date: Fri, 11 Dec 2009 11:38:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jamie Iles <jamie.iles@picochip.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
Message-ID: <20091211103848.GA9947@elte.hu>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com>
 <20091211102316.GB16882@elte.hu>
 <20091211103030.GC4164@wear.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211103030.GC4164@wear.picochip.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jamie Iles <jamie.iles@picochip.com> wrote:

> On Fri, Dec 11, 2009 at 11:23:16AM +0100, Ingo Molnar wrote:
> > cpu_relax() looks fine, but rmb() seems not to match the one that can be 
> > found in arch/arm/:
> > 
> > arch/arm/include/asm/system.h:#define rmb()		dmb()
> > arch/arm/include/asm/system.h:#define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
> > arch/arm/include/asm/system.h:#define smp_rmb()	rmb()
> > 
> > arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("dmb" : : : "memory")
> > arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 5" \
> > arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("" : : : "memory")
> > arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("" : : : "memory")
>
> The implementation of the barriers depend on the CPU arch revision 
> which is defined in the kernel config. As the perf tools don't use the 
> kernel config, we don't know here what arch revision we're building 
> for. Perhaps we need a LINUX_ARM_ARCH parameter when building for ARM 
> so we can pick the correct one.

rmb() is used in two places in perf:

 tools/perf/builtin-record.c:    rmb();
 tools/perf/builtin-top.c:       rmb();

to interact with the shared kernel/user ring-buffer. Getting a barrier 
wrong there may cause hickups in recording.

Could you tell me a bit more about this ARM instruction - is the 'DMB' 
instruction used on all SMP ARM cores? Can it be used unconditionally, 
or is the instruction undefined on certain versions? To get the ball 
rolling we could use it unconditionally in the initial patch, but this 
needs to be solved i suspect.

	Ingo
