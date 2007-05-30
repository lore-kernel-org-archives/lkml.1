Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbXE3JuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbXE3JuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXE3JuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:50:11 -0400
Received: from c3po.0xdef.net ([217.172.181.57]:1199 "EHLO c3po.0xdef.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbXE3JuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:50:09 -0400
Date: Wed, 30 May 2007 11:50:07 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Hagen Paul Pfeifer <pfeifer@netlab.nec.de>
Subject: [PATCH] INTERNODE_CACHE_SHIFT redefinition for hot spot structures
Message-ID: <20070530095007.GA24087@c3po.0xdef.net>
Reply-To: Hagen Paul Pfeifer <pfeifer@netlab.nec.de>
Mail-Followup-To: Hagen Paul Pfeifer <pfeifer@netlab.nec.de>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=iso-8859-1; format=fixed
Content-Disposition: inline

I followed code in include/linux/mmzone.h and attract attention to the padding
construct for struct zone:

struct zone_padding {
  char x[0];
} ____cacheline_internodealigned_in_smp;
                                                                                                                                                                                                                    
The definition for ____cacheline_internodealigned_in_smp
is definded as __attribute__((__aligned__(1 << (INTERNODE_CACHE_SHIFT))))                                                                                                                                          

INTERNODE_CACHE_SHIFT in turn is defined as L1_CACHE_SHIFT for all
architectures (expect x86_64) as L1_CACHE_SHIFT - which is not that what
everybody should expected if they use ____cacheline_internodealigned_in_smp!
The comment stated out: "The maximum alignment needed for some critical
structures. These could be inter-node cacheline sizes/L3 cacheline size etc.
Define this in asm/cache.h for your arch"                                                                                                                                                                           
If a architecture redefine INTERNODE_CACHE_SHIFT (as x86_64) this patch has no
effects at all. All other architecture will profit from a better cache line
utilization.

The superior solution is to utilize the gcc 4.2 alternative to use the cpuid
instruction (which is new in gcc release 4.2) to gather CPU attributes at
compile time and replace the static
#define L1_CACHE_BYTES  (1 << L1_CACHE_SHIFT)
macros for at least amd/intel processors- but that is another thought ...
(Which _user_ knows the l1/l2 cache line size of the current CPU if they are
different for different models (e.g P4)? If this fails -> fall back to standard
size). But as I said - this is a idea.

See gcc/config/i386/driver-i386.c:host_detect_local_cpu() for more information
in the gcc devel branch.

Salaam
Hagen Paul Pfeifer


Increase (double) the definition for INTERNODE_CACHE_SHIFT to accommodate a
higher cache line size for l2 and l3 cacheline sizes - compared to l1 cache
line size. The introduced overhead for architectures where the l1 cache line
size correspond to the l2  cache line size is evanescent small, cause
INTERNODE_CACHE_SHIFT is used only for hot spots.

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
---
 include/linux/cache.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--dDRMvlgZJXvWKvBx
Content-Type: text/x-patch; charset=us-ascii;
	name="46130e6afdad1c3df698bde8b86ab89568a3f6d9.diff"
Content-Disposition: inline; filename="46130e6afdad1c3df698bde8b86ab89568a3f6d9.diff"
Content-Transfer-Encoding: 8bit

diff --git a/include/linux/cache.h b/include/linux/cache.h
index 4552504..ebc366c 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -48,7 +48,7 @@
  * size etc.  Define this in asm/cache.h for your arch
  */
 #ifndef INTERNODE_CACHE_SHIFT
-#define INTERNODE_CACHE_SHIFT L1_CACHE_SHIFT
+#define INTERNODE_CACHE_SHIFT (L1_CACHE_SHIFT + 1)
 #endif
 
 #if !defined(____cacheline_internodealigned_in_smp)

--dDRMvlgZJXvWKvBx--
