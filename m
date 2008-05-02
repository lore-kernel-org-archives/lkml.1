Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbYEBFT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbYEBFT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 01:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYEBFTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 01:19:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:32934 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYEBFTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 01:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YYwe1U5RGstjv6xlNmZ+6dwD28CT/EjuRryj5sDs03o7Fh0EyLpYCO/pnxeYw1vGhX53bv3c7s+/i+gIybrdocUn/RlF48BE3QpOFxOMJOpJ+t+D12xg74UiXKpQXSBb2pA7QrtJJi+7nxRzSm+d5lQWV3019XxCD2hNKNnBxkk=
Subject: [PATCH 2/6] include: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 22:19:32 -0700
Message-Id: <1209705572.22362.38.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/reiserfs_fs.h      |    4 ++--
 include/linux/smb_fs.h           |   19 +++++++------------
 include/net/ieee80211_radiotap.h |    2 +-
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 4aacaee..e9963af 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -526,8 +526,8 @@ struct item_head {
 ** p is the array of __u32, i is the index into the array, v is the value
 ** to store there.
 */
-#define get_block_num(p, i) le32_to_cpu(get_unaligned((p) + (i)))
-#define put_block_num(p, i, v) put_unaligned(cpu_to_le32(v), (p) + (i))
+#define get_block_num(p, i) get_unaligned_le32((p) + (i))
+#define put_block_num(p, i, v) put_unaligned_le32((v), (p) + (i))
 
 //
 // in old version uniqueness field shows key type
diff --git a/include/linux/smb_fs.h b/include/linux/smb_fs.h
index 2c5cd55..923cd8a 100644
--- a/include/linux/smb_fs.h
+++ b/include/linux/smb_fs.h
@@ -43,18 +43,13 @@ static inline struct smb_inode_info *SMB_I(struct inode *inode)
 }
 
 /* macro names are short for word, double-word, long value (?) */
-#define WVAL(buf,pos) \
-	(le16_to_cpu(get_unaligned((__le16 *)((u8 *)(buf) + (pos)))))
-#define DVAL(buf,pos) \
-	(le32_to_cpu(get_unaligned((__le32 *)((u8 *)(buf) + (pos)))))
-#define LVAL(buf,pos) \
-	(le64_to_cpu(get_unaligned((__le64 *)((u8 *)(buf) + (pos)))))
-#define WSET(buf,pos,val) \
-	put_unaligned(cpu_to_le16((u16)(val)), (__le16 *)((u8 *)(buf) + (pos)))
-#define DSET(buf,pos,val) \
-	put_unaligned(cpu_to_le32((u32)(val)), (__le32 *)((u8 *)(buf) + (pos)))
-#define LSET(buf,pos,val) \
-	put_unaligned(cpu_to_le64((u64)(val)), (__le64 *)((u8 *)(buf) + (pos)))
+#define WVAL(buf, pos) (get_unaligned_le16((u8 *)(buf) + (pos)))
+#define DVAL(buf, pos) (get_unaligned_le32((u8 *)(buf) + (pos)))
+#define LVAL(buf, pos) (get_unaligned_le64((u8 *)(buf) + (pos)))
+
+#define WSET(buf, pos, val) put_unaligned_le16((val), (u8 *)(buf) + (pos))
+#define DSET(buf, pos, val) put_unaligned_le32((val), (u8 *)(buf) + (pos))
+#define LSET(buf, pos, val) put_unaligned_le64((val), (u8 *)(buf) + (pos))
 
 /* where to find the base of the SMB packet proper */
 #define smb_base(buf) ((u8 *)(((u8 *)(buf))+4))
diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index dfd8bf6..d364fd5 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -262,7 +262,7 @@ static inline int ieee80211_get_radiotap_len(unsigned char *data)
 	struct ieee80211_radiotap_header *hdr =
 		(struct ieee80211_radiotap_header *)data;
 
-	return le16_to_cpu(get_unaligned(&hdr->it_len));
+	return get_unaligned_le16(&hdr->it_len);
 }
 
 #endif				/* IEEE80211_RADIOTAP_H */
-- 
1.5.5.1.350.gbbbf


