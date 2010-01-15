Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0AOBt5 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657Ab0AOBti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:49:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:59358 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab0AOBtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:49:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232971460"
Message-Id: <20100115014422.405089087@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Jan 2010 09:39:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Jamie Lokier <jamie@shareable.org>,
        Roland Dreier <rdreier@cisco.com>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
CC: Eric Paris <eparis@redhat.com>
CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: David Howells <dhowells@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/6] bitops: compile time optimization for hweight_long(CONSTANT)
References: <20100115013954.311049665@intel.com>
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

--- linux.orig/include/linux/bitops.h	2010-01-09 12:13:00.000000000 +0800
+++ linux/include/linux/bitops.h	2010-01-09 12:21:50.000000000 +0800
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


