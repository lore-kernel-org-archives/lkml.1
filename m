Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbYBMUg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbYBMUg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbYBMUgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:36:18 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:6943 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYBMUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:36:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=INfIqcjiYI/bIuvEwV9MsR1rXvMXC7ONqsFKlKIOLIyh7nnkJr8TeTDYqEWIKtgK/hFifSCo0uA6MqsFFnfr34rAZwNlOwUjPD6eg50OqMi8qqWlZlZeKQawXaR0GTLAo1U1oenujvwpLwEHCGZrQlmXjrj5PHoOyXtgpk4DbmM=
Subject: [PATCH] remove sparse warning for mmzone.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1202932606.6238.16.camel@brick>
References: <1202417543.31361.5.camel@brick>
	 <20080208135154.ccdac0c1.akpm@linux-foundation.org>
	 <alpine.LFD.1.00.0802081401410.2896@woody.linux-foundation.org>
	 <alpine.LFD.1.00.0802081421590.2896@woody.linux-foundation.org>
	 <1202932606.6238.16.camel@brick>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 12:36:10 -0800
Message-Id: <1202934970.6238.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/mmzone.h:640:22: warning: potentially expensive pointer subtraction

Calculate the offset into the node_zones array rather than the index
using casts to (char *) and comparing against the index * sizeof(struct zone).

On X86_32 this saves a sar, but code size increases by one byte per
is_highmem() use due to 32-bit cmps rather than 16 bit cmps.

Before:
 207:   2b 80 8c 07 00 00       sub    0x78c(%eax),%eax
 20d:   c1 f8 0b                sar    $0xb,%eax
 210:   83 f8 02                cmp    $0x2,%eax
 213:   74 16                   je     22b <kmap_atomic_prot+0x144>
 215:   83 f8 03                cmp    $0x3,%eax
 218:   0f 85 8f 00 00 00       jne    2ad <kmap_atomic_prot+0x1c6>
 21e:   83 3d 00 00 00 00 02    cmpl   $0x2,0x0
 225:   0f 85 82 00 00 00       jne    2ad <kmap_atomic_prot+0x1c6>
 22b:   64 a1 00 00 00 00       mov    %fs:0x0,%eax

After:
 207:   2b 80 8c 07 00 00       sub    0x78c(%eax),%eax
 20d:   3d 00 10 00 00          cmp    $0x1000,%eax
 212:   74 18                   je     22c <kmap_atomic_prot+0x145>
 214:   3d 00 18 00 00          cmp    $0x1800,%eax
 219:   0f 85 8f 00 00 00       jne    2ae <kmap_atomic_prot+0x1c7>
 21f:   83 3d 00 00 00 00 02    cmpl   $0x2,0x0
 226:   0f 85 82 00 00 00       jne    2ae <kmap_atomic_prot+0x1c7>
 22c:   64 a1 00 00 00 00       mov    %fs:0x0,%eax

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/mmzone.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8d8d197..3109a65 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -637,9 +637,10 @@ static inline int is_normal_idx(enum zone_type idx)
 static inline int is_highmem(struct zone *zone)
 {
 #ifdef CONFIG_HIGHMEM
-	int zone_idx = zone - zone->zone_pgdat->node_zones;
-	return zone_idx == ZONE_HIGHMEM ||
-		(zone_idx == ZONE_MOVABLE && zone_movable_is_highmem());
+	int zone_off = (char *)zone - (char *)zone->zone_pgdat->node_zones;
+	return zone_off == ZONE_HIGHMEM * sizeof(*zone) ||
+	       (zone_off == ZONE_MOVABLE * sizeof(*zone) &&
+	        zone_movable_is_highmem());
 #else
 	return 0;
 #endif
-- 
1.5.4.1.1278.gc75be



