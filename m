Return-Path: <linux-kernel-owner+w=401wt.eu-S1760619AbXEYKpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619AbXEYKpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 06:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXEYKph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 06:45:37 -0400
Received: from c3po.0xdef.net ([217.172.181.57]:4571 "EHLO c3po.0xdef.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbXEYKpg (ORCPT <rfc822;linux-kerneL@vger.kernel.org>);
	Fri, 25 May 2007 06:45:36 -0400
X-Greylist: delayed 1562 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 06:45:36 EDT
Date: Fri, 25 May 2007 12:19:33 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: linux-kerneL@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Hagen Paul Pfeifer <pfeifer@netlab.nec.de>
Subject: INTERNODE_CACHE_SHIFT redefinition for hot spot data alignment
Message-ID: <20070525101933.GB32742@c3po.0xdef.net>
Mail-Followup-To: Hagen Paul Pfeifer <hagen@jauu.net>,
	linux-kerneL@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Hagen Paul Pfeifer <pfeifer@netlab.nec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I read code in include/linux/mmzone.h and attract attention to the padding
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

BTW: the superior solution is to utilize the gcc 4.2 alternative to use the
cpuid instruction (which is new in gcc release 4.2) to gather cpu attributes
at compile time and replace the static 
#define L1_CACHE_BYTES  (1 << L1_CACHE_SHIFT)
macros

My suggestion is added as an patch -- any superior suggestions

Shalom
Hagen Paul Pfeifer




Increase (double) the definition for INTERNODE_CACHE_SHIFT to accommodate a
higher cache line size for l2 and l3 cacheline sizes - compared to l1 cache
line size. The introduced overhead for architectures where the l1 cache line
size correspond to the l2  cache line size is evanescent small, cause
INTERNODE_CACHE_SHIFT is used only for hot spots.
---
 include/linux/cache.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.4.4.4

