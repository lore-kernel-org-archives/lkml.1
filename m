Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbYD2PvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbYD2PvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbYD2Puh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:50:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758136AbYD2Pug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:50:36 -0400
Date: Tue, 29 Apr 2008 08:50:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib: bitrev.c micro-optimization
In-Reply-To: <1209446696.24729.18.camel@brick>
Message-ID: <alpine.LFD.1.10.0804290839220.3119@woody.linux-foundation.org>
References: <1209446696.24729.18.camel@brick>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Not very good. Why do it in memory, when doing it in a register is much 
clearer?

This generates one byte longer code for me, but avoids the partial memory 
stalls and looks more obvious. It is also portable, unlike your version 
(you need to use a union to avoid aliasing issues - admittedly we disable 
the gcc alias code anyway because of other kernel code, but still).

		Linus

---
 lib/bitrev.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/lib/bitrev.c b/lib/bitrev.c
index 989aff7..e0cb44e 100644
--- a/lib/bitrev.c
+++ b/lib/bitrev.c
@@ -42,17 +42,15 @@ const u8 byte_rev_table[256] = {
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
+	return  (bitrev8(x) << 24) |
+		(bitrev8(x >> 8) << 16) |
+		(bitrev8(x >> 16) << 8) |
+		(bitrev8(x >> 24));
 }
 EXPORT_SYMBOL(bitrev32);
