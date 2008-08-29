Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYH2Lpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYH2Lpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYH2LpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:45:21 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:13661 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbYH2LpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:45:20 -0400
Message-Id: <48B7FDBA.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 12:46:34 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] BUILD_BUG_ON() should not use array type
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With gcc's extension of variable size arrays, using the size of an
array type for BUILD_BUG_ON() doesn't always work, since non-constant
conditions aren't being detected, and hence the intention of the
construct cannot be met anymore. It is therefore necessary to use a
construct where all compilers can be expected to only accept constant
expressions with certain values being invalid, and the only thing I
could think of are bit-fields.

Note that in the virtio_config.h case MAYBE_BUILD_BUG_ON() really just
serves documentation purposes - even if the expression is compile time
constant (__builtin_constant_p() yields true), the array is still deemed
of variable length by gcc, and hence the whole expression doesn#t have
the intended effect.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/net/niu.c             |    2 +-
 include/linux/kernel.h        |    8 ++++++--
 include/linux/virtio_config.h |    3 +--
 3 files changed, 8 insertions(+), 5 deletions(-)

--- linux-2.6.27-rc5/drivers/net/niu.c	2008-08-21 14:37:31.000000000 +0200
+++ 2.6.27-rc5-build-bug-on/drivers/net/niu.c	2008-08-28 16:51:40.000000000 +0200
@@ -5144,7 +5144,7 @@ static void niu_init_tx_mac(struct niu *
 	/* The XMAC_MIN register only accepts values for TX min which
 	 * have the low 3 bits cleared.
 	 */
-	BUILD_BUG_ON(min & 0x7);
+	BUG_ON(min & 0x7);
 
 	if (np->flags & NIU_FLAGS_XMAC)
 		niu_init_tx_xmac(np, min, max);
--- linux-2.6.27-rc5/include/linux/kernel.h	2008-08-21 14:37:35.000000000 +0200
+++ 2.6.27-rc5-build-bug-on/include/linux/kernel.h	2008-08-28 15:10:28.000000000 +0200
@@ -468,13 +468,17 @@ struct sysinfo {
 };
 
 /* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
+
+/* Force a compilation error if condition is constant and true */
+#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
 
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
    aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)BUILD_BUG_ON_ZERO(e))
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
--- linux-2.6.27-rc5/include/linux/virtio_config.h	2008-08-21 14:37:35.000000000 +0200
+++ 2.6.27-rc5-build-bug-on/include/linux/virtio_config.h	2008-08-28 15:08:47.000000000 +0200
@@ -96,8 +96,7 @@ static inline bool virtio_has_feature(co
 				      unsigned int fbit)
 {
 	/* Did you forget to fix assumptions on max features? */
-	if (__builtin_constant_p(fbit))
-		BUILD_BUG_ON(fbit >= 32);
+	MAYBE_BUILD_BUG_ON(fbit >= 32);
 
 	virtio_check_driver_offered_feature(vdev, fbit);
 	return test_bit(fbit, vdev->features);



