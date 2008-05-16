Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbYEPRoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbYEPRoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbYEPRoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:44:44 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54898 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752569AbYEPRon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:44:43 -0400
Message-ID: <482DC807.6080406@sgi.com>
Date: Fri, 16 May 2008 10:44:39 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, travis@sgi.com
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86-64 NODES_SHIFT compile failure.
References: <20080516165456.GA30854@codemonkey.org.uk>
In-Reply-To: <20080516165456.GA30854@codemonkey.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 4323838215184f5a2f081e0d17b8d60731b03164 added this line to x86's Kconfig..
> 
>  config NODES_SHIFT
>         int
> +       range 1 15  if X86_64
>         default "6" if X86_64
>         default "4" if X86_NUMAQ
>         default "3"
> 
> Selecting 15 causes:
> 
> drivers/base/node.c: In function â€˜node_read_distanceâ€™:
> drivers/base/node.c:140: error: size of array â€˜type nameâ€™ is negative
> 
> Should the upper limit be reduced to 14 (which compiles), or should
> the BUILD_BUG_ON be changed to somehow cope with this set of changes?
> 
> 	Dave
> 

A later patch changed it to 9 which is the current real limit of NODES_SHIFT
(or at least the fully tested limit).  I think it might be in Ingo's
sched/latest tree, but here it is again.. (cleaned up with MAXSMP not included.)


Subject: [PATCH 1/1] x86: change maximum NR_CPUS to 4096 and MAX_NUMNODES to 512

  * Change the range of NR_CPUS from 2-255 to 2-4096 and change the
    range of MAX_NUMNODES (NODES_SHIFT) from 1-32768 to 1-512.

  * Alter comment about how much each increment of NR_CPUS consumes.
    (This was found by configuring for 256 cpus and then 512 cpus
     and dividing the difference by 256.)

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6-next.orig/arch/x86/Kconfig
+++ linux-2.6-next/arch/x86/Kconfig
@@ -566,18 +566,18 @@ config IOMMU_HELPER
 	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB)
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-255)"
-	range 2 255
+	int "Maximum number of CPUs (2-4096)"
+	range 2 4096
 	depends on SMP
 	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
 	default "8"
 	help
 	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  The maximum supported value is 255 and the
+	  kernel will support.  The maximum supported value is 4096 and the
 	  minimum value which makes sense is 2.
 
 	  This is purely to save memory - each supported CPU adds
-	  approximately eight kilobytes to the kernel image.
+	  approximately one kilobyte to the kernel image.
 
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"
@@ -969,8 +969,8 @@ config NUMA_EMU
 	  number of nodes. This is only useful for debugging.
 
 config NODES_SHIFT
-	int "Max num nodes shift(1-15)"
-	range 1 15  if X86_64
+	int "Max num nodes shift(1-9)"
+	range 1 9  if X86_64
 	default "6" if X86_64
 	default "4" if X86_NUMAQ
 	default "3"
