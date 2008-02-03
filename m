Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYBCSiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYBCSiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYBCSif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:38:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:30475 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYBCSie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:38:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=KvU2mJRabnv3QOCxHR6GDq2VGUukzj9bi+wraz8egPrst4xQe34ciXW8ElOOTRwL2uF+5td8pK36mYD0gkz8KeDE0FnzRKrJhFLohfe7BEPkmbrzs53NnN9B7a5kHaXPOe2iljQbib8O7HfKQr7MddBuEB9tMUmTDxOwI0maPBQ=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 5/6] udf: remove unneeded kernel_timestamp type
Date: Sun,  3 Feb 2008 19:36:10 +0100
Message-Id: <1202063771-18172-6-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove now unneeded kernel_timestamp type with conversion functions

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/ecma_167.h |   13 -------------
 fs/udf/super.c    |    9 +++++----
 fs/udf/udfend.h   |   22 ----------------------
 3 files changed, 5 insertions(+), 39 deletions(-)

diff --git a/fs/udf/ecma_167.h b/fs/udf/ecma_167.h
index 5638771..a0974df 100644
--- a/fs/udf/ecma_167.h
+++ b/fs/udf/ecma_167.h
@@ -70,19 +70,6 @@ typedef struct {
 	uint8_t		microseconds;
 } __attribute__ ((packed)) timestamp;
 
-typedef struct {
-	uint16_t	typeAndTimezone;
-	int16_t		year;
-	uint8_t		month;
-	uint8_t		day;
-	uint8_t		hour;
-	uint8_t		minute;
-	uint8_t		second;
-	uint8_t		centiseconds;
-	uint8_t		hundredsOfMicroseconds;
-	uint8_t		microseconds;
-} __attribute__ ((packed)) kernel_timestamp;
-
 /* Type and Time Zone (ECMA 167r3 1/7.3.1) */
 #define TIMESTAMP_TYPE_MASK		0xF000
 #define TIMESTAMP_TYPE_CUT		0x0000
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 8a98a2e..3a7faad 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -916,12 +916,13 @@ static void udf_load_pvoldesc(struct super_block *sb, struct buffer_head *bh)
 
 	if (udf_stamp_to_time(&UDF_SB(sb)->s_record_time,
 			      pvoldesc->recordingDateAndTime)) {
-		kernel_timestamp ts;
-		ts = lets_to_cpu(pvoldesc->recordingDateAndTime);
+#ifdef UDFFS_DEBUG
+		timestamp *ts = &pvoldesc->recordingDateAndTime;
 		udf_debug("recording time %04u/%02u/%02u"
 			  " %02u:%02u (%x)\n",
-			  ts.year, ts.month, ts.day, ts.hour,
-			  ts.minute, ts.typeAndTimezone);
+			  le16_to_cpu(ts->year), ts->month, ts->day, ts->hour,
+			  ts->minute, le16_to_cpu(ts->typeAndTimezone));
+#endif
 	}
 
 	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32))
diff --git a/fs/udf/udfend.h b/fs/udf/udfend.h
index c4bd120..489f52f 100644
--- a/fs/udf/udfend.h
+++ b/fs/udf/udfend.h
@@ -24,17 +24,6 @@ static inline lb_addr cpu_to_lelb(kernel_lb_addr in)
 	return out;
 }
 
-static inline kernel_timestamp lets_to_cpu(timestamp in)
-{
-	kernel_timestamp out;
-
-	memcpy(&out, &in, sizeof(timestamp));
-	out.typeAndTimezone = le16_to_cpu(in.typeAndTimezone);
-	out.year = le16_to_cpu(in.year);
-
-	return out;
-}
-
 static inline short_ad lesa_to_cpu(short_ad in)
 {
 	short_ad out;
@@ -85,15 +74,4 @@ static inline kernel_extent_ad leea_to_cpu(extent_ad in)
 	return out;
 }
 
-static inline timestamp cpu_to_lets(kernel_timestamp in)
-{
-	timestamp out;
-
-	memcpy(&out, &in, sizeof(timestamp));
-	out.typeAndTimezone = cpu_to_le16(in.typeAndTimezone);
-	out.year = cpu_to_le16(in.year);
-
-	return out;
-}
-
 #endif /* __UDF_ENDIAN_H */
-- 
1.5.3.7

