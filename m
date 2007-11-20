Return-Path: <linux-kernel-owner+w=401wt.eu-S1763283AbXKTScf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763283AbXKTScf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761682AbXKTS07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51926 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761658AbXKTS05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:57 -0500
Date: Tue, 20 Nov 2007 10:24:30 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benny Halevy <bhalevy@fs1.bhalevy.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 17/29] libcrc32c: keep intermediate crc state in cpu order
Message-ID: <20071120182430.GS28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libcrc32c-keep-intermediate-crc-state-in-cpu-order.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

It's upstream changeset ef19454bd437b2ba14c9cda1de85debd9f383484.

[LIB] crc32c: Keep intermediate crc state in cpu order

crypto/crc32.c:chksum_final() is computing the digest as
*(__le32 *)out = ~cpu_to_le32(mctx->crc);
so the low-level crc32c_le routines should just keep
the crc in cpu order, otherwise it is getting swabbed
one too many times on big-endian machines.

Signed-off-by: Benny Halevy <bhalevy@fs1.bhalevy.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/libcrc32c.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -33,7 +33,6 @@
 #include <linux/crc32c.h>
 #include <linux/compiler.h>
 #include <linux/module.h>
-#include <asm/byteorder.h>
 
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
 MODULE_DESCRIPTION("CRC32c (Castagnoli) calculations");
@@ -161,15 +160,13 @@ static const u32 crc32c_table[256] = {
  */
 
 u32 __attribute_pure__
-crc32c_le(u32 seed, unsigned char const *data, size_t length)
+crc32c_le(u32 crc, unsigned char const *data, size_t length)
 {
-	u32 crc = __cpu_to_le32(seed);
-	
 	while (length--)
 		crc =
 		    crc32c_table[(crc ^ *data++) & 0xFFL] ^ (crc >> 8);
 
-	return __le32_to_cpu(crc);
+	return crc;
 }
 
 #endif	/* CRC_LE_BITS == 8 */

-- 
