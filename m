Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYIBPzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYIBPzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYIBPz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:55:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:48582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYIBPz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=cXbqEts5Blhf3/WUs2AFrvw9dSc9R85hZ6ZBxJU0AkcROvHkn1AD2+P0HdfhG0kvht
         2cr5d+ooL0YuMstX1Ec5hj/6cbrn/fFy/8CKPGOlV7BqvqVy+4DRuP7HxHCpXWib/Pts
         0jtI4dmHohOC1dMcuv/JbEiGiBskXKjhyzgB4=
Message-ID: <48BD61E9.9070004@panasas.com>
Date: Tue, 02 Sep 2008 18:55:21 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5 ver2] rt2x00: Compiler warning unmasked by fix of BUILD_BUG_ON
References: <48BBE77D.7070007@panasas.com> <48BBEC6C.1050301@panasas.com>
In-Reply-To: <48BBEC6C.1050301@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A "Set" to a sign-bit in an "&" operation causes a compiler warning.
Make calculations unsigned.

[ The warning was masked by the old definition of BUILD_BUG_ON() ]

Also remove __builtin_constant_p from FIELD_CHECK since BUILD_BUG_ON
no longer permits non-const values.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/wireless/rt2x00/rt2x00reg.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 7e88ce5..2ea7866 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -136,7 +136,7 @@ struct rt2x00_field32 {
  */
 #define is_power_of_two(x)	( !((x) & ((x)-1)) )
 #define low_bit_mask(x)		( ((x)-1) & ~(x) )
-#define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
+#define is_valid_mask(x)	is_power_of_two(1LU + (x) + low_bit_mask(x))
 
 /*
  * Macro's to find first set bit in a variable.
@@ -173,8 +173,7 @@ struct rt2x00_field32 {
  * does not exceed the given typelimit.
  */
 #define FIELD_CHECK(__mask, __type)			\
-	BUILD_BUG_ON(!__builtin_constant_p(__mask) ||	\
-		     !(__mask) ||			\
+	BUILD_BUG_ON(!(__mask) ||			\
 		     !is_valid_mask(__mask) ||		\
 		     (__mask) != (__type)(__mask))	\
 
-- 
1.5.6.rc1.5.gadf6


