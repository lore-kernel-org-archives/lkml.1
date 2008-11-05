Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYKEXYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYKEXYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYKEXXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:23:54 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:40650 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYKEXXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:23:54 -0500
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2008 18:23:54 EST
Message-Id: <20081105231646.764343476@quilx.com>
References: <20081105231634.133252042@quilx.com>
User-Agent: quilt/0.46-1
Date: Wed, 05 Nov 2008 17:16:35 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: travis@sgi.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Subject: [patch 1/7] Increase default reserve percpu area
Content-Disposition: inline; filename=cpu_alloc_increase_percpu_default
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB now requires a portion of the per cpu reserve. There are on average
about 70 real slabs on a system (aliases do not count) and each needs 12 bytes
of per cpu space. Thats 840 bytes. In debug mode all slabs will be real slabs
which will make us end up with 150 -> 1800.

Things work fine without this patch but then slub will reduce the percpu reserve
for modules.

Percpu data must be available regardless if modules are in use or not. So get
rid of the #ifdef CONFIG_MODULES.

Make the size of the percpu area dependant on the size of a machine word. That
way we have larger sizes for 64 bit machines. 64 bit machines need more percpu
memory since the pointer and counters may have double the size. Plus there is
lots of memory available on 64 bit.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2008-11-05 12:05:46.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2008-11-05 14:29:15.000000000 -0600
@@ -44,7 +44,7 @@
 extern unsigned int percpu_reserve;
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_AREA_SIZE
-#define PERCPU_RESERVE_SIZE	8192
+#define PERCPU_RESERVE_SIZE   (sizeof(unsigned long) * 2500)
 
 #define PERCPU_AREA_SIZE						\
 	(__per_cpu_end - __per_cpu_start + percpu_reserve)

-- 
