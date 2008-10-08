Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYJHGj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYJHGj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYJHGic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:38:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:41681 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbYJHGib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=dVfT5ERsnsXeprOrNkTZSE2jeSE+3okZFQKARXN8lLy9QJiUxNgzbUm0jDzwOay/7o
         LwFK77VdIAkqZFmaw+va6x9wA8A3Zg5IqfddtFb2NIHx1A05pJxtKkYXVx3/6bR1k9jl
         bz5RVKFurRhcKCnnc3KgjJ8Kire0rBG7xvi/0=
Subject: [PATCH 4/4] unaligned: remove now unused memmove-based access
 implementation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 23:38:25 -0700
Message-Id: <1223447905.8195.68.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, this depends on 1-3 being accepted.

 include/linux/unaligned/be_memmove.h |   36 ---------------------------
 include/linux/unaligned/le_memmove.h |   36 ---------------------------
 include/linux/unaligned/memmove.h    |   45 ----------------------------------
 3 files changed, 0 insertions(+), 117 deletions(-)

diff --git a/include/linux/unaligned/be_memmove.h b/include/linux/unaligned/be_memmove.h
deleted file mode 100644
index c2a76c5..0000000
--- a/include/linux/unaligned/be_memmove.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _LINUX_UNALIGNED_BE_MEMMOVE_H
-#define _LINUX_UNALIGNED_BE_MEMMOVE_H
-
-#include <linux/unaligned/memmove.h>
-
-static inline u16 get_unaligned_be16(const void *p)
-{
-	return __get_unaligned_memmove16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_be32(const void *p)
-{
-	return __get_unaligned_memmove32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_be64(const void *p)
-{
-	return __get_unaligned_memmove64((const u8 *)p);
-}
-
-static inline void put_unaligned_be16(u16 val, void *p)
-{
-	__put_unaligned_memmove16(val, p);
-}
-
-static inline void put_unaligned_be32(u32 val, void *p)
-{
-	__put_unaligned_memmove32(val, p);
-}
-
-static inline void put_unaligned_be64(u64 val, void *p)
-{
-	__put_unaligned_memmove64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_LE_MEMMOVE_H */
diff --git a/include/linux/unaligned/le_memmove.h b/include/linux/unaligned/le_memmove.h
deleted file mode 100644
index 269849b..0000000
--- a/include/linux/unaligned/le_memmove.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _LINUX_UNALIGNED_LE_MEMMOVE_H
-#define _LINUX_UNALIGNED_LE_MEMMOVE_H
-
-#include <linux/unaligned/memmove.h>
-
-static inline u16 get_unaligned_le16(const void *p)
-{
-	return __get_unaligned_memmove16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_le32(const void *p)
-{
-	return __get_unaligned_memmove32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_le64(const void *p)
-{
-	return __get_unaligned_memmove64((const u8 *)p);
-}
-
-static inline void put_unaligned_le16(u16 val, void *p)
-{
-	__put_unaligned_memmove16(val, p);
-}
-
-static inline void put_unaligned_le32(u32 val, void *p)
-{
-	__put_unaligned_memmove32(val, p);
-}
-
-static inline void put_unaligned_le64(u64 val, void *p)
-{
-	__put_unaligned_memmove64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_LE_MEMMOVE_H */
diff --git a/include/linux/unaligned/memmove.h b/include/linux/unaligned/memmove.h
deleted file mode 100644
index eeb5a77..0000000
--- a/include/linux/unaligned/memmove.h
+++ /dev/null
@@ -1,45 +0,0 @@
-#ifndef _LINUX_UNALIGNED_MEMMOVE_H
-#define _LINUX_UNALIGNED_MEMMOVE_H
-
-#include <linux/kernel.h>
-#include <linux/string.h>
-
-/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
-
-static inline u16 __get_unaligned_memmove16(const void *p)
-{
-	u16 tmp;
-	memmove(&tmp, p, 2);
-	return tmp;
-}
-
-static inline u32 __get_unaligned_memmove32(const void *p)
-{
-	u32 tmp;
-	memmove(&tmp, p, 4);
-	return tmp;
-}
-
-static inline u64 __get_unaligned_memmove64(const void *p)
-{
-	u64 tmp;
-	memmove(&tmp, p, 8);
-	return tmp;
-}
-
-static inline void __put_unaligned_memmove16(u16 val, void *p)
-{
-	memmove(p, &val, 2);
-}
-
-static inline void __put_unaligned_memmove32(u32 val, void *p)
-{
-	memmove(p, &val, 4);
-}
-
-static inline void __put_unaligned_memmove64(u64 val, void *p)
-{
-	memmove(p, &val, 8);
-}
-
-#endif /* _LINUX_UNALIGNED_MEMMOVE_H */
-- 
1.6.0.2.471.g47a76

