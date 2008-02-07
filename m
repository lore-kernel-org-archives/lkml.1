Return-Path: <linux-kernel-owner+w=401wt.eu-S964808AbYBGVE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808AbYBGVE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933301AbYBGUwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:52:32 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:21486 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286AbYBGUw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VHMj2h5eE3xoeNYmFKd6rUWap2t5LhS86cSBZBLMWQYrq9cI8XuQInyJLCPe6LP1H2TpNrkdAv8uy2AcdbEKQgIqMTQVdCZYkzfM420j4n0ItwDlcKbV2Z8kIp4/XSgBRQEzPuwvc9tUWAPFSAmSp4BW+dG30LzK2MrsYugDuNw=
Subject: [PATCH] fix sparse warning from include/linux/mmzone.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 12:52:23 -0800
Message-Id: <1202417543.31361.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/mmzone.h:640:22: warning: potentially expensive pointer subtraction

The code in question was doing a pointer subtraction to find the index of
the zone argument in the node_zones array.  This essentially boils down to:

((unsigned long)zone - (unsigned long)zone->zone_pgdat->node_zones)/sizeof(struct zone)

Which can be expensive if struct zone is not a power of two.  Instead, just
calculate the offsets rather than the index in the array.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
This shows up > 30 times in an x86 allyesconfig, would be nice to get
rid of it and makes the code a little more efficient.  I believe this
is correct, unless there is a subtlety I have missed.

 include/linux/mmzone.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8d8d197..cb07758 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -637,9 +637,12 @@ static inline int is_normal_idx(enum zone_type idx)
 static inline int is_highmem(struct zone *zone)
 {
 #ifdef CONFIG_HIGHMEM
-	int zone_idx = zone - zone->zone_pgdat->node_zones;
-	return zone_idx == ZONE_HIGHMEM ||
-		(zone_idx == ZONE_MOVABLE && zone_movable_is_highmem());
+	const int highmem_off = ZONE_HIGHMEM * sizeof(*zone);
+	const int movable_off = ZONE_MOVABLE * sizeof(*zone);
+
+	int zone_off = (unsigned long)zone - (unsigned long)zone->zone_pgdat->node_zones;
+	return zone_off == highmem_off ||
+		(zone_off == movable_off && zone_movable_is_highmem());
 #else
 	return 0;
 #endif
-- 
1.5.4.1219.g65b9



