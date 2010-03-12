Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab0CLTvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 14:51:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:2080 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab0CLTvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 14:51:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,627,1262592000"; 
   d="scan'208";a="254107754"
Subject: Re: page_to_nid not linked in on PAE
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <ak@linux.intel.com>
In-Reply-To: <alpine.LSU.2.01.1003101128340.9318@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1003091210230.10157@obet.zrqbmnf.qr>
	 <alpine.LSU.2.01.1003101128340.9318@obet.zrqbmnf.qr>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 12 Mar 2010 11:50:24 -0800
Message-Id: <1268423424.2793.21.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 02:30 -0800, Jan Engelhardt wrote:
> On Tuesday 2010-03-09 13:32, Jan Engelhardt wrote:
> >
> >I have here a compile error with 2.6.33 related to some change in
> >page flags. The offending commit, according to bisect, is
> >
> >commit 46cf98cdaef5471926010b5bddf84c44ec177fdd
> >
> >    x86, pat: Generalize the use of page flag PG_uncached
> >    
> >$ make ARCH=i386 vmlinux
> > ...
> >  LD      .tmp_vmlinux1
> >arch/x86/built-in.o: In function `dma_generic_alloc_coherent':
> >(.text+0x42b2): undefined reference to `page_to_nid'
> ...
> 
> Due to the addition of page flags (like in the commit above),
> there are less bits to encode the node.
> In other words, reducing CONFIG_NODES_SHIFT works around the problem.
> But that can't really be a terminal solution.

Jan, Even with out using the PG_head, PG_tail, PG_uncached and
PG_hwpoison, by allowing the NODES_SHIFT to have a maximum value of 9 on
32bit kernel, can still result in the page flags to runout and result in
this problem. Best solution for now is to limit the NODES_SHIFT to 5. I
don't know of any platforms that have > 32nodes and where we care about
32bit linux kernel. So it should be ok as a fix. If someone in future
cares about > 32 nodes for 32bit kernel, then we can think of a better
solution. Do you agree? I copied Andi/Nick for their eyes aswell on
this.

Peter, Are you ok with this approach?

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86_32: limit the NODES_SHIFT to 5 to avoid page flags to run out

Jan Engelhardt reported this compilation failure with
32bit PAE kernel + !SPARSEMEM + NUMA
> arch/x86/built-in.o: In function `dma_generic_alloc_coherent':
> (.text+0x42b2): undefined reference to `page_to_nid'

This is as a result of running out the page flags to represent node id.

Currently NODES_SHIFT is limited to the max value of 9. With the value of 9
and even with !CONFIG_PAGEFLAGS_EXTENDED && !CONFIG_MEMORY_FAILURE &&
!CONFIG_ARCH_USES_PG_UNCACHED, we can easily run out the page flags
(as 9 bits for representing nid, 2 bits for representing section, leaving
21 bits for page flags. And even without the above mentioned config options
we have the need for 22 bits of page flags)

So limit the NODES_SHIFT to 5 to avoid page flags to run out on 32bit platforms.
Practically no one cares for the 32bit kernel on a platform with > 32nodes.

Reported-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eb40925..6455a34 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1181,7 +1181,9 @@ config NUMA_EMU
 
 config NODES_SHIFT
 	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
-	range 1 9
+	range 1 9 if X86_64
+	range 1 5 if X86_32
+	# On 32-bit, too big of NODES_SHIFT can cause the page flags to run out.
 	default "9" if MAXSMP
 	default "6" if X86_64
 	default "4" if X86_NUMAQ


