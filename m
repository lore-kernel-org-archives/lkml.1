Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbYI3Bza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbYI3Bza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 21:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYI3Byz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 21:54:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:57917 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbYI3Byx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 21:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=daHuIop2QpcD8Mm7pOSIFCL2JobqDRpacqnYCusoDSsQhXQijBhhNlCYvHMmIZ36yK
         bplbXlRD+LdMlmqV7REJwW4WQuvwKnaBidbPt+x7Widyo2042HIWqEIq2eermom4c5zT
         +E0BT7GAWwTbziZCkeJtjV/yLZOng+59Asoxw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Date: Mon, 29 Sep 2008 18:54:12 -0700
Message-Id: <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

one have gran < 1M

reg00: base=0xd8000000 (3456MB), size= 128MB: uncachable, count=1
reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
reg05: base=0xd7f80000 (3455MB), size= 512KB: uncachable, count=1

will get

Found optimal setting for mtrr clean up
gran_size: 512K         chunk_size: 2M  num_reg: 7      lose RAM: 0G
range0: 0000000000000000 - 00000000d8000000
Setting variable MTRR 0, base: 0GB, range: 2GB, type WB
Setting variable MTRR 1, base: 2GB, range: 1GB, type WB
Setting variable MTRR 2, base: 3GB, range: 256MB, type WB
Setting variable MTRR 3, base: 3328MB, range: 128MB, type WB
hole: 00000000d7f00000 - 00000000d7f80000
Setting variable MTRR 4, base: 3455MB, range: 512KB, type UC
rangeX: 0000000100000000 - 0000000128000000
Setting variable MTRR 5, base: 4GB, range: 512MB, type WB
Setting variable MTRR 6, base: 4608MB, range: 128MB, type WB

so start from 64k instead of 1M

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -1197,11 +1197,11 @@ struct mtrr_cleanup_result {
 };
 
 /*
- * gran_size: 1M, 2M, ..., 2G
+ * gran_size: 64K, 128K, 256K, 512K, 1M, 2M, ..., 2G
  * chunk size: gran_size, ..., 2G
- * so we need (1+12)*6
+ * so we need (1+16)*8
  */
-#define NUM_RESULT	78
+#define NUM_RESULT	136
 #define PSHIFT		(PAGE_SHIFT - 10)
 
 static struct mtrr_cleanup_result __initdata result[NUM_RESULT];
@@ -1322,7 +1322,7 @@ static int __init mtrr_cleanup(unsigned
 	i = 0;
 	memset(min_loss_pfn, 0xff, sizeof(min_loss_pfn));
 	memset(result, 0, sizeof(result));
-	for (gran_size = (1ULL<<20); gran_size < (1ULL<<32); gran_size <<= 1) {
+	for (gran_size = (1ULL<<16); gran_size < (1ULL<<32); gran_size <<= 1) {
 		char gran_factor;
 		unsigned long gran_base;
 
