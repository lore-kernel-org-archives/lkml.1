Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbYDPSaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbYDPSaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYDPS3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:29:30 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:21232 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958AbYDPS31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AGxelyZ3iJ5ezT6nELmepG8RAo1QDHQsGip90zXnYP+NBAnWaNBMqMPfWYFjyy5BNZq/WU+rOldAZKU5NV77J6whN/v7mofGd/o2sRAWNH+URO6LYiR0fhsIS/VRWcxFguLBbiYOufHL7ArOfwWeeYQgx4LqMZ4YFaBVIYwbMHo=
Subject: [PATCH-mm 2/3] mac80211: michael.c use get/put_unaligned helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Benc <jbenc@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 11:29:31 -0700
Message-Id: <1208370571.11920.108.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/michael.c |   31 ++++++++-----------------------
 1 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index 36bb3bb..698d7b3 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -27,35 +27,20 @@ static void michael_block(u32 val, u32 *l, u32 *r)
 	*l += *r;
 }
 
-static u32 michael_get16(u8 *data)
-{
-	return le16_to_cpu(get_unaligned((__le16 *)data));
-}
-
-static u32 michael_get32(u8 *data)
-{
-	return le32_to_cpu(get_unaligned((__le32 *)data));
-}
-
-static void michael_put32(u32 val, u8 *data)
-{
-	put_unaligned(cpu_to_le32(val), (__le32 *)data);
-}
-
 void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 		 u8 *data, size_t data_len, u8 *mic)
 {
 	u32 l, r, val;
 	size_t block, blocks, left;
 
-	l = michael_get32(key);
-	r = michael_get32(key + 4);
+	l = get_unaligned_le32(key);
+	r = get_unaligned_le32(key + 4);
 
 	/* A pseudo header (DA, SA, Priority, 0, 0, 0) is used in Michael MIC
 	 * calculation, but it is _not_ transmitted */
-	michael_block(michael_get32(da), &l, &r);
-	michael_block(michael_get16(da) | (michael_get16(sa) << 16), &l, &r);
-	michael_block(michael_get32(&sa[2]), &l, &r);
+	michael_block(get_unaligned_le32(da), &l, &r);
+	michael_block(get_unaligned_le16(da) | (get_unaligned_le16(sa) << 16), &l, &r);
+	michael_block(get_unaligned_le32(sa + 2), &l, &r);
 	michael_block(priority, &l, &r);
 
 	/* Real data */
@@ -63,7 +48,7 @@ void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 	left = data_len % 4;
 
 	for (block = 0; block < blocks; block++)
-		michael_block(michael_get32(&data[block * 4]), &l, &r);
+		michael_block(get_unaligned_le32(data + (block * 4)), &l, &r);
 
 	/* Partial block of 0..3 bytes and padding: 0x5a + 4..7 zeros to make
 	 * total length a multiple of 4. */
@@ -76,6 +61,6 @@ void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 	michael_block(val, &l, &r);
 	michael_block(0, &l, &r);
 
-	michael_put32(l, mic);
-	michael_put32(r, mic + 4);
+	put_unaligned_le32(l, mic);
+	put_unaligned_le32(r, mic + 4);
 }
-- 
1.5.5.144.g3e42


