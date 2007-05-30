Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbXE3Qky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbXE3Qky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXE3Qkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:40:47 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:5870 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbXE3Qkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=r8gRtqOjjPh4BdsmDvgqtOkYF/Tn8DTPTo35lpkVbS3Nruv3lwvYYHjb3jExL7u6OzfNcy2bfkpUIp+Kw19HR6MVbPFy3eyWsuKP7pHcPskZoImllDOjQ2tKiDdCgz8RGKX/ZNG5DBwuPtVykQlrra0iaJxUq8mRg80D/JDdoRg=
Date: Thu, 31 May 2007 01:33:06 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] fault-injection: add min-order parameter to fail_page_alloc
Message-ID: <20070530163306.GA4282@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Limiting smaller allocation failures by fault injection helps to
find real possible bugs. Because higher order allocations are likely to
fail and zero-order allocations are not likely to fail.

This patch adds min-order parameter to fail_page_alloc.
It specifies the minimum page allocation order to be injected failures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 Documentation/fault-injection/fault-injection.txt |    5 +++++
 mm/page_alloc.c                                   |   12 +++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

Index: 2.6-mm/mm/page_alloc.c
===================================================================
--- 2.6-mm.orig/mm/page_alloc.c
+++ 2.6-mm/mm/page_alloc.c
@@ -1168,11 +1168,13 @@ static struct fail_page_alloc_attr {
 
 	u32 ignore_gfp_highmem;
 	u32 ignore_gfp_wait;
+	u32 min_order;
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
 	struct dentry *ignore_gfp_highmem_file;
 	struct dentry *ignore_gfp_wait_file;
+	struct dentry *min_order_file;
 
 #endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
 
@@ -1180,6 +1182,7 @@ static struct fail_page_alloc_attr {
 	.attr = FAULT_ATTR_INITIALIZER,
 	.ignore_gfp_wait = 1,
 	.ignore_gfp_highmem = 1,
+	.min_order = 1,
 };
 
 static int __init setup_fail_page_alloc(char *str)
@@ -1190,6 +1193,8 @@ __setup("fail_page_alloc=", setup_fail_p
 
 static int should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
+	if (order < fail_page_alloc.min_order)
+		return 0;
 	if (gfp_mask & __GFP_NOFAIL)
 		return 0;
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
@@ -1221,12 +1226,17 @@ static int __init fail_page_alloc_debugf
 	fail_page_alloc.ignore_gfp_highmem_file =
 		debugfs_create_bool("ignore-gfp-highmem", mode, dir,
 				      &fail_page_alloc.ignore_gfp_highmem);
+	fail_page_alloc.min_order_file =
+		debugfs_create_u32("min-order", mode, dir,
+				   &fail_page_alloc.min_order);
 
 	if (!fail_page_alloc.ignore_gfp_wait_file ||
-			!fail_page_alloc.ignore_gfp_highmem_file) {
+            !fail_page_alloc.ignore_gfp_highmem_file ||
+            !fail_page_alloc.min_order_file) {
 		err = -ENOMEM;
 		debugfs_remove(fail_page_alloc.ignore_gfp_wait_file);
 		debugfs_remove(fail_page_alloc.ignore_gfp_highmem_file);
+		debugfs_remove(fail_page_alloc.min_order_file);
 		cleanup_fault_attr_dentries(&fail_page_alloc.attr);
 	}
 
Index: 2.6-mm/Documentation/fault-injection/fault-injection.txt
===================================================================
--- 2.6-mm.orig/Documentation/fault-injection/fault-injection.txt
+++ 2.6-mm/Documentation/fault-injection/fault-injection.txt
@@ -103,6 +103,11 @@ configuration of fault-injection capabil
 	default is 'N', setting it to 'Y' will inject failures
 	only into non-sleep allocations (GFP_ATOMIC allocations).
 
+- /debug/fail_page_alloc/min-order:
+
+	specifies the minimum page allocation order to be injected
+	failures.
+
 o Boot option
 
 In order to inject faults while debugfs is not available (early boot time),
