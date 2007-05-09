Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbXEIWQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbXEIWQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbXEIWQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:16:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:31570 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbXEIWQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:16:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="241396130"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] Call percpu smp cacheline algin interface
Date: Wed, 9 May 2007 15:16:11 -0700
Message-ID: <A29F7A5700A7EA4380E08C1F68C3B6D802B5F702@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070509133328.c79ef48e.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] Call percpu smp cacheline algin interface
Thread-Index: AceSeV97o8/1jAEgSw6GJ3v1OsB3FQABSGkg
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <linux-kernel@vger.kernel.org>, <clameter@sgi.com>
X-OriginalArrivalTime: 09 May 2007 22:16:12.0668 (UTC) FILETIME=[A7324BC0:01C79287]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>hm, DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED is a bit of a mouthful.

>I wonder if we can improve things here so that we use the
runtime-detected
>cacheline size rather than the compile-time size.  I guess not, given
that
>the offsets into the percpu area are calculated at build-time.

>Did you work out how much space this change will actually save?  It
>should be available by suitable crunching on the nm and objdump output.

Depending on how data fields are arranged by linker, the patches could
save or waste per_cpu size. Below is data I got.


Case 1: On linux-2.6.21-rc7-mm2 with defconfig build.
Case 2: On linux-2.6.21-rc7-mm2 plus the patches in this thread with
defconfig build.
Case 3: On linux-2.6.21-rc7-mm2 with defconfig with VSMP=y build.
Case 4: On linux-2.6.21-rc7-mm2 plus the patches in this thread with
defconfig with VSMP=y build.

Please note that on x86/x86-64, per_cpu_init_tss is placed in the first
place in per_cpu section in Case 1 and 3. And thus there is no padding
waste for per_cpu_init_tss in Case 1 and 3.

On X86:
Case 1: Size of per_cpu section is: 0x7768
Case 2: Size of per_cpu section is: 0x790c
The patches waste 0x1a4 bytes.

per_cpu__init_tss, per_cpu__irq_stat, and per_cpu__runqueues are moved
to shared_cacheline_aligned section.

On X86-64:
Case 1: Size of per_cpu section is: 0x72d0
Case 2: Size of per_cpu section is: 0x6540
The patches save 0xd90 bytes.

Case 3: Size of per_cpu section is: 0x72d0
Case 4: Size of per_cpu section is: 0x8340
The patches waste 0x1070 bytes. 

Shall we not use shared_cacheline_aligned section for VSMP case? The
waste of cache eventually may offset the potential gain of alignment.

Probably need to set up a cache line size threshold: if L1 cache line
size is bigger than a number CACHELINE_ALIGN_SHRESHOLD, don't do
cacheline alignment.

per_cpu__init_tss and per_cpu__runqueues are moved to
shared_cacheline_aligned section.

On ia64:
Case 1: Size of per_cpu section is: 0x8370
Case 2: Size of per_cpu section is: 0x7fc0
The patches save 0x3b0 bytes.

per_cpu_ipi_operation and per_cpu_runqueues are moved to
shared_cacheline_aligned section
