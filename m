Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYD2FY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYD2FY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 01:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYD2FYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:24:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:25655 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYD2FYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rQ3lPTL1M9FtMoto2tIsFN3wxKeqLTlsLgt308/cR69QgvwRjLyjQle1+tFoRMkWqKzaloRSzG+GF9SGjscqcYE13hHkHkN/VPRCD4zxbCI8tOU9/6oi/otbuXO6bXDCS/NAoE/HUdt7h1hvJ1XHkg+tpmVCPAp7JngUKQs5euw=
Subject: [PATCH] lib: bitrev.c micro-optimization
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 22:24:55 -0700
Message-Id: <1209446696.24729.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86_32 before:
00000000 <bitrev32>:
   0:	55                   	push   %ebp
   1:	89 c1                	mov    %eax,%ecx
   3:	89 e5                	mov    %esp,%ebp
   5:	0f b6 cd             	movzbl %ch,%ecx
   8:	53                   	push   %ebx
   9:	89 c3                	mov    %eax,%ebx
   b:	0f b6 c0             	movzbl %al,%eax
   e:	0f b6 90 00 00 00 00 	movzbl 0x0(%eax),%edx
  15:	c1 eb 10             	shr    $0x10,%ebx
  18:	66 0f b6 81 00 00 00 	movzbw 0x0(%ecx),%ax
  1f:	00
  20:	c1 e2 08             	shl    $0x8,%edx
  23:	09 d0                	or     %edx,%eax
  25:	0f b6 d3             	movzbl %bl,%edx
  28:	0f b6 8a 00 00 00 00 	movzbl 0x0(%edx),%ecx
  2f:	0f b6 d7             	movzbl %bh,%edx
  32:	66 0f b6 92 00 00 00 	movzbw 0x0(%edx),%dx
  39:	00
  3a:	c1 e0 10             	shl    $0x10,%eax
  3d:	5b                   	pop    %ebx
  3e:	5d                   	pop    %ebp
  3f:	c1 e1 08             	shl    $0x8,%ecx
  42:	09 ca                	or     %ecx,%edx
  44:	0f b7 d2             	movzwl %dx,%edx
  47:	09 d0                	or     %edx,%eax
  49:	c3                   	ret

X86_32 after:
00000000 <bitrev32>:
   0:   55                      push   %ebp
   1:   89 e5                   mov    %esp,%ebp
   3:   83 ec 08                sub    $0x8,%esp
   6:   89 45 f8                mov    %eax,-0x8(%ebp)
   9:   0f b6 45 f8             movzbl -0x8(%ebp),%eax
   d:   8a 80 00 00 00 00       mov    0x0(%eax),%al
  13:   88 45 ff                mov    %al,-0x1(%ebp)
  16:   0f b6 45 f9             movzbl -0x7(%ebp),%eax
  1a:   8a 80 00 00 00 00       mov    0x0(%eax),%al
  20:   88 45 fe                mov    %al,-0x2(%ebp)
  23:   0f b6 45 fa             movzbl -0x6(%ebp),%eax
  27:   8a 80 00 00 00 00       mov    0x0(%eax),%al
  2d:   88 45 fd                mov    %al,-0x3(%ebp)
  30:   0f b6 45 fb             movzbl -0x5(%ebp),%eax
  34:   8a 80 00 00 00 00       mov    0x0(%eax),%al
  3a:   88 45 fc                mov    %al,-0x4(%ebp)
  3d:   8b 45 fc                mov    -0x4(%ebp),%eax
  40:   c9                      leave
  41:   c3                      ret

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/bitrev.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/lib/bitrev.c b/lib/bitrev.c
index 989aff7..8367b91 100644
--- a/lib/bitrev.c
+++ b/lib/bitrev.c
@@ -42,17 +42,20 @@ const u8 byte_rev_table[256] = {
 };
 EXPORT_SYMBOL_GPL(byte_rev_table);
 
-static __always_inline u16 bitrev16(u16 x)
-{
-	return (bitrev8(x & 0xff) << 8) | bitrev8(x >> 8);
-}
-
 /**
  * bitrev32 - reverse the order of bits in a u32 value
  * @x: value to be bit-reversed
  */
 u32 bitrev32(u32 x)
 {
-	return (bitrev16(x & 0xffff) << 16) | bitrev16(x >> 16);
+	u32 y;
+	u8 *yp = (u8 *)&y + 3;
+	u8 *xp = (u8 *)&x;
+
+	*yp-- = byte_rev_table[*xp++];
+	*yp-- = byte_rev_table[*xp++];
+	*yp-- = byte_rev_table[*xp++];
+	*yp-- = byte_rev_table[*xp++];
+	return y;
 }
 EXPORT_SYMBOL(bitrev32);
-- 
1.5.5.1.270.g89765



