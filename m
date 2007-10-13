Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbXJMOmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbXJMOmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbXJMOmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:05 -0400
Received: from 1wt.eu ([62.212.114.60]:2903 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761466AbXJMOmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:01 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143424.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:24 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 02/35] AVR32: Fix atomic_add_unless() and atomic_sub_unless()
Content-Disposition: inline; filename=0010-AVR32-Fix-atomic_add_unless-and-atomic_sub_unless.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These functions depend on "result" being initalized to 0, but "result"
is not included as an input constraint to the inline assembly block
following its initialization, only as an output constraint. Thus gcc
thinks it doesn't need to initialize it, so result ends up undefined
if the "unless" condition is true.

This fixes an oops in sunrpc where the faulty atomics caused
rpciod_up() to not start the workqueue as it should.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/asm-avr32/atomic.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: 2.6/include/asm-avr32/atomic.h
===================================================================
--- 2.6.orig/include/asm-avr32/atomic.h
+++ 2.6/include/asm-avr32/atomic.h
@@ -101,7 +101,7 @@ static inline int atomic_sub_unless(atom
 		"	mov	%1, 1
"
 		"1:"
 		: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-		: "m"(v->counter), "rKs21"(a), "rKs21"(u)
+		: "m"(v->counter), "rKs21"(a), "rKs21"(u), "1"(result)
 		: "cc", "memory");
 
 	return result;
@@ -137,7 +137,7 @@ static inline int atomic_add_unless(atom
 			"	mov	%1, 1
"
 			"1:"
 			: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-			: "m"(v->counter), "r"(a), "ir"(u)
+			: "m"(v->counter), "r"(a), "ir"(u), "1"(result)
 			: "cc", "memory");
 	}
 

-- 
