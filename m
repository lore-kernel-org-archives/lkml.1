Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYHYL2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYHYL2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYHYL2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:28:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47013 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbYHYL2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:28:40 -0400
Date: Mon, 25 Aug 2008 21:28:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: linux-next:  build failure
Message-Id: <20080825212833.38550575.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Today's linux-next build (sparc64 defconfig) failed like this:

ERROR: "__BUILD_BUG_ON_non_constant" [drivers/net/sunvnet.ko] undefined!
ERROR: "__BUILD_BUG_ON_non_constant" [drivers/block/sunvdc.ko] undefined!

Probably intorduced by commit f5b5d41dd51a31fe70e3a04fb80a3b90b84c6a4e
("debug: fix BUILD_BUG_ON() for non-constant expressions").

The preprocessed code looks like this:

static inline __attribute__((always_inline)) u32 vio_dring_avail(struct vio_dring_state *dr,
      unsigned int ring_size)
{
 do { (void)sizeof(char[1 - 2*!!(!is_power_of_2(ring_size))]); if (!__builtin_constant_p(!is_power_of_2(ring_size))) __BUILD_BUG_ON_non_constant++; } while (0);

 return (dr->pending -
  ((dr->prod - dr->cons) & (ring_size - 1)));
}

I tried turning the above inline function into a macro to no avail.

I applied the following patch (which is probably not what is wanted, but
puts back what was there before).

I see from LKML that this definition of BUILD_BUG_ON is to be replaced,
so this is just a temporary measure.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 25 Aug 2008 21:16:14 +1000
Subject: [PATCH] revert BUILD_BUG_ON change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/compiler.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d7d313b..a1c082d 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -206,15 +206,9 @@ extern void __chk_io_ptr(const volatile void __iomem *);
  * ( The linker trick relies on gcc optimizing out a multiplication with
  *   constant zero - which should be reasonable enough. )
  */
-#ifndef __ASSEMBLY__
-extern unsigned int __BUILD_BUG_ON_non_constant;
-#endif
-
 #define BUILD_BUG_ON(condition)					\
 do {								\
 	(void)sizeof(char[1 - 2*!!(condition)]);		\
-	if (!__builtin_constant_p(condition))			\
-		__BUILD_BUG_ON_non_constant++;			\
 } while (0)
 
 /*
-- 
1.5.6.3


