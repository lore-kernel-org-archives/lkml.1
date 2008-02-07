Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYBGHyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYBGHyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYBGHyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:54:39 -0500
Received: from neuf-infra-smtp-out-sp604006av.neufgp.fr ([84.96.92.121]:34888
	"EHLO neuf-infra-smtp-out-sp604006av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706AbYBGHyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:54:39 -0500
Message-ID: <47AAB935.8040507@cosmosbay.com>
Date: Thu, 07 Feb 2008 08:54:29 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Avoid divides in BITS_TO_LONGS
Content-Type: multipart/mixed;
 boundary="------------070607010908030000030701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070607010908030000030701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

BITS_PER_LONG is a signed value (32 or 64)

DIV_ROUND_UP(nr, BITS_PER_LONG) performs signed arithmetic if "nr" is signed too.

Converting BITS_TO_LONGS(nr) to DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
makes sure compiler can perform a right shift, even if "nr" is a signed value, 
instead of an expensive integer divide.

Applying this patch saves 141 bytes on x86 when CONFIG_CC_OPTIMIZE_FOR_SIZE=y
and speedup bitmap operations.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--------------070607010908030000030701
Content-Type: text/plain;
 name="BITS_TO_LONGS.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="BITS_TO_LONGS.patch"

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 69c1edb..be5c27c 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -6,8 +6,8 @@
 #define BIT(nr)			(1UL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_LONG)
 #define BITS_PER_BYTE		8
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 #endif
 
 /*

--------------070607010908030000030701--
