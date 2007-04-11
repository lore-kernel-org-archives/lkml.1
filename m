Return-Path: <linux-kernel-owner+w=401wt.eu-S1161204AbXDKFLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161204AbXDKFLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 01:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161198AbXDKFLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 01:11:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44900
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161195AbXDKFLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 01:11:00 -0400
Date: Tue, 10 Apr 2007 22:11:01 -0700 (PDT)
Message-Id: <20070410.221101.110908614.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
       heiko.carstens@de.ibm.com
Subject: Re: link error : 2.6.21-rc6-mm1 for s390
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070410184738.dc1c5943.akpm@linux-foundation.org>
References: <20070410182937.8169c672.akpm@linux-foundation.org>
	<20070410.183629.57444787.davem@davemloft.net>
	<20070410184738.dc1c5943.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Apr 2007 18:47:38 -0700

> attribute(weak) would give a nicer result?
> 
> We'd also need to remove s390's EXPORT_SYMBOL(__div64_32), so s390 ends up
> using lib/div64.c's EXPORT_SYMBOL().

Ok, here is the version of the fix I'll use for now:

commit c3abb3b8d41814ce4691cc4cc3998b0f5242c8d0
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Tue Apr 10 22:10:39 2007 -0700

    [S390]: Fix build on 31-bit.
    
    Allow s390 to properly override the generic
    __div64_32() implementation by:
    
    1) Using obj-y for div64.o in s390's makefile instead
       of lib-y
    
    2) Adding the weak attribute to the generic implementation.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/s390/lib/Makefile b/arch/s390/lib/Makefile
index 7a44fed..59aea65 100644
--- a/arch/s390/lib/Makefile
+++ b/arch/s390/lib/Makefile
@@ -5,6 +5,6 @@
 EXTRA_AFLAGS := -traditional
 
 lib-y += delay.o string.o uaccess_std.o uaccess_pt.o qrnnd.o
-lib-$(CONFIG_32BIT) += div64.o
+obj-$(CONFIG_32BIT) += div64.o
 lib-$(CONFIG_64BIT) += uaccess_mvcos.o
 lib-$(CONFIG_SMP) += spinlock.o
diff --git a/arch/s390/lib/div64.c b/arch/s390/lib/div64.c
index 0481f34..a5f8300 100644
--- a/arch/s390/lib/div64.c
+++ b/arch/s390/lib/div64.c
@@ -147,5 +147,3 @@ uint32_t __div64_32(uint64_t *n, uint32_t base)
 }
 
 #endif /* MARCH_G5 */
-
-EXPORT_SYMBOL(__div64_32);
diff --git a/lib/div64.c b/lib/div64.c
index 74f0c8c..b71cf93 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -23,7 +23,7 @@
 /* Not needed on 64bit architectures */
 #if BITS_PER_LONG == 32
 
-uint32_t __div64_32(uint64_t *n, uint32_t base)
+uint32_t __attribute__((weak)) __div64_32(uint64_t *n, uint32_t base)
 {
 	uint64_t rem = *n;
 	uint64_t b = base;
