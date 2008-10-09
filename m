Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYJIIRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYJIIRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 04:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbYJIIRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 04:17:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:36004 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbYJIIRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=jXwDA6Va1FPpJj0wNsOhn/HR3SmiP6pEXnMXTrUP2zVc/a+Su6YLqM7Jy5J2A45LUe
         igpvF/QilZvlV0IUbwyvdM10H/Ril7fT7D2YCoeaWzkfATD5S1QKE+B/A72LInqsaawb
         i7cMwWz4ex1q4/Ttgvh0PdKGd5S6tV+NnhfmU=
Message-ID: <fbd277f20810090117g7b916d2fia201b9184d41bd7d@mail.gmail.com>
Date: Thu, 9 Oct 2008 16:17:15 +0800
From: "bibo mao" <bibo.mao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [patch 0/1] remove existing enclosed mtrr region
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 This patch is remove enclosed mtrr region when adding new region.

 Signed-off-by: bibo mao <bibo.mao@gmail.com>

 thanks
 bibo,mao


 kernel/cpu/mtrr/main.c          |   35 +++++++++++++++++++++++++++++++----
 3 files changed, 31 insertions(+), 4 deletions(-)
---------------------------------------------------------------------------------------------------------------------

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 6a1e278..6e212f3 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -303,7 +303,7 @@ static void set_mtrr(unsigned int reg, unsigned long base,
 int mtrr_add_page(unsigned long base, unsigned long size,
 		  unsigned int type, bool increment)
 {
-	int i, replace, error;
+	int i, j, replace, error;
 	mtrr_type ltype;
 	unsigned long lbase, lsize;

@@ -351,7 +351,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 			if (base <= lbase && base + size - 1 >= lbase + lsize - 1) {
 				/*  New region encloses an existing region  */
 				if (type == ltype) {
-					replace = replace == -1 ? i : -2;
+					replace = i;
 					continue;
 				}
 				else if (types_compatible(type, ltype))
@@ -391,6 +391,20 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 				set_mtrr(replace, 0, 0, 0);
 				mtrr_usage_table[replace] = 0;
 			}
+
+			/* remove existing enclosed region */
+			for (j = 0; j < num_var_ranges; ++j) {
+				if (i == j)
+					continue;
+				mtrr_if->get(j, &lbase, &lsize, &ltype);
+				if (lsize && type == ltype && base <= lbase
+					 && base + size - 1 >= lbase + lsize - 1) {
+					/*  New region encloses an existing region  */
+					mtrr_usage_table[i] += mtrr_usage_table[j];
+					set_mtrr(j, 0, 0, 0);
+					mtrr_usage_table[j]=0;
+				}	
+			}
 		}
 	} else
 		printk(KERN_INFO "mtrr: no more MTRRs available\n");
