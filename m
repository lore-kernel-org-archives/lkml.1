Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbYJIIVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbYJIIVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 04:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbYJIIVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 04:21:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:3914 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbYJIIVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:21:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Czk1iGiZaxdZOE6880NvFq+aI+qQuG+v1sco20zEBUzbGtDqRRBX/Tt7lsDzNzrkMF
         LyV0Sp/kMfVkNwEYAwmE3Sl0Y5MrUri+mvNiz8DqYEuwF0J2E0Mc6fbdXtE4qgYxQEXJ
         AN+A0mVvBT/RivTYz7r8Qi/ZwZReoUVCd15JA=
Message-ID: <fbd277f20810090121m41e87a8eg9e6b7a1d4ec62776@mail.gmail.com>
Date: Thu, 9 Oct 2008 16:21:40 +0800
From: "bibo mao" <bibo.mao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [patch 1/1] combine two adjacent mtrr region with the same type
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to combine two adjacent mtrr region with the same type.

 kernel/cpu/mtrr/main.c          |   17 +++++++++++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

Signed-off-by: bibo mao <bibo.mao@gmail.com>

-------------------------------------------------------------------------------
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 6e212f3..c3adf83 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -305,7 +305,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 {
 	int i, j, replace, error;
 	mtrr_type ltype;
-	unsigned long lbase, lsize;
+	unsigned long lbase, lsize, newbase;

 	if (!mtrr_if)
 		return -ENXIO;
@@ -344,7 +344,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 	mutex_lock(&mtrr_mutex);
 	for (i = 0; i < num_var_ranges; ++i) {
 		mtrr_if->get(i, &lbase, &lsize, &ltype);
-		if (!lsize || base > lbase + lsize - 1 || base + size - 1 < lbase)
+		if (!lsize || base > lbase + lsize || base + size < lbase)
 			continue;
 		/*  At this point we know there is some kind of overlap/enclosure  */
 		if (base < lbase || base + size - 1 > lbase + lsize - 1) {
@@ -356,6 +356,19 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 				}
 				else if (types_compatible(type, ltype))
 					continue;
+			} else if ((base == lbase + lsize) || (lbase ==base + size)) {
+				if (type != ltype)
+					continue;
+				/* New region adjacent with an existing region  */
+				newbase = (base < lbase) ? base : lbase;
+				if (!mtrr_if->validate_add_page(newbase,lsize + size,type) &&
+				   mtrr_if->get_free_region(newbase, lsize + size, replace)>=0) {
+					base = newbase;
+					size += lsize;
+					replace = i;
+					continue;
+				} else
+					continue;
 			}
 			printk(KERN_WARNING
 			       "mtrr: 0x%lx000,0x%lx000 overlaps existing"
