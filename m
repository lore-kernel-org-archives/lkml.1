Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZIZQf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZIZQf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZIZQfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:35:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbZIZQfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:35:24 -0400
Date: Sat, 26 Sep 2009 09:35:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [origin tree build failure] Re: [PULL] Please pull hwpoison code
 for 2.6.32
In-Reply-To: <20090926151740.GN30185@one.firstfloor.org>
Message-ID: <alpine.LFD.2.01.0909260930410.3303@localhost.localdomain>
References: <20090916125116.GA12751@basil.fritz.box> <20090926141352.GA26117@elte.hu> <20090926151740.GN30185@one.firstfloor.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Sep 2009, Andi Kleen wrote:
> 
> Thanks for the report. The issue comes from NODES_SHIFT=4
> 
> I think I tested the NUMA case, but perhaps not with full NODES_SHIFT.
> 
> The easy fix would be to limit NODES_SHIFT to 3 for 32bit (8 nodes max). Do you
> have any problems with that? I doubt there are any >8 nodes NUMAQs left.
> (last time I heard the last machine at IBM was down to < 4)

No, just say "we don't support HWPOISON on 32-bit NUMA". 

Maybe simply using something like this.

TOTALLY UNTESTED!

		Linus
---
 arch/x86/Kconfig |    6 ++++++
 mm/Kconfig       |    4 +++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9369879..be1bb44 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -432,6 +432,12 @@ config X86_NUMAQ
 	  of Flat Logical.  You will need a new lynxer.elf file to flash your
 	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
 
+config X86_SUPPORTS_MEMORY_FAILURE
+	bool
+	depends on !X86_NUMAQ
+	select ARCH_SUPPORTS_MEMORY_FAILURE
+	default y
+
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
 	depends on X86_32 && PCI && X86_MPPARSE && PCI_GODIRECT
diff --git a/mm/Kconfig b/mm/Kconfig
index 2477607..edd300a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -244,10 +244,12 @@ config DEFAULT_MMAP_MIN_ADDR
 	  This value can be changed after boot using the
 	  /proc/sys/vm/mmap_min_addr tunable.
 
+config ARCH_SUPPORTS_MEMORY_FAILURE
+	bool
 
 config MEMORY_FAILURE
 	depends on MMU
-	depends on X86_MCE
+	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
 	help
 	  Enables code to recover from some memory failures on systems
