Return-Path: <linux-kernel-owner+w=401wt.eu-S1752448AbZIZSLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbZIZSLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZIZSLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:11:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49828 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZIZSLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:11:30 -0400
Date: Sat, 26 Sep 2009 20:11:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [origin tree build failure] Re: [PULL] Please pull hwpoison code for 2.6.32
Message-ID: <20090926181134.GT30185@one.firstfloor.org>
References: <20090916125116.GA12751@basil.fritz.box> <20090926141352.GA26117@elte.hu> <20090926151740.GN30185@one.firstfloor.org> <alpine.LFD.2.01.0909260930410.3303@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909260930410.3303@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 09:35:07AM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 26 Sep 2009, Andi Kleen wrote:
> > 
> > Thanks for the report. The issue comes from NODES_SHIFT=4
> > 
> > I think I tested the NUMA case, but perhaps not with full NODES_SHIFT.
> > 
> > The easy fix would be to limit NODES_SHIFT to 3 for 32bit (8 nodes max). Do you
> > have any problems with that? I doubt there are any >8 nodes NUMAQs left.
> > (last time I heard the last machine at IBM was down to < 4)
> 
> No, just say "we don't support HWPOISON on 32-bit NUMA". 
> 
> Maybe simply using something like this.

That's a reasonable solution, but I would prefer to do it the other way round 
(MEMORY_FAILURE disabling NUMA) to minimize user confusion. Also it's not
enough to just do NUMAQ, but needs all of 32bit NUMA, otherwise the NODES_SHIFT
could be set too high again.

Here's a compile tested patch (don't have a NUMAQ) implementing this:

---

x86: Don't allow 32bit NUMA together with hwpoison to avoid page flags overflow

From: Andi Kleen <ak@linux.intel.com>
    
Otherwise the enlarged sparsemem field in page->flags overflows 32bit,
which breaks compilation.
    
Reported by Ingo Molnar.
Originally based on a patch from Linus.
    
Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9369879..384a897 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -423,6 +423,7 @@ config X86_32_NON_STANDARD
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
 	depends on X86_32_NON_STANDARD
+	depends on !MEMORY_FAILURE
 	select NUMA
 	select X86_MPPARSE
 	---help---
@@ -1108,6 +1109,7 @@ config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
 	depends on SMP
 	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
+	depends on !X86_32 || !MEMORY_FAILURE
 	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
 	---help---
 	  Enable NUMA (Non Uniform Memory Access) support.
@@ -1125,6 +1127,9 @@ config NUMA
 
 	  Otherwise, you should say N.
 
+comment "32bit NUMA support requires disabling MEMORY_FAILURE"
+	depends on X86_32 && MEMORY_FAILURE
+
 comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
 	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
 
