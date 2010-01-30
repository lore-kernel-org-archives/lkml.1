Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401Ab0A3JyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0A3JyD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 04:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337Ab0A3Jxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 04:53:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:46174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab0A3Jx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 04:53:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,373,1262592000"; 
   d="scan'208";a="536027263"
Message-Id: <20100130094957.692671259@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 30 Jan 2010 17:45:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Jamie Lokier <jamie@shareable.org>, Roland Dreier <rdreier@cisco.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
References: <20100130094515.475881280@intel.com>
Content-Disposition: inline; filename=constant-hweight32.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows use of hweight_long() in BUILD_BUG_ON().
Suggested by Jamie.

CC: Jamie Lokier <jamie@shareable.org>
CC: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/bitops.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- linux-mm.orig/include/linux/bitops.h	2009-07-20 20:10:19.000000000 +0800
+++ linux-mm/include/linux/bitops.h	2010-01-30 17:41:15.000000000 +0800
@@ -40,10 +40,14 @@ static __inline__ int get_count_order(un
 	return order;
 }
 
-static inline unsigned long hweight_long(unsigned long w)
-{
-	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
-}
+#define hweight_long(x)				\
+(						\
+	__builtin_constant_p(x) ?		\
+		__builtin_popcountl(x) :	\
+		(sizeof(x) <= 4 ?		\
+			 hweight32(x) :		\
+			 hweight64(x))		\
+)
 
 /**
  * rol32 - rotate a 32-bit value left


