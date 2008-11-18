Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbYKRDks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYKRDks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 22:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYKRDjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 22:39:20 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:34235 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYKRDjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:39:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=l6APyZxJ0tqG+azXu/CUPJYv9KiiaP4onqz2yhQgWyM47BICFKUd9X6exLW6avy8Sp
         GXADCIr3Td4tB0UCU0XSD5HOuuHVjdVVnQ3kIcDNT8BqSolCo87V/SozLBBZ2UUfEE0j
         5apIBzN/YXVpDlD2DfTZDV517L+m3jXlLl9/I=
Subject: [PATCH-mm 5/7] unaligned: pack the struct, not the struct members
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Will Newton <will.newton@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 19:39:12 -0800
Message-Id: <1226979552.6150.270.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is safe for the arches that currently use this as gcc says that
defining a struct as packed is equivalent to putting packed on each struct
member.

The reason this is needed is that there are some arches that define structs
to be aligned to something greater than a byte...so even if the first member
of the struct is marked as packed, gcc will still treat it as having the
default stuct alignment which will allow it to choose _builtin_memcpy...
see the comments in the memmove-using arches.  This also turned out to be
the issue with ARM (needs confirmation) because _some_ ARM compilers
have this alignment set to 4 bytes.

If the struct _itself_ is marked as packed, the compiler cannot assume this default
alignment and _must_ do the bytewise access in whatever way the arch does it.  By
making this change, the last 3 arches could move to the new asm-generic version
and the bits in linux/unaligned/ can be removed.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-generic/unaligned.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
index 8dfca50..ac23e04 100644
--- a/include/asm-generic/unaligned.h
+++ b/include/asm-generic/unaligned.h
@@ -68,9 +68,9 @@ static inline void put_unaligned_be64(u64 val, void *p)
 
 #else /* _UNALIGNED_ACCESS_OK */
 
-struct __una_u16 { u16 x __attribute__((packed)); };
-struct __una_u32 { u32 x __attribute__((packed)); };
-struct __una_u64 { u64 x __attribute__((packed)); };
+struct __una_u16 { u16 x; } __attribute__((packed));
+struct __una_u32 { u32 x; } __attribute__((packed));
+struct __una_u64 { u64 x; } __attribute__((packed));
 
 static inline u16 __get_le16_noalign(const u8 *p)
 {
-- 
1.6.0.4.994.g16bd3e


