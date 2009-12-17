Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbZLQAkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbZLQAkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763454AbZLQAk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:40:29 -0500
Received: from mgate.redback.com ([155.53.3.41]:37667 "EHLO mgate.redback.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763455AbZLQAk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:40:26 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2009 19:40:26 EST
X-IronPort-AV: E=Sophos;i="4.47,409,1257148800"; 
   d="scan'208";a="6862130"
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH] Improve hash function used for full_name_hash()
Date: Wed, 16 Dec 2009 16:23:53 -0800
Message-Id: <1261009433-6332-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hash function currently used for full_name_hash() produces a large number
of collisions if hashed names are similar. This can cause performance problems
if a large number of similar names exist in the kernel (e.g., if there is
a large number of virtual interfaces).

For example, when hashing "eth0" .. "eth9999" with a hash table size of 256,
the resulting minimum hash bucket depth is 0, the maximum depth is 563,
and the standard deviation is ~136.

With this patch applied, the same test results in a minimum bucket depth
of 37, a maximum bucket depth of 42, and a standard deviation of ~1.02.

The hash factor of 41 was chosen for the following reasons:
- The resulting standard deviation is significantly better than the standard
  deviation of the original hash function for all tested hash table sizes
  (2^x, x=4..16).
- The hash function is simple.
- The resulting code does not require a multiply instruction
  (tested: x86, mips, powerpc).
- The resulting code is more efficient than the code generated for the
  original hash (x86, gcc -O2: 3 instead of 7 instructions).

The problem was found when creating a large number of virtual interfaces for
test purposes. As the number of interfaces gets larger, the kernel spent most
of its time in name search functions when adding additional interfaces.
With this patch applied, the amount of time spent in name search functions
was negligible.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 include/linux/dcache.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 30b93b2..772755d 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -53,7 +53,7 @@ extern struct dentry_stat_t dentry_stat;
 static inline unsigned long
 partial_name_hash(unsigned long c, unsigned long prevhash)
 {
-	return (prevhash + (c << 4) + (c >> 4)) * 11;
+	return (prevhash + c) * 41;
 }
 
 /*
-- 
1.6.0.4

