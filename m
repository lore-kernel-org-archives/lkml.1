Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbZKYTSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbZKYTSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759080AbZKYTSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:18:17 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:58246 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbZKYTSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:18:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=W69DNdmT9kP/HlW7DNJ8b/BcQIEJWdz4LZclvfdLHNSCrr2K5Ys5Cc1Y2/M5HCVFh2
         JPLKpip6wRSRzQcJTB8pwXQOEIplrzvQT+Gzc753FxBLMWK54cRacHWcJ2GotObfhBeF
         IIW7/IUzTwR4PPQsHiCgW1gmAMtIV8EGztsqE=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: loadsegment() optimization
Date: Wed, 25 Nov 2009 14:18:26 -0500
Message-Id: <1259176706-5908-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zero the input register in the exception handler instead of using
an extra register to pass in a zero value.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/system.h |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index f08f973..18ac1ec 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -158,18 +158,19 @@ extern void native_load_gs_index(unsigned);
  * segment if something goes wrong..
  */
 #define loadsegment(seg, value)			\
+do {						\
+	unsigned short __val = value;		\
 	asm volatile("\n"			\
 		     "1:\t"			\
 		     "movl %k0,%%" #seg "\n"	\
-		     "2:\n"			\
 		     ".section .fixup,\"ax\"\n"	\
-		     "3:\t"			\
-		     "movl %k1, %%" #seg "\n\t"	\
-		     "jmp 2b\n"			\
+		     "2:\t"			\
+		     "xorl %k0,%k0\n\t"		\
+		     "jmp 1b\n"			\
 		     ".previous\n"		\
-		     _ASM_EXTABLE(1b,3b)	\
-		     : :"r" (value), "r" (0) : "memory")
-
+		     _ASM_EXTABLE(1b,2b)	\
+		     : "+r" (__val) : : "memory"); \
+} while (0)
 
 /*
  * Save a segment register away
-- 
1.6.5.2

