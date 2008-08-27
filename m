Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYH0QGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYH0QGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYH0QGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:06:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:59494 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbYH0QGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=uQlH6vGn/6hzRvFAbYYX9nmMZ4sFBSHdyzoCo8qaT0phA6bf8KzQFDtTWmsYlUctde
         xnynUikyE+gxPYgzj0X2IHq3UxEfcgP/Y1k3FX1fZw5PwXVwuB1fAXbyLM+nnh20kivd
         lUzhYRHY9SCk0ueM1hmBMrA6nFj73vb8OxodU=
Subject: [PATCH] byteorder: use generic C version for value byteswapping
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 09:06:23 -0700
Message-Id: <1219853183.6069.50.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the new implementation of the byteorder helpers match the
old in how it degraded when an arch-defined version was not available:

1) swab()
	- look for arch defined
	- if not, use generic c version

2) swabp()
	- look for arch-defined
	- if not, deref pointer and use swab()

3) swabs()
	- look for arch defined
	- if not, use swabp

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
David, I hope this has covered the last of your objections...also note that
once each arch has moved over, __constant_{endian} will no longer be required.

 include/linux/swab.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/include/linux/swab.h b/include/linux/swab.h
index 270d5c2..bbed279 100644
--- a/include/linux/swab.h
+++ b/include/linux/swab.h
@@ -47,8 +47,6 @@ static inline __attribute_const__ __u16 ___swab16(__u16 val)
 {
 #ifdef __arch_swab16
 	return __arch_swab16(val);
-#elif defined(__arch_swab16p)
-	return __arch_swab16p(&val);
 #else
 	return __const_swab16(val);
 #endif
@@ -58,8 +56,6 @@ static inline __attribute_const__ __u32 ___swab32(__u32 val)
 {
 #ifdef __arch_swab32
 	return __arch_swab32(val);
-#elif defined(__arch_swab32p)
-	return __arch_swab32p(&val);
 #else
 	return __const_swab32(val);
 #endif
@@ -69,8 +65,6 @@ static inline __attribute_const__ __u64 ___swab64(__u64 val)
 {
 #ifdef __arch_swab64
 	return __arch_swab64(val);
-#elif defined(__arch_swab64p)
-	return __arch_swab64p(&val);
 #elif defined(__SWAB_64_THRU_32__)
 	__u32 h = val >> 32;
 	__u32 l = val & ((1ULL << 32) - 1);
@@ -84,8 +78,6 @@ static inline __attribute_const__ __u32 ___swahw32(__u32 val)
 {
 #ifdef __arch_swahw32
 	return __arch_swahw32(val);
-#elif defined(__arch_swahw32p)
-	return __arch_swahw32p(&val);
 #else
 	return __const_swahw32(val);
 #endif
@@ -95,8 +87,6 @@ static inline __attribute_const__ __u32 ___swahb32(__u32 val)
 {
 #ifdef __arch_swahb32
 	return __arch_swahb32(val);
-#elif defined(__arch_swahb32p)
-	return __arch_swahb32p(&val);
 #else
 	return __const_swahb32(val);
 #endif
-- 
1.6.0.366.gf9ffa8



