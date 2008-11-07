Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbYKGUj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbYKGUj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYKGUje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:39:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52179 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbYKGUjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:39:32 -0500
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com, npiggin@suse.de
Subject: [PATCH 1/4] don't call __vmalloc from other vmap internal functions
Date: Fri,  7 Nov 2008 20:35:51 -0200
Message-Id: <1226097354-7523-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1226097354-7523-1-git-send-email-glommer@redhat.com>
References: <1226097354-7523-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we do that, output of files like /proc/vmallocinfo
will show things like "vmalloc_32", "vmalloc_user", or
whomever the caller was as the caller. This info is not
as useful as the real caller of the allocation.

So, proposal is to call __vmalloc_node node directly, with
matching parameters to save the caller information

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 mm/vmalloc.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0365369..95856d1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1343,7 +1343,8 @@ void *vmalloc_user(unsigned long size)
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO, PAGE_KERNEL);
+	ret = __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+			     PAGE_KERNEL, -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
 		area->flags |= VM_USERMAP;
@@ -1388,7 +1389,8 @@ EXPORT_SYMBOL(vmalloc_node);
 
 void *vmalloc_exec(unsigned long size)
 {
-	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC);
+	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
+			      -1, __builtin_return_address(0));
 }
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
@@ -1408,7 +1410,8 @@ void *vmalloc_exec(unsigned long size)
  */
 void *vmalloc_32(unsigned long size)
 {
-	return __vmalloc(size, GFP_VMALLOC32, PAGE_KERNEL);
+	return __vmalloc_node(size, GFP_VMALLOC32, PAGE_KERNEL,
+			      -1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_32);
 
@@ -1424,7 +1427,8 @@ void *vmalloc_32_user(unsigned long size)
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc(size, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL);
+	ret = __vmalloc_node(size, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL,
+			     -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
 		area->flags |= VM_USERMAP;
-- 
1.5.6.5

