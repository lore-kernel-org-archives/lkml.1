Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbYI0HbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbYI0HbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 03:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYI0Har
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 03:30:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:60541 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYI0Haq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 03:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N/aTVCJ+3BQw6SwV8dPbw5KW86cGQVzPECPmGCfjbc/uPrFIbM9GqOyUZJJgP/N6AV
         mCrrgwLKcd79R9FqUta+I7CT2LvXM979DZAQreg/wyzGbq3ZIE4QfvHjyCJAy+9lCnGp
         YdBRTgid7GHdSRb8YDi4RejeMl+36diuA6rbw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/3] x86: don't need to go to chunksize to 4G
Date: Sat, 27 Sep 2008 00:30:07 -0700
Message-Id: <1222500608-14855-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1222500608-14855-1-git-send-email-yhlu.kernel@gmail.com>
References: <1222500608-14855-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change back chunksize max to 2g
   otherwise will get strange layout in 2G ram system like
     0 - 4g WB, 2040M - 2048M UC, 2048M -  4G NC
   instead of
     0 - 2g WB, 2040M - 2048M UC

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/mtrr/main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -1162,10 +1162,10 @@ struct mtrr_cleanup_result {
 
 /*
  * gran_size: 1M, 2M, ..., 2G
- * chunk size: gran_size, ..., 4G
- * so we need (2+13)*6
+ * chunk size: gran_size, ..., 2G
+ * so we need (1+12)*6
  */
-#define NUM_RESULT	90
+#define NUM_RESULT	78
 #define PSHIFT		(PAGE_SHIFT - 10)
 
 static struct mtrr_cleanup_result __initdata result[NUM_RESULT];
@@ -1282,7 +1282,7 @@ static int __init mtrr_cleanup(unsigned
 	memset(min_loss_pfn, 0xff, sizeof(min_loss_pfn));
 	memset(result, 0, sizeof(result));
 	for (gran_size = (1ULL<<20); gran_size < (1ULL<<32); gran_size <<= 1) {
-		for (chunk_size = gran_size; chunk_size < (1ULL<<33);
+		for (chunk_size = gran_size; chunk_size < (1ULL<<32);
 		     chunk_size <<= 1) {
 			int num_reg;
 
