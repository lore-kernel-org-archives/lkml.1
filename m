Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbXEIWy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbXEIWy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbXEIWxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:53:36 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759826AbXEIWxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:53:31 -0400
Date: Wed, 9 May 2007 15:53:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <linux-kernel@vger.kernel.org>, <clameter@sgi.com>
Subject: Re: [PATCH 2/2] Call percpu smp cacheline algin interface
Message-Id: <20070509155326.5e02f60d.akpm@linux-foundation.org>
In-Reply-To: <A29F7A5700A7EA4380E08C1F68C3B6D802B5F702@scsmsx411.amr.corp.intel.com>
References: <20070509133328.c79ef48e.akpm@linux-foundation.org>
	<A29F7A5700A7EA4380E08C1F68C3B6D802B5F702@scsmsx411.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 15:16:11 -0700
"Yu, Fenghua" <fenghua.yu@intel.com> wrote:

> 
> >hm, DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED is a bit of a mouthful.
> 
> >I wonder if we can improve things here so that we use the
> runtime-detected
> >cacheline size rather than the compile-time size.  I guess not, given
> that
> >the offsets into the percpu area are calculated at build-time.
> 
> >Did you work out how much space this change will actually save?  It
> >should be available by suitable crunching on the nm and objdump output.
> 
> Depending on how data fields are arranged by linker, the patches could
> save or waste per_cpu size. Below is data I got.
> 
> 
> Case 1: On linux-2.6.21-rc7-mm2 with defconfig build.
> Case 2: On linux-2.6.21-rc7-mm2 plus the patches in this thread with
> defconfig build.
> Case 3: On linux-2.6.21-rc7-mm2 with defconfig with VSMP=y build.
> Case 4: On linux-2.6.21-rc7-mm2 plus the patches in this thread with
> defconfig with VSMP=y build.
> 
> Please note that on x86/x86-64, per_cpu_init_tss is placed in the first
> place in per_cpu section in Case 1 and 3. And thus there is no padding
> waste for per_cpu_init_tss in Case 1 and 3.
> 
> On X86:
> Case 1: Size of per_cpu section is: 0x7768
> Case 2: Size of per_cpu section is: 0x790c
> The patches waste 0x1a4 bytes.
> 
> per_cpu__init_tss, per_cpu__irq_stat, and per_cpu__runqueues are moved
> to shared_cacheline_aligned section.
> 
> On X86-64:
> Case 1: Size of per_cpu section is: 0x72d0
> Case 2: Size of per_cpu section is: 0x6540
> The patches save 0xd90 bytes.
> 
> Case 3: Size of per_cpu section is: 0x72d0
> Case 4: Size of per_cpu section is: 0x8340
> The patches waste 0x1070 bytes. 
> 
> Shall we not use shared_cacheline_aligned section for VSMP case? The
> waste of cache eventually may offset the potential gain of alignment.
> 
> Probably need to set up a cache line size threshold: if L1 cache line
> size is bigger than a number CACHELINE_ALIGN_SHRESHOLD, don't do
> cacheline alignment.
> 
> per_cpu__init_tss and per_cpu__runqueues are moved to
> shared_cacheline_aligned section.
> 
> On ia64:
> Case 1: Size of per_cpu section is: 0x8370
> Case 2: Size of per_cpu section is: 0x7fc0
> The patches save 0x3b0 bytes.
> 
> per_cpu_ipi_operation and per_cpu_runqueues are moved to
> shared_cacheline_aligned section

erm, it's not obviosu from all this that the patches are worth proceeding
with, are they?
